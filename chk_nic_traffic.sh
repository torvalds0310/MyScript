#!/bin/bash

# This script will count NIC send/receive traffic at 1s interval.

INTERVAL="1"  # update interval in seconds

function usage (){
cat <<EOF
Usage: $0 NIC
Examples: $0 eth0 -- check NIC eth0's traffic at 1s interval.
EOF
}

if [ -z $1 ]; then
	usage;
	exit 1;
fi

while true
do
        R1=`cat /sys/class/net/$1/statistics/rx_bytes`
        T1=`cat /sys/class/net/$1/statistics/tx_bytes`
        sleep $INTERVAL
        R2=`cat /sys/class/net/$1/statistics/rx_bytes`
        T2=`cat /sys/class/net/$1/statistics/tx_bytes`
        TBPS=`expr $T2 - $T1`
        RBPS=`expr $R2 - $R1`
        TKBPS=`expr $TBPS / 1024`
        RKBPS=`expr $RBPS / 1024`
        echo "TX $1: $TKBPS kb/s RX $1: $RKBPS kb/s"
done
