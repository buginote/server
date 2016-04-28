#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export PATH

apt-get update && apt-get upgrade -y
pt-get -y install wget screen python

#Change timezone to Shanghai
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime -y
sed -i '1d' /etc/timezone
echo Asia/Shanghai > /etc/timezone

#Change color
sed -i 's/# export LS_OPTIONS/export LS_OPTIONS/g' /root/.bashrc
sed -i 's/# eval/eval/g' /root/.bashrc
sed -i 's/# alias/alias/g' /root/.bashrc
source /root/.bashrc

#install fail2ban
apt-get install fail2ban -y
cp jail.local /etc/fail2ban/jail.local
cp apache-w00tw00t.conf /etc/fail2ban/filter.d/apache-w00tw00t.conf
cp apache-myadmin.conf /etc/fail2ban/filter.d/apache-myadmin.conf
service fail2ban restart

