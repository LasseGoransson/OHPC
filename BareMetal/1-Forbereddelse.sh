#!/bin/bash -v
cp /run/media/root/TRAVELER16G/OpenHPC/BareMetal/OpenHPC_enviroment_variables.sh /etc/profile.d/OpenHPC_enviroment_variables.sh
cp /run/media/root/TRAVELER16G/OpenHPC/BareMetal/Install_guide-CentOS7.2-1.1.1.pdf /root/Desktop/Install_guide-CentOS7.2-1.1.1.pdf
mkdir /root/OpenHPC
cp /run/media/root/TRAVELER16G/OpenHPC/BareMetal/*.sh /root/OpenHPC/
chown root:root /root/OpenHPC/*.sh
chmod 744 /root/OpenHPC/*.sh
cp /run/media/root/TRAVELER16G/OpenHPC/BareMetal/ifcfg-enp* /etc/sysconfig/network-scripts/
chown root:root /etc/sysconfig/network-scripts/ifcfg-enp*
chmod 755 /etc/sysconfig/network-scripts/ifcfg-enp*
cp /run/media/root/TRAVELER16G/OpenHPC/BareMetal/wwpower /root/OpenHPC/
chown root:root /root/OpenHPC/wwpower
chmod 744 /root/OpenHPC/wwpower
cp /run/media/root/TRAVELER16G/OpenHPC/*. /root/OpenHPC/
chown root:root /root/OpenHPC/*.
chmod 744 /root/OpenHPC/*.

source /etc/profile.d/OpenHPC_enviroment_variables.sh

echo "$sms_name" > /etc/hostname
echo "PATH=$PATH:/root/OpenHPC ; export PATH" > /etc/profile.d/OpenHPC_add_PATH.sh

echo "!!!! HUSK AT DISABLE SELINUX !!!!"
read await_acceptance
vi /etc/selinux/config

echo "!!!! OG SÅ GENSTARTES MASKINEN !!!!"
read await_acceptance
init 6

