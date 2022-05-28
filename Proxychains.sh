#!/bin/bash

#trap crtl^c
trap ctrl_c INT
function crtl_c(){
	echo "Exiting.. Cleaining up Firefox and Wireshark"
}

datetime=`date +"%d_%m_%y_%H_%M"`
$wireshark
$proxychains
$devname
$wiresharkdevice
$logfile

#Create log file
$logfile="/var/log/proxychainswireshark${datetime}.capture"
If file exists add an index
for i in {0..4}
do
	if [ -f "$logfile" ]; then
		continue
	else
		sudo touch $logfile.=i
		break
	fi
done

if [ ! -f "$logfile" ]; then
        echo "Log file does not exist. Creating.."
        sudo touch "/var/log/proxychainswireshark${datetime}.capture"
fi


echo "Starting Wireshark and Firefox with proxychains"
echo "Device Selection for wireshark:"
sudo wireshark -D
echo "Please insert the index or name of a device:"
read $devname

#Set commands
$wireshark="sudo wireshark -i ${devname} -k -w /var/log/proxychainswireshark${datetime}.capture"
$proxychains="proxychains firefox -p -no-remote"

#Start Wireshark and proxychains
echo "Starting Wireshark (Log@/var/log/proxychainswireshark${datetime}.capture)"
$wireshark &
echo "Starting Firefox with proxychains"
$proxychains &
