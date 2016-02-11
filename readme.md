<a name="europa"/>
# EUROPA

<img src="build/roles/europa/files/logo/greeter-logo.png" width="300" height="300" align="right">

## Table of Contents
- [Overview](#overview)
  - [MinimumRequirements](#min-reqs)
- [Building Europa in Windows](#build-win)
  - [Installing Cygwin](#install-cyg)
  - [Running the build script](#run-build)
  	- [Building a specific version](#build-version)
  	- [Building the latest development code](#build-dev)
- [Building Europa in MacOS - Darwin](#build-mac)
- [Using Europa](#using-europa)
  - [Creating a shared folder](#creating_share)
  - [Managing proxy settings](#man-proxy)
- [Tools](#tools)
  - [Integrated Development Environments (IDEs)](#ide)
  - [Build Tools](#build)
  - [Languages](#lang)
  - [DevOps Tools](#devops)
  - [Other Tools](#other)
  - [Browsers](#browsers)
- [Appliances folder](#appliances)
- [Licensing](#license)


<a name="overview"/>
# Overview
Europa is a CentOS 7.2 Linux Virtual Machine with Development tools.
It allows to run linux and native Docker on Windows and MacOS desktops to speed up the process of installing the tools and middleware required to develop applications using Java, Scala, Groovy and JavaScript. 
It provides a ready to use set of development tools and the ability to run middleware such as Web Servers, Databases, etc. on linux containers as part of the environment via [Docker](https://www.docker.com/whatisdocker).

<a name="min-reqs"/>
# Minimum requirements

To run Europa, a machine with Windows Operating System, Virtual Box and 8Gb of RAM is required.

To run it optimally, it is recommended to have an Solid State Disk (SSD) drive and 12/16 Gb RAM with 8Gb allocated to the virtual machine.

The automated installation script has been tested on Windows 7 Enterprise SP1 64 bits, [Oracle VM Virtual Box 5.0.14](http://download.virtualbox.org/virtualbox/5.0.14) and CygWin 2.873 64 bits.

<a name="build-win"/>
# Building Europa in Windows

Europa can be built automatically in Windows using a shell script.
The following steps are required to launch the installation process.

**NOTE on network connection**: it is likely that running the installation script behind a proxy will fail due to proxy restrictions downloading the packages required by Europa from the internet.
Installing behind a proxy is therefore discouraged. This document does not include any proxy specific configuration required to build Europa.

**NOTE on packages download sites**: Europa tools are downloaded from the internet using the [fetch.sh](build/fetch.sh) file. As download sites fall outside  the control of this project, they can change overtime, leaving broken links and causing the build to fail. If this happens, such file needs to be updated to correct broken links so that the required packages are downloaded into the local cache before the image build process starts.

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
# Building Europa in MacOS

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

<a name="using-europa"/>
# Using Europa

- Launch Virtual Box, select the Europa virtual appliance and click start.
- The password for the europa user is **"eur0pa"** 
- The password for the root user is **"Passw0rd!"**.
- Change your password after first login: in the terminal type **passwd** and follow the instructions.

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

Once Europa is built, it can work behind a proxy.
To make it easy to switch proxy settings on and off, the Europa user provides a set of commands (in .bashrc) as follows:

- to get help/usage: **proxy**
- to set (or reset) the proxy: **proxy on** *my-proxy-uri:my-proxy-port*
- to switch the proxy off: **proxy off** 
- to switch the proxy on: **proxy on**
- to view the proxy status: **proxy status**
- to clear the current proxy settings: **proxy clear**

The above commands also change the GNOME desktop proxy settings, as used by some applications such as web browsers to connect to internet.

**NOTE**: the terminal has been set to **run command as login shell** by default so that the *.bash_profile* is loaded when the terminal is started.

<a name="tools"/>
# Tools
<a name="ide"/>
## Integrated Development Environments (IDE)

Europa has the following IDEs pre-installed:

| Tool | Version |  Description |
|:-----|:------------|:------------|
| ScalaIDE | Luna 4.3.0 | The primary tool used to develop Scala based applications using Play or Akka.|
| Eclipse| Mars 4.5.1 for JEE Developers | Eclipse is the primary tool to develop aplications using JBoss EAP, JBoss Fuse, JBoss BRMS and JBoss BPMS. After launching eclipse, using the eclipse marketplace feature, install JBoss Developer Studio 9. |
| IntelliJ IDEA Utimate (30 days Trial)| 15.0.3 IU | Provides a set of development productivity tools and can be used to develop Scala, Java, JavaScript and Groovy applications. **NOTE:** IntelliJ starts with a 30-day trial of Ultimate Edition. A valid key must be entered after the trial period to avoid expiration. After launching IntelliJ, activate plugins as required.|
| IntelliJ IDEA Community | 15.0.3 IC | The community edition of IntelliJ.|

<a name="build"/>
## Build Tools

The following build tools are included in the distro:

| Tool | Version | Description |
|:-----|:------------|:------------|
| Maven | 3.3.9 | Apache Maven is included as the standard build tool for Java based projects. |
| Gradle | 2.10 | Gradle is included as an alternative to Maven which leverages the use of Groovy instead of XML for build configuration files. Gradle provides a simpler way to create plugins and extensions when standard components are not good enough.|
|SBT| 0.13.9 | The Simple Build Tool (SBT) is provided primarily to build Scala projects. It uses Scala to define build tasks. It also allows to run the tasks in parallel from the shell.|
|Activator| 1.3.7 | A superset of SBT with additional **ui** and **new** commands.|

<a name="lang"/>
## Languages
| Language | Version | Description |
|:---------|:------------|:------------|
| Java | Oracle 8u74 | JDK 1.8  |
| Scala| 2.10/2.11 | supported via JDK 1.8 and provided via TypeSafe Activator, ScalaIDE and IntelliJ. |
| Groovy | 2.4.5 | Command Line and IDEs.|
| Ruby | 2.0.0 p598 | Command line and IDEs. |
| JavaScript|   | In IDEs. |
| TypeScript|   | In IDEs. |
| Other |   | Via IDEs plugins. |

<a name="devops"/>
## DevOps tools
| Tool | Version | Description |
|:-----|:------------|:------------|
|Ansible| 2.0.1.0-0.1.rc1 | To create provisioning scripts for environment automation, based on Docker containers. |
|Vagrant| 1.8.1 | To spin up and manage docker containers for development. |
|Docker| 1.10.0-1 | To create Docker images and containers. |
| Docker Compose | 1.6.0, build d99cad6 | A tool for defining and running multi-container Docker applications.|
| OpenShift Cient Tools | 1.38.4 | Command line interace tool to connect to OpenShift. |

<a name="other"/>
## Other tools
| Tool | Version | Description |
|:-----|:------------|:------------|
|Haroopad| 0.13.1 | A document processor based on Markdown. |
|Git|  2.7.0-1 | Open source distributed version control system. |
|MySQL Workbench| 6.3.6-2 | A unified visual tool for data modeling, SQL development, and comprehensive administration tools for server configuration, user administration and backup.|
|Robomongo| 0.9.0-rc4 | A shell-centric cross-platform MongoDB management tool.|

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

Europa is lincensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0).
The software is distributed WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND as stated in the license.


## Virtual Box Licensing 

Europa uses Virtual Box base packages (does not need the extension pack).
The base packages are released under the GNU General Public License V2.
There is no need to purchase a commercial license, provided that the extension pack is not used.
Commercial licenses provide access to enterprise features and support that could be needed for mission critical use of Virtual Box.
For more information see [here](https://www.virtualbox.org/wiki/Licensing_FAQ).

## InteliJ IDEA Licensing

Europa has IntelliJ Idea Ultimate which comes with a 30-day trial version.
If you intend to use it beyond the trial period, you must buy a license key from [JetBrains](https://www.jetbrains.com/store/).

Additionally, Europa also comes with IntelliJ Community Edition which is free of charge.

# XScreenSaver

Europa features [XScreenSaver](https://www.jwz.org/xscreensaver/) by [Jamie Zawinski](https://www.jwz.org/) and many others. Thanks to Tim Robinson for contributing and suggesting its inclusion within Europa.

