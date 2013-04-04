######################################################################
# "ldconfig" configuration (for libraries)

# Add the playnet librarys folder to ldconfig.
if [ ! -f /etc/ld.so.conf.d/playnet.conf ] ; then
 report "Adding /playnet/wwiiol/lib to library config"
 echo -e "# PlayNet product specific libraries.\n/playnet/wwiiol/lib" >/etc/ld.so.conf.d/playnet.conf
 ldconfig /playnet/wwiiol/lib || die "ldconfig failed"
fi
ldconfig 2>/dev/null /playnet/wwiiol/lib

