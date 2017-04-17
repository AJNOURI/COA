## Instances

### 1. (Keypair) From demo account, generate a public keypair named **mypubkey1** for use with openstack instances   

    nova keypair-add key1 > key1.pem  
    chmod 600 key1.pem  
    nova keypair-list

  

### 2. (Flavor) From admin account, create a new flavor named m1.extra_tiny with 
 * RAM: 64mb    
 * Root disk size: 0  
 * cpu: 1  

-

    . admin_rc.sh  
    nova flavor-list  
    nova flavor-create m1.extra_tiny auto 64 0 1 --rxtx-factor 1.0

  

### 3. Allow the tenant (project) "demo" to access the flavor

    openstack project list  
    nova flavor-access-add m1.extra_tiny <demo>  

**additional help**  
_delete_
get flavor id to delete  

    nova flavor-list  

delete flavor  

    nova flavor-delete <flavor-id>

  

### 4. Add new rules to the default security group "default" to allow access instances from internet through SSH, http and ICMP.
using openstack unified client:

    openstack security group rule create --proto icmp --src-ip 0.0.0.0/0 default
    openstack security group rule create --proto tcp --src-ip 0.0.0.0/0 --dst-port 22 default
    openstack security group rule create --proto tcp --src-ip 0.0.0.0/0 --dst-port 80 default

or

    nova secgroup-list    
    nova secgroup-list-rules default    
    nova secgroup-add-rule default tcp 22 22 0.0.0.0/0    
    nova secgroup-add-rule default tcp 80 80 0.0.0.0/0    
    nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0    


### 5. Provision the following instance
 * image: cirros-0.3.4-x86_64-uec
 * flavor: m1.tiny
 * keypair: key1
 * security group: default

-

    nova boot instance2   
    --image cirros-0.3.4-x86_64-uec --flavor m1.tiny --key-name key1 --security-group default  

### 6. Create a pair key with ssh-keygen (we want to have a keypair created outside of openstack). Now, add the created key  with openstack with name "mykey1"

    ssh-keygen -q -f <ssh-key>

This will generate a keypair:
 *  ssh-key: private key
 *  ssh-key.pub: public key
 
Using nova client:
    
    nova keypair-add --pub-key ssh-key.pub mykey1

Using openstack client:

    openstack keypair create --pub-key ssh-key.pub mykey1


### 7. This time, create a pair key directly with openstack and name it "mykey2"

Using openstack client:
    
    openstack keypair create mykey2 > mykey2.pem

Using nova client:
    
    nova keypair-add mykey2 > mykey2.pem


### 8. Provision the following instance  
name:  instance7  
image: cirros-0.3.4-x86_64-uec  
flavor: m1.tiny  
keypair: mykey1  
security group: default  
  
  
    openstack server create --image cirros-0.3.4-x86_64-uec --flavor m1.tiny --security-group default --key-name mykey1 --nic net-id=41c0a2ee-e780-4efe-beba-05abbb658b52 instance7

or

    nova boot --flavor m1.tiny --image cirros-0.3.4-x86_64-uec --key-name mykey1 --security-groups default --nic net-id=41c0a2ee-e780-4efe-beba-05abbb658b52 instance7
    
    
### 9. Create a floating IP (from the public subnet)and assign it to the instance7

    nova floating-ip-create
    nova floating-ip-associate instance7 <ex:172.24.4.231>
    
### 10. Log to the machine console using the keypair mykey1 using the floating IP assigned to the instance7

    ssh -i mykey1.pem ubuntu@<ex:172.24.4.231>




-----------

## Quotas

If you are not sure about the unit to use (in GB/MB), check the values displayed in the command:

    openstack quota show \<project\>

or under the appropriate authorized user:

    nova quota-show



### 1. Make sure tenant demo have the following limits

 - 15 backups   
 - 15 000 gigabytes   
 - 15 networks   
 - 15 subnets  

### 2. Make sure user demo from tenant demo have the following limits

 - 15 cpu cores 15  
 - floating ips  

-

    openstack project list

    cinder quotas-usage <project-id>
    cinder quotas-update --backups 15 --gigabytes 15 000 <project-id>

    neutron quota-show
    neutron quota-update --tenant <teanant-id> --network 15 --subnet --15

    nova quota-show --tenant <tenant-id>
    nova quota-update --tenant <tenant-id> --cpu <15> --floating_ips <15>

    nova limits --tenant <tenant-id>


### 3. Using p1_user1/openstack, check that project1 cannot create more instances
### 4. Make sure that users in project1 can create 2 more instances

    openstack quota set --instances 1 project1
  
### 5. Check that the new quotas is also applied for user=p1_user2,pass=openstack 
### 6. We want user=p2_user1,pass=openstack is able to create only 2 floating ips, but 5 floating ips for p2_user2/openstack

    nova quota-update --user p1_user1 --floating-ips 2 project2
    nova quota-update --user p1_user2 --floating-ips 5 project2


### 7. Change the default quotas for any new project to:  

 - max 5 instances 
 - max 5 cores  
 - max 55555 RAM  
 - max 55 floating_ips  

-

    nova quota-class-update --instances 5 --cores 5 --ram 55555 --floating_ips 55  default  

### 8. Create project "project3" and user "user3" within.  
Check the quotas for "project3".  
  
    openstack project create project3  
    openstack user create user3 --password user3 --project project3  
    nova quota-defaults  

### 9. Again, change the default quotas for any new project to:

 - max 2 instances
 - max 2 cores
 - max 22222 RAM
 - max 22 floating_ips

-

    nova quota-class-update --instances 2 --cores 2 --ram 22222 --floating_ips 22  default  

### 10. Create project "project4" and two users "user41" and "user42" within.  
(you can choose any password you like)  
Check the quotas for "user41" / "project3".  
Check the quotas for "user42" / "project3".  

    nova quota-class-update --instances 5 --cores 5 --ram 55555 --floating_ips 55  default  openstack user create user41 --password user41 --project project4  
    nova quota-class-update --instances 5 --cores 5 --ram 55555 --floating_ips 55  default  openstack user create user42 --password user42 --project project4  


### 11. Change the quotas for "user41" within "project4" to:  
 - max 1 instances  
 - max 1 cores  
 - max 11111 RAM  
 - max 11 floating_ips  
Check the quotas for "user41" / "project4".  
Check the quotas for "user42" / "project4".  
Check the default quotas  

-

    nova quota-update --instances 1 --ram 11111 --cores 1 --user \<user41_id\>  \<project4_id\>  
    nova quota-show --tenant \<project4\> --user \<user41_id\>  
    nova quota-show --tenant \<project4\> --user \<user42_id\>  

Notice the different quotas between a specific user within a project, the same project and the default quotas.  
