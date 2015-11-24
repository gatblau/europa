#!/usr/bin/env bash
rm default_profile_id
id=$(gsettings get org.gnome.Terminal.ProfilesList default)
id="${id%\'}"
id="${id#\'}"
echo $id >> "/home/$1/default_profile_id"