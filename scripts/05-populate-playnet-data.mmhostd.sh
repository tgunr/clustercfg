#! /bin/bash

# Check for and install the ${PRODUCT}-data.tar.bz2 file

if [ ! -L /playnet/data ] ; then
 debugOut "Creating /playnet/data -> /playnet/wwiiol/bin/data symlink"
 ln -s /playnet/wwiiol/bin/data /playnet/data
fi

if [ ! -d /playnet/wwiiol/bin/data ] ; then
 debgOut "Creating /playnet/wwiiol/bin/data directory"
 ww2mkdir /playnet/wwiiol/bin/data
fi

# Check that all of these files exist.
Missing=""
for file in blitzWor.csv host.loc ppo.xml th_blitz/weapon/weapClasses.csv th_blitz/weapon/weapCountry.csv
do
 path="/playnet/wwiiol/bin/data/${file}"
 if [ ! -f "${path}" ] ; then Missing+="${file} " ; fi
done

DATAPKG_FILE=${DATAPKG_FILE:-./pkgs/${PRODUCT}-data.tar.bz2}

if [ ! -z "${Missing}" ] ; then
 debugOut "Missing /playnet/data files: ${Missing}"
 if [ ! -r "${DATAPKG_FILE}" ] ; then
  die "Unable to access ${DATAPKG_FILE} and /playnet/data is not populated."
 fi

 report "Installing ${PRODUCT} data from ${DATAPKG_FILE} => /playnet/data"

 tarArgs="xf"
 if [ "x${DEBUG}" = "x1" ] ; then tarArgs="xvf" ; fi
 cmd="tar $tarArgs ${DATAPKG_FILE} -C /playnet/wwiiol/bin/"
 debugOut "Running: $cmd"
 eval $cmd || die "Populating /playnet/data failed."
fi

