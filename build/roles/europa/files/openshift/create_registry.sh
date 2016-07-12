#!/usr/bin/env bash
#
# Creates an integrated docker registry running on a specific service account
# This script MUST NOT be used for production environments as it creates the persistent storage in a directory in the
# node where the pod is running. If the pod runs on more than one node, duplicates of the store are created
# producing inconsistent behaviour.
#
# Usage: sh create_registry.sh
#

OS_HOME=/usr/local/openshift/default
KUBE_CFG=openshift.local.config/master/admin.kubeconfig
REGISTRY_DIR=$OS_HOME/registry

PATH=$PATH:$OS_HOME

if [ ! -d "$REGISTRY_DIR" ]; then
  echo "Creating persistent storage folder @ "$REGISTRY_DIR
  sudo mkdir $REGISTRY_DIR

  # The Docker registry pod runs as user 1001. This user must be able to write to the host directory.
  echo "Changing ownership of the storage folder to the user the pod runs under"
  sudo chown 1001:root $REGISTRY_DIR
fi

echo "Login into Openshift"
oc login \
    -u system:admin \
    --config=$OS_HOME/$KUBE_CFG

echo "Creating a new service account in the default namespace to run the internal registry"
oc create \
     serviceaccount registry \
     --config=$OS_HOME/$KUBE_CFG -n default

echo "Adding the registry service account to the list of users allowed to run privileged containers"
oadm policy \
     add-scc-to-user \
     privileged \
     system:serviceaccount:default:registry \
     --config=$OS_HOME/$KUBE_CFG

echo "Creating the registry"
oadm registry \
    --service-account=registry \
    --config=$OS_HOME/$KUBE_CFG \
    --mount-host=$REGISTRY_DIR \
    --config=$OS_HOME/$KUBE_CFG

echo "Creating a registry configuration file for re-creation of the registry in the future"
oadm registry \
    --service-account=registry \
    --config=$OS_HOME/$KUBE_CFG \
    --mount-host=$REGISTRY_DIR \
    --config=$OS_HOME/$KUBE_CFG \
    -o yaml > $OS_HOME/integrated_registry.yaml

echo "Recording the IP Address the registry runs under for use if the registry is re-created"
oc get svc/docker-registry \
    -o yaml \
    --config=$OS_HOME/$KUBE_CFG | grep clusterIP: > $OS_HOME/integrated_registry_ip.txt
