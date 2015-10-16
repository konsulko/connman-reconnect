#!/bin/sh

configServer='8.8.8.8'
configPingTimeout=3

ipaddr=`ifconfig eth0 | grep 'inet addr:'  | cut -d: -f2 | awk '{ print $1}'`
#echo $ipaddr
if [ -z $ipaddr ]; then 
	echo "IP not assigned"
	exit 0
fi
ping -q -c 1 -W $configPingTimeout $configServer
isNetworkALive=$?
if [ $isNetworkALive -eq 0 ]; then
	echo "Network is alive"
	exit 0
fi
service=`connmanctl services | grep "\*AO" | cut -d: -f2 | awk '{ print $3}'`
if [ -z service ]; then
	echo "Unable to retrieve connected WiFi"
	exit 0
fi
echo $service
connmanctl disconnect $service
sleep 3
connmanctl connect $service
