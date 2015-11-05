#!/bin/bash
#
# Copyright 2015 - gatblau.org
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
# EUROPA Source to Image script
#
# This script will create the Europa virtual machine from source and import it into Virtual Box
# It is intended to run in a Cygwin terminal installed in a Windows machine.
# Cygwin must have lynx installed so that the script can install the cygwin package manager
# and install the other required Cygwin packaged automatically.
# Internet connectivity is required, the overall process can take up to 1 hour
#

v="$(uname -a)"
if [[ $v != CYGWIN* ]]; then
	echo 'this script is intended to run in CYGWIN'
	echo '   download and install CYGWIN from https://cygwin.com/install.html'
	echo '   make sure the "lynx" package in the Web group is installed!'
	exit
fi

startTime=$(date -u +"%s")

v="$(apt-cyg --version)"
if [[ $v != apt-cyg* ]]; then
	echo 'the apt-cyg package manager is not installed'
	v="$(lynx --version)"
	if [[ $v == Lynx* ]]; then
		echo 'installing apt-cyg'
		lynx -source rawgit.com/transcode-open/apt-cyg/master/apt-cyg > apt-cyg
		install apt-cyg /bin
	else
		echo 'the script cannot continue: lynx is required!'
		exit
	fi
fi

v="$(wget --version)"
if [[ $v != GNU* ]]; then
	echo 'installing wget'
	apt-cyg install wget
fi

v="$(git --version)"
if [[ $v != git* ]]; then
	echo 'installing git'
	apt-cyg install git
fi

v="$(unzip -v)"
if [[ $v != UnZip* ]]; then
	echo 'installing Unzip'
	apt-cyg install unzip
fi

if [[ ! -d "C:\Program Files\Oracle\VirtualBox" ]]; then
    if [[ ! -e vbox.exe ]]; then
        echo 'downloading Virtual Box'
        wget -O vbox.exe 'http://download.virtualbox.org/virtualbox/5.0.8/VirtualBox-5.0.8-103449-Win.exe'
        chmod +x vbox.exe
    fi
    echo 'installing Virtual Box, please wait!'
    ./vbox.exe --silent
fi

export PATH=$PATH:"/cygdrive/c/Program Files/Oracle/VirtualBox"

if [[ ! -d "packer_files" ]]; then
	echo 'installing Packer'
	mkdir packer_files
	cd packer_files
	wget 'https://releases.hashicorp.com/packer/0.8.6/packer_0.8.6_windows_amd64.zip'
	unzip packer_0.8.6_windows_amd64.zip
	chmod +x packer.exe
	export PATH=$PATH:"$PWD"
	cd ..
fi

echo 'downloading build scripts'
git clone https://github.com/gatblau/europa.git

echo 'dowloading Europa packages, please wait...'
cd europa/build
sh fetch.sh
cd ..

echo 'building Europa image, please wait...'
../packer_files/packer build europa.vbox.json

echo 'copying Europa Virtual Machine to C:\VMs directory'
mkdir -p c:/VMs/europa
cp -v europa-vbox/* c:/VMs/europa

echo 'importing Europa into Virtual Box, please wait...'
VBoxManage import c:/VMs/europa/europa.ova

read -p "Do you want to delete the installation files?" deleteFiles
case $deleteFiles in
    [Yy]* ) cd .. && rm -rf * ;;
    * ) echo "installation files can be found at $PWD" ;;
esac

endTime=$(date -u +"%s")
diff=$(($endTime-$startTime))

echo "Europa build process complete: it took $(($diff / 60)) minutes and $(($diff % 60)) seconds."

echo 'Launching Virtual Box...'
echo 'Remember to adjust the VM settings before starting it!'

(VirtualBox &)

read -p "Press any key to close the console..."

exit