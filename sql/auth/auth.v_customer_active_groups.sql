/*
 * $Id$
 * View that selects a simple list of all chat groups to which
 * a customer is currently subscribed for a given arena.
 * Expected rows:
 *  1 = customer_id
 *  2 = arenaid
 *  3 = group_oid
*/

USE `auth` ;

CREATE OR REPLACE
	DEFINER = CURRENT_USER
	SQL SECURITY INVOKER
	VIEW `auth`.`v_customer_active_groups`
	AS

	SELECT	ac.customer_id, a.arenaid, cg.group_oid
	  FROM	auth.auth_customer ac
			INNER JOIN auth.auth_subscribed s USING (customer_id)
			INNER JOIN auth.auth_subarenaassoc a USING (subscriptionid)
			INNER JOIN auth.auth_subgroupassoc g USING (subscriptionid)
			INNER JOIN auth.chat_groups cg ON (g.groupid = cg.group_oid)
	 WHERE	s.status = 1
			AND cg.enabled <> 'N'
;

