### 1. Retrieve Ubuntu cloud image file from the following link:
* https://cloud-images.ubuntu.com/trusty/current/trusty-server-cloudimg-amd64-disk1.img

`wget https://cloud-images.ubuntu.com/trusty/current/trusty-server-cloudimg-amd64-disk1.img`  

- Create an image named "ubuntu-trusty" from the downoaded image file
`glance image-create --progress --name ubuntu-trusty --file trusty-server-cloudimg-amd64-disk1.img --disk-format qcow2 --container-format bare`

-Start an instance named "u1" from the following parameters:
* image: "ubuntu-trusty"
* flavor: m1.small
* key: key31
* security group: default

`nova boot u2 --image ubuntu-trusty --flavor m1.small --key-name key1 --security-group default`

### 2. Retrieve Debian cloud image file from the following link:
* http://cdimage.debian.org/cdimage/openstack/8.7.0-20170114/debian-8.7.0-openstack-amd64.qcow2

`wget https://http://cdimage.debian.org/cdimage/openstack/8.7.0-20170114/debian-8.7.0-openstack-amd64.qcow2`  

-Create an image named "debian87" from the downoaded image file
`glance image-create --progress --name debian87 --file debian-8.7.0-openstack-amd64.qcow2 --disk-format qcow2 --container-format bare`

-Start an instance named "u2" from the following parameters:
* image: "debian87"
* flavor: m1.small
* key: key32
* security group: default

`nova boot u2 --image debian87 --flavor m1.small --key-name key1 --security-group default`



----------

**Docs:**  
http://docs.openstack.org/user-guide/common/cli-manage-images.html
