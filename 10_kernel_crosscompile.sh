#!/bin/bash

# This will compile a new kernel
# (this runs inside a LXC container on your local PC)

set -e

NAME=nano-builder
mkdir -p tmp

echo "Note: this should run on your local machine"

lxc delete -f $NAME || echo No previous containers to delete

lxc launch images:ubuntu/18.04 $NAME
sleep 5

lxc exec $NAME -- bash << EOF
sudo apt update
sudo apt upgrade -y
sudo apt install -y --no-install-recommends git wget make build-essential bc # libncurses5-dev

# get the compiler

# ubuntu default compiler
# sudo apt install -y --no-install-recommends  gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu
# export CROSS_COMPILE=aarch64-linux-gnu-

# linaro compiler
apt install -y gcc-multilib lib32z1
wget -q https://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/aarch64-linux-gnu/gcc-linaro-7.3.1-2018.05-i686_aarch64-linux-gnu.tar.xz
tar xf gcc-linaro-7.3.1-2018.05-i686_aarch64-linux-gnu.tar.xz
export CROSS_COMPILE=~/gcc-linaro-7.3.1-2018.05-i686_aarch64-linux-gnu/bin/aarch64-linux-gnu-

# L4T compiler
# wget -q https://developer.nvidia.com/embedded/dlc/l4t-gcc-toolchain-64-bit-32-1 -O l4t-gcc.tgz
# tar xf l4t-gcc.tgz
# export LC_ALL=C
## export PATH=$PATH:~/install/bin
# export CROSS_COMPILE=~/install/bin/aarch64-unknown-linux-gnu-


# get the kernel
wget -q https://developer.nvidia.com/embedded/dlc/l4t-sources-32-1-jetson-nano -O l4t-sources.tar.bz2
tar xf l4t-sources.tar.bz2
tar xf public_sources/kernel_src.tbz2


# build the kernel
cd kernel/kernel-4.9

export ARCH=arm64
export CROSS32CC=${CROSS_COMPILE}gcc
export LOCALVERSION="-tegra"

# make tegra_gnu_linux_defconfig
make tegra_defconfig
# scripts/config --disable CC_STACKPROTECTOR_STRONG

# scripts/rt-patch.sh apply-patches

make prepare
make modules_prepare
make -j $(nproc) Image zImage
make -j $(nproc) modules

# get the stuff
mkdir dist
make INSTALL_MOD_PATH=dist modules_install
make INSTALL_PATH=dist install
make INSTALL_PATH=dist firmware_install
cd dist
tar cf /kernel.tar.gz *

EOF

lxc file pull $NAME/kernel.tar.gz tmp/

lxc delete -f $NAME


