/*
   player.v_player_notes
	Sun Sep  2 16:06:59 CDT 2007 ogs
	Returns a list of player notes with a qualification of issuer
*/

USE `player` ;

CREATE OR REPLACE
	DEFINER = CURRENT_USER
	SQL SECURITY INVOKER
	VIEW `player`.`v_player_notes`
	AS
	SELECT	note.*, pnt.description, IF(p.callsign IS NULL,"SYSTEM",p.callsign) as callsign
	  FROM	`player`.`note_types` pnt
			INNER JOIN `player`.`notes` note 
				ON (pnt.id = note.note_type_id)
			LEFT JOIN `player`.`players` p
				ON (note.note_by = p.id)
;	

