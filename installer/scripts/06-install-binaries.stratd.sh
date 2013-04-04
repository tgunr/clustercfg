#! /bin/bash

# Check for an install binary .deb package.

Pkg=""
for file in pkgs/*-Linux.deb
do
 if [ -f ${file} ] ; then
  Pkg=${file}
 fi
done

if [ ! -z "${Pkg}" ] ; then
 debugOut "Checking if ${PRODUCT} is installed [$Pkg]"
 installed=`dpkg -s ${PRODUCT} 2>&1 | grep -e 'not.installed'`
 if [ ! -z "${installed}" ] ; then
  report "Installing binary package {$Pkg}"
  cmd="dpkg -i ${Pkg}"
  debugOut "Running: $cmd"
  eval "$cmd"
  ldconfig /playnet/wwiiol/lib
 fi
fi

