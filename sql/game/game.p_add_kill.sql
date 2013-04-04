/*
	Thu Jan 10 12:18:02 CST 2008 ogs
	Record one vehicle killing another
*/

USE `game` ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `game`.`p_add_kill` $$

CREATE PROCEDURE `game`.`p_add_kill`
   (
		i_instance_id BIGINT(20) UNSIGNED

	,	i_killer_id BIGINT(20) UNSIGNED
	,	i_killer_player BIGINT(20) UNSIGNED
	,	i_killer_persona BIGINT(20) UNSIGNED

	,	i_killer_country TINYINT(3) UNSIGNED
	,	i_killer_category TINYINT(3) UNSIGNED
	,	i_killer_class TINYINT(3) UNSIGNED
	,	i_killer_type TINYINT(3) UNSIGNED

	,	i_victim_id BIGINT(20) UNSIGNED
	,	i_victim_player BIGINT(20) UNSIGNED
	,	i_victim_persona INT(20) UNSIGNED

	,	i_victim_country TINYINT(3) UNSIGNED
	,	i_victim_category TINYINT(3) UNSIGNED
	,	i_victim_class TINYINT(3) UNSIGNED
	,	i_victim_type TINYINT(3) UNSIGNED

	,	i_kill_value INT(11) UNSIGNED

	,	i_dead_x INT(11)
	,	i_dead_y INT(11)
	,	i_dead_z INT(11)
   )

  LANGUAGE SQL
  MODIFIES SQL DATA
  SQL SECURITY INVOKER

BEGIN
	DECLARE l_insert_error TINYINT(1) UNSIGNED DEFAULT 0 ;

	DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET l_insert_error = 1 ;

	START TRANSACTION ;

	-- Single table version - yahoo!
	INSERT INTO `game`.`kills`
		(
			instance_id
		,	kill_time
		,	victim_sortie_id
		,	victim_player
		,	killer_sortie_id
		,	killer_player
		,	dead_x, dead_y, dead_z
		,	victim_country, victim_category, victim_class, victim_type
		,	victim_vehtype_oid
		,	killer_country, killer_category, killer_class, killer_type
		,	killer_vehtype_oid
		)
	VALUES
		(
			i_instance_id
		,	NOW()
		,	i_victim_id
		,	i_victim_player
		,	i_killer_id
		,	IF(i_killer_player <> 0,i_killer_player,(SELECT kps.player_id FROM `game`.`sorties` kps WHERE kps.id = i_killer_id))
		,	i_dead_x, i_dead_y, i_dead_z
		,	i_victim_country, i_victim_category, i_victim_class, i_victim_type
		,	(SELECT vehtype_oid FROM `game`.`vehicle_types` WHERE countryID = i_victim_country AND categoryID = i_victim_category AND classID = i_victim_class AND typeID = i_victim_type)
		,	i_killer_country, i_killer_category, i_killer_class, i_killer_type
		,	(SELECT vehtype_oid FROM `game`.`vehicle_types` WHERE countryID = i_killer_country AND categoryID = i_killer_category AND classID = i_killer_class AND typeID = i_killer_type)
		)
	;

	IF l_insert_error = 0 THEN
		COMMIT ;
	ELSE
		ROLLBACK ;
	END IF ;

END $$

DELIMITER ;
