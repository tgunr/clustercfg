#! /bin/bash
# Check for a recognized operating system platform.

# Linux Standard Base is a way of allowing
# scripts like this to tell what they're running on.
lsbFile="/etc/lsb-release"

function requestPermissionToUpgrade() {
 required=$* ; shift

 echo "* ${DISTRIB_RELEASE} is currently installed."

 # Ask the user if they want to upgrade
 proceed=0
 while [ ${proceed} -eq 0 ]
 do
  echo -n "Perform automatic distribution upgrade to next release? (yes/no): "
  read reply
  if [ "${reply}" = "yes" ] ; then proceed=1 ; fi
  if [ "${reply}" = "no" ] ; then proceed=1 ; fi
  if [ ${proceed} -eq 0 ] ; then echo "Please respond 'yes' or 'no'" ; fi
 done

 # What was their answer?
 if [ "${reply}" = "no" ] ; then
  if [ "x$required" = "x1" ] ; then
   die "Cannot proceed without upgrade."
  fi
  return 0
 fi

 # Start the upgrade.
 report "Beginning automatic upgrade"
 apt-get -q -q -y install update-manager-core
 perl -i -pe 's/^(\s*Prompt\s*=\s*)(\S+)(.*)/$1normal$3/' /etc/update-manager/release-upgrades || die "Unable to configure for normal updates"
 apt-get -q -q -y update || die "Unable to update apt-cache"

 report "Starting dist-upgrade"
 "do-release-upgrade" || die "Upgrade failed"
 
 report "Rebooting"
 reboot

 exit 0
}


checkOperatingSystem() {
 report "Checking Operating System"

 if [ ! -f "${lsbFile}" ] ; then
  die "Unrecognized operating system (missing $lsbFile)"
 fi

 . ${lsbFile}

 if [ -z "${DISTRIB_ID}" ] ; then
  die "Unrecognized operating system ($lsbFile does not defined DISTRIB_ID)"
 fi
 if [ "${DISTRIB_ID}" != "Ubuntu" ] ; then
  warn "Only 'Ubuntu' is officially supported"
  return 0
 fi

 if [ -z "${DISTRIB_RELEASE}" ] ; then
  die "Unrecognized operating system ($lsbFile does not defined DISTRIB_RELEASE)"
 fi

 report "DISTRIB_ID=${DISTRIB_ID}, DISTRIB_RELEASE=${DISTRIB_RELEASE}"

 if [ ${DISTRIB_RELEASE/\.*/} -lt 11 ] ; then
  warn "Ubuntu 11.04 or higher is required"
  requestPermissionToUpgrade 1
 fi
 if [ ${DISTRIB_RELEASE/\.*/} -gt 11 ] ; then
  warn "Only Ubuntu 11 has been tested so far. Proceed at your own risk!"
  return 0
 fi

 case ${DISTRIB_RELEASE} in
  11.10) return 0 ;;
  *) ;;
 esac

 warn "Ubuntu 11.04 detected. 11.10 is recommended."
 requestPermissionToUpgrade
}

checkOperatingSystem || die "Failed operating system check"

