SET @@foreign_key_checks = 0 ;

/* ------------------------------------------------------------ */

USE `auth` ;
CREATE TABLE IF NOT EXISTS `auth`.`schema_info` (
  `version_no` int(11) unsigned NOT NULL DEFAULT '0',
  `implemented` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Track current database schema revision to allow automatic up' ;

USE `auth` ;
DROP TABLE IF EXISTS `auth`.`chat_groups`;
CREATE TABLE `auth`.`chat_groups` (
  `group_oid` smallint(6) unsigned NOT NULL AUTO_INCREMENT COMMENT 'NOTE: Range 1-65535, host stores as 16-bit int',
  `name` char(20) CHARACTER SET ucs2 NOT NULL COMMENT 'Short/descriptive name',
  `description` char(80) CHARACTER SET ucs2 NOT NULL COMMENT 'Explanation of group/purpose',
  `auto_by_rank` enum('N','Y') CHARACTER SET latin1 NOT NULL DEFAULT 'N' COMMENT 'Deprecated: Set to Y to enable auto joining by rank',
  `auto_min_rank` tinyint(3) unsigned NOT NULL DEFAULT '99' COMMENT 'Deprecated: Min. rank for auto-joining',
  `auto_max_rank` tinyint(3) unsigned NOT NULL DEFAULT '99' COMMENT 'Deprecated: Max. rank for auto-joining',
  `auto_side` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'Deprecated: 0 or side requried for auto-join',
  `grants` bigint(20) unsigned NOT NULL COMMENT '64-bit bitfield of permissions granted by membership (see wwii_permissions)',
  `max_squad_rank` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Highest squad rank this group grants',
  `enabled` enum('N','Y') CHARACTER SET latin1 NOT NULL DEFAULT 'Y' COMMENT 'Set to N to indicate group is no-longer in use instead of deleting while servers are operational',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Track when entry was last changed',
  PRIMARY KEY (`group_oid`),
  UNIQUE KEY `name` (`name`),
  KEY `idx_cg_main` (`group_oid`,`enabled`,`grants`,`max_squad_rank`),
  KEY `idx_cg_modified` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Chat groups describe permission sets (permission masks, rank';

/* ------------------------------------------------------------ */

USE `auth` ;
DROP TABLE IF EXISTS `wwii_permissions`;
CREATE TABLE `wwii_permissions` (
  `permissionID` int(11) unsigned NOT NULL COMMENT 'Table index',
  `maskValue` bigint(20) unsigned NOT NULL COMMENT '64-bit binary bit value of this permission',
  `description` varchar(64) NOT NULL COMMENT 'Host name for this permission (English)',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `added` datetime NOT NULL COMMENT 'Initial add datetime',
  `internal` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '1 indicates this value is only for use internally within the host',
  `details` varchar(128) DEFAULT NULL COMMENT 'Extended description of this permission',
  PRIMARY KEY (`permissionID`),
  UNIQUE KEY `maskValue` (`maskValue`),
  UNIQUE KEY `description` (`description`),
  UNIQUE KEY `perm_mask_unq` (`maskValue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* ------------------------------------------------------------ */

USE `auth` ;
DROP TABLE IF EXISTS `app_host_versions`;
CREATE TABLE `app_host_versions` (
  `appID` int(11) unsigned NOT NULL DEFAULT '0',
  `hostVersion` varchar(20) DEFAULT '0',
  `platform` int(11) unsigned NOT NULL DEFAULT '0',
  `minClientVersion` varchar(20) DEFAULT '0',
  `maxClientVersion` varchar(20) DEFAULT '0',
  `app_index` int(11) NOT NULL AUTO_INCREMENT,
  UNIQUE KEY `app_index` (`app_index`),
  KEY `appID` (`appID`)
) ENGINE=MyISAM COMMENT='version informaton related to each host version and appid';

USE `auth` ;
DROP TABLE IF EXISTS `app_manifest`;
CREATE TABLE `app_manifest` (
  `old` varchar(20) DEFAULT '0',
  `new` varchar(20) DEFAULT '0',
  `appID` int(11) NOT NULL DEFAULT '0',
  `platform` int(10) unsigned DEFAULT NULL,
  `actionType` char(1) DEFAULT '0',
  `webURL` varchar(129) DEFAULT '0',
  `ftpPort` int(11) unsigned DEFAULT '0',
  `ftpProtocol` char(1) DEFAULT '0',
  `ftpURL` varchar(129) DEFAULT '0',
  `ftpDir` varchar(129) DEFAULT '0',
  `ftpFile` varchar(129) DEFAULT '0',
  `manifest_index` int(11) NOT NULL AUTO_INCREMENT,
  UNIQUE KEY `manifest_index` (`manifest_index`),
  UNIQUE KEY `app_man_unq_idx` (`appID`,`platform`,`old`,`new`),
  KEY `appID` (`appID`)
) ENGINE=MyISAM COMMENT='manifest entries for all applications served by auth';

USE `auth` ;
DROP TABLE IF EXISTS `app_platforms`;
CREATE TABLE `app_platforms` (
  `platformid` tinyint(3) unsigned NOT NULL PRIMARY KEY,
  `name` varchar(10) NOT NULL DEFAULT '',
  UNIQUE KEY `platform` (`platformid`,`name`)
) ENGINE=MyISAM COMMENT='Known Platforms';

USE `auth` ;
DROP TABLE IF EXISTS `auth_apps`;
CREATE TABLE `auth_apps` (
  `appid` int(11) NOT NULL DEFAULT '0',
  `gameid` int(11) NOT NULL DEFAULT '0',
  `description` varchar(255) NOT NULL DEFAULT '',
  `appleID` varchar(5) DEFAULT NULL,
  UNIQUE KEY `appid` (`appid`,`gameid`)
) ENGINE=MyISAM ;

USE `auth` ;
DROP TABLE IF EXISTS `auth_arenas`;
CREATE TABLE `auth_arenas` (
  `arenaid` int(11) NOT NULL DEFAULT '0',
  `gameid` int(11) NOT NULL DEFAULT '0',
  `groupid` int(11) NOT NULL DEFAULT '0',
  `clusterid` int(11) NOT NULL DEFAULT '0',
  `hostVersion` varchar(20) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `state` enum('online','offline','full','active','inactive') CHARACTER SET latin1 NOT NULL DEFAULT 'offline',
  `controlState` enum('online','offline') CHARACTER SET latin1 DEFAULT 'offline',
  `controlVisible` enum('hidden','visible') CHARACTER SET latin1 DEFAULT 'hidden',
  `method` enum('customerid','playerid') CHARACTER SET latin1 NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `lock_state` smallint(6) NOT NULL DEFAULT '-4',
  `players` mediumint(9) NOT NULL DEFAULT '0',
  `alias` varchar(16) DEFAULT NULL,
  `db` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`arenaid`)
) ENGINE=MyISAM;

USE `auth` ;
DROP TABLE IF EXISTS `auth_communities`;
CREATE TABLE `auth_communities` (
  `communityid` int(11) NOT NULL AUTO_INCREMENT,
  `community` varchar(128) NOT NULL DEFAULT '',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `added` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`communityid`)
) ENGINE=MyISAM ;

USE `auth` ;
DROP TABLE IF EXISTS `auth_community_subscriptions`;
CREATE TABLE `auth_community_subscriptions` (
  `communityid` int(11) NOT NULL DEFAULT '0',
  `subscriptionid` BIGINT(20) NOT NULL DEFAULT '0',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `added` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`communityid`,`subscriptionid`)
) ENGINE=MyISAM ;

USE `auth` ;
DROP TABLE IF EXISTS `auth_connections`;
CREATE TABLE `auth_connections` (
  `occurred` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `customer_id` BIGINT(20) unsigned NOT NULL,
  `arenaID` int(11) unsigned NOT NULL,
  `ip` int(11) unsigned NOT NULL DEFAULT '0',
  KEY `occurred` (`occurred`,`customer_id`),
  KEY `customer_id` (`customer_id`),
  KEY `ip` (`ip`)
) ENGINE=MyISAM;

USE `auth` ;
DROP TABLE IF EXISTS `auth_customer`;
CREATE TABLE `auth_customer` (
  `customer_id` BIGINT(20) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(16) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `password` varchar(128) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `handle` char(10) NOT NULL DEFAULT '',
  `status` enum('new','sync','normal') CHARACTER SET latin1 DEFAULT NULL,
  `flags` int(11) DEFAULT '0',
  `first` varchar(25) DEFAULT NULL,
  `last` varchar(25) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `username` (`username`),
  KEY `handle` (`handle`(8))
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

USE `auth` ;
DROP TABLE IF EXISTS `auth_customer_flags`;
CREATE TABLE `auth_customer_flags` (
  `flagid` int(11) NOT NULL AUTO_INCREMENT,
  `maskvalue` int(10) unsigned NOT NULL DEFAULT '0',
  `description` varchar(255) NOT NULL DEFAULT '',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `added` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`flagid`)
) ENGINE=MyISAM ;

USE `auth` ;
DROP TABLE IF EXISTS `auth_customer_roles`;
CREATE TABLE `auth_customer_roles` (
  `customer_id` BIGINT(20) NOT NULL DEFAULT '0',
  `communityid` int(11) NOT NULL DEFAULT '0',
  `roleid` int(11) NOT NULL DEFAULT '0',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `added` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`customer_id`,`communityid`,`roleid`)
) ENGINE=MyISAM ;

USE `auth` ;
DROP TABLE IF EXISTS `auth_gamedbs`;
CREATE TABLE `auth_gamedbs` (
  `dbaddress` varchar(255) NOT NULL DEFAULT '',
  `dbname` varchar(255) NOT NULL DEFAULT '',
  `dbuser` varchar(20) NOT NULL DEFAULT '',
  `dbpass` varchar(20) NOT NULL DEFAULT '',
  `dbport` int(11) NOT NULL DEFAULT '0',
  `dbtable` varchar(255) NOT NULL DEFAULT '',
  `gameid` int(11) NOT NULL DEFAULT '0',
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`dbaddress`)
) ENGINE=MyISAM ;

USE `auth` ;
DROP TABLE IF EXISTS `auth_games`;
CREATE TABLE `auth_games` (
  `gameid` int(11) NOT NULL DEFAULT '0',
  `description` varchar(255) NOT NULL DEFAULT '',
  `playertable` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`gameid`)
) ENGINE=MyISAM ;

USE `auth` ;
DROP TABLE IF EXISTS `auth_groups`;
CREATE TABLE `auth_groups` (
  `groupid` int(11) NOT NULL DEFAULT '0',
  `description` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`groupid`)
) ENGINE=MyISAM ;

USE `auth` ;
DROP TABLE IF EXISTS `auth_illegal_users`;
CREATE TABLE `auth_illegal_users` (
  `recorded` datetime DEFAULT NULL,
  `ip` int(11) unsigned DEFAULT NULL,
  `username` varchar(40) DEFAULT NULL,
  `reason` varchar(20) DEFAULT NULL,
  KEY `username` (`username`),
  KEY `reason` (`reason`),
  KEY `recorded` (`recorded`)
) ENGINE=MyISAM ;

USE `auth` ;
DROP TABLE IF EXISTS `auth_lock_states`;
CREATE TABLE `auth_lock_states` (
  `lock_state` smallint(6) NOT NULL,
  `state_name` varchar(32) NOT NULL,
  PRIMARY KEY (`lock_state`),
  UNIQUE KEY `lock_state` (`lock_state`)
) ENGINE=MyISAM ;

USE `auth` ;
DROP TABLE IF EXISTS `auth`.`auth_minute_balance`;
CREATE TABLE `auth`.`auth_minute_balance` (
  `customer_id` BIGINT(20) unsigned NOT NULL COMMENT 'References auth.auth_customer.customer_id',
  `balance` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Playable minutes remaining',
  `modified` datetime DEFAULT NULL COMMENT '[Manual] time of last update',
  `deposited` datetime DEFAULT NULL COMMENT '[Manual] time of last deposit',
  PRIMARY KEY (`customer_id`)
) ENGINE=MyISAM  COMMENT='This is a dummy version of the minute balance table since Pl';

USE `auth` ;
DROP TABLE IF EXISTS `auth_otp`;
CREATE TABLE `auth_otp` (
  `username` varchar(20) NOT NULL DEFAULT '',
  `otp` varchar(20) NOT NULL DEFAULT '',
  `homedir` varchar(20) NOT NULL DEFAULT '/home/ftpchroot/DENY'
) ENGINE=MyISAM ;

USE `auth` ;
DROP TABLE IF EXISTS `auth_population_grades`;
CREATE TABLE `auth_population_grades` (
  `min_players` mediumint(8) unsigned NOT NULL,
  `grade_name` varchar(32) NOT NULL,
  PRIMARY KEY (`min_players`),
  UNIQUE KEY `min_players` (`min_players`)
) ENGINE=MyISAM ;

USE `auth` ;
DROP TABLE IF EXISTS `auth_roles`;
CREATE TABLE `auth_roles` (
  `roleid` int(11) NOT NULL AUTO_INCREMENT,
  `role` varchar(25) NOT NULL DEFAULT '',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `added` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`roleid`),
  UNIQUE KEY `role` (`role`)
) ENGINE=MyISAM ;

USE `auth` ;
DROP TABLE IF EXISTS `auth_status`;
CREATE TABLE `auth_status` (
  `arena_id` int(11) unsigned NOT NULL DEFAULT '0',
  `visibility` int(11) unsigned NOT NULL DEFAULT '0',
  `status` int(11) unsigned NOT NULL DEFAULT '2',
  `axis` int(11) unsigned NOT NULL DEFAULT '0',
  `allied` int(11) unsigned NOT NULL DEFAULT '0',
  `motd` text NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `type` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`arena_id`)
) ENGINE=MyISAM ;

USE `auth` ;
DROP TABLE IF EXISTS `auth_subarenaassoc`;
CREATE TABLE `auth_subarenaassoc` (
  `subscriptionID` BIGINT(20) NOT NULL DEFAULT '0',
  `arenaID` int(11) NOT NULL DEFAULT '0',
  UNIQUE KEY `arenaID` (`arenaID`,`subscriptionID`),
  KEY `idx_asaa_sub_arena` (`subscriptionID`,`arenaID`)
) ENGINE=MyISAM ;

USE `auth` ;
DROP TABLE IF EXISTS `auth_subgroupassoc`;
CREATE TABLE `auth_subgroupassoc` (
  `subscriptionID` BIGINT(20) unsigned NOT NULL COMMENT 'Subscription associated being related (see auth_subscription)',
  `groupID` int(11) unsigned NOT NULL COMMENT 'group_oid of chat_group being related',
  PRIMARY KEY (`subscriptionID`,`groupID`),
  KEY `idx_asga_inverse` (`groupID`,`subscriptionID`)
) ENGINE=MyISAM  COMMENT='Relates subscriptions and chat_groups';

USE `auth` ;
DROP TABLE IF EXISTS `auth_subscribed`;
CREATE TABLE `auth_subscribed` (
  `customer_id` BIGINT(20) NOT NULL DEFAULT '0',
  `subscriptionID` BIGINT(20) NOT NULL DEFAULT '0',
  `status` enum('active','inactive') CHARACTER SET latin1 DEFAULT NULL,
  UNIQUE KEY `customer_id` (`customer_id`,`subscriptionID`),
  KEY `idx_as_substatcust` (`subscriptionID`,`status`,`customer_id`),
  KEY `idx_as_subcust` (`subscriptionID`,`customer_id`)
) ENGINE=MyISAM ;

USE `auth` ;
DROP TABLE IF EXISTS `auth_subscription`;
CREATE TABLE `auth_subscription` (
  `subscriptionID` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `subcode` char(4) NOT NULL DEFAULT '' COMMENT 'Human readable identifier',
  `description` char(255) NOT NULL DEFAULT '' COMMENT 'Internal description of subscription',
  `type` enum('permissions','access') CHARACTER SET latin1 DEFAULT 'permissions',
  PRIMARY KEY (`subscriptionID`),
  UNIQUE KEY `subcode` (`subcode`)
) ENGINE=MyISAM COMMENT='Declares the group of subscription sets';

USE `auth` ;
DROP TABLE IF EXISTS `auth_variables`;
CREATE TABLE `auth_variables` (
  `name` varchar(30) NOT NULL DEFAULT '',
  `value` text,
  PRIMARY KEY (`name`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM ;

USE `auth` ;
DROP TABLE IF EXISTS `info_ogl`;
CREATE TABLE `info_ogl` (
  `card_name` varchar(40) NOT NULL DEFAULT '',
  `vendor` varchar(10) NOT NULL DEFAULT '',
  `ogl_version` int(11) NOT NULL DEFAULT '0',
  `num_comp_textures` int(11) NOT NULL DEFAULT '0',
  `comp_texture_descs` text,
  `num_extensions` int(11) NOT NULL DEFAULT '0',
  `extensions_bitmap` text,
  `format_number` smallint(6) NOT NULL DEFAULT '0',
  `n_size` smallint(6) NOT NULL DEFAULT '0',
  `n_version` smallint(6) NOT NULL DEFAULT '0',
  `dwflags` smallint(6) NOT NULL DEFAULT '0',
  `i_pixel_type` smallint(6) NOT NULL DEFAULT '0',
  `c_color_bits` smallint(6) NOT NULL DEFAULT '0',
  `c_red_bits` smallint(6) NOT NULL DEFAULT '0',
  `c_green_bits` smallint(6) NOT NULL DEFAULT '0',
  `c_blue_bits` smallint(6) NOT NULL DEFAULT '0',
  `c_alpha_bits` smallint(6) NOT NULL DEFAULT '0',
  `c_accum_bits` smallint(6) NOT NULL DEFAULT '0',
  `c_accum_red_bits` smallint(6) NOT NULL DEFAULT '0',
  `c_accum_green_bits` smallint(6) NOT NULL DEFAULT '0',
  `c_accum_blue_bits` smallint(6) NOT NULL DEFAULT '0',
  `c_accum_alpha_bits` smallint(6) NOT NULL DEFAULT '0',
  `c_depth_bits` smallint(6) NOT NULL DEFAULT '0',
  `c_stencil_bits` smallint(6) NOT NULL DEFAULT '0',
  `cpu_vendor` varchar(40) DEFAULT NULL,
  `cpu_family` int(11) DEFAULT '0',
  `cpu_model` int(11) DEFAULT '0',
  `cpu_stepping` int(11) DEFAULT '0',
  `cpu_feature` int(11) DEFAULT '0',
  `cpu_os_support` int(11) DEFAULT '0',
  `cpu_checks` int(11) DEFAULT '0',
  `cpu_speed` int(11) unsigned DEFAULT '0',
  `mem_phys` int(11) unsigned DEFAULT '0',
  `mem_page` int(11) unsigned DEFAULT '0',
  `mem_virtual` int(11) unsigned DEFAULT '0',
  `sound_name` varchar(40) DEFAULT NULL,
  `sound_manuf_id` int(11) unsigned DEFAULT '0',
  `sound_prod_id` int(11) unsigned DEFAULT '0'
) ENGINE=MyISAM ;

USE `auth` ;
DROP TABLE IF EXISTS `wwiiol_players`;
CREATE TABLE `wwiiol_players` (
  `player_id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `customer_id` BIGINT(20) NOT NULL DEFAULT '0',
  `added` datetime DEFAULT NULL,
  PRIMARY KEY (`player_id`),
  UNIQUE KEY `customer_id` (`customer_id`)
) ENGINE=MyISAM ;

USE `auth` ;
DROP TABLE IF EXISTS `rapid_assault_players`;
CREATE TABLE `rapid_assault_players` (
  `player_id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `customer_id` BIGINT(20) NOT NULL DEFAULT '0',
  `added` datetime DEFAULT NULL,
  PRIMARY KEY (`player_id`),
  UNIQUE KEY `customer_id` (`customer_id`)
) ENGINE=MyISAM ;

/* ------------------------------------------------------------ */

USE `auth` ;
DROP TABLE IF EXISTS `auth`.`auth_checksums` ;
CREATE TABLE `auth`.`auth_checksums` (
  `check_oid` int(11) NOT NULL AUTO_INCREMENT,
  `appID` int(11) NOT NULL DEFAULT '0',
  `platform` int(11) NOT NULL DEFAULT '0',
  `checksum` varchar(64) DEFAULT NULL,
  `filename` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`check_oid`),
  UNIQUE KEY `appID` (`appID`,`platform`)
) ENGINE=MyISAM ;

/* ------------------------------------------------------------ */

USE `playnet` ;

DROP TABLE IF EXISTS `playnet`.`auth_customer_subscriptions`;
CREATE TABLE `playnet`.`auth_customer_subscriptions` (
  `user_id` int(10) unsigned NOT NULL DEFAULT '0',
  `product_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `terms_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `terms_renew` smallint(5) unsigned NOT NULL DEFAULT '0',
  `terms_cycled` smallint(5) unsigned NOT NULL DEFAULT '0',
  `terms_start` date DEFAULT NULL,
  `terms_end` date DEFAULT NULL,
  `status` enum('pending','active','grace','inactive') NOT NULL DEFAULT 'pending',
  `locked` enum('false','true') NOT NULL DEFAULT 'false',
  `use_credit` enum('true','false') NOT NULL DEFAULT 'true',
  `cycled` float NOT NULL DEFAULT '0',
  `join_date` date DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `last_date` date DEFAULT NULL,
  `next_date` date DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`product_id`),
  KEY `daily_idx` (`status`,`next_date`),
  KEY `stats_idx` (`product_id`,`status`),
  KEY `mod_idx` (`modified`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `playnet`.`auth_customers`;
CREATE TABLE `playnet`.`auth_customers` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(16) CHARACTER SET latin1 NOT NULL,
  `password` varchar(128) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `account_id` int(10) unsigned NOT NULL DEFAULT '0',
  `added` datetime DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  KEY `mod_idx` (`modified`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `playnet`.`billing_products`;
CREATE TABLE `playnet`.`billing_products` (
  `product_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `community_id` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `department_id` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `category_id` smallint(5) unsigned NOT NULL DEFAULT '1',
  `content_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL DEFAULT '',
  `allow_credit` enum('true','false') DEFAULT 'true',
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `visible` enum('true','false') NOT NULL DEFAULT 'true',
  `entry` varchar(255) DEFAULT NULL,
  `handler` varchar(255) DEFAULT NULL,
  `type` enum('real','virtual') NOT NULL DEFAULT 'virtual',
  `limited` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `restricted` enum('true','false') NOT NULL DEFAULT 'false',
  `ext_pid` varchar(255) DEFAULT NULL,
  `shipping` smallint(6) DEFAULT '0',
  `shippingx` smallint(6) DEFAULT '0',
  `added` datetime DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `playnet`.`ra_players`;
CREATE TABLE `playnet`.`ra_players` (
  `player_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `callsign` varchar(10) NOT NULL DEFAULT '',
  `squad_id` int(11) DEFAULT '0',
  `isplaynet` tinyint(4) DEFAULT NULL,
  `decal` tinyint(4) unsigned DEFAULT '0',
  `added` datetime DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`player_id`),
  UNIQUE KEY `customerid` (`user_id`),
  UNIQUE KEY `callsign` (`callsign`),
  KEY `playerid` (`player_id`),
  KEY `players_modified_idx` (`modified`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='master players list';

DROP TABLE IF EXISTS `playnet`.`wwii_players`;
CREATE TABLE `playnet`.`wwii_players` (
  `player_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `callsign` varchar(10) NOT NULL DEFAULT '',
  `squad_id` int(11) DEFAULT '0',
  `isplaynet` tinyint(4) DEFAULT NULL,
  `decal` tinyint(4) unsigned DEFAULT '0',
  `added` datetime DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`player_id`),
  UNIQUE KEY `customerid` (`user_id`),
  UNIQUE KEY `callsign` (`callsign`),
  KEY `playerid` (`player_id`),
  KEY `players_modified_idx` (`modified`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='master players list';

/* ------------------------------------------------------------ */

SET @@foreign_key_checks = 1 ;
