#!/bin/bash

# machine learning stuff: CUDA, pytorch and fastai
#
# arm64 CUDA systems are not well supported, hence the mess below

set -e

# these should already be here, but in case you removed them for some reason
sudo apt install -y -m cuda-cusparse-10-0 cuda-curand-dev-10-0 cuda-cufft-dev-10-0 cuda-tools-10-0 cuda-nvtx-10-0

# base libraries
pip3 install pandas matplotlib numpy --user

# pytorch:
# you can build pytorch from source but getting the CUDA support is tricky
# for instructions see https://gist.github.com/dusty-nv/ef2b372301c00c0a9d3203e42fd83426
# and https://devtalk.nvidia.com/default/topic/1049071/jetson-nano/pytorch-for-jetson-nano/
wget https://nvidia.box.com/shared/static/j2dn48btaxosqp0zremqqm8pjelriyvs.whl -O torch-1.1.0-cp36-cp36m-linux_aarch64.whl
pip3 install torch-1.1.0-cp36-cp36m-linux_aarch64.whl --user

# test pytorch
cd
python3 << EOF
import torch
print(torch.__version__)
print('CUDA available: ' + str(torch.cuda.is_available()))
a = torch.cuda.FloatTensor(2).zero_()
b = torch.randn(2).cuda()
c = a + b
print('Tensor a = ' + str(a))
print('Tensor b = ' + str(b))
print('Tensor c = ' + str(c))
EOF

# torch vision:
sudo apt install -y libjpeg-dev zlib1g-dev libpng-dev
pip3 install Pillow --user
pip3 install torchvision --no-deps --user

# scipy, used by fastai:
sudo apt install -y libmlpack-dev gfortran
pip3 install scipy --user

# fastai:
# Requires: beautifulsoup4, numpy, requests, spacy, torch, dataclasses, nvidia-ml-py3, matplotlib, scipy, pyyaml, Pillow, packaging, torchvision, fastprogress, numexpr, bottleneck, typing, pandas 

pip3 install space==2.0.18 --user
pip3 install dataclasses fastprogress --user
pip3 install fastai --no-deps --user

# test fastai
python3 << EOF
from fastai import *
from fastai.vision import *

path = untar_data(URLs.MNIST_SAMPLE)
data = ImageDataBunch.from_folder(path, bs = 8)
learn = cnn_learner(data, models.resnet18, metrics=accuracy)
learn.fit(1)
EOF


# clean up to redo all
# rm -rf ~/pytorch ~/.cache/pip ~/.local/lib/python3*

