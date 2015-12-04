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
RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[0;43m'; NC='\033[0m'

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

# reset terminal colour
echo '${NC}'

os="$(uname)"

startTime=$(date -u +"%s")

echo "${CYAN}downloading build scripts...${NC}"
git clone https://github.com/gatblau/europa.git

echo "${CYAN}determining the latest version...${NC}"
cd europa
if [[ -z "$1" ]]; then
    echo "${CYAN}reading version from latest tag...${NC}"
    tag=$(git describe --tags $(git rev-list --tags --max-count=1))
else
    echo "${CYAN}using specified tag ${YELLOW}${1}${CYAN} as version...${NC}"
    tag="$1"
fi
if [[ -e 'build/roles/europa/files/shell/version' ]]; then
   rm 'build/roles/europa/files/shell/version'
fi
echo $tag >> build/roles/europa/files/shell/version
echo "${CYAN}version is ${YELLOW}$tag${CYAN}..."

echo "${CYAN}switching to latest version...${NC}"
git checkout $tag

echo "${CYAN}dowloading Europa packages, please wait...${NC}"
cd build
sh fetch.sh
cd ..

if [[ $os == CYGWIN* ]]; then
    echo "${CYAN}Windows installation identified.${NC}"
    packer_zip='packer_0.8.6_windows_amd64.zip'
    appliance_folder='c:/appliances'
    packer_exe='packer.exe'
elif [[ $os == Darwin* ]]; then
    echo "${CYAN}Darwin installation identified.${NC}"
    packer_zip='packer_0.8.6_darwin_386.zip'
    appliance_folder='~/appliances'
    packer_exe='packer'
else
    echo "${RED}Installation on ${os} is not supported!"
    echo "cannot continue...${NC}"
    exit
fi

check_packer $packer_zip $packer_exe

if check_vm europa; then
    echo "${CYAN}Un-versioned Europa VM found in Virtual Box, deleting it...${NC}"
    VBoxManage unregistervm europa --delete
fi

echo "${CYAN}building the Europa appliance, please wait...${NC}"
./packer_files/"$packer_exe" build europa.vbox.json

if [[ ! -d $appliance_folder ]]; then
    echo "${CYAN}creating the ${appliance_folder} folder...${NC}"
    mkdir -p $appliance_folder
fi

echo "${CYAN}copying the Europa virtual appliance to ${YELLOW}${appliance_folder}${NC} ..."
echo "${CYAN}future imports can use this file."
cp -v europa-vbox/europa.ova $appliance_folder/europa_$tag.ova

echo "${CYAN}importing the Europa appliance into Virtual Box, please wait...${NC}"
VBoxManage import $appliance_folder/europa_$tag.ova --vsys 0 --vmname europa_$tag

read -n1 -p "Do you want to delete the installation files? [Y-N]" deleteFiles
case $deleteFiles in
    [Yy]* ) cd .. && rm -rf * ;;
    * ) echo "${CYAN}installation files can be found at $PWD${NC}" ;;
esac

endTime=$(date -u +"%s")
diff=$(($endTime-$startTime))

echo "${YELLOW}Europa build process complete: it took $(($diff / 60)) minutes and $(($diff % 60)) seconds.${NC}"

echo "${CYAN}Launching Virtual Box...${NC}"

(VirtualBox &)

read -p "Press any key to close the console..."

exit