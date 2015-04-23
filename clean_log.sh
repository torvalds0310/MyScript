#!/bin/bash

# Clean log file.

root_id=0
log_file=/path/to/log_file

# Check current user.
if [ $UID -ne $root_id ]; then
	echo "Only root can execute this scirpt, please try agian with root user."
	exit 1
fi

# Check log fie.
if [ -z $log_file ]; then
	echo "The log file dose not exist, please check."
	exit
fi

# Execute clean operation.

cat /dev/null > $log_file

echo "The log file $log_file has been cleaned."
