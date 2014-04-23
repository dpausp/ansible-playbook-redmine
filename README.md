Redmine Installation Playbook
=============================

[Ansible](http://ansible.com) Playbook + Vagrantfile for installing [Redmine](http://www.redmine.org) with local PostgreSQL database, Gitolite and many plugins (including git\_hosting, CRM, checklist and dmsf). 
Three installation methods are available:

* (A) universal [Vagrant](http://www.vagrantup.com) installer (recommended for first tests)
* (B) Vagrant with local Ansible
* (C) running the ansible playbook directly

* (A) and (B) will install Redmine to a local virtual machine (VM) provided by VirtualBox and managed by Vagrant (purpose: testing only!)
    * (A) installs everything to the VM and works on all operating systems which are supported by Vagrant (Windows, MacOS, Linux)
    * (B) uses Ansible (installed on your local machine) to provision a VM managed by Vagrant (Linux, MacOS)

* (C) uses Ansible on your local machine to install Redmine on a remote host via SSH (purpose: production or testing) 

TL;DR
-----

Install Redmine VM ([Vagrant 1.5](http://www.vagrantup.com) and [VirtualBox](https://www.virtualbox.org/) must be installed) with:

    git clone https://github.com/mediatum/ansible-playbook-redmine && cd ansible-playbook-redmine && vagrant up inabox

Playbook Structure
------------------

* the `playbook-redmine` subdirectory contains the playbook itself
    * if you like to see what this playbook does, please look at the subdirectories of `playbook-redmine/roles`. 
    * .yml files in `tasks/` directories contain the actual installation steps
    * if you like to know more about Ansible playbooks, please read the [Ansible Playbook Documentation](http://docs.ansible.com/playbooks.html)
* The `Vagrantfile` contains instructions for Vagrant how to setup a test virtual machine with Redmine automatically. 
     * This is described below in [(A)](#universal-vagrant-vm-installation-a) and [(B)](#using-ansible-for-vagrant-vm-provisioning-b).

Playbook Preparation
--------------------

In the `playbook-redmine` subdirectory:

* (optional) Create a file named `redmine_db_pass` in the playbook directory. Passwords must be kept secret! 
The file can be destroyed after a successful installation. Keep the passwords in a safe place!
If you do not specify a password, it will be generated and written to the file
* (optional) copy `group_vars/{role}.example` to `group_vars/{role}` and customize settings

If the settings are left unchanged, Redmine will be installed with a self signed SSL certificate, english locale and default paths under /srv. 
The server process is run by user `redmine` and `redmine_adm` is created as administrative account. 
You can log in as `redmine_adm` if you specify an existing SSH pubkey file with `redmine_adm_pubkeyfile` (in `group_vars/redmine`).

See [Customizing]("#customizing") for details.

  
Universal Vagrant VM Installation (A)
-------------------------------------

If you like to install Redmine on your local machine for testing purposes, you can use the [Vagrant](http://vagrantup.com) installation method.
This will install Redmine in a separate virtual machine. No changes will be made to your local system. 
VirtualBox and Vagrant (version 1.5+) must be installed.
A Debian Wheezy 7.4 system is used for the VM. You can edit the `Vagrantfile` to choose another system type. (for example, a 32bit Ubuntu)

Just run:

    vagrant up inabox

Port 3000 on localhost is forwarded to the VM, so Redmine can be reached like this after some minutes:

    https://localhost:3000
    
You can login with _admin_ as username and _admin_ as password.

If something wents wrong in the provisioning (look for "Running provisioner" in the output) step, you can try running it again in debug mode:

    VA_VERBOSE="vvvv" vagrant provision inabox

This may give you more information about why it fails. SSH problems are the most common cause.

To SSH into the box, use

    vagrant ssh inabox

The vagrant user is able to use passwordless sudo. 

The VM can be removed with:

    vagrant destroy inabox

Installing Ansible
------------------

_needed for method (B) or (C)_

Follow the installation instructions in the [Ansible documentation](http://docs.ansible.com/intro_installation.html#installing-the-control-machine)

Example: a simple installation using git on a Debian / Ubuntu machine:
    
    sudo apt-get install python-pip git # if not installed
    # installation for current user
    pip install paramiko PyYAML jinja2 httplib2  --user --upgrade
    git clone git://github.com/ansible/ansible.git
    source ansible/hacking/env-setup

Run the _source_ command above in new terminals before using the _ansible-playbook_ command.


Using Ansible For Vagrant VM Provisioning (B)
---------------------------------------------

*read [Universal Vagrant VM Installation (A) ](#universal-vagrant-vm-installation-a) first!*

This works like (A), but uses a locally installed Ansible and is a bit faster.
A current Ansible (1.5)+ from Github is required. (see instructions above)
The commands work like in (A), but you have to specify the machine name *ext* after each command instead

Run:

    vagrant up ext

To SSH into the box, use

    vagrant ssh ext

The VM can be removed with:

    vagrant destroy ext


Using Ansible For Remote Installation (C)
----------------------------------------

This will run the playbook from your local machine ("control machine") and install Redmine on a remote host. 
The control machine must use some operating system which is supported by Ansible, Linux or MacOS, for example.

The target machine should use a supported Linux distribution from the following list (similar debian-based systems could work, too. Try it!)

* Debian 7 "Wheezy" (64bit)

More supported distributions will be added later on demand.
A current Ansible (1.5)+ from Github is required.

### Setting Target Host

In the `playbook-redmine` subdirectory:

* copy hosts.example to hosts and set target hosts in `[db]` (for Postgres database), `[git_server]` and `[redmine_server]` sections.

__Important__

Currently, only installing components on a single host is supported. 
Please specify the same host for all sections in the hosts file, like in the hosts.example file. Support for multiple hosts will be added later.


### Host Preparation
The main playbook needs SSH access to an admin user who is able to sudo (with password is ok).
You can use the helper playbook access.yml to create such an user with proper SSH setup on a freshly installed Debian machine.

* configure host for root SSH access via password, if neccessary
* copy `access_vars.yml.example` to `access_vars.yml` and change the variables there
* run access playbook:

    ansible-playbook -i hosts access.yml -u root -k


### Running The Playbook
If the remote admin user has the same name as your current local user and must use sudo, run from the `playbook-redmine` dir:

    ansible-playbook -i hosts site.yml -K

For passwordless sudo (if allowed), run without -K. To specify another user, use `-u <username>`.
See `ansible-playbook --help` for more options.

You can add -vvvv to the command line to see more information if something wents wrong. SSH problems are the most common cause.

You must have "-i" in your Ansible sudo\_flags (in ansible.cfg). If not, use something like:

    ANSIBLE_SUDO_FLAGS="-i" ansible-playbook -i hosts all site.yml -K

After installation is completed, Redmine is running on Port 3000 (HTTPS only). You can login with _admin_ as username and _admin_ as password.


Customizing
------------

*this section can be ignored for a simple test installation*

Many settings can be changed by placing a custom vars file for each role in `group_vars`. 
Example files with default settings are included (`group_vars/{role}.example`).

Some facts about the installation in with default settings:

Redmine

* installed under `/srv/redmine/redmine`
* mail config uses sendmail binary installed on target host
* default data is loaded for English locale

Security

* SSL only on port 443
* port 80 redirected to HTTPS
* generated self-signed SSL certificate and 2048bit DH param
* no SSL 3, no MD5, no RC4, TLS 1+ only

Server/Ruby 

* most current version supported by Redmine and all plugins (2.1.0)
* served by Passenger integrated in Nginx
* installed with RVM for user `redmine_adm`
* Nginx managed by supervisor


### Mail Configuration

If you want a simple mail configuration which relays mails to another SMTP host (auth can be configured), this playbook can install nullmailer for you.

Example for a mail relay which supports STARTTLS, settings in `group_vars/redmine`:

    install_nullmailer: yes
    nullmailer_host: mail.example.com
    nullmailer_options: --starttls
    nullmailer_protocol: smtp
    nullmailer_admin_email: admin@example.com

For details, see 
* http://metz.gehn.net/2012/11/nullmailer-with-starttls/ 
* http://untroubled.org/nullmailer/HOWTO

If you need a more complex configuration, visit the [Redmine Wiki](http://www.redmine.org/projects/redmine/wiki/EmailConfiguration) and edit `playbook-redmine/roles/redmine/templates/config_production.yml`


### SSL Configuration

See settings in `group_vars/redmine`. 

You should at least change the certificate settings and install a certificate signed by a trusted CA on the host before installing Redmine.

### Redmine Plugins

For a list of installed plugins, see `playbook-redmine/roles/redmine_plugins/tasks/mail.yml`. 
You can skip plugins by simply commenting them out or using Ansible options for this:

    ansible-playbook --skip-tags=redmine_dmsf,redmine_etherpad site.yml

To install only one plugin and nothing else (maybe you excluded it earlier and want to install it now):

    ansible-playbook --tags=redmine_dmsf redmine_plugins.yml

### Install without Git support

Run ansible with:

    ansible-playbook --skip-tags=gitolite,redmine_git_hosting site.yml
