/*
	Mon Feb  4 14:48:31 CST 2008 ogs
	Validate a user and return values indicating whether or not the
	user exists or has valid credentials.
*/

USE `auth` ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `auth`.`p_get_user_subscriptions` $$

CREATE PROCEDURE `auth`.`p_get_user_subscriptions`
	(
		i_username	VARCHAR(16) CHARACTER SET latin1 /* Account name, not game name */
	,	i_password	TEXT CHARACTER SET latin1
	)

	LANGUAGE SQL
	READS SQL DATA
	SQL SECURITY INVOKER

BEGIN

	DECLARE l_not_found TINYINT(1) UNSIGNED DEFAULT 0 ;

	-- How to tell if no record was found
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_not_found = 1 ;

	-- Look for a single entry
	SELECT	IF ( c.password = i_password, 1, 0 ) AS password_match
		 ,	s.status AS is_active
		 ,	p.player_id AS id
		 ,	1 AS have_hw_info -- IF ( c.flags & 2, 1, 0 ) AS have_hw_info
		 ,	ps.status AS is_playnet
		 ,	(
				SELECT	GROUP_CONCAT(DISTINCT(a.arenaID))
				  FROM	auth_subscribed s
						INNER JOIN auth_subarenaassoc a USING (subscriptionID)
						INNER JOIN auth_arenas aa USING (arenaID)
				 WHERE	s.customer_id = c.customer_id
						AND s.status = 1
				 GROUP	BY s.customer_id
				 ORDER	BY a.arenaID
			) AS subs
	  FROM `auth`.`rapid_assault_players` p
			INNER JOIN `auth`.auth_customer c USING (customer_id)
			INNER JOIN `auth`.auth_subscribed s USING (customer_id)
			LEFT OUTER JOIN `auth`.auth_subscribed ps
				ON (ps.customer_id = p.customer_id AND ps.subscriptionid = 9)
			 WHERE c.username = i_username
			 ORDER BY s.status DESC
			 LIMIT 1
	;

END $$

DELIMITER ;

