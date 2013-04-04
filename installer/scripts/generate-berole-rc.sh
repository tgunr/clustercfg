######################################################################
# Each host has a "berole.rc" file in ~/etc/ which describes the
# role/function of this server, allowing other scripts to detect
# what behavior to carry out here.

if [ ! -d "/home/wwiiol/etc" ] ; then
 report "Creating ~wwiiol/etc"
 ww2mkdir /home/wwiiol/etc
fi
roleFile="/home/wwiiol/etc/berole.rc"
if [ "x$(cat 2>/dev/null ${roleFile})" != "x${Role}" ] ; then
 report "Setting berole.rc to ${Role}"
 echo "${Role}" >/home/wwiiol/etc/berole.rc
 chown wwiiol.wwiiol /home/wwiiol/etc/berole.rc
fi

