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
    find $ROOT. -size 0c -delete
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
download "http://mirror.centos.org/centos/7/os/x86_64/Packages/" "unzip-6.0-16.el7.x86_64.rpm"
download "http://mirror.centos.org/centos/7/os/x86_64/Packages/" "system-config-language-1.4.0-7.el7.noarch.rpm"
download "http://download.oracle.com/otn-pub/java/jdk/8u144-b01/" "jdk-8u144-linux-x64.rpm" "Cookie: oraclelicense=accept-securebackup-cookie"
download "https://dl.google.com/linux/direct/" "google-chrome-stable_current_x86_64.rpm"
downloadTo "https://cocl.us/sbt01316zip" "sbt-0.13.16.zip"
download "https://services.gradle.org/distributions/" "gradle-4.0.2-bin.zip"
download "http://www-eu.apache.org/dist/maven/maven-3/3.5.0/binaries/" "apache-maven-3.5.0-bin.zip"
download "http://opensource.wandisco.com/centos/7/git/x86_64/" "wandisco-git-release-7-2.noarch.rpm"
download "http://opensource.wandisco.com/centos/7/git/x86_64/" "git-2.8.0-1.WANdisco.308.x86_64.rpm"
download "http://opensource.wandisco.com/centos/7/git/x86_64/" "perl-Git-2.8.0-1.WANdisco.308.noarch.rpm"
download "http://dl.bintray.com/groovy/maven/" "apache-groovy-binary-2.4.12.zip"
download "https://download-cf.jetbrains.com/idea/" "ideaIC-2017.2.1.tar.gz"
download "http://downloads.typesafe.com/scalaide-pack/4.6.1-vfinal-neon-212-20170609/" "scala-SDK-4.6.1-vfinal-2.12-linux.gtk.x86_64.tar.gz"
download "http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/oxygen/R/" "eclipse-jee-oxygen-R-linux-gtk-x86_64.tar.gz"
download "http://cdn.mysql.com//Downloads/MySQLGUITools/" "mysql-workbench-community-6.3.9-1.el7.x86_64.rpm"
download "https://github.com/atom/atom/releases/download/v1.18.0/" "atom.x86_64.rpm"
download "https://github.com/openshift/origin/releases/download/v3.6.0/" "openshift-origin-server-v3.6.0-c4dd4cf-linux-64bit.tar.gz"
download "https://az764295.vo.msecnd.net/stable/cb82febafda0c8c199b9201ad274e25d9a76874e/" "code-1.14.2-1500507068.el7.x86_64.rpm"
downloadTo "https://sourceforge.net/projects/cntlm/files/cntlm/cntlm%200.92.3/cntlm-0.92.3-1.x86_64.rpm/download" "cntlm-0.92.3-1.x86_64.rpm"
download "http://downloads.jboss.org/forge/releases/3.7.2.Final/" "forge-distribution-3.7.2.Final-offline.zip"