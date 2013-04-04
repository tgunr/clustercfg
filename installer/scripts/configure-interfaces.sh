# Construct ${interfacesFile} configuration.

interfacesFile="/etc/network/interfaces"
tmpFile="/tmp/network.interfaces"
interfaces=""
NeedNet=0

configureNetwork () {
 interface=${1/i*f*=/} ; shift
 address=${1/addr*=/} ; shift
 netmask=${1/*mask=/} ; shift
 gateway=${1/g*w*=/} ; shift
 txqueuelen=${1/txq*=/} ; shift
 nameserver=${1/ns=/} ; shift

 interfaces+=" ${interface}"
 
 # Does the interface appear in the interface file?
 cmd="grep 2>/dev/null \"iface ${interface} inet static\" ${interfacesFile}"
 isConfigured=$(eval $cmd)
 if [ -z "${isConfigured}" ] ; then
  debugOut "Need to configure ${interface} ${address} ${netmask} ${gateway}"
  NeedNet=1
 fi

 cat >>$tmpFile <<END_SCR
auto ${interface}
iface ${interface} inet static
  address ${address}
  netmask ${netmask}
END_SCR
 if [ -z "$(grep 2>/dev/null ${address} ${interfacesFile})" ] ; then
  NeedNet=1
 fi
 if [ ! -z "${gateway}" ] ; then cat >>$tmpFile <<END_SCR
  gateway ${gateway}
END_SCR
  if [ -z "$(grep 2>/dev/null ${gateway} ${interfacesFile})" ] ; then
   NeedNet=1
  fi
 fi
 if [ ! -z "${nameserver}" ] ; then cat >>$tmpFile <<END_SCR
  dns-nameservers ${nameserver}
  dns-domain ${DNS_DOMAIN:-crs.local}
  dns-search ${DNS_DOMAIN:-crs.local playnet.com}
END_SCR
  if [ -z "$(grep 2>/dev/null ${nameserver} ${interfacesFile})" ] ; then
   NeedNet=1
  fi
 fi
 txqIsConfigured="$(grep 2>/dev/null "^  up ifconfig ${interface} txqueuelen" ${interfacesFile})"
 if [ ! -z "${interface/*:*/}" -a ! -z "${txqueuelen}" ] ; then cat >>$tmpFile <<END_SCR
  up ifconfig ${interface} txqueuelen ${txqueuelen}     # Thanks to Dest Bai :)
END_SCR
  if [ -z "${txqIsConfigured}" ] ; then
   NeedNet=1
  fi
 elif [ ! -z "${txqIsConfigured}" ] ; then
  NeedNet=1	# Needs to remove the txq line.
 fi
}

cat >$tmpFile <<END_SCR
# configure-server.sh generated interfaces file.

auto lo
iface lo inet loopback

END_SCR

configureNetwork "interface=eth0" "address=${net}.${addr}" "netmask=${NETMASK:-255.255.255.0}" "gw=${GATEWAY:-${net}.1}" "txq=12000" "ns=${NAMESERVER}"
if [ ! -z "${NETWORK2}" ] ; then
 debugOut "Configuring secondary network ($NETWORK2)"
 configureNetwork "interface="eth0:0 "addr=${NETWORK2}.${addr}" "mask=${NETMASK2:-255.255.255.0}" "gw=${GATEWAY2}"
fi

if [ ${AuthHost} -eq 0 ] ; then
 if [ $isDev -eq 0 ] ; then
  debugOut "Using production (dual nic) configuration"
  peerIf="eth1" ; nfsIf="eth1:0"		# Production clusters use two IFs
 else
  debugOut "Using dev (single nic) configuration"
  peerIf="eth0:1" ; nfsIf="eth0:2"	# Production only has one
 fi

 configureNetwork "if=${peerIf}" "addr=192.168.10.${addr}" "mask=255.255.255.0" "gw=" "txq=8000"
 if [ ${NFSServer} -eq 1 ] ; then
  debugOut "Adding ${nfsIf} for NFS services on 192.168.10.1"
  configureNetwork "if=${nfsIf}" "addr=192.168.10.1" "mask=255.255.255.0" "gw=" "txq=4000"
 fi
else
 debugOut "AuthHost only makes use of one nic."
fi

if [ ${NeedNet} -eq 1 ] ; then
 report "Installing replacement network configuration"
 cp ${tmpFile} ${interfacesFile} || die "Unable to overwrite $interfacesFile"
 warn "Network configuration changed - please reboot. Running /etc/init.d/networking restart isn't enough."
 exit 0
else
 debugOut "Keeping existing network configuration"
fi

rm ${tmpFile}

