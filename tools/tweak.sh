#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

apt-get update
apt-get upgrade

apt-get install wget

#设置时区,同步时间
dpkg-reconfigure tzdata
apt-get install -y ntp
#vim /etc/ntp.conf #修改为下面几行
#server 0.debian.pool.ntp.org iburst dynamic
#server 1.debian.pool.ntp.org iburst dynamic
#server 2.debian.pool.ntp.org iburst dynamic
#server 3.debian.pool.ntp.org iburst dynamic
/etc/init.d/ntp restart

# -----------安装oh-my-zsh --------------
apt-get install zsh
cd ~
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# ----------- 系统配置及性能调优 -----------
#vim
apt-get install vim
echo 'syntax on
set fencs=utf-8,gbk
set nu!
set autoindent
set cindent
set smartindent
set tabstop=4
set ruler' > ~/.vimrc

# use my own vim conf,force cp without overwrite tip
# \cp vimrc /etc/vim/vimrc

# Change color
# sed -i 's/# export LS_OPTIONS/export LS_OPTIONS/g' /root/.bashrc
# sed -i 's/# eval/eval/g' /root/.bashrc
# sed -i 's/# alias/alias/g' /root/.bashrc
# echo "alias vi='vim'" >> /root/.bashrc
# source /root/.bashrc

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