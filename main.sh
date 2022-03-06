#!/bin/bash
rm -rf ipwndfu_public
rm -rf ipwndfu

files/igetnonce | grep 'n53ap' &> /dev/null
if [ $? == 0 ]; then
   echo "Supported Device"
   device="iPhone6,2"
   echo $device
fi

files/igetnonce | grep 'n51ap' &> /dev/null
if [ $? == 0 ]; then
   echo "Supported Device"
   device="iPhone6,1"
   echo $device
fi

files/igetnonce | grep 'j71ap' &> /dev/null
if [ $? == 0 ]; then
   echo "Supported Device"
   device="iPad4,1"
   echo $device
fi

files/igetnonce | grep 'j72ap' &> /dev/null
if [ $? == 0 ]; then
   echo "Supported Device"
   device="iPad4,2"
   echo $device
fi

files/igetnonce | grep 'j85ap' &> /dev/null
if [ $? == 0 ]; then
   echo "Supported Device"
   device="iPad4,4"
   echo $device
fi

files/igetnonce | grep 'j86ap' &> /dev/null
if [ $? == 0 ]; then
   echo "Supported Device"
   device="iPad4,5"
   echo $device
fi
files/igetnonce | grep 'd11ap' &> /dev/null
if [ $? == 0 ]; then
   echo "Supported Device"
   device="iPhone9,2"
   echo $device
fi
files/igetnonce | grep 'd10ap' &> /dev/null
if [ $? == 0 ]; then
   echo "Supported Device"
   device="iPhone9,1"
   echo $device
fi
files/igetnonce | grep 'd101ap' &> /dev/null
if [ $? == 0 ]; then
   echo "Supported Device"
   device="iPhone9,3"
   echo $device
fi
files/igetnonce | grep 'd111ap' &> /dev/null
if [ $? == 0 ]; then
   echo "Supported Device"
   device="iPhone9,4"
   echo $device
fi
files/igetnonce | grep 'd22ap' &> /dev/null
if [ $? == 0 ]; then
   echo "Supported Device"
   device="iPhone10,3"
   echo $device
fi
files/igetnonce | grep 'd221ap' &> /dev/null
if [ $? == 0 ]; then
   echo "Supported Device"
   device="iPhone10,6"
   echo $device
fi

if [ -z "$device" ]
then
    echo "Either unsupported device or no device found."
    echo "Exiting.."
    exit
else
    echo "Supported device found."
fi

echo "Please connect device in DFU mode. Press enter when ready to continue"

read randomIrrelevant

echo "Starting ipwndfu"

string=$(./files/lsusb | grep -c "checkm8")
until [ $string = 1 ];
do
    killall iTunes && killall iTunesHelper
    seconds=$((5 + $RANDOM % 20))
    echo "Waiting $seconds seconds to allow you to enter DFU mode"
    sleep $seconds
    echo "Attempting to get into pwndfu mode"
    echo "Please just enter DFU mode again on each reboot"
    echo "The script will run ipwndfu again and again until the device is in PWNDFU mode"
    ipwndfu -p
    string=$(./files/lsusb | grep -c "checkm8")
done

sleep 3

if [ $device == iPhone10,3 ] || [ $device == iPhone10,6 ]; then
    echo "Device is an iPhone X, using akayn's signature check remover"
    ipwndfu --patch
    sleep 1
else
    echo "Device is NOT an iPhone X, using Linus's signature check remover"
    python2 rmsigchks.py
    sleep 1
fi
cd ..
echo "Device is now in PWNDFU mode with signature checks removed (Thanks to Linus Henze & akayn)"