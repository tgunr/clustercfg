#! /bin/sh
######################################################################
# Common Playnet (BE/RA) scripting functions, variables, environment.
#
# Variables:
#  $BE_ROLE
#	the name of the host process this host is intended for,
#  $pidof
#	path to the 'pidof' command,
#
# Functions:
#  die
#	print an error message and exit the current script
#  execute
#	attempt to execute the given command line, reporting an
#   error if it fails and terminating the script.
#   (if $DEBUG is set, reports the command line being attempted)

if test "x$BE_ROLE" = "x" -a -r /home/wwiiol/etc/berole.rc ; then
 BE_ROLE=`cat /home/wwiiol/etc/berole.rc`
fi
if test "x$BE_ROLE" = "x" ; then
 echo "FAIL: No BE_ROLE environment variable"
 exit 1
fi

if test -r /playnet/etc/cluster.rc ; then
 . /playnet/etc/cluster.rc
fi

apps="${BE_ROLE}"
case "${BE_ROLE}" in
	strat*)		apps="${apps} dbd"	;;
	mmhost*)	apps="${apps} pinghostd" ;;
	*) ;;
esac

pidof=
for path in /bin /usr/bin /usr/local/bin /sbin /usr/sbin /usr/local/sbin
do
 if test "x$pidof" = "x" -a -x "$path/pidof" ; then
  pidof="$path/pidof"
 fi
done
if test "x$pidof" = "x" ; then
 echo "FAIL: Unable to find 'pidof'."
 exit 1
fi

export PATH="/playnet/bin:/playnet/wwiiol/bin:/home/wwiiol/bin:${PATH}"
export CLUSTER_DOWN=${CLUSTER_DOWN:-/tmp/CLUSTER_DOWN}

function die () {
	echo "ERROR: $*"
	exit 1
}

function execute () {
	if [ ! -z "${DEBUG}" -a "${DEBUG}" != "0" ] ; then echo "--? '${*}'" ; fi
    eval $* || die "'$*' failed"
}
