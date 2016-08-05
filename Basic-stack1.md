**Basic template1: **
- image
- flavor
- keypair  



==basic-hot1.yml ==

	heat_template_version: 2015-04-30
	
	description: Simple template to deploy a single compute instance
	
	resources:
	  my_instance:
	    type: OS::Nova::Server
	    properties:
	      key_name: mykey
	      image: cirros-0.3.4-x86_64-uec 
	      flavor: m1.tiny


*From cli:*

	heat stack-create -f basic-hot1.yml basic-stack1

![](http://hpnouri.free.fr/misc/Selection_177.png) 




Launch the same template a second time will create a new instance connected to the default private network.

*From cli:*

	heat stack-create -f basic-hot1.yml basic-stack12

![](http://hpnouri.free.fr/misc/Selection_181.png) 


