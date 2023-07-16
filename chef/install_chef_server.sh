#!/usr/bin/env bash

apt-get update -y -qq > /dev/null
apt-get upgrade -y -qq > /dev/null
apt-get -y -q install linux-headers-$(uname -r) build-essential > /dev/null

wget -qq -P /tmp https://packages.chef.io/files/stable/chef-server/15.6.2/ubuntu/20.04/chef-server-core_15.6.2-1_amd64.deb > /dev/null
dpkg -i /tmp/chef-server-core_15.6.2-1_amd64.deb

mkdir /home/vagrant/certs
chown -R vagrant:vagrant /home/vagrant

chef-server-ctl reconfigure --chef-license=accept
chef-server-ctl user-create mounik laurent mounicou mounicou@gmail.com '2Ksable$' --filename /home/vagrant/certs/mounik.pem
chef-server-ctl org-create belive "Belive.ai" --association_user mounik --filename /home/vagrant/certs/belive.pem

mkdir -p /root/.ssh
cp /vagrant/sshkey.pub /root/.ssh/authorized_keys

echo "Chef Console is ready: http://chef-server with login: mounik password: 2Ksable$"
