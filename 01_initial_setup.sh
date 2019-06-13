#!/bin/bash

# initial setup for the nano after the setup
#

set -e

sudo apt update

# get the minimal stuff we need to
sudo apt install -y ufw
sleep 5
sudo ufw enable
sleep 5
sudo ufw allow ssh
sudo ufw logging off

# remove stuff we don't need and add some we need
sudo apt remove -y libreoffice-* gnome-games gnome-calendar cheese deja-dup shotwell rhythmbox
 simple-scan thunderbird transmission-gtk activity-log-manager 

sudo apt remove -y unity-lens-photos *geocodeglib* aisleriot eog gnome-mines gnome-sudoku totem gnome-todo || echo cleanup failed


sudo apt install -y openssh-server git wget mg tmux

# update and cleanup
sudo apt upgrade -y
sudo apt autoremove -y


# python
sudo apt install -y python3 python3-pip python3-dev make cmake build-essential pkg-config libfreetype6-dev #python3-cuda
pip3 install setuptools

# reboot, just in case
sudo reboot now
