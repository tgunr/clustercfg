/*
   webauth.users
	Mon Oct 15 13:55:09 CDT 2007 osmith
	Pulls user auth data and checks for playnet/gm status
*/

USE `webauth` ;

DELIMITER $$

DROP FUNCTION IF EXISTS `webauth`.`f_is_user` $$

CREATE
	FUNCTION `webauth`.`f_is_user`
	( i_customer_id BIGINT(20) UNSIGNED )
	RETURNS TINYINT UNSIGNED
	READS SQL DATA
BEGIN
	DECLARE l_is_playnet TINYINT UNSIGNED DEFAULT 0 ;
	DECLARE l_groups INT UNSIGNED DEFAULT 0 ;
	DECLARE l_result TINYINT UNSIGNED DEFAULT 1 ;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_result = 0 ;

	SELECT	p.isplaynet, COUNT(cg.group_oid)
	  INTO	l_is_playnet, l_groups
	  FROM	`player`.`players` p
			LEFT JOIN `auth`.`chat_group_members` cgm
				ON (p.id = cgm.player_id)
			LEFT JOIN `auth`.`chat_groups` cg
				ON (cgm.group_oid = cg.group_oid AND cg.name IN ('gms', 'gmadmin', 'staff'))
	 WHERE	p.customer_id = i_customer_id
	 GROUP	BY p.id
	;

	IF l_result = 1 THEN
		IF l_is_playnet > 0 THEN
			SET l_result = 2 ;
		ELSEIF l_groups > 0 THEN
			SET l_result = 3 ;
		END IF ;
	END IF ;

	RETURN l_result ;
END $$

DELIMITER ;

