#!/usr/bin/env bash
#
# Copyright 2015-2017 - gatblau.org
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
echo 'registering the system with Red Hat'
subscription-manager register --username ${RH_USERNAME} --password ${RH_PASSWORD} --name europa --auto-attach
subscription-manager repos --enable codeready-builder-for-rhel-8-x86_64-rpms

echo 'setting the the user'
europauser='europa'

echo 'installing the EPEL repository'
dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
#yum install -y epel-release

echo 'insalling dkms for Virtualbox Guest Additions'
yum install -y dkms

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

echo 'installing ansible'
yum install -y ansible
