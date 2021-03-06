#!/usr/bin/bash

source /etc/profile.d/OpenHPC_enviroment_variables.sh

echo ">>>>>>>>>> Install OpenMPI LAMMPS"

rpm  --root=$CHROOT --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro 
rpm  --root=$CHROOT -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-1.el7.nux.noarch.rpm

rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro 
rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-1.el7.nux.noarch.rpm

yum -y --installroot=$CHROOT  remove lmod-ohpc 
yum -y remove lmod-ohpc 

yum -y --installroot=$CHROOT install ffmpeg libgfortran libgomp python-virtualenv RPMS/*.rpm  makecache gcc-c++ gcc ImageMagick
yum -y install ffmpeg libgfortran libgomp python-virtualenv RPMS/*.rpm  makecache gcc-c++ gcc ImageMagick
yum  makecache

virtualenv mdbenv
source mdbenv/bin/activate
pip install --upgrade pip
pip install -r Mandelbrot/requirements.txt
deactivate


