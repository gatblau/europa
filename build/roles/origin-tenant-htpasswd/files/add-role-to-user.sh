#!/usr/bin/env bash
# add-user-to-role under a specified namespace
#   $1 : origin path
#   $2 : user
#   $3 : origin namespace (e.g. myproject-dev)
#   $4 : is the user a project admin? (y/n)

# is the user an admin or a basic user?
if [ "$4" == "y" ]; then
    role='admin'
else
    role='basic-user'
fi

# add user to role basic-user
$1/oc adm policy add-role-to-user $role $2 -n $3 --config=$1/openshift.local.config/master/admin.kubeconfig