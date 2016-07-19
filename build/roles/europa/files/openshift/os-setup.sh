#!/usr/bin/env bash
#
# Starts the service for the first time and sets up the kubeconfig file for the user
#
usr_home=/home/europa
os_home=/usr/local/openshift/default

# re-creates the configuration folder
sudo rm -rf $usr_home/.kube
sudo mkdir $usr_home/.kube

# copy the kube config file
sudo cp $os_home/openshift.local.config/master/admin.kubeconfig $usr_home/.kube/config

# assigning permissions and user/group
sudo chmod 0777 $usr_home/.kube/config
sudo chgrp europa $usr_home/.kube/config
sudo chown europa $usr_home/.kube/config

# check for secrets folder
if [ ! -d "/etc/secrets" ]; then
   sudo mkdir /etc/secrets
fi

# copy certificates for the registry to the secrets folder
sudo cp $os_home/openshift.local.config/master/openshift-registry.crt /etc/secrets/openshift-registry.crt
sudo cp $os_home/openshift.local.config/master/openshift-registry.key /etc/secrets/openshift-registry.key

# changes the owner for the certificates
sudo chown europa /etc/secrets/openshift-registry.crt
sudo chown europa /etc/secrets/openshift-registry.key

# checks / creates the integrated docker registry persistence folder
reg_dir=$os_home/registry
if [ ! -d "$reg_dir" ]; then
  sudo mkdir $reg_dir
  sudo chown 1001:europa $reg_dir
  sudo chmod 0775 $reg_dir
fi