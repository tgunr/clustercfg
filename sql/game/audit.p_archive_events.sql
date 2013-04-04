/*
	Thu Oct 18 15:19:30 CDT 2007 ogs
	Transfer old entries from the audit.archive_events table
	to the "archive" table instead.
*/

USE `audit` ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `audit`.`p_archive_events` $$

CREATE PROCEDURE `audit`.`p_archive_events`
   (
     i_max_days INT(11) UNSIGNED
   )

  LANGUAGE SQL
  MODIFIES SQL DATA
  SQL SECURITY INVOKER

BEGIN
	DECLARE l_start_date DATETIME ;
	DECLARE l_end_date DATETIME ;
	DECLARE l_no_rows TINYINT(1) UNSIGNED DEFAULT 0 ;
	DECLARE l_rows_copied BIGINT(20) UNSIGNED DEFAULT 0 ;

	-- The last date to retain
	DECLARE	l_oldest_date DATETIME DEFAULT DATE_SUB(NOW(), INTERVAL 31 DAY) ;
	-- Maximum days to archive at a time
	DECLARE l_max_days INT(11) UNSIGNED DEFAULT 7 ;

	-- Set this to non-zero to use average values instead of raw
	DECLARE l_averaging_seconds INT(11) UNSIGNED DEFAULT 0 ;


	DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_no_rows = 1 ;


	-- What's the earliest entry in the table?
	SELECT MIN(recorded) INTO l_start_date FROM `audit`.`events` ;

	IF l_no_rows = 1 THEN
		-- Nothing in the table to archive
		SELECT 0, "No value for recorded" ;
	ELSE
		-- Determinine the cut-off date for archiving; if there are way
		SET l_end_date = DATE_ADD(l_start_date, INTERVAL i_max_days DAY) ;
		IF l_end_date > l_oldest_date THEN
			SET l_end_date = l_oldest_date ;
		END IF ;

		START TRANSACTION ;

		IF l_averaging_seconds > 0 THEN
			-- Average 15 minute windows
			SET l_end_date = `game`.`f_date_rounded`(l_end_date, l_averaging_seconds) ;

			INSERT INTO `audit`.`events_old`
						(`recorded`, `host`, `event`, `number`)
				SELECT	`game`.`f_date_rounded`(`recorded`, l_averaging_seconds), `host`
						, `event`, AVG(`number`)
			  	FROM	`audit`.`events`
			 	WHERE	recorded < l_end_date
						AND EVENT NOT LIKE 'nc2-%'
						AND `number` <> 0
			 	GROUP	BY 1, 2
			 	ORDER	BY 1, 2
			;
		ELSE
			-- Use raw, non-zero values
			INSERT INTO `audit`.`events_old`
						(`recorded`, `host`, `event`, `number`)
				SELECT	recorded, host, event, number
			  	FROM	`audit`.`events`
			 	WHERE	recorded < l_end_date
						AND EVENT NOT LIKE 'nc2-%'
						AND `number` <> 0
				ORDER	BY 1, 2
			;
		END IF ;

		SET l_rows_copied = row_count() ;

		DELETE
		  FROM `audit`.`events`
		 WHERE recorded BETWEEN l_start_date AND l_end_date
		;

		SELECT 1, l_start_date, l_end_date, l_rows_copied, row_count() AS l_rows_deleted ;
	END IF ;

END $$

DELIMITER ;

USE `game` ;
