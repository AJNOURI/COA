### 1. Create a router named "router11" bind the public network "public" as external network   

    openstack router create --enable router11  
    openstack router list  
    neutron router-gateway-set <router11-id> public  
  
### 2. create a private network named "p1_net2" under the project "project1" and under it a subnet with the following parameters  
* name = p1_subnet2  
* range 11.0.0.0/24  
* pool = 11.0.0.2 - 11.0.0.100  
* gateway = 11.0.0.254
* enable dhcp  
* dns = 8.8.8.8  

-

    openstack network create --project project1 --internal p1_net2  
    openstack subnet create --project project1 --subnet-range 11.0.0.0/24 --dns-nameserver 8.8.8.8 --allocation-pool start=11.0.0.2,end=11.0.0.100 --dhcp  --network p1_net1 p1_subnet1

or

    neutron subnet-create --tenant-id <project1-id> --gateway 11.0.0.254 --allocation-pool start=11.0.0.2,end=11.0.0.100 --dns-nameserver 8.8.8.8 --enable-dhcp p1_net2 --name p1_subnet2 11.0.0.0/24
  
### 3. Connect the subnet "p1_subnet2" to router "router11"  
    openstack router add subnet <router11-id> p1_subnet2  

