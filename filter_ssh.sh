#!/bin/bash

ServerIP=`ifconfig  eth0 | grep "inet addr" | awk '{print $2}' | awk -F ":" '{print $2}'`

# Get SSH failure login infos.
grep -r Failed /var/log/secure* > /root/ssh_failure_data.log

# Filter failure login infos.
cat /root/ssh_failure_data.log | awk '{print $(NF-3),$(NF-5)}' | sort | uniq -c | awk '{print $1"="$2"="$3}' >  /root/ssh_data.log

for i in `cat /root/ssh_data.log`
	do
		Count=`echo $i |awk -F"=" '{print $1}'`
		IP=`echo $i |awk  -F"=" '{print $2}'`
		User=`echo $i |awk -F"=" '{print $3}'`
		if [ $Count -gt 10 ]; then
			grep $IP /root/ssh_failure_data.log > /tmp/ssh_error.logs
			mail -s "SSH abnormal login occurred on server $ServerIP." root@localhost < /tmp/ssh_error.logs
			rm -rf /tmp/ssh_error.logs
		fi
done
