#!/bin/bash -v
cp OpenHPC_enviroment_variables.sh /etc/profile.d/OpenHPC_enviroment_variables.sh
mkdir /root/OpenHPC
cp *.sh /root/OpenHPC/
chown root:root /root/OpenHPC/*.sh
chmod 744 /root/OpenHPC/*.sh
cp ifcfg-enp* /etc/sysconfig/network-scripts/
chown root:root /etc/sysconfig/network-scripts/ifcfg-enp*
chmod 755 /etc/sysconfig/network-scripts/ifcfg-enp*
cp ww* /root/OpenHPC/
chown root:root /root/OpenHPC/ww*
chmod 744 /root/OpenHPC/ww*
cp s* /root/OpenHPC/
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

