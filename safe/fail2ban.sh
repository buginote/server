#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install lnmp"
    exit 1
fi

# Get_Dist_Name
if grep -Eqi "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
    DISTRO='CentOS'
    PM='yum'
elif grep -Eqi "Red Hat Enterprise Linux Server" /etc/issue || grep -Eq "Red Hat Enterprise Linux Server" /etc/*-release; then
    DISTRO='RHEL'
    PM='yum'
elif grep -Eqi "Aliyun" /etc/issue || grep -Eq "Aliyun" /etc/*-release; then
    DISTRO='Aliyun'
    PM='yum'
elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release; then
    DISTRO='Fedora'
    PM='yum'
elif grep -Eqi "Amazon Linux" /etc/issue || grep -Eq "Amazon Linux" /etc/*-release; then
    DISTRO='Amazon'
    PM='yum'
elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
    DISTRO='Debian'
    PM='apt'
elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
    DISTRO='Ubuntu'
    PM='apt'
elif grep -Eqi "Raspbian" /etc/issue || grep -Eq "Raspbian" /etc/*-release; then
    DISTRO='Raspbian'
    PM='apt'
elif grep -Eqi "Deepin" /etc/issue || grep -Eq "Deepin" /etc/*-release; then
    DISTRO='Deepin'
    PM='apt'
elif grep -Eqi "Mint" /etc/issue || grep -Eq "Mint" /etc/*-release; then
    DISTRO='Mint'
    PM='apt'
elif grep -Eqi "Kali" /etc/issue || grep -Eq "Kali" /etc/*-release; then
    DISTRO='Kali'
    PM='apt'
else
    DISTRO='unknow'
fi

# Press_Start
echo ""
Echo_Green "Press any key to start...or Press Ctrl+c to cancel"
OLDCONFIG=`stty -g`
stty -icanon -echo min 1 time 0
dd count=1 2>/dev/null
stty ${OLDCONFIG}


if [ "${PM}" = "yum" ]; then
    yum install python iptables rsyslog -y
    service rsyslog restart
    \cp /var/log/secure /var/log/secure.$(date +"%Y%m%d%H%M%S")
    cat /dev/null > /var/log/secure
elif [ "${PM}" = "apt" ]; then
    apt-get update
    apt-get install python iptables rsyslog -y
    /etc/init.d/rsyslog restart
    \cp /var/log/secure /var/log/secure.$(date +"%Y%m%d%H%M%S")
    cat /dev/null > /var/log/auth.log
fi

echo "Downloading..."
wget -c --progress=bar:force --prefer-family=IPv4 --no-check-certificate https://github.com/fail2ban/fail2ban/archive/0.10.3.1.tar.gz -O fail2ban-0.10.3.1.tar.gz
tar zxf fail2ban-0.10.3.1.tar.gz && cd fail2ban-0.10.3.1
echo "Installing..."
python setup.py install

echo "Copy configure file..."
\cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
cat >>/etc/fail2ban/jail.local<<EOF
[sshd]
enabled  = true
port     = ssh
filter   = sshd
action   = iptables[name=SSH, port=ssh, protocol=tcp]
#mail-whois[name=SSH, dest=yourmail@mail.com]
logpath  = /var/log/auth.log
maxretry = 3
bantime  = 604800
EOF

echo "Copy init files..."
if [ ! -d /var/run/fail2ban ];then
    mkdir /var/run/fail2ban
fi
if [ `/sbin/iptables -h|grep -c "\-w"` -eq 0 ]; then
    sed -i 's/lockingopt =.*/lockingopt =/g' /etc/fail2ban/action.d/iptables-common.conf
fi
if [ "${PM}" = "yum" ]; then
    sed -i 's#logpath  = /var/log/auth.log#logpath  = /var/log/secure#g' /etc/fail2ban/jail.local
    \cp files/redhat-initd /etc/init.d/fail2ban
elif [ "${PM}" = "apt" ]; then
    ln -sf /usr/local/bin/fail2ban-client /usr/bin/fail2ban-client
    \cp files/debian-initd /etc/init.d/fail2ban
fi
chmod +x /etc/init.d/fail2ban
cd ..
rm -rf fail2ban-0.10.3.1

# StartUp fail2ban
echo "Add fail2ban service at system startup..."
if [ "$PM" = "yum" ]; then
    chkconfig --add fail2ban
    chkconfig fail2ban on
elif [ "$PM" = "apt" ]; then
    update-rc.d -f fail2ban defaults
fi


echo "Start fail2ban..."
/etc/init.d/fail2ban start