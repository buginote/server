#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# by buginote from http://1024.me
# version v0.1 build20180420
# Debian8 64bit

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
SKYBLUE='\033[0;36m'
PLAIN='\033[0m'

# ------- 检测是否是root账号 -------
if [ $(id -u) != "0" ]; then
    echo -e "${RED}Error:${PLAIN} You must be root to run this script"
    exit 1
fi

# ------------ 配置信息 -----------
echo "Enter New User Name & Password, Be Sure To REMEMBER them!! "
# 新用户的用户名
read -p "Add a new user name: " COMMON_USER
# 新用户的密码,不能少于8位
read -p "Add a new user password: " COMMON_USER_PWD
# 密码位数不能小于8位
while [ ${#COMMON_USER_PWD} -le 8 ]
do
    read -p "Need more than 8 characters passowrd:" COMMON_USER_PWD
done
SUDOUSER='no'
read -p "Give new user SUDO permission? (Enter for no): " SUDOUSER

# ------------ 开始添加及设置 -----------
# 创建一个普通新用户,并设好好密码及主目录
useradd -d /home/"$COMMON_USER" -m -p "$COMMON_USER_PWD" "$COMMON_USER"
mkdir /home/"$COMMON_USER"/.ssh
#将新的用户目录及其子目录下的所有文件所有者变为新添加的用户
chown "$COMMON_USER":"$COMMON_USER" -R /home/"$COMMON_USER"

#修改ssh配置,允计用密钥登录
echo -e "${SKYBLUE} Change /etc/ssh/sshd_config settings to allow ssh-key login  ... ${PLAIN}"
#echo -e "\e[1;36m Change /etc/ssh/sshd_config settings to allow  ... \e[0m"
# 先备份
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
# 打开ssh密钥登录功能
sed -i "s/#RSAAuthentication/RSAAuthentication/" /etc/ssh/sshd_config
sed -i "s/#PubkeyAuthentication/PubkeyAuthentication/" /etc/ssh/sshd_config
# 重启ssh服务
echo -e "${SKYBLUE} Restart sshd service... ${PLAIN}"
service sshd restart

# 创建密钥对
ssh-keygen -b 1024 -t rsa -f /home/"$COMMON_USER"/.ssh/id_rsa
# 给密钥及目录设置权限
chmod 700 /home/"$COMMON_USER"/.ssh/
cd /home/"$COMMON_USER"/.ssh/
mv id_rsa.pub authorized_keys
chmod 600 authorized_keys

if [ $SUDOUSER = "yes" ]; then
    apt-get install sudo && visudo
fi

# 显示结果
echo -e "${SKYBLUE} New user name:     ${GREEN}"$COMMON_USER" ${PLAIN}"
echo -e "${SKYBLUE} New user password: ${GREEN}"$COMMON_USER_PWD" ${PLAIN}"
echo -e "${SKYBLUE} Old sshd_config backup to /etc/ssh/sshd_config.bak ${PLAIN}"
echo -e "${RED} Copy the following private key & Save as ~/.ssh/id_rsa in local device & chmod 600 ${PLAIN}"
# 显示private key 
cat /home/"$COMMON_USER"/.ssh/id_rsa


# To delete a user and delete the home directory
#deluser --remove-home username
#!/bin/bash