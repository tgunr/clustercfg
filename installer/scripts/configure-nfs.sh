######################################################################
# NFS Client/Server selection.

# The auth-host lives outside of clusters and does not participate
# in NFS with other cluster members.
if [ ${AuthHost} -eq 0 ] ; then

 if [ ${NFSServer} -eq 1 ] ; then
   # If this server is providing the NFS mount for a cluster, it will
   # need the NFS Kernel server packages
   if [ "$(aptitude show nfs-kernel-server | grep State)" = "State: not installed" ] ; then
    report "Installing nfs-kernel-server"
    apt-get install -q -q -y nfs-kernel-server || die "Unable to install NFS Kernel Server packages"
   fi

   if [ ! -f /etc/exports ] ; then touch /etc/exports ; fi

   # Configure /playnet mount for export across the 192.168.10/24 network.
   if [ -z "$(grep /playnet /etc/exports)" ] ; then
    report "Configuring /playnet NFS export"
    echo "/playnet 192.168.10.0/24(sec=sys,ro,async,no_subtree_check,all_squash,anonuid=1000,anongid=1000,fsid=0)" >>/etc/exports
   fi
 else
  # The remaining roles need to mount /playnet on startup.
  if [ -z "$(grep /playnet /etc/fstab)" ] ; then
   report "Configuring /playnet NFS mount"
   echo "192.168.10.1:/ /playnet nfs4 auto,async,ro,nolock,intr,soft 0 0" >>/etc/fstab
  fi
 fi

 # Enable NFS drivers/services.
 modprobe nfs >/dev/null 2>&1
 service lockd restart >/dev/null 2>&1
 service idmapd stop >/dev/null 2>&1
 service idmapd start >/dev/null

 if [ ${NFSServer} -eq 1 ] ; then
   # Enable nfs exports.
   service nfs-kernel-server restart >/dev/null
 else
   # Attempt to mount /playnet
   mount /playnet || die "Unable to mount /playnet, make sure NFS server is configured and running"
 fi
fi

