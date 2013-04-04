######################################################################
# All hosts need a /playnet directory, either for NFS mounting or
# to contain the local playnet data.

if [ ! -d "/playnet" ] ; then
  report "Creating /playnet"
  mkdir /playnet
fi
chown wwiiol.wwiiol /playnet

# Create the bootstrap directories on Map and Auth hosts.
if [ ${IsLocalMaster} -eq 1 ] ; then
    report "Populating /playnet"

    ### This is the stuff we only do on the master server,
    ### which will be hosting the database and the NFS mounts.
    ### It will therefore house all the cluster-wide config
    ### and so on.

    # Bootstrap directories.
    ww2mkdir /playnet/bin
    ww2mkdir /playnet/etc
    ww2mkdir /playnet/wwiiol/bin/data
    ww2mkdir /playnet/wwiiol/lib
    ww2mkdir /playnet/wwiiol/share
    if [ ! -L /playnet/data -a ! -e /playnet/data ] ; then ln -s /playnet/wwiiol/bin/data /playnet/data ; fi

    if [ $dev ] ; then
     irc="192.168.0.81"
    else
     irc="shivers.playnet.com"
    fi

    # Copy scripts
    if [ -d "bin" ] ; then
     for file in bin/*
     do
      cp -a "${file}" "/playnet/bin"
     done
    fi

    if [ -d "lib" ] ; then
     ww2mkdir /playnet/lib
     for file in lib/*
     do
      cp -a "${file}" "/playnet/lib"
     done
     ldconfig /playnet/lib
    fi
fi

