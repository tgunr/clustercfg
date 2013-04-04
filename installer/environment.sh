#! /bin/bash
#
# TEMPLATE FOR ENVIRONMENT SETTINGS
#
# Usage: ". environment.sh" prior to running configure.
#

# For a strat+dbd server that includes an auth host.
#export ROLE=strat ; export IS_AUTH=1
# For a strat+dbd server with separate auth
#export ROLE=strat
# For a chat server
#export ROLE=chat
# For a map server
#export ROLE=map
# For a cell host
#export ROLE=cell

export NETWORK=66.28.224
export NETMASK=255.255.255.192
export NETWORK2=209.144.109
export NETMASK2=255.255.255.192
export HOST=151
export GATEWAY=${NETWORK}.129
#export GATEWAY2=${NETWORK2}.129
export NAMESERVER=${NETWORK}.252
export APT_CACHE=${NETWORK}.242

export CLUSTER=auth
export ARENA_ID=222
export DEBUG=1

export ROOTDB_PASSWD=gravytrain

export GAMEDB_USER=wwiiol
export GAMEDB_PASSWD=freebird

# Only actually required by Auth.
export AUTH_ERROR_URL=http://www.battlegroundeurope.com/scripts/wwiionline/error.jsp
export AUTHDB_USER=authuser
export AUTHDB_PASSWD=scalar449
export AUTH_ADDRESS=${NETWORK}.151
export AUTH_DB=${NETWORK}.151

