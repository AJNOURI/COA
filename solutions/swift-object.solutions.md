### 1. Create user1, user2 and user3 under tenant "swift-company"  
### 2. Create three text files "text1.txt, text2.txt and text3.txt" and upload them to a container "container-test1"
touch text1.txt text2.txt text3.txt  
```
swift upload container-test1 text1.txt  
swift upload container-test1 text2.txt  
swift upload container-test1 text3.txt  
```

### 3. Create a text file "text4.txt and upload it to a container "container-test2"  
```
touch text4.txt   
swift upload container-test2 text4.txt   
```

### 4. Make sure container "container-test1" is publically accessible, but NOT "container-test2".  
`swift post container-test1 --read-acl .r:*,.rlistings`  

### 5. Make "container-test2" accessible only to user3.  
`swift post container-test1 -r swift-company:user3`  

### 6. Remove both text files from the local directory.  
`rm text*.txt`  

### 7. Restore the deleted files from the container.  
`swift download container-test1`  

### 8. We do not need text3.txt anymore, delete it from the container.  
`swift delete container-test1 text3.txt`  

### 9. Some clients wants to have access to text1.txt and text2.txt, provide files urls to them.  
`swift stat -v container-test1 text1.txt`  
`swift stat -v container-test1 text2.txt`  

### 10. It was decided to make container-test1 available until the next month, after that it should be deleted.  

- example of current date in epoch format: `date +%s`  
- In the same epoch format, choose a month from now: 
`date -d "Sat Oct 22 06:14:01 UTC 2016" +%s`  
> 1459405259    

**A) Using swift command**

`swift post container-test1 image.png -H X-Delete-At:1459405259`

**B) Using REST query**

- get URL & Auth token  
`swift list container-test1`  
`swift stat -v container-test1 image.png`  

URL : http://146.20.105.173:8080/v1/AUTH_abeaccbd32f9430884191236701c33cd/container-test1/image.png  
Auth Token: 2df95274b53b4d75aa0815c5b806e415  


```
curl -X POST -H 'X-Auth-Token: 501ca051c6644ea5be05d1ab96e57ceb' -H 'X-Delete-On: 1459405259'   http://104.239.168.42:8080/v1/AUTH_abeaccbd32f9430884191236701c33cd/container-test1/image.png  
```

### 11. Monitor the space left for object storage  


**A) Single node:**


We need to determine the partitons used for storage.
On storage nodes, in the Swift configuration files:

* /etc/swift/account-server.conf
* /etc/swift/container-server.conf
* /etc/swift/object-server.conf

under **[DEFAULT]** section look for "**devices=**"

_For example:_


`for i in $(find /etc/swift -name '*.conf'); do cat $i | grep -v ^# | grep devices; done`
> devices = /srv/node
> devices = /srv/node
> devices = /srv/node

Now look for mount directories in the list of disk usage df command:

`df -h`
> Filesystem      Size  Used Avail Use% Mounted on  
> /dev/xvda1      158G   12G  140G   8% /  
> devtmpfs        3.9G     0  3.9G   0% /dev  
> tmpfs           3.7G  4.0K  3.7G   1% /dev/shm  
> tmpfs           3.7G   33M  3.7G   1% /run  
> tmpfs           3.7G     0  3.7G   0% /sys/fs/cgroup  
> /dev/loop0      1.9G  6.1M  1.7G   1% /srv/node/swiftloopback  
> tmpfs           757M     0  757M   0% /run/user/0  
  
  
in this case:  
> /dev/loop0      1.9G  6.1M  1.7G   1% /srv/node/swiftloopback  



**B) For multi-storage nodes**

You can check the nodes on the controller for accounts, containers and object servers
* swift-ring-builder account.builder  
* swift-ring-builder container.builder  
* swift-ring-builder object.builder  


ex:

`\#swift-ring-builder account.builder`
> account.builder, build version 4  
> 1024 partitions, 3.000000 replicas, 1 regions, 4 zones, 4 devices, 100.00 balance, 0.00 dispersion  
> The minimum number of hours before a partition can be reassigned is 1  
> The overload factor is 0.00% (0.000000)  
> Devices:    id  region  zone      ip address  port  replication ip  replication port      name weight partitions  balance meta  
>              0       1     1       10.0.0.51  6002       10.0.0.51              6002      sdb  100.00          0   -100.00  
>              1       1     2       10.0.0.51  6002       10.0.0.51              6002      sdc  100.00          0 -100.00  
>              2       1     3       10.0.0.52  6002       10.0.0.52              6002      sdb  100.00          0 -100.00  
>              3       1     4       10.0.0.52  6002       10.0.0.52              6002      sdc  100.00          0 -100.00  

and monitor listed partition usage
