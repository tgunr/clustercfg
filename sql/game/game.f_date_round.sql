USE `game` ;

DELIMITER $$

DROP FUNCTION IF EXISTS `game`.`f_date_round` $$

CREATE
	FUNCTION `game`.`f_date_round`
	( i_date DATETIME, i_seconds INT(11) UNSIGNED )
	RETURNS INT(11) UNSIGNED
	NO SQL
	DETERMINISTIC
BEGIN
	RETURN FLOOR( UNIX_TIMESTAMP(i_date) / i_seconds ) * i_seconds ;
END $$

DELIMITER ;

