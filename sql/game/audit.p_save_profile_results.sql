/*
	Tue Nov 27 17:32:29 CST 2007 ogs
	Save a profile result
*/

USE `audit` ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `audit`.`p_save_profile_results` $$

CREATE PROCEDURE `audit`.`p_save_profile_results`
(
	i_player_id		BIGINT(20)	UNSIGNED
,	i_version_no	VARCHAR(15)
,	i_frames		INT(11) UNSIGNED
,	i_min_time		FLOAT
,	i_max_time		FLOAT
,	i_total_time	FLOAT
,	i_over_100		INT(11) UNSIGNED
,	i_over_300		INT(11) UNSIGNED
,	i_over_500		INT(11) UNSIGNED
,	i_over_1000		INT(11) UNSIGNED
,	i_peak_mem		INT(11) UNSIGNED
,	i_os			VARCHAR(3)
,	i_num_cpus		INT(11) UNSIGNED
,	i_cpu_flags		INT(11) UNSIGNED
,	i_cpu_mhz		INT(11) UNSIGNED
,	i_cpu_name		VARCHAR(64)
,	i_notes			TEXT
)

  LANGUAGE SQL
  MODIFIES SQL DATA
  SQL SECURITY INVOKER

BEGIN
	INSERT INTO `audit`.`profile_results`
		( recorded, player_id, version
		, total_frames, min_frame_time, max_frame_time, total_frame_time
		, frames_over_100ms, frames_over_300ms, frames_over_500ms, frames_over_1000ms
		, peak_mem
		, operating_system
		, num_cpus, cpu_flags, cpu_mhz, cpu_name
		, notes
		)
	VALUES
		( NOW(), i_player_id, INET_ATON(i_version_no)
		, i_frames, i_min_time, i_max_time, i_total_time
		, i_over_100, i_over_300, i_over_500, i_over_1000
		, i_peak_mem
		, i_os
		, i_num_cpus, i_cpu_flags, i_cpu_mhz, i_cpu_name
		, i_notes
		) ;
END $$

DELIMITER ;
