The following is a collection of exercices to get familiar with Openstack administration through the cli for the purpose of preparing for COA (Openstack Foundation Openstack Certified Administrator) exam:

### CLI administration section:

1. [Identity management](https://github.com/AJNOURI/COA/wiki/01.-Identity:-Keystone)
2. [Compute](https://github.com/AJNOURI/COA/wiki/02.-Compute:-Nova)
    * Instances
    * Quotas
3. [Glance](https://github.com/AJNOURI/COA/wiki/03.-Image:-Glance)
4. [Neutron](https://github.com/AJNOURI/COA/wiki/04.-Networking:-Neutron) 
5. [Cinder](https://github.com/AJNOURI/COA/wiki/05.-Block-Storage:-Cinder)
    * Instances snapshots    
    * Volume snapshots  
    * Volume backups
    * Volume encryption
6. [Swift](https://github.com/AJNOURI/COA/wiki/06.-Object-Storage:-Swift)
7. [Orchestration (heat)](https://github.com/AJNOURI/COA/wiki/07.-Orchestration:-Heat)
8. Telemetry (ceilometer)
9. [Database](https://github.com/AJNOURI/COA/wiki/09.-Database)

### Exam practice & labbing:

Browse the page http://hpnouri.free.fr/coa, you'll find a series of tasks you can try to perform on your own lab.
You can download the page [index.html](https://github.com/AJNOURI/ajnouri.github.io/blob/master/coa/index.html) and run a local webserver in the same directory    
ex: `python -m SimpleHTTPServer 12345`

By clicking on each tasks, the solution will be revealed.  
Make sure to avoid the **illusion of competency** by trying your best to solve the question and consulting the documentation [docs.openstack.org](docs.openstack.org), the only reference available in the exam, before looking the answer. 
This will help consolidating a mental process to get to the solution.    

### Troubleshooting section:

I am collecting all issues I've encountered during the learning process, mainly, [installing multinode openstack from scratch](http://docs.openstack.org/newton/install-guide-ubuntu/)

In the [issue section](https://github.com/AJNOURI/COA/issues), look for issues labeled **Troubleshooting**.
Opened issues are still under investigation, closed are solved.  
  
Even though different root causes could have the same symptoms and some solutions are curcumstantial, they still gives a hint on how processes and configuration files are interconnected.  
  
If you are lucky enough, you'll make a lot of mistakes to learn from and to be prepared for the exam :)  


#### Exam references

- [General inf. about the exam: cost, score, duration...](https://www.openstack.org/coa)  
- [The OpenStack Foundation Certification Candidate Handbook](https://www.openstack.org/assets/coa/COA-Candidate-Handbook-V1.5.62.pdf)  
- [Inside Certified Openstack Administrator exam](http://superuser.openstack.org/articles/inside-certified-openstack-administrator-exam/)
- [The exam environment: start the exam, interface, what you are allowed to do or not to do.](https://www.openstack.org/assets/coa/os-tipsdocument-0423.pdf)  
- [The Operators' View on the Certified OpenStack Administrator Exam](https://www.youtube.com/watch?v=2NvMgdI1m1I)  
- [The Test Takers Guide to the Certified OpenStack Administrator](https://youtu.be/EXckOKPtSZQ)
- [Prepping for the OpenStack Administrator Exam](https://youtu.be/JGzDgnSex00)
- [Passing the Certified OpenStack Administrator Test](https://youtu.be/p2_Z8WCqkTU)

## VERY IMPORTANT!
Your contribution is very welcome and encouraged for both the content and the form.

----------------

#### Documentation
* [Openstack official Documentation](http://docs.openstack.org/)  
* [Troubleshooting swift](http://docs.openstack.org/admin-guide/objectstorage-troubleshoot.html)   




