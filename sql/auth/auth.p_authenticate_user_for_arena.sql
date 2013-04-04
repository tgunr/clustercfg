/*
	Mon Feb  4 14:48:31 CST 2008 ogs
	Validate a user and return values indicating whether or not the
	user exists or has valid credentials.
*/

USE `auth` ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `auth`.`p_authenticate_user_for_arena` $$

CREATE PROCEDURE `auth`.`p_authenticate_user_for_arena`
	(
		i_username	VARCHAR(16) CHARACTER SET latin1	/* Account name, not game name */
	,	i_password	TEXT CHARACTER SET latin1
	,	i_arena_id	INT(11) UNSIGNED
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
		 ,	p.player_id as player_id, c.handle
		 ,	IF ( c.flags & 2, 1, 0 ) AS have_hw_info
	  FROM `auth`.`rapid_assault_players` p
			INNER JOIN `auth`.auth_customer c USING (customer_id)
			INNER JOIN `auth`.auth_subscribed s USING (customer_id)
			INNER JOIN `auth`.auth_subarenaassoc a USING (subscriptionID)
			 WHERE c.username = i_username
				 AND a.arenaID = i_arena_id
			 ORDER BY s.status DESC
			 LIMIT 1
	;

END $$

DELIMITER ;

