USE `game` ;

DELIMITER $$

DROP FUNCTION IF EXISTS `game`.`f_weapon_spec` $$

CREATE
	FUNCTION `game`.`f_weapon_spec`
	( i_country INT(11) UNSIGNED, i_category INT(11) UNSIGNED, i_class INT(11) UNSIGNED, i_type INT(11) UNSIGNED )
	RETURNS INT(11) UNSIGNED
	NO SQL
	DETERMINISTIC
BEGIN
	RETURN ((i_country << 24) | (i_category << 16) | (i_class << 8) | (i_type)) & 0xffffffff ;
END $$

DELIMITER ;

