# EUROPA

## Overview
Europa is a Linux virtual machine with Docker and development tools.
It allows to run linux and native Docker on Windows desktops to speed up the process of installing the tools and middleware required to develop applications using Java, Scala, Groovy and JavaScript. 
It provides a ready to use set of development tools and the ability to run middleware such as Web Servers, Databases, etc. on linux containers as part of the environment via [Docker](https://www.docker.com/whatisdocker).

## Using Europa

### Minimum requirements

To run Europa, a machine with Windows Operating System, Virtual Box and 8Gb of RAM is required.

To run it optimally, it is recommended to have an Solid State Disk (SSD) drive and 12/16 Gb RAM with 8Gb allocated to the virtual machine.

The automated installation script has been tested on Windows 7 Enterprise SP1 64 bits, Oracle VM Virtual Box 5.0.8 and CygWin 2.2.1 64 bits.


# Building Europa

Europa can be build completely automatically using a shell script.
The following steps are required to launch the installation process.

#### Install Cygwin

Cygwin provides a Windows console with Linux tools that is needed to run Europa's shell installation script.

- Ensure you have a reliable internet connection.
- Ensure the power saving settings in your machine are set to avoid turning it off due to inactivity, as the installation process will take a while.
- Download [Cygwin](https://cygwin.com/install.html) and launch it. In the setup screen:
    - Keep all the default settings except when connecting from a corporate network. If so, in the internet connection screen, select the option to use the browser settings.
    - You should see a list of mirrors, select one and click next
    - In the select packages screen pick the packages below.
      To do this, type the package name in the search box in the installer and check the selected package. 
        - **lynx** (Lynx is required to deploy the Cygwin package manager **"apt-cyg"**)
        - **wget** 
        - **ncurses**
    - Start the installation.
- Run the Cygwin terminal **as Administrator**: find Cygwin in the Windows Start Menu, right-click it and select "Run as administrator".

#### Set Proxy (if required)

If behind a corporate firewall, run the following export command, replacing username, password, host and port to the values required by your proxy:

```sh
export http_proxy=http://username:password@host:port/
```

#### Run the installation script

Copy the following block, paste it in the Cygwin terminal and press enter to execute it:

```sh  
mkdir europa && cd europa && wget https://raw.githubusercontent.com/gatblau/europa/master/europa.sh && sh europa.sh
```

Now let the script to automatically install the required software and build the Europa virtual machine.
Be prepared to wait, the installation takes approximately 90 minutes.

**TIP**: if the Virtual Box windows goes black, press the right shift key down to make it show again.

## Using Europa

Launch Virtual Box, select the Europa image and adjust its settings as follows:

- Increase the machine Video Memory depending on your hardware.
- If possible, try to increase the RAM used by the machine to over 4Gb.
- Within General -> Advanced: set "Shared Clipboard" and "Drag & Drop" items to **Bidirectional**.
- Start the virtual machine
- The password for the europa user is **eur0pa** and the one for the root user is **Passw0rd!**.
  It is advisable to change them after your first login.


## Provided Components
### Integrated Development Environments (IDE)

Europa has the following IDEs pre-installed:

| Tool | Version |  Description |
|:-----|:------------|:------------|
| ScalaIDE | 4.2.0 Luna | The primary tool used to develop Scala based applications using Play or Akka.|
| Eclipse| JEE Mars | Eclipse is the primary tool to develop aplications using JBoss EAP, JBoss Fuse, JBoss BRMS and JBoss BPMS. After launching eclipse, using the eclipse marketplace feature, install JBoss Developer Studio 9. |
| IntelliJ IDEA| 14.1.5 | Provides a nice set of development productivity tools and can be used to develop Scala, Java, JavaScript and Groovy applications. **NOTE:** IntelliJ starts with a 30-day trial of Ultimate Edition. A valid key must be entered after the trial period to avoid expiration. After launching IntelliJ, activate plugins as required.|

### Build Tools

The following build tools are included in the distro:

| Tool | Version | Description |
|:-----|:------------|:------------|
| Maven | 3.3.3 | Apache Maven is included as the standard build tool for Java based projects. |
| Gradle | 2.8 | Gradle is included as an alternative to Maven which leverages the use of Groovy instead of XML for build configuration files. Gradle provides a simpler way to create plugins and extensions when standard components are not good enough.|
|SBT| 0.13.9 | The Simple Build Tool (SBT) is provided primarily to build Scala projects. It uses Scala to define build tasks. It also allows to run the tasks in parallel from the shell.|
|Activator| 1.3.6 | A superset of SBT with additional **ui** and **new** commands.|

### Languages
| Language | Version | Description |
|:---------|:------------|:------------|
| Java | Oracle 8u66 | supported via JDK 1.8 and provided via JDBS and IntelliJ. |
| Scala| 2.10/2.11 | supported via JDK 1.8 and provided via TypeSafe Activator, ScalaIDE and IntelliJ. |
| Groovy | 2.4.5 | suported via Command Line and IDEs.|
| JavaScript|   |best support via IntelliJ.|
|Other|   | supported via IDEs plugins.|

### DevOps tools
| Tool | Version | Description |
|:-----|:------------|:------------|
|Ansible| 2.x+ | To create provisioning scripts for environment automation, based on Docker containers. |
|Vagrant| 1.7.4 | To spin up and manage docker containers for development. |
|Docker| 1.7.1 | To create Docker images and containers. |

### Other tools
| Tool | Version | Description |
|:-----|:------------|:------------|
|Haroopad| 0.13.1 | A document processor based on Markdown. |
|Git|  2.4.1 | Open source distributed version control system. |
|MySQL Workbench| 6.3.4 | A unified visual tool for data modeling, SQL development, and comprehensive administration tools for server configuration, user administration and backup.|
|Robomongo| 0.8.5 | A shell-centric cross-platform MongoDB management tool.|

### Browsers 
| Browser |
|:-----|
|Firefox| 
|Chrome| 
