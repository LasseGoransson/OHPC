export CHROOT=/opt/ohpc/admin/images/centos7.2

export sms_name=sms-server
export sms_ip=192.168.50.1
export sms_eth_internal=enp0s8
export eth_provision=enp0s8
export internal_netmask=255.255.255.0
export ntp_server=sms-server
export bmc_username=USERID
export bmc_password=PASSW0RD
#export compute_regex=node*
export num_computes=2
export base_computes=node
export compute_regex=${base_computes}*
export c_mac=("08:00:27:C6:DC:86" "08:00:27:A3:1D:9A")
export c_ip=("192.168.50.100" "192.168.50.101")
export c_name=("node1" "node2")
