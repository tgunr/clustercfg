/*
	Thu Jan 10 15:57:05 CST 2008 ogs
	Record a sortie generating a pilot and crew record as needed
*/

USE `game` ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `game`.`p_add_sortie` $$

CREATE PROCEDURE `game`.`p_add_sortie`
   (
		i_sortie_id	BIGINT(20) UNSIGNED
	,	i_player_id BIGINT(20) UNSIGNED, i_persona_id BIGINT(20) UNSIGNED
	,   i_instance_id BIGINT(20) UNSIGNED
	,	i_weap_country TINYINT(3) UNSIGNED, i_weap_category TINYINT(3) UNSIGNED, i_weap_class TINYINT(3) UNSIGNED, i_weap_type TINYINT(3) UNSIGNED
	,	i_mission_type SMALLINT UNSIGNED, i_mission_id BIGINT(20) UNSIGNED
	,	i_cell_host_ip TINYINT(3) UNSIGNED
   )

  LANGUAGE SQL
  MODIFIES SQL DATA
  SQL SECURITY INVOKER

BEGIN

	INSERT HIGH_PRIORITY INTO `game`.`sorties`
		(
		  id
		, player_id, persona_id, instance_id
		, vcountry, vcategory, vclass, vtype
		, mission_type, mission_id
		, cell_host_ip
		, added
		)
	VALUES
		(
		  i_sortie_id
		, i_player_id, i_persona_id, i_instance_id
		, i_weap_country, i_weap_category, i_weap_class, i_weap_type
		, i_mission_type, i_mission_id
		, i_cell_host_ip
		, NOW()
		) ;

END $$

DELIMITER ;
