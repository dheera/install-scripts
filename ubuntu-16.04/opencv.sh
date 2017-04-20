#!/bin/bash
# Compiles OpenCV 3.1.0 with python2 and python3 bindings.

sudo apt-get update && sudo apt-get -y upgrade

sudo apt-get -y install python3-numpy python-numpy python-pip python3-pip

sudo pip3 install virtualenv virtualenvwrapper
sudo pip install virtualenv virtualenvwrapper

sudo apt-get -y install build-essential cmake git pkg-config
sudo apt-get -y install libjpeg8-dev libtiff-dev libjasper-dev libpng12-dev
sudo apt-get -y install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
sudo apt-get -y install libgtk2.0-dev
sudo apt-get -y install libatlas-base-dev gfortran
sudo apt-get -y install python3.5-dev
sudo apt-get -y install python2.7-dev
sudo apt-get -y install libhdf5-dev


cd ~
git clone https://github.com/opencv/opencv.git
cd opencv
git checkout 3.1.0
# fix for hdf5.h not found
# https://github.com/opencv/opencv/issues/6016
sed -i '1s/^/# Temporary Fix\nfind_package(HDF5)\ninclude_directories(${HDF5_INCLUDE_DIRS})\n/' modules/python/common.cmake

cd ~
git clone https://github.com/opencv/opencv_contrib.git
cd opencv_contrib
git checkout 3.1.0

cd ~/opencv
mkdir build
cd build

CUDA_LIBRARY_LOCATION=`find / 2>/dev/null | egrep libcudart.so$ | head -1`

cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
	-D INSTALL_C_EXAMPLES=OFF \
	-D INSTALL_PYTHON_EXAMPLES=ON \
	-D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
	-D BUILD_EXAMPLES=ON \
	-D CUDA_NVCC_FLAGS="-D_FORCE_INLINES" \
	-D CUDA_CUDA_LIBRARY=$CUDA_LIBRARY_LOCATION \
	..

make -j4
sudo make install
sudo ldconfig


