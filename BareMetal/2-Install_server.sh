#!/bin/bash -v

source /etc/profile.d/OpenHPC_enviroment_variables.sh

echo ">>>>>>>>>> !!! Opdater operativsystemet, og opdater repository cache"
read await_acceptance
yum update
yum -y install epel-release
rpm -ivh http://build.openhpc.community/OpenHPC:/1.1/CentOS_7.2/x86_64/ohpc-release-1.1-1.x86_64.rpm

echo ">>>>>>>>>> Installer grundopsætningen af OpenHPC pakkerne."
read await_acceptance

yum makecache
echo ">>>>>>>>>> Cache opdateret!"
read await_acceptance
yum -y groupinstall ohpc-base
yum -y groupinstall ohpc-warewulf

echo ">>>>>>>>>> Fjern firewall på SMS-serveren"
read await_acceptance
systemctl disable firewalld
systemctl stop firewalld

echo ">>>>>>>>>> Og tilføj SMS-serveren som NTP server for klosteret."
read await_acceptance
systemctl enable ntpd
echo "server ${ntp_server}" >> /etc/ntp.conf
systemctl restart ntpd

echo ">>>>>>>>>> Installer Slurm for at håndtere jobs på klosteret."
read await_acceptance
yum -y groupinstall ohpc-slurm-server
useradd slurm
systemctl enable munge
systemctl enable slurmctld.service


echo ">>>>>>>>>> Nu starter den egentlige opsætning af WareWulf installationen."
read await_acceptance
perl -pi -e "s/device = eth1/device = ${sms_eth_internal}/" /etc/warewulf/provision.conf
perl -pi -e "s/^\s+disable\s+= yes/ disable = no/" /etc/xinetd.d/tftp
export MODFILE=/etc/httpd/conf.d/warewulf-httpd.conf
perl -pi -e "s/cgi-bin>\$/cgi-bin>\n Require all granted/" $MODFILE
perl -pi -e "s/Allow from all/Require all granted/" $MODFILE
perl -ni -e "print unless /^\s+Order allow,deny/" $MODFILE
ifconfig ${sms_eth_internal} ${sms_ip} netmask ${internal_netmask} up

echo ">>>>>>>>>> Ændre daemons til at starte korrekt!"
read await_acceptance
systemctl restart xinetd
systemctl enable mariadb.service
systemctl restart mariadb.service
systemctl enable httpd.service
systemctl restart httpd



