#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# by buginote from http://1024.me
# version v0.1 build20180403
# Debian8 64bit

clear
echo "+-----------------------------------------------------------------------+"
echo "|                  Warning!!!   Warning!!!   Warning!!!                 |"
echo "+-----------------------------------------------------------------------+"
echo "|                  New server run this script for once!                 |"
echo "+-----------------------------------------------------------------------+"

# ----------- 检测是否是root账号 -----------
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script"
    exit 1
fi

# ----------- 配置信息 -----------
echo "Enter New User Name & Password & SSH Port, Be Sure To REMEMBER!! "
# 新用户的用户名
read -p "Add a new user name: " COMMON_USER
# 新用户的密码,不能少于8位
read -p "Add a new user password: " COMMON_USER_PWD
while [${#COMMON_USER_PWD} -lt 8]
do
    read -p "Short length password not safe,enter more than 8 characters PASSORDD:" COMMON_USER_PWD
done
#SSH端口
read -p "New SSH port: " SSH_PORT
WEB_PORT=80
read -p "New web port (Enter for default 80): " WEB_PORT

# ----------- 升级系统软件及下载基础工具 -----------
echo -e "\e[1;36m Update system ... \e[0m"
apt-get update && apt-get upgrade -y
apt-get -y install wget chkconfig vim screen

# ----------- 账户安全设置 -----------
echo -e "\e[1;36m 正在进行账户安全设置 ... \e[0m"

# 禁用系统不需要的用户
passwd -l xfs
passwd -l news
passwd -l nscd
passwd -l dbus
passwd -l vcsa
passwd -l games
passwd -l nobody
passwd -l avahi
passwd -l haldaemon
passwd -l gopher
passwd -l ftp
passwd -l mailnull
passwd -l pcap
passwd -l mail
passwd -l shutdown
passwd -l halt
passwd -l uucp
passwd -l operator
passwd -l sync
passwd -l adm
passwd -l lp
passwd -l pppusers
passwd -l dip

# 删除系统不需要的用户组
#修改之前先备份
cp /etc/group /etc/groupbak
groupdel adm
groupdel lp
groupdel news
groupdel uucp
groupdel games
groupdel dip
groupdel pppusers

# 限制su命令
#sed -i "s/#auth  required  pam_wheel.so use_uid/auth  required  pam_wheel.so use_uid group=wheel/" /etc/pam.d/su
#usermod -G10 $COMMON_USER
#这时，仅isd组的用户可以su作为root。此后，如果您希望用户admin能够su作为root，可以运行如下命令：
# usermod -G10 admin  #注isd组的id号不一定是10，所以请谨慎执行。

# 禁止Ctrl+Alt+Delete重启命令
#sed -i -e "s/\(^ca\:\:ctrlaltdel.*$\)/#\1/" /etc/inittab

# 提醒经常换密码
#sed -i 's/^PASS_MAX_DAYS.*$/PASS_MAX_DAYS 90/g' /etc/login.defs
#sed -i 's/^PASS_WARN_AGE.*$/PASS_WARN_AGE 10/g' /etc/login.defs

# 限制重要命令的权限
chmod 700 /bin/ping
chmod 700 /usr/bin/finger
chmod 700 /usr/bin/who
chmod 700 /usr/bin/w
chmod 700 /usr/bin/locate
chmod 700 /usr/bin/whereis
chmod 700 /sbin/ifconfig
chmod 700 /usr/bin/pico
chmod 700 /bin/vi
chmod 700 /usr/bin/which
chmod 700 /usr/bin/gcc
chmod 700 /usr/bin/make
chmod 700 /bin/rpm

# 历史安全
chattr +a /root/.bash_history
chattr +i /root/.bash_history

# ----------- SSH安全配置 -----------
echo -e "\e[1;36m 进行SSH安全配置 ... \e[0m"

# 先备份
datename=$(date +%Y%m%d) 
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak.$datename

# 改端口
sed -i "s/#Port 22/Port $SSH_PORT/" /etc/ssh/sshd_config
sed -i "s/Port 22/Port $SSH_PORT/" /etc/ssh/sshd_config

# 不允许root用户直接登录
sed -i "s/PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
# 不允许空密码登录
sed -i "s/#PermitEmptyPasswords no/PermitEmptyPasswords no/g" /etc/ssh/sshd_config
sed -i "s/PermitEmptyPasswords yes/PermitEmptyPasswords no/g" /etc/ssh/sshd_config

# ----------- 关闭系统中不需要的服务和端口 慎用,除非对现有所有服务一清二楚  -----------
# echo -e "\e[1;36m 关闭系统中不需要的服务和端口 ... \e[0m"
# for serv in `ls /etc/rc3.d/S*`
# do
#     CURSRV=`echo $serv | cut -c 15-`
#     case $CURSRV in
#     acpid | anacron | cpuspeed | crond | iptables | irqbalance | microcode_ctl | mysqld | network | nginx | php-fpm | random | sendmail | sshd | syslog | fail2ban )
#         #这个启动的系统服务根据具体的应用情况设置，其中network、sshd、syslog是三项必须要启动的系统服务！
#         echo "$CURSRV is Base services, Skip!"
#         ;;
#     *)
#         echo "change $CURSRV to off"
#         chkconfig --level 235 $CURSRV off
#         service $CURSRV stop
#         ;;
#     esac
# done

# ----------- 防止攻击 -----------
echo -e "\e[1;36m 正在进行防止攻击设置 ... \e[0m"

# 阻止ping
# 加下面的一行命令到/etc/rc.d/rc.local，以使每次启动后自动运行
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all

# 防止IP欺骗攻击
echo "order bind，hosts
multi off
nospoof on" >> /etc/host.conf

# 防止DoS攻击
echo "# 禁止调试文件
* hard core 0
# 限制内存使用为50MB
* hard rss 50000
* hard nproc 50" >> /etc/security/limits.conf

# ----------- 防火墙设置 -----------
echo -e "\e[1;36m 防火墙设置 ... \e[0m"
# 编写crontab任务，每5分钟关闭一次iptalbes脚本，防止将SSH客户端锁在外面
crontab -l > tmpcrontab
echo "*/5 * * * * root /etc/init.d/iptables stop" >> tmpcrontab
crontab tmpcrontab
rm -f tmpcrontab
# 使用iptables防火墙只打开指定的端口
iptables -F INPUT
iptables -P INPUT DROP
# 打开80端口和SSH端口
iptables -A INPUT -p tcp -m multiport --dport ${WEB_PORT},${SSH_PORT} -j ACCEPT
# 打开本地访问
iptables -I INPUT 2 -i lo -p all -j ACCEPT
# 打开服务器对外的DNS端口
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
# 123为ntpdate更新时间的端口
iptables -A INPUT -p udp -m multiport --sport 53,123 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p udp --sport 53 -j ACCEPT
# 打开服务器内部访问80端口
iptables -A INPUT -p tcp -m multiport --sport 21,80,443,8080 -j ACCEPT
# 保存规则并重启iptables
/etc/init.d/iptables save
/etc/init.d/iptables restart


cat << EOF
+--------------------------------------------------------------+
    配置完成，谢谢！
    如果防火墙没有问题，请在定时任务中删除*/5 * * * * root /etc/init.d/iptables stop
    然后使用reboot重新启动计算机！
+--------------------------------------------------------------+
EOF

# 参考
# Linux服务器安全初始化Shell脚本 http://os.51cto.com/art/201107/273839.htm
# Linux初始安装之后配置脚本 http://www.javatang.com/archives/2012/09/17/2532761.html
# CentOS 6 的安全配置（CentOS Linux服务器安全设置）http://www.jb51.net/os/RedHat/65039.html
# CentOS Linux服务器安全设置 http://blog.51cto.com/cyr520/828293
# Linux操作系统安全配置步骤 http://www.jb51.net/os/RedHat/1227.html