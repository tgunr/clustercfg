/*
	Thu Jan 17 12:13:53 CST 2008
	Get the last kills of a named player
*/

USE `player` ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `player`.`p_get_last_kills` $$

CREATE PROCEDURE `player`.`p_get_last_kills`
   (
	i_callsign VARCHAR(10)
   )

  LANGUAGE SQL
  READS SQL DATA
  SQL SECURITY INVOKER

BEGIN

    SELECT  k.kill_time AS `kill_time`
		 ,	kv.fullName	AS `killer_veh`
         ,  vp.callsign AS `victim_crew`
         ,  vv.fullName AS `victim_veh`
      FROM  `player`.`players` kp INNER JOIN `game`.`kills` k ON (kp.id = k.killer_player) INNER JOIN `player`.`players` vp ON (k.victim_player = vp.id)
            , `game`.`vehicle_types` vv
            , `game`.`vehicle_types` kv
     WHERE  kp.callsign = i_callsign
			AND k.killer_vehtype_oid = kv.vehtype_oid
			AND k.victim_vehtype_oid = vv.vehtype_oid
     ORDER  BY k.kill_time DESC
     LIMIT  5
     ;

END $$

DELIMITER ;

