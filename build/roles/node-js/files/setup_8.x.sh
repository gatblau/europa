#!/usr/bin/env bash
# Discussion, issues and change requests at:
#   https://github.com/nodesource/distributions
#
# Script to install the NodeSource Node.js 8.x repo onto an
# Enterprise Linux or Fedora Core based system.
#
# Run as root or insert `sudo -E` before `bash`:
#
# curl -sL https://rpm.nodesource.com/setup_8.x | bash -
#   or
# wget -qO- https://rpm.nodesource.com/setup_8.x | bash -
#

print_status() {
  local outp=$(echo "$1" | sed -r 's/\\n/\\n## /mg')
  echo
  echo -e "## ${outp}"
  echo
}

bail() {
  echo 'Error executing command, exiting'
  exit 1
}

exec_cmd_nobail() {
  echo "+ $1"
  bash -c "$1"
}

exec_cmd() {
  exec_cmd_nobail "$1" || bail
}

print_status "Installing the NodeSource Node.js 8.x repo..."

print_status "Inspecting system..."

if [ ! -x /bin/rpm ]; then
  print_status "\
You don't appear to be running an Enterprise Linux based \
system, please contact NodeSource at \
https://github.com/nodesource/distributions/issues if you think this \
is incorrect or would like your distribution to be considered for \
support.\
"
  exit 1
fi

## Annotated section for auto extraction in test.sh
#-check-distro-#

## Check distro and arch
echo "+ rpm -q --whatprovides redhat-release || rpm -q --whatprovides centos-release || rpm -q --whatprovides cloudlinux-release || rpm -q --whatprovides sl-release"
DISTRO_PKG=$(rpm -q --whatprovides redhat-release || rpm -q --whatprovides centos-release || rpm -q --whatprovides cloudlinux-release || rpm -q --whatprovides sl-release)
echo "+ uname -m"
UNAME_ARCH=$(uname -m)


if [ "X${UNAME_ARCH}" == "Xi686" ]; then
  DIST_ARCH=i386
elif [ "X${UNAME_ARCH}" == "Xx86_64" ]; then
  DIST_ARCH=x86_64
else

  print_status "\
You don't appear to be running a supported machine architecture: ${UNAME_ARCH}. \
Please contact NodeSource at \
https://github.com/nodesource/distributions/issues if you think this is \
incorrect or would like your architecture to be considered for support. \
"
  exit 1

fi

if [[ $DISTRO_PKG =~ ^(redhat|centos|cloudlinux|sl)- ]]; then
    DIST_TYPE=el
elif [[ $DISTRO_PKG =~ ^system-release- ]]; then # Amazon Linux
    DIST_TYPE=el
elif [[ $DISTRO_PKG =~ ^(fedora|korora)- ]]; then
    DIST_TYPE=fc
else

  print_status "\
You don't appear to be running a supported version of Enterprise Linux. \
Please contact NodeSource at \
https://github.com/nodesource/distributions/issues if you think this is \
incorrect or would like your architecture to be considered for support. \
Include your 'distribution package' name: ${DISTRO_PKG}. \
"
  exit 1

fi

if [[ $DISTRO_PKG =~ ^system-release-201[4-9]\. ]]; then  #NOTE: not really future-proof

  # Amazon Linux, for 2014.* use el7, older versions are unknown, perhaps el6
  DIST_VERSION=7

else

  ## Using the redhat-release-server-X, centos-release-X, etc. pattern
  ## extract the major version number of the distro
  DIST_VERSION=$(echo $DISTRO_PKG | sed -r 's/^[[:alpha:]]+-release(-server|-workstation)?-([0-9]+).*$/\2/')

  if ! [[ $DIST_VERSION =~ ^[0-9][0-9]?$ ]]; then

    print_status "\
Could not determine your distribution version, you may not be running a \
supported version of Enterprise Linux. \
Please contact NodeSource at \
https://github.com/nodesource/distributions/issues if you think this is \
incorrect. Include your 'distribution package' name: ${DISTRO_PKG}. \
"
    exit 1

  fi

fi


## Given the distro, version and arch, construct the url for
## the appropriate nodesource-release package (it's noarch but
## we include the arch in the directory tree anyway)
RELEASE_URL_VERSION_STRING="${DIST_TYPE}${DIST_VERSION}"
RELEASE_URL="\
https://rpm.nodesource.com/pub_8.x/\
${DIST_TYPE}/\
${DIST_VERSION}/\
${DIST_ARCH}/\
nodesource-release-${RELEASE_URL_VERSION_STRING}-1.noarch.rpm"

#-check-distro-#

print_status "Confirming \"${DIST_TYPE}${DIST_VERSION}-${DIST_ARCH}\" is supported..."

## Simple fetch & fast-fail to see if the nodesource-release
## file exists for this distro/version/arch
exec_cmd_nobail "curl -sLf -o /dev/null '${RELEASE_URL}'"
RC=$?

if [[ $RC != 0 ]]; then
    print_status "\
Your distribution, identified as \"${DISTRO_PKG}\", \
is not currently supported, please contact NodeSource at \
https://github.com/nodesource/distributions/issues \
if you think this is incorrect or would like your distribution to be considered for support"
    exit 1
fi

## EPEL is needed for EL5, we don't install it if it's missing but
## we can give guidance
if [ "$DIST_TYPE" == "el" ] && [ "$DIST_VERSION" == "5" ]; then

  print_status "Checking if EPEL is enabled..."

  echo "+ yum repolist enabled 2> /dev/null | grep epel"
  repolist=$(yum repolist enabled 2> /dev/null | grep epel)

  if [ "X${repolist}" == "X" ]; then
    print_status "Finding current EPEL release RPM..."

    ## We can scrape the html to find the latest epel-release (likely 5.4)
    epel_url="http://dl.fedoraproject.org/pub/epel/5/${DIST_ARCH}/"
    epel_release_view="${epel_url}repoview/epel-release.html"
    echo "+ curl -s $epel_release_view | grep -oE 'epel-release-[0-9\-]+\.noarch\.rpm'"
    epel=$(curl -s $epel_release_view | grep -oE 'epel-release-[0-9\-]+\.noarch\.rpm')
    if [ "X${epel}" = "X" ]; then
      print_status "Error: Could not find current EPEL release RPM!"
      exit 1
    fi

    print_status "\
The EPEL (Extra Packages for Enterprise Linux) repository is a\n\
prerequisite for installing Node.js on your operating system. Please\n\
add it and re-run this setup script.\n\
\n\
The EPEL repository RPM is available at:\n\
  ${epel_url}${epel}\n\
You can try installing with: \`rpm -ivh <url>\`\
"

    exit 1
  fi

fi

print_status "Downloading release setup RPM..."

## Two-step process to install the nodesource-release RPM,
## Download to a tmp file then install it directly with `rpm`.
## We don't rely on RPM's ability to fetch from HTTPS directly
echo "+ mktemp"
RPM_TMP=$(mktemp || bail)

exec_cmd "curl -sL -o '${RPM_TMP}' '${RELEASE_URL}'"

print_status "Installing release setup RPM..."

## --nosignature because nodesource-release contains the signature!
exec_cmd "rpm -i --nosignature --force '${RPM_TMP}'"

print_status "Cleaning up..."

exec_cmd "rm -f '${RPM_TMP}'"

print_status "Checking for existing installations..."

## Nasty consequences if you have an existing Node or npm package
## installed, need to inform if they are there
echo "+ rpm -qa 'node|npm' | grep -v nodesource"
EXISTING_NODE=$(rpm -qa 'node|npm|iojs' | grep -v nodesource)

if [ "X${EXISTING_NODE}" != "X" ]; then

  print_status "\
Your system appears to already have Node.js installed from an alternative source.\n\
Run \`\033[1myum remove -y nodejs npm\033[22m\` (as root) to remove these first.\
"

fi

print_status "\
Run \`\033[1myum install -y nodejs\033[22m\` (as root) to install Node.js 8.x and npm.\n\
You may also need development tools to build native addons:\n\
  \`yum install -y gcc-c++ make\`\
"

## Alternative to install dev tools: `yum groupinstall 'Development Tools'

exit 0
