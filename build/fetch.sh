#!/usr/bin/env bash
# fetches all required packages and copies them to the ROOT folder

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
            wget -O $ROOT$2 $1$2
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
download "http://dl.fedoraproject.org/pub/epel/7/x86_64/e/" "epel-release-7-7.noarch.rpm"
download "http://download.oracle.com/otn-pub/java/jdk/8u92-b14/" "jdk-8u92-linux-x64.rpm" "Cookie: oraclelicense=accept-securebackup-cookie"
download "https://dl.google.com/linux/direct/" "google-chrome-stable_current_x86_64.rpm"
download "https://yum.dockerproject.org/repo/main/centos/7/Packages/" "docker-engine-selinux-1.10.0-1.el7.centos.noarch.rpm"
download "https://yum.dockerproject.org/repo/main/centos/7/Packages/" "docker-engine-1.10.0-1.el7.centos.x86_64.rpm"
download "https://dl.bintray.com/sbt/native-packages/sbt/0.13.11/" "sbt-0.13.11.zip"
download "https://services.gradle.org/distributions/" "gradle-2.10-bin.zip"
download "http://www.mirrorservice.org/sites/ftp.apache.org/maven/maven-3/3.3.9/binaries/" "apache-maven-3.3.9-bin.zip"
download "http://downloads.typesafe.com/typesafe-activator/1.3.7/" "typesafe-activator-1.3.7.zip"
download "http://opensource.wandisco.com/centos/7/git/x86_64/" "wandisco-git-release-7-2.noarch.rpm"
download "http://opensource.wandisco.com/centos/7/git/x86_64/" "git-2.8.0-1.WANdisco.308.x86_64.rpm"
download "http://opensource.wandisco.com/centos/7/git/x86_64/" "perl-Git-2.8.0-1.WANdisco.308.noarch.rpm"
download "http://dl.bintray.com/groovy/maven/" "apache-groovy-binary-2.4.7.zip"
download "https://releases.hashicorp.com/vagrant/1.8.1/" "vagrant_1.8.1_x86_64.rpm"
download "https://download-cf.jetbrains.com/idea/" "ideaIU-2016.1.3.tar.gz"
download "https://download-cf.jetbrains.com/idea/" "ideaIC-2016.1.3.tar.gz"
download "http://downloads.typesafe.com/scalaide-pack/4.3.0-vfinal-luna-211-20151201/" "scala-SDK-4.3.0-vfinal-2.11-linux.gtk.x86_64.tar.gz"
download "http://www.mirrorservice.org/sites/download.eclipse.org/eclipseMirror/technology/epp/downloads/release/mars/R/" "eclipse-jee-mars-R-linux-gtk-x86_64.tar.gz"
download "https://bitbucket.org/rhiokim/haroopad-download/downloads/" "haroopad-v0.13.1-x64.tar.gz"
download "http://cdn.mysql.com//Downloads/MySQLGUITools/" "mysql-workbench-community-6.3.6-2.el7.x86_64.rpm"
download "https://download.robomongo.org/0.9.0-rc9/linux/" "robomongo-0.9.0-rc9-linux-x86_64-0bb5668.tar.gz"
download "https://github.com/openshift/origin/releases/tag/v1.2.0" "openshift-origin-client-tools-v1.2.0-2e62fab-linux-64bit.tar.gz"