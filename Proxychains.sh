#!/bin/bash

#trap crtl^c
trap ctrl_c INT
function crtl_c(){
	echo "Exiting.. Cleaining up Firefox and Wireshark"
}

datetime=`date +"%d.%m.%y::%H:%M"`
$wireshark
$proxychains
$devname
$wiresharkdevice
$logfile

#Create log file
logfile="/var/log/proxychainswireshark${datetime}.capture"
#If file exists add an index
for i in {0..4}
do
	if [ ! -f "$logfile" ]; then
		sudo touch "${logfile}"
		break
	else
		logfile="/var/log/proxychainswireshark${i}.${datetime}.capture"
	fi
done

if [ ! -f "$logfile" ]; then
        echo "Log file does not exist. Creating.."
        sudo touch "/var/log/proxychainswireshark${datetime}.capture"
fi

#Select wireshark device
echo "Device Selection for wireshark:"
sudo wireshark -D
echo "Please insert the index or name of a device:"
read devname

#Set commands
wireshark="sudo wireshark -i ${devname} -k -w ${logfile}"
proxychains="proxychains firefox -p -no-remote"

#Start Wireshark and proxychains
echo "Starting Wireshark (Log@${logfile})"
$wireshark &
echo "Starting Firefox with proxychains"
$proxychains &
