#!/bin/bash

# By making the device headless you remove the GUI but also save ~300MB of RAM

set -e

# set runlevel to 3 the systemd way
sudo systemctl set-default multi-user.target

