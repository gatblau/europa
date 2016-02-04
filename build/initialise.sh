#!/usr/bin/env bash
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
pip install six==1.4

echo 'installing docker-py, which is required by the ansible docker module'
pip install docker-py==1.2.3

echo 'installing git'
yum install -y git

ansibleVersion=v2.0.1.0-0.1.rc1
echo "installing ansible $ansibleVersion from source"
cd /usr/local
git clone --branch "$ansibleVersion" --depth 1 https://github.com/ansible/ansible.git
cd ansible
git submodule update --init --recursive
make && sudo make install

echo 'zeroing the disk'
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY