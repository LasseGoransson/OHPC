#!/bin/bash -v
ROOT=$1

cp $ROOT/OpenHPC_enviroment_variables.sh /etc/profile.d/OpenHPC_enviroment_variables.sh
cp $ROOT/Install_guide-CentOS7.2-1.1.1.pdf /root/Desktop/Install_guide-CentOS7.2-1.1.1.pdf
mkdir /root/OpenHPC
cp $ROOT/*.sh /root/OpenHPC/
chown root:root /root/OpenHPC/*.sh
chmod 744 /root/OpenHPC/*.sh
cp $ROOT/s* /root/OpenHPC/
chown root:root /root/OpenHPC/s*
chmod 744 /root/OpenHPC/s*

source /etc/profile.d/OpenHPC_enviroment_variables.sh

echo "$sms_name" > /etc/hostname
echo "PATH=$PATH:/root/OpenHPC ; export PATH" > /etc/profile.d/OpenHPC_add_PATH.sh

echo ">>>>>>>>>> !!!! HUSK AT DISABLE SELINUX !!!!"
read await_acceptance
vi /etc/selinux/config

echo ">>>>>>>>>> !!!! OG SÅ GENSTARTES MASKINEN !!!!"
read await_acceptance
init 6
