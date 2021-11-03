#!/usr/bin/env bash
#
# Copyright 2015-2017 - gatblau.org
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
# EUROPA Source to Image script for Windows
#
# This script will create the Europa virtual machine from source and import it into Virtual Box
# It is intended to run in a Cygwin terminal installed in a Windows machine.
# Cygwin must have lynx installed so that the script can install the cygwin package manager
# and install the other required Cygwin packaged automatically.
# Internet connectivity is required, the overall process can take up to 1 hour
#

# must run as administrator!
loggedAs=$(id -G | grep -qE '\<(544|0)\>' && echo admin || echo user)
if [[ $loggedAs != admin ]]; then
	echo 'The installation script must run as administrator. Cannot continue.'
	echo 'Re-launch this console by right clicking on the Cygwin item in the Windows Start Menu and selecting run as administrator.'
    read -n1 -r -p "Press any key to continue..."
    exit
fi

# must run in a Cygwin console!
v="$(uname -a)"
if [[ $v != CYGWIN* ]]; then
	echo 'this script is intended to run in CYGWIN'
	echo '   download and install CYGWIN from https://cygwin.com/install.html'
	echo '   make sure the "lynx" package in the Web group is installed!'
	exit
fi

v="$(sage --version)"
if [[ $v != Sage* ]]; then
	echo 'the Sage package manager is not installed'
	v="$(lynx --version)"
	if [[ $v == Lynx* ]]; then
		echo 'installing the Sage package manager for Cygwin'
		lynx -source rawgit.com/svnpenn/sage/master/sage > sage
		install sage /bin
	else
		echo 'the script cannot continue: lynx is required!'
		exit
	fi
fi

sage install ncurses

v="$(wget --version)"
if [[ $v != GNU* ]]; then
	echo 'installing wget'
	sage install wget
fi

v="$(git --version)"
if [[ $v != git* ]]; then
	echo 'installing git'
	sage install git
fi

v="$(unzip -v)"
if [[ $v != UnZip* ]]; then
	echo 'installing Unzip'
	sage install unzip
fi

if [[ ! -d "C:\Program Files\Oracle\VirtualBox" ]]; then
    if [[ ! -e vbox.exe ]]; then
        echo 'downloading Virtual Box'
        wget -O vbox.exe 'https://download.virtualbox.org/virtualbox/6.1.22/VirtualBox-6.1.22-144080-Win.exe'
        chmod +x vbox.exe
    fi
    echo 'installing Virtual Box, please wait!'
    ./vbox.exe --silent
fi

export PATH=$PATH:"/cygdrive/c/Program Files/Oracle/VirtualBox"

# if there is a previous installation in Virtual Box, deletes it
if [[ -d "$USERPROFILE\VirtualBox VMs\europa" ]]; then
   rm -rf "$USERPROFILE\VirtualBox VMs\europa"
fi

if [[ ! -f "./europa.sh" ]]; then
   wget https://raw.githubusercontent.com/gatblau/europa/master/europa.sh
fi

source ./europa.sh "$1"

exit
