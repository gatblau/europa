# OpenShift

## Table of Contents
- [Login as admin](#log-admin)
- [Login as user](#log-user)
- [Building an application from source](#from-source)
- [Resetting OpenShift](#reset)

## Overview
[OpenShift Origin](https://github.com/openshift/origin) is installed in Europa as a systemd unit named "openshift".

To check it is running type:
```sh
$ systemctl status openshift
```
You should see:
```sh
● openshift.service - OpenShift Container Application Platform
   Loaded: loaded (/etc/systemd/system/openshift.service; enabled; vendor preset: disabled)
  Drop-In: /etc/systemd/system/openshift.service.d
           └─openshift.conf
   Active: active (running) since ...
 Main PID: 1039 (openshift)
   Memory: 18.0M
   CGroup: /system.slice/openshift.service
           └─1039 /usr/local/openshift/default/openshift start
```
<a name="log-admin"/>
## Login a Admin
In order to login as an administrator, switch to the root user as follows:
```sh
$ su
Password: 
[root@localhost europa]# 
```
To check the available projects type:
```sh
[root@localhost europa]# oc get projects
NAME              DISPLAY NAME   STATUS
default                          Active
openshift                        Active
openshift-infra                  Active
```
The default project comes with the router and a secure integrated registry installed. 
To check them type:
```sh
[root@localhost europa]# oc status
In project default on server https://10.0.2.15:8443

svc/docker-registry - 172.30.183.134:5000
  dc/docker-registry deploys docker.io/openshift/origin-docker-registry:v1.2.0 
    deployment #1 deployed ... hours ago - 1 pod

svc/kubernetes - 172.30.0.1 ports 443, 53, 53

svc/router - 172.30.61.38 ports 80, 443, 1936
  dc/router deploys docker.io/openshift/origin-haproxy-router:v1.2.0 
    deployment #1 deployed ... hours ago - 1 pod

View details with 'oc describe <resource>/<name>' or list everything with 'oc get all'.
```
<a name="log-user"/>
## Login a User
In order to login as a user use the oc login command and type "any" password:
```sh 
[europa@localhost ~]$ oc login
Authentication required for https://localhost:8443 (openshift)
Username: europa
Password: ***any password***
Login successful.
```
<a name="from-source"/>
## Bulding an application from source
To test building an app from source type:
```sh
# creates a new test project
[europa@localhost ~]$ oc new-project test
# creates a new app from source
[europa@localhost ~]$ oc new-app centos/ruby-22-centos7~https://github.com/openshift/ruby-hello-world.git
# checks the build progress
[europa@localhost ~]$ oc logs -f bc/ruby-hello-world
# check the new application status
[europa@localhost ~]$ oc status
In project test on server https://localhost:8443

svc/ruby-hello-world - 172.30.58.160:8080
  dc/ruby-hello-world deploys istag/ruby-hello-world:latest <-
    bc/ruby-hello-world builds https://github.com/openshift/ruby-hello-world.git with test/ruby-22-centos7:latest 
    deployment #1 deployed 8 minutes ago - 1 pod
```
Now you can open a browser an navigate to the IP of **svc/ruby-hello-world** as described above.

To remove the project type:
```sh
[europa@localhost ~]$ oc delete project test
```
<a name="reset"/>
## Resetting OpenShift
It is sometimes useful to be able to reset OpenShift back to its initial state.
A few scripts are provided to facilitate this as follows:
- [os-cleanup.sh](../build/roles/europa/files/openshift/os-cleanup.sh): stops the openshift systemd unit and removes all docker containers.
- [os-setup-login.sh](../build/roles/europa/files/openshift/os-setup-login.sh): copies the admin login credentials to the current user home, so that the user can automatically login as administrator.
- [os-create-registry.sh](../build/roles/europa/files/openshift/os-create-registry.sh): creates a TLS enabled integrated docker registry in OpenShift and configures the Docker client to trust it.
- [os-create-router.sh](../build/roles/europa/files/openshift/os-create-router.sh): creates a router.
- [add-templaplates.sh](../build/roles/europa/files/openshift/add-templates.sh): adds a set of pre-configured application templates to OpenShift.

In order to reset OpenShift do the following:

```sh 
# log as root
[europa@localhost ~]$ su
Password: *****

# cd into the OpenShift installation
[root@localhost europa]# cd /usr/local/openshift/default

# execute clean up
[root@localhost default]# sh os-cleanup.sh

# disregard errors about busy devices

# starts the OpenShift systemd unit
[root@localhost default]# systemctl start openshift

# setup the admin login cerdentials
[root@localhost default]# sh os-setup-login.sh

# create the integrated registry
[root@localhost default]# sh os-create-registry.sh

# create the router
[root@localhost default]# sh os-create-router.sh

# add application templates
[root@localhost default]# sh os-add-templates.shß
```