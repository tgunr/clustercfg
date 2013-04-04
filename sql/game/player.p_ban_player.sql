/*
	Sun Sep  2 16:27:59 CDT 2007 ogs
	Issue a ban with a note against a player
*/

USE `player` ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `player`.`p_ban_player` $$

CREATE PROCEDURE `player`.`p_ban_player`
   (
    i_callsign VARCHAR(10)
   , i_banFor INT(11) unsigned
   , i_issuedBy BIGINT(20) unsigned
   , i_reason text
   )

  LANGUAGE SQL
  MODIFIES SQL DATA
  SQL SECURITY INVOKER

BEGIN
	DECLARE l_player_id BIGINT(20) unsigned DEFAULT 0 ;
	DECLARE	l_isPlaynet TINYINT(1) unsigned DEFAULT 0 ;

	DECLARE l_note_type_id INT(11) UNSIGNED DEFAULT 0 ;
	DECLARE l_bans INT(11) UNSIGNED DEFAULT 0 ;
	DECLARE l_last_row_fetched INT(11) UNSIGNED DEFAULT 0 ;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_last_row_fetched = 1 ;

	START TRANSACTION ;

	SELECT	p.id, p.isPlaynet, (SELECT COUNT(*) FROM `player`.`notes` n WHERE n.player_id = p.id AND n.note_type_id = 2)
	  INTO	l_player_id, l_isPlaynet, l_bans
	  FROM	`player`.`players` p
	 WHERE	p.callsign = LOWER(i_callsign)
	   FOR	UPDATE
	;

	IF l_last_row_fetched THEN

		ROLLBACK ;
		SELECT 0, "No such player" ;

	ELSEIF l_isPlaynet > 0 THEN

		ROLLBACK ;
		SELECT 0, "Cannot issue bans on CRS accounts" ;

	ELSE

		IF i_banFor > 0 THEN 
			UPDATE	`player`.`players`
	   		SET	lockside = 3
		 		,	locktime = UNIX_TIMESTAMP() + i_banFor
	 		WHERE	id = l_player_id
			;

			SET l_bans = l_bans + 1 ;

			INSERT	INTO `player`.`notes`
					(player_id, note_type_id, note_at, note_end, note_by, note)
			VALUES	(l_player_id, 2, NOW(), FROM_UNIXTIME(UNIX_TIMESTAMP() + i_banFor), i_issuedBy, i_reason)
			;

			COMMIT ;
		ELSE
			ROLLBACK ;
		END IF ;

		SELECT l_player_id, l_bans ;

	END IF ;

END $$

DELIMITER ;
