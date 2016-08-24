I am trying to create a volume, put some data, snapshot it, create a new volume from the snapshot, delete original volume and its snapshot, and recover the data from the new volume, but I cannot recover the original data:

1- Create a volume  
2- Create an instance  
3- Attach the volume to the instance  
4- Console to the instnce  
5- Format, mount the partition and create a file in the mounting directory   /mnt/vdb  
6- Detach the volume  
7- Create a snapshot of the volume  
8- Create a volume from the snapshot  
9- Delete the original volume and its snapshot  
10- Attach the volume created from the snapshot to the instance  
11- Console to the instance  
==> no trace of the created file  





**1- Create a volume**

    cinder create --name vol1 1

**2- Create an instance**

    root@ubuntu-openstack-liberty23082016-123009:~# nova boot --flavor m1.tiny --security-groups new-secgroup --image cirros-0.3.4-x86_64-uec instance1


**3- Attach the volume to the instance**

    root@ubuntu-openstack-liberty23082016-123009:~# nova volume-attach a0342488-3c72-4791-ae5e-ce18a5566526 90d3913f-f3a0-4caa-aeab-53b7ca360881
    +----------+--------------------------------------+
    | Property | Value                                |
    +----------+--------------------------------------+
    | device   | /dev/vdb                             |
    | id       | 90d3913f-f3a0-4caa-aeab-53b7ca360881 |
    | serverId | a0342488-3c72-4791-ae5e-ce18a5566526 |
    | volumeId | 90d3913f-f3a0-4caa-aeab-53b7ca360881 |
    +----------+--------------------------------------+



**4- Console to the instnce**

    root@ubuntu-openstack-liberty23082016-123009:~# ssh cirros@10.0.0.3

**5- Format, mount the partition and create a file in the mounting directory /mnt/vdb**

    sudo mkfs.ext3 /dev/vdb
    sudo mount /dev/vdb /mnt/vdb
    
    $ echo "data" > /mnt/vdb/testfile.txt
    $ sync && sleep2
    $ exit

**6- Detach the volume**

    root@ubuntu-openstack-liberty23082016-123009:~# nova volume-detach a0342488-3c72-4791-ae5e-ce18a5566526 90d3913f-f3a0-4caa-aeab-53b7ca360881

**7- Create a snapshot of the volume**

    root@ubuntu-openstack-liberty23082016-123009:~# cinder snapshot-create --name snapshot-of-vol1 90d3913f-f3a0-4caa-aeab-53b7ca360881
    +-------------+--------------------------------------+
    |   Property  |                Value                 |
    +-------------+--------------------------------------+
    |  created_at |      2016-08-24T00:47:09.788915      |
    | description |                 None                 |
    |      id     | bc953f1d-ff98-415e-a4ff-f22d4c70f1ac |
    |   metadata  |                  {}                  |
    |     name    |           snapshot-of-vol1           |
    |     size    |                  1                   |
    |    status   |               creating               |
    |  volume_id  | 90d3913f-f3a0-4caa-aeab-53b7ca360881 |
    +-------------+--------------------------------------+
    root@ubuntu-openstack-liberty23082016-123009:~# cinder snapshot-list
    +--------------------------------------+--------------------------------------+-----------+------------------+------+
    |                  ID                  |              Volume ID               |   Status  |       Name       | Size |
    +--------------------------------------+--------------------------------------+-----------+------------------+------+
    | bc953f1d-ff98-415e-a4ff-f22d4c70f1ac | 90d3913f-f3a0-4caa-aeab-53b7ca360881 | available | snapshot-of-vol1 |  1   |
    +--------------------------------------+--------------------------------------+-----------+------------------+------+

**8- Create a volume from the snapshot**

    root@ubuntu-openstack-liberty23082016-123009:~# cinder create --snapshot-id bc953f1d-ff98-415e-a4ff-f22d4c70f1ac --name vol2-from-snapshot-of-vol1
    
    root@ubuntu-openstack-liberty23082016-123009:~# cinder list
    +--------------------------------------+-----------+----------------------------+------+-------------+----------+-------------+-------------+
    |                  ID                  |   Status  |            Name            | Size | Volume Type | Bootable | Multiattach | Attached to |
    +--------------------------------------+-----------+----------------------------+------+-------------+----------+-------------+-------------+
    | 90d3913f-f3a0-4caa-aeab-53b7ca360881 | available |            vol1            |  1   | lvmdriver-1 |  false   |    False    |             |
    | e2a5b327-2485-42a2-b97f-6e76d5327b52 | available | vol2-from-snapshot-of-vol1 |  1   | lvmdriver-1 |  false   |    False    |             |
    +--------------------------------------+-----------+----------------------------+------+-------------+----------+-------------+-------------+


**9- Delete the original volume and its snapshot**

    root@ubuntu-openstack-liberty23082016-123009:~# cinder snapshot-delete bc953f1d-ff98-415e-a4ff-f22d4c70f1ac
    root@ubuntu-openstack-liberty23082016-123009:~# cinder delete 90d3913f-f3a0-4caa-aeab-53b7ca360881
    Request to delete volume 90d3913f-f3a0-4caa-aeab-53b7ca360881 has been accepted.



    root@ubuntu-openstack-liberty23082016-123009:~# cinder list

    +--------------------------------------+-----------+----------------------------+------+-------------+----------+-------------+-------------+
    |                  ID                  |   Status  |            Name            | Size | Volume Type | Bootable | Multiattach | Attached to |
    +--------------------------------------+-----------+----------------------------+------+-------------+----------+-------------+-------------+
    | e2a5b327-2485-42a2-b97f-6e76d5327b52 | available | vol2-from-snapshot-of-vol1 |  1   | lvmdriver-1 |  false   |    False    |             |
    +--------------------------------------+-----------+----------------------------+------+-------------+----------+-------------+-------------+
    root@ubuntu-openstack-liberty23082016-123009:~# nova list
    +--------------------------------------+-----------+--------+------------+-------------+--------------------------------------------------------+
    | ID                                   | Name      | Status | Task State | Power State | Networks                                               |
    +--------------------------------------+-----------+--------+------------+-------------+--------------------------------------------------------+
    | a0342488-3c72-4791-ae5e-ce18a5566526 | instance1 | ACTIVE | -          | Running     | private=10.0.0.3, fdac:2033:33e4:0:f816:3eff:fed2:d970 |
    +--------------------------------------+-----------+--------+------------+-------------+--------------------------------------------------------+

**10- Attach the volume created from the snapshot to the instance**

    root@ubuntu-openstack-liberty23082016-123009:~# nova volume-attach a0342488-3c72-4791-ae5e-ce18a5566526 e2a5b327-2485-42a2-b97f-6e76d5327b52
    +----------+--------------------------------------+
    | Property | Value                                |
    +----------+--------------------------------------+
    | device   | /dev/vdb                             |
    | id       | e2a5b327-2485-42a2-b97f-6e76d5327b52 |
    | serverId | a0342488-3c72-4791-ae5e-ce18a5566526 |
    | volumeId | e2a5b327-2485-42a2-b97f-6e76d5327b52 |
    +----------+--------------------------------------+

**11- Console to the instance**

    root@ubuntu-openstack-liberty23082016-123009:~# ssh cirros@10.0.0.3
    cirros@10.0.0.3's password: 
    $ 
    $ df -h
    Filesystem                Size      Used Available Use% Mounted on
    /dev                    242.2M         0    242.2M   0% /dev
    /dev/vda                 23.2M      9.6M     12.4M  44% /
    tmpfs                   245.8M         0    245.8M   0% /dev/shm
    tmpfs                   200.0K    108.0K     92.0K  54% /run
    /dev/vdb               1007.9M     33.3M    923.4M   3% /mnt/vdb
    $ cd /mnt/vdb
    $ ls
    $

==> no trace of the created file



