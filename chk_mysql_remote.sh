#!/bin/bash

# This script will help you check remote or local mysql service, depend on what's parameters you input.



function Usage()
{
cat <<EOF
Usage: $0 Options
	--host or -h   # Define the Host IP.
	--user or -u   # Define DB user.
	--passwd or -p # Define DB password.
	--socket or -s # Define DB socket file.
	--port or -P   # Define DB port, default value is 3306.

Examples: $0 -h 1.1.1.1 -uroot -ppasswd -P 3306 -s /var/lib/mysql/mysql.socket
EOF
}


Usage
