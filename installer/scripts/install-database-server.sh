######################################################################
# If we are to host our own database, install MySQL
# TODO: Check which version of MySQL is being installed, since we
# are specifying the version number in the debconf-set-selections...

if [ ${DBServer} -eq 1 ] ; then
  if [ "$(aptitude show mysql-server | grep State)" = "State: not installed" ] ; then
    report "Installing MySQL server"
    echo mysql-server-5.1 mysql-server/root_password password ${ROOTDB_PASSWD} | debconf-set-selections
    echo mysql-server-5.1 mysql-server/root_password_again password ${ROOTDB_PASSWD} | debconf-set-selections
    apt-get install -q -q -y mysql-server || die "Unable to install MySQL server"
  fi
fi

