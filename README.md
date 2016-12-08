The following is a collection of exercices to get familiar with Openstack administration through the cli for the purpose of preparing for COA (Openstack Foundation Openstack Certified Administrator) exam:

### CLI administration section:

1. [Identity management](https://github.com/AJNOURI/COA/wiki/01.-Identity-management)
2. [Compute](https://github.com/AJNOURI/COA/wiki/02.-Compute)
  * Instances
  * Quotas
3. [Glance](https://github.com/AJNOURI/COA/wiki/03.-Glance)
4. [Cinder](https://github.com/AJNOURI/COA/wiki/04.-Cinder)
  * Instances snapshots    
  * Volume snapshots  
  * Volume backups
  * Volume encryption
5. [Orchestration (heat)](https://github.com/AJNOURI/COA/wiki/05.-Orchestration)


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

## VERY IMPORTANT!
Your contribution is very welcome and encouraged for both the content and the form.

----------------

#### Documentation
* [Openstack official Documentation](http://docs.openstack.org/)  
* [Troubleshooting swift](http://docs.openstack.org/admin-guide/objectstorage-troubleshoot.html)   
  
#### Exam references
* https://www.openstack.org/coa/  
* https://youtu.be/JGzDgnSex00  
* https://youtu.be/EXckOKPtSZQ  
* https://youtu.be/p2_Z8WCqkTU  
