/* Formatted on 2007/08/14 15:25 (QP5 v5.50) */

USE `player` ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `player`.`p_persona_add_score`$$

CREATE PROCEDURE `player`.`p_persona_add_score`
   (
    forPlayer BIGINT(20) unsigned
   , forPersona BIGINT(20) unsigned
   , pointsScored INT(11) unsigned
   , onSortie BIGINT(20) unsigned
   )

  LANGUAGE SQL
  MODIFIES SQL DATA
  SQL SECURITY INVOKER

BEGIN

 DECLARE i_persona_points INT(11) unsigned;
 DECLARE i_rank_id  INT unsigned;
 DECLARE i_next_rank_id  INT unsigned;
 DECLARE i_rank_points  INT(11) unsigned;
 DECLARE b_promoted  BOOL DEFAULT false;

 -- If we don't find the player/persona combo, duly note it via b_success
 DECLARE b_success BOOL DEFAULT true;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET b_success = false;

 -- Return values.
 -- Player and persona returned so that this query can be threaded on the host
 -- and it can look up the necessary player again after the command has executed.
 SELECT forPlayer, forPersona, b_success, b_promoted, i_rank_id, i_persona_points ; 

END$$

DELIMITER ;
