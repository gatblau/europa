#!/usr/bin/env bash
#
# Creates a set pf default application templates in OpenShift
# usage:
#       sh os-add-templates.sh
#
OS_HOME=/usr/local/openshift/default
PATH=$PATH:$OS_HOME
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