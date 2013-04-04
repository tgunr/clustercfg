#! /bin/bash
# Populate mysql.cnf for the whole cluster.

if test "x${NO_DB_INSTALL}" != "x1" ; then
 if [ ${DBServer} -eq 1 ] ; then
  report "Stopping any instances of MySQL that happen to be running"
  service mysql stop >/dev/null 2>&1
 fi

 if [ -f './etc/my.cnf' -a -d '/etc/mysql' ] ; then
  report "Copying my.cnf configuration"
  cp -f etc/my.cnf /etc/mysql/my.cnf
 fi

 if [ ${DBServer} -eq 1 ] ; then
  report "Starting MySQL"
  service mysql start
 fi
fi
