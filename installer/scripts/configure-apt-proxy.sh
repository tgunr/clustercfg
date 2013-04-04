######################################################################
# Configure the apt-proxy -- recommend apt-cacher-ng
# TODO: This does rather limit us to Ubuntu, duh.

_proxyFile=/etc/apt/apt.conf.d/02proxy
if [ ! -f "$_proxyFile" ] ; then
 if [ $isDev -ne 1 ] ; then
   APT_CACHE=${APT_CACHE:-66.28.224.242}
 else
   APT_CACHE=${APT_CACHE:-192.168.0.8}
 fi
 if [ -z "${APT_CACHE}" -o "${APT_CACHE/http:.*/HAS_URL}" != "HAS_URL" ] ; then
  aptCache="http://${APT_CACHE}:3142/"
 else
  aptCache="${APT_CACHE}"
 fi
 report "Configuring APT proxy/cache as ${aptCache}"
 echo "Acquire::http::Proxy \"${aptCache}\";" >$_proxyFile || die "Unable to configure proxy cache (unable to write to ${_proxyFile}?) $?"
fi

if [ -f '/etc/apt/apt.conf' ] ; then
 perl -i -pe 's/^(?=Acquire::http::Proxy)/#/' /etc/apt/apt.conf
fi

######################################################################
# Make sure the OS is upto date.
# TODO: This does rather limit us to Ubuntu, duh.

report "Updating APT cache index"
apt-get update -y -q -q || die "Unable to perform apt-get update"
report "Fetching/applying APT updates"
apt-get upgrade -y -q -q || die "Unable to perform apt-get upgrade"
apt-get dist-upgrade -y -q -q

