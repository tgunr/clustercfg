/*
 * $Id: auth.p_get_chat_group_summmary.sql 5578 2012-01-31 21:47:53Z osmith $
 * ** GAME DATABASE SPECIFIC: Requires wwiionline schema **
 * Retrieve summary of chat_groups that have changed since
 * the specified timestamp.
 * Called by gameservers to maintain an in-memory mapping
 * of <group-oid>:<permission mask, rank restrictions etc>
 * Expecting columns:
 *  1 = group_oid
 *  2 = enabled (1 = yes, 0 = no)
 *  3 = max army rank (branch 1)
 *  4 = max air rank (branch 2)
 *  5 = max navy rank (branch 3)
 *  6 = max squad rank
 *  7 = grant permission mask
 */

USE `auth` ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `auth`.`p_get_chat_group_summary` $$

CREATE PROCEDURE `auth`.`p_get_chat_group_summary`
(
)
  LANGUAGE SQL
  READS SQL DATA
  SQL SECURITY INVOKER
BEGIN
	SELECT	cg.group_oid
	     ,	IF(cg.enabled='Y', 1, 0) AS enabled
	     ,	MAX(IF(cgr.branchid = 1, cgr.max_rank, NULL)) AS max_army_rank
	     ,	MAX(IF(cgr.branchid = 2, cgr.max_rank, NULL)) AS max_air_rank
	     ,	MAX(IF(cgr.branchid = 3, cgr.max_rank, NULL)) AS max_navy_rank
	     ,	cg.max_squad_rank
	     ,	cg.grants
	     ,  GROUP_CONCAT(cgv.vehtype_oid) AS vehtype_oids
	  FROM	`auth`.`chat_groups` cg
			LEFT OUTER JOIN `chat`.`group_ranks` cgr USING (group_oid)
			LEFT OUTER JOIN `chat`.`group_vehs_cache` cgv ON (cg.group_oid = cgv.group_oid)
	 GROUP	BY 1
	;
END $$



DELIMITER ;

