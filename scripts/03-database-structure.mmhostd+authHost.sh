#! /bin/bash

# Tear up the game database structure.

if [ ${DBServer} -eq 1 ] ; then
 if test "x${net}" = "x" ; then
  die "FAIL: Requires \$net to be populated"
 fi

 . scripts/00-sql-common.inc

 suites=""
 if [ ${AuthDB} -eq 1 ] ; then suites+="auth " ; fi
 if [ ${Map} -eq 1 ] ; then suites+="game " ; fi

 report "Creating database structure (tables): ${suites}"

 for suite in ${suites}
 do
  filename="sql/${suite}-database-structure.sql"
  if [ -r "${filename}" ] ; then
   debugOut "Installing ${suite} structures"
   setSqlCmd "-u root -p${ROOTDB_PASSWD} ${suite} <${filename}"
   debugOut "${displayCmd}"
   eval $cmd || die "Script failed: ${displayCmd}."
  fi
 done
fi

