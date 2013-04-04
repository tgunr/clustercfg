#! /bin/bash
#
# TEMPLATE FOR ENVIRONMENT SETTINGS
# Usage: ". environment.sh" prior to running configure.

#################### HOST-SPECIFIC SETTINGS.

## Set to 1 if you want more detail during install.
export DEBUG=0

## Specify what the purpose of THIS box is.
#export ROLE=strat export IS_AUTH=1	 	# For a strat+dbd server that includes an auth host.
#export ROLE=strat						# For a strat+dbd server with separate auth
#export ROLE=chat						# For a chat server
#export ROLE=map						# For a map server
#export ROLE=cell						# For a cell host

## Final octet of the machine's IP address.
export HOST=151

#################### CLUSTER-WIDE COMMON SETTINGS.

## Cluster identify.
export CLUSTER=wwiiol
export ARENA_ID=1

## Networking configuration.
export NETWORK=66.28.224
export NETMASK=255.255.255.192
export NETWORK2=209.144.109
export NETMASK2=255.255.255.192
export GATEWAY=${NETWORK}.129
#export GATEWAY2=${NETWORK2}.129
export NAMESERVER=${NETWORK}.252
export APT_CACHE=${NETWORK}.242

## Game database access.
export ROOTDB_PASSWD=gravytrain
export GAMEDB_USER=wwiiol
export GAMEDB_PASSWD=freebird

## Auth-database access.
export AUTHDB_USER=authuser
export AUTHDB_PASSWD=scalar449
export AUTH_ADDRESS=${NETWORK}.151
export AUTH_DB=${NETWORK}.151

## Where to redirect authentication errors in the user's browser.
export AUTH_ERROR_URL=http://www.battlegroundeurope.com/scripts/wwiionline/error.jsp

