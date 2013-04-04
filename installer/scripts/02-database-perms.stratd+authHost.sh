#! /bin/bash

# On the mmhost, we need to ensure that we create permissions
# for the local network to access the game databases.

if [ ${DBServer} -eq 0 ] ; then exit 0 ; fi

if test "x${net}" = "x" ; then
 die "Requires \$net to be populated"
fi

. scripts/00-sql-common.inc

# configure_schemas(username, password, schemas...)
function configure_schemas () {
 local dbuser=$1 ; shift
 local dbpass=$1 ; shift

 report "Creating database user '${dbuser}'"

 Password="IDENTIFIED BY '${dbpass}'"

 addresses="'localhost' '127.0.0.1' '${net}.%' '192.168.10.%'"
 if test "x${net}" != "x192.168.0" ; then
  addresses+=" '192.168.0.%'"
 fi

 for addr in ${addresses}
 do
  User="'${dbuser}'@${addr} ${Password}"
  execRootSql "CREATE USER ${User}"
  execRootSql "GRANT USAGE ON *.* TO ${User}"
 done

 report "Creating ${dbuser} database schemas (databases)"
 for schemaName in $*
 do
   schema="\\\`${schemaName}\\\`"
   execRootSql "CREATE DATABASE IF NOT EXISTS ${schema} DEFAULT CHARACTER SET = '${DEFAULT_DBCHARSET}'"
   for addr in ${addresses}
   do
    To="TO '${dbuser}'@${addr} ${password}"
    execRootSql "GRANT ALL ON ${schema} ${To}"
    execRootSql "GRANT ALL on ${schema}.* ${To}"
   done
 done
}

if [ ${AuthDB} -eq 1 ] ; then
 configure_schemas "${AUTHDB_USER}" "${AUTHDB_PASSWD}" 'auth' 'webauth' 'happyoo' 'playnet'
fi
if [ ${Strat} -eq 1 ] ; then
 configure_schemas "${GAMEDB_USER}" "${GAMEDB_PASSWD}" 'audit' 'auth' 'chat' 'game' 'happyoo' 'player' 'playnet' 'squad' 'sys' 'webauth' 'wwii' 'wwiionline'
fi

execRootSql "GRANT EXECUTE ON webauth.* TO 'webauth'@'66.28.224.248' IDENTIFIED BY 'c+l4ltd3l'"

