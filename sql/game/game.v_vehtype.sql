/*
   game.v_vehtype
	Wed Sep 19 15:42:37 CDT 2007
	Extends game.vehicle_types with the value of f_weapon_spec as weapon_spec
*/

USE `game` ;

CREATE OR REPLACE
	DEFINER = CURRENT_USER
	SQL SECURITY INVOKER
	VIEW `game`.`v_vehtype`
	AS
	SELECT	*, game.f_weapon_spec(countryid, categoryid, classid, typeid) AS weapon_spec
	  FROM	`game`.`vehicle_types` v
;

