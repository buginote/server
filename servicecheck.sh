#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

file="/root/servicedown.log"
if [ ! -f "$file" ]; then
  touch "$file"
fi

#check fail2ban 
check1="fail2ban"
 
if pgrep "$check1" ; then
		echo "$check1 OK"
else
        date=$(date +"%Y-%m-%d %H:%M:%S")
        service fail2ban start
        echo 'error: fail2ban at ' $date > /root/servicedown.log
fi

#Check Ruisu
check2="acce-3.10.61.0"

if pgrep "$check2" ; then
		echo "$check2 OK"
else
        date=$(date +"%Y-%m-%d %H:%M:%S")
        service serverSpeeder restart
        echo 'error: serverSpeeder at ' $date > /root/servicedown.log
fi