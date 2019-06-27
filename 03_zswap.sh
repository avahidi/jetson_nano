#!/bin/bash

# This will enable zswap, which should improve memory usage 


set -e

cd /boot/extlinux/
sudo cp extlinux.conf extlinux.conf.org
sudo sed -i 's/rootwait/rootwait zswap.enabled=1/' extlinux.conf

echo "Reboot for this to take effect"

