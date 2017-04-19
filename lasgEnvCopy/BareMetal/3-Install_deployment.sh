#!/bin/bash -v

source /etc/profile.d/OpenHPC_enviroment_variables.sh

echo ">>>>>>>>>> Setup initial root image."
read await_acceptance
export CHROOT=/opt/ohpc/admin/images/centos7.2
wwmkchroot centos-7 $CHROOT

cp -p /etc/resolv.conf $CHROOT/etc/resolv.conf
yum -y --installroot=$CHROOT groupinstall ohpc-slurm-client
yum -y --installroot=$CHROOT install ntp
yum -y --installroot=$CHROOT install kernel
yum -y --installroot=$CHROOT install lmod-ohpc

# add new cluster key to base image
wwinit ssh_keys
cat ~/.ssh/cluster.pub >> $CHROOT/root/.ssh/authorized_keys

# add NFS client mounts of /home and /opt/ohpc/pub to base image
echo "${sms_ip}:/home /home nfs nfsvers=3,rsize=1024,wsize=1024,cto 0 0" >> $CHROOT/etc/fstab
echo "${sms_ip}:/opt/ohpc/pub /opt/ohpc/pub nfs nfsvers=3 0 0" >> $CHROOT/etc/fstab

# Identify resource manager host name on master host
perl -pi -e "s/ControlMachine=\S+/ControlMachine=${sms_name}/" /etc/slurm/slurm.conf
perl -pi -e "s/NodeName=\S+/NodeName=${base_computes}\[1-${num_computes}\]/" /etc/slurm/slurm.conf
perl -pi -e "s/Nodes=\S+/Nodes=${base_computes}\[1-${num_computes}\]/" /etc/slurm/slurm.conf
chroot $CHROOT systemctl enable munge
chroot $CHROOT systemctl enable slurmd

echo "${sms_ip}		${sms_name}" >> /etc/hosts

# Export /home and OpenHPC public packages from master server to cluster compute nodes
echo "/home *(rw,no_subtree_check,fsid=10,no_root_squash)" >> /etc/exports
echo "/opt/ohpc/pub *(ro,no_subtree_check,fsid=11)" >> /etc/exports
exportfs -a
systemctl restart nfs
systemctl enable nfs-server

# Enable NTP time service on computes and identify master host as local NTP server
chroot $CHROOT systemctl enable ntpd
echo "server ${sms_ip}" >> $CHROOT/etc/ntp.conf

echo "account required      pam_slurm.so" >> $CHROOT/etc/pam.d/sshd
