-- MariaDB dump 10.18  Distrib 10.4.17-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: kth_mrp
-- ------------------------------------------------------
-- Server version	10.4.17-MariaDB

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
  `name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `code` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `description` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `priority` int(11) DEFAULT NULL,
  `isPartOf_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `assetcategory_isPartOf_id_114f99d9_fk_assetcategory_id` (`isPartOf_id`),
  CONSTRAINT `assetcategory_isPartOf_id_114f99d9_fk_assetcategory_id` FOREIGN KEY (`isPartOf_id`) REFERENCES `assetcategory` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assetcategory`
--

LOCK TABLES `assetcategory` WRITE;
/*!40000 ALTER TABLE `assetcategory` DISABLE KEYS */;
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
  `profile_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `assetrandemaninit_asset_category_id_5ebcf7b2_fk_assetcategory_id` (`asset_category_id`),
  KEY `assetrandemaninit_profile_id_4ceda952_fk_financialprofile_id` (`profile_id`),
  CONSTRAINT `assetrandemaninit_asset_category_id_5ebcf7b2_fk_assetcategory_id` FOREIGN KEY (`asset_category_id`) REFERENCES `assetcategory` (`id`),
  CONSTRAINT `assetrandemaninit_profile_id_4ceda952_fk_financialprofile_id` FOREIGN KEY (`profile_id`) REFERENCES `financialprofile` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assetrandemaninit`
--

LOCK TABLES `assetrandemaninit` WRITE;
/*!40000 ALTER TABLE `assetrandemaninit` DISABLE KEYS */;
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
  `profile_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `assetrandemanlist_mah_sal_7802a2e4_uniq` (`mah`,`sal`),
  KEY `assetrandemanlist_profile_id_b5335d76_fk_financialprofile_id` (`profile_id`),
  CONSTRAINT `assetrandemanlist_profile_id_b5335d76_fk_financialprofile_id` FOREIGN KEY (`profile_id`) REFERENCES `financialprofile` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assetrandemanlist`
--

LOCK TABLES `assetrandemanlist` WRITE;
/*!40000 ALTER TABLE `assetrandemanlist` DISABLE KEYS */;
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
  `tolid_value` decimal(15,2) NOT NULL,
  `asset_category_id` bigint(20) NOT NULL,
  `shift_id` bigint(20) NOT NULL,
  `asset_randeman_list_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `assetrandemanpermont_asset_category_id_cc9b6e91_fk_assetcate` (`asset_category_id`),
  KEY `assetrandemanpermonth_shift_id_4a7979c4_fk_shift_id` (`shift_id`),
  KEY `assetrandemanpermont_asset_randeman_list__e204a2d4_fk_assetrand` (`asset_randeman_list_id`),
  CONSTRAINT `assetrandemanpermont_asset_category_id_cc9b6e91_fk_assetcate` FOREIGN KEY (`asset_category_id`) REFERENCES `assetcategory` (`id`),
  CONSTRAINT `assetrandemanpermont_asset_randeman_list__e204a2d4_fk_assetrand` FOREIGN KEY (`asset_randeman_list_id`) REFERENCES `assetrandemanlist` (`id`),
  CONSTRAINT `assetrandemanpermonth_shift_id_4a7979c4_fk_shift_id` FOREIGN KEY (`shift_id`) REFERENCES `shift` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assetrandemanpermonth`
--

LOCK TABLES `assetrandemanpermonth` WRITE;
/*!40000 ALTER TABLE `assetrandemanpermonth` DISABLE KEYS */;
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
  `assetName` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `assetDescription` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `assetCode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `assetAddress` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `assetCity` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `assetState` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `assetZipcode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `assetCountry` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `assetAccount` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `assetChargeDepartment` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `assetNotes` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `assetBarcode` int(11) DEFAULT NULL,
  `assetHasPartOf` tinyint(1) NOT NULL,
  `assetAisel` int(11) DEFAULT NULL,
  `assetRow` int(11) DEFAULT NULL,
  `assetBin` int(11) DEFAULT NULL,
  `assetManufacture` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `assetModel` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `assetSerialNumber` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `assetStatus` tinyint(1) NOT NULL,
  `assetIsStock` tinyint(1) NOT NULL,
  `assetTavali` int(11) DEFAULT NULL,
  `assetCategory_id` bigint(20) DEFAULT NULL,
  `assetIsLocatedAt_id` bigint(20) DEFAULT NULL,
  `assetIsPartOf_id` bigint(20) DEFAULT NULL,
  `assetMachineCategory_id` bigint(20) DEFAULT NULL,
  `assetVahed` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `assets_assetCategory_id_c2ac8995_fk_assetcategory_id` (`assetCategory_id`),
  KEY `assets_assetIsLocatedAt_id_5d718c44_fk_assets_id` (`assetIsLocatedAt_id`),
  KEY `assets_assetIsPartOf_id_c24c9bca_fk_assets_id` (`assetIsPartOf_id`),
  KEY `assets_assetMachineCategory_id_29b0595a_fk_machinecategory_id` (`assetMachineCategory_id`),
  CONSTRAINT `assets_assetCategory_id_c2ac8995_fk_assetcategory_id` FOREIGN KEY (`assetCategory_id`) REFERENCES `assetcategory` (`id`),
  CONSTRAINT `assets_assetIsLocatedAt_id_5d718c44_fk_assets_id` FOREIGN KEY (`assetIsLocatedAt_id`) REFERENCES `assets` (`id`),
  CONSTRAINT `assets_assetIsPartOf_id_c24c9bca_fk_assets_id` FOREIGN KEY (`assetIsPartOf_id`) REFERENCES `assets` (`id`),
  CONSTRAINT `assets_assetMachineCategory_id_29b0595a_fk_machinecategory_id` FOREIGN KEY (`assetMachineCategory_id`) REFERENCES `machinecategory` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assets`
--

LOCK TABLES `assets` WRITE;
/*!40000 ALTER TABLE `assets` DISABLE KEYS */;
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
  `name` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
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
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add asset category',7,'add_assetcategory'),(26,'Can change asset category',7,'change_assetcategory'),(27,'Can delete asset category',7,'delete_assetcategory'),(28,'Can view asset category',7,'view_assetcategory'),(29,'Can add machine category',8,'add_machinecategory'),(30,'Can change machine category',8,'change_machinecategory'),(31,'Can delete machine category',8,'delete_machinecategory'),(32,'Can view machine category',8,'view_machinecategory'),(33,'Can add asset',9,'add_asset'),(34,'Can change asset',9,'change_asset'),(35,'Can delete asset',9,'delete_asset'),(36,'Can view asset',9,'view_asset'),(37,'Can add formula',10,'add_formula'),(38,'Can change formula',10,'change_formula'),(39,'Can delete formula',10,'delete_formula'),(40,'Can view formula',10,'view_formula'),(41,'Can add daily production',11,'add_dailyproduction'),(42,'Can change daily production',11,'change_dailyproduction'),(43,'Can delete daily production',11,'delete_dailyproduction'),(44,'Can view daily production',11,'view_dailyproduction'),(45,'Can add sys user',12,'add_sysuser'),(46,'Can change sys user',12,'change_sysuser'),(47,'Can delete sys user',12,'delete_sysuser'),(48,'Can view sys user',12,'view_sysuser'),(49,'can view dashboard',12,'can_view_dashboard'),(50,'Can add shift',13,'add_shift'),(51,'Can change shift',13,'change_shift'),(52,'Can delete shift',13,'delete_shift'),(53,'Can view shift',13,'view_shift'),(54,'Can add speed formula',14,'add_speedformula'),(55,'Can change speed formula',14,'change_speedformula'),(56,'Can delete speed formula',14,'delete_speedformula'),(57,'Can view speed formula',14,'view_speedformula'),(58,'Can add production standard',15,'add_productionstandard'),(59,'Can change production standard',15,'change_productionstandard'),(60,'Can delete production standard',15,'delete_productionstandard'),(61,'Can view production standard',15,'view_productionstandard'),(62,'Can add zayeat',16,'add_zayeat'),(63,'Can change zayeat',16,'change_zayeat'),(64,'Can delete zayeat',16,'delete_zayeat'),(65,'Can view zayeat',16,'view_zayeat'),(66,'Can add zayeat vaz',17,'add_zayeatvaz'),(67,'Can change zayeat vaz',17,'change_zayeatvaz'),(68,'Can delete zayeat vaz',17,'delete_zayeatvaz'),(69,'Can view zayeat vaz',17,'view_zayeatvaz'),(70,'Can add failure',18,'add_failure'),(71,'Can change failure',18,'change_failure'),(72,'Can delete failure',18,'delete_failure'),(73,'Can view failure',18,'view_failure'),(74,'Can add asset failure',19,'add_assetfailure'),(75,'Can change asset failure',19,'change_assetfailure'),(76,'Can delete asset failure',19,'delete_assetfailure'),(77,'Can view asset failure',19,'view_assetfailure'),(78,'Can add asset randeman init',20,'add_assetrandemaninit'),(79,'Can change asset randeman init',20,'change_assetrandemaninit'),(80,'Can delete asset randeman init',20,'delete_assetrandemaninit'),(81,'Can view asset randeman init',20,'view_assetrandemaninit'),(82,'Can add asset randeman per month',21,'add_assetrandemanpermonth'),(83,'Can change asset randeman per month',21,'change_assetrandemanpermonth'),(84,'Can delete asset randeman per month',21,'delete_assetrandemanpermonth'),(85,'Can view asset randeman per month',21,'view_assetrandemanpermonth'),(86,'Can add asset randeman list',22,'add_assetrandemanlist'),(87,'Can change asset randeman list',22,'change_assetrandemanlist'),(88,'Can delete asset randeman list',22,'delete_assetrandemanlist'),(89,'Can view asset randeman list',22,'view_assetrandemanlist'),(90,'Can add nezafat padash',23,'add_nezafatpadash'),(91,'Can change nezafat padash',23,'change_nezafatpadash'),(92,'Can delete nezafat padash',23,'delete_nezafatpadash'),(93,'Can view nezafat padash',23,'view_nezafatpadash'),(94,'Can add nezafat ranking',24,'add_nezafatranking'),(95,'Can change nezafat ranking',24,'change_nezafatranking'),(96,'Can delete nezafat ranking',24,'delete_nezafatranking'),(97,'Can view nezafat ranking',24,'view_nezafatranking'),(98,'Can add tolid padash',25,'add_tolidpadash'),(99,'Can change tolid padash',25,'change_tolidpadash'),(100,'Can delete tolid padash',25,'delete_tolidpadash'),(101,'Can view tolid padash',25,'view_tolidpadash'),(102,'Can add tolid ranking',26,'add_tolidranking'),(103,'Can change tolid ranking',26,'change_tolidranking'),(104,'Can delete tolid ranking',26,'delete_tolidranking'),(105,'Can view tolid ranking',26,'view_tolidranking'),(106,'Can add financial profile',27,'add_financialprofile'),(107,'Can change financial profile',27,'change_financialprofile'),(108,'Can delete financial profile',27,'delete_financialprofile'),(109,'Can view financial profile',27,'view_financialprofile');
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
  `password` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `first_name` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `last_name` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(254) COLLATE utf8_unicode_ci NOT NULL,
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
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$260000$86p8gwwYT8d73pd0u95Qr6$6dyyC2qKVpHl1lRJLbUcOtse7Bwi1+DqQWMhr4lvemQ=','2024-11-18 15:52:55.787979',1,'admin','','','ad@admin.com',1,1,'2024-11-18 15:52:34.569503');
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
  `register_user` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `nomre` double NOT NULL,
  `counter1` double NOT NULL,
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
  `vahed` double NOT NULL,
  `counter2` double NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dailyproduction_machine_id_shift_id_dayOfIssue_e9a55b55_uniq` (`machine_id`,`shift_id`,`dayOfIssue`),
  KEY `dailyproduction_shift_id_b0e36c70_fk_shift_id` (`shift_id`),
  CONSTRAINT `dailyproduction_machine_id_3581c565_fk_assets_id` FOREIGN KEY (`machine_id`) REFERENCES `assets` (`id`),
  CONSTRAINT `dailyproduction_shift_id_b0e36c70_fk_shift_id` FOREIGN KEY (`shift_id`) REFERENCES `shift` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dailyproduction`
--

LOCK TABLES `dailyproduction` WRITE;
/*!40000 ALTER TABLE `dailyproduction` DISABLE KEYS */;
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
  `object_id` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `object_repr` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext COLLATE utf8_unicode_ci NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
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
  `app_label` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `model` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(9,'mrp','asset'),(7,'mrp','assetcategory'),(19,'mrp','assetfailure'),(20,'mrp','assetrandemaninit'),(22,'mrp','assetrandemanlist'),(21,'mrp','assetrandemanpermonth'),(11,'mrp','dailyproduction'),(18,'mrp','failure'),(27,'mrp','financialprofile'),(10,'mrp','formula'),(8,'mrp','machinecategory'),(23,'mrp','nezafatpadash'),(24,'mrp','nezafatranking'),(15,'mrp','productionstandard'),(13,'mrp','shift'),(14,'mrp','speedformula'),(12,'mrp','sysuser'),(25,'mrp','tolidpadash'),(26,'mrp','tolidranking'),(16,'mrp','zayeat'),(17,'mrp','zayeatvaz'),(6,'sessions','session');
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
  `app` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2024-11-18 15:51:37.673888'),(2,'auth','0001_initial','2024-11-18 15:51:38.627730'),(3,'admin','0001_initial','2024-11-18 15:51:38.858477'),(4,'admin','0002_logentry_remove_auto_add','2024-11-18 15:51:38.866977'),(5,'admin','0003_logentry_add_action_flag_choices','2024-11-18 15:51:38.876951'),(6,'contenttypes','0002_remove_content_type_name','2024-11-18 15:51:38.961866'),(7,'auth','0002_alter_permission_name_max_length','2024-11-18 15:51:39.055620'),(8,'auth','0003_alter_user_email_max_length','2024-11-18 15:51:39.151006'),(9,'auth','0004_alter_user_username_opts','2024-11-18 15:51:39.166628'),(10,'auth','0005_alter_user_last_login_null','2024-11-18 15:51:39.230286'),(11,'auth','0006_require_contenttypes_0002','2024-11-18 15:51:39.230286'),(12,'auth','0007_alter_validators_add_error_messages','2024-11-18 15:51:39.245909'),(13,'auth','0008_alter_user_username_max_length','2024-11-18 15:51:39.261534'),(14,'auth','0009_alter_user_last_name_max_length','2024-11-18 15:51:39.277149'),(15,'auth','0010_alter_group_name_max_length','2024-11-18 15:51:39.370877'),(16,'auth','0011_update_proxy_permissions','2024-11-18 15:51:39.386528'),(17,'auth','0012_alter_user_first_name_max_length','2024-11-18 15:51:39.417743'),(18,'mrp','0001_initial','2024-11-18 15:51:39.657502'),(19,'mrp','0002_asset_machinecategory','2024-11-18 15:51:40.170479'),(20,'mrp','0003_dailyproduction_formula','2024-11-18 15:51:40.423997'),(21,'mrp','0004_dailyproduction_speed','2024-11-18 15:51:40.439589'),(22,'mrp','0005_sysuser','2024-11-18 15:51:40.670132'),(23,'mrp','0006_auto_20231202_2059','2024-11-18 15:51:40.810724'),(24,'mrp','0007_remove_dailyproduction_shift','2024-11-18 15:51:40.857588'),(25,'mrp','0008_dailyproduction_shift','2024-11-18 15:51:40.951316'),(26,'mrp','0009_remove_dailyproduction_shift','2024-11-18 15:51:41.013807'),(27,'mrp','0010_dailyproduction_shift','2024-11-18 15:51:41.123152'),(28,'mrp','0011_speedformula','2024-11-18 15:51:41.264955'),(29,'mrp','0012_delete_speedformula','2024-11-18 15:51:41.280578'),(30,'mrp','0013_speedformula','2024-11-18 15:51:41.405546'),(31,'mrp','0014_delete_speedformula','2024-11-18 15:51:41.421167'),(32,'mrp','0015_speedformula','2024-11-18 15:51:41.546139'),(33,'mrp','0016_auto_20231205_0937','2024-11-18 15:51:41.702352'),(34,'mrp','0017_productionstandard','2024-11-18 15:51:41.842944'),(35,'mrp','0018_zayeat_zayeatvaz','2024-11-18 15:51:42.203335'),(36,'mrp','0019_auto_20231218_1228','2024-11-18 15:51:42.265819'),(37,'mrp','0020_zayeatvaz_dayofissue','2024-11-18 15:51:42.281446'),(38,'mrp','0021_zayeatvaz_shift','2024-11-18 15:51:42.375170'),(39,'mrp','0022_assetfailure_failure','2024-11-18 15:51:42.847181'),(40,'mrp','0023_auto_20231231_1318','2024-11-18 15:51:42.894045'),(41,'mrp','0024_auto_20240109_1354','2024-11-18 15:51:43.065881'),(42,'mrp','0025_assetrandemanpermonth','2024-11-18 15:51:43.301315'),(43,'mrp','0026_assetrandemanlist','2024-11-18 15:51:43.332562'),(44,'mrp','0027_auto_20240112_1534','2024-11-18 15:51:43.473150'),(45,'mrp','0028_auto_20240117_1052','2024-11-18 15:51:43.629362'),(46,'mrp','0029_auto_20240122_1121','2024-11-18 15:51:43.926168'),(47,'mrp','0030_auto_20240122_1142','2024-11-18 15:51:44.209610'),(48,'mrp','0031_auto_20240129_1627','2024-11-18 15:51:44.318987'),(49,'mrp','0032_alter_dailyproduction_unique_together','2024-11-18 15:51:44.363859'),(50,'mrp','0033_alter_assetfailure_unique_together','2024-11-18 15:51:44.410723'),(51,'mrp','0034_auto_20240321_0924','2024-11-18 15:51:44.613800'),(52,'mrp','0035_auto_20240321_0942','2024-11-18 15:51:45.053320'),(53,'mrp','0036_auto_20240321_0944','2024-11-18 15:51:45.441716'),(54,'mrp','0037_auto_20240321_0951','2024-11-18 15:51:45.535445'),(55,'mrp','0038_nezafatpadash_asset_randeman_list','2024-11-18 15:51:45.629171'),(56,'mrp','0039_auto_20240321_0952','2024-11-18 15:51:45.769763'),(57,'mrp','0040_remove_tolidpadash_asset_randeman_list','2024-11-18 15:51:45.832249'),(58,'mrp','0041_tolidpadash_asset_randeman_list','2024-11-18 15:51:45.988462'),(59,'mrp','0042_nezafatpadash_asset_randeman_list','2024-11-18 15:51:46.097811'),(60,'mrp','0043_auto_20240321_1028','2024-11-18 15:51:46.144675'),(61,'mrp','0044_auto_20240321_1031','2024-11-18 15:51:46.192649'),(62,'mrp','0045_auto_20240321_1327','2024-11-18 15:51:46.270748'),(63,'mrp','0046_auto_20240321_1328','2024-11-18 15:51:46.348883'),(64,'mrp','0047_auto_20240327_1340','2024-11-18 15:51:46.501986'),(65,'mrp','0048_auto_20240329_1405','2024-11-18 15:51:46.970625'),(66,'mrp','0049_auto_20240329_1406','2024-11-18 15:51:47.456012'),(67,'mrp','0050_auto_20240329_1406','2024-11-18 15:51:48.018379'),(68,'mrp','0051_auto_20240329_2110','2024-11-18 15:51:48.065243'),(69,'mrp','0052_auto_20240329_2229','2024-11-18 15:51:48.238203'),(70,'mrp','0053_auto_20240329_2326','2024-11-18 15:51:48.441249'),(71,'mrp','0054_auto_20240330_1029','2024-11-18 15:51:48.488144'),(72,'mrp','0055_auto_20240331_0023','2024-11-18 15:51:48.675570'),(73,'mrp','0056_auto_20240412_1834','2024-11-18 15:51:48.722434'),(74,'mrp','0057_auto_20240412_1842','2024-11-18 15:51:48.784919'),(75,'mrp','0058_financialprofile_tolid_randeman_mazrab_3','2024-11-18 15:51:48.816161'),(76,'mrp','0059_alter_sysuser_options','2024-11-18 15:51:48.831783'),(77,'mrp','0060_failure_is_it_count','2024-11-18 15:51:48.863029'),(78,'mrp','0061_alter_failure_is_it_count','2024-11-18 15:51:48.941132'),(79,'mrp','0062_alter_failure_is_it_count','2024-11-18 15:51:48.956753'),(80,'mrp','0063_auto_20240529_2018','2024-11-18 15:51:49.200301'),(81,'mrp','0064_alter_assetrandemanpermonth_tolid_value','2024-11-18 15:51:49.325272'),(82,'mrp','0065_asset_assetvahed','2024-11-18 15:51:49.356516'),(83,'mrp','0066_dailyproduction_vahed','2024-11-18 15:51:49.419000'),(84,'mrp','0067_auto_20241019_1910','2024-11-18 15:51:49.465863'),(85,'mrp','0068_zayeatvaz_makan','2024-11-18 15:51:49.588308'),(86,'sessions','0001_initial','2024-11-18 15:51:49.657122');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `session_data` longtext COLLATE utf8_unicode_ci NOT NULL,
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
INSERT INTO `django_session` VALUES ('767euj2rkba92hg5tvfbmrh3xjelaiag','.eJxVjDkOwjAURO_iGlmJdyjpOYP1FxsHkC3FSYW4O4mUAqSp5r2Zt4iwLiWuPc1xYnERozj9dgj0THUH_IB6b5JaXeYJ5a7Ig3Z5a5xe18P9OyjQy7bWdmRghoxgiUANCWzwmAIFPKfMziirjUe0TlPYgoyDAgOeOTjM4vMFIyo5eA:1tD43b:J6sXDMwIHYHXDCtlBJaC1i0qh5dMrat4txCmkHyQkh0','2024-12-02 15:52:55.787979');
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
  `code` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `is_it_count` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failure`
--

LOCK TABLES `failure` WRITE;
/*!40000 ALTER TABLE `failure` DISABLE KEYS */;
/*!40000 ALTER TABLE `failure` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `financialprofile`
--

DROP TABLE IF EXISTS `financialprofile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `financialprofile` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `description` longtext COLLATE utf8_unicode_ci NOT NULL,
  `time_created` datetime(6) NOT NULL,
  `mablagh_kol_randeman` decimal(10,0) NOT NULL,
  `tolid_randeman` decimal(10,0) NOT NULL,
  `tolid_randeman_mazrab_3` decimal(10,0) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `financialprofile`
--

LOCK TABLES `financialprofile` WRITE;
/*!40000 ALTER TABLE `financialprofile` DISABLE KEYS */;
/*!40000 ALTER TABLE `financialprofile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `formula`
--

DROP TABLE IF EXISTS `formula`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `formula` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `formula` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `machine_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `machine_id` (`machine_id`),
  CONSTRAINT `formula_machine_id_bc181d55_fk_assets_id` FOREIGN KEY (`machine_id`) REFERENCES `assets` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `formula`
--

LOCK TABLES `formula` WRITE;
/*!40000 ALTER TABLE `formula` DISABLE KEYS */;
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
  `name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `description` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
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
  UNIQUE KEY `mrp_assetfailure_asset_name_id_shift_id_f_cd2a2ae3_uniq` (`asset_name_id`,`shift_id`,`failure_name_id`,`dayOfIssue`),
  KEY `mrp_assetfailure_failure_name_id_519162f5_fk_failure_id` (`failure_name_id`),
  KEY `mrp_assetfailure_shift_id_b5d785e5_fk_shift_id` (`shift_id`),
  CONSTRAINT `mrp_assetfailure_asset_name_id_c2925acd_fk_assets_id` FOREIGN KEY (`asset_name_id`) REFERENCES `assets` (`id`),
  CONSTRAINT `mrp_assetfailure_failure_name_id_519162f5_fk_failure_id` FOREIGN KEY (`failure_name_id`) REFERENCES `failure` (`id`),
  CONSTRAINT `mrp_assetfailure_shift_id_b5d785e5_fk_shift_id` FOREIGN KEY (`shift_id`) REFERENCES `shift` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mrp_assetfailure`
--

LOCK TABLES `mrp_assetfailure` WRITE;
/*!40000 ALTER TABLE `mrp_assetfailure` DISABLE KEYS */;
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
  `price_personnel` decimal(10,0) NOT NULL,
  `description` longtext COLLATE utf8_unicode_ci NOT NULL,
  `price_sarshift` decimal(10,0) NOT NULL,
  `profile_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nezafatpadash_profile_id_73222534_fk_financialprofile_id` (`profile_id`),
  CONSTRAINT `nezafatpadash_profile_id_73222534_fk_financialprofile_id` FOREIGN KEY (`profile_id`) REFERENCES `financialprofile` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nezafatpadash`
--

LOCK TABLES `nezafatpadash` WRITE;
/*!40000 ALTER TABLE `nezafatpadash` DISABLE KEYS */;
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
  `price_personnel` decimal(10,0) NOT NULL,
  `price_sarshift` decimal(10,0) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `nezafatranking_asset_randeman_list__5722f5aa_fk_assetrand` (`asset_randeman_list_id`),
  KEY `nezafatranking_shift_id_e3755b1c_fk_shift_id` (`shift_id`),
  CONSTRAINT `nezafatranking_asset_randeman_list__5722f5aa_fk_assetrand` FOREIGN KEY (`asset_randeman_list_id`) REFERENCES `assetrandemanlist` (`id`),
  CONSTRAINT `nezafatranking_shift_id_e3755b1c_fk_shift_id` FOREIGN KEY (`shift_id`) REFERENCES `shift` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nezafatranking`
--

LOCK TABLES `nezafatranking` WRITE;
/*!40000 ALTER TABLE `nezafatranking` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productionstandard`
--

LOCK TABLES `productionstandard` WRITE;
/*!40000 ALTER TABLE `productionstandard` DISABLE KEYS */;
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
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shift`
--

LOCK TABLES `shift` WRITE;
/*!40000 ALTER TABLE `shift` DISABLE KEYS */;
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
  `formula` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `machine_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `machine_id` (`machine_id`),
  CONSTRAINT `speedformula_machine_id_3269048b_fk_assets_id` FOREIGN KEY (`machine_id`) REFERENCES `assets` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `speedformula`
--

LOCK TABLES `speedformula` WRITE;
/*!40000 ALTER TABLE `speedformula` DISABLE KEYS */;
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
  `password` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `token` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fullName` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `personalCode` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `title` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(70) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tel1` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tel2` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `addr1` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `addr2` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `postalCode` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `hourlyRate` double DEFAULT NULL,
  `defaultLoginLocation` double DEFAULT NULL,
  `profileImage` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
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
  `description` longtext COLLATE utf8_unicode_ci NOT NULL,
  `rank` int(11) NOT NULL,
  `price_sarshift` decimal(10,0) NOT NULL,
  `price_personnel` decimal(10,0) NOT NULL,
  `profile_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tolidpadash_profile_id_9fd627e7_fk_financialprofile_id` (`profile_id`),
  CONSTRAINT `tolidpadash_profile_id_9fd627e7_fk_financialprofile_id` FOREIGN KEY (`profile_id`) REFERENCES `financialprofile` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tolidpadash`
--

LOCK TABLES `tolidpadash` WRITE;
/*!40000 ALTER TABLE `tolidpadash` DISABLE KEYS */;
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
  `price_personnel` decimal(10,0) NOT NULL,
  `price_sarshift` decimal(10,0) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tolidranking_asset_randeman_list__eaf3b438_fk_assetrand` (`asset_randeman_list_id`),
  KEY `tolidranking_shift_id_c556bbb1_fk_shift_id` (`shift_id`),
  CONSTRAINT `tolidranking_asset_randeman_list__eaf3b438_fk_assetrand` FOREIGN KEY (`asset_randeman_list_id`) REFERENCES `assetrandemanlist` (`id`),
  CONSTRAINT `tolidranking_shift_id_c556bbb1_fk_shift_id` FOREIGN KEY (`shift_id`) REFERENCES `shift` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tolidranking`
--

LOCK TABLES `tolidranking` WRITE;
/*!40000 ALTER TABLE `tolidranking` DISABLE KEYS */;
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
  `name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zayeat`
--

LOCK TABLES `zayeat` WRITE;
/*!40000 ALTER TABLE `zayeat` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zayeat_assets`
--

LOCK TABLES `zayeat_assets` WRITE;
/*!40000 ALTER TABLE `zayeat_assets` DISABLE KEYS */;
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
  `makan_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mrp_zayeatvaz_zayeat_id_71c38b28_fk_mrp_zayeat_id` (`zayeat_id`),
  KEY `zayeatvazn_shift_id_76d1507f_fk_shift_id` (`shift_id`),
  KEY `zayeatvazn_makan_id_917e4298_fk_assets_id` (`makan_id`),
  CONSTRAINT `mrp_zayeatvaz_zayeat_id_71c38b28_fk_mrp_zayeat_id` FOREIGN KEY (`zayeat_id`) REFERENCES `zayeat` (`id`),
  CONSTRAINT `zayeatvazn_makan_id_917e4298_fk_assets_id` FOREIGN KEY (`makan_id`) REFERENCES `assets` (`id`),
  CONSTRAINT `zayeatvazn_shift_id_76d1507f_fk_shift_id` FOREIGN KEY (`shift_id`) REFERENCES `shift` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zayeatvazn`
--

LOCK TABLES `zayeatvazn` WRITE;
/*!40000 ALTER TABLE `zayeatvazn` DISABLE KEYS */;
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

-- Dump completed on 2024-11-18 19:54:02
