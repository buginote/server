#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#定时校正系统时间
chkconfig --list | grep ntp
if [ $? -ne 0 ]; then
    apt-get -y install ntp
fi
timedatectl set-ntp true
timedatectl set-timezone Asia/Shanghai

# ----------- 系统配置及性能调优 -----------
#vim
echo 'syntax on
set fencs=utf-8,gbk
set nu!
set autoindent
set cindent
set smartindent
set tabstop=4
set ruler' > /root/.vimrc

# use my own vim conf,force cp without overwrite tip
# \cp vimrc /etc/vim/vimrc

#Change color
sed -i 's/# export LS_OPTIONS/export LS_OPTIONS/g' /root/.bashrc
sed -i 's/# eval/eval/g' /root/.bashrc
sed -i 's/# alias/alias/g' /root/.bashrc
echo "alias vi='vim'" >> /root/.bashrc
source /root/.bashrc

# 给重要命令写 md5
# cat > list << "EOF" &&
# /bin/ping
# /usr/bin/finger
# /usr/bin/who
# /usr/bin/w
# /usr/bin/locate
# /usr/bin/whereis
# /sbin/ifconfig
# /bin/vi
# /usr/bin/vim
# /usr/bin/which
# /usr/bin/gcc
# /usr/bin/make
# /bin/rpm
# EOF

# for i in `cat list`
# do
#    if [ ! -x $i ];then
#    echo "$i not found,no md5sum!"
#   else
#    md5sum $i >> /var/log/`hostname`.log
#   fi
# done
# rm -f list