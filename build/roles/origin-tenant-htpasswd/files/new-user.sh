#!/usr/bin/env bash
#
# new-user.sh creates a new user / pwd combination in htpasswd file and add-user-to-role under a specified namespace
# usage: sh new-user.sh 4 /usr/local/openshift basic-user myproject-dev y
#
# input vars:
#   $1 : password len
#   $2 : origin path
#   $3 : user
#   $4 : origin namespace (e.g. myproject-dev)
#   $5 : is the user a project admin? (y/n)

# create a random password
pwd=$(perl -le 'print map { (a..z,A..Z,0..9)[rand 62] } 0..pop' $1)

# create a user in htpasswd file
htpasswd -c -b $2'/users.htpasswd' $3 $pwd

# is the user an admin or a basic user?
if [ "$5" eq "y" ]; then
    role='admin'
else
    role='basic-user'
fi

# add user to role basic-user
$2/oc add-role-to-user basic-user $role $3 -n $4 --config=$2/openshift.local.config/master/admin.kubeconfig

# writes the user and pwd to a file
echo "$3 - $pwd" >> "$2/user-info"
echo "" >> "$2/user-info"