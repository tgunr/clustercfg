#! /bin/bash

# Populate the game database with data.

if [ ${DBServer} -eq 1 ] ; then
 if test "x${net}" = "x" ; then
  die "Requires \$net to be populated"
 fi
 
 . scripts/00-sql-common.inc

 suites=""
 if [ ${AuthDB} -eq 1 ] ; then suites+="auth " ; fi
 if [ ${Map} -eq 1 ] ; then suites+="game " ; fi

 report "Populating database with default data: ${suites}"

 for suite in ${suites}
 do
  filename="sql/${suite}-database-data.sql"
  if [ -r "${filename}" ] ; then
   debugOut "Installing ${suite} data"
   setSqlCmd "-u root -p${ROOTDB_PASSWD} ${suite} <${filename}"
   debugOut "${displayCmd}"
   eval $cmd || die "Script failed: ${displayCmd}."
  fi
 done

 # Process any auth data entries.
 for suite in ${suites}
 do
  if test -d "sql/${suite}" ; then
   report "Populating ${suite} database with snapshot data and procedures/views"
   for file in sql/${suite}/*.sql
   do
    setSqlCmd "-u root -p${ROOTDB_PASSWD} ${suite} <${file}"
    debugOut "${displayCmd}"
    eval $cmd || die "${suite} script failed: ${displayCmd}."
   done
  fi

  # Now process site-specific data.
  for target in playnet happyoo
  do
   dir="sql/${suite}/${target}"
   if test -d "${dir}" -a ! -z "$(ls 2>/dev/null ${dir}/*.sql)" ; then
    report "Installing ${target} specific database data."
    for file in ${dir}/*.sql
    do
     setSqlCmd "-u root -p${ROOTDB_PASSWD} game <${file}"
     debugOut "${displayCmd}"
     eval $cmd || die "${target} script failed: ${displayCmd}."
    done
   fi
  done
 done
fi

