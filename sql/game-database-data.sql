USE `audit` ;
TRUNCATE `audit`.`squad_action_types` ;
LOCK TABLES `audit`.`squad_action_types` WRITE;
INSERT INTO `audit`.`squad_action_types` (id, name)
VALUES
(1, 'pre-create'),
(2, 'check'),
(3, 'disband'),
(4, 'add'),
(5, 'promote'),
(6, 'demote'),
(7, 'appoint'),
(8, 'remove'),
(9, 'approve'),
(10, 'settext')
;
UNLOCK TABLES ;

USE `player` ;
TRUNCATE `player`.`note_types` ;
LOCK TABLES `player`.`note_types` WRITE;
INSERT INTO `player`.`note_types` VALUES (1,'Comment'),(2,'Ban'),(3,'Warning'),(4,'Kick');
UNLOCK TABLES;

USE `game` ;
TRUNCATE `game`.`branches` ;
LOCK TABLES `game`.`branches` WRITE;
INSERT INTO `game`.`branches` (id, name, abbr) VALUES (1,'Army','AR'),(2,'Air Force','AF'),(3,'Navy','NV');
UNLOCK TABLES;

USE `game` ;
TRUNCATE `game`.`countries` ;
LOCK TABLES `game`.`countries` WRITE;
INSERT INTO `game`.`countries`
(id, side, name, fullname, is_active)
VALUES
(1,1,'UK','ENGLAND',1),
(2,1,'US','USA',1),
(3,1,'FR','FRANCE',1),
(4,2,'DE','GERMANY',1),
(5,2,'IT','ITALY',0),
(6,2,'JP','JAPAN',0),
(7,1,'CW','COMMONWEALTH',0),
(8,1,'CN','CHINA',0),
(9,1,'RU','RUSSIA',0);
UNLOCK TABLES;

USE `player` ;
TRUNCATE `player`.`players` ;
LOCK TABLES `player`.`players` WRITE ;
INSERT INTO `player`.`players` (id, customer_id, callsign, isplaynet) values (1, 1, "SYSTEM", 1) ;
UNLOCK TABLES ;

USE `game` ;
TRUNCATE `game`.`arena_config` ;
LOCK TABLES `game`.`arena_config` WRITE;
INSERT INTO `game`.`arena_config` (name,value) VALUES ('binocs_rank','1'),('dead_body_delay','1200000'),('max_reports','20'),('max_user_reports','8'),('max_waypoints','16');
UNLOCK TABLES;

USE `game` ;
TRUNCATE `game`.`rank_types` ;
LOCK TABLES `rank_types` WRITE;
INSERT INTO `rank_types` VALUES (1,'Enlisted'),(2,'Officer'),(3,'Command'),(4,'CRS Staff');
UNLOCK TABLES;

USE `game` ;
TRUNCATE `game`.`ranks` ;
LOCK TABLES `game`.`ranks` WRITE;
INSERT INTO `game`.`ranks`
(id,rank,description,nextrank,pointsrequired,`type`,start_points)
VALUES
(1,'E1','Recruit',2,100,1,0),
(2,'E2','Private',3,300,1,100),
(3,'E3','Lance Corporal',4,500,1,400),
(4,'E4','Corporal',5,750,1,900),
(5,'E5','Sergeant',6,1000,1,1650),
(6,'E6','Colour Sergeant',7,1250,1,2650),
(7,'E7','QM Sergeant',8,1500,1,3900),
(8,'E8','Sgt. Major',9,2000,1,5400),
(9,'O1','2nd Lieutenant',10,3000,2,7400),
(10,'O2','Lieutenant',11,5000,2,10400),
(11,'O3','Captain',12,10000,2,15400),
(12,'O4','Major',13,20000,2,25400),
(13,'O5','Lt. Colonel',0,65535,2,45400),
(14,'C1','Colonel',0,65535,3,110935),
(15,'C2','Brigadier Gen.',0,65535,3,176470),
(16,'C3','Major General',0,65535,3,242005),
(17,'C4','Lt. General',0,65535,3,307540),
(18,'C5','General',0,65535,3,373075),
(19,'C6','Fieldmarshall',0,65535,3,438610),
(20,'C7','Country Leader',0,65535,3,504145),
(21,'C8','Theater Leader',0,65535,3,569680),
(22,'C9','Side Commander',0,65535,3,635215),
(23,'R1','Junior Staff',0,65535,4,700750),
(24,'R2','Staff',0,65535,4,766285),
(25,'R3','Senior Staff',0,65535,4,831820);
UNLOCK TABLES;

USE `game` ;
TRUNCATE `game`.`vehicle_categories` ;
LOCK TABLES `game`.`vehicle_categories` WRITE;
INSERT INTO `game`.`vehicle_categories` (id, name, fullname, branch_id) VALUES (1,'AC','Aircraft',2),(2,'GV','Ground Vehicle',1),(3,'SV','Sea Vehicle',3),(4,'IN','Infantry',1),(5,'MN','Munitions',1);
UNLOCK TABLES;

USE `game` ;
TRUNCATE `game`.`vehicle_classes` ;
LOCK TABLES `game`.`vehicle_classes` WRITE ;
INSERT INTO `game`.`vehicle_classes`
(categoryid, classid, fullname)
VALUES
(1,1,'bomber'),
(1,2,'fighter'),
(1,3,'gm'),
(2,4,'tank'),
(2,5,'artillery'),
(2,6,'truck'),
(2,7,'gun'),
(3,12,'riverine'),
(3,13,'sea'),
(4,8,'crew'),
(4,9,'troop'),
(4,14,'para'),
(4,15,'depot'),
(5,10,'airBomb'),
(5,11,'heavyInfantry');
UNLOCK TABLES;

