Beforehand, you need to know this inf. :

* auth url v3       : --os-auth-url ==>  http://controller:5000/v3/
* project domain id : --os-project-domain-id ==> default  
* user domain id    : --os-user-domain-id ==> default 
* project name      : --os-project-name ==> admin 
* user name         : --os-username ==> admin 
* type of password  : --os-auth-type ==> password

1- Get the project name & id:  

	openstack --os-auth-url http://146.20.103.97:5000/v3/ --os-project-domain-id default --os-user-domain-id default --os-project-name admin --os-username admin --os-auth-type password project list 
	+----------------------------------+--------------------+
	| ID                               | Name               |
	+----------------------------------+--------------------+
	| 0de5a13d471c44e3857a3fc4f3e7e4a2 | admin              |
	| 17622193872e411693ffc94a3f66e0c2 | invisible_to_admin |
	| 5e840ee451394544aa74572a7c1d3a10 | swifttenanttest2   |
	| 6623ba56d0454aeaa160a0da382743e1 | alt_demo           |
	| a06a5c9476914d30aa098a875fd6000a | service            |
	| a658429b57744777acff7662a5908414 | demo               |
	| e153cbab04e94483b31999911f86e0c3 | swifttenanttest1   |
	+----------------------------------+--------------------+
	
2- Get the neutron endpoint id:  

	openstack --os-auth-url http://146.20.103.97:5000/v3/ --os-project-domain-id default --os-user-domain-id default --os-project-name admin --os-username admin --os-auth-type password endpoint list
	+----------------------------------+-----------+--------------+----------------+
	| ID                               | Region    | Service Name | Service Type   |
	+----------------------------------+-----------+--------------+----------------+
	| 5e8b696ea7a54cd0b6fe6c52a661b562 | RegionOne | cinder       | volume         |
	| ce97f948b71b41bda0c8d2d658fabdfb | RegionOne | heat-cfn     | cloudformation |
	| 9e36e0147c424808a50f5158e6602b5e | RegionOne | ec2          | ec2            |
	| db79ca1ab2cc4ee394a6f099a0116592 | RegionOne | swift        | object-store   |
	| bad4159e2b934c429237f4d7c057a648 | RegionOne | heat         | orchestration  |
	| 06bd474c949d4a09ad3e4b5edd071ece | RegionOne | nova_legacy  | compute_legacy |
	| 667575c147c148d3abb588a78bb95836 | RegionOne | s3           | s3             |
	| 136c945e5fb4452b8e2b166d4e58e4ca | RegionOne | keystone     | identity       |
	| 8764dfbdde15439088e7d071baaef85f | RegionOne | glance       | image          |
	| dcca53e3cc454aea9fa90c213f531255 | RegionOne | neutron      | network        |
	| 9cc0724e94104a35b49d0f82d41bc7f2 | RegionOne | nova         | compute        |
	| ae6e741b265846d4b7bda275eee07dc5 | RegionOne | cinderv2     | volumev2       |
	+----------------------------------+-----------+--------------+----------------+

3- Using endpoint id, get the auth. url

	openstack --os-auth-url http://146.20.103.97:5000/v3/ --os-project-domain-id default --os-user-domain-id default --os-project-name admin --os-username admin --os-auth-type password endpoint show 136c945e5fb4452b8e2b166d4e58e4ca
	+--------------+----------------------------------+
	| Field        | Value                            |
	+--------------+----------------------------------+
	| adminurl     | http://146.20.103.97:35357/v2.0  |
	| enabled      | True                             |
	| id           | 136c945e5fb4452b8e2b166d4e58e4ca |
	| internalurl  | http://146.20.103.97:5000/v2.0   |
	| publicurl    | http://146.20.103.97:5000/v2.0   |
	| region       | RegionOne                        |
	| service_id   | be39f289337e44c1945cd5fd87f28dac |
	| service_name | keystone                         |
	| service_type | identity                         |
	+--------------+----------------------------------+

4- Build the file with 5 variables:
- auth. url
- tenant id + name
- username + password

	\#\!/bin/bash  
	export OS_AUTH_URL=http://146.20.103.97:35357/v2.0  
	export OS_TENANT_ID=0de5a13d471c44e3857a3fc4f3e7e4a2  
	export OS_TENANT_NAME="admin"  
	export OS_USERNAME="admin"  
	export OS_PASSWORD="openstack"  

5- source the file  

6- Now you should be able to use openstack unified client without issuing credentials:  
  
	ex: openstack user list  
	+----------------------------------+----------------+
	| ID                               | Name           |
	+----------------------------------+----------------+
	| 1069f6cf77c047829784bcb5210ba6e0 | swift          |
	| 22752b77c3004ce487d3dcf557d5f7e9 | nova           |
	| 2e5d52a88f0044588144556548531532 | neutron        |
	| 4656431621b646d1b204b88aeb8e797a | heat           |
	| 51376ec8c3da43a4aaa9f37a039cfdb9 | demo           |
	| 74fe142bcbea417895a255ebfde6139d | glance         |
	| 8635548f02c448e9afb87ba5c3056208 | alt_demo       |
	| 8b64e4e7806f412aaf686940961c5c15 | swiftusertest1 |
	| a2ec7829f4f24b62a850e7346686096b | admin          |
	| cf971ee1c26241db9f5d302174b41b3a | cinder         |
	| d62221ade317410abb0d57a1ce74887a | swiftusertest2 |
	| e407edf26ad447dd8e78a34853af0405 | swiftusertest3 |
	| edec55b242ea4259a7e39d0a154e662a | glance-swift   |
	+----------------------------------+----------------+
