#!/usr/bin/env bash
{{ ocp_path }}/oc get svc/docker-registry -n default --config=/home/{{ admin_user }}/.kube/config | grep -oE "\b([0-9]{1,3}.){3}[0-9]{1,3}\b"