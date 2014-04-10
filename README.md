Ansible Redmine + Git Playbook
==============================

An Ansible playbook for installing redmine + gitolite + redmine\_git\_hosting on nginx and PostgreSQL.
Ansible 1.4 is required.

Playbook Preparation
--------------------

* copy secret\_passwords.yml.example to secret\_passwords.yml and set passwords. Passwords must be kept secret! The file can be destroyed after a successful installation. Keep the passwords in a safe place!
* roles/redmine/files/redmine\_key.pub must be a public ssh key (file containing the key or link to a file). This key will be used for a part of the installation which does not require root permissions. The public key will be copied to the target machine, the private key is never copied.
* copy hosts.example to hosts and set target host.
* edit 
  

Running The Playbook
--------------------

You must be able to login as root via SSH with pubkey authentication to use this style. A user with sudo rights may also work (untested). 
Full install with all plugins:

    ansible-playbook -i hosts all site.yml

__Important__

Currently, only installing components on a single host is supported. Please specify the same host for all sections in the hosts file, like in the hosts.example file. Support for multiple hosts will be added later.

You must have "-i" in your Ansible sudo\_flags (in ansible.cfg). If not, use something like:

    ANSIBLE_SUDO_FLAGS="-i" ansible-playbook -i hosts all site.yml
