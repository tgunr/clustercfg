######################################################################
# If this machine is a local master, then it needs to provide a
# cluster configuration file, /playnet/etc/cluster.rc

# Need the cluster configuration.
if [ ${IsLocalMaster} -eq 1 ] ; then
 cat >/playnet/etc/cluster.rc <<END_CLUSTER_RC
# Cluster-wide configuration for ${PRODUCT} {$CLUSTER} cluster.
export PRODUCT="${PRODUCT}"
export ARENA_ID="${ARENA_ID}"
export AUTH_ADDRESS="${AUTH_ADDRESS}"
export AUTH_LAST="${AUTH_ADDRESS}"
export AUTH_DB="${AUTH_DB:-${AUTH_ADDRESS}}"
export AUTH_ERROR_URL="${AUTH_ERROR_URL}"
export BASE_ADDRESS="192.168.10.0"
export BUG_DB_ADDRESS="66.28.224.239"
export CLUSTER_DOWN="/tmp/CLUSTER_DOWN"
export DBSE_PRIMARY_ADDRESS="192.168.10.1"
export WWII_CLUSTER="${CLUSTER}"
export WWII_DB_ADDRESS="192.168.10.1"
export WWII_IRC_SERVER="${IRC_SERVER:-$irc}"
export TEUL_UWEB_PATH="/playnet/wwiiol/web/debug"

# Where to find lua scripts and shared objects.
export LUA_PATH='/playnet/wwiiol/lua/?;/playnet/wwiiol/lua/?.lua;/playnet/wwiiol/share/lua/5.1/?.lua'
export LUA_CPATH='/playnet/wwiiol/share/lua/cmod/?.so;/usr/local/lib/lua/5.1/loadall.so'
END_CLUSTER_RC
fi

