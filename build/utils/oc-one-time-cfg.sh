#!/usr/bin/env bash

# if oc cluster is not down, then bring it down
isup=$(oc cluster status | grep -c 'Error')
if [ "$isup" -eq 0 ]; then
   echo 'bringing the oc cluster down'
   oc cluster down
else
   echo 'oc cluster down check ok'
fi

# the user name and password of the user to be created in htpasswd
user='developer'
password='d3v3l0p3r!'

# the path where all ocp configuration should be created
ocpath='/usr/local/openshift/default'

# specific ocp configuration folders
conf=${ocpath}'/openshift.local.config'
data=${ocpath}'/openshift.local.data'
pv=${ocpath}'/openshift.local.pv'
volumes=${ocpath}'/openshift.local.volumes'

# removes any previous ocp configuration
sudo rm -rf $conf
sudo rm -rf $data
sudo rm -rf $pv
sudo rm -rf $volumes

# re-creates the ocp configuration folders
sudo mkdir -p $conf
sudo mkdir -p $data
sudo mkdir -p $pv
sudo mkdir -p $volumes

# brings the cluster up
oc cluster up \
  --use-existing-config=true \
  --skip-registry-check=true \
  --host-config-dir=$conf \
  --host-data-dir=$data \
  --host-pv-dir=$pv \
  --host-volumes-dir=$volumes

# after creation of configuration files brings the cluster back down
oc cluster down

# installs httpd tools if not already installed
sudo yum install httpd-tools -y

# creates an htpasswd file to store user credentials and adds the username and password
sudo htpasswd -c -b ${ocpath}/openshift.local.config/users.htpasswd ${user} ${password}

# gets the definition for the HTPasswdPasswordIdentityProvider in OCP from the idp.txt file
provider=$(<idp.txt)

# changes the identity provider to HTPasswd in the master-config.yaml (and leave the original as *.old)
sudo perl -i.old -0pe "s/identityProviders.*AllowAllPasswordIdentityProvider/${provider}/s" ${ocpath}/openshift.local.config/master/master-config.yaml
