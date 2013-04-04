/*
	Tue Feb 12 15:35:50 CST 2008 ogs
	Look up a GM users credentials
*/

USE `auth` ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `auth`.`p_authenticate_gm_user` $$

CREATE PROCEDURE `auth`.`p_authenticate_gm_user`
	(
		i_username	VARCHAR(16) CHARACTER SET latin1	/* Account name, not game name */
	,	i_password	TEXT CHARACTER SET latin1
	)

	LANGUAGE SQL
	READS SQL DATA
	SQL SECURITY INVOKER

BEGIN
	DECLARE l_not_found TINYINT(1) UNSIGNED DEFAULT 0 ;
	DECLARE l_customer_id BIGINT(20) UNSIGNED DEFAULT 0 ;
	DECLARE l_group_name TEXT ;
	DECLARE l_is_gm TINYINT(1) UNSIGNED DEFAULT 0 ;
	DECLARE l_is_gm_admin TINYINT(1) UNSIGNED DEFAULT 0 ;
	DECLARE l_is_staff TINYINT(1) UNSIGNED DEFAULT 0 ;

	-- Look for a single entry
	DECLARE curs CURSOR FOR
		SELECT	c.customer_id, cg.name
		  FROM
			(
				`auth`.`rapid_assault_players` pp
					INNER JOIN `auth`.`auth_customer` c USING (customer_id)
					INNER JOIN `auth`.`auth_subscribed` s USING (customer_id)
					INNER JOIN `auth`.`auth_subarenaassoc` a USING (subscriptionID)
			)
			  LEFT OUTER JOIN ( `auth`.`chat_group_members` cgm INNER JOIN `auth`.`chat_groups` cg USING (group_oid) ) ON (pp.player_id = cgm.player_id)
		 WHERE	c.username <> c.customer_id AND c.username = i_username AND c.password = MD5(i_password) AND a.arenaID = 1
		   AND	cg.name IN ('gms', 'gmadmin', 'staff')
		 GROUP BY 1, 2
		 LIMIT	3
	;

	-- How to tell if no record was found
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_not_found = 1 ;

	OPEN curs ;
	REPEAT
		FETCH curs INTO l_customer_id, l_group_name ;
		IF l_not_found = 0 THEN
			IF l_group_name = 'gms' THEN SET l_is_gm = 1  ;
			ELSEIF l_group_name = 'gmadmin' THEN SET l_is_gm_admin = 1 ;
			ELSEIF l_group_name = 'staff' THEN SET l_is_staff = 1 ;
			END IF ;
		END IF ;
	UNTIL l_not_found END REPEAT ;
	CLOSE curs ;

	IF l_customer_id > 0 THEN
		SELECT l_customer_id, l_is_gm, l_is_gm_admin, l_is_staff ;
	END IF ;
END $$

DELIMITER ;

