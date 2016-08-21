#!/usr/bin/env bash
#
# Creates a router in OpenShift
# usage:
#       sh os-create-router.sh
#
OS_HOME=/usr/local/openshift/default
PATH=$PATH:$OS_HOME

echo 'Allowing the ﻿service account router to access the host network on nodes'
oadm policy add-scc-to-user hostnetwork -z router

echo 'Creating the router'
oadm router