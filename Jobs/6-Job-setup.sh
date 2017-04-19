#!/usr/bin/bash

source /etc/profile.d/OpenHPC_enviroment_variables.sh

echo ">>>>>>>>>> Install OpenMPI LAMMPS"
yum --installroot=$CHROOT  remove lmod-ohpc 
yum --installroot=$CHROOT install /home/user/Jobs/*.rpm

yum --installroot=$CHROOT install libgfortran libgomp

rpm --root=$CHROOT --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro 
rpm --root=$CHROOT -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-1.el7.nux.noarch.rpm

yum --installroot=$CHROOT makecache

yum --installroot=$CHROOT install ffmpeg
