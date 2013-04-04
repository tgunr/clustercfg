/*
 * $Id: auth.p_get_player_details.sql 5578 2012-01-31 21:47:53Z osmith $
 * ** GAME DATABASE SPECIFIC: Requires wwiionline schema **
 *
 * Procedure that selects the *player* details required for
 * the map and chat hosts to load a player.
 *
 * Expected rows:
 *  1 = player_id
 *  2 = permissions (64 bit mask of server-specific permissions)
 *  3 = callsign 
 *  4 = customer_id
 *  5 = squadid (or 0)
 *  6 = squad_rank (or 0 or NULL)
 *  7 = squad_short_name (or NULL)
 *  8 = player_decal (or 0 or NULL)
 *  9 = lock_unixtime (sidelock as unix timestamp or 0 or NULL)
 * 10 = lock_side (side player is locked to or 0 = no lock, 1 = allied, 2 = axis, 3 = banned)
 * 11 = last_poll (last answered opinion poll or 0 or NULL)
 * 12 = last_login (date time or NULL)
 * 13 = groups (comma separated list of *distinct* chat_group OIDs)
 * 14 = lock_datetime (lock_unixtime in human readable format)
 * 15 = minute balance for metered access
 */

USE `player` ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `player`.`p_get_player_details` $$

CREATE PROCEDURE `player`.`p_get_player_details`
	(
		i_player_id BIGINT(20) UNSIGNED
	,	i_arena_id	INT(11)	UNSIGNED
	)
	LANGUAGE SQL
	READS SQL DATA
	SQL SECURITY INVOKER
BEGIN
	SELECT	pl.id AS `player_id`
	     ,	0 AS `permissions`
	     ,	pl.callsign AS `callsign`
	     ,	pl.customer_id AS `customer_id`
	     ,	pl.squadid AS `squadid`
	     ,	pl.squad_rank AS `squad_rank`
	     ,	s.short_name AS `squad_short_name`
	     ,	pl.player_decal AS `player_decal`
	     ,	pl.locktime AS `lock_unixtime`
	     ,	pl.lockside AS `lock_side`
	     ,	pl.last_poll AS `last_poll`
	     ,	pl.last_login AS `last_login`
	     ,	GROUP_CONCAT(DISTINCT v.group_oid ORDER BY v.group_oid) AS `groups`
	     ,	FROM_UNIXTIME(pl.locktime) AS `lock_datetime`
		 ,	amb.balance AS `minutes`
	  FROM	`player`.`players` pl
			LEFT OUTER JOIN `auth`.`auth_minute_balance` amb
				USING (customer_id)
			LEFT OUTER JOIN `auth`.`v_customer_active_groups` v
				ON (pl.customer_id = v.customer_id AND v.arenaid = i_arena_id)
			LEFT OUTER JOIN `squad`.`squads` s
				ON (pl.squadid = s.id)
	 WHERE	pl.id = i_player_id
	 GROUP	BY pl.id
	;
END
 $$

DELIMITER ;

