/*
	Sun Sep  2 20:51:51 CDT 2007 ogs
	Add a note to a player's record
*/

USE `player` ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `player`.`p_add_player_note` $$

CREATE PROCEDURE `player`.`p_add_player_note`
   (
    i_callsign VARCHAR(10)
   , i_issuedBy BIGINT(20) unsigned
   , i_note_type_id INT(11) unsigned
   , i_note text
   )

  LANGUAGE SQL
  MODIFIES SQL DATA
  SQL SECURITY INVOKER

BEGIN
	DECLARE l_player_id INT(20) unsigned DEFAULT 0 ;
	DECLARE	l_isPlaynet TINYINT(1) unsigned DEFAULT 0 ;

	DECLARE l_last_row_fetched INT(11) UNSIGNED DEFAULT 0 ;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_last_row_fetched = 1 ;

	SELECT	p.id, p.isPlaynet
	  INTO	l_player_id, l_isPlaynet
	  FROM	`player`.`players` p
	 WHERE	p.callsign = LOWER(i_callsign)
	;

	IF l_last_row_fetched THEN

		SELECT 0 AS err, "No such player" AS txt ;
/*
	ELSEIF l_isPlaynet > 0 THEN

		SELECT 0 AS err, "Cannot place notes on CRS accounts" AS txt ;
*/
	ELSE

		INSERT	INTO `player`.`notes`
				(player_id, note_type_id, note_at, note_end, note_by, note)
		VALUES	(l_player_id, i_note_type_id, NOW(), NULL, i_issuedBy, i_note)
		;

		COMMIT ;

		SELECT l_player_id AS player ;

	END IF ;

END $$

DELIMITER ;
