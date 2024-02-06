-- MariaDB dump 10.19  Distrib 10.4.28-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: mrp
-- ------------------------------------------------------
-- Server version	10.4.28-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `assetcategory`
--

DROP TABLE IF EXISTS `assetcategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assetcategory` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `code` varchar(50) NOT NULL,
  `description` varchar(50) NOT NULL,
  `priority` int(11) DEFAULT NULL,
  `isPartOf_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `assetcategory_isPartOf_id_114f99d9_fk_assetcategory_id` (`isPartOf_id`),
  CONSTRAINT `assetcategory_isPartOf_id_114f99d9_fk_assetcategory_id` FOREIGN KEY (`isPartOf_id`) REFERENCES `assetcategory` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assetcategory`
--

LOCK TABLES `assetcategory` WRITE;
/*!40000 ALTER TABLE `assetcategory` DISABLE KEYS */;
INSERT INTO `assetcategory` VALUES (1,'کاردینگ','','',2,NULL),(2,'پاساژ','','',3,NULL),(3,'فینیشر','','',4,NULL),(4,'رینگ','','',5,NULL),(5,'اتوکنر','','',6,NULL),(6,'لاکنی','','',7,NULL),(7,'دولاتاب','','',8,NULL),(8,'هیت ست','','',9,NULL),(9,'حلاجی','','',1,NULL),(10,'آزاد','','',10,NULL);
/*!40000 ALTER TABLE `assetcategory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assetrandemaninit`
--

DROP TABLE IF EXISTS `assetrandemaninit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assetrandemaninit` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `operator_count` int(11) NOT NULL,
  `max_randeman` decimal(10,0) NOT NULL,
  `randeman_yek_dastgah` decimal(10,0) NOT NULL,
  `randeman_mazrab_3` decimal(10,0) NOT NULL,
  `mablaghe_kole_randeman` decimal(10,0) NOT NULL,
  `mablaghe_kole_randeman_round` decimal(10,0) NOT NULL,
  `randeman_tolid` decimal(10,0) NOT NULL,
  `asset_category_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `assetrandemaninit_asset_category_id_5ebcf7b2_fk_assetcategory_id` (`asset_category_id`),
  CONSTRAINT `assetrandemaninit_asset_category_id_5ebcf7b2_fk_assetcategory_id` FOREIGN KEY (`asset_category_id`) REFERENCES `assetcategory` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assetrandemaninit`
--

LOCK TABLES `assetrandemaninit` WRITE;
/*!40000 ALTER TABLE `assetrandemaninit` DISABLE KEYS */;
INSERT INTO `assetrandemaninit` VALUES (1,1,6800000,6800000,20400000,0,0,0,9),(2,1,4900000,4900000,14700000,24054545,24050000,19240000,1),(3,1,4900000,4900000,14700000,24054545,24050000,19240000,2),(4,1,4900000,4900000,14700000,24054545,24050000,19240000,3),(5,8,5900000,47200000,141600000,231709091,231710000,185368000,4),(6,3,4900000,14700000,44100000,72163636,72160000,57728000,5),(7,3,4900000,14700000,44100000,72163636,72160000,57728000,6),(8,3,4900000,14700000,44100000,72163636,72160000,57728000,7),(9,3,4900000,14700000,44100000,72163636,72160000,57728000,8),(10,1,5400000,5400000,16200000,26509091,26510000,21208000,10);
/*!40000 ALTER TABLE `assetrandemaninit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assetrandemanlist`
--

DROP TABLE IF EXISTS `assetrandemanlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assetrandemanlist` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `mah` int(11) NOT NULL,
  `sal` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assetrandemanlist`
--

LOCK TABLES `assetrandemanlist` WRITE;
/*!40000 ALTER TABLE `assetrandemanlist` DISABLE KEYS */;
INSERT INTO `assetrandemanlist` VALUES (26,9,1402),(29,10,1402);
/*!40000 ALTER TABLE `assetrandemanlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assetrandemanpermonth`
--

DROP TABLE IF EXISTS `assetrandemanpermonth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assetrandemanpermonth` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tolid_value` decimal(10,2) NOT NULL,
  `mah` int(11) NOT NULL,
  `sal` int(11) NOT NULL,
  `asset_category_id` bigint(20) NOT NULL,
  `shift_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `assetrandemanpermont_asset_category_id_cc9b6e91_fk_assetcate` (`asset_category_id`),
  KEY `assetrandemanpermonth_shift_id_4a7979c4_fk_shift_id` (`shift_id`),
  CONSTRAINT `assetrandemanpermont_asset_category_id_cc9b6e91_fk_assetcate` FOREIGN KEY (`asset_category_id`) REFERENCES `assetcategory` (`id`),
  CONSTRAINT `assetrandemanpermonth_shift_id_4a7979c4_fk_shift_id` FOREIGN KEY (`shift_id`) REFERENCES `shift` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=514 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assetrandemanpermonth`
--

LOCK TABLES `assetrandemanpermonth` WRITE;
/*!40000 ALTER TABLE `assetrandemanpermonth` DISABLE KEYS */;
INSERT INTO `assetrandemanpermonth` VALUES (460,20695691.09,9,1402,5,1),(461,16069129.23,9,1402,5,2),(462,20963179.68,9,1402,5,3),(463,7834300.21,9,1402,2,1),(464,4048670.90,9,1402,2,2),(465,7357028.89,9,1402,2,3),(466,19242666.67,9,1402,7,1),(467,19242666.67,9,1402,7,2),(468,19242666.67,9,1402,7,3),(469,67792781.27,9,1402,4,1),(470,50890766.32,9,1402,4,2),(471,66684452.42,9,1402,4,3),(472,6382911.36,9,1402,3,1),(473,6499845.84,9,1402,3,2),(474,6357242.81,9,1402,3,3),(475,8756742.47,9,1402,1,1),(476,2208401.97,9,1402,1,2),(477,8274855.56,9,1402,1,3),(478,19621706.16,9,1402,6,1),(479,19296815.17,9,1402,6,2),(480,18809478.67,9,1402,6,3),(481,16203107.99,9,1402,8,1),(482,20605576.44,9,1402,8,2),(483,20919315.57,9,1402,8,3),(490,32075703.85,10,1402,5,1),(491,12516138.05,10,1402,5,2),(492,13136158.10,10,1402,5,3),(493,994327.74,10,1402,2,1),(494,1689031.28,10,1402,2,2),(495,16556640.98,10,1402,2,3),(496,19313822.33,10,1402,7,1),(497,19100355.34,10,1402,7,2),(498,19313822.33,10,1402,7,3),(499,63960455.98,10,1402,4,1),(500,61345749.38,10,1402,4,2),(501,60061794.64,10,1402,4,3),(502,111550.33,10,1402,3,1),(503,18985.01,10,1402,3,2),(504,19109464.67,10,1402,3,3),(505,4006080.31,10,1402,1,1),(506,7616959.85,10,1402,1,2),(507,7616959.85,10,1402,1,3),(508,27755425.32,10,1402,6,1),(509,1751821.72,10,1402,6,2),(510,28220752.96,10,1402,6,3),(511,55527287.92,10,1402,8,1),(512,1207938.97,10,1402,8,2),(513,992773.10,10,1402,8,3);
/*!40000 ALTER TABLE `assetrandemanpermonth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assets`
--

DROP TABLE IF EXISTS `assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assets` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `assetTypes` int(11) DEFAULT NULL,
  `assetName` varchar(100) NOT NULL,
  `assetDescription` varchar(100) DEFAULT NULL,
  `assetCode` varchar(50) DEFAULT NULL,
  `assetAddress` varchar(100) DEFAULT NULL,
  `assetCity` varchar(50) DEFAULT NULL,
  `assetState` varchar(50) DEFAULT NULL,
  `assetZipcode` varchar(50) DEFAULT NULL,
  `assetCountry` varchar(100) DEFAULT NULL,
  `assetAccount` varchar(100) DEFAULT NULL,
  `assetChargeDepartment` varchar(100) DEFAULT NULL,
  `assetNotes` varchar(100) DEFAULT NULL,
  `assetBarcode` int(11) DEFAULT NULL,
  `assetHasPartOf` tinyint(1) NOT NULL,
  `assetAisel` int(11) DEFAULT NULL,
  `assetRow` int(11) DEFAULT NULL,
  `assetBin` int(11) DEFAULT NULL,
  `assetManufacture` varchar(50) DEFAULT NULL,
  `assetModel` varchar(50) DEFAULT NULL,
  `assetSerialNumber` varchar(50) DEFAULT NULL,
  `assetStatus` tinyint(1) NOT NULL,
  `assetIsStock` tinyint(1) NOT NULL,
  `assetTavali` int(11) DEFAULT NULL,
  `assetCategory_id` bigint(20) DEFAULT NULL,
  `assetIsLocatedAt_id` bigint(20) DEFAULT NULL,
  `assetIsPartOf_id` bigint(20) DEFAULT NULL,
  `assetMachineCategory_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `assets_assetCategory_id_c2ac8995_fk_assetcategory_id` (`assetCategory_id`),
  KEY `assets_assetIsLocatedAt_id_5d718c44_fk_assets_id` (`assetIsLocatedAt_id`),
  KEY `assets_assetIsPartOf_id_c24c9bca_fk_assets_id` (`assetIsPartOf_id`),
  KEY `assets_assetMachineCategory_id_29b0595a_fk_machinecategory_id` (`assetMachineCategory_id`),
  CONSTRAINT `assets_assetCategory_id_c2ac8995_fk_assetcategory_id` FOREIGN KEY (`assetCategory_id`) REFERENCES `assetcategory` (`id`),
  CONSTRAINT `assets_assetIsLocatedAt_id_5d718c44_fk_assets_id` FOREIGN KEY (`assetIsLocatedAt_id`) REFERENCES `assets` (`id`),
  CONSTRAINT `assets_assetIsPartOf_id_c24c9bca_fk_assets_id` FOREIGN KEY (`assetIsPartOf_id`) REFERENCES `assets` (`id`),
  CONSTRAINT `assets_assetMachineCategory_id_29b0595a_fk_machinecategory_id` FOREIGN KEY (`assetMachineCategory_id`) REFERENCES `machinecategory` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assets`
--

LOCK TABLES `assets` WRITE;
/*!40000 ALTER TABLE `assets` DISABLE KEYS */;
INSERT INTO `assets` VALUES (2,1,'ریسندگی',NULL,'ln1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,NULL,NULL,NULL,NULL,NULL),(3,2,'کاردینگ',NULL,'carding_ln1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,1,2,NULL,NULL),(4,2,'پاساژ',NULL,'pasag_ln1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,2,2,2,NULL,NULL),(5,2,'فینیشر',NULL,'finisher_ln1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,3,3,2,NULL,NULL),(6,2,'رینگ 1',NULL,'ring1_ln1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,4,4,2,NULL,NULL),(7,2,'رینگ 2',NULL,'ring2_ln1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,5,4,2,NULL,NULL),(8,2,'رینگ 3',NULL,'ring3_ln1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,6,4,2,NULL,NULL),(9,2,'اوتوکنر 1',NULL,'autoconner1_ln1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,9,5,2,NULL,NULL),(10,2,'رینگ 4',NULL,'ring4_ln1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,7,4,2,NULL,NULL),(11,2,'رینگ زینسر',NULL,'ring_zinser_ln1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,8,4,2,NULL,NULL),(12,2,'اوتوکنر 2',NULL,'autoconner2_ln1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,10,5,2,NULL,NULL),(13,2,'اوتوکنر 3',NULL,'autoconner3_ln1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,11,5,2,NULL,NULL),(14,2,'اوتوکنر 4',NULL,'autoconner4_ln1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,12,5,2,NULL,NULL),(15,2,'اوتوکنر 5',NULL,'autoconner4_ln1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,13,5,2,NULL,NULL),(16,2,'لاکنی',NULL,'lakoni_ln1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,14,6,2,NULL,NULL),(17,2,'دولاتاب 1',NULL,'dolatab1_ln1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,15,7,2,NULL,NULL),(18,2,'دولاتاب 2',NULL,'dolatab2_ln1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,16,7,2,NULL,NULL),(19,2,'دولاتاب 3',NULL,'dolatab3_ln1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,17,7,2,NULL,NULL),(20,1,'هیت ست آرسیا1',NULL,'heatset2_ln1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,19,8,2,NULL,NULL),(21,1,'هیت ست آرسیا2',NULL,'heatset3_ln1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,20,8,2,NULL,NULL),(22,1,'هیت ست اورنک',NULL,'heatset1_ln1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,18,8,2,NULL,NULL);
/*!40000 ALTER TABLE `assets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add asset category',7,'add_assetcategory'),(26,'Can change asset category',7,'change_assetcategory'),(27,'Can delete asset category',7,'delete_assetcategory'),(28,'Can view asset category',7,'view_assetcategory'),(29,'Can add machine category',8,'add_machinecategory'),(30,'Can change machine category',8,'change_machinecategory'),(31,'Can delete machine category',8,'delete_machinecategory'),(32,'Can view machine category',8,'view_machinecategory'),(33,'Can add asset',9,'add_asset'),(34,'Can change asset',9,'change_asset'),(35,'Can delete asset',9,'delete_asset'),(36,'Can view asset',9,'view_asset'),(37,'Can add daily production',10,'add_dailyproduction'),(38,'Can change daily production',10,'change_dailyproduction'),(39,'Can delete daily production',10,'delete_dailyproduction'),(40,'Can view daily production',10,'view_dailyproduction'),(41,'Can add formula',11,'add_formula'),(42,'Can change formula',11,'change_formula'),(43,'Can delete formula',11,'delete_formula'),(44,'Can view formula',11,'view_formula'),(45,'Can add sys user',12,'add_sysuser'),(46,'Can change sys user',12,'change_sysuser'),(47,'Can delete sys user',12,'delete_sysuser'),(48,'Can view sys user',12,'view_sysuser'),(49,'Can add shift',13,'add_shift'),(50,'Can change shift',13,'change_shift'),(51,'Can delete shift',13,'delete_shift'),(52,'Can view shift',13,'view_shift'),(53,'Can add speed formula',14,'add_speedformula'),(54,'Can change speed formula',14,'change_speedformula'),(55,'Can delete speed formula',14,'delete_speedformula'),(56,'Can view speed formula',14,'view_speedformula'),(57,'Can add production standard',15,'add_productionstandard'),(58,'Can change production standard',15,'change_productionstandard'),(59,'Can delete production standard',15,'delete_productionstandard'),(60,'Can view production standard',15,'view_productionstandard'),(61,'Can add zayeat vaz',16,'add_zayeatvaz'),(62,'Can change zayeat vaz',16,'change_zayeatvaz'),(63,'Can delete zayeat vaz',16,'delete_zayeatvaz'),(64,'Can view zayeat vaz',16,'view_zayeatvaz'),(65,'Can add zayeat',17,'add_zayeat'),(66,'Can change zayeat',17,'change_zayeat'),(67,'Can delete zayeat',17,'delete_zayeat'),(68,'Can view zayeat',17,'view_zayeat'),(69,'Can add failure',18,'add_failure'),(70,'Can change failure',18,'change_failure'),(71,'Can delete failure',18,'delete_failure'),(72,'Can view failure',18,'view_failure'),(73,'Can add asset failure',19,'add_assetfailure'),(74,'Can change asset failure',19,'change_assetfailure'),(75,'Can delete asset failure',19,'delete_assetfailure'),(76,'Can view asset failure',19,'view_assetfailure'),(77,'Can add asset randeman init',20,'add_assetrandemaninit'),(78,'Can change asset randeman init',20,'change_assetrandemaninit'),(79,'Can delete asset randeman init',20,'delete_assetrandemaninit'),(80,'Can view asset randeman init',20,'view_assetrandemaninit'),(81,'Can add asset randeman per month',21,'add_assetrandemanpermonth'),(82,'Can change asset randeman per month',21,'change_assetrandemanpermonth'),(83,'Can delete asset randeman per month',21,'delete_assetrandemanpermonth'),(84,'Can view asset randeman per month',21,'view_assetrandemanpermonth'),(85,'Can add asset randeman list',22,'add_assetrandemanlist'),(86,'Can change asset randeman list',22,'change_assetrandemanlist'),(87,'Can delete asset randeman list',22,'delete_assetrandemanlist'),(88,'Can view asset randeman list',22,'view_assetrandemanlist'),(89,'Can add nezafat padash',23,'add_nezafatpadash'),(90,'Can change nezafat padash',23,'change_nezafatpadash'),(91,'Can delete nezafat padash',23,'delete_nezafatpadash'),(92,'Can view nezafat padash',23,'view_nezafatpadash'),(93,'Can add nezafat ranking',24,'add_nezafatranking'),(94,'Can change nezafat ranking',24,'change_nezafatranking'),(95,'Can delete nezafat ranking',24,'delete_nezafatranking'),(96,'Can view nezafat ranking',24,'view_nezafatranking'),(97,'Can add tolid padash',25,'add_tolidpadash'),(98,'Can change tolid padash',25,'change_tolidpadash'),(99,'Can delete tolid padash',25,'delete_tolidpadash'),(100,'Can view tolid padash',25,'view_tolidpadash'),(101,'Can add tolid ranking',26,'add_tolidranking'),(102,'Can change tolid ranking',26,'change_tolidranking'),(103,'Can delete tolid ranking',26,'delete_tolidranking'),(104,'Can view tolid ranking',26,'view_tolidranking');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$260000$3d2GboOdP16IRGYtBrclBN$j6zofB3TcG6687Yjkj9clxu8YogjilUqBmDXhEyCag8=','2024-02-05 17:33:00.078418',1,'admin','','','dsa@ds.com',1,1,'2023-12-02 06:27:37.902847');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dailyproduction`
--

DROP TABLE IF EXISTS `dailyproduction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dailyproduction` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dayOfIssue` date NOT NULL,
  `timestamp` datetime(6) NOT NULL,
  `register_user` varchar(100) NOT NULL,
  `nomre` double NOT NULL,
  `counter` double NOT NULL,
  `production_value` double DEFAULT NULL,
  `machine_id` bigint(20) NOT NULL,
  `speed` int(11) NOT NULL,
  `shift_id` bigint(20) NOT NULL,
  `daf_num` double DEFAULT NULL,
  `dook_weight` double DEFAULT NULL,
  `net_weight` double DEFAULT NULL,
  `weight1` double DEFAULT NULL,
  `weight2` double DEFAULT NULL,
  `weight3` double DEFAULT NULL,
  `weight4` double DEFAULT NULL,
  `weight5` double DEFAULT NULL,
  `makhraj_metraj_daf` double DEFAULT NULL,
  `metrajdaf1` double DEFAULT NULL,
  `metrajdaf2` double DEFAULT NULL,
  `metrajdaf3` double DEFAULT NULL,
  `metrajdaf4` double DEFAULT NULL,
  `metrajdaf5` double DEFAULT NULL,
  `metrajdaf6` double DEFAULT NULL,
  `metrajdaf7` double DEFAULT NULL,
  `metrajdaf8` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dailyproduction_machine_id_shift_id_dayOfIssue_e9a55b55_uniq` (`machine_id`,`shift_id`,`dayOfIssue`),
  KEY `dailyproduction_machine_id_3581c565_fk_assets_id` (`machine_id`),
  KEY `dailyproduction_shift_id_b0e36c70_fk_shift_id` (`shift_id`),
  CONSTRAINT `dailyproduction_machine_id_3581c565_fk_assets_id` FOREIGN KEY (`machine_id`) REFERENCES `assets` (`id`),
  CONSTRAINT `dailyproduction_shift_id_b0e36c70_fk_shift_id` FOREIGN KEY (`shift_id`) REFERENCES `shift` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1048 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dailyproduction`
--

LOCK TABLES `dailyproduction` WRITE;
/*!40000 ALTER TABLE `dailyproduction` DISABLE KEYS */;
INSERT INTO `dailyproduction` VALUES (937,'2024-01-27','2024-01-29 13:11:26.736021','',25,290,6525,3,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(938,'2024-01-27','2024-01-29 13:11:26.753012','',25,114.589,2578.25,4,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(939,'2024-01-27','2024-01-29 13:11:26.770999','',1.7,41.673,1530.23,5,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(940,'2024-01-27','2024-01-29 13:11:26.786989','',21,11.27,416.02,6,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(941,'2024-01-27','2024-01-29 13:11:26.792988','',21,11.36,419.35,7,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(942,'2024-01-27','2024-01-29 13:11:26.802981','',21,11.11,410.12,8,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(943,'2024-01-27','2024-01-29 13:11:26.808975','',21,10.96,404.58,10,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(944,'2024-01-27','2024-01-29 13:11:26.823967','',21,574,545.3,11,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(945,'2024-01-27','2024-01-29 13:11:26.829963','',21,419,398.05,9,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(946,'2024-01-27','2024-01-29 13:11:26.839957','',21,433,411.35,12,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(947,'2024-01-27','2024-01-29 13:11:26.845953','',21,417,396.15,13,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(948,'2024-01-27','2024-01-29 13:11:26.861944','',21,409,388.55,14,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(949,'2024-01-27','2024-01-29 13:11:26.866940','',21,533,506.35,15,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(950,'2024-01-27','2024-01-29 13:11:26.877920','',7,1207,2293.3,16,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(951,'2024-01-27','2024-01-29 13:11:26.883915','',7,8,729.6,17,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(952,'2024-01-27','2024-01-29 13:11:26.900925','',7,8,729.6,18,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(953,'2024-01-27','2024-01-29 13:11:26.959007','',7,8,729.6,19,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(954,'2024-01-27','2024-01-29 13:11:26.980041','',25,2.486,55.94,3,290,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(955,'2024-01-27','2024-01-29 13:11:26.987034','',25,35.859,806.83,4,290,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(956,'2024-01-27','2024-01-29 13:11:27.052428','',1.7,63.471,2330.66,5,185,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(957,'2024-01-27','2024-01-29 13:11:27.064338','',21,11.57,427.1,6,24,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(958,'2024-01-27','2024-01-29 13:11:27.071434','',21,11.35,418.98,7,24,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(959,'2024-01-27','2024-01-29 13:11:27.088452','',21,11.29,416.76,8,24,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(960,'2024-01-27','2024-01-29 13:11:27.094922','',21,11.17,412.33,10,24,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(961,'2024-01-27','2024-01-29 13:11:27.106522','',21,581,551.95,11,24,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(962,'2024-01-27','2024-01-29 13:11:27.112529','',21,441,418.95,9,1100,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(963,'2024-01-27','2024-01-29 13:11:27.128574','',21,423,401.85,12,1100,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(964,'2024-01-27','2024-01-29 13:11:27.135017','',21,436,414.2,13,1100,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(965,'2024-01-27','2024-01-29 13:11:27.145993','',21,416,395.2,14,1100,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(966,'2024-01-27','2024-01-29 13:11:27.152987','',21,546,518.7,15,1050,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(967,'2024-01-27','2024-01-29 13:11:27.170976','',7,1239,2354.1,16,700,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(968,'2024-01-27','2024-01-29 13:11:27.176973','',7,8,729.6,17,78,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(969,'2024-01-27','2024-01-29 13:11:27.188965','',7,8,729.6,18,78,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(970,'2024-01-27','2024-01-29 13:11:27.194962','',7,8,729.6,19,78,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(971,'2024-01-27','2024-01-29 13:11:27.213951','',25,107.584,2420.64,3,290,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(972,'2024-01-27','2024-01-29 13:11:27.220945','',25,73.211,1647.25,4,290,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(973,'2024-01-27','2024-01-29 13:11:27.240335','',1.7,29.49,1082.87,5,185,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(974,'2024-01-27','2024-01-29 13:11:27.248466','',21,11.2,413.44,6,24,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(975,'2024-01-27','2024-01-29 13:11:27.262885','',21,11.29,416.76,7,24,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(976,'2024-01-27','2024-01-29 13:11:27.272167','',21,11.1,409.75,8,24,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(977,'2024-01-27','2024-01-29 13:11:27.329030','',21,10.92,403.1,10,24,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(978,'2024-01-27','2024-01-29 13:11:27.351956','',21,586,556.7,11,24,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(979,'2024-01-27','2024-01-29 13:11:27.366491','',21,440,418,9,1100,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(980,'2024-01-27','2024-01-29 13:11:27.384444','',21,440,418,12,1100,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(981,'2024-01-27','2024-01-29 13:11:27.397442','',21,429,407.55,13,1100,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(982,'2024-01-27','2024-01-29 13:11:27.422095','',21,450,427.5,14,1100,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(983,'2024-01-27','2024-01-29 13:11:27.436103','',21,589,559.55,15,1050,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(984,'2024-01-27','2024-01-29 13:11:27.455762','',7,1170,2223,16,700,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(985,'2024-01-27','2024-01-29 13:11:27.470382','',7,8,729.6,17,78,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(986,'2024-01-27','2024-01-29 13:11:27.495364','',7,8,729.6,18,78,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(987,'2024-01-27','2024-01-29 13:11:27.509892','',7,8,729.6,19,78,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(988,'2024-01-22','2024-01-30 12:08:29.651965','',25,104.311,2347,3,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(989,'2024-01-22','2024-01-30 12:08:29.663127','',25,99.991,2249.8,4,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(990,'2024-01-22','2024-01-30 12:08:29.673965','',1.7,55.503,2038.07,5,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(991,'2024-01-22','2024-01-30 12:08:29.683304','',21,11.11,410.12,6,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(992,'2024-01-22','2024-01-30 12:08:29.692407','',21,11.28,416.39,7,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(993,'2024-01-22','2024-01-30 12:08:29.699485','',21,11.2,413.44,8,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(994,'2024-01-22','2024-01-30 12:08:29.709483','',21,11.08,409.01,10,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(995,'2024-01-22','2024-01-30 12:08:29.722476','',21,577,548.15,11,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(996,'2024-01-22','2024-01-30 12:08:29.729964','',21,414,393.3,9,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(997,'2024-01-22','2024-01-30 12:08:29.738960','',21,413,392.35,12,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(998,'2024-01-22','2024-01-30 12:08:29.746442','',21,421,399.95,13,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(999,'2024-01-22','2024-01-30 12:08:29.754284','',21,432,410.4,14,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1000,'2024-01-22','2024-01-30 12:08:29.764399','',21,552,524.4,15,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1001,'2024-01-22','2024-01-30 12:08:29.772972','',7,1189,2259.1,16,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1002,'2024-01-22','2024-01-30 12:08:29.781145','',7,8,729.6,17,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1003,'2024-01-22','2024-01-30 12:08:29.789146','',7,8,729.6,18,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1004,'2024-01-22','2024-01-30 12:08:29.799677','',7,8,729.6,19,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1005,'2024-01-22','2024-01-30 12:08:29.808966','',25,107.487,2418.46,3,290,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1006,'2024-01-22','2024-01-30 12:08:29.816961','',25,105.625,2376.56,4,290,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1007,'2024-01-22','2024-01-30 12:08:29.828984','',1.7,56.406,2071.23,5,185,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1008,'2024-01-22','2024-01-30 12:08:29.864930','',21,11.54,425.99,6,24,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1009,'2024-01-22','2024-01-30 12:08:29.875802','',21,11.3,417.13,7,24,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1010,'2024-01-22','2024-01-30 12:08:29.883610','',21,11.21,413.81,8,24,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1011,'2024-01-22','2024-01-30 12:08:29.893604','',21,11.09,409.38,10,24,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1012,'2024-01-22','2024-01-30 12:08:29.902861','',21,587,557.65,11,24,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1013,'2024-01-22','2024-01-30 12:08:29.910612','',21,442,419.9,9,1100,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1014,'2024-01-22','2024-01-30 12:08:29.921372','',21,437,415.15,12,1100,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1015,'2024-01-22','2024-01-30 12:08:29.929896','',21,430,408.5,13,1100,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1016,'2024-01-22','2024-01-30 12:08:29.939469','',21,426,404.7,14,1100,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1017,'2024-01-22','2024-01-30 12:08:29.949109','',21,575,546.25,15,1050,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1018,'2024-01-22','2024-01-30 12:08:29.957971','',7,1168,2219.2,16,700,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1019,'2024-01-22','2024-01-30 12:08:29.966966','',7,8,729.6,17,78,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1020,'2024-01-22','2024-01-30 12:08:29.975997','',7,8,729.6,18,78,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1021,'2024-01-22','2024-01-30 12:08:29.984575','',7,8,729.6,19,78,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1022,'2024-01-22','2024-01-30 12:08:29.995980','',25,90.7,2040.75,3,290,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1023,'2024-01-22','2024-01-30 12:08:30.003948','',25,86.816,1953.36,4,290,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1024,'2024-01-22','2024-01-30 12:08:30.014120','',1.7,48.816,1792.52,5,185,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1025,'2024-01-22','2024-01-30 12:08:30.022095','',21,11.12,410.49,6,24,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1026,'2024-01-22','2024-01-30 12:08:30.033083','',21,11.36,419.35,7,24,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1027,'2024-01-22','2024-01-30 12:08:30.042768','',21,10.98,405.32,8,24,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1028,'2024-01-22','2024-01-30 12:08:30.051063','',21,10.96,404.58,10,24,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1029,'2024-01-22','2024-01-30 12:08:30.062057','',21,582,552.9,11,24,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1030,'2024-01-22','2024-01-30 12:08:30.070363','',21,452,429.4,9,1100,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1031,'2024-01-22','2024-01-30 12:08:30.078390','',21,425,403.75,12,1100,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1032,'2024-01-22','2024-01-30 12:08:30.086958','',21,414,393.3,13,1100,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1033,'2024-01-22','2024-01-30 12:08:30.094917','',21,420,399,14,1100,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1034,'2024-01-22','2024-01-30 12:08:30.101854','',21,554,526.3,15,1050,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1035,'2024-01-22','2024-01-30 12:08:30.109850','',7,1215,2308.5,16,700,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1036,'2024-01-22','2024-01-30 12:08:30.119844','',7,8,729.6,17,78,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1037,'2024-01-22','2024-01-30 12:08:30.127839','',7,8,729.6,18,78,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1038,'2024-01-22','2024-01-30 12:08:30.136832','',7,8,729.6,19,78,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(1039,'2024-01-27','2024-01-30 12:20:58.165452','',0,0,917.14,22,418,1,0,45000,0,0,17000,0,0,917.14,0,0,0,0,0,0,0,0,0),(1040,'2024-01-27','2024-01-30 12:20:58.172449','',0,0,298.27,20,300,1,0,4700,0,13388,13412,65420,65456,298.27,5800,4795,3044,1684,3997,3987,2568,0,0),(1041,'2024-01-27','2024-01-30 12:20:58.179497','',0,0,353.4,21,300,1,0,4700,0,10840,10876,28468,28504,353.4,5800,4562,264,4368,2973,2542,3800,0,0),(1042,'2024-01-27','2024-01-30 12:20:58.185494','',0,0,1542.86,22,0,2,0,45000,0,17000,17000,0,0,1542.86,0,0,0,0,0,0,0,0,0),(1043,'2024-01-27','2024-01-30 12:20:58.192452','',0,0,297.54,20,0,2,0,4700,0,13412,13436,65456,65492,297.54,0,0,0,0,0,0,0,0,0),(1044,'2024-01-27','2024-01-30 12:20:58.199421','',0,0,409.96,21,0,2,0,4700,0,10876,10924,28504,28540,409.96,0,0,0,0,0,0,0,0,0),(1045,'2024-01-27','2024-01-30 12:20:58.209602','',0,0,1534.29,22,0,3,0,45000,0,17000,16000,0,0,1534.29,0,0,0,0,0,0,0,0,0),(1046,'2024-01-27','2024-01-30 12:20:58.218167','',0,0,342.54,20,0,3,0,4700,0,13436,13468,65492,65532,342.54,0,0,0,0,0,0,0,0,0),(1047,'2024-01-27','2024-01-30 12:20:58.226457','',0,0,412.95,21,0,3,0,4700,0,10924,10960,28540,28590,412.95,0,0,0,0,0,0,0,0,0);
/*!40000 ALTER TABLE `dailyproduction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2023-12-18 09:01:23.580262','1','ضایعات',1,'[{\"added\": {}}]',17,1),(2,'2023-12-18 09:01:36.957631','1','پرز',2,'[{\"changed\": {\"fields\": [\"Name\"]}}]',17,1),(3,'2023-12-18 09:01:57.748400','2','سرنخ',1,'[{\"added\": {}}]',17,1),(4,'2023-12-19 05:30:01.127525','6','سرنخ - 312.0 kg',3,'',16,1),(5,'2023-12-19 05:30:01.132517','5','سرنخ - 312.0 kg',3,'',16,1),(6,'2023-12-19 05:30:01.141529','4','سرنخ - 312.0 kg',3,'',16,1),(7,'2023-12-19 05:30:01.145430','3','سرنخ - 21.0 kg',3,'',16,1),(8,'2023-12-19 05:30:01.148434','2','سرنخ - 12.0 kg',3,'',16,1),(9,'2023-12-19 05:30:01.152216','1','سرنخ - 12.0 kg',3,'',16,1),(10,'2023-12-31 09:10:38.342552','1','2 - 1',1,'[{\"added\": {}}]',18,1),(11,'2023-12-31 09:10:43.363942','2','3 - 3',1,'[{\"added\": {}}]',18,1);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(9,'mrp','asset'),(7,'mrp','assetcategory'),(19,'mrp','assetfailure'),(20,'mrp','assetrandemaninit'),(22,'mrp','assetrandemanlist'),(21,'mrp','assetrandemanpermonth'),(10,'mrp','dailyproduction'),(18,'mrp','failure'),(11,'mrp','formula'),(8,'mrp','machinecategory'),(23,'mrp','nezafatpadash'),(24,'mrp','nezafatranking'),(15,'mrp','productionstandard'),(13,'mrp','shift'),(14,'mrp','speedformula'),(12,'mrp','sysuser'),(25,'mrp','tolidpadash'),(26,'mrp','tolidranking'),(17,'mrp','zayeat'),(16,'mrp','zayeatvaz'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2023-12-02 06:24:13.783483'),(2,'auth','0001_initial','2023-12-02 06:24:14.306854'),(3,'admin','0001_initial','2023-12-02 06:24:14.467969'),(4,'admin','0002_logentry_remove_auto_add','2023-12-02 06:24:14.479978'),(5,'admin','0003_logentry_add_action_flag_choices','2023-12-02 06:24:14.488984'),(6,'contenttypes','0002_remove_content_type_name','2023-12-02 06:24:14.550027'),(7,'auth','0002_alter_permission_name_max_length','2023-12-02 06:24:14.609068'),(8,'auth','0003_alter_user_email_max_length','2023-12-02 06:24:14.658104'),(9,'auth','0004_alter_user_username_opts','2023-12-02 06:24:14.669111'),(10,'auth','0005_alter_user_last_login_null','2023-12-02 06:24:14.698132'),(11,'auth','0006_require_contenttypes_0002','2023-12-02 06:24:14.701135'),(12,'auth','0007_alter_validators_add_error_messages','2023-12-02 06:24:14.714144'),(13,'auth','0008_alter_user_username_max_length','2023-12-02 06:24:14.784192'),(14,'auth','0009_alter_user_last_name_max_length','2023-12-02 06:24:14.852241'),(15,'auth','0010_alter_group_name_max_length','2023-12-02 06:24:14.895272'),(16,'auth','0011_update_proxy_permissions','2023-12-02 06:24:14.907282'),(17,'auth','0012_alter_user_first_name_max_length','2023-12-02 06:24:14.965322'),(18,'sessions','0001_initial','2023-12-02 06:24:15.009353'),(19,'mrp','0001_initial','2023-12-02 06:25:06.352450'),(20,'mrp','0002_asset_machinecategory','2023-12-02 06:26:56.001683'),(21,'mrp','0003_dailyproduction_formula','2023-12-02 08:08:20.450086'),(22,'mrp','0004_dailyproduction_speed','2023-12-03 03:36:18.525305'),(23,'mrp','0005_sysuser','2023-12-03 03:36:18.641388'),(24,'mrp','0006_auto_20231202_2059','2023-12-03 03:37:03.323095'),(25,'mrp','0007_remove_dailyproduction_shift','2023-12-03 03:37:03.329098'),(26,'mrp','0008_dailyproduction_shift','2023-12-03 03:37:03.334103'),(27,'mrp','0009_remove_dailyproduction_shift','2023-12-03 03:37:03.340106'),(28,'mrp','0010_dailyproduction_shift','2023-12-03 03:38:14.317473'),(29,'mrp','0011_speedformula','2023-12-03 05:26:20.336424'),(30,'mrp','0012_delete_speedformula','2023-12-03 05:27:26.992725'),(31,'mrp','0013_speedformula','2023-12-03 05:27:26.995727'),(32,'mrp','0014_delete_speedformula','2023-12-03 05:27:47.721434'),(33,'mrp','0015_speedformula','2023-12-03 05:28:02.280765'),(34,'mrp','0016_auto_20231205_0937','2023-12-05 06:07:40.216791'),(35,'mrp','0017_productionstandard','2023-12-05 06:56:38.863099'),(36,'mrp','0018_zayeat_zayeatvaz','2023-12-18 08:51:07.854573'),(37,'mrp','0019_auto_20231218_1228','2023-12-18 08:58:10.592329'),(38,'mrp','0020_zayeatvaz_dayofissue','2023-12-18 09:26:53.157079'),(39,'mrp','0021_zayeatvaz_shift','2023-12-19 04:54:29.641796'),(40,'mrp','0022_assetfailure_failure','2023-12-31 08:58:22.278272'),(41,'mrp','0023_auto_20231231_1318','2023-12-31 09:48:25.717589'),(42,'mrp','0024_auto_20240109_1354','2024-01-09 10:24:46.574230'),(43,'mrp','0025_assetrandemanpermonth','2024-01-10 06:10:14.371648'),(44,'mrp','0026_assetrandemanlist','2024-01-10 06:56:01.829428'),(45,'mrp','0027_auto_20240112_1534','2024-01-13 05:36:54.091834'),(46,'mrp','0028_auto_20240117_1052','2024-01-17 07:22:47.934822'),(47,'mrp','0029_auto_20240122_1121','2024-01-22 07:51:45.817471'),(48,'mrp','0030_auto_20240122_1142','2024-01-22 08:12:39.056234'),(49,'mrp','0031_auto_20240129_0458','2024-01-29 12:58:42.509719'),(50,'mrp','0031_auto_20240129_1627','2024-02-05 17:33:23.878864'),(51,'mrp','0032_alter_dailyproduction_unique_together','2024-02-05 17:33:23.916568');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('38qufhtnm9hqfp5k76qp6i56ekb927h2','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rUQOU:_DISoLeoKtOyFYV6CBJAcPvr1XiahMvijd2-LhqUDWA','2024-02-12 12:05:42.669927'),('7k0k2bpm4hsdf1ah62v5r6r0stn91fdf','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rDO2k:tXJZ--0FvCy1mLM9sr5ZYWYl0dtW8n9cKKDf_COydO0','2023-12-27 12:08:50.884359'),('au6ut6acjh8wqh54qhdb6s359q6whjho','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rJreV:_d-NjLvPO5zQVsRrZVBi7_dGwTteGk5R801tzWO4zE4','2024-01-14 08:58:35.369055'),('b39ggxssso96tkam2cfeusu5tf93u3k8','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rSERp:OnIxSvZCBKrETbGQLxrzWyvu2F7WtyMrnQEOQ6PgnKc','2024-02-06 10:56:05.101511'),('btkyg92ceh7lcktjevlh5624iw04toe4','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rU2Mt:hAVMPyfbKV2scJNmIER9hClMLRghbPqpOpICeW6oI4g','2024-02-11 10:26:27.312700'),('fauodtzdutn1geg2cz5oa9gzx1udbkfz','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rCyom:Mv_RcGJiW4EZCryGv_khmLKn6y6WqEgsjnXxN6enIjQ','2023-12-26 09:12:44.419167'),('i401su1yf08cove076pfewtxa20za59j','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rCcpp:WmvEx2qA5fFma9GPBf8QTBsna4m4Ctt4xCvntrN6-OE','2023-12-25 09:44:21.643394'),('mtts10yommv21feic40u4rao8jxk1o2k','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rUMtk:ToXmydYzg6QFBRmpo4z-znf7wpIMM3yHg_yWcgH7Nbw','2024-02-12 08:21:44.815977'),('ri3dp5ye4pasd1hiwn1huv061gs6dysv','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rN9hQ:4otptzdX6CzKkjfaiw9pAJXsbw4LKD9Dk7JHNjQiunY','2024-01-23 10:51:12.722759'),('s6wfxjzo3f09uelm511tcxpdben2k6xi','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rUQCu:Yf8lx6NQoR-2fcYZ-bHzkUBSn9C8nC7STOe9f_LozIY','2024-02-12 11:53:44.562747'),('tsgplhjmy4or4nf893eb3jivr8wni7rj','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rCdGz:2N1cMSHyz16I6DmA8r-WGoltBZ-nldhzJzDHic-Ch5Q','2023-12-25 10:12:25.036309'),('wbyc4lbc47skknr4089l9v9cn9zs54m1','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rM6AC:Z_1ouzEIJGo5v8829BzH_2SH7v9d23o19vGLWfN3pMQ','2024-01-20 12:52:32.051849'),('zo0z7wtpcr5p2g4vxwx4v4bztxm7ne8a','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rX2q4:Xx05vd2oZL3ydBXlF_BSxQ3HzAskam87l8WJiLVi3ME','2024-02-19 17:33:00.085425');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failure`
--

DROP TABLE IF EXISTS `failure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `failure` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failure`
--

LOCK TABLES `failure` WRITE;
/*!40000 ALTER TABLE `failure` DISABLE KEYS */;
INSERT INTO `failure` VALUES (12,'01','برقی');
/*!40000 ALTER TABLE `failure` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `formula`
--

DROP TABLE IF EXISTS `formula`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `formula` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `formula` varchar(255) NOT NULL,
  `machine_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `machine_id` (`machine_id`),
  CONSTRAINT `formula_machine_id_bc181d55_fk_assets_id` FOREIGN KEY (`machine_id`) REFERENCES `assets` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `formula`
--

LOCK TABLES `formula` WRITE;
/*!40000 ALTER TABLE `formula` DISABLE KEYS */;
INSERT INTO `formula` VALUES (1,'(P*Q*90) /100',3),(2,'(P*Q*90) /100',4),(3,'(P*Q*24*90) /100',5),(4,'Q*816/P*95/100',6),(5,'Q*816/P*95/100',7),(6,'Q*816/P*95/100',8),(7,'Q*816/P*95/100',10),(8,'Q*95/100',11),(9,'Q*95/100',9),(10,'Q*95/100',12),(11,'Q*95/100',13),(12,'Q*95/100',14),(13,'Q*95/100',15),(14,'Q*1.9',16),(15,'Q*24*3.8',17),(16,'Q*24*3.8',18),(17,'Q*24*3.8',19),(18,'((P*Q)+(R-S))*60/7000',22),(19,'((R+S+T)*Q)/1000',20),(20,'((R+S+T)*Q)/1000',21);
/*!40000 ALTER TABLE `formula` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `machinecategory`
--

DROP TABLE IF EXISTS `machinecategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `machinecategory` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` varchar(50) NOT NULL,
  `isPartOf_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `machinecategory_isPartOf_id_3f0a4c08_fk_machinecategory_id` (`isPartOf_id`),
  CONSTRAINT `machinecategory_isPartOf_id_3f0a4c08_fk_machinecategory_id` FOREIGN KEY (`isPartOf_id`) REFERENCES `machinecategory` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `machinecategory`
--

LOCK TABLES `machinecategory` WRITE;
/*!40000 ALTER TABLE `machinecategory` DISABLE KEYS */;
/*!40000 ALTER TABLE `machinecategory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mrp_assetfailure`
--

DROP TABLE IF EXISTS `mrp_assetfailure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mrp_assetfailure` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `duration` time(6) NOT NULL,
  `asset_name_id` bigint(20) NOT NULL,
  `failure_name_id` bigint(20) NOT NULL,
  `shift_id` bigint(20) NOT NULL,
  `dayOfIssue` date NOT NULL,
  `timestamp` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mrp_assetfailure_asset_name_id_c2925acd_fk_assets_id` (`asset_name_id`),
  KEY `mrp_assetfailure_failure_name_id_519162f5_fk_failure_id` (`failure_name_id`),
  KEY `mrp_assetfailure_shift_id_b5d785e5_fk_shift_id` (`shift_id`),
  CONSTRAINT `mrp_assetfailure_asset_name_id_c2925acd_fk_assets_id` FOREIGN KEY (`asset_name_id`) REFERENCES `assets` (`id`),
  CONSTRAINT `mrp_assetfailure_failure_name_id_519162f5_fk_failure_id` FOREIGN KEY (`failure_name_id`) REFERENCES `failure` (`id`),
  CONSTRAINT `mrp_assetfailure_shift_id_b5d785e5_fk_shift_id` FOREIGN KEY (`shift_id`) REFERENCES `shift` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mrp_assetfailure`
--

LOCK TABLES `mrp_assetfailure` WRITE;
/*!40000 ALTER TABLE `mrp_assetfailure` DISABLE KEYS */;
INSERT INTO `mrp_assetfailure` VALUES (12,'01:00:00.000000',11,12,2,'2024-01-29','2024-01-29 08:34:31.972121'),(13,'03:00:00.000000',10,12,1,'2024-01-23','2024-01-29 08:37:30.098960');
/*!40000 ALTER TABLE `mrp_assetfailure` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nezafatpadash`
--

DROP TABLE IF EXISTS `nezafatpadash`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nezafatpadash` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `rank` int(11) NOT NULL,
  `price_personnel` decimal(10,2) NOT NULL,
  `description` longtext NOT NULL,
  `price_sarshift` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nezafatpadash`
--

LOCK TABLES `nezafatpadash` WRITE;
/*!40000 ALTER TABLE `nezafatpadash` DISABLE KEYS */;
INSERT INTO `nezafatpadash` VALUES (1,1,50000000.00,'رتبه اول نظافت',80000000.00),(2,2,35000000.00,'رتبه دوم نظافت',60000000.00),(3,3,20000000.00,'رتبه سوم نظافت',40000000.00);
/*!40000 ALTER TABLE `nezafatpadash` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nezafatranking`
--

DROP TABLE IF EXISTS `nezafatranking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nezafatranking` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `rank` int(11) NOT NULL,
  `asset_randeman_list_id` bigint(20) NOT NULL,
  `shift_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `nezafatranking_asset_randeman_list__5722f5aa_fk_assetrand` (`asset_randeman_list_id`),
  KEY `nezafatranking_shift_id_e3755b1c_fk_shift_id` (`shift_id`),
  CONSTRAINT `nezafatranking_asset_randeman_list__5722f5aa_fk_assetrand` FOREIGN KEY (`asset_randeman_list_id`) REFERENCES `assetrandemanlist` (`id`),
  CONSTRAINT `nezafatranking_shift_id_e3755b1c_fk_shift_id` FOREIGN KEY (`shift_id`) REFERENCES `shift` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nezafatranking`
--

LOCK TABLES `nezafatranking` WRITE;
/*!40000 ALTER TABLE `nezafatranking` DISABLE KEYS */;
INSERT INTO `nezafatranking` VALUES (7,2,26,1),(8,3,26,2),(9,1,26,3),(16,1,29,1),(17,2,29,2),(18,3,29,3);
/*!40000 ALTER TABLE `nezafatranking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productionstandard`
--

DROP TABLE IF EXISTS `productionstandard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `productionstandard` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `good_production_rate` int(11) NOT NULL,
  `mean_production_rate` int(11) NOT NULL,
  `bad_production_rate` int(11) NOT NULL,
  `machine_name_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `productionstandard_machine_name_id_df3d2ff2_fk_assets_id` (`machine_name_id`),
  CONSTRAINT `productionstandard_machine_name_id_df3d2ff2_fk_assets_id` FOREIGN KEY (`machine_name_id`) REFERENCES `assets` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productionstandard`
--

LOCK TABLES `productionstandard` WRITE;
/*!40000 ALTER TABLE `productionstandard` DISABLE KEYS */;
INSERT INTO `productionstandard` VALUES (1,8000,7000,7000,3),(2,7000,6000,6000,4),(3,8000,7000,7000,5),(4,1250,1120,1120,6),(5,1250,1120,1120,7),(6,1250,1120,1120,8),(7,1250,1120,1120,10),(8,1800,1600,1600,11),(9,1250,1120,1120,9),(10,1250,1120,1120,12),(11,1250,1120,1120,13),(12,1250,1120,1120,14),(13,1800,1600,1600,15),(14,6600,6000,6000,16),(15,2600,2100,2100,17),(16,2600,2100,2100,18),(17,2600,2100,2100,19),(18,4600,4200,4200,22),(19,1200,1000,1000,20),(20,1200,1000,1000,21);
/*!40000 ALTER TABLE `productionstandard` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shift`
--

DROP TABLE IF EXISTS `shift`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shift` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shift`
--

LOCK TABLES `shift` WRITE;
/*!40000 ALTER TABLE `shift` DISABLE KEYS */;
INSERT INTO `shift` VALUES (1,'زین الدین A'),(2,'فعله گری B'),(3,'ابریشمی C');
/*!40000 ALTER TABLE `shift` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `speedformula`
--

DROP TABLE IF EXISTS `speedformula`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `speedformula` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `formula` varchar(255) NOT NULL,
  `machine_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `machine_id` (`machine_id`),
  CONSTRAINT `speedformula_machine_id_3269048b_fk_assets_id` FOREIGN KEY (`machine_id`) REFERENCES `assets` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `speedformula`
--

LOCK TABLES `speedformula` WRITE;
/*!40000 ALTER TABLE `speedformula` DISABLE KEYS */;
INSERT INTO `speedformula` VALUES (1,'Z*60*8*3*P/1000',3),(2,'Z*60*8*3*P/1000',4),(3,'Z*60*8*3*24*P/1000',5),(4,'Z*60*8*3*816/(P*1000)',6),(5,'Z*60*8*3*816/(P*1000)',7),(6,'Z*60*8*3*816/(P*1000)',8),(7,'Z*60*8*3*816/(P*1000)',10),(8,'(Z*60*8*3*1200)/(1000*21.1)',11),(9,'(Z*60*8*3*28)/(1000*21.1)',9),(10,'(Z*60*8*3*28)/(1000*21.1)',12),(11,'(Z*60*8*3*28)/(1000*21.1)',13),(12,'(Z*60*8*3*28)/(1000*21.1)',14),(13,'(Z*60*8*3*40)/(1000*21.1)',15),(14,'630*60*8*3*60/7000',16),(15,'Z*60*24*191/7000',17),(16,'Z*60*24*191/7000',18),(17,'Z*60*24*191/7000',19),(18,'Z*60*24*60/7000',22),(19,'Z*60*8*3*24/7000',20),(20,'Z*60*8*3*24/7000',21);
/*!40000 ALTER TABLE `speedformula` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sysusers`
--

DROP TABLE IF EXISTS `sysusers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sysusers` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `password` varchar(20) NOT NULL,
  `token` varchar(20) DEFAULT NULL,
  `fullName` varchar(50) NOT NULL,
  `personalCode` varchar(50) NOT NULL,
  `title` varchar(50) DEFAULT NULL,
  `email` varchar(70) DEFAULT NULL,
  `tel1` varchar(50) DEFAULT NULL,
  `tel2` varchar(50) DEFAULT NULL,
  `addr1` varchar(50) DEFAULT NULL,
  `addr2` varchar(50) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `postalCode` varchar(50) DEFAULT NULL,
  `hourlyRate` double DEFAULT NULL,
  `defaultLoginLocation` double DEFAULT NULL,
  `profileImage` varchar(100) NOT NULL,
  `userStatus` tinyint(1) NOT NULL,
  `userId_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `userId_id` (`userId_id`),
  CONSTRAINT `sysusers_userId_id_f6b44698_fk_auth_user_id` FOREIGN KEY (`userId_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sysusers`
--

LOCK TABLES `sysusers` WRITE;
/*!40000 ALTER TABLE `sysusers` DISABLE KEYS */;
/*!40000 ALTER TABLE `sysusers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tolidpadash`
--

DROP TABLE IF EXISTS `tolidpadash`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tolidpadash` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `description` longtext NOT NULL,
  `rank` int(11) NOT NULL,
  `price_sarshift` decimal(10,2) NOT NULL,
  `price_personnel` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tolidpadash`
--

LOCK TABLES `tolidpadash` WRITE;
/*!40000 ALTER TABLE `tolidpadash` DISABLE KEYS */;
INSERT INTO `tolidpadash` VALUES (1,'رتبه اول تولید',1,95000000.00,95000000.00),(2,'رتبه دوم تولید',2,75000000.00,75000000.00),(3,'رتبه سوم تولید',3,55000000.00,55000000.00);
/*!40000 ALTER TABLE `tolidpadash` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tolidranking`
--

DROP TABLE IF EXISTS `tolidranking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tolidranking` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `rank` int(11) NOT NULL,
  `asset_randeman_list_id` bigint(20) NOT NULL,
  `shift_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tolidranking_asset_randeman_list__eaf3b438_fk_assetrand` (`asset_randeman_list_id`),
  KEY `tolidranking_shift_id_c556bbb1_fk_shift_id` (`shift_id`),
  CONSTRAINT `tolidranking_asset_randeman_list__eaf3b438_fk_assetrand` FOREIGN KEY (`asset_randeman_list_id`) REFERENCES `assetrandemanlist` (`id`),
  CONSTRAINT `tolidranking_shift_id_c556bbb1_fk_shift_id` FOREIGN KEY (`shift_id`) REFERENCES `shift` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tolidranking`
--

LOCK TABLES `tolidranking` WRITE;
/*!40000 ALTER TABLE `tolidranking` DISABLE KEYS */;
INSERT INTO `tolidranking` VALUES (7,2,26,1),(8,1,26,2),(9,3,26,3),(16,1,29,1),(17,2,29,2),(18,3,29,3);
/*!40000 ALTER TABLE `tolidranking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zayeat`
--

DROP TABLE IF EXISTS `zayeat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zayeat` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zayeat`
--

LOCK TABLES `zayeat` WRITE;
/*!40000 ALTER TABLE `zayeat` DISABLE KEYS */;
INSERT INTO `zayeat` VALUES (1,'پرز'),(2,'سرنخ');
/*!40000 ALTER TABLE `zayeat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zayeat_assets`
--

DROP TABLE IF EXISTS `zayeat_assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zayeat_assets` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `zayeat_id` bigint(20) NOT NULL,
  `asset_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mrp_zayeat_assets_zayeat_id_asset_id_e84cfd31_uniq` (`zayeat_id`,`asset_id`),
  KEY `mrp_zayeat_assets_asset_id_d73e4418_fk_assets_id` (`asset_id`),
  CONSTRAINT `mrp_zayeat_assets_asset_id_d73e4418_fk_assets_id` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`),
  CONSTRAINT `mrp_zayeat_assets_zayeat_id_697cea95_fk_mrp_zayeat_id` FOREIGN KEY (`zayeat_id`) REFERENCES `zayeat` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zayeat_assets`
--

LOCK TABLES `zayeat_assets` WRITE;
/*!40000 ALTER TABLE `zayeat_assets` DISABLE KEYS */;
INSERT INTO `zayeat_assets` VALUES (1,1,2),(2,2,2);
/*!40000 ALTER TABLE `zayeat_assets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zayeatvazn`
--

DROP TABLE IF EXISTS `zayeatvazn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zayeatvazn` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `vazn` double NOT NULL,
  `zayeat_id` bigint(20) NOT NULL,
  `dayOfIssue` date NOT NULL,
  `shift_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mrp_zayeatvaz_zayeat_id_71c38b28_fk_mrp_zayeat_id` (`zayeat_id`),
  KEY `zayeatvazn_shift_id_76d1507f_fk_shift_id` (`shift_id`),
  CONSTRAINT `mrp_zayeatvaz_zayeat_id_71c38b28_fk_mrp_zayeat_id` FOREIGN KEY (`zayeat_id`) REFERENCES `zayeat` (`id`),
  CONSTRAINT `zayeatvazn_shift_id_76d1507f_fk_shift_id` FOREIGN KEY (`shift_id`) REFERENCES `shift` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zayeatvazn`
--

LOCK TABLES `zayeatvazn` WRITE;
/*!40000 ALTER TABLE `zayeatvazn` DISABLE KEYS */;
INSERT INTO `zayeatvazn` VALUES (7,1,1,'2024-01-21',1),(8,654,2,'2024-01-21',1),(9,22,1,'2024-01-21',2),(10,654,2,'2024-01-21',2),(11,654,1,'2024-01-21',3),(12,654,2,'2024-01-21',3),(13,21,1,'2023-12-19',1),(14,12,2,'2023-12-19',1),(15,21,1,'2023-12-19',2),(16,21,2,'2023-12-19',2),(17,21,1,'2023-12-19',3),(18,21,2,'2023-12-19',3),(19,321,1,'2023-12-18',1),(20,312,2,'2023-12-18',1),(21,312,1,'2023-12-18',2),(22,312,2,'2023-12-18',2),(23,312,1,'2023-12-18',3),(24,321,2,'2023-12-18',3),(25,100,1,'2024-01-25',1),(26,200,2,'2024-01-25',1),(27,100,1,'2024-01-25',2),(28,0,2,'2024-01-25',2),(29,0,1,'2024-01-25',3),(30,0,2,'2024-01-25',3),(31,200,1,'2024-01-25',1),(32,200,2,'2024-01-25',1),(33,100,1,'2024-01-25',2),(34,0,2,'2024-01-25',2),(35,0,1,'2024-01-25',3),(36,0,2,'2024-01-25',3),(37,300,1,'2024-01-25',1),(38,200,2,'2024-01-25',1),(39,100,1,'2024-01-25',2),(40,0,2,'2024-01-25',2),(41,0,1,'2024-01-25',3),(42,0,2,'2024-01-25',3),(43,200,1,'2024-01-25',1),(44,200,2,'2024-01-25',1),(45,100,1,'2024-01-25',2),(46,0,2,'2024-01-25',2),(47,0,1,'2024-01-25',3),(48,0,2,'2024-01-25',3),(49,300,1,'2024-01-25',1),(50,200,2,'2024-01-25',1),(51,100,1,'2024-01-25',2),(52,0,2,'2024-01-25',2),(53,0,1,'2024-01-25',3),(54,0,2,'2024-01-25',3),(55,300,1,'2024-01-25',1),(56,200,2,'2024-01-25',1),(57,100,1,'2024-01-25',2),(58,0,2,'2024-01-25',2),(59,0,1,'2024-01-25',3),(60,0,2,'2024-01-25',3),(61,23,1,'2024-01-22',1),(62,312,2,'2024-01-22',1),(63,312,1,'2024-01-22',2),(64,312,2,'2024-01-22',2),(65,312,1,'2024-01-22',3),(66,312,2,'2024-01-22',3),(67,312,1,'2024-01-23',1),(68,312,2,'2024-01-23',1),(69,312,1,'2024-01-23',2),(70,312,2,'2024-01-23',2),(71,4,1,'2024-01-23',3),(72,4,2,'2024-01-23',3);
/*!40000 ALTER TABLE `zayeatvazn` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-02-05 21:41:42
