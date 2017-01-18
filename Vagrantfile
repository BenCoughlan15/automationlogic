# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
# Defines our Vagrant environment
#
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|


  # create some application servers
  #We'll limit it to two but we could spin up many more.
  #you basically just need to change the integer below, and the ansible.ini file, and you've got many nodes. 
  #giving each half a gig of ram. 
  #OS is UBUNTU/trusty, but it's out of date, we won't run updates on it, as it'll take forever. 
  (1..2).each do |i|
    config.vm.define "application#{i}" do |node|
        node.vm.box = "puppetlabs/ubuntu-14.04-64-nocm"
        node.vm.hostname = "application#{i}"
	    node.ssh.insert_key = false 
        node.vm.network :private_network, ip: "10.0.15.2#{i}"
        node.vm.network "forwarded_port", guest: 80, host: "808#{i}"
		node.vm.provision "shell", inline: "cat /vagrant/.ssh/id_rsa.pub >> ~vagrant/.ssh/authorized_keys"
		node.vm.provision "shell", inline: "cp /vagrant/.ssh/id_rs*  /home/vagrant/.ssh/"
		node.vm.provision "shell", inline: "chmod 400 /home/vagrant/.ssh/id_rs*"
        node.vm.provider "virtualbox" do |vb|
          vb.memory = "512"
        end
    end
  end
  
  # create load balancer
  #give it a gig of ram
  #OS is UBUNTU/trusty, but it's out of date, we won't run updates on it, as it'll take forever. 
  config.vm.define :loadbalancer do |loadbalancer_config|
      loadbalancer_config.vm.box = "puppetlabs/ubuntu-14.04-64-nocm"
      loadbalancer_config.vm.hostname = "loadbalancer"
	  loadbalancer_config.ssh.insert_key = false 
      loadbalancer_config.vm.network :private_network, ip: "10.0.15.11"
      loadbalancer_config.vm.network "forwarded_port", guest: 80, host: 8080
	  loadbalancer_config.vm.provision "shell", inline: "cat /vagrant/.ssh/id_rsa.pub >> ~vagrant/.ssh/authorized_keys"
	  loadbalancer_config.vm.provision "shell", inline: "cp /vagrant/.ssh/id_rs*  /home/vagrant/.ssh/"
	  loadbalancer_config.vm.provision "shell", inline: "chmod 400 /home/vagrant/.ssh/id_rs*"
      loadbalancer_config.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
      end
      loadbalancer_config.vm.provision :shell, path: "provision.sh"
  
  	  loadbalancer_config.vm.provision :ansible_local do |ansible|
      ansible.playbook       = "ansible/playbook.yaml"
      ansible.verbose        = true
      ansible.limit          = "all" # or only "nodes" group, etc.
    end

  #· Run a simple test using Vagrant's shell provisioner to ensure that nginx is listening on port 80
     loadbalancer_config.vm.provision "shell", inline: "sudo netstat -tapen  | grep ':80 ' ; true "
	 loadbalancer_config.vm.provision :shell, path: "ansible/subtasks/connectiontest.sh"
end

  end

