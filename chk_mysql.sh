#!/bin/bash

# This script will help you to check mysql status, it will send mail to Admin with defined errors if something wrong with mysql, such as mysql did not start, or mysql hang on.


user=root
passwd=redhat
host=localhost
mysqladmin=/usr/local/mysql/bin/mysqladmin
mysql=/usr/local/mysql/bin/mysql
serverip=`ifconfig | grep "inet addr" | head -n 1 | awk '{print $2}' | awk -F ":" '{print $2}'`
currdate=`date +"%y-%m-%d-%H:%M:%S"`

# Check mysql if runing.
$mysqladmin -u$user -p$passwd -h$host status 1>2 2>/home/mysqlstatus.log

if [ $? -ne 0 ]; then
	echo "$currdate" >> /home/mysqlstatus.log
	echo "Mysql is not runing on server $serverip at $currdate." > /home/mysqlstatus.log
	mail -s "Mysql is not running on server $serverip at $currdate." yaning@blabla.com < /home/mysqlstatus.log
	exit 1
fi


# Check mysql if functionnal.
$mysql -u$user -p$passwd -h$host -e "insert into test.mytest values(1,'test');" 1>2 2>/home/mysqlinsert.log

if [ $? -ne 0 ]; then
	echo "$currdate" >> /home/mysqlinsert.log
	echo "MySQL is not functional on server $serverip at $currdate." >> /home/mysqlinsert.log
	mail -s "MySQL is not functional on server $serverip at $currdate." yaning@blabla.com < /home/mysqlinsert.log
fi


