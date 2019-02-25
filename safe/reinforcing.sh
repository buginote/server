#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# ----------- 检测是否是root账号 -----------
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script"
    exit 1
fi

# 用chattr防止以下文件被修改
chattr +i /etc/passwd
chattr +i /etc/shadow
chattr +i /etc/group
chattr +i /etc/gshadow
#给系统服务端口列表文件加锁,防止未经许可的删除或添加服务
#chattr +i /etc/services

#重新设置 /etc/rc.d/init.d/ 目录下所有文件的许可权限,只有root用户可以操作
chmod -R 700 /etc/rc.d/init.d/*