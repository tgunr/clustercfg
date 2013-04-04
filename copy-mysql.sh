#! /bin/bash

OLD="/playnet/old"
if [ ! -d "${OLD}/var/lib/mysql" ] ; then
 echo "ERROR: ${OLD}/var/lib/mysql not found [did you mount ${OLDDIR}?"
 exit 1
fi

if [ $(id -u) -ne 0 ] ; then
 echo "ERROR: Must run as root"
 exit 2
fi

DATA=/var/lib/mysql ; SYNC=/var/run/mysqld ; COPY=/tmp/mysql-copy

rm -rf ${DATA}
rm -rf ${SYNC}

rm -rf ${COPY}/${DATA} ${COPY}/${SYNC}
mkdir -p ${COPY}/${DATA} ${COPY}/${SYNC}

cp -dR --preserve=timestamps,mode,links ${OLD}${DATA}/* ${COPY}/${DATA}
cp -dR --preserve=timestamps,mode,links ${OLD}${SYNC}/* ${COPY}/${SYNC}

chown mysql.mysql ${COPY}/${DATA} ${COPY}/${DATA}/* ${COPY}/${DATA}/*/* ${COPY}/${SYNC} ${COPY}/${SYNC}/*

mv ${COPY}/${DATA} ${DATA}
mv ${COPY}/${SYNC} ${SYNC}

rm -rf ${COPY}

myisamchk -n --force --o -e --correct-checksum */*.MYI

echo "Copied ${DATA} and ${SYNC} from /old"
echo "Next, you probably want to run:"
echo "  mysqld_safe --skip-grant-tables --skip-host-cache --skip-locking --skip-external-locking --skip-new --skip-slave-start"
echo "On older boxes, you might want to add:"
echo "  --myisam_repair_threads=1"
echo "Then run:"
echo "  mysql_upgrade --force -u root -pgravytrain"

# mysqld_safe --skip-grant-tables --skip-host-cache --skip-locking --skip-external-locking --skip-new --skip-slave-start
# mysqld_safe --skip-grant-tables --skip-host-cache --skip-locking --skip-external-locking --skip-new --skip-slave-start --myisam_repair_threads=1
# mysql_upgrade --force -u root -pgravytrain

