# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

$script = <<SCRIPT
if [ ! "$(grep single-request-reopen /etc/resolv.conf)" ] 
then 
  echo 'options single-request-reopen' >> /etc/resolv.conf
fi
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.box = "ffuenf/debian-7.4.0-amd64"

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 2
  end

  config.vm.network :forwarded_port, guest: 443, host: 3000

  # fix DNS problem with nginx install
  # DNS is too slow and nginx install aborts after 5 sec
  # => https://github.com/mitchellh/vagrant/issues/1172
  config.vm.provision :shell, inline: $script

  config.vm.define "ext", primary: true do |guest|
    guest.vm.provision :ansible do |ansible|
      ansible.playbook = "playbook-redmine/site.yml"
      ansible.groups = {
        "db" => ["ext"],
        "redmine_server" => ["ext"],
        "git_server" => ["ext"]
      }
      ansible.verbose = ENV["VA_VERBOSE"]
      ansible.raw_arguments = ENV["VA_ARGS"]
    end
  end
end
