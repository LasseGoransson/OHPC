#!/usr/bin/bash

source /etc/profile.d/OpenHPC_enviroment_variables.sh


#echo ">>>>>>>>> Compiler OpenMPI uden dynamisk linkning"
#yum -y install flex gcc-c++
#wget https://www.open-mpi.org/nightly/v1.10/openmpi-v1.10.4-31-g6a5fe29.tar.bz2
#tar xf openmpi-v1.10.4-31-g6a5fe29.tar.bz2
#cd openmpi-v1.10.4-31-g6a5fe29
#./configure --prefix=/usr/local --disable-dlopen
#make all install



#echo ">>>>>>>>> Compiler OpenMPI til noder"
#yum -y install flex gcc-c++
#wget https://www.open-mpi.org/nightly/v1.10/openmpi-v1.10.4-31-g6a5fe29.tar.bz2
#tar xf openmpi-v1.10.4-31-g6a5fe29.tar.bz2
#cd openmpi-v1.10.4-31-g6a5fe29
#./configure --prefix=$CHROOT/usr/local --disable-dlopen
#make all install


#exit 0
echo ">>>>>>>>>> Install OpenMPI LAMMPS"
yum --installroot=$CHROOT  remove lmod-ohpc 
yum remove lmod-ohpc 
yum --installroot=$CHROOT install /home/user/Jobs/*.rpm
yum install /home/user/Jobs/*.rpm

yum --installroot=$CHROOT install libgfortran libgomp python-virtualenv
yum install libgfortran libgomp python-virtualenv

rpm --root=$CHROOT --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro 
rpm --root=$CHROOT -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-1.el7.nux.noarch.rpm

rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro 
rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-1.el7.nux.noarch.rpm

yum --installroot=$CHROOT makecache
yum  makecache

yum --installroot=$CHROOT install ffmpeg
yum  install ffmpeg


