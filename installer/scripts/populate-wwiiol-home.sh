######################################################################
# Ensure custom login environment for the wwiiol user across all hosts.

rcFile="/home/wwiiol/.bashrc"
# Check to see if we've already done this.
if [ ! -f "${rcFile}" -o -z "$(grep cluster.rc ${rcFile})" ] ; then
 report "Putting playnet specifics in ${rcFile}"
 tmpRc=/tmp/new.bashrc
 cat >/tmp/new.bashrc <<END_BASHRC
# Load the necessary paths before we do any fancy stuff.
if [ -f /playnet/etc/cluster.rc ]; then
    . /playnet/etc/cluster.rc
fi

if [ -f /home/wwiiol/etc/berole.rc ]; then
    BE_ROLE="`cat /home/wwiiol/etc/berole.rc`"
fi

for dir in /playnet/bin /playnet/wwiiol/bin ~/bin
do
    [ -d \$dir -a -x \$dir ] && PATH=\$PATH:\$dir
done

export PATH

# --------------------------------------------------------------------

END_BASHRC
 if [ -f "${rcFile}" ] ; then
  cat /home/wwiiol/.bashrc >>${tmpRc}
 fi
 mv ${tmpRc} /home/wwiiol/.bashrc
fi
chown wwiiol.wwiiol /home/wwiiol/.bashrc

# Create various wwiiol folders we need.
if [ ! -d "/home/wwiiol/logs" ] ; then ww2mkdir "/home/wwiiol/logs" ; fi
if [ ! -d "/home/wwiiol/bin" ] ; then ww2mkdir "/home/wwiiol/bin" ; fi
if [ ! -d "/home/wwiiol/etc" ] ; then ww2mkdir "/home/wwiiol/etc" ; fi
if [ ! -d "/home/wwiiol/lib" ] ; then ww2mkdir "/home/wwiiol/lib" ; fi
if [ ! -d "/home/wwiiol/tmp" ] ; then ww2mkdir "/home/wwiiol/tmp" ; fi

for svc in "authHost" "mmhostd" "stratd" "dbd" "pinghostd" "chatd" "hostd"
do
  dir="/home/wwiiol/${svc}"
  if [ ! -d "${dir}" ] ; then
    ww2mkdir "${dir}"
    ln -s /playnet/wwiiol/bin/data "${dir}/data"
  fi
done

