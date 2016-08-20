#!/usr/bin/env bash
#
# Creates a secure integrated docker registry in OpenShift
# usage:
#       sh os-create-registry.sh
# NOTE:
#      the script requires root access
#
OS_HOME=/usr/local/openshift/default
PATH=$PATH:$OS_HOME

echo 'Granting the registry service account access to the Privileged Security Context Constraints (SCC)'
oadm policy add-scc-to-user privileged system:serviceaccount:default:registry

echo 'Creating a folder for the integrated registry mount point'
REG_PATH=$OS_HOME/registry
rm -rf $REG_PATH
mkdir $REG_PATH
chown 1001:europa $REG_PATH

echo 'Creating the integrated registry in OpenShift'
oadm registry \
    --service-account=registry \
    --mount-host=$OS_HOME/registry

echo 'Creating a folder to keep registry secrets'
rm -rf /etc/secrets
mkdir /etc/secrets
chown 1001:europa /etc/secrets

echo 'Reading the IP address of the integrated registry'
IP=$(oc get svc/docker-registry -n default | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
echo 'The integrated registry IP is '$IP

echo 'Creating TLS certificates for the integrated registry'
oadm ca create-server-cert \
    --signer-cert=$OS_HOME/openshift.local.config/master/ca.crt \
    --signer-key=$OS_HOME/openshift.local.config/master/ca.key \
    --signer-serial=$OS_HOME/openshift.local.config/master/ca.serial.txt \
    --hostnames='docker-registry.default.svc.cluster.local,'$IP \
    --cert=/etc/secrets/openshift-registry.crt \
    --key=/etc/secrets/openshift-registry.key

echo 'Making user 1001 the owner of the TLS certificate files'
chown 1001:europa /etc/secrets/openshift-registry.crt
chown 1001:europa /etc/secrets/openshift-registry.key

echo 'Creating the secret for the registry TLS certificates in OpenShift'
oc secrets new registry-secret \
    /etc/secrets/openshift-registry.crt \
    /etc/secrets/openshift-registry.key

echo 'Adding the secret to the registry pod’s service accounts: registry and default'
oc secrets add serviceaccounts/registry secrets/registry-secret
oc secrets add serviceaccounts/default secrets/registry-secret

echo 'Adding the secret volume to the registry deployment configuration'
oc volume dc/docker-registry --add --type=secret --secret-name=registry-secret -m /etc/secrets

echo 'Enabling TLS﻿on the registry'
oc env dc/docker-registry \
    REGISTRY_HTTP_TLS_CERTIFICATE=/etc/secrets/openshift-registry.crt \
    REGISTRY_HTTP_TLS_KEY=/etc/secrets/openshift-registry.key

echo 'Updating the registry’s readiness and liveness probe schemes to HTTPS'
oc patch dc/docker-registry -p '{"spec": {"template": {"spec": {"containers":[{
    "name":"registry",
    "readinessProbe":  {"httpGet": {"scheme":"HTTPS"}},
    "livenessProbe":  {"httpGet": {"scheme":"HTTPS"}}
  }]}}}}'

echo 'Configuring the Docker client to trust the CA that signed the registry TLS certificate'
DOCKER_CERT_PATH="/etc/docker/certs.d"
rm -rf $DOCKER_CERT_PATH
mkdir $DOCKER_CERT_PATH
mkdir $DOCKER_CERT_PATH/$IP:5000
cp $OS_HOME/openshift.local.config/master/ca.crt $DOCKER_CERT_PATH/$IP:5000/ca.crt

echo 'Restarting the Docker daemon'
systemctl restart docker