#!/bin/bash

yum -y install flex gcc-c++
wget https://www.open-mpi.org/nightly/v1.10/openmpi-v1.10.4-31-g6a5fe29.tar.bz2
tar xf openmpi-v1.10.4-31-g6a5fe29.tar.bz2
cd openmpi-v1.10.4-31-g6a5fe29
./configure --prefix=/usr/local --disable-dlopen
make all install

