<a name="europa"/>
# EUROPA

<img src="build/roles/europa/files/logo/greeter-logo.png" width="300" height="300" align="right">

## Table of Contents
- [Overview](#overview)
  - [Minimum Requirements](#min-reqs)
- [Downloading and Installing Europa](#download)
- [Building Europa](#build-europa)
    - [Network connection considerations](#net-con)
    - [Package download considerations](#pac-con)
    - [Version considerations](#ver-con)
    - [Building gold images considerations](#gold-im-con)
    - [VirtualBox considerations](#vb-con)
- [Building Europa in Windows](#build-win)
  - [Installing Cygwin](#install-cyg)
  - [Running the build script](#run-build)
    - [Building a specific version](#build-version)
    - [Building the latest development code](#build-dev)
- [Building Europa in OS X - Darwin](#build-mac)
- [Building Europa as VDI](#vdi)
- [Using Europa](#using-europa)
  - [Changing the system language](#change_lang)
  - [Creating a shared folder](#creating_share)
  - [Managing proxy settings](#man-proxy)
- [Using OpenShift](docs/openshift.md)
- [Tools](#tools)
  - [Integrated Development Environments (IDEs)](#ide)
  - [Build Tools](#build)
  - [Package Managers](#pac-man)
  - [Languages](#lang)
  - [DevOps Tools](#devops)
  - [Other Tools](#other)
  - [Browsers](#browsers)
- [Appliances folder](#appliances)
- [Licensing](#license)
- [XScreenSaver](#xscr)


<a name="overview"/>
# Overview
Europa is a Virtual Appliance based on CentOS Linux.  

It comes with a set of the common software development tools (both user interface and command line driven).

It is aimed at software developers using Windows or Mac computers who want to use a Linux environment for container based development.

It provides a ready to use, standardised set of development tools and the ability to run middleware such as Web Servers, Databases, etc. on linux containers as part of the environment via [Docker](https://www.docker.com/whatisdocker) and [OpenShift](https://www.openshift.com).

For more information about using OpenShift in Europa check the section [Using OpenShift](docs/openshift.md)

<a name="min-reqs"/>
# Minimum requirements

To run Europa, a machine with Windows or OS X Operating System, Virtual Box and a minimum of 8Gb of RAM in total are required. The virtual machine is configured by default to run with 4 Gb of RAM.

To run it optimally, it is recommended to have an Solid State Disk (SSD) drive and 16 Gb RAM with 8 Gb allocated to the virtual machine. This is because if you want to run multiple docker containers comfortably you need memory and a fast disk. The fast disk also helps with intensive I/O operations usually required by the installed IDEs.

<a name="download"/>
# [Downloading and Installing Europa](https://github.com/gatblau/europa/releases)
The easiest way to run Europa is to download the Open Virtualization Appliance (OVA) file from the [releases](https://github.com/gatblau/europa/releases) section.

Due to its size, the file has been zipped and split up into several smaller files to facilitate the download process.

### Installing the Appliance
After you have downloaded the required zip files into a folder in your computer, unzip them into the one single OVA file by clicking on the first file (e.g. europa_vx.x.x.ova.zip.001). Once you have the OVA file unzipped, import it in Virtual Box by double clicking it. You just need to make sure that Virtual Box is already installed before importing the OVA.

### Running Multiple Instances
You can import the appliance several times. Each time the appliance is imported a new instance is created. This way you can have multiple instances of Europa for different purposes if required. The OVA file is effectively a template for a virtual machine and not the virtual machine instance itself.

### Using other virtualization Products
In addition to Virtual Box, the OVA file can also be imported into other virtualization products supporting the OVA format (e.g. VMWare Workstation).

### Portability
The OVA file is portable, so it can run on any operating system having a virtualization product which supports the OVA format.

Alternatively, if you wish to customize the Europa build, you can build it from source as explained in the following section. This is only recommended for advanced users who understand the source code and can troubleshoot and customize the build process to their requirements.

<a name="build-europa"/>
# Building Europa

**NOTE**: *If you took the approach above to install Europa you do not need to read this section on building the environment as the gold build (i.e. the zipped OVA file in the [releases](https://github.com/gatblau/europa/releases) section) removes the need to build the application from scratch.*

The automated build script has been tested on:
- Windows 7 Enterprise SP1 64 bit with [CygWin](https://www.cygwin.com/) 2.873 64 bit
- OS X Yosemite 10.10.4 64 bit

using [Oracle VM Virtual Box 5.0.16](http://download.virtualbox.org/virtualbox/5.0.16) for both operating systems.

If the intention is to deploy Europa across multiple teams / people, it is recommended that a gold image is built using the build scripts, and then the resulting Open Virtual Appliance (OVA) file is distributed, to avoid having to deal with issues people might encounter when building on different machines.

The creation of the Europa OVA file has been automated using a combination of tools which are launched by a wrapping shell script. The intention is to make the build process as simple as possible, however, in some circumstances, there are certain aspects which can prevent the build scripts from running swiftly, and are explained below so they can be overcome if presented.

<a name="net-con"/>
### Network connection considerations
It is likely that running the installation script behind a proxy will fail due to proxy restrictions downloading the packages required by Europa from the internet. Installing behind a proxy is therefore discouraged. This document does not include any proxy specific configuration required to build Europa.

<a name="pac-con"/>
### Package download site considerations

Europa tools are downloaded from the internet using the [fetch.sh](build/fetch.sh) file. As download sites fall outside  the control of this project, they can change overtime, leaving broken links and causing the build to fail. If this happens, such file needs to be updated to correct broken links so that the required packages are downloaded into the local cache before the image build process starts.

<a name="ver-con"/>
### Version considerations

The build script is programmed to pick the latest tag from github. This means that whilst the development of the next version in the master might be on the way, the script will build the latest tag by default. This tag might be already out of date if, for example download links have changed as described above. To build the latest development version you need to add a tag at the end of the build script command as described in [Building the latest development code](#build-dev) below.

<a name="gold-im-con"/>
### Building gold image considerations
It is recommended that when building a gold image, the downloaed packages are backed up in case the build process has to be repeated at a later stage and those packages are not available anymore online.

Once the image is built, it is also advisable to break it down into various zip files so they can be easily downloaded especially in low bandwidth conditions.

<a name="vb-con"/>
### Virtual Box considerations
After the [kickstart](build/http/ks.cfg) file starts configuring the virtual machine, the progress can be seen in the VirtualBox windows. After a while, the window display switches off preventing you to see progress. In order to refresh the display, simply press the right swift key on your keyboard.

Europa installs VirtualBox guest additions so that resizing and drag and drop features are enabled. These additions are for the particular version of VirtualBox used to build the Virtual Machine. It is therefore recommended to use the version of VirtualBox compatible with the Europa VM.

<a name="build-win"/>
## Building Europa in Windows

<a name="install-cyg"/>
#### Installing Cygwin

**Why do I need Cygwin?** Cygwin provides a Windows console with Linux tools that is needed to run Europa's shell installation script.

**NOTE:** if you have git for windows installed, including git bash, you might encounter issues running the installation script below. So it is recommended to uninstall git for windows and reboot the pc.
After the installation of Europa completes, Cygwin will contain git.

- Ensure you have a reliable internet connection.
- Ensure the power saving settings in your machine are set to avoid turning it off due to inactivity, as the installation process will take a while.
- Download [Cygwin](https://cygwin.com/install.html) and launch it. In the setup screen:
    - "Choose a Download Source" screen: select install from internet, click next
    - "Select Root Install Directory" screen: select install for all users, leave the default root directory, click next
    - "Select Local Package Directory" screen: leave the default value, click next
    - "Select Your Internet Connection" screen: select "Direct Connection", assumes no proxy, click next
    - "Choose a Download Site" screen: select a mirror that is close to your region. For example: [ftp.mirrorservice.org](ftp://ftp.mirrorservice.org) in the case of the UK. Click next
    - "Select Packages" screen: locate and type in the "Search" text box as follows
       - type **lynx**, expand the "Web Default" option in the tree view and click on Skip, the version of Lynx to be installed should now show
       - click the clear button next to the search box and type **wget**, expand the "Web Default" option in the tree view and click on Skip, the version of wget to be installed should now show
       - click next to start the installation.
    - "Resolving Dependencies" screen: click next
    - "Progress" screen: wait until all dependencies are downloaded and the next button becomes enabled, click next
    - "Create Icons" screen: uncheck "Create icon on Desktop" and check "Add icon to Start Menu", click finish
- Click the Windows Start Menu button
- In the "Search for programs and files" box type "cygwin", the "Cygwin64 Terminal" icon should show at the top of the menu
- Right click on the item and select "Pin to Start Menu"
- Run the Cygwin terminal **as Administrator**: find Cygwin in the Windows Start Menu, right-click it and select "Run as administrator".

<a name="run-build"/>
#### Runing the build script

Copy the following block, paste it in the Cygwin terminal and press enter to execute it:

```sh  
mkdir europa && cd europa && wget https://raw.githubusercontent.com/gatblau/europa/master/europaw.sh && sh europaw.sh
```

Now let the script to automatically install the required software and build the Europa virtual machine.
Be prepared to wait, the installation takes approximately 90 minutes.

**TIP**: if the Virtual Box windows goes black, press the right shift key down to make it show again.

<a name="build-version"/>
#### Building a Specific Version

If a build is required that is not for the last version (tag) in github, then pass in the name of the required version to the build script as follows:

... **europaw.sh specific-version-name-here**

<a name="build-dev"/>
#### Building the latest development code

If you want to build the latest development state, then pass in a name that is not a actual tag name (e.g. "dev-may-14") to the build script as follows:

... **europaw.sh dev-may-14**


<a name="build-mac"/>
## Building Europa in OS X - Darwin

- Install [wget](http://rudix.org/packages/wget.html)
- Install packer
   - Download [packer](https://www.packer.io/downloads.html) for MacOS 64 bits
   - Unzip the file and place it in a folder of your choice
   - Add an "export PACKER_HOME=/Users/YOUR_USER/Tools/packer" to the ~/.bash_profile
   - Add "PATH=$PATH:$PACKER_HOME" to the ~/.bash_profile
   - Test it by typing **packer** in the terminal
- Install [git](https://git-scm.com/downloads)
- Install [Oracle VM Virtual Box 5.0.14](http://download.virtualbox.org/virtualbox/5.0.14/VirtualBox-5.0.14-105127-OSX.dmg)

Copy the following block, paste it in the MacOSX terminal and press enter to execute it:

```sh  
mkdir europa && cd europa && wget https://raw.githubusercontent.com/gatblau/europa/master/europa.sh && sh europa.sh
```

<a name="vdi"/>
## Building Europa as VDI
If the intention is to provide Europa as a Virtual session from a data centre, the suggested approach to create the image is:

- Create a Virtual Machine running CentOS 7+ with Gnome - as per [kickstart](build/http/ks.cfg) file (or hardened version of it)
- Install ansible in the virtual machine (e.g. yum install ansible)

- execute the [fetch.sh](build/fetch.sh) file to create the local cache as follows:

```sh
sh fetch.sh
```

- execute ansible with the local provisioner as follows:

```sh
ansible-playbook europa.yml -i inv-local.txt
```

- remove the ansible files
- template the Virtual Machine


<a name="using-europa"/>
# Using Europa

- Launch Virtual Box, select the Europa virtual appliance and click start.
- The password for the europa user is **"eur0pa"**
- The password for the root user is **"Passw0rd!"**.
- Change your password after first login: in the terminal type **passwd** and follow the instructions.

<a name="change_lang"/>
## Changing the system language

### Configuring the language after the build
To change Europa's language follow the steps below:
- After the first start, follow the instructions in the displayed gnome window to change the keyboard layout to your specific keyboard
- Open the terminal and type "**sudo system-config-language**", this will launch the graphical user interface to change the system language
- Select the language of your choice
- Select if you wish to change the name of the system folders to the selected language
- Close the window and restart Europa for changes to take place

**NOTE**: at this point a new image could be exported for distribution with the new settings.

### Changing the language before the build

If you want to build the image with a particular language by default, update the [kickstart](build/http/ks.cfg) file before running the build process by finding and updating the lines below:

```sh
# Language for the install
lang en_GB.UTF-8

# The keyboard type
keyboard uk
```

<a name="creating_share"/>
## Creating a shared folder
It is recommended that Europa is treated as a transient Virtual Machine. This is, all development files should sit outside of Europa, in its host machine. To achieve this, create a shared folder in Europa which points to a folder of your choice in your host machine. Then store all your development files there. This ensures that if for any reason you need to destroy and re-import the virtual machine, all your files are preserved in your host machine.

The following is an example of the command required to create a shared folder:

```sh
VBoxManage sharefolder add "europa_vm_name" -name "share" --hostpath "c:\user\<username>\share"
```
Alternatively, the shared folder can be created using the VirtualBox settings for the required virtual machine, as follows:

- Open virtual box and select the specific virtual machine you want to add the shared folder to.
- Go to Settings
- In "machine folders" click to add a new one
- In the folder path "Other" navigate to the path of the shared folder in the host machine
- Select "automount"
- Select "make permanent"
- Click OK.

The shared folder should appear on the desktop.
From Europa's terminal, the shared folder can be accessed using the path **"/media/folder_name"**.
The europa user has been granted access to the shared folder by default as part of the build process.

<a name="man-proxy"/>
## Managing Proxy Settings

Once Europa is built, it can connect to internet behind a corporate proxy. To make it easy to switch proxy settings on and off (depending on whether you are inside or outside the corporate network), a [proxy command](build/roles/europa/files/shell/proxy.sh) is provided in the terminal that can be used as follows:

- to get help/usage: **proxy**
- to set (or reset) the proxy: **proxy on** *my-proxy-uri:my-proxy-port*
- to switch the proxy off: **proxy off**
- to switch the proxy on: **proxy on**
- to view the proxy status: **proxy status**
- to clear the current proxy settings: **proxy clear**

The above commands also change the GNOME desktop proxy settings, as used by some applications such as web browsers to connect to internet.

**NOTE**: the terminal has been set to **run command as login shell** by default so that the *.bash_profile* is loaded when the terminal is started.

<a name="openshift"/>
# [Using OpenShift](docs/openshift.md)

<a name="tools"/>
# Tools
<a name="ide"/>
## Integrated Development Environments (IDE)

Europa has the following IDEs pre-installed:

| Tool | Version |
|:-----|:------------|
| ScalaIDE | The primary tool used to develop Scala based applications using Play or Akka.|
| Eclipse| Eclipse is the primary tool to develop aplications using JBoss EAP, JBoss Fuse, JBoss BRMS and JBoss BPMS. After launching eclipse, using the eclipse marketplace feature, install JBoss Developer Studio 9. |
| IntelliJ IDEA Utimate (30 days Trial)| Provides a set of development productivity tools and can be used to develop Scala, Java, JavaScript and Groovy applications. <ENTER> **NOTE:** IntelliJ starts with a 30-day trial of Ultimate Edition. A valid key must be entered after the trial period to avoid expiration. After launching IntelliJ, activate plugins as required.|
| IntelliJ IDEA Community | The community edition of IntelliJ.|

<a name="build"/>
## Build Tools

The following build tools are included in the distro:

| Tool | Description |
|:-----|:------------|
| Maven | Apache Maven is included as the standard build tool for Java based projects. |
| Gradle | Gradle is included as an alternative to Maven which leverages the use of Groovy instead of XML for build configuration files. Gradle provides a simpler way to create plugins and extensions when standard components are not good enough.|
|SBT| The Simple Build Tool (SBT) is provided primarily to build Scala projects. It uses Scala to define build tasks. It also allows to run the tasks in parallel from the shell.|
|Activator| A superset of SBT with additional **ui** and **new** commands.|

<a name="pac-man"/>
## Package Managers
| Manager | Description |
|:--------|:------------|
| YUM | The Yellowdog Updater Modified utility for deploying RPM packages. |
| PIP | "Pip Installs Packages/Python" utility to install and manage software packages written in Python |
| NPM | Node Package Manager for JavaScript. |
| Bower | A package manager for web frameworks, libraries, assets, and utilities. |

<a name="lang"/>
## Languages
| Language | Description |
|:---------|:------------|
| Java | JDK   |
| Scala| supported via JDK 1.8 and provided via TypeSafe Activator, ScalaIDE and IntelliJ. |
| Groovy | Command Line and IDEs.|
| Ruby | Command line and IDEs. |
| JavaScript|  In IDEs. |
| TypeScript|   In IDEs. |
| Other |   Via IDEs plugins. |

<a name="devops"/>
## DevOps tools
| Tool | Description |
|:-----|:------------|
|Ansible| To create provisioning scripts for environment automation, based on Docker containers. |
|Vagrant| To create and configure lightweight, reproducible, and portable development environments. |
|Docker| To create Docker images and containers. |
| Docker Compose | A tool for defining and running multi-container Docker applications.|
| OpenShift | Docker / Kubernetes based container platform. |

<a name="other"/>
## Other tools
| Tool | Description |
|:-----|:------------|
|Haroopad| A document processor based on Markdown. |
|Git| Open source distributed version control system. |
|MySQL Workbench| A unified visual tool for data modeling, SQL development, and comprehensive administration tools for server configuration, user administration and backup.|
|Robomongo| A shell-centric cross-platform MongoDB management tool.|

<a name="browsers"/>
## Browsers
| Browser |
|:-----|
|Firefox|
|Chrome|

<a name="appliances"/>
# Appliances folder
After the build completes, an Open Virtual Appliance (OVA) file is saved in the following directory:

| Operating System | Appliances Folder | VirtualBox VMs folder |
|:-----------------|:------------------|:----------------------|
| Windows | c:\appliances | c:\users\ {user}\VirtualBox VMs\ |
| Darwin  | ~/appliances | ~/VirtualBox VMs/ |

The appliance can be imported with the following command:

```sh  
VBoxManage import <path-to-ova-file> --vsys 0 --vmname <ova-file-name> --unit 7 --disk "<VirtualBox-VMs-folder>/<ova-filename>/<ova-filename>.vmdk"
```
This can be useful if there is a need to reinstall the appliance, for example to go back to its original settings.

<a name="license"/>
# Licensing

Europa is lincensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0). The software is made available WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND as stated in the license.


## Virtual Box Licensing

Europa uses the Virtual Box base package released under the GNU General Public License V2. Therefore, a commercial license is not required to run Europa.

Commercial licenses would be required if the [extension pack](https://www.virtualbox.org/manual/ch01.html#intro-installing) was used. The pack provides access to enterprise features and comes with support that might be needed for mission critical use of Virtual Box. For more information on this see the [Virtual Box Licensing FAQ](https://www.virtualbox.org/wiki/Licensing_FAQ) page.

## InteliJ IDEA Licensing

Europa provides IntelliJ Idea Ultimate, which comes with a 30-day trial version. If you intend to use it beyond the trial period, you must buy a license key from [JetBrains](https://www.jetbrains.com/store/).

Additionally, Europa also provides IntelliJ Community Edition which is licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0) as described [here](http://www.jetbrains.org/display/IJOS/FAQ).

<a name="xscr"/>
# XScreenSaver
Europa features [XScreenSaver](https://www.jwz.org/xscreensaver/) by [Jamie Zawinski](https://www.jwz.org/) and many others. Thanks to Tim Robinson for contributing and suggesting its inclusion within Europa.
