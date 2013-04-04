######################################################################
# Configure limits.conf to allow large numbers of file descriptors.

_limitFile="/etc/security/limits.conf"
if [ -z "$(grep wwiiol.*nofile ${_limitFile})" ] ; then
 report "Adjusting ulimits [${_limitFile}]"
 echo -e >>$_limitFile "\n# game needs higher ulimits\nwwiiol hard nofile 10240\nwwiiol soft nofile 4096"
fi

