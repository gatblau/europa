#!/usr/bin/env bash
#
# Creates the basic services on a fresh OpenShift instance
#
KUBE=/home/europa/.kube
OS_HOME=/usr/local/openshift/default
CONF_DIR=$OS_HOME/openshift.local.config/master

PATH=$PATH:$OS_HOME

# creates the integrated docker registry
oc create serviceaccount registry -n defaults
oadm policy add-scc-to-user privileged system:serviceaccount:default:registry
oadm registry \
    --service-account=registry \
    --tls-certificate=$KUBE/openshift-registry.crt \
    --tls-key=$KUBE/openshift-registry.key

# ﻿Enable TLS﻿ on the registry
#oc env dc/docker-registry \
#    REGISTRY_HTTP_TLS_CERTIFICATE=$CONF_DIR/openshift-registry.crt \
#    REGISTRY_HTTP_TLS_KEY=$CONF_DIR/openshift-registry.key

# needs to copy certs to secrets folder
#    /etc/secrets/registry.crt
#    /etc/secrets/registry.key

# allows the ﻿service account "router" to access the host network on nodes
oadm policy add-scc-to-user hostnetwork -z router

# creates the router
oadm router

URI=https://raw.githubusercontent.com/openshift/origin/master/examples

# loads common image streams in  OpenShift
oc create -f $URI/image-streams/image-streams-centos7.json -n openshift

# loads common database templates
oc create -f $URI/db-templates/mongodb-ephemeral-template.json -n openshift
oc create -f $URI/db-templates/mongodb-persistent-template.json -n openshift
oc create -f $URI/db-templates/mysql-ephemeral-template.json -n openshift
oc create -f $URI/db-templates/mysql-persistent-template.json -n openshift
oc create -f $URI/db-templates/postgresql-ephemeral-template.json -n openshift
oc create -f $URI/db-templates/postgresql-persistent-template.json -n openshift