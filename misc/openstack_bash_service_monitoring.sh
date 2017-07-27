#!/bin/bash


RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color


osservices=(\
 gns3 \
 sshd \
 openstack-nova-api \
 openstack-nova-cert \
 openstack-nova-consoleauth \
 openstack-nova-scheduler \ 
 openstack-nova-conductor \
 openstack-nova-novncproxy \
 neutron-server \
 neutron-dhcp-agent \
 neutron-l3-agent \
 neutron-metadata-agent \
 neutron-openvswitch-agent \
 openstack-cinder-api \
 openstack-cinder-backup \
 openstack-cinder-scheduler\
 )

#echo "${osservices[@]}"


for i in "${osservices[@]}"
do 
  REZ=$(systemctl is-enabled $i.service 2>&-)
  if [[ $REZ == "enabled" ]];then
    printf "$i ==> ${GREEN}${GREEN}OK${NC}\n" 
  else
  	printf "$i ==> ${RED}NOK${NC}\n" 
  	#printf "$i ==> \x1b[5m NOK x1b[25m \n"
  fi
  #echo $REZ
  
 done

 
