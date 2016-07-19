#!/usr/bin/env bash
#
# Creates the basic services on a fresh OpenShift instance
#

PATH=$PATH:/usr/local/openshift/default

# =========================================================================
# INTEGRATED DOCKER REGISTRY
# =========================================================================

# creates the registry service account and grant access to the Privileged Security Context Constraints (SCC)
oadm policy add-scc-to-user privileged system:serviceaccount:default:registry

# creates the integrated registry
oadm registry \
    --service-account=registry \
    --mount-host=/usr/local/openshift/default/registry

# create the secret for the registry TLS certificates
oc secrets new registry-secret \
    /etc/secrets/openshift-registry.crt \
    /etc/secrets/openshift-registry.key

# add the secret to the registry pod’s service accounts registry and default
oc secrets add serviceaccounts/registry secrets/registry-secret
oc secrets add serviceaccounts/default secrets/registry-secret

# add the secret volume to the registry deployment configuration
oc volume dc/docker-registry --add --type=secret --secret-name=registry-secret -m /etc/secrets

# ﻿Enable TLS﻿ on the registry
oc env dc/docker-registry \
    REGISTRY_HTTP_TLS_CERTIFICATE=/etc/secrets/openshift-registry.crt \
    REGISTRY_HTTP_TLS_KEY=/etc/secrets/openshift-registry.key

# Update the scheme used for the registry’s readiness probe from HTTP to HTTPS
oc patch dc/docker-registry --api-version=v1 -p '{"spec": {"template": {"spec": {"containers":[{
    "name":"registry",
    "readinessProbe":  {"httpGet": {"scheme":"HTTPS"}}
  }]}}}}'

# =========================================================================
# ROUTER
# =========================================================================

# allows the ﻿service account "router" to access the host network on nodes
oadm policy add-scc-to-user hostnetwork -z router

# creates the router
oadm router

# =========================================================================
# TEMPLATES
# =========================================================================

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