#!/bin/bash

# this will set up a temporary swap on your USB
# this is needed if, say, you want to compile your own kernel

set -e

echo "Enter location for the swap file (preferably on an external USB or SSD drive!)."
echo "Make sure it has been formatted for ext4"
read -p "Location to place swap file (e.g. /mnt/USB ): " loc


if [ -z $loc  ] ; then
	exit 0
fi


if [ ! -d $loc  ] ; then
	echo Location does not exist
	exit 0
fi


# 4G swap file
echo "Creating swap file. This might take some time..."
sudo dd if=/dev/zero of=$loc/swapfile bs=1k count=4M
sudo chmod 600 $loc/swapfile

echo "${loc}/swapfile none swap sw,pri=5 0 0" | sudo tee -a /etc/fstab

sudo mkswap ${loc}/swapfile
sudo swapon -a

free


