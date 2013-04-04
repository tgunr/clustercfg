USE `game` ;

DELIMITER $$

DROP FUNCTION IF EXISTS `game`.`f_date_rounded` $$

CREATE
	FUNCTION `game`.`f_date_rounded`
	( i_date DATETIME, i_seconds INT(11) UNSIGNED )
	RETURNS DATETIME
	NO SQL
	DETERMINISTIC
BEGIN
	RETURN FROM_UNIXTIME( FLOOR( UNIX_TIMESTAMP(i_date) / i_seconds ) * i_seconds ) ;
END $$

DELIMITER ;

