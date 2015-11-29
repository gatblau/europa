#!/usr/bin/env bash
# Performs post configuration tasks
# gets the Id of the default terminal profile
id=$(gsettings get org.gnome.Terminal.ProfilesList default)
# removes leading quote
id="${id%\'}"
# removes trailing quote
id="${id#\'}"
# sets the terminal to run as login shell
sudo -u europa dbus-launch gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"$id"/ login-shell true
# sets the terminal not to use theme colours
sudo -u europa dbus-launch gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:"$id"/ use-theme-colors false
# elevates privileges to run docker
sudo chmod 0666 /var/run/docker.sock