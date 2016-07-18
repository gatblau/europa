#!/usr/bin/env bash
#
# Starts the service for the first time and sets up the kubeconfig file for the user
#
home=/home/europa
# re-creates the configuration folder
sudo rm -rf $home/.kube
sudo mkdir $home/.kube
# copy the kube config file
sudo cp /usr/local/openshift/default/openshift.local.config/master/admin.kubeconfig $home/.kube/config
# sorting out permissions
sudo chmod 0777 $home/.kube/config
# sorting out group and owner
sudo chgrp europa $home/.kube/config
sudo chown europa $home/.kube/config

# copy certificates for the registry
sudo cp /usr/local/openshift/default/openshift.local.config/master/openshift-registry.crt $home/.kube/openshift-registry.crt
sudo chown europa $home/.kube/openshift-registry.crt
sudo chmod 0777 $home/.kube/openshift-registry.crt

sudo cp /usr/local/openshift/default/openshift.local.config/master/openshift-registry.key $home/.kube/openshift-registry.key
sudo chown europa $home/.kube/openshift-registry.key
sudo chmod 0777 $home/.kube/openshift-registry.key