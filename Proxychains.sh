#!/bin/bash

#trap crtl^c
#trap ctrl_c INT
#function crtl_c(){
#	echo "Exiting.. Cleaning up Firefox and Wireshark"
#}

datetime=`date +"%d.%m.%y::%H:%M"`
$wireshark
$proxychains
$devname
$wiresharkdevice
$logfile

#Create log file
logfile="/var/log/proxychains${datetime}.capture"
#If file exists add an index
for i in {0..4}
do
	if [ ! -f "$logfile" ]; then
		sudo touch "${logfile}"
		break
	else
		logfile="/var/log/proxychains${i}.${datetime}.capture"
	fi
done

#Select wireshark device
echo "Would you like to use wireshark or tcpdump? (wireshark/tcpdump)"
read wiresharktcpdump

if [ $wiresharktcpdump == "wireshark" ]; then
    echo "Device Selection for wireshark:"
    sudo wireshark -D
    echo "Please insert the index or name of a device:"
    read devname
    #Set commands
    wireshark="sudo wireshark -i ${devname} -k -w ${logfile}"
    $wireshark &
    echo "Started wireshark (log@${logfile})"
elif [ $wiresharktcpdump == "tcpdump" ]; then
    echo "Started tcpdump (log@${logfile})"
    tcpdump="sudo tcpdump -vv > ${logfile}"
    $tcpdump &
else
    exit 1
fi

#Start proxychains firefox
proxychains="proxychains4 firefox -p -no-remote"
echo "Starting Firefox with proxychains"
$proxychains &
