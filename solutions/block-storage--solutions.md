# Cinder tasks solutions 

## Instance snapshots

 > _Remember, a snapshot of instance/volume is not usable directly, you need to create instance/volume from it._

### 1. Create an instance "instance1" from cirros-0.3.4-x86_64-uec image and ssh to it. 
* image: cirros-0.3.4-x86_64-uec
* flavor: m1.tiny
* keypair: key1
* security group: new-secgroup

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)

Make sure, you have a key and the appropriate ICMP and SSH rules in place:

    nova keypair-add key1 > key1.pem  
    chmod 600 key1.pem  
    nova keypair-list  

    nova secgroup-list  
    nova secgroup-list-rules new_secgroup  
    nova secgroup-add-rule new_secgroup tcp 22 22 0.0.0.0/0  
    nova secgroup-add-rule new_secgroup icmp -1 -1 0.0.0.0/0  

    nova boot --image cirros-0.3.4-x86_64-uec --flavor m1.tiny --key_name key1 instance1

### 2. inside the home directory of "instance2" create a file testfile.txt 

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  
    ssh -i key1.pem cirros@<instance2-ip>
    touch testfile.txt


### 3. take a snapshot of instance "instance2", name it "snapshot-of-instance2"

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  
    nova image-create <snapshot-id> snapshot-of-instance1

### 4. terminate the instance "instance2"

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  
    nova delete <instance1-id>

### 5. Create an instance from "snapshot-of-instance2" and name it "instance-from-snapshot"

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  
    nova boot --flavor m1.tiny --key key1 --security-groups new-secgroup --snapshot <snapshot> instance2-from-instance1

### 6. inside the home directory of "instance-from-snapshot" verify the presence of the file "testfile.txt" 

  
---------

---------

---------
  
  

## Volume snapshots

### 1. Create a new empty volume "vol1" of a 1GB size  

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  
`cinder create --display-name <demo-volume1> <1>`  

### 2. Create an instance "instance1" from cirros-0.3.4-x86_64-uec image  
* image: cirros-0.3.4-x86_64-uec
* flavor: m1.tiny
* keypair: key1
* security group: new-secgroup

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  

Make sure, you have a key and the appropriate ICMP and SSH rules in place:

    nova keypair-add key1 > key1.pem  
    chmod 600 key1.pem  
    nova keypair-list  

    nova secgroup-list  
    nova secgroup-list-rules new_secgroup  
    nova secgroup-add-rule new_secgroup tcp 22 22 0.0.0.0/0  
    nova secgroup-add-rule new_secgroup icmp -1 -1 0.0.0.0/0  

    nova boot --image cirros-0.3.4-x86_64-uec --flavor m1.tiny --key_name key1 --security-groups new-secgroup instance1 

  
  
### 3. Attach the created image "vol1" to the instance, "instance1", ssh to it and mount it to /mnt/vdb  

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  

    nova volume-attach <instance-id> <vol-id> /dev/vdb`  
    ssh -i key1.pem cirros@10.0.0.3  
    sudo fdisk /dev/vdb  
    sudo mount /dev/vdb /mnt

  

### 4. inside the attached volume (/mnt/vdb) create a file testfile.txt  

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  

    touch /mnt/vdb/testfile.txt  
    sync && sleep 2  

### 5. detach the colume "vol1" from the instance "instance1"  

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  

`nova volume-detach <instance-id> <vol-id> /dev/vdb`  
  
### 6. Take a snapshot of "vol1", name it "snapshot-of-vol1"   

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  

    cinder snapshot-create --name <snapshot-name> <vol-id>    
or  
  
    openstack snapshot create --name snapshot-of-vol1 <vol1-id>  
      
    cinder list    
    cinder snapshot-list     

  
### 7. create a volume from the snapshot  

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  

    cinder create --snapshot-id <snapshot-id> --name <new-vol>  
or
    
    openstack volume create --snapshot <snapshot-id> --size <1> <new-vol>
    cinder list 

### 8. reattach the first volume "vol1" to the instance "instance1"  

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  

    nova volume-attach <instance-id>  <vol-id>  

### 9. delete the previously created file "testfile.txt"  

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  
  
### 10. detach the colume "vol1" from the instance "instance1"  

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  

    nova volume-detach <instance-id> <vol-id> /dev/vdb  


### 11. attach the created volume "new-vol" to the instance "instance1"  

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  

    nova volume-attach <instance-id>  <vol-id>  

  
### 12. inside the attached volume verify the presence of the file "testfile.txt"   


-----------
-----------
-----------


## Volume Backups

### 1. Create a new empty volume "vol2" of a 1GB size  

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  

    cinder create --display-name <demo-volume1> <1>  
    cinder list   

 

### 2. Create an instance "instance3"
* image: cirros-0.3.4-x86_64-uec
* flavor: m1.tiny
* keypair: key1
* security group: default


![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  
        
nova boot --image cirros-0.3.4-x86_64-uec --flavor m1.tiny --key_name key1 instance3  
    nova list  --security-groups default

### 3. Attach the volume "vol2" it to the instance "instance3"  

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  

    nova volume-attach 253619cf-127c-46a1-a2aa-a273cedf6a85 2429b44b- cc42-4ebd-847c-fde00ea96649 /dev/vdb  

### 4. On "instance3", create, format and mount the new attached volume into a a directory, create a file testfile.txt and safely (after syn) umount the partition

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  

    sudo fdisk /dev/vdb
    sudo mkfs.ext4 /dev/vdb1
    sudo mount /dev/vdb1 /mnt/vdb1
    touch /mnt/vdb1/testfile.txt
    sync && sleep 2
    sudo umount /dev/vdb1 /mnt/vdb1
    

### 5. Detach the volume from the running instance  

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  

    nova volume-detach 253619cf-127c-46a1-a2aa-a273cedf6a85 2429b44b- cc42-4ebd-847c-fde00ea96649

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  

### 6. Backup the volume "vol2" into a volume "vol2-backup"  

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  

    cinder backup-show  
    cinder backup-list  
    cinder backup-create <vol-id>  

### 7. Remove the original volume "vol2"  

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  

    cinder delete <vol-id>  

### 8. Restore the backed up volume "vol2-backup"  

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  

    cinder backup-restore <vol-id>  

### 9. Delete the backup volume "vol2-backup"  

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  

    cinder backup-delete <backup-vol-id>  

### 10. Attach it to the running instance "instance3"  

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  

    nova volume-detach 253619cf-127c-46a1-a2aa-a273cedf6a85 2429b44b- cc42-4ebd-847c-fde00ea96649 /dev/vdb  

### 11. Inside the mounted partition, make sure the file "testfile.txt" exists  

    sudo mount /dev/vdb1 /mnt/vdb1 
    ls /mnt/vdb1

-----------
-----------
-----------



## Volume encryption  
  
### 1. Create the encrypted volume "encrypted-vol" (LUKS volume) of 1GB size  

If encrypted type LUKS is not recognized:

    openstack volume create --type LUKS --size 1 encrvol1
    Volume type with name LUKS could not be found. (HTTP 404)

Create it first:

    openstack volume type create LUKS
    cinder encryption-type-create --cipher aes-xts-plain64 --key_size 512 \
    --control_location front-end LUKS nova.volume.encryptors.luks.LuksEncryptor
    
No need for epiphany to find out how, check the [documentation (available on the exam)](http://docs.openstack.org/newton/config-reference/block-storage/volume-encryption.html):

configuration guides > Block storage service > Volume encryption ...

Then create a simple volume with LUKS type:

    openstack volume create --size 1 --type LUKS encr-vol1



![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  

    cinder create --display-name 'encrypted volume' --volume-type LUKS 1  
    cinder list  

### 2. Create an instance "instance4"  

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  

    chmod 600 key1.pem  
    nova keypair-add key1 > key1.pem  
    nova keypair-list  
    
    Security rule  
    nova secgroup-create new_secgroup "comments"  
    nova secgroup-add-rule new_secgroup tcp 22 22 0.0.0.0/0  
    nova secgroup-add-rule new_secgroup icmp -1 -1 0.0.0.0/0  
    
    nova boot --image cirros-0.3.4-x86_64-uec --flavor m1.tiny --key_name key1 --security-group new_secgroup instance4  
    
    nova list  
    ssh -i <ssh-key.pem> cirros@X.X.X.X  

### 3. Attach the encrypted volume to the machine  

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  
    
    nova volume-attach 253619cf-127c-46a1-a2aa-a273cedf6a85 2429b44b- cc42-4ebd-847c-fde00ea96649 /dev/vdb  
    
### 4. Create a file "testfile.txt" and syncronize the operations  

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  

    touch /mnt/vdb/testfile.txt  
    sync && sleep 2  

### 5. Check if you can see the encrypted volume on the block storage node directory

![](https://github.com/AJNOURI/COA/blob/master/misc/Selection_697.png)  

On the block storage node directory /dev/stack-volumes/volume-<id> 

    strings /dev/stack-volumes/volume-* | grep "testfile.txt"  

Because the volume is encrypted, you shouldn't be able to see the file.


-------------
#### Documentation:
* http://docs.openstack.org/user-guide/common/cli-manage-volumes.html
* http://docs.openstack.org/mitaka/config-reference/block-storage/volume-encryption.html






