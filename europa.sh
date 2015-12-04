#!/usr/bin/env bash
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
# EUROPA Source to Image script core installation script.
#

# define output colours
RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[0;33m'; NC='\033[0m'

out() {
   if [[ $1 == CYGWIN* ]]; then
      echo $3
   else
      echo $2$3"${NC}"
   fi
}

# parameter $1: name of the packer file to download
check_packer() {
    if [[ ! -d "packer_files" ]]; then
	    echo "${CYAN}installing Packer...${NC}"
	    mkdir packer_files
	    cd packer_files
	    wget 'https://releases.hashicorp.com/packer/0.8.6/'"$1"
	    unzip "$1"
	    chmod +x "$2"
	    export PATH=$PATH:"$PWD"
	    cd ..
	else
	    echo "${CYAN}packer is already installed...${NC}"
    fi
}

check_vm () {
   if `VBoxManage showvminfo $1 > /dev/null 2>&1`; then
        return 0
   else
        return 1
   fi
}

os="$(uname)"

# reset terminal colour
out $os "${NC}"

startTime=$(date -u +"%s")

out $os "${CYAN}" "downloading build scripts..."
git clone https://github.com/gatblau/europa.git

out $os "${CYAN}" "determining the latest version..."
cd europa
if [[ -z "$1" ]]; then
    out $os "${CYAN}" "reading version from latest tag..."
    tag=$(git describe --tags $(git rev-list --tags --max-count=1))
else
    out $os "${CYAN}" "using version tag:"
    out $os "${YELLOW}" ">>>>   ${1}   <<<<"
    tag="$1"
fi
if [[ -e 'build/roles/europa/files/shell/version' ]]; then
   rm 'build/roles/europa/files/shell/version'
fi
echo $tag >> build/roles/europa/files/shell/version

out $os "${CYAN}" "switching to latest version..."
git checkout $tag

out $os "${CYAN}" "dowloading Europa packages, please wait..."
cd build
sh fetch.sh
cd ..

if [[ $os == CYGWIN* ]]; then
    out $os "${CYAN}" "getting packer for WINDOWS build..."
    packer_zip='packer_0.8.6_windows_amd64.zip'
    appliance_folder='c:/appliances'
    packer_exe='packer.exe'
elif [[ $os == Darwin* ]]; then
    out $os "${CYAN}" "getting packer for DARWIN build..."
    packer_zip='packer_0.8.6_darwin_386.zip'
    appliance_folder='~/appliances'
    packer_exe='packer'
else
    out $os "${RED}" "Installation on ${os} is not supported!, cannot continue..."
    exit
fi

check_packer $packer_zip $packer_exe

if check_vm europa; then
    out $os "${CYAN}" "Europa build image found in Virtual Box, deleting it..."
    VBoxManage unregistervm europa --delete
fi

out $os "${CYAN}" "building the Europa appliance, please wait..."
./packer_files/"$packer_exe" build europa.vbox.json

if [[ ! -d $appliance_folder ]]; then
    out $os "${CYAN}" "creating the ${appliance_folder} folder..."
    mkdir -p $appliance_folder
fi

out $os "${CYAN}" "copying the Europa virtual appliance to ${appliance_folder}..."
out $os "${YELLOW}" "The appliance can be imported as many times as required from this folder."
cp -v europa-vbox/europa.ova $appliance_folder/europa_$tag.ova

out $os "${YELLOW}" "importing the Europa appliance into Virtual Box, please wait..."
VBoxManage import $appliance_folder/europa_$tag.ova --vsys 0 --vmname europa_$tag

read -n1 -p "Do you want to delete the installation files? [Y-N]" deleteFiles
case $deleteFiles in
    [Yy]* ) cd .. && rm -rf * ;;
    * ) out $os "${CYAN}" "installation files can be found at $PWD" ;;
esac

endTime=$(date -u +"%s")
diff=$(($endTime-$startTime))

out $os "${YELLOW}" "Europa build process complete: it took $(($diff / 60)) minutes and $(($diff % 60)) seconds."

out $os "${CYAN}" "Launching Virtual Box..."

(VirtualBox &)

read -p "Press any key to close the console..."

exit