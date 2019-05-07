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
ROOT='../cache/'

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
download "https://dl.fedoraproject.org/pub/epel/" "epel-release-latest-7.noarch.rpm"
#download "http://mirror.centos.org/centos/7/os/x86_64/Packages/" "unzip-6.0-19.el7.x86_64.rpm"
download "http://mirror.centos.org/centos/7/os/x86_64/Packages/" "system-config-language-1.4.0-9.el7.noarch.rpm"
#downloadTo "https://download.oracle.com/otn-pub/java/jdk/12.0.1+12/69cfe15208a647278a19ef0990eea691/jdk-12.0.1_linux-x64_bin.rpm?AuthParam=1556778291_d3af0749ba8b1728edb4afae9bfebec2" "jdk-12.0.1_linux-x64_bin.rpm"
#download "https://download.oracle.com/java/GA/jdk12.0.1/69cfe15208a647278a19ef0990eea691/12/GPL/" "openjdk-12.0.1_linux-x64_bin.tar.gz"
download "https://github.com/AdoptOpenJDK/openjdk12-binaries/releases/download/jdk-12.0.1%2B12/" "OpenJDK12U-jdk_x64_linux_hotspot_12.0.1_12.tar.gz"
download "https://dl.google.com/linux/direct/" "google-chrome-stable_current_x86_64.rpm"
downloadTo "https://piccolo.link/sbt-1.2.8.zip" "sbt-1.2.8.zip"
download "https://services.gradle.org/distributions/" "gradle-4.0.2-bin.zip"
download "http://www-eu.apache.org/dist/maven/maven-3/3.6.1/binaries/" "apache-maven-3.6.1-bin.zip"
download "http://opensource.wandisco.com/centos/7/git/x86_64/" "wandisco-git-release-7-2.noarch.rpm"
download "http://opensource.wandisco.com/centos/7/git/x86_64/" "git-2.18.0-1.WANdisco.402.x86_64.rpm"
download "http://opensource.wandisco.com/centos/7/git/x86_64/" "perl-Git-2.18.0-1.WANdisco.402.noarch.rpm"
download "http://dl.bintray.com/groovy/maven/" "apache-groovy-binary-2.5.6.zip"
download "https://download-cf.jetbrains.com/idea/" "ideaIC-2019.1.1-jbr11.tar.gz"
download "http://downloads.typesafe.com/scalaide-pack/4.7.0-vfinal-oxygen-212-20170929/" "scala-SDK-4.7.0-vfinal-2.12-linux.gtk.x86_64.tar.gz"
download "http://ftp.halifax.rwth-aachen.de/eclipse//technology/epp/downloads/release/2019-03/R/" "eclipse-jee-2019-03-R-linux-gtk-x86_64.tar.gz"
download "https://cdn.mysql.com//Downloads/MySQLGUITools/" "mysql-workbench-community-8.0.16-1.el7.x86_64.rpm"
download "https://github.com/atom/atom/releases/download/v1.36.1/" "atom.x86_64.rpm"
# download "https://github.com/openshift/origin/releases/download/v3.6.0/" "openshift-origin-server-v3.6.0-c4dd4cf-linux-64bit.tar.gz"
download "https://github.com/openshift/origin/releases/download/v3.11.0/" "openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz"
download "https://az764295.vo.msecnd.net/stable/51b0b28134d51361cf996d2f0a1c698247aeabd8/" "code-1.33.1-1554971173.el7.x86_64.rpm"
#downloadTo "https://sourceforge.net/projects/cntlm/files/cntlm/cntlm%200.92.3/cntlm-0.92.3-1.x86_64.rpm/download" "cntlm-0.92.3-1.x86_64.rpm"
download "http://downloads.jboss.org/forge/releases/3.9.2.Final/" "forge-distribution-3.9.2.Final-offline.zip"
downloadTo "https://github.com/fabric8io/gofabric8/releases/download/v0.4.176/gofabric8-linux-amd64" "gofabric8"