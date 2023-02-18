#!/bin/bash
while true
     do
     i=$(cat /sys/class/net/wls33/carrier)
if [ $i == 1 ]
then
       echo "A ligação do PC à GOPRO via WIFI mantêm-se ligado."
else
	nmcli dev wifi connect "SSID" password "PALAVRA_PASSE"
	fi
sleep 2
done