#!/usr/bin/env bash
#
# add-user.sh creates a new user / pwd combination in htpasswd file
# usage: sh add-user.sh 4 /usr/local/openshift myuser myproject-dev y
#
# input vars:
#   $1 : password len
#   $2 : origin path
#   $3 : user

# create a random password
pwd=$(perl -le 'print map { (a..z,A..Z,0..9)[rand 62] } 0..pop' $1)

# create a user in htpasswd file
htpasswd -c -b $2'/users.htpasswd' $3 $pwd

# writes the user and pwd to a file
echo "user = $3 - pwd = $pwd" >> "$2/user-info"