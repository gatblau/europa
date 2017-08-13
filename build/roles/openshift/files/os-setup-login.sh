#!/usr/bin/env bash
#
# Sets up login as administrator for the current user.
#
os_home=/usr/local/openshift/default

# re-creates the configuration folder
rm -rf /root/.kube
mkdir /root/.kube

# copy the kube config file
cp $os_home/openshift.local.config/master/admin.kubeconfig /root/.kube/config
