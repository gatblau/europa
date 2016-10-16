# OpenShift

## Table of Contents
- [Overview](#overview)
- [Login as admin](#log-admin)
- [Login as user](#log-user)
- [Building an application from source](#from-source)
- [Resetting OpenShift](#reset)

<a name="overview"/>
## Overview
[OpenShift Origin v1.3.0](https://github.com/openshift/origin/releases/tag/v1.3.0) is installed in Europa as a systemd unit named "openshift". The service is not started by default to avoid consuming resources if its use is not intended.

To enable OpenShift use the built-in shell tools as follows:
```sh
$ os on
```

To check OpenShift is running type:
```sh
$ systemctl status openshift
```

You should see the following:
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

Alternatively the shell tools can also be used to check the running status of OpenShift as follows:
```sh
$ os status
OpenShift is RUNNING...
```

<a name="log-admin"/>
## Login as Admin
In order to login to OpenShift as an administrator, switch to the root user as follows:
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
## Login as User
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
[europa@localhost ~]$ oc new-app centos/ruby-22-centos7~https://github.com/openshift/ruby-ex.git
# checks the build progress
[europa@localhost ~]$ oc logs -f bc/ruby-ex
# check the new application status
[europa@localhost ~]$ oc status
In project test on server https://localhost:8443

svc/ruby-ex - 172.30.236.225:8080
  dc/ruby-ex deploys istag/ruby-ex:latest <-
    bc/ruby-ex source builds https://github.com/openshift/ruby-ex.git on istag/ruby-22-centos7:latest
    deployment #1 deployed 40 seconds ago - 1 pod

```
Now you can open a browser an navigate to the IP of **svc/ruby-ex** as described above to see the application running.

To remove the project type:
```sh
[europa@localhost ~]$ oc delete project test
```
<a name="reset"/>
## Bash Tools

The following built-in bash tools are available from the bash terminal for the europa user:

| Command | Description |
|:-----|:------------|
| os on | Starts the OpenShift service and deploys router, registry and templates.|
| os off | Stops the OpenShift service and removes all running containers.|
| os restart| Runs 'off' and 'on' commands consecutively. |
| os tidy | Removes all 'exited' Kubernetes containers. |
| os status | Shows the help for each available command. |

The above commands call the scripts below, located in the OpenShift installation folder:
- [os-cleanup.sh](../build/roles/europa/files/openshift/os-cleanup.sh): stops the openshift systemd unit and removes all docker containers.
- [os-setup-login.sh](../build/roles/europa/files/openshift/os-setup-login.sh): copies the admin login credentials to the current user home, so that the user can automatically login as administrator.
- [os-create-registry.sh](../build/roles/europa/files/openshift/os-create-registry.sh): creates a TLS enabled integrated docker registry in OpenShift and configures the Docker client to trust it.
- [os-create-router.sh](../build/roles/europa/files/openshift/os-create-router.sh): creates a router.
- [os-add-templaplates.sh](../build/roles/europa/files/openshift/os-add-templates.sh): adds a set of pre-configured application templates to OpenShift.
