#!/usr/bin/env bash

#1
# install ansible on the "loadbalancer" host - namely version 2.2.1.0-0.5
apt-get -y install software-properties-common >> /tmp/ansiblelog.log
apt-add-repository -y ppa:ansible/ansible >> /tmp/ansiblelog.log
apt-get update >> /tmp/ansiblelog.log
apt-get -y install ansible >> /tmp/ansiblelog.log

#2
# copy examples into /home/vagrant (from inside the loadbalancing node)
# well, this is embarrassing.. everything points to here, but I'm pulling from the automounted /vagrant path anyway. 
# I should have changed this already, but it's currently working, and I'm on the clock, so.. 
mkdir -p /home/vagrant/ansible
cp -a /vagrant/ansible/* /home/vagrant/ansible/.
chown -R vagrant:vagrant /home/vagrant

#3
#vagrant sudo rules
# remain idemponent
if grep --quiet exempt_group=admin /etc/sudoers; then
    # code if found
	echo "sudoers file already configured. "
else

# I'm not sure if you meant to have these done in ansible or not, the same job can be done handily enough. 
groupadd -r admin
usermod -a -G admin vagrant
cp /etc/sudoers /etc/sudoers.orig
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers 

fi

#4
# configure hosts file for our internal network defined by Vagrantfile
# remain idemponent
if grep --quiet 10.0.15.11 /etc/hosts; then
    # code if found
	echo "hosts file already configured. "
else
    # code if not found
	cat >> /etc/hosts <<EOL
# vagrant environment nodes
10.0.15.11 loadbalancer
10.0.15.21  application1
10.0.15.22  application2

EOL

fi

#5
#sort out the ssh stuff, so that we don't get errors at ansible stage when trying to run commands remotely. 
#this is another reason why Im falling out of love with this tool.  
ssh-keyscan application1 application2 >> /home/vagrant/.ssh/known_hosts


