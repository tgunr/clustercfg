/*
	Thu Jan 17 12:13:53 CST 2008
	Get the last killers of a named player
*/

USE `player` ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `player`.`p_increase_rank_score` $$

CREATE PROCEDURE `player`.`p_increase_rank_score`
   (
		i_player_id BIGINT(20) UNSIGNED
	,	i_country INT(11) UNSIGNED
	,	i_branch INT(11) UNSIGNED
	,	i_persona_id	BIGINT(20) UNSIGNED
	,	i_rankid INT(11) UNSIGNED
	,	i_points INT(11) UNSIGNED
   )

  LANGUAGE SQL
  MODIFIES SQL DATA
  SQL SECURITY DEFINER

BEGIN

	UPDATE	`player`.`score`
	   SET	points = points + i_points
	 WHERE	player_id = i_player_id
	;

END $$

DELIMITER ;
