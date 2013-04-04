USE `player` ;

DELIMITER $$

DROP TRIGGER IF EXISTS game.tau_sortie_times $$

CREATE TRIGGER game.tau_sortie_times
  AFTER UPDATE ON game.sorties FOR EACH ROW
BEGIN

   IF OLD.return_time IS NULL AND NEW.return_time IS NOT NULL THEN
     SET @return_time = UNIX_TIMESTAMP(NEW.return_time) ;
     SET @spawn_time  = UNIX_TIMESTAMP(NEW.spawn_time) ;
     IF @return_time > @spawn_time THEN
       UPDATE player.players
		  SET total_time_played = IF(total_time_played, total_time_played, 0) + (@return_time - @spawn_time)
	    WHERE id = NEW.player_id
	   ;
     END IF ;
   END IF ;

END$$

DELIMITER ;

