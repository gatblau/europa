<a name="europa"></a>
# EUROPA

<img src="build/roles/europa/files/logo/greeter-logo.png" width="300" height="300" align="right">

## Table of Contents
- [Overview](#overview)
  - [Minimum Requirements](#min-reqs)
- [Download Europa](#download)
- [Using Europa](#using-europa)
  - [Changing the system language](#change_lang)
  - [Creating a shared folder](#creating_share)
  - [Managing proxy settings](#man-proxy)
- [Using OpenShift](#openshift)
- [Tools](#tools)
  - [Integrated Development Environments (IDEs)](#ide)
  - [Build Tools](#build)
  - [Package Managers](#pac-man)
  - [Languages](#lang)
  - [DevOps Tools](#devops)
  - [Other Tools](#other)
  - [Browsers](#browsers)
- [Licensing](#license)
- [XScreenSaver](#xscr)


<a name="overview"></a>
# Overview

Europa is a Virtual Appliance based on CentOS Linux.  

It comes with a set of the common software development tools (both user interface and command line driven).

It is aimed at software developers using Windows or Mac computers who want to use a Linux environment for container based development.

It provides a ready to use, standardised set of development tools and the ability to run middleware such as Web Servers, Databases, etc. on linux containers as part of the environment via [Docker](https://www.docker.com/whatisdocker) and [OpenShift](https://www.openshift.com).

For more information about using OpenShift in Europa check the section [Using OpenShift](docs/openshift.md)

<a name="min-reqs"></a>
# Minimum requirements

To run Europa, a machine with Windows or OS X Operating System, Virtual Box 5 and a minimum of 8Gb of RAM in total are required. The virtual machine is configured by default to run with 4 Gb of RAM.

To run it optimally, it is recommended to have an Solid State Disk (SSD) drive and 16 Gb RAM with 8 Gb allocated to the virtual machine. This is because if you want to run multiple docker containers comfortably you need memory and a fast disk. The fast disk also helps with intensive I/O operations usually required by the installed IDEs.

<a name="download"><a/>
# [Download Europa](https://github.com/gatblau/europa/releases)
To get started, download the latest Open Virtualization Appliance (OVA) file from the [releases](https://github.com/gatblau/europa/releases) section.

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

<a name="using-europa"></a>
# Using Europa

- Launch Virtual Box, select the Europa virtual appliance and click start.
- The password for the europa user is **"eur0pa"**
- The password for the root user is **"Passw0rd!"**.
- Change your password after first login: in the terminal type **passwd** and follow the instructions.

<a name="change_lang"></a>
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

<a name="creating_share"></a>
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

<a name="man-proxy"></a>
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

### NTLM Authentication

Europa comes with [cntlm](http://cntlm.sourceforge.net/), an NTLM authenticating proxy.

The **proxy on** command automatically starts cntlm and **proxy off** automatically stops it. 

You can see the status of the service by typing the following on the terminal:

```bash
$ systemctl status cntlmd
```

**IMPORTANT**: Before using the **proxy** command, edit the **/etc/cntlm.conf** file specifying your username, domain, proxy and password according to your specific proxy settings.
Failing to do do will result in the cntlmd service failing to start.

For specific information on how to configure cntlm for your proxy take a look [here](http://cntlm.sourceforge.net/).

<a name="openshift"></a>
# Using OpenShift

OpenShift Origin 3.6.0 can be launched by using the **oc** command as follows:
``` bash
$ oc cluster up
```
The above command will start OpenShift in a Docker container. Access to internet is required for the command to download the Docker images required to run OpenShift.

To take the cluster down, simply type:
``` bash
$ oc cluster down
```

For more information take a look [here](https://docs.openshift.org/).

<a name="tools"></a>
# Tools

<a name="ide"></a>
## Integrated Development Environments (IDE)

Europa has the following IDEs pre-installed:

| Tool | Version |
|:-----|:------------|
| ScalaIDE | The primary tool used to develop Scala based applications using Play or Akka.|
| Eclipse| Eclipse is the primary tool to develop aplications using JBoss EAP, JBoss Fuse, JBoss BRMS and JBoss BPMS. After launching eclipse, using the eclipse marketplace feature, install JBoss Developer Studio 9. |
| Visual Studio Code | A lightweight source code that comes with built-in support for JavaScript, TypeScript and Node.js and has a rich ecosystem of extensions for other languages (such as C++, C#, Python, PHP, Go) and runtimes (such as .NET and Unity).|
| IntelliJ IDEA Community | The open source version of IntelliJ IDEA, a premier IDE (Integrated Development Environment) for Java, Groovy and other programming languages such as Scala or Clojure.|

<a name="build"></a>
## Build Tools

The following build tools are included in the distro:

| Tool | Description |
|:-----|:------------|
| Maven | Apache Maven is included as the standard build tool for Java based projects. |
| Gradle | Gradle is included as an alternative to Maven which leverages the use of Groovy instead of XML for build configuration files. Gradle provides a simpler way to create plugins and extensions when standard components are not good enough.|
|SBT| The Simple Build Tool (SBT) is provided primarily to build Scala projects. It uses Scala to define build tasks. It also allows to run the tasks in parallel from the shell.|

<a name="pac-man"></a>
## Package Managers

| Manager | Description |
|:--------|:------------|
| YUM | The Yellowdog Updater Modified utility for deploying RPM packages. |
| PIP | "Pip Installs Packages/Python" utility to install and manage software packages written in Python |
| NPM | Node Package Manager for JavaScript. |
| Bower | A package manager for web frameworks, libraries, assets, and utilities. |

<a name="lang"></a>
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

<a name="devops"></a>
## DevOps tools

| Tool | Description |
|:-----|:------------|
|Ansible| To create provisioning scripts for environment automation, based on Docker containers. |
|Docker| To create Docker images and containers. |
| Docker Compose | A tool for defining and running multi-container Docker applications.|
| OpenShift Origin | Docker / Kubernetes based container platform. |

<a name="other"></a>
## Other tools

| Tool | Description |
|:-----|:------------|
|Meld|Meld is a visual diff and merge tool targeted at developers. Meld helps compare files, directories, and version controlled projects.|
|Git| Open source distributed version control system. |
|MySQL Workbench| A unified visual tool for data modeling, SQL development, and comprehensive administration tools for server configuration, user administration and backup.|

<a name="browsers"></a>
## Browsers

| Browser |
|:-----|
|Firefox|
|Chrome|

<a name="license"></a>
# Licensing

Europa is lincensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0). The software is made available WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND as stated in the license.


## Virtual Box Licensing

Europa uses the Virtual Box base package released under the GNU General Public License V2. Therefore, a commercial license is not required to run Europa.

Commercial licenses would be required if the [extension pack](https://www.virtualbox.org/manual/ch01.html#intro-installing) was used. The pack provides access to enterprise features and comes with support that might be needed for mission critical use of Virtual Box. For more information on this see the [Virtual Box Licensing FAQ](https://www.virtualbox.org/wiki/Licensing_FAQ) page.

<a name="xscr"></a>
# XScreenSaver

Europa features [XScreenSaver](https://www.jwz.org/xscreensaver/) by [Jamie Zawinski](https://www.jwz.org/) and many others. Thanks to Tim Robinson for contributing and suggesting its inclusion within Europa.
