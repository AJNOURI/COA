#!/bin/bash
# load script from internet
# $1 script argument for the controller IP
# Create a keystone authentication tamplate file
controller=$1
usage(){
  echo ""
  echo "Usage: $0 {controller_IP}"
  echo ""
  exit 1
}

if [ "$#" -ne 1 ]; then
  usage
fi

ipcheck(){
  if [[ "$controller" =~ ^([0-9]{1,3})[.]([0-9]{1,3})[.]([0-9]{1,3})[.]([0-9]{1,3})$ ]]
  then
      for (( i=1; i<${#BASH_REMATCH[@]}; ++i ))
      do
        (( ${BASH_REMATCH[$i]} <= 255 )) || { echo "BAD IP entered" >&2; exit 1; }
      done
  else
        echo "BAD IP entered" >&2
        exit 1;
  fi
}

cat <<EOFMOTD > ~/keystone_auth
unset OS_SERVICE_TOKEN
export OS_USERNAME=\$1
export OS_PASSWORD=\$2
export PS1='[\u@\h \W(\$1)]\$ '
export OS_AUTH_URL=http://$1:5000/v2.0
export OS_TENANT_NAME=\$3
export OS_IDENTITY_API_VERSION=2.0
EOFMOTD

function log {

	echo ""
	echo " ======> $1 "
	echo ""
}


source keystonerc_admin

#####################################
# Task quotas
#####################################




# 1. Nova exercics
# create projects


log 'Creating projects'

openstack project create --enable project1
project1_id=$(openstack project list | grep project1 | awk '{print $2}')

openstack project create --enable project2
project2_id=$(openstack project list | grep project2 | awk '{print $2}')

# create the users
[ $? ] && osmember='_member_' ||  osmember='Member'

log 'Creating user & memership to projects'

openstack user create --project project1 --password openstack --enable p1_user1
openstack role add --project project1 --user p1_user1 $(echo $osmember)
openstack user create --project project1 --password openstack --enable p1_user2
openstack role add --project project1 --user p1_user2 $(echo $osmember)

openstack user create --project project2 --password openstack --enable p2_user1
openstack role add --project project2 --user p2_user1 $(echo $osmember)
openstack user create --project project2 --password openstack --enable p2_user2
openstack role add --project project2 --user p2_user2 $(echo $osmember)


log 'Creating Keypairs'
# create keypairs with the appropriate authorization
source keystone_auth p1_user1 openstack  project1
nova keypair-add p1_user1_kp > p1_user1_kp.pem
nova keypair-list

source keystone_auth p1_user2 openstack  project1
nova keypair-add p1_user2_kp > p1_user2_kp.pem
nova keypair-list

source keystone_auth p2_user1 openstack  project2
nova keypair-add p2_user1_kp > p2_user1_kp.pem
nova keypair-list

source keystone_auth p2_user2 openstack  project2
nova keypair-add p2_user2_kp > p2_user2_kp.pem
nova keypair-list


log 'Creating network and subnets'
source keystone_auth admin openstack admin
# create new network & subnet
openstack network create --project project1 --no-share p1_net1
#p1_net1_id=openstack network list | grep p1_net1 | awk '{print $2}'
#openstack subnet create --project project1 --subnet-range 11.0.0.0/24 --dns-nameserver 8.8.8.8 --allocation-pool start=11.0.0.2,end=11.0.0.100 --dhcp  --network p1_net1 p1_subnet1
neutron subnet-create --tenant-id $project1_id --gateway 11.0.0.254 --allocation-pool start=11.0.0.1,end=11.0.0.253 --dns-nameserver 8.8.8.8 --enable-dhcp p1_net1 --name p1_subnet1 11.0.0.0/24

openstack network create --project project2 --no-share p2_net1
#p1_net1_id=openstack network list | grep p1_net1 | awk '{print $2}'
#openstack subnet create --project project2 --subnet-range 22.0.0.0/24 --dns-nameserver 8.8.8.8 --allocation-pool start=22.0.0.2,end=22.0.0.100 --dhcp  --network p2_net1 p2_subnet1
neutron subnet-create --tenant-id $project2_id --gateway 22.0.0.254 --allocation-pool start=22.0.0.1,end=22.0.0.253 --dns-nameserver 8.8.8.8 --enable-dhcp p2_net1 --name p2_subnet1 22.0.0.0/24


log 'Modifiyng seucity group'
source keystone_auth p1_user1 openstack  project1
openstack security group rule create --proto tcp --dst-port 22 default
nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0

source keystone_auth p2_user1 openstack  project2
openstack security group rule create --proto tcp --dst-port 22 default
nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0


log 'Starting router and connecting subnet'
neutron router-create routerp1
neutron router-gateway-set routerp1 public
neutron router-interface-add routerp1 p1_subnet1


log 'Starting instance'
p1_net1_id=$(openstack network list | grep p1_net1 | awk '{print $2}')
source keystone_auth p1_user1 openstack  project1
openstack server create --image cirros --flavor m1.tiny --security-group default --key-name p1_user1_kp --nic net-id=$p1_net1_id instance7
#nova boot --flavor m1.tiny --image cirros-0.3.4-x86_64-uec --key-name mykey1 --security-groups default --nic net-id=41c0a2ee-e780-4efe-beba-05abbb658b52 instance7
