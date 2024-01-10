# Testing Branch Working Document

### Workflow
* Deploy ansible-user
  * May be able to use existing playbook, except Windows and maybe FreeBSD
* Start VM
  * https://docs.ansible.com/ansible/latest/collections/community/libvirt/virt_module.html#ansible-collections-community-libvirt-virt-module
* Patch VM
  * https://docs.ansible.com/ansible/latest/collections/ansible/builtin/package_module.html#ansible-collections-ansible-builtin-package-module
* Reboot VM
  * https://docs.ansible.com/ansible/latest/collections/ansible/builtin/reboot_module.html#ansible-collections-ansible-builtin-reboot-module
* Get Version
  * Via setup?
* Shutdown VM
  * https://docs.ansible.com/ansible/latest/collections/community/libvirt/virt_module.html#ansible-collections-community-libvirt-virt-module
 

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
