/*
 * $Id: auth.p_persona_refresh.sql 5578 2012-01-31 21:47:53Z osmith $
 * ** GAME DATABASE SPECIFIC: Requires wwiionline schema **
 *
 * Retrieves a quick refresh on a particular persona
 *
 * Expected rows:
 *  1 = rank_id
 *  2 = rank_points
 *  3 = permissions (BIT_OR of player-specific permissions)
 *  4 = groups (comma separated list of group_oids)
 *  5 = minute balance
 */

USE `auth` ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `auth`.`p_persona_refresh` $$

CREATE PROCEDURE `auth`.`p_persona_refresh`
	(
		i_player_id BIGINT(20) UNSIGNED
	,	i_arena_id	INT(11)	UNSIGNED
	)

	LANGUAGE SQL
	READS SQL DATA
	SQL SECURITY INVOKER

BEGIN

	SELECT	1 AS `rank_id`
	     ,	0 AS `rank_points`
	     ,	0 AS `permissions`
	     ,	GROUP_CONCAT(DISTINCT(v.group_oid)) AS `groups`
	     ,	amb.balance AS `minute_balance`
	  FROM	`player`.`players` pl -- To get customer_id
			LEFT OUTER JOIN `auth`.`auth_minute_balance` amb
				USING (customer_id)
			LEFT OUTER JOIN auth.v_customer_active_groups v
				ON (pl.customer_id = v.customer_id AND v.arenaid = i_arena_id)
	 WHERE	pl.id = i_persona_id
	 LIMIT	1
	;

END $$


DELIMITER ;

