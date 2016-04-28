#!/bin/bash
 
check1="fail2ban"
 
if pgrep "$check1" ; then
		echo "$check1 OK"
else
        date=$(date +"%Y-%m-%d %H:%M:%S")
        service fail2ban start
        echo 'error: fail2ban at ' $date > /root/servicedown.log
fi

check2="acce-3.10.61.0"

if pgrep "$check2" ; then
		echo "$check2 OK"
else
        date=$(date +"%Y-%m-%d %H:%M:%S")
        service serverSpeeder restart
        echo 'error: serverSpeeder at ' $date > /root/servicedown.log
fi