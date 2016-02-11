#!/usr/bin/env bash
#
# Copyright 2016 - gatblau.org
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Configures the gnome terminal after the Ansible provisioning
#

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
# leave the display turned on - so the screensaver can kick in
sudo -u europa dbus-launch gsettings set org.gnome.desktop.session idle-delay 0
# grant permission to europa to access the shared folder
sudo gpasswd --add europa vboxsf