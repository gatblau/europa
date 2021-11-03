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
	    echo "installing Packer..."
	    mkdir packer_files
	    cd packer_files
	    wget 'https://releases.hashicorp.com/packer/1.7.2/'"$1"
	    unzip "$1"
	    chmod +x "$2"
	    export PATH=$PATH:"$PWD"
	    cd ..
	else
	    echo "packer is already installed..."
    fi
}

check_rhel_env() {
    if [[ -z "${RH_USERNAME}" || -z "${RH_PASSWORD}" ]]; then
      echo "RH_USERNAME or RH_PASSWORD environment variable not set"
      return 1
    else
      echo "RH_USERNAME: ${RH_USERNAME}"
      echo "RH_PASSWORD: ${RH_PASSWORD}"
    fi
}

os="$(uname)"

# reset terminal colour
out $os "${NC}"

check_rhel_env
# exits if a RH credential env not set
if [[ $? -ne 0 ]] ; then
    return 1
fi

startTime=$(date -u +"%s")

out $os "${CYAN}" "downloading build scripts..."
if [[ -d europa ]]; then
   out $os "${YELLOW}" "pre existing build files found, refreshing them whilst preserving cached files..."
   #git clone https://github.com/gatblau/europa.git tmp
   git clone https://github.com/tim-m-robinson/europa-2.0-beta.git tmp
   rm -rf europa/.git
   mv tmp/.git europa
   rm -rf tmp
   rm -rf europa/europa-vbox
else
   #git clone https://github.com/gatblau/europa.git europa
   git clone https://github.com/tim-m-robinson/europa-2.0-beta.git europa
fi

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
if [[ -e 'build/roles/pre-build/files/version' ]]; then
   rm 'build/roles/pre-build/files/version'
fi
echo $tag >> build/roles/pre-build/files/version

out $os "${CYAN}" "switching to latest version..."
git checkout $tag

out $os "${CYAN}" "dowloading Europa packages, please wait..."
cd build

# download packages
sh fetch.sh

# exits if a package is not found due to a broken link
if [[ $? -ne 0 ]] ; then
    return 1
fi

cd ..

if [[ $os == CYGWIN* ]]; then
    out $os "${CYAN}" "getting packer for WINDOWS build..."
    packer_zip='packer_1.7.2_windows_amd64.zip'
    appliance_folder='c:/appliances'
    packer_exe='packer.exe'
	export PATH=$PATH:"/cygdrive/c/Program Files/Oracle/VirtualBox"
	vms=$(VBoxManage.exe list vms)
	if [[ $vms == *"\"europa_$1\""* ]]; then
       VBoxManage.exe unregistervm europa_$1 --delete
    fi
    # creates a shared folder in europa to the host machine
    VBoxManage.exe sharedfolder add "europa_$1" -name "europa" -hostpath "$USERPROFILE\europa"
    import_root="c:/users/"$USERNAME"/VirtualBox VMs"
elif [[ $os == Darwin* ]]; then
    out $os "${CYAN}" "getting packer for DARWIN build..."
    packer_zip='packer_1.7.2_darwin_amd64.zip'
    appliance_folder='appliances'
    packer_exe='packer'
    vms=$(VBoxManage list vms)
	if [[ $vms == *"\"europa_$1\""* ]]; then
       VBoxManage unregistervm europa_$1 --delete
    fi
    import_root="VirtualBox VMs"
else
    out $os "${RED}" "Installation on ${os} is not supported!, cannot continue..."
    return
fi

check_packer $packer_zip $packer_exe

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
VBoxManage import $appliance_folder/europa_$tag.ova --vsys 0 --vmname europa_$tag --unit 7 --disk "$import_root/europa_$tag/europa_$tag.vmdk"

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

return
