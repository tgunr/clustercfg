PlayNet / Cornered Rat Software : Server Builder for Rapid Assault

Copyright (C) PlayNet Inc. 2012 -- NOT FOR REDISTRIBUTION
DEVELOPMENT RELEASE
REQUIREMENTS

Rapid Assault clusters target 32-bit Ubuntu Linux 10.10 or 11.04. They are designed and optimized to run on multi-core Intel x86. A minimum of 4 cores is recommended.

Installation testing can be performed using Virtual Machines, but production performance will be extremely poor if virtualized.

In addition to Ubuntu Server, MySQL Server 5.1 or 5.5 is required. Additional game-management functions are provided through an IRC interface.

The system must be configured with a "wwiiol" user.

CLUSTER ARCHITECTURE

Rapid Assault clusters comprise several physical machines across which a number of functional roles are distributed.

There are roles for the following standard Unix processes:

MySQL Authentication Database Server,
MySQL Game Database Server,
NFS Server,
IRC Server,
Web/Management Server
and hosts for the following Rapid Assault processes:

Authentication Server,
Map Host,
Chat Host,
Cell Host
Minimal Rapid Assault DEVELOPMENT RELEASE cluster requires 3 machines:

MySQL Auth, MySQL Game, NFS, IRC, Web and Map,
Chat Host,
Cell Host
NOTE: Authentication Server not required for DEVELOPMENT RELEASE.

At this time, we anticipate capacity of 3000 players per cluster, constrained by the Map and Chat Hosts. We are looking for a cell host capacity of between 1000-1500 players.

A PRODUCTION RELEASE architecture is likely to be:

Auth + MySQL Auth, MySQL Game, IRC, Web,
Map Host + NFS,
Chat Host,
Cell Host,
Cell Host,
Cell Host
NOTE: Each Map, Chat and Cell process requires a DISCRETE machine.

Rapid Assault binaries, scripts, data, etc, will all be installed under /playnet on the NFS server, and this will be exported to the remaining systems.

NOTE: In all cases, Rapid Assault cluster machines need access to a private 192.168.1/24 network. Each cluster assumes the NFS server for that cluster will be reachable as 192.168.1.1.

SERVER ROLES

Map Host

After a player has been authenaticated, they arrive on the cluster via the Map/Mission Host (mmhost). This is the master server for the cluster, responsible for tracking which other servers are running, who is logged in, and what instances are available, etc.

[This is also currently the server which hosts Lua scripts that run the instance rules, but we may relocate this workload to the cell hosts to increase overall cluster capacity]

Chat Host

After a player has logged in to the mmhost successfully, their game client is instructed to open a secondary connection to this process. It is responsible for player-to-player communications, receiving and processing "/"commands, and for squad management.

Cell Host

Cell hosts handle positional and 3d-world information between players. Players are assigned to a cell host based on which instance they will be joining, all players in an instance will be sent to the same cell host. Each cell can host multiple instances. There is no special communication between the cells, so it is possible to increase capacity by adding extra cells, until the limits of the mmhost/chat are reached.

If a cell host crashes, all of the players currently in that instance will be despawned. Once the map host detects the failure of the cell, it will forward subsequent attempts to spawn to a new cell host.

INSTALLATION

In this folder you should find a script called "configure-server.sh".

NOTE: This script is currently still in development!

Typing: ./configure-server.sh --help will provide usage details. Rather than taking command line arguments, the script makes use of environment variables.

Usage:
    ROLE=map|chat|cell [options] ./configure-server.sh
Options:
    APT_CACHE=nn.nn.nn.nn        Configure APT to use proxy at given address
    ARENA_ID=nnn                 Specifies arena ID (map only)
    CLUSTER=clustername          Short name for the cluster (map only)
    DATABASE_STRUCTURE=filename  File containing database structure SQL
    DEBUG=1                      Enable extra script output
    DEFAULT_DBCHARSET=...        Default database characterset
    GAMEDB_USER=...              Override default username for main database user
    GAMEDB_PASSWD=...            Override default password for main database user
    GATEWAY=nn.nn.nn.nn          Gateway IP for primary network
    GATEWAY2=nn.nn.nn.nn         Gateway IP for secondary network
    HOST=nnn                     Host address for the machine (last octet)
    NAMESERVER=...               IP address of primary nameserver
    NETMASK=nn.nn.nn.nn          Netmask for primary network
    NETMASK2=nn.nn.nn.nn         Netmask for secondary network
    NETWORK=...                  Network address for primary interface
    NETWORK2=nn.nn.nn            Network address for [optional] secondary interface
    NO_WAITS=1                   Don't sleep after warnings
    ROOTDB_PASSWD=...            Specify the root password for the game database
We strongly recommend that you configure an apt-cache server on your network and make it accessible to your servers, this will greatly speed up installation.

The majority of parameters are required only for the MAP role.

The script is stateful, so it can be run repeatedly until the system is configured.

NOTE: DEVELOPMENT RELEASE: The script does not check for a partially populated database. If the script fails during database population, I recomend that you perform a:

service stop mysql ; apt-get purge -y mysql-server mysql-core ; rm -rf /var/lib/mysql
and then re-run the configure-server.sh script after resolving the problem.
NOTE: DEVELOPMENT RELEASE: At this time it is NOT recommended that you use 'GAMEDB_USER' or 'GAMEDB_PASSWD'.

Standard DEVELOPMENT RELEASE Cluster

Assuming you are building a DEVELOPMENT RELEASE (192.168.0 network based) cluster with a map, chat and cell host configured as .61, .62 and .63;

Assuming your default router is 192.168.0.222 and your nameserver is on 192.168.0.191;

Assuming you have extracted these files into /root/installer on each machine;

First install the map host ...

  $ sudo -i
  ... enter password ...
  # cd installer
  # ROLE=map APT_CACHE=192.168.0.5 ARENA_ID=250 CLUSTER=dev ROOTDB_PASSWD=IAmRoot \
  > NETWORK=192.168.0 HOST=61 NETMASK=255.255.255.0 \
  > GATEWAY=192.168.0.222 NAMESERVER=192.168.0.191 \
  > ./configure-server.sh
You may have to reboot the machine and re-run the script in order to complete installation. When the script finally completes with "SUCCESS", you can proceed to the chat host:

  $ sudo -i
  ... enter password ...
  # cd installer
  # ROLE=chat APT_CACHE=192.168.0.5 HOST=62 ARENA_ID=250 CLUSTER=dev ./configure-server.sh
  ...
"ARENA_ID" and "CLUSTER" are optional for chat and map.

Again, you may need to reboot several times. When the script is installed, it is recommended you reboot and ensure that /playnet mounts on restart. Then you can proceed to configuring cell hosts:

  $ sudo -i
  ... enter password ...
  # cd installer
  # ROLE=cell APT_CACHE=192.168.0.5 HOST=63 ./configure-server.sh
  ...
Again, reboots may be required. In all cases, "HOST=..." is optional if you wish to use the address currently assigned to the machine.

Game data (/playnet/data)

Data is currently shipped in a Tar BZip2 file, e.g. rapid-assault.data.tbz2. This extracted to /playnet on the NFS Server, e.g:

  $ tar xf rapid-assault.data.tbz2 -C /playnet
An initial install file is supplied as pkgs/rapid-assault.data.tbz2 which will be installed by the installer. A more recent file can be used by replacing this file or specifying it's path in the DATAPKG_FILE variable.

Server Binaries (/playnet/wwiiol/bin, /playnet/wwiiol/lib)

You will need to install the game server binaries and libraries. These are supplied as a .deb Debian Installer Package. E.g. for the file rapid-assault-5626.Debug-BETA-Linux.deb you would type the following command on the NFS Server only:

  $ sudo dpkg -i ./rapid-assault-5626.Debug-BETA-Linux.deb
An initial set of binaries are supplied with this package and will be installed during server configuration. Updates can be installed by performing a "dpkg -i" on the most recent '.deb'ian package available.

Operating the cluster

The file "/home/wwiiol/etc/berole.rc" on each cluster node indicates the role of that machine. Based on this, the script "/playnet/bin/starthost" will start the processes intended for that server, and "/playnet/bin/stophost" will stop any running instance.

Servers write their output to log files located in /tmp, and periodically roll these logs files so that the most recent file is /tmp/*.0.log. You can thus monitor the operation of a server with:

  $ tail -F /tmp/*.0.log
Each line starts with a letter indicating the log severity: 'D' = debug (disabled for PRODUCTION RELEASES unless you kill -USR2 the process), 'I' = information, 'N' = nominal (or not-actually-an-error), 'M' = minor warning, 'W' = warning, 'A' = abnormal, 'F' = fault (terminates application)

In most cases you will want to monitor primarily for '^[AW]' in your log files.

PRODUCTION SERVER notes

For a production environment, it is recommended that each machine have TWO physical NICs, one public-facing NIC (eth0) and one for a private LAN shared between server processes for NFS and other server-to-server data. This network should be gigabit ethernet at minimum.

Public access to the game is primarily via TCP on ports 27015-27020 although some portions of game traffic will use UDP ports in the same range, if available.

Management Web Interface

NOTE: Still in development.

All game server processes now present a simple, high-performance, private web interface on port 6080. This interface is designed for debugging and for provisioning internal management tools. It is strongly recommended that you prevent external access to this interface.

The static content for this interface is housed in /playnet/wwiiol/web/debug,
this path can be overridden by the 'TEUL_UWEB_PATH' environment variable.

