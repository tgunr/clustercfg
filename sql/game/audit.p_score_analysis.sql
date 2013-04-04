/*
	Wed Dec  5 16:11:24 CST 2007 ogs
	Analyse the current "score" audit trail
*/

USE `audit` ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `audit`.`p_score_analysis` $$

CREATE PROCEDURE `audit`.`p_score_analysis`
(
)

  LANGUAGE SQL
  MODIFIES SQL DATA
  SQL SECURITY INVOKER

BEGIN
	DECLARE l_last_persona_id, l_persona_id BIGINT(20) UNSIGNED ;
	DECLARE l_last_rank, l_branchid, l_old_rank, l_new_rank INT(11) UNSIGNED ;
	DECLARE l_last_recorded, l_recorded DATETIME ;

	DECLARE l_done TINYINT(1) UNSIGNED DEFAULT 0 ;

	DECLARE curs CURSOR FOR
		SELECT	r.persona_id, r.recorded, p.branchid, r.old_rank, r.new_rank
		  FROM	`audit`.`rank` r
				INNER JOIN `player`.`personas` p ON (r.persona_id = p.id)
		 ORDER	BY 1, 2
	;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_done = 1 ;

	OPEN curs ;
	REPEAT
		FETCH curs INTO l_persona_id, l_recorded, l_branchid, l_old_rank, l_new_rank ;
		IF NOT l_done THEN
			IF l_persona_id = l_last_persona_id AND l_old_rank = l_last_rank AND l_new_rank = l_last_rank + 1 THEN
				REPLACE INTO `audit`.`score_analysis`
					(persona_id, branchid, rankid, first_entry, last_entry, hours, complete)
				VALUES
					( l_persona_id, l_branchid, l_new_rank, l_last_recorded, l_recorded
					, FLOOR((UNIX_TIMESTAMP(l_recorded) - UNIX_TIMESTAMP(l_last_recorded)) / 3600 + 0.5)
					, 1
					)
				;
			END IF ;
			SET l_last_persona_id = l_persona_id, l_last_rank = l_new_rank, l_last_recorded = l_recorded ;
		END IF ;
	UNTIL l_done END REPEAT ;
	CLOSE curs ;

END $$

DELIMITER ;

