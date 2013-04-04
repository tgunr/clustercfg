/*
 * ** GAME DATABASE SPECIFIC: Requires wwiionline schema **
 * View that selects a simple list of all chat groups to which
 * a /player/ is currently subscribed for a given arena.
 * Expected rows:
 *  1 = customer_id
 *  2 = arenaid
 *  3 = group_oid
*/

USE `player` ;

CREATE OR REPLACE
	DEFINER = CURRENT_USER
	SQL SECURITY INVOKER
	VIEW `player`.`v_player_active_groups`
	AS

	SELECT	pl.id AS player_id, a.arenaid, cg.group_oid
	  FROM	`player`.`players` pl
			INNER JOIN `auth`.auth_subscribed s USING (customer_id)
			INNER JOIN `auth`.auth_subarenaassoc a USING (subscriptionid)
			INNER JOIN `auth`.auth_subgroupassoc g USING (subscriptionid)
			INNER JOIN `auth`.chat_groups cg ON (g.groupid = cg.group_oid)
	 WHERE	s.status = 1
			AND cg.enabled <> 'N'
;

