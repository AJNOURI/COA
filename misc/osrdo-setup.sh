#!/bin/bash

# Prepare the host
systemctl disable firewalld
systemctl stop firewalld
systemctl disable NetworkManager
systemctl stop NetworkManager
systemctl enable network
systemctl start network

# Install repository
yum install -y centos-release-openstack-newton
yum install -y https://rdoproject.org/repos/rdo-release.rpm
yum update -y

# Install openstack
yum install -y openstack-packstack
# Change interface name facing extenal network according to your needs.
packstack --allinone --provision-demo=n --os-neutron-ovs-bridge-mappings=extnet:br-ex --os-neutron-ovs-bridge-interfaces=br-ex:eno16777736 --os-neutron-ml2-type-drivers=vxlan,flat
