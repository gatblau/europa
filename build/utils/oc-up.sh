#!/usr/bin/env bash

# the path where all ocp configuration should be created
ocpath='/usr/local/openshift/default'

# specific ocp configuration folders
conf=${ocpath}'/openshift.local.config'
data=${ocpath}'/openshift.local.data'
pv=${ocpath}'/openshift.local.pv'
volumes=${ocpath}'/openshift.local.volumes'

oc cluster up \
  --use-existing-config=true \
  --skip-registry-check=true \
  --host-config-dir=$conf \
  --host-data-dir=$data \
  --host-pv-dir=$pv \
  --host-volumes-dir=$volumes