######################################################################
# Trim back various stock ubuntu packages that are either a waste of
# cpu or have proven to create problems with running the game.

report "Checking unwanted components"
apt-get remove --purge -q -q -y ppp pppoeconf pppconfig apparmor apparmor-utils apport apport-symptoms \
    laptop-detect powermgmt-base wpasupplicant wireless-tools

if [ ${CleanDB} -eq 1 ] ; then
  report "Deinstalling MySQL - Existing databases will be removed"
  apt-get remove --purge -q -q -y mysql-server mysql-server-core
  rm -rf /var/lib/mysql
fi

