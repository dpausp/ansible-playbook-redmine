#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

apt-get update -qq
apt-get install -y make git-core
apt-get install -y python-pip python-dev
pip install paramiko PyYAML jinja2 httplib2 --upgrade

if [[ ! -d /home/vagrant/ansible ]]; then
    # Install Ansible dependencies.
    # Checkout the Ansible repository.
    git clone https://github.com/ansible/ansible.git /home/vagrant/ansible
    echo "source /home/vagrant/ansible/hacking/env-setup > /dev/null" >> /home/vagrant/.bash_profile
fi
