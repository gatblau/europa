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
    fi
}

# download from URI but assign different filename
downloadTo() {
    if [[ ! -e $ROOT$2 ]]; then
        wget -O $ROOT$2 $1
    fi
}

# download the following files to the root folder if they do not exist
download "http://dl.fedoraproject.org/pub/epel/7/x86_64/e/" "epel-release-7-5.noarch.rpm"
download "http://download.oracle.com/otn-pub/java/jdk/8u72-b15/" "jdk-8u72-linux-x64.rpm" "Cookie: oraclelicense=accept-securebackup-cookie"
download "https://dl.google.com/linux/direct/" "google-chrome-stable_current_x86_64.rpm"
download "http://mirror.centos.org/centos/7/extras/x86_64/Packages/" "docker-1.8.2-10.el7.centos.x86_64.rpm"
download "https://dl.bintray.com/sbt/native-packages/sbt/0.13.9/" "sbt-0.13.9.zip"
download "https://services.gradle.org/distributions/" "gradle-2.10-bin.zip"
download "http://www.mirrorservice.org/sites/ftp.apache.org/maven/maven-3/3.3.9/binaries/" "apache-maven-3.3.9-bin.zip"
download "http://downloads.typesafe.com/typesafe-activator/1.3.7/" "typesafe-activator-1.3.7.zip"
download "http://opensource.wandisco.com/centos/7/git/x86_64/" "wandisco-git-release-7-2.noarch.rpm"
download "http://opensource.wandisco.com/centos/7/git/x86_64/" "git-2.7.0-1.WANdisco.284.x86_64.rpm"
download "http://opensource.wandisco.com/centos/7/git/x86_64/" "perl-Git-2.7.0-1.WANdisco.284.noarch.rpm"
download "http://dl.bintray.com/groovy/maven/" "apache-groovy-binary-2.4.5.zip"
download "https://releases.hashicorp.com/vagrant/1.8.1/" "vagrant_1.8.1_x86_64.rpm"
download "https://d1opms6zj7jotq.cloudfront.net/idea/" "ideaIU-15.0.3.tar.gz"
download "https://d1opms6zj7jotq.cloudfront.net/idea/" "ideaIC-15.0.3.tar.gz"
download "http://downloads.typesafe.com/scalaide-pack/4.3.0-vfinal-luna-211-20151201/" "scala-SDK-4.3.0-vfinal-2.11-linux.gtk.x86_64.tar.gz"
download "http://www.mirrorservice.org/sites/download.eclipse.org/eclipseMirror/technology/epp/downloads/release/mars/R/" "eclipse-jee-mars-R-linux-gtk-x86_64.tar.gz"
download "https://bitbucket.org/rhiokim/haroopad-download/downloads/" "haroopad-v0.13.1-x64.tar.gz"
download "http://cdn.mysql.com//Downloads/MySQLGUITools/" "mysql-workbench-community-6.3.6-2.el7.x86_64.rpm"
download "http://download.robomongo.org/0.9.0-rc4/linux/" "robomongo-0.9.0-rc4-linux-x86_64-8c830b6.tar.gz"