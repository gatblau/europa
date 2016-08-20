#!/usr/bin/env bash
#
# Sets up login as administrator for europa and root users
#
usr_home=/home/europa
os_home=/usr/local/openshift/default

# re-creates the configuration folder
sudo rm -rf $usr_home/.kube
sudo mkdir $usr_home/.kube

sudo rm -rf /root/.kube
sudo mkdir /root/.kube

# copy the kube config file
sudo cp $os_home/openshift.local.config/master/admin.kubeconfig /root/.kube/config
sudo cp $os_home/openshift.local.config/master/admin.kubeconfig $usr_home/.kube/config

# assigning permissions and user/group
sudo chmod 0777 $usr_home/.kube/config
sudo chgrp europa $usr_home/.kube/config
sudo chown europa $usr_home/.kube/config