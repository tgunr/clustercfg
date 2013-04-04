#! /bin/bash
######################################################################
# Usage: (as root user)
#  ROLE="strat|chat|map|cell" prepare-host.sh
#
# Installs packages, configures nfs, etc.

export PRODUCT="wwiiol"

######################################################################
## Helper functions

debugOut() {
 if test "x$DEBUG" = "x1" ; then echo -ne "\e[m\e[32m" ; echo "--i  $*" ; echo -ne "\e[m" ; fi
}
report() {
 echo -ne "\e[m*** \e[36m" ; echo $* ; echo -ne "\e[m"
}
wait_5s() {
 if [ "x${NO_WAITS}" != "x1" ] ; then
  for i in 5 4 3 2 1 ; do echo -ne "\r(Continuing in $i seconds)" ; sleep 1 ; done
  echo -ne "\r                                      \r"
  sleep 1
 fi
}
warn() {
 echo -ne "\e[m\e[31mWARNING: \e[33m" ; echo $* ; echo -ne "\e[m"
 wait_5s
}
showUsage() {
 echo -ne "\e[m\e[33m"
 echo "Usage:"
 echo "    ROLE=strat|map|chat|cell|auth [options] $0"
 echo "Options:"
 cat <<END_OPTIONS
    APT_CACHE=nn.nn.nn.nn        Configure APT to use proxy at given address
    ARENA_ID=nnn                 Specifies arena ID (map only)
    AUTH_ADDRESS=nn.nn.nn.nn     Specifies IP address of auth server
    AUTH_DB=nn.nn.nn.nn          Specifies auth database (if not auth server)
    AUTHDB_USER=...              Override default authdb username (authuser)
    AUTHDB_PASSWD=...            Specify default authdb password
    AUTH_ERROR_URL=http://       Prefix for browser-redirects on auth errors
    CLUSTER=clustername          Short name for the cluster (map only)
	CLEAN_DB=1                   Remove an re-install MySQL (db only)
    DATAPKG_FILE=...path...      Non-default /playnet/data tar file (map only)
    DEBUG=1                      Enable extra script output
    DEFAULT_DBCHARSET=...        Default database characterset
    GAMEDB_USER=...              Override default username for main database user
    GAMEDB_PASSWD=...            Override default password for main database user
    GATEWAY=nn.nn.nn.nn          Gateway IP for primary network
    GATEWAY2=nn.nn.nn.nn         Gateway IP for secondary network
    HOST=nnn                     Host address for the machine (last octet)
    IS_AUTH=1                    Include local auth installation (map only)
    NAMESERVER=...               IP address of primary nameserver
    NETMASK=nn.nn.nn.nn          Netmask for primary network
    NETMASK2=nn.nn.nn.nn         Netmask for secondary network
    NETWORK=...                  Network address for primary interface
    NETWORK2=nn.nn.nn            Network address for [optional] secondary interface
    NO_DB_INSTALL=1              Skip database installation
    NO_WAITS=1                   Don't sleep after warnings
    ROOTDB_PASSWD=...            Specify the root password for the game database
END_OPTIONS
 echo -ne "\e[m"
}
die() {
 echo -e "\e[m\e[31mERROR: $*\e[m"
 exit 1
}
dieWithUsage() {
 echo -e "\e[m\e[31mERROR: $*\e[m"
 showUsage
 exit 1
}
ww2mkdir() {
  if [ ! -d "${1}" ] ; then
   debugOut "Creating [${1}] with wwiiol as owner"
   su -c "mkdir -p '${1}'" -l wwiiol
  fi
}
function run_script () {
 local script="$1" ; shift
 cmd=". scripts/${script}"
 debugOut "Executing: $cmd"
 eval ${cmd} || die "${script} failed."
}
function require_var () {
 # Test the variable named in arg[0] is not empty.
 local test="[ \! -z \${$1} ]"
 eval ${test} || die "No value for ${1} specified (required for ${BE_ROLE} servers)."
}

case "x$1" in
    x) ;;
    x-h|x-?|x--help|x-help) showUsage ; exit 0 ;;
    x*) dieWithUsage "Unknown command line arguments: $*" ;;
esac

######################################################################
## Check for pre-requisites.

# Require this script to be run as root.
if [ $(id -u) -ne 0 ] ; then
  dieWithUsage "Must be run as superuser or via sudo"
fi

# Get the user ID of the wwiiol user.
Uid=$(id -u wwiiol)
if [ -z ${Uid} ] ; then die "No 'wwiiol' user found - has to be added manually." ; fi
Gid=$(id -g wwiiol)
if [ -z ${Gid} ] ; then die "No 'wwiiol' group found - has to be added manually." ; fi

# Check for Ubuntu
. scripts/operating-system-check.sh || die "Operating System Checks failed"

######################################################################
## Environment / parameter checks.

# "ROLE" specifies what kind of server we will be running,
# which is used to identify packages that will be installed,
# which scripts from the "scripts" folder will be run, and
# what the contents of /home/wwiiol/etc/berole.rc will be.
Role=""
Strat=0 ; DBD=0 ; Chat=0 ; Map=0 ; Cell=0 ; AuthHost=0
isDev=0
case x${ROLE} in
    xauth*) Role="authHost" ; AuthHost=1 ;;
	xstrat) Role="stratd" ; Strat=1 ; DBD=1 ;;
    xchat|xchatd) Role="chatd"; Chat=1 ;;
    xmap|xmmhost|xmmhostd) Role="mmhostd"; Map=1 ;;
    xcell|xhostd|xcellhost) Role="hostd"; Cell=1 ;;
    x) dieWithUsage "No ROLE specified." ;;
    x*) dieWithUsage "Unknown ROLE: ${ROLE}." ; Fail=1 ;;
esac
BE_ROLE=${Role}

if [ ${AuthHost} -eq 1 ] ; then
 # Force these values to be used for AuthHost.
 CLUSTER="Auth"
 ARENA_ID="0"
 APP_ID="0"
fi

export GAMEDB_USER=${GAMEDB_USER:-wwiiol}
export AUTHDB_USER=${AUTHDB_USER:-authuser}

######################################################################
# Translate the role into various configuration parameters.

NFSServer=0			# Whether or not this server acts as cluster NFS master
IsLocalMaster=0		# Whether this role is responsible for providing local configuration files
					# (chat, cell, etc, use the nfs mount instead)
DBServer=0			# Whether this host will be hosting it's own database
Auth=0				# Will I be hosting Auth
AuthDB=0			# Will have local copy of the auth db (inc. mirrors)
IS_AUTH=${IS_AUTH:-0}
CleanDB=${CLEAN_DB:-0}

if [ ${IS_AUTH} -eq 1 ] ; then
  if [ ${Strat} -eq 0 ] ; then
    dieWithUsage "'IS_AUTH' can only be specified for Map role"
  fi
  debugOut "Configuring as Strat + Auth [IS_AUTH=1]"
  Auth=1
fi
if [ ${AuthHost} -eq 1 ] ; then Auth=1 ; fi

# For now, the NFS server is also the strat server
if [ ${Strat} -eq 1 ] ; then NFSServer=1 ; fi

# Auth and strat hosts need local data stuff.
if [ ${Strat} -eq 1 -o ${Auth} -eq 1 ] ; then IsLocalMaster=1 ; fi
if [ ${Strat} -eq 1 -o ${Auth} -eq 1 ] ; then AuthDB=1 ; fi

# Database host is also the strat server
if [ ${IsLocalMaster} -eq 1 ] ; then DBServer=1 ; fi
if [ ${NO_DB_INSTALL} ] ; then DBServer=0 ; fi

debugOut "Role=${Role}, Strat=${Strat}, DBD=${DBD}, Chat=${Chat}, Map=${Map}, Cell=${Cell}, AuthHost=${AuthHost}, isDev=${isDev}, BE_ROLE=${BE_ROLE},"
debugOut "NFSServer=${NFSServer}, ILM=${IsLocalMaster}, DBServer=${DBServer}, Auth=${Auth}"

######################################################################
# Check for required variables.

# "CLUSTER" specifies the name to be given to this cluster.
if [ ${IsLocalMaster} -eq 1 ] ; then require_var CLUSTER ; fi
if [ ${IsLocalMaster} -eq 1 ] ; then require_var ARENA_ID ; fi
if [ ${DBServer} -eq 1 -a -z "${ROOTDB_PASSWD}" ] ; then require_var ROOTDB_PASSWD ; fi
if [ ${IsLocalMaster} -eq 1 ] ; then require_var AUTH_ERROR_URL ; fi
if [ ${AuthDB} -eq 1 ] ; then require_var AUTHDB_USER ; require_var AUTHDB_PASSWD ; fi
require_var AUTH_ADDRESS

######################################################################
# Validate configuration with regards to networking.

is_eth0_configured="$(perl -ne 's/\s*\#.*// ; print if /eth0\s.*static/' /etc/network/interfaces)"
if [ -z "${is_eth0_configured}" -a \( -z "${NETWORK}" -o -z "${HOST}" \) ] ; then
 dieWithUsage "'eth0' is not statically configured and no NETWORK or HOST specified."
fi

curNet=$(ifconfig eth0 | perl -ne 'print $1 if /inet\s+addr:(\d+\.\d+\.\d+)\.(\d+)/')
net="${NETWORK:-$curNet}"
if [ -z "${net}" ] ; then
 dieWithUsage "'eth0' is not configured, and no network address provided."
fi
if [ "$net" != "$curNet" ] ; then
 warn "eth0 is currently configured as ${curNet}, will reconfigure as ${net}"
 NeedNet=1
fi
if [ "${net}" = "192.168.0" ] ; then
 isDev=1
 warn "192.168.0 network: assuming DEV cluster."
fi

curAddr=$(ifconfig eth0 | perl -ne "print \$1 if /inet addr:\\d+\.\\d+\.\\d+\\.(\\d+)/")
if [ ! -z "${curAddr}" ] ; then
 debugOut "eth0 currently configured as ${curAddr}"
 if [ ! -z "${HOST}" -a "${HOST}" != "${curAddr}" ] ; then
  warn "Reconfiguring host as ${HOST}"
  NeedNet=1
 fi
fi
addr=${HOST:-${curAddr}}

if [ ${NFSServer} -eq 1 -a $isDev -eq 1 -a ${ARENA_ID} -eq 1 ] ; then
 if [ "x${DEV_ARENA_1}" != "xPlease" ] ; then
  die "Configuring dev cluster as ARENA_ID ${ARENA_ID} is a really, really bad idea.\n" \
     "  If you're absolutely sure you want to do this,\n" \
     "  set the environment variable DEV_ARENA_1 to Please, e.g.\n" \
     "  export DEV_ARENA_1=Please"
 else
  warn "Configuring DEV cluster as ARENA_ID ${ARENA_ID}"
 fi
fi

######################################################################
# Report configuration status.

debugOut "Configure script starting:"
debugOut "ROLE=${ROLE} NFSServer=${NFSServer} DBServer=${DBServer}"
debugOut "Using primary IP Address ${net}.${addr}"
if [ ! -z "${NETWORK_SEC_NET}" ] ; then
 debugOut "Secondary IP address ${NETWORK_SEC_NET}.${addr}"
fi

# Make backup copies of files we know we're going to tamper with.
for file in /etc/network/interfaces /etc/fstab /etc/exports /home/wwiiol/.bashrc /etc/security/limits.conf
do
 if [ -f "${file}" -a ! -f "${file}.orig" ] ; then debugOut "Saving backup copy of $file as $file.orig" ; cp "${file}" "${file}.orig" ; fi
done

######################################################################

#####################################
## ## ## BEGIN CONFIGURATION ## ## ##
#####################################

export BE_ROLE Role Strat DBD Chat Map Cell isDev AuthHost Auth AuthDB CLUSTER ARENA_ID APP_ID NFSServer DBServer IsLocalMaster NO_DB_INSTALL CleanDB

run_script "configure-interfaces.sh"

run_script "configure-apt-proxy.sh"

run_script "adjust-ulimits.sh"

run_script "generate-berole-rc.sh"

run_script "create-directory-structure.sh"

run_script "generate-cluster-rc.sh"

run_script "remove-extra-packages.sh"

run_script "install-os-packages.sh"

run_script "install-game-packages.sh"

run_script "configure-nfs.sh"

run_script "configure-ldconfig.sh"

run_script "install-database-server.sh"

run_script "populate-wwiiol-home.sh"

export BE_ROLE Role Strat DBD Chat Map Cell isDev AuthHost Auth AuthDB CLUSTER ARENA_ID APP_ID NFSServer DBServer IsLocalMaster NO_DB_INSTALL CleanDB

# Execute presumably sorted list of scripts and
# execute those which are either cluster wide
# or match our role.
if [ -d ./scripts ] ; then
 for script in scripts/[0-9]*.sh
 do
  cmd="ROLE=${Role} . \"${script}\""
  case "$script" in
   *.${CLUSTER}.*|*.cluster.*|*[.\+]${Role}[.\+]*)
    debugOut "Running ${cmd}"
    eval $cmd || die "Error executing $cmd: $?"
   ;;
   *) debugOut "/Skipping/ ${cmd}"
   ;;
  esac
 done
fi

echo -e "\e[m\e[32mSUCCESS: Finished installation.\e[m"

