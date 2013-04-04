/* Formatted on 2007/08/14 15:25 (QP5 v5.50) */

USE `player` ;

DROP PROCEDURE IF EXISTS `player`.`p_get_persona_data` ;

DELIMITER $$
CREATE PROCEDURE `player`.`p_get_persona_data`
(
	i_player_id BIGINT(20) UNSIGNED
)
	 READS SQL DATA
	 SQL SECURITY INVOKER
 BEGIN 
	DECLARE l_no_match TINYINT(1) UNSIGNED DEFAULT 0 ;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_no_match = 1 ;
	SELECT  p.id
		, p.rank_id AS rank
		, p.rank_points AS points
		, p.player_decal
		, s.id
		, s.short_name
		, m.seconds
		, mb.balance
	FROM  (`player`.`players` p
	LEFT OUTER JOIN `player`.`minor_usage` m ON (p.id = m.player_id AND expires > NOW())
	LEFT OUTER JOIN `auth`.`auth_minute_balance` mb ON (p.customer_id = mb.customer_id)
	)
	LEFT OUTER JOIN `squad`.`squads` s ON (p.squadID = s.id AND s.disbanded = 0)
	WHERE  p.id = i_player_id
	LIMIT	1
;
END $$

DELIMITER ;

