# Testing Branch Working Document

### Workflow
* Deploy ansible-user
  * May be able to use existing ansible-user.yml playbook, except:
    * Windows
    * FreeBSD (maybe) -- [BSD Guide](https://docs.ansible.com/ansible/latest/os_guide/intro_bsd.html)
* Start VM
  * virt-start-stop.yml
  * [community.libvirt.virt module](https://docs.ansible.com/ansible/latest/collections/community/libvirt/virt_module.html#ansible-collections-community-libvirt-virt-module)
* Check disk space??
* Patch VM
  * Testing
    * Snapshot
    * Update (make sure it only updates existing versus installing new/all packages
  * Start with patch-other-linux-vms.yml?
  * [ansible.builtin.package](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/package_module.html#ansible-collections-ansible-builtin-package-module)
* Reboot VM
  * Start with reboot-rhel6.yml
    * Add wait_until
  * [ansible.builtin.reboot module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/reboot_module.html#ansible-collections-ansible-builtin-reboot-module)
* Get Version
  * Via setup?
* Shutdown VM
  * virt-start-stop.yml
  * [community.libvirt.virt module](https://docs.ansible.com/ansible/latest/collections/community/libvirt/virt_module.html#ansible-collections-community-libvirt-virt-module)
 

### Distros
* Fedora/CentOS
* Debian
* Ubuntu
* Slackware
* openSuSE
* FreeBSD
* Windows(?)
 
 
### EE Build
* Collections
  * community.libvirt
* Packages
  * python3-libvirt
  * libguestfs-tools
