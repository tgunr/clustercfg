-- MySQL dump 10.13  Distrib 5.1.41, for debian-linux-gnu (i486)
--
-- Host: localhost    Database: auth
-- ------------------------------------------------------
-- Server version	5.1.41-3ubuntu12.10-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `auth_subscription`
--

LOCK TABLES `auth_subscription` WRITE;
/*!40000 ALTER TABLE `auth_subscription` DISABLE KEYS */;
INSERT INTO `auth_subscription` VALUES (1,'FREE','Playnet Free Games Subscription.','access'),(2,'PERB','Closed Beta','access'),(3,'RETP','Premium','access'),(4,'WCOM','WWII Online Community Subscription','access'),(5,'MEAT','Meat Subcription, do not ADD!!!','access'),(6,'WPAY','WWII Online Monthly','access'),(7,'WPRE','WWII Online 6-Month','access'),(8,'DOGF','Dogfighter Community','access'),(9,'CRS','CRS Staff','access'),(10,'DSMO','Darkspace Monthly','access'),(11,'DS6M','Darkspace 6-Month Prepay','access'),(12,'DSYR','Darkspace 12-Month Prepay','access'),(13,'RVAL','WWII Online Re-Evaluation','access'),(14,'GGEX','WWII Online Gigex Promo','access'),(15,'INT+','WWII Online International Monthly + CD Key','access'),(16,'INT','WWII Online International Monthly','access'),(17,'MBTA','WWII Online Mac Beta','access'),(18,'DS3M','Darkspace 3-Month Prepay','access'),(19,'E3PR','WWII Online E3 Promo','access'),(20,'W1M+','WWII Online Monthly + Activation Key','access'),(21,'W3M+','WWII Online 3-Month + Activation Key','access'),(22,'W6M+','WWII Online 6-Month + Activation Key','access'),(23,'W3M','WWII Online 3-Month','access'),(24,'PSUP','Playnet Support','access'),(25,'IPCG','WWII Online Incite PCGames Promo','access'),(26,'REXT','Special Prepay Offer','access'),(27,'PCGP','PC GAMEPLAY Promo','access'),(28,'SWDN','WWII Online PC GAMER SVENSKA Promo','access'),(29,'WJOY','WWII Online JOYSTICK FRANCE Promo','access'),(30,'JS6M','WWII Online 6-Month Joystick Special','access'),(31,'EALF','WWII Online Events Allied Fighter','access'),(32,'EALB','WWII Online Events Allied Bomber','access'),(33,'EALS','WWII Online Events Allied Ship','access'),(34,'EAXF','WWII Online Events Axis Fighter','access'),(35,'EAXB','WWII Online Events Axis Bomber','access'),(36,'EAXS','WWII Online Events Axis Ship','access'),(37,'IMGP','WWII Online INSIDEMACGAMES Promo','access'),(38,'GIGX','WWII Online Gigex Promo','access'),(39,'GMC','WWII Online GMC Promo','access'),(40,'OPBE','WWII Online Open Beta','access'),(41,'SCAN','WWII Online ScanDH promo','access'),(42,'WYT','WWII Online Yearly (TShirt)','access'),(43,'WYT+','WWII Online Yearly (TShirt) + Activation Key','access'),(44,'WYER','WWII Online Yearly','access'),(45,'WYR+','WWII Online Yearly + Activation Key','access'),(46,'WNGP','WWII Online Netgamer Promo','access'),(47,'WTGP','WWII Online Total Games PC Promo','access'),(48,'WMCS','WWII Online Microsim Promo','access'),(50,'EVNT','WWII Online Events Pass','access'),(54,'W5YR','WWII Online 5-Year','access'),(55,'WLFE','WWII Online Lifetime','access'),(56,'WFEP','WWII Online Free Events Promo','access'),(57,'WATT','WWII Online ATT Demo','access'),(58,'WMAG','WWII Online WW2 Mag Promo','access'),(59,'WPEL','WWII Online Pelaaja Promo','access'),(60,'WMDK','WWII Online Monthly (DK)','access'),(61,'WT2','WWII Online Yearly (T-Shirt)','access'),(62,'WT2+','WWII Online Yearly (T-Shirt) + Activation Key','access'),(63,'W3MS','WWII Online 3-Month Special','access'),(64,'WPCT','WWII Online PC Team Promo','access'),(65,'WFRT','WWII Online Filefront Promo','access'),(66,'WGMC','WWII Online GMC Promo','access'),(67,'WWAR','WWII Online PC Zone Promo','access'),(68,'WJUX','WWII Online PC Jeux Promo','access'),(69,'WMG2','WWII Online WWII Mag Promo','access'),(70,'WSWG','WWII Online SWG 501st Rogue','access'),(71,'WTIR','WWII Online Track IR','access'),(72,'W12B','WWII Online 12-Month Builders','access'),(73,'WFSP','WWII Online FiringSquad','access'),(122,'MMOR','WWII Online MMORPG Free Trial','access'),(134,'PRGR','Press Group','access'),(137,'BELM','BE Limited Trial','access'),(144,'MT14','Matrix Games 14 Day Free Trial','access'),(154,'BE14','BE 14-day Free Trial (K)','access'),(168,'BSEP','Bridges SE 7-Day Free Trial','access'),(169,'WB07','Welcome Back Soldier 2007','access'),(171,'MINC','Mini-Con Sub','access'),(172,'GIGA','Giga TV Trial','access'),(174,'B214','BE 14-day Free Trial (NK)','access'),(183,'WBS8','Welcome Back Soldier 2008','access'),(186,'WBSX','Welcome Back Soldier Christmas 2008','access'),(187,'DARK','CRS Darkglasses','permissions'),(188,'PROD','CRS Producer','permissions'),(189,'GM','GM','permissions'),(190,'TRAI','Trainer','permissions'),(191,'AHC','AHC','permissions'),(192,'AHC1','AHC+','permissions'),(193,'AHC2','AHC++','permissions'),(194,'GHC','GHC','permissions'),(195,'GHC1','GHC+','permissions'),(196,'GHC2','GHC++','permissions'),(197,'FP','Free Play','access'),(199,'EVST','Event Staff','access'),(200,'BLDR','Builders','permissions'),(201,'FAFT','Fighter Ace Free Trial','access'),(202,'131B','1.31 Open Beta','access'),(206,'WBSY','Welcome Back Soldier v1.32','access'),(205,'ALl','14 Day All Access Trial','access'),(209,'BBTA','Builders Beta','access'),(213,'BSQD','Squads Beta','access'),(214,'WBSO','WBS Oct 2011','access');
/*!40000 ALTER TABLE `auth_subscription` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-01-31 10:34:17
