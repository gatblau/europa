#!/usr/bin/env bash
#
# Cleans up an existing OpenShift instance.
#

# stops the Openshift service
sudo systemctl stop openshift

# removes the Openshift configuration folders
sudo rm -rf /usr/local/openshift/default/openshift.local.*

# removes the all kubernetes docker containers runnig on the host
id=$(docker ps -af name=k8s_* -q)
if [[ ! -z $id ]]; then
   docker rm -f $id
fi

# removes kube config folder for user
sudo rm -rf ~/.kube