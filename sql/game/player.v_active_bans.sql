/*
   player.v_active_bans
	Sun Sep  2 16:06:59 CDT 2007 ogs
	Returns active bans from player_notes with a qualification of
	who issued them.
*/

USE `player` ;

CREATE OR REPLACE
	DEFINER = CURRENT_USER
	SQL SECURITY INVOKER
	VIEW `player`.`v_active_bans`
	AS
	SELECT	note.player_id, note.note_at as banned_at, note.note_end as banned_until, note.note as reason, IF(p.callsign IS NULL,"SYSTEM",p.callsign) as banner
	  FROM	`player`.`notes` note 
			LEFT JOIN `player`.`players` p
				ON (note.note_by = p.id)
	 WHERE	note.note_type_id = 2 AND note.note_end > NOW()
;

