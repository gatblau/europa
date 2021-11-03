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
# Performs initialisation of the linux environment including the installation
# of Ansible for the provisioning of the various required tools.
# This script is executed by packer using a shell provisioner.
#
# fetches all required packages and copies them to the ROOT folder
#
#ROOT='../cache/'
ROOT='../iso/'

# creates the root folder if it does not exist
if [[ ! -e $ROOT ]]; then
    mkdir $ROOT
fi

# removes files from the root folder if 'clean' is passed as parameter to the shell script
if [[ $1 == "clean" ]]; then
    echo "Refreshing cache in progress...\n"
    rm $ROOT*
fi

# removes all files with zero length size which were the result of previous failed downloads
remove_empty_files() {
    find $ROOT. -size 0c -type f -delete
}

download() {
    # if the requested file does not exist in the root folder
    if [[ ! -e $ROOT$2 ]]; then
        # if a header string is specified for the download
        if [[ $3 ]]; then
            # download using the specified HTTP header
            wget --header "$3" -O $ROOT$2 $1$2
        else
            # download without an HTTP header
            wget --no-check-certificate -O $ROOT$2 $1$2
        fi
        if [[ $? != 0 ]]; then
            remove_empty_files
            echo "ERROR: BROKEN LINK FOUND @ $1$2"
            echo "The build process cannot continue."
            echo "The likely cause of this is that the link was probably changed after the release was created."
            echo "Check that the latest master has corrected it."
            echo "If not, you need to update the fetch.sh file fixing the broken URI before trying again!"
            exit -1
        fi
    fi
}

# download from URI but assign different filename
downloadTo() {
    if [[ ! -e $ROOT$2 ]]; then
        wget -O $ROOT$2 $1
    fi
}

remove_empty_files

# download the following files to the root folder if they do not exist
# for future reference, alternate provider of 'free' OpenJDK
# download "https://github.com/AdoptOpenJDK/openjdk12-binaries/releases/download/jdk-12.0.1%2B12/" "OpenJDK12U-jdk_x64_linux_hotspot_12.0.1_12.tar.gz"
downloadTo "https://access.cdn.redhat.com/content/origin/files/sha256/23/2323ad44d75df1a1e83048a34e196ddfedcd6c0f6c49ea59bf08095e3bb9ef65/rhel-8.1-x86_64-dvd.iso?_auth_=1627149443_6ff7b4dfb1f3c10dd25b093c4a26da34" "rhel-8.3-x86_64-dvd.iso"
