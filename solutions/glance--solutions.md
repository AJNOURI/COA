### 1. Retrieve Ubuntu cloud image file from the following link:
* https://cloud-images.ubuntu.com/trusty/current/trusty-server-cloudimg-amd64-disk1.img

`wget https://cloud-images.ubuntu.com/trusty/current/trusty-server-cloudimg-amd64-disk1.img`  

### 2. Create an image named "ubuntu-trusty" from the downoaded image file
`glance image-create --progress --name ubuntu-trusty --file trusty-server-cloudimg-amd64-disk1.img --disk-format qcow2 --container-format bare`

### 3. Start an instance named "u1" from the following parameters:
* image: "ubuntu-trusty"
* flavor: m1.small
* key: key1
* security group: default

`nova boot u2 --image ubuntu-trusty --flavor m1.small --key-name key1 --security-group default`

----------

**Docs:**  
http://docs.openstack.org/user-guide/common/cli-manage-images.html
