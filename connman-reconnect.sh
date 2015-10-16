#!/bin/sh

configPingTimeout=3

#retrieve the default gateway
server=`route -n | grep 'UG[ \t]' | awk '{print $2}'`
if [ -z $server ]; then
	#if the default gateway cannot be found use Google public DNS server
	server='8.8.8.8'
fi
ipaddr=`ifconfig eth0 | grep 'inet addr:'  | cut -d: -f2 | awk '{ print $1}'`
if [ -z $ipaddr ]; then 
	echo "IP not assigned"
	exit 0
fi
ping -q -c 1 -W $configPingTimeout $server
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
if [[ $service != "wifi"* ]]; then
	echo "$service is not a WiFi network"
	exit 0
fi
connmanctl disconnect $service
sleep 3
connmanctl connect $service
