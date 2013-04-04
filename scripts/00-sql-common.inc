#! /bin/bash
# Common functions/variables for SQL scripts

DEFAULT_DBCHARSET="${DEFAULT_DBCHARSET:-ucs2}"
GAMEDB_USER="${GAMEDB_USER:-wwiiol}"
GAMEDB_PASSWD="${GAMEDB_PASSWD:-freebird}"
RootDbPasswd="${ROOTDB_PASSWD}"
MySQLOpts="--no-auto-rehash --quick"

debugOut "dc = ${DEFAULT_DBCHARSET}"
debugOut "gu = ${GAMEDB_USER}"
debugOut "gp = ${GAMEDB_PASSWD}"


######################################################################
# Validate username.

case "x${GAMEDB_USER}" in
	xroot) die "Ho ho, very funny. Game user can't be 'root'" ;;
	x*[\-\@\'\"\%\*\;]*) die "Invalid game-user username: $GAMEDB_USER" ;;
    x) die "Empty game-user username specified." ;;
    *) ;;
esac


######################################################################
# Validate password.

case "x${GAMEDB_PASSWD}" in
	x*[\@\'\"\%\*\;]*) die "Invalid game-passwd: ${GAMEDB_PASSWD}" ;;
	x) die "Empty game-user password specified." ;;
    *) ;;
esac


######################################################################
# Validate character set.

case "x${DEFAULT_DBCHARSET}" in
	x*[\@\'\"\%\*\;]*) die "Invalid default database charset specified: $DEFAULT_DBCHARSET" ;;
	x) die "Empty default database charset specified." ;;
    *) ;;
esac

######################################################################
# Report a mysql command without revealing passwords.

function setSqlCmd() {
 cmd="mysql ${MySQLOpts} $*"
 displayCmd="${cmd/$RootDbPasswd/<hidden>}"
 displayCmd="${displayCmd/$GAMEDB_PASSWD/<hidden>}"
}

######################################################################
# Execute a piece of SQL as the 'root' user.

function execRootSql() {
 setSqlCmd "-u root -p${RootDbPasswd} mysql -e \"$*\""
 debugOut "$displayCmd"
 eval "$cmd" || die "SQL statement failed: ${displayCmd}"
}

######################################################################
# Execute a piece of SQL as the game user.

function execGameSql() {
 setSqlCmd "-u ${GAMEDB_USER} -p${GAMEDB_PASSWD} game -e \"$*\""
 debugOut "$displayCmd"
 eval "$cmd" || die "SQL statement failed: ${displayCmd}"
}

