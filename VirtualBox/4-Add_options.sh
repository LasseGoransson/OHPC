#!/bin/bash -v

source /etc/profile.d/OpenHPC_enviroment_variables.sh

# Install Nagios base, Remote Plugin Engine, and Plugins on master host
yum -y groupinstall ohpc-nagios

# Also install in compute node image
yum -y --installroot=$CHROOT groupinstall ohpc-nagios

# Enable and configure NRPE in compute image
chroot $CHROOT systemctl enable nrpe
perl -pi -e "s/^allowed_hosts=/# allowed_hosts=/" $CHROOT/etc/nagios/nrpe.cfg
echo "nrpe 5666/tcp # NRPE" >> $CHROOT/etc/services
echo "nrpe : ${sms_ip} : ALLOW" >> $CHROOT/etc/hosts.allow
echo "nrpe : ALL : DENY" >> $CHROOT/etc/hosts.allow
chroot $CHROOT /usr/sbin/useradd -c "NRPE user for the NRPE service" -d /var/run/nrpe -r -g nrpe -s /sbin/nologin nrpe
chroot $CHROOT /usr/sbin/groupadd -r nrpe

# Configure remote services to test on compute nodes
mv /etc/nagios/conf.d/services.cfg.example /etc/nagios/conf.d/services.cfg

# Define compute nodes as hosts to monitor
mv /etc/nagios/conf.d/hosts.cfg.example /etc/nagios/conf.d/hosts.cfg
for ((i=0; i<$num_computes; i++)) ; do
	perl -pi -e "s/HOSTNAME$(($i+1))/${c_name[$i]}/ || s/HOST$(($i+1))_IP/${c_ip[$i]}/" /etc/nagios/conf.d/hosts.cfg
done

# Update location of mail binary for alert commands
perl -pi -e "s/ \/bin\/mail/ \/usr\/bin\/mailx/g" /etc/nagios/objects/commands.cfg

# Update email address of contact for alerts
perl -pi -e "s/nagios\@localhost/root\@${sms_name}/" /etc/nagios/objects/contacts.cfg

# Add check_ssh command for remote hosts
echo command[check_ssh]=/usr/lib64/nagios/plugins/check_ssh localhost >> $CHROOT/etc/nagios/nrpe.cfg

# Enable Nagios on master, and configure
chkconfig nagios on
systemctl start nagios
chmod u+s `which ping`



# Install Ganglia
yum -y groupinstall ohpc-ganglia
yum -y --installroot=$CHROOT install ganglia-gmond-ohpc

# Use example configuration script to enable unicast receiver on master host
cp /opt/ohpc/pub/examples/ganglia/gmond.conf /etc/ganglia/gmond.conf
perl -pi -e "s/<sms>/${sms_name}/" /etc/ganglia/gmond.conf

# Add config to compute image and provide gridname
cp /etc/ganglia/gmond.conf $CHROOT/etc/ganglia/gmond.conf
echo "gridname MySite" >> /etc/ganglia/gmetad.conf

# Start and enable Ganglia services
systemctl enable gmond
systemctl enable gmetad
systemctl start gmond
systemctl start gmetad
chroot $CHROOT systemctl enable gmond

# Restart web server
systemctl try-restart httpd

# Configure SMS to receive messages and reload rsyslog configuration
perl -pi -e "s/\\#\\\$ModLoad imudp/\\\$ModLoad imudp/" /etc/rsyslog.conf
perl -pi -e "s/\\#\\\$UDPServerRun 514/\\\$UDPServerRun 514/" /etc/rsyslog.conf
systemctl restart rsyslog

# Define compute node forwarding destination
echo "*.* @${sms_ip}:514" >> $CHROOT/etc/rsyslog.conf

# Disable most local logging on computes. Emergency and boot logs will remain on the compute nodes
perl -pi -e "s/^\*\.info/\\#\*\.info/" $CHROOT/etc/rsyslog.conf
perl -pi -e "s/^authpriv/\\#authpriv/" $CHROOT/etc/rsyslog.conf
perl -pi -e "s/^mail/\\#mail/" $CHROOT/etc/rsyslog.conf
perl -pi -e "s/^cron/\\#cron/" $CHROOT/etc/rsyslog.conf
perl -pi -e "s/^uucp/\\#uucp/" $CHROOT/etc/rsyslog.conf

# Setup files to clone to cluster nodes.
wwsh file import /etc/passwd
wwsh file import /etc/group
wwsh file import /etc/shadow
wwsh file import /etc/slurm/slurm.conf
wwsh file import /etc/munge/munge.key

# Build bootstrap image
wwbootstrap `uname -r`

# Assemble Virtual Node File System (VNFS) image
wwvnfs -y --chroot $CHROOT


