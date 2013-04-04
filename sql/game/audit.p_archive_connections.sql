/*
	Thu Oct 18 15:19:30 CDT 2007 ogs
	Transfer old entries from the wwiionline.wwii_connections table
	to the "archive" table instead.
*/

USE `audit` ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `audit`.`p_archive_connections` $$

CREATE PROCEDURE `audit`.`p_archive_connections`
   (
     i_num_days INT(11) UNSIGNED
   )

  LANGUAGE SQL
  MODIFIES SQL DATA
  SQL SECURITY INVOKER

BEGIN
	DECLARE l_start_date DATETIME ;
	DECLARE l_end_date DATETIME ;
	DECLARE	l_max_date DATETIME DEFAULT DATE_SUB(NOW(), INTERVAL 60 DAY) ;
	DECLARE l_no_rows TINYINT(1) UNSIGNED DEFAULT 0 ;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_no_rows = 1 ;

	SELECT MIN(recorded) INTO l_start_date FROM audit.connections ;

	IF l_no_rows = 1 THEN
		SELECT 0, "No value for recorded" ;
	ELSE
		SET l_end_date = DATE_ADD(l_start_date, INTERVAL i_num_days DAY) ;
		IF l_end_date > l_max_date THEN
			SET l_end_date = l_max_date ;
		END IF ;

		START TRANSACTION ;

		INSERT INTO audit.connections_old
			SELECT * FROM audit.connections
			 WHERE recorded BETWEEN l_start_date AND l_end_date
		;

		DELETE
		  FROM audit.connections
		 WHERE recorded BETWEEN l_start_date AND l_end_date
		;

		SELECT 1, l_start_date, l_end_date, row_count() ;
	END IF ;

END $$

DELIMITER ;
