######################################################################
# Common runtime packages required by the game: Additional future
# packages will be detected by the package system, but it seems a
# good idea to check upfront that pre-requisites are available.

report "Checking additional components"
apt-get install -q -q -y lua5.1 liblua5.1-0 liblua5.1-json mysql-client libopenthreads-dev || die "Unable to install critical packages"

