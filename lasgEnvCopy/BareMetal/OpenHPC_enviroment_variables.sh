export CHROOT=/opt/ohpc/admin/images/centos7.2

export sms_name=sms-server
export sms_ip=192.168.99.254
export internal_netmask=255.255.255.0
export ntp_server=sms-server
export bmc_ipaddr=(192.168.100.20 192.168.100.21)
export bmc_username=USERID
export bmc_password=PASSW0RD
export num_computes=2
export base_computes=node
export compute_regex=${base_computes}*
export c_ip=("192.168.99.1" "192.168.99.2")
export c_name=("node1" "node2")
export sms_eth_internal=enp11s0f1
export eth_provision=enp11s0f1
export c_mac=(e4:1f:13:22:85:14 E4:1F:13:22:7C:B1)
