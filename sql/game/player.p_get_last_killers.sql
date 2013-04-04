/*
	Thu Jan 17 12:13:53 CST 2008
	Get the last killers of a named player
*/

USE `player` ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `player`.`p_get_last_killers` $$

CREATE PROCEDURE `player`.`p_get_last_killers`
   (
	i_callsign VARCHAR(10)
   )

  LANGUAGE SQL
  READS SQL DATA
  SQL SECURITY INVOKER

BEGIN

    SELECT  k.kill_time
         ,  kp.callsign
         ,  vv.fullName
         ,  kv.fullName
      FROM  `player`.`players` vp INNER JOIN `game`.`kills` k ON (vp.id = k.victim_player) INNER JOIN `player`.`players` kp ON (v.killer_player = kp.id)
            , `game`.`vehicle_types` vv
            , `game`.`vehicle_types` kv
     WHERE  vp.callsign = i_callsign
			AND k.victim_vehtype_oid = vv.vehtype_oid
			AND k.killer_vehtype_oid = kv.vehtype_oid
     ORDER  BY k.kill_time DESC
     LIMIT  5
     ;
END $$

DELIMITER ;

