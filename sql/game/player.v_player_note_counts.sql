USE `player` ;

CREATE OR REPLACE
	DEFINER = CURRENT_USER
	SQL SECURITY INVOKER
	VIEW `player`.`v_player_note_counts`
	AS
	SELECT	pl.id AS player_id
		 ,	SUM(IF(note_type_id = 1, 1, 0)) AS `comments`
		 ,	SUM(IF(note_type_id = 2, 1, 0)) AS `bans`
		 ,	SUM(IF(note_type_id = 3, 1, 0)) AS `warnings`
	  FROM	`player`.`players` pl
			LEFT JOIN `player`.`notes` pn ON (pl.id = pn.player_id)
	 GROUP	BY 1
;	

