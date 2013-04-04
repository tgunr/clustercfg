set @@foreign_key_checks = 0 ;

/* ------------------------------------------------------------ */

USE `sys` ;
CREATE TABLE IF NOT EXISTS `sys`.`schema_info` (
  `version_no` int(11) unsigned NOT NULL DEFAULT '0',
  `implemented` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Track current database schema revision to allow automatic up' ;

/* ------------------------------------------------------------ */

USE `game` ;
DROP TABLE IF EXISTS `game`.`vehicle_types`;
CREATE TABLE `game`.`vehicle_types` (
  `id` INT(11) unsigned NOT NULL AUTO_INCREMENT,
  `countryID` tinyint(3) unsigned NOT NULL,
  `categoryID` tinyint(3) unsigned NOT NULL,
  `classID` tinyint(3) unsigned NOT NULL,
  `typeID` tinyint(3) unsigned NOT NULL,
  `fullName` varchar(64) NOT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `added` datetime DEFAULT NULL,
  `cvc_value` int(11) NOT NULL DEFAULT '0',
  `blitz_name` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `countryID` (`countryID`,`categoryID`,`classID`,`typeID`),
  KEY `idx_vt_grep` (`id`,`countryID`,`categoryID`,`classID`)
) ENGINE=InnoDB;

/* ------------------------------------------------------------ */

USE `game` ;
DROP TABLE IF EXISTS `host_config`;
CREATE TABLE `host_config` (
  `variableNo` int(11) NOT NULL AUTO_INCREMENT,
  `variableName` varchar(32) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `value` text NOT NULL,
  `lastModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `description` text CHARACTER SET utf8 NOT NULL,
  `changed_by` varchar(10) NOT NULL DEFAULT 'nobody',
  UNIQUE KEY `variableNo` (`variableNo`),
  UNIQUE KEY `variableName` (`variableName`)
) ENGINE=MyISAM ;

/* ------------------------------------------------------------ */

USE `game` ;
DROP TABLE IF EXISTS `game`.`serial_numbers` ;
CREATE TABLE IF NOT EXISTS `game`.`serial_numbers`
(
  `resource` CHAR(16) NOT NULL PRIMARY KEY
, `last_serial` BIGINT UNSIGNED NOT NULL DEFAULT 1000
) ENGINE=MyISAM COMMENT 'For tracking incremental serial numbers such as instance#, sortie#, etc' ;

/* ------------------------------------------------------------ */

USE `squad` ;
DROP TABLE IF EXISTS `squad`.`squads` ;
CREATE TABLE IF NOT EXISTS `squad`.`squads`
(
  `id` BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `short_name` CHAR(10) NOT NULL,
  `name` char(40) NOT NULL,
  `active` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
  `recruiting` TINYINT(1) UNSIGNED NOT NULL DEFAULT '1',
  `disbanded` TINYINT(1) unsigned NOT NULL DEFAULT '0',
  `voting` TINYINT(1) unsigned DEFAULT '1',
  `modified` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created` DATETIME DEFAULT NULL,
  `creatorid` BIGINT UNSIGNED NOT NULL,
  `flags` BIGINT UNSIGNED DEFAULT 0,
  `pri_language` SMALLINT(2) UNSIGNED NOT NULL DEFAULT '0',
  `sec_language` SMALLINT(2) UNSIGNED NOT NULL DEFAULT '0',
  `def_country` SMALLINT(2) UNSIGNED NOT NULL DEFAULT '0',
  `def_branch` SMALLINT(2) UNSIGNED NOT NULL DEFAULT '0',
  `rookie_days` SMALLINT(6) unsigned DEFAULT '7',
  `size_warning` DATETIME DEFAULT NULL,
  `squad_closed` DATETIME DEFAULT NULL,
  `last_joined` DATETIME DEFAULT NULL,
  `name_changed` BIGINT UNSIGNED DEFAULT NULL,
  `last_joiner` CHAR(10) DEFAULT NULL,
  `voice_info` CHAR(80) DEFAULT NULL,
  `slogan` CHAR(80) DEFAULT NULL,
  `squad_night` CHAR(8) CHARACTER SET latin1 NOT NULL DEFAULT '0,0,0',
  `description` text NOT NULL,
  `password` text NOT NULL,
  `homepage` text,
  `motd` text,
  UNIQUE KEY (short_name),
  KEY `idx_modified` (modified)
) ;

/* ------------------------------------------------------------ */

USE `audit` ;
DROP TABLE IF EXISTS `audit`.`squad_action_types` ;
CREATE TABLE `audit`.`squad_action_types`
(
  `id` TINYINT(4) NOT NULL AUTO_INCREMENT,
  `name` CHAR(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) COMMENT 'Enumeration of squad_action action_types' ;

/* ------------------------------------------------------------ */

USE `audit` ;
DROP TABLE IF EXISTS `audit`.`squad_actions` ;
CREATE TABLE `audit`.`squad_actions`
(
  `squadID` BIGINT UNSIGNED NOT NULL,
  `action` TINYINT(4) unsigned NOT NULL,
  `occured` DATETIME NOT NULL,
  `originator` CHAR(10) NOT NULL,
  `target` CHAR(10) NOT NULL,
  `newval` INT(4) unsigned DEFAULT NULL,
  `textmessage` text NOT NULL,
  `prev` TINYINT(4) NOT NULL DEFAULT '0',
  `coID` BIGINT UNSIGNED NOT NULL DEFAULT '0',
  `xoID` BIGINT UNSIGNED NOT NULL DEFAULT '0'
) ;

/* ------------------------------------------------------------ */

USE `chat` ;
DROP TABLE IF EXISTS `chat`.`commands`;
CREATE TABLE `chat`.`commands` (
  `cmd_oid` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `command` varchar(32) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `description` varchar(80) CHARACTER SET latin1 DEFAULT NULL,
  `availability` enum('C','E','P') CHARACTER SET latin1 DEFAULT 'P',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`cmd_oid`),
  UNIQUE KEY `cmd_oid` (`cmd_oid`),
  UNIQUE KEY `command` (`command`)
) ENGINE=InnoDB;

/* ------------------------------------------------------------ */

USE `audit` ;
DROP TABLE IF EXISTS `audit`.`chat_events`;
CREATE TABLE `audit`.`chat_events` (
  `id` BIGINT unsigned NOT NULL AUTO_INCREMENT,
  `event_stamp` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `category` varchar(4) NOT NULL DEFAULT '',
  `event` varchar(10) NOT NULL DEFAULT '',
  `callsign` char(10) NOT NULL,
  `parameter` text NOT NULL,
  `data` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `event_stamp` (`event_stamp`)
) ENGINE=MyISAM;

/* ------------------------------------------------------------ */

USE `chat` ;
DROP TABLE IF EXISTS `chat`.`friends`;
CREATE TABLE `chat`.`friends` (
  `player_id` BIGINT(20) NOT NULL,
  `target` char(10) NOT NULL,
  PRIMARY KEY (`player_id`,`target`)
) ENGINE=MyISAM;

/* ------------------------------------------------------------ */

USE `audit` ;
DROP TABLE IF EXISTS `audit`.`chat_groups`;
CREATE TABLE `audit`.`chat_groups` (
  `server` varchar(8) NOT NULL DEFAULT '',
  `player_id` BIGINT(20) NOT NULL DEFAULT '0',
  `eventtime` datetime DEFAULT NULL,
  `cmd` char(3) NOT NULL DEFAULT '',
  `user` varchar(10) NOT NULL DEFAULT '',
  `group_oid` int(11) NOT NULL DEFAULT '0',
  `cga_oid` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`cga_oid`),
  KEY `server` (`server`,`player_id`,`eventtime`),
  KEY `cmd` (`cmd`),
  KEY `group_oid` (`group_oid`)
) ENGINE=MyISAM COMMENT="Audit-trail of changes to chat_groups";

/* ------------------------------------------------------------ */

USE `chat` ;
DROP TABLE IF EXISTS `chat`.`group_cmds`;
CREATE TABLE `chat`.`group_cmds` (
  `group_oid` smallint(6) unsigned NOT NULL COMMENT 'auth.chat_groups group id',
  `cmd_oid` int(11) unsigned NOT NULL COMMENT 'chat.commands command id being granted',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB COMMENT='List of commands granted by specific chat groups';

/* ------------------------------------------------------------ */

USE `chat` ;
DROP TABLE IF EXISTS `chat`.`group_ranks`;
CREATE TABLE `chat`.`group_ranks` (
  `group_oid` smallint(6) unsigned NOT NULL COMMENT 'auth.chat_groups group id',
  `branchid` tinyint(3) unsigned NOT NULL COMMENT 'wwiionline.wwii_branch number',
  `max_rank` tinyint(3) unsigned NOT NULL COMMENT 'Highest rank in this branch granted thru this group',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`group_oid`,`branchid`),
  CONSTRAINT `fk_cgr_group_oid` FOREIGN KEY (`group_oid`) REFERENCES `auth`.`chat_groups` (`group_oid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Provides maximum-per-branch ranks to chat`.`groups';

/* ------------------------------------------------------------ */

USE `chat` ;
DROP TABLE IF EXISTS `chat`.`group_vehs`;
CREATE TABLE `chat`.`group_vehs` (
  `group_oid` smallint(6) unsigned NOT NULL COMMENT 'auth.chat_groups group id',
  `vcountry` tinyint(3) unsigned NOT NULL COMMENT 'See game.vehicle_types',
  `vcategory` tinyint(3) unsigned NOT NULL COMMENT 'See game.vehicle_types',
  `vclass` tinyint(3) unsigned NOT NULL COMMENT 'See game.vehicle_types',
  `vehtype_oid` int(11) unsigned NOT NULL COMMENT 'See game.vehicle_types',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`group_oid`,`vcountry`,`vcategory`,`vclass`,`vehtype_oid`),
  CONSTRAINT `fk_cgv_group_oid` FOREIGN KEY (`group_oid`) REFERENCES `auth`.`chat_groups` (`group_oid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Management-level table of vehicles granted by chat group: pr';

/* ------------------------------------------------------------ */

USE `chat` ;
DROP TABLE IF EXISTS `chat`.`group_vehs_cache`;
CREATE TABLE `chat`.`group_vehs_cache` (
  `group_oid` smallint(6) unsigned NOT NULL COMMENT 'auth.chat_groups group id',
  `vehtype_oid` int(11) unsigned NOT NULL COMMENT 'Exact ID of the vehicle being granted',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`group_oid`,`vehtype_oid`),
  KEY `fk_cgvc_vehtype_oid` (`vehtype_oid`),
  CONSTRAINT `fk_cgvc_group_oid` FOREIGN KEY (`group_oid`) REFERENCES `auth`.`chat_groups` (`group_oid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cgvc_vehtype_oid` FOREIGN KEY (`vehtype_oid`) REFERENCES `game`.`vehicle_types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Table of explicit vehicle IDs granted by chat group. Users m';

/* ------------------------------------------------------------ */

USE `chat` ;
DROP TABLE IF EXISTS `chat`.`ignore`;
CREATE TABLE `chat`.`ignore` (
  `player_id` BIGINT(20) NOT NULL DEFAULT '0',
  `target` char(10) NOT NULL,
  PRIMARY KEY (`player_id`,`target`)
) ENGINE=MyISAM;

/* ------------------------------------------------------------ */

USE `chat` ;
DROP TABLE IF EXISTS `chat`.`tunes`;
CREATE TABLE `chat`.`tunes` (
  `player_id` BIGINT(20) unsigned NOT NULL DEFAULT '0',
  `slotid` int(2) unsigned NOT NULL DEFAULT '0',
  `type` int(2) unsigned NOT NULL DEFAULT '0',
  `subid` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`player_id`,`slotid`)
) ENGINE=MyISAM;

/* ------------------------------------------------------------ */

USE `sys` ;
DROP TABLE IF EXISTS `sys`.`host_status` ;
CREATE TABLE `sys`.`host_status` (
  `name` varchar(16) NOT NULL,
  `ping` datetime DEFAULT NULL,
  PRIMARY KEY (`name`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM;

/* ------------------------------------------------------------ */

USE `player` ;
DROP TABLE IF EXISTS `player`.`note_types`;
CREATE TABLE `player`.`note_types` (
  `id` int(3) unsigned NOT NULL AUTO_INCREMENT,
  `description` char(40) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM;

/* ------------------------------------------------------------ */

USE `player` ;
DROP TABLE IF EXISTS `player`.`notes`;
CREATE TABLE `player`.`notes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `player_id` BIGINT(20) unsigned NOT NULL DEFAULT '0',
  `note_type_id` int(3) NOT NULL DEFAULT '0',
  `note_at` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `note_end` datetime DEFAULT NULL,
  `note_by` int(11) unsigned NOT NULL DEFAULT '0',
  `note` text,
  PRIMARY KEY (`id`),
  KEY `player_id` (`player_id`,`note_type_id`)
) ENGINE=MyISAM;

/* ------------------------------------------------------------ */

USE `game` ;
DROP TABLE IF EXISTS `game`.`branches`;
CREATE TABLE `game`.`branches` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `name` char(10) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `added` datetime DEFAULT NULL,
  `abbr` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

/* ------------------------------------------------------------ */

USE `game` ;
DROP TABLE IF EXISTS `game`.`countries`;
CREATE TABLE `game`.`countries` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `side` int(11) NOT NULL DEFAULT '0',
  `name` varchar(10) NOT NULL DEFAULT '',
  `fullName` varchar(64) NOT NULL DEFAULT '',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `added` datetime DEFAULT NULL,
  `is_active` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/* ------------------------------------------------------------ */

DROP TABLE IF EXISTS `player`.`players` ;
CREATE TABLE `player`.`players` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `customer_id` BIGINT UNSIGNED NOT NULL,
  `callsign` char(10) NOT NULL,
  `lockside` TINYINT(2) UNSIGNED DEFAULT '0',
  `squadid` BIGINT(11) UNSIGNED DEFAULT '0',
  `squad_rank` int(4) unsigned NOT NULL DEFAULT '0',
  `locktime` int(11) DEFAULT NULL,
  `isplaynet` TINYINT(1) DEFAULT NULL,
  `player_decal` SMALLINT UNSIGNED NOT NULL DEFAULT '0',
  `last_login` datetime DEFAULT NULL,
  `last_poll` int(11) unsigned NOT NULL DEFAULT '0',
  `squad_joined` datetime DEFAULT NULL,
  `last_online` datetime DEFAULT NULL,
  `total_time_played` int(11) unsigned DEFAULT NULL,
  `squad_time_played` int(11) unsigned DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `added` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `customer_id` (`customer_id`),
  UNIQUE KEY `callsign` (`callsign`),
  KEY `plyrsquad` (`squadid`,`squad_rank`,`squad_joined`),
  KEY `lockidx` (`lockside`,`locktime`)
) ENGINE=MyISAM AUTO_INCREMENT=1000 ;

/* ------------------------------------------------------------ */

USE `game` ;
DROP TABLE IF EXISTS `game`.`arena_config`;
CREATE TABLE `game`.`arena_config` (
  `name` varchar(25) NOT NULL DEFAULT '',
  `value` varchar(255) NOT NULL DEFAULT '',
  `added` datetime DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/* ------------------------------------------------------------ */

USE `wwiionline` ;
DROP TABLE IF EXISTS `wwiionline`.`wwii_bad_checks`;
CREATE TABLE `wwiionline`.`wwii_bad_checks` (
  `report_time` varchar(18) NOT NULL DEFAULT '',
  `player_id` BIGINT(20) unsigned NOT NULL DEFAULT '0',
  `checksum` varchar(21) NOT NULL DEFAULT '',
  `app` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`report_time`,`player_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Bad checksum log';

/* ------------------------------------------------------------ */

USE `sys` ;
DROP TABLE IF EXISTS `sys`.`client_checksums`;
CREATE TABLE `sys`.`client_checksums` (
  `checksum_oid` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `version` varchar(20) NOT NULL DEFAULT '',
  `checksum` varchar(24) NOT NULL DEFAULT '',
  `description` text CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`checksum_oid`),
  UNIQUE KEY `unq_check_ver` (`checksum`,`version`),
  UNIQUE KEY `checksum_oid` (`checksum_oid`),
  KEY `version` (`version`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='List of allowed game checksums';

/* ------------------------------------------------------------ */

USE `audit` ;
DROP TABLE IF EXISTS `audit`.`speed_hacks`;
CREATE TABLE `audit`.`speed_hacks` (
  `whruid` int(11) NOT NULL AUTO_INCREMENT,
  `customer_id` BIGINT(20) NOT NULL DEFAULT '0',
  `cycleno` int(11) NOT NULL DEFAULT '0',
  `hosttime` int(11) NOT NULL DEFAULT '0',
  `host_elapsed_ms` bigint(20) unsigned NOT NULL DEFAULT '0',
  `client_elapsed_ms` bigint(20) unsigned NOT NULL DEFAULT '0',
  `delta_avg` bigint(20) NOT NULL DEFAULT '0',
  `faults` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `packets_counted` bigint(20) unsigned NOT NULL DEFAULT '0',
  `drift` bigint(20) NOT NULL DEFAULT '0',
  `kicked` char(1) NOT NULL DEFAULT '',
  PRIMARY KEY (`whruid`),
  KEY `timeIndex` (`hosttime`),
  KEY `customerIndex` (`customer_id`)
) ENGINE=MyISAM;

/* ------------------------------------------------------------ */

USE `game` ;
DROP TABLE IF EXISTS `game`.`motds`;
CREATE TABLE `game`.`motds` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type` int(11) unsigned NOT NULL DEFAULT '0',
  `added` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `added_by` int(11) unsigned NOT NULL DEFAULT '0',
  `motd` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `access_idx` (`type`,`added`)
) ENGINE=MyISAM;

/* ------------------------------------------------------------ */

USE `player` ;
DROP TABLE IF EXISTS `player`.`personas`;
CREATE TABLE `player`.`personas` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `player_id` BIGINT(20) unsigned NOT NULL,
  `countryid` TINYINT(3) unsigned NOT NULL,
  `branchid` TINYINT(3) unsigned NOT NULL,
  `rankid` SMALLINT(5) unsigned NOT NULL DEFAULT '1',
  `rankpoints` int(11) DEFAULT '0',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `added` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `player_id` (`player_id`,`countryid`,`branchid`)
) ENGINE=MyISAM;

/* ------------------------------------------------------------ */

USE `game` ;
DROP TABLE IF EXISTS `game`.`polls`;
CREATE TABLE `game`.`polls` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `opened` datetime DEFAULT NULL,
  `closed` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

/* ------------------------------------------------------------ */

USE `game` ;
DROP TABLE IF EXISTS `game`.`poll_entries`;
CREATE TABLE `game`.`poll_entries` (
  `pollid` int(11) unsigned NOT NULL,
  `entryid` tinyint(3) unsigned NOT NULL,
  `entry` text NOT NULL,
  `votes` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`pollid`,`entryid`),
  CONSTRAINT `fk_pe_pollid` FOREIGN KEY (`pollid`) REFERENCES `game`.`polls` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

/* ------------------------------------------------------------ */

USE `game` ;
DROP TABLE IF EXISTS `game`.`ranks`;
CREATE TABLE `game`.`ranks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rank` varchar(4) DEFAULT NULL,
  `description` varchar(64) NOT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `added` datetime DEFAULT NULL,
  `nextrank` int(11) DEFAULT NULL,
  `pointsrequired` int(11) DEFAULT NULL,
  `type` smallint(4) NOT NULL DEFAULT '0',
  `start_points` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `rank` (`rank`),
  KEY `start_points` (`start_points`)
) ENGINE=InnoDB ;

/* ------------------------------------------------------------ */

USE `game` ;
DROP TABLE IF EXISTS `game`.`rank_permissions`;
CREATE TABLE `game`.`rank_permissions` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Row ID',
  `rankID` int(11) unsigned NOT NULL COMMENT 'Explicit rank this is granted to',
  `permissionID` int(11) unsigned NOT NULL COMMENT 'auth.wwii_permissions ID of permission',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `added` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rankperm` (`rankID`,`permissionID`),
  KEY `permission_idx` (`permissionID`),
  KEY `fk_wrp_permission` (`permissionID`),
  CONSTRAINT `fk_grp_permission` FOREIGN KEY (`permissionID`) REFERENCES `auth`.`wwii_permissions` (`permissionID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Permissions granted to players for having a secific rank. No';

/* ------------------------------------------------------------ */

USE `game` ;
DROP TABLE IF EXISTS `game`.`rank_types`;
CREATE TABLE `game`.`rank_types` (
  `id` int(6) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(40) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM COMMENT='Friendly mapping of rank types' ;

/* ------------------------------------------------------------ */

USE `squad` ;
DROP TABLE IF EXISTS `squad`.`reserved_names`;
CREATE TABLE `squad`.`reserved_names` (
  `short_name` char(10) NOT NULL,
  `added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`short_name`),
  UNIQUE KEY `short_name` (`short_name`)
) ENGINE=MyISAM;

/* ------------------------------------------------------------ */

USE `game` ;
DROP TABLE IF EXISTS `game`.`sorties`;
CREATE TABLE `game`.`sorties` (
  `id` bigint unsigned NOT NULL,
  `player_id` BIGINT(20) NOT NULL,
  `persona_id` bigint unsigned NOT NULL,
  `instance_id` bigint unsigned not null,
  `vcountry` tinyint(3) unsigned NOT NULL,
  `vcategory` tinyint(3) unsigned NOT NULL,
  `vclass` tinyint(3) unsigned NOT NULL,
  `vtype` tinyint(3) unsigned NOT NULL,
  `spawn_time` datetime DEFAULT NULL,
  `return_time` datetime DEFAULT NULL,
  `rtb` tinyint(3) unsigned DEFAULT '0',
  `mission_type` smallint(5) unsigned DEFAULT NULL,
  `mission_id` int(11) DEFAULT NULL,
  `kills` int(11) unsigned DEFAULT '0',
  `vehicles_hit` int(11) unsigned DEFAULT '0',
  `score` bigint unsigned DEFAULT '0',
  `cell_host_ip` tinyint(3) unsigned NOT NULL,
  `alt_f4ed` tinyint(1) unsigned DEFAULT '0',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `added` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sortie_spawn_idx` (`spawn_time`),
  KEY `sortie_added_idx` (`added`),
  KEY `weapon_spec` (`vcountry`,`vcategory`,`vclass`,`vtype`),
  KEY `sortie_return_idx` (`return_time`,`cell_host_ip`),
  KEY `sortie_player_idx` (`player_id`,`rtb`),
  KEY `inst_player_id` (`instance_id`, `player_id`, `id`),
  KEY `player_inst_id` (`player_id`, `instance_id`, `id`)
) ENGINE=MyISAM;

/* ------------------------------------------------------------ */

USE `game` ;
DROP TABLE IF EXISTS `game`.`kills`;
CREATE TABLE `game`.`kills` (
  `id` BIGINT(20) unsigned NOT NULL AUTO_INCREMENT,
  `kill_time` datetime DEFAULT NULL,
  `instance_id` BIGINT(20) unsigned NOT NULL,
  `victim_sortie_id` BIGINT(20) unsigned NOT NULL,
  `killer_sortie_id` BIGINT(20) unsigned NOT NULL,
  `dead_x` int(11) NOT NULL,
  `dead_y` int(11) NOT NULL,
  `dead_z` int(11) NOT NULL,
  `victim_country` tinyint(4) unsigned NOT NULL,
  `victim_category` tinyint(4) unsigned NOT NULL,
  `victim_class` tinyint(4) unsigned NOT NULL,
  `victim_type` tinyint(4) unsigned NOT NULL,
  `killer_country` tinyint(4) unsigned NOT NULL,
  `killer_category` tinyint(4) unsigned NOT NULL,
  `killer_class` tinyint(4) unsigned NOT NULL,
  `killer_type` tinyint(4) unsigned NOT NULL,
  `victim_player` BIGINT(20) unsigned DEFAULT NULL,
  `killer_player` BIGINT(20) unsigned DEFAULT NULL,
  `victim_vehtype_oid` int(11) unsigned DEFAULT NULL,
  `killer_vehtype_oid` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `victim_sortie_id` (`victim_sortie_id`),
  KEY `killer_sortie_id` (`killer_sortie_id`),
  KEY `victim_vehicle` (`victim_country`,`victim_category`,`victim_class`,`victim_type`),
  KEY `killer_vehicle` (`killer_country`,`killer_category`,`killer_class`,`killer_type`),
  KEY `victim_player` (`victim_player`,`kill_time`,`killer_player`,`victim_vehtype_oid`,`killer_vehtype_oid`),
  KEY `by_inst_id` (`instance_id`, `id`)
  KEY `by_inst_time` (`instance_id`, `kill_time`)
) ENGINE=MyISAM;

/* ------------------------------------------------------------ */

USE `game` ;
DROP TABLE IF EXISTS `game`.`vehicle_categories`;
CREATE TABLE `game`.`vehicle_categories` (
  `id` int(11) NOT NULL,
  `name` char(10) NOT NULL,
  `fullname` varchar(32) NOT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `added` datetime not null,
  `branch_id` tinyint(3) unsigned not null,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM COMMENT="Lists the vehicle categories listed in th_blitz";

/* ------------------------------------------------------------ */

USE `game` ;
DROP TABLE IF EXISTS `game`.`vehicle_classes`;
CREATE TABLE `game`.`vehicle_classes` (
  `categoryID` int(11) NOT NULL DEFAULT '0',
  `classID` int(11) NOT NULL DEFAULT '0',
  `fullName` char(16) NOT NULL DEFAULT '',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `added` datetime DEFAULT NULL,
  PRIMARY KEY (`categoryID`,`classID`)
) ENGINE=MyISAM COMMENT="Lists the classes within each vehicle category";

/* ------------------------------------------------------------ */

USE `player` ;
DROP TABLE IF EXISTS `player`.`minor_usage` ;
CREATE TABLE `player`.`minor_usage` (
  `player_id` BIGINT(20) unsigned NOT NULL PRIMARY KEY UNIQUE,
  `seconds` int(11) unsigned NOT NULL DEFAULT '0',
  `expires` datetime NOT NULL
) ENGINE=MyISAM ;

/* ------------------------------------------------------------ */

USE `audit` ;
DROP TABLE IF EXISTS `audit`.`player_counts` ;
CREATE TABLE `audit`.`player_counts` (
  `stamp` datetime NOT NULL PRIMARY KEY UNIQUE,
  `undecided` int(11) NOT NULL,
  `allied` int(11) NOT NULL,
  `axis` int(11) NOT NULL,
  `spawned_allied` int(11) NOT NULL,
  `spawned_axis` int(11) NOT NULL
) ENGINE=MyISAM ;

/* ------------------------------------------------------------ */

USE `player` ;
DROP TABLE IF EXISTS `player`.`training_progress` ;
CREATE TABLE `player`.`training_progress` (
  `player_id` BIGINT(20) unsigned NOT NULL,
  `group_name` char(10) NOT NULL,
  `progress` bigint(20) unsigned NOT NULL DEFAULT '0',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`player_id`,`group_name`)
) ENGINE=MyISAM ;

/* ------------------------------------------------------------ */

USE `audit` ;
DROP TABLE IF EXISTS `audit`.`instance_populations` ;
CREATE TABLE `audit`.`instance_populations` (
  `category_id` smallint(4) unsigned NOT NULL,
  `type_id` smallint(4) unsigned NOT NULL,
  `owner_id` bigint(20) unsigned NOT NULL,
  `unique_id` bigint(20) unsigned NOT NULL,
  `recorded` datetime NOT NULL,
  `side` tinyint(1) unsigned NOT NULL,
  `players` int(11) unsigned NOT NULL,
  PRIMARY KEY (`category_id`,`type_id`,`owner_id`,`unique_id`,`recorded`,`side`),
  KEY `recorded` (`recorded`,`side`,`type_id`)
) ENGINE=MyISAM ;

/* ------------------------------------------------------------ */

USE `audit` ;
DROP TABLE IF EXISTS `audit`.`score` ;
CREATE TABLE `audit`.`score` (
  `row_id` BIGINT(20) unsigned NOT NULL AUTO_INCREMENT,
  `persona_id` BIGINT(20) unsigned NOT NULL,
  `recorded` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `old_rank` int(11) unsigned NOT NULL,
  `new_rank` int(11) unsigned NOT NULL,
  `old_score` int(11) unsigned NOT NULL,
  `new_score` int(11) unsigned NOT NULL,
  PRIMARY KEY (`row_id`),
  KEY `asst` (`persona_id`,`old_rank`,`recorded`),
  KEY `recorded` (`recorded`)
) ENGINE=MyISAM ;

USE `audit` ;
DROP TABLE IF EXISTS `audit`.`rank` ;
CREATE TABLE `audit`.`rank` (
  `persona_id` BIGINT(20) unsigned NOT NULL,
  `recorded` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `old_rank` tinyint(3) unsigned NOT NULL,
  `new_rank` tinyint(3) unsigned NOT NULL,
  KEY `persona_id` (`persona_id`),
  KEY `recorded` (`recorded`)
) ENGINE=MyISAM  ;

USE `audit` ;
DROP TABLE IF EXISTS `audit`.`sto_history` ;
CREATE TABLE `audit`.`sto_history` (
  `uid` BIGINT(20) unsigned NOT NULL,
  `clock64` BIGINT(20) unsigned NOT NULL COMMENT 'milisecond time of event',
  `event` enum('Creation','Destruction') NOT NULL,
  `instance_id` BIGINT(20) unsigned NOT NULL,
  `type` int(11) unsigned NOT NULL,
  `subtype` int(11) unsigned NOT NULL,
  `player_id` int(11) unsigned NOT NULL,
  `mission_id` int(11) unsigned NOT NULL,
  `pos_x` decimal(12,4) NOT NULL COMMENT 'X co-ordinate',
  `pos_y` decimal(12,4) NOT NULL COMMENT 'Y co-ordinate',
  `pos_z` decimal(12,4) NOT NULL COMMENT 'Y co-ordinate',
  `att_x` float NOT NULL COMMENT 'Attitude X',
  `att_y` float NOT NULL COMMENT 'Attitude Y',
  `att_z` float NOT NULL COMMENT 'Attitude Z',
  `flags` int(11) unsigned NOT NULL,
  `lifespan` int(11) unsigned NOT NULL,
  KEY `uid` (`uid`,`event`),
  KEY `clock64` (`clock64`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Audit trail of STO creation/destruction'  ;

USE `audit` ;
DROP TABLE IF EXISTS `audit`.`chat_messages` ;
CREATE TABLE `audit`.`chat_messages` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `player_id` bigint(20) unsigned NOT NULL,
  `message` text,
  `logged` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `id_rev` (`id`),
  KEY `cm_pid` (`player_id`),
  FULLTEXT KEY `cm_message_fulltext_idx` (`message`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ;

USE `wwii` ;
DROP TABLE IF EXISTS `wwii`.`client_terminations`;
CREATE TABLE IF NOT EXISTS `wwii`.`client_terminations`
(
  `id` int(11) unsigned NOT NULL auto_increment,
  `sessionOTP` int(11) unsigned default '0',
  `eventID` int(11) unsigned default '0',
  `errorType` int(11) unsigned default '0',
  `player_id` bigint(20) unsigned default '0',
  `whereIP` char(16) default '',
  `clientVersion` char(16) NOT NULL default '0.0.0.0',
  `platform` int(11) unsigned default NULL,
  `rxTime` timestamp(14) NOT NULL,
  `hostTime` timestamp(14) NOT NULL,
  `clientTime` timestamp(14) NOT NULL,
  `archiveCorrupt` tinyint(3) unsigned default '0',
  `piExitLine` int(11) unsigned default '0',
  `piExitFile` char(64) default '',
  `piExitMessage` char(128) default '',
  `exceptionAddr` int(11) unsigned zerofill default '00000000000',
  `exceptionCode` int(11) unsigned zerofill default '00000000000',
  `invalidArchive` char(64) default '0',
  `invalidFileName` char(64) default '0',
  `invalidCRC` int(11) unsigned default '0',
  `invalidMD5` char(64) default '0',
  `stackinfo` char(255) default '',
  `exceptionText` char(255) default '',
  `clientRevision` int(11) unsigned NOT NULL,
  PRIMARY KEY  (`id`),
  KEY (`id`, `clientVersion`),
  KEY `big_cv_idx` (`clientVersion`,`errorType`,`archiveCorrupt`)
) ;

USE `player` ;
DROP TABLE IF EXISTS `player`.`personas`;
DROP VIEW IF EXISTS `player`.`personas`;
CREATE OR REPLACE VIEW `player`.`personas`
 AS
  SELECT pl.id AS id
	   , pl.id AS player_id
	   , c.id AS countryid
	   , b.id AS branchid
	   , 1 AS rankid
	   , 0 AS rankpoints
	   , pl.modified AS modified
	   , pl.added AS added
  FROM `player`.`players` pl
   , `game`.`countries` c
   , `game`.`branches` b
 WHERE c.is_active = 1 ;

INSERT IGNORE INTO `sys`.`schema_info` (`version_no`, `implemented`)
VALUES
	(0, CURRENT_TIMESTAMP)
,	(1, CURRENT_TIMESTAMP)
,	(2, CURRENT_TIMESTAMP)
,	(3, CURRENT_TIMESTAMP)
,	(4, CURRENT_TIMESTAMP)
;

USE `game` ;
DROP TABLE IF EXISTS `game`.`instances` ;
CREATE TABLE `game`.`instances`
(
	`id` BIGINT(20) UNSIGNED NOT NULL	UNIQUE PRIMARY KEY
,	`category` INT(11) UNSIGNED NOT NULL
,	`type` INT(11) UNSIGNED NOT NULL
,	`handle` VARCHAR(10) NOT NULL
,	`created` DATETIME NOT NULL
,	`creator` BIGINT(20) UNSIGNED NOT NULL COMMENT 'players.player.id'
,	`lua_state` BLOB
,	`closed` DATETIME

,	INDEX `cat_type_cre` (`category`, `type`, `created`)
) ;

/* ------------------------------------------------------------ */

set @@foreign_key_checks = 1 ;

