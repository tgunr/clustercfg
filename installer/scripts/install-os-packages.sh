######################################################################
# Common OS-level requirements.

report "Checking stock system components"
apt-get install -q -q -y nfs-common vim byobu subversion gdb || die "Unable to install basic packages"

