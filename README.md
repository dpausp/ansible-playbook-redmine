Ansible Redmine + Git Playbook
==============================

An Ansible playbook for installing redmine + gitolite + redmine\_git\_hosting on nginx and PostgreSQL.
Ansible 1.5+ is required.

Running The Playbook
--------------------

You must be able to login as root via SSH with pubkey authentication to use this style. A user with sudo rights may also work (untested). 
Full install with all plugins:

    ansible-playbook -i hosts all site.yml

__Important__

Currently, only installing components on a single host is supported. Please specify the same host for all sections in the hosts file, like in the hosts.example file. Support for multiple hosts will be added later.

You must have "-i" in your Ansible sudo\_flags (in ansible.cfg). If not, use something like:

    ANSIBLE_SUDO_FLAGS="-i" ansible-playbook -i hosts all site.yml



