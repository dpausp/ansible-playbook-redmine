# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.box = "ffuenf/debian-7.4.0-amd64"

  config.vm.define "ext", primary: true do |guest|
    guest.vm.provision :ansible do |ansible|
      ansible.playbook = "playbook-redmine/site.yml"
      ansible.groups = {
        "db" => ["ext"],
        "redmine_server" => ["ext"],
        "git_server" => ["ext"]
      }
      ansible.verbose = ENV["VA_VERBOSE"]
    end
  end
end
