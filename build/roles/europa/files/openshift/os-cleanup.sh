#!/usr/bin/env bash
#
# Cleans up an existing OpenShift instance.
#
# stops the service
sudo systemctl stop openshift
# removes config folders
sudo rm -rf /usr/local/openshift/default/openshift.local.*
# removes the kubernetes docker containers
id=$(docker ps -af name=k8s_* -q)
if [[ ! -z $id ]]; then
   docker rm -f $id
fi
# removes kube config
sudo rm -rf ~/.kube