#!/bin/bash

# download the latest image and start the application that writes it to a sdcard
# (this first scripts runs from your PC)

set -e

mkdir -p tmp
rm -f tmp/*.img

wget https://developer.nvidia.com/embedded/dlc/jetson-nano-dev-kit-sd-card-image -O tmp/sd-card-image.zip
unzip tmp/sd-card-image.zip -d tmp

xdg-open tmp/*.img
