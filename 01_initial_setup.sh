#!/bin/bash

# initial setup for the nano after the setup
#

set -e

sudo apt update

# start with the firewall
sudo apt install -y ufw
sudo ufw allow ssh
sudo ufw logging off

# sometimes ufw enable fails for unknown reasons
sleep 5
sudo ufw enable || sudo ufw enable || echo "Try enabling ufw later..."


# remove stuff we don't need and add some we need
sudo apt remove -y -m libreoffice-* gnome-games gnome-calendar cheese deja-dup shotwell rhythmbox
 simple-scan thunderbird transmission-gtk activity-log-manager unity-lens-photos *geocodeglib* aisleriot eog gnome-mines gnome-sudoku totem gnome-todo || echo cleanup failed

sudo apt install -y openssh-server git wget mg tmux

# update and cleanup
sudo apt upgrade -y
sudo apt autoremove -y


# python
sudo apt install -y python3 python3-pip python3-dev make cmake build-essential pkg-config libfreetype6-dev #python3-cuda
pip3 install setuptools

# reboot, just in case
sudo reboot now
