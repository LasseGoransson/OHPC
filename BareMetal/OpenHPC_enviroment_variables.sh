export CHROOT=/opt/ohpc/admin/images/centos7.2

export sms_name=sms-server
export sms_ip=192.168.1.254
export sms_eth_internal=enp13s0
export eth_provision=enp13s0
export internal_netmask=255.255.255.0
export ntp_server=sms-server
export bmc_ipaddr=(192.168.100.20 192.168.100.21)
export bmc_username=USERID
export bmc_password=PASSW0RD
export num_computes=2
export base_computes=node
export compute_regex=${base_computes}*
export c_mac=(e4:1f:13:22:9b:28 e4:1f:13:22:80:be)
export c_ip=("192.168.1.1" "192.168.1.2")
export c_name=("node1" "node2")
