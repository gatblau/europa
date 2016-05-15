#!/usr/bin/env bash
#
# Copyright 2016 - gatblau.org
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Performs initialisation of the linux environment including the installation
# of Ansible for the provisioning of the various required tools.
# This script is executed by packer using a shell provisioner.
#
echo 'setting the the user'
europauser='europa'

echo 'installing the EPEL repo'
wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
rpm -ivh epel-release-7-5.noarch.rpm
rm epel-release-7-5.noarch.rpm

echo 'recording the build time'
date > /etc/europa_build_time

echo 'creating a directory to store the ssh public key'
mkdir -pm 700 /home/$europauser/.ssh

echo 'using the vagrant public key - assumes the use of the vagrant insecure private key for provisioning'
curl -L https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -o /home/$europauser/.ssh/authorized_keys

echo 'configuring access rights for user'
chmod 0600 /home/$europauser/.ssh/authorized_keys
chown -R $europauser:$europauser /home/$europauser/.ssh

echo 'removing the libreoffice suite'
yum -y remove libreoffice*
yum -y clean all

echo 'configuring Virtual Box guest additions'
VBOX_VERSION=$(cat /home/$europauser/.vbox_version)
cd /tmp
mount -o loop /home/$europauser/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt
rm -rf /home/$europauser/VBoxGuestAdditions_*.iso

echo 'installing the python package manager (pip)'
yum install -y python-pip

echo 'upgrading pip to its latest version'
pip install --upgrade pip

echo 'installing python development headers'
yum install -y python-devel

echo 'installing python compatibility between versions 2 and 3'
pip install six==1.10.0

echo 'installing docker-py, which is required by the ansible docker module'
pip install docker-py==1.7.0

echo 'installing git'
yum install -y git

ansibleVersion=v2.0.2.0
echo "installing ansible $ansibleVersion from source"
cd /usr/local
git clone --branch "$ansibleVersion" --depth 1 https://github.com/ansible/ansible.git
cd ansible
git submodule update --init --recursive
make && sudo make install

echo 'zeroing the disk'
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY