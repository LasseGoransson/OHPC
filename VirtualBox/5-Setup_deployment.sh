#!/bin/bash -x

source /etc/profile.d/OpenHPC_enviroment_variables.sh

# Set provisioning interface as the default networking device
echo "GATEWAYDEV=${eth_provision}" > /tmp/network.$$
wwsh -y file import /tmp/network.$$ --name network
wwsh -y file set network --path /etc/sysconfig/network --mode=0644 --uid=0

# Add nodes to Warewulf data store
for ((i=0; i<$num_computes; i++)) ; do wwsh -y node new ${c_name[$i]} --ipaddr=${c_ip[$i]} --hwaddr=${c_mac[$i]} -D ${eth_provision} ; done

# Define provisioning image for hosts
wwsh -y provision set "${compute_regex}" --vnfs=centos7.2 --bootstrap=`uname -r` --files=dynamic_hosts,passwd,group,shadow,slurm.conf,munge.key,network

# Restart dhcp / update PXE
systemctl restart dhcpd
wwsh pxe update

systemctl enable munge
systemctl enable slurmctld

echo "!!!! OG SÅ GENSTARTES MASKINEN !!!!"
read await_acceptance
init 6



