-- MariaDB dump 10.19  Distrib 10.4.28-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: kth_mrp
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
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assetcategory`
--

LOCK TABLES `assetcategory` WRITE;
/*!40000 ALTER TABLE `assetcategory` DISABLE KEYS */;
INSERT INTO `assetcategory` VALUES (1,'سایدل','','',2,NULL),(2,'پاساژ','','',3,NULL),(3,'فینیشر','','',4,NULL),(4,'رینگ','','',5,NULL),(5,'اتوکنر','','',6,NULL),(6,'لاکنی','','',7,NULL),(7,'دولاتاب','','',8,NULL),(9,'ریبریکر','','',1,NULL);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=7254 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assets`
--

LOCK TABLES `assets` WRITE;
/*!40000 ALTER TABLE `assets` DISABLE KEYS */;
INSERT INTO `assets` VALUES (6942,1,'خط 2','خط2','ln2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,NULL,NULL,NULL,NULL,NULL,NULL),(6943,2,'رینگ2 / خط2','رینگ2 / خط2','ln2-T.M-ring2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,2,4,6942,NULL,NULL,NULL),(6961,1,'خط 4','خط 4','ln4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,NULL,NULL,NULL,NULL,NULL,1),(6993,3,'رینگ1(zinser 420) / خط4','رینگ1(zinser 420) / خط4 \r\n700 اسپیندل','ln4-T.M-ring1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'zinser 420',NULL,1,0,1,4,6961,NULL,NULL,700),(6994,3,'رینگ2(zinser 420) / خط4','رینگ2(zinser 420) / خط4 \r\n700 اسپیندل','ln4-T.M-ring2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'zinser 420',NULL,1,0,2,4,6961,NULL,NULL,700),(6995,3,'رینگ3(zinser 420) / خط4','رینگ3(zinser 420) / خط4\r\n700 اسپیندل','ln4-T.M-ring3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'zinser 420',NULL,1,0,3,4,6961,NULL,NULL,700),(6997,3,'رینگ4(zinser 420) / خط4','رینگ4(zinser 420) / خط4\r\n700 اسپیندل','ln4-T.M-ring4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'zinser 420',NULL,1,0,4,4,6961,NULL,NULL,700),(6999,3,'رینگ5(zinser 420) / خط4','رینگ5(zinser 420) / خط4\r\n700 اسپیندل','ln4-T.M-ring5',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'zinser 420',NULL,1,0,5,4,6961,NULL,NULL,700),(7001,3,'رینگ6(zinser 420) / خط4','رینگ6(zinser 420) / خط4\r\n700 اسپیندل','ln4-T.M-ring6',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'zinser 420',NULL,1,0,6,4,6961,NULL,NULL,700),(7003,3,'رینگ7(zinser 420) / خط4','رینگ7(zinser 420) / خط4 \r\n700 اسپیندل','ln4-T.M-ring7',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'zinser 420',NULL,1,0,7,4,6961,NULL,NULL,700),(7005,3,'رینگ8(zinser 319sl) / خط4','رینگ8(zinser 319sl) / خط4\r\n820 اسپیندل','ln4-T.M-ring8',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'zinser 319sl',NULL,1,0,8,4,6961,NULL,NULL,820),(7007,3,'رینگ9(zinser 319sl) / خط4','رینگ9(zinser 319sl) / خط4\r\n820 اسپیندل','ln4-T.M-ring9',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'zinser 319sl',NULL,1,0,9,4,6961,NULL,NULL,820),(7009,3,'رینگ10(zinser 319sl) / خط4','رینگ10(zinser 319sl) / خط4 \r\n820 اسپیندل','ln4-T.M-ring10',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'zinser 319sl',NULL,1,0,10,4,6961,NULL,NULL,820),(7032,2,'رینگ3 / خط2','رینگ3 / خط2','ln2-T.M-ring3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,3,4,6942,NULL,NULL,NULL),(7033,2,'رینگ4 / خط2','رینگ4 / خط2','ln2-T.M-ring4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,4,4,6942,NULL,NULL,NULL),(7034,2,'رینگ5 / خط2','رینگ5 / خط2','ln2-T.M-ring5',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,5,4,6942,NULL,NULL,NULL),(7035,2,'رینگ6 / خط2','رینگ6 / خط2','ln2-T.M-ring6',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,6,4,6942,NULL,NULL,NULL),(7036,2,'رینگ7 / خط2','رینگ7 / خط2','ln2-T.M-ring7',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,7,4,6942,NULL,NULL,NULL),(7037,2,'رینگ8 / خط2','رینگ8 / خط2','ln2-T.M-ring8',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,8,4,6942,NULL,NULL,NULL),(7038,2,'رینگ9 / خط2','رینگ9 / خط2','ln2-T.M-ring9',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,9,4,6942,NULL,NULL,NULL),(7039,2,'رینگ10 / خط2','رینگ10 / خط2','ln2-T.M-ring10',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,10,4,6942,NULL,NULL,NULL),(7040,2,'رینگ11 / خط2','رینگ11 / خط2','ln2-T.M-ring11',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,11,4,6942,NULL,NULL,NULL),(7041,2,'رینگ12 / خط2','رینگ12 / خط2','ln2-T.M-ring12',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,12,4,6942,NULL,NULL,NULL),(7042,2,'رینگ13 / خط2','رینگ13 / خط2','ln2-T.M-ring13',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,13,4,6942,NULL,NULL,NULL),(7043,2,'رینگ14 / خط2','رینگ14 / خط2','ln2-T.M-ring14',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,14,4,6942,NULL,NULL,NULL),(7044,2,'رینگ15 / خط2','رینگ15 / خط2','ln2-T.M-ring15',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'zinser319sl',NULL,1,0,15,4,6942,NULL,NULL,NULL),(7047,3,'رینگ11(zinser 319sl) / خط4','رینگ11(zinser 319sl) / خط4\r\n820 اسپیندل','ln4-T.M-ring11',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'zinser 319sl',NULL,1,0,11,4,6961,NULL,NULL,820),(7048,3,'رینگ12(zinser 319sl) / خط4','رینگ12(zinser 319sl) / خط4\r\n820 اسپیندل','ln4-T.M-ring12',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'zinser 319sl',NULL,1,0,12,4,6961,NULL,NULL,820),(7049,3,'رینگ13(zinser 319sl) / خط4','رینگ13(zinser 319sl) / خط4\r\n820 اسپیندل','ln4-T.M-ring13',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'zinser 319sl',NULL,1,0,13,4,6961,NULL,NULL,820),(7050,3,'رینگ14(zinser 319sl) / خط4','رینگ14(zinser 319sl) / خط4 \r\n820 اسپیندل','ln4-T.M-ring14',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'zinser 319sl',NULL,1,0,14,4,6961,NULL,NULL,820),(7052,3,'تاپس(SEYDEL 679_L) / خط4','تاپس(SEYDEL 679_L) / خط4','ln4-mgm-1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'(SEYDEL 679_L)',NULL,1,0,1,1,6961,NULL,NULL,1),(7053,3,'ریبریکر(NSC) / خط4','ریبریکر(NSC) / خط4','ln4-mgm-2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'NSC',NULL,1,0,1,9,6961,NULL,NULL,1),(7054,3,'پاساژ1(NSC jc-12) / خط4','پاساژ1(NSC jc-12) / خط4','1-ln4-mgm-3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'NSC jc12',NULL,1,0,1,2,6961,NULL,NULL,1),(7055,3,'فینیشر(NSC) / خط4','فینیشر(NSC) / خط4','ln4-mgm-4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'NSC',NULL,1,0,1,3,6961,NULL,NULL,20),(7059,3,'پاساژ2(NSC jc-12) / خط4','پاساژ2(NSC jc-12) / خط4','ln4-mgm-3-2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'NSC jc-12',NULL,1,0,2,2,6961,NULL,NULL,1),(7060,3,'پاساژ3(NSC jc-12) / خط4','پاساژ3(NSC jc-12) / خط4','ln4-mgm-3-3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'NSC jc-12',NULL,1,0,3,2,6961,NULL,NULL,2),(7061,3,'اتوکنر6(schlafhorst) / خط4','اتوکنر6(schlafhorst) / خط4\r\n20 واحدی','ln4-autoconner-6',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'schlafhorst',NULL,1,0,6,5,6961,NULL,NULL,1),(7062,3,'اتوکنر1(schlafhorst) / خط4','اتوکنر1(schlafhorst) / خط4 \r\n60 واحدی خشابی','ln4-autoconner-1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'schlafhorst',NULL,1,0,1,5,6961,NULL,NULL,1),(7064,3,'اتوکنر2(schlafhorst) / خط4','اتوکنر2(schlafhorst) / خط4 \r\n60 واحدی خشابی','ln4-autoconner-2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'schlafhorst',NULL,1,0,2,5,6961,NULL,NULL,1),(7066,3,'اتوکنر3(schlafhorst a238) / خط4','اتوکنر3(schlafhorst a238) / خط4\r\n60 واحدی کدی','ln4-autoconner-3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'schlafhorst a238',NULL,1,0,3,5,6961,NULL,NULL,1),(7068,3,'اتوکنر4(schlafhorst a238) / خط4','اتوکنر4(schlafhorst a238) / خط4 \r\n60 واحدی کدی','ln4-autoconner-4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'schlafhorst a238',NULL,1,0,4,5,6961,NULL,NULL,1),(7070,3,'اتوکنر5(schlafhorst) / خط4','اتوکنر5(schlafhorst) / خط4 \r\n30 واحدی','ln4-autoconner-5',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'schlafhorst',NULL,1,0,5,5,6961,NULL,NULL,1),(7077,3,'لاکنی3 / خط4','لاکنی3 / خط4\r\nاتوکنر تبدیل شده به لاکنی\r\n60 واحدی','ln4-lakoni-3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,3,6,6961,NULL,NULL,1),(7082,3,'لاکنی1(muratec no_607) / خط4','لاکنی1(muratec no_607) / خط4\r\n48 واحدی','ln4-lakoni-1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'muratec no_607',NULL,1,0,1,6,6961,NULL,NULL,1),(7083,3,'لاکنی2(ssm) / خط4','لاکنی2(ssm) / خط4 \r\n55 واحدی','ln4-lakoni-2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'ssm',NULL,1,0,2,6,6961,NULL,NULL,1),(7084,3,'دولاتاب8(volkman vts-07) / خط4','دولاتاب8(volkman vts-07) / خط4\r\n156 واحدی','ln4-dolatab-8',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'volkman vts-07',NULL,1,0,8,7,6961,NULL,NULL,1),(7086,3,'دولاتاب1(volkman vts-07) / خط4','دولاتاب1(volkman vts-07) / خط4 \r\n192 واحدی','ln4-dolatab-1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'volkman vts-07',NULL,1,0,1,7,6961,NULL,NULL,1),(7119,3,'دولاتاب2(volkman vts-07) / خط4','دولاتاب2(volkman vts-07) / خط4 \r\n192 واحدی','ln4-dolatab-2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'volkman vts-07',NULL,1,0,2,7,6961,NULL,NULL,1),(7120,3,'دولاتاب3(volkman vts-07) / خط4','دولاتاب3(volkman vts-07) / خط4 \r\n192 واحدی','ln4-dolatab-3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'volkman vts-07',NULL,1,0,3,7,6961,NULL,NULL,1),(7121,3,'دولاتاب4(volkman vts-07) / خط4','دولاتاب4(volkman vts-07) / خط4 \r\n192 واحدی','ln4-dolatab-4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'volkman vts-07',NULL,1,0,4,7,6961,NULL,NULL,1),(7122,3,'دولاتاب5(volkman vts-07) / خط4','دولاتاب5(volkman vts-07) / خط4\r\n192 واحدی','ln4-dolatab-5',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'volkman vts-07',NULL,1,0,5,7,6961,NULL,NULL,1),(7123,3,'دولاتاب6(volkman vts-07) / خط4','دولاتاب6(volkman vts-07) / خط4 \r\n192 واحدی','ln4-dolatab-6',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'volkman vts-07',NULL,1,0,6,7,6961,NULL,NULL,1),(7124,3,'دولاتاب7(volkman vts-07) / خط4','دولاتاب7(volkman vts-07) / خط4\r\n192 واحدی','ln4-dolatab-7',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'volkman vts-07',NULL,1,0,7,7,6961,NULL,NULL,1),(7125,2,'تاپس / خط2','تاپس / خط2','ln2_tops',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,1,6942,NULL,NULL,NULL),(7126,2,'ریبریکر / خط2','ریبریکر / خط2','ln2_ribriker',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,9,6942,NULL,NULL,NULL),(7127,2,'پاساژ1(NSC-GC15) / خط2','پاساژ1(NSC-GC15) / خط2\r\n2001','ln2_pasajh1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'NSC-GC15',NULL,1,0,1,2,6942,NULL,NULL,NULL),(7128,2,'پاساژ2(NSC-GC15) / خط2','پاساژ2(NSC-GC15) / خط2\r\n1997','ln2_pasajh2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'NSC-GC15',NULL,1,0,2,2,6942,NULL,NULL,NULL),(7129,2,'پاساژ3(NSC-GC15) / خط2','پاساژ3(NSC-GC15) / خط2\r\n2003','ln2_pasajh3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'NSC-GC15',NULL,1,0,3,2,6942,NULL,NULL,NULL),(7131,2,'فینیشر / خط2','فینیشر / خط2','ln2_finisher',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,4,3,6942,NULL,NULL,NULL),(7133,2,'رینگ1 / خط2','رینگ1 / خط2','ln2-T.M-ring1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,4,6942,NULL,NULL,NULL),(7134,2,'اتوکنر1 / خط2','اتوکنر1 / خط2','ln2_autoconner1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,6,5,6942,NULL,NULL,NULL),(7135,2,'اتوکنر2 / خط2','اتوکنر2 / خط2','ln2_autoconner2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,6,5,6942,NULL,NULL,NULL),(7136,2,'اتوکنر3 / خط2','اتوکنر3 /خط2','ln2_autoconner3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,6,5,6942,NULL,NULL,NULL),(7137,2,'اتوکنر4 / خط2','اتوکنر4 / خط2','ln2_autoconner4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,6,5,6942,NULL,NULL,NULL),(7138,2,'اتوکنر5 / خط2','اتوکنر5 / خط2','ln2_autoconner5',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,6,5,6942,NULL,NULL,NULL),(7139,2,'اتوکنر6 / خط2','اتوکنر6 / خط2','ln2_autoconner6',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,6,5,6942,NULL,NULL,NULL),(7142,2,'لاکنی1(ریته) / خط2','لاکنی1(ریته) / خط2','ln2_lakoni1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'ریته',NULL,1,0,7,6,6942,NULL,NULL,NULL),(7143,2,'لاکنی2(کایپو) / خط2','لاکنی2(کایپو) / خط2','ln2_lakoni2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'کایپو',NULL,1,0,7,6,6942,NULL,NULL,NULL),(7144,2,'لاکنی3(ssm) / خط2','لاکنی3(ssm) / خط2','ln2_lakoni3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'ssm',NULL,1,0,NULL,6,6942,NULL,NULL,NULL),(7145,2,'دولاتاب1 / خط2','دولاتاب1 / خط2','ln2_dollatap1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,8,7,6942,NULL,NULL,NULL),(7147,2,'دولاتاب2 / خط2','دولاتاب2 / خط2','ln2_dollatap2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,8,7,6942,NULL,NULL,NULL),(7148,2,'دولاتاب3 / خط2','دولاتاب3 / خط2','ln2_dollatap3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,8,7,6942,NULL,NULL,NULL),(7149,2,'دولاتاب4 / خط2','دولاتاب4 / خط2','ln2_dollatap4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,NULL,7,6942,NULL,NULL,NULL),(7150,2,'دولاتاب5 / خط2','دولاتاب5 / خط2','ln2_dollatap5',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,8,7,6942,NULL,NULL,NULL),(7151,2,'دولاتاب6 / خط2','دولاتاب6 / خط2','ln2_dollatap6',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,8,7,6942,NULL,NULL,NULL),(7250,3,'لاکنی4 / خط4','لاکنی4 / خط4','ln4-lakoni-4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,4,6,6961,NULL,NULL,1),(7251,NULL,'خط 1',NULL,'خط_1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,NULL,NULL,NULL,NULL,NULL,NULL),(7252,NULL,'خط 12',NULL,'خط_12',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,NULL,NULL,NULL,NULL,NULL,NULL),(7253,NULL,'خط 33',NULL,'خط_33',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `assets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assets2`
--

DROP TABLE IF EXISTS `assets2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assets2` (
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
  `assetVahed` int(11) DEFAULT NULL,
  `assetCategory_id` bigint(20) DEFAULT NULL,
  `assetIsLocatedAt_id` bigint(20) DEFAULT NULL,
  `assetIsPartOf_id` bigint(20) DEFAULT NULL,
  `assetMachineCategory_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `assets2_assetCategory_id_bb7cfaad_fk_assetcategory_id` (`assetCategory_id`),
  KEY `assets2_assetIsLocatedAt_id_9bed0e7a_fk_assets2_id` (`assetIsLocatedAt_id`),
  KEY `assets2_assetIsPartOf_id_dbde6abc_fk_assets2_id` (`assetIsPartOf_id`),
  KEY `assets2_assetMachineCategory_id_17f5c723_fk_machinecategory_id` (`assetMachineCategory_id`),
  CONSTRAINT `assets2_assetCategory_id_bb7cfaad_fk_assetcategory_id` FOREIGN KEY (`assetCategory_id`) REFERENCES `assetcategory` (`id`),
  CONSTRAINT `assets2_assetIsLocatedAt_id_9bed0e7a_fk_assets2_id` FOREIGN KEY (`assetIsLocatedAt_id`) REFERENCES `assets2` (`id`),
  CONSTRAINT `assets2_assetIsPartOf_id_dbde6abc_fk_assets2_id` FOREIGN KEY (`assetIsPartOf_id`) REFERENCES `assets2` (`id`),
  CONSTRAINT `assets2_assetMachineCategory_id_17f5c723_fk_machinecategory_id` FOREIGN KEY (`assetMachineCategory_id`) REFERENCES `machinecategory` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assets2`
--

LOCK TABLES `assets2` WRITE;
/*!40000 ALTER TABLE `assets2` DISABLE KEYS */;
INSERT INTO `assets2` VALUES (1,NULL,'dsad',NULL,'dsad',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,NULL,NULL,NULL,NULL,NULL,NULL),(2,NULL,'یسی',NULL,'یسی',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,NULL,NULL,NULL,NULL,NULL,NULL),(3,NULL,'خط1',NULL,'خط1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,1,0,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `assets2` ENABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=159 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add asset category',7,'add_assetcategory'),(26,'Can change asset category',7,'change_assetcategory'),(27,'Can delete asset category',7,'delete_assetcategory'),(28,'Can view asset category',7,'view_assetcategory'),(29,'Can add machine category',8,'add_machinecategory'),(30,'Can change machine category',8,'change_machinecategory'),(31,'Can delete machine category',8,'delete_machinecategory'),(32,'Can view machine category',8,'view_machinecategory'),(33,'Can add asset',9,'add_asset'),(34,'Can change asset',9,'change_asset'),(35,'Can delete asset',9,'delete_asset'),(36,'Can view asset',9,'view_asset'),(37,'Can add formula',10,'add_formula'),(38,'Can change formula',10,'change_formula'),(39,'Can delete formula',10,'delete_formula'),(40,'Can view formula',10,'view_formula'),(41,'Can add daily production',11,'add_dailyproduction'),(42,'Can change daily production',11,'change_dailyproduction'),(43,'Can delete daily production',11,'delete_dailyproduction'),(44,'Can view daily production',11,'view_dailyproduction'),(45,'Can add sys user',12,'add_sysuser'),(46,'Can change sys user',12,'change_sysuser'),(47,'Can delete sys user',12,'delete_sysuser'),(48,'Can view sys user',12,'view_sysuser'),(49,'can view dashboard',12,'can_view_dashboard'),(50,'Can add shift',13,'add_shift'),(51,'Can change shift',13,'change_shift'),(52,'Can delete shift',13,'delete_shift'),(53,'Can view shift',13,'view_shift'),(54,'Can add speed formula',14,'add_speedformula'),(55,'Can change speed formula',14,'change_speedformula'),(56,'Can delete speed formula',14,'delete_speedformula'),(57,'Can view speed formula',14,'view_speedformula'),(58,'Can add production standard',15,'add_productionstandard'),(59,'Can change production standard',15,'change_productionstandard'),(60,'Can delete production standard',15,'delete_productionstandard'),(61,'Can view production standard',15,'view_productionstandard'),(62,'Can add zayeat',16,'add_zayeat'),(63,'Can change zayeat',16,'change_zayeat'),(64,'Can delete zayeat',16,'delete_zayeat'),(65,'Can view zayeat',16,'view_zayeat'),(66,'Can add zayeat vaz',17,'add_zayeatvaz'),(67,'Can change zayeat vaz',17,'change_zayeatvaz'),(68,'Can delete zayeat vaz',17,'delete_zayeatvaz'),(69,'Can view zayeat vaz',17,'view_zayeatvaz'),(70,'Can add failure',18,'add_failure'),(71,'Can change failure',18,'change_failure'),(72,'Can delete failure',18,'delete_failure'),(73,'Can view failure',18,'view_failure'),(74,'Can add asset failure',19,'add_assetfailure'),(75,'Can change asset failure',19,'change_assetfailure'),(76,'Can delete asset failure',19,'delete_assetfailure'),(77,'Can view asset failure',19,'view_assetfailure'),(78,'Can add asset randeman init',20,'add_assetrandemaninit'),(79,'Can change asset randeman init',20,'change_assetrandemaninit'),(80,'Can delete asset randeman init',20,'delete_assetrandemaninit'),(81,'Can view asset randeman init',20,'view_assetrandemaninit'),(82,'Can add asset randeman per month',21,'add_assetrandemanpermonth'),(83,'Can change asset randeman per month',21,'change_assetrandemanpermonth'),(84,'Can delete asset randeman per month',21,'delete_assetrandemanpermonth'),(85,'Can view asset randeman per month',21,'view_assetrandemanpermonth'),(86,'Can add asset randeman list',22,'add_assetrandemanlist'),(87,'Can change asset randeman list',22,'change_assetrandemanlist'),(88,'Can delete asset randeman list',22,'delete_assetrandemanlist'),(89,'Can view asset randeman list',22,'view_assetrandemanlist'),(90,'Can add nezafat padash',23,'add_nezafatpadash'),(91,'Can change nezafat padash',23,'change_nezafatpadash'),(92,'Can delete nezafat padash',23,'delete_nezafatpadash'),(93,'Can view nezafat padash',23,'view_nezafatpadash'),(94,'Can add nezafat ranking',24,'add_nezafatranking'),(95,'Can change nezafat ranking',24,'change_nezafatranking'),(96,'Can delete nezafat ranking',24,'delete_nezafatranking'),(97,'Can view nezafat ranking',24,'view_nezafatranking'),(98,'Can add tolid padash',25,'add_tolidpadash'),(99,'Can change tolid padash',25,'change_tolidpadash'),(100,'Can delete tolid padash',25,'delete_tolidpadash'),(101,'Can view tolid padash',25,'view_tolidpadash'),(102,'Can add tolid ranking',26,'add_tolidranking'),(103,'Can change tolid ranking',26,'change_tolidranking'),(104,'Can delete tolid ranking',26,'delete_tolidranking'),(105,'Can view tolid ranking',26,'view_tolidranking'),(106,'Can add financial profile',27,'add_financialprofile'),(107,'Can change financial profile',27,'change_financialprofile'),(108,'Can delete financial profile',27,'delete_financialprofile'),(109,'Can view financial profile',27,'view_financialprofile'),(110,'Can add part',28,'add_part'),(111,'Can change part',28,'change_part'),(112,'Can delete part',28,'delete_part'),(113,'Can view part',28,'view_part'),(114,'Can add part csv file',29,'add_partcsvfile'),(115,'Can change part csv file',29,'change_partcsvfile'),(116,'Can delete part csv file',29,'delete_partcsvfile'),(117,'Can view part csv file',29,'view_partcsvfile'),(118,'Can add purchase request',30,'add_purchaserequest'),(119,'Can change purchase request',30,'change_purchaserequest'),(120,'Can delete purchase request',30,'delete_purchaserequest'),(121,'Can view purchase request',30,'view_purchaserequest'),(122,'Can add request item',31,'add_requestitem'),(123,'Can change request item',31,'change_requestitem'),(124,'Can delete request item',31,'delete_requestitem'),(125,'Can view request item',31,'view_requestitem'),(126,'Can add rfq',32,'add_rfq'),(127,'Can change rfq',32,'change_rfq'),(128,'Can delete rfq',32,'delete_rfq'),(129,'Can view rfq',32,'view_rfq'),(130,'Can add supplier',33,'add_supplier'),(131,'Can change supplier',33,'change_supplier'),(132,'Can delete supplier',33,'delete_supplier'),(133,'Can view supplier',33,'view_supplier'),(134,'Can add supplier response',34,'add_supplierresponse'),(135,'Can change supplier response',34,'change_supplierresponse'),(136,'Can delete supplier response',34,'delete_supplierresponse'),(137,'Can view supplier response',34,'view_supplierresponse'),(138,'Can add part user',35,'add_partuser'),(139,'Can change part user',35,'change_partuser'),(140,'Can delete part user',35,'delete_partuser'),(141,'Can view part user',35,'view_partuser'),(142,'Can add part file',36,'add_partfile'),(143,'Can change part file',36,'change_partfile'),(144,'Can delete part file',36,'delete_partfile'),(145,'Can view part file',36,'view_partfile'),(146,'Can add part category',37,'add_partcategory'),(147,'Can change part category',37,'change_partcategory'),(148,'Can delete part category',37,'delete_partcategory'),(149,'Can view part category',37,'view_partcategory'),(150,'Can add order',38,'add_order'),(151,'Can change order',38,'change_order'),(152,'Can delete order',38,'delete_order'),(153,'Can view order',38,'view_order'),(154,'can admin create purchase',12,'can_admin_purchase'),(155,'Can add asset2',39,'add_asset2'),(156,'Can change asset2',39,'change_asset2'),(157,'Can delete asset2',39,'delete_asset2'),(158,'Can view asset2',39,'view_asset2');
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$260000$4Ye4nTTUOPI5CfqZN0wY8G$3Ww8cCXMnbS9NJ8OMBFpOxjFqTYhwBfIVzr+Os9XZrI=','2025-01-07 17:07:17.971190',1,'admin','','','admin@admin.com',1,1,'2024-10-26 11:41:38.520780'),(2,'pbkdf2_sha256$260000$QCGAPX2LXPmNJEtSrRLcbc$ihDTkCZwUA5gjK9vAkKx0gDmaIfIkyN6JYLgv5tEX1g=',NULL,0,'sayahi','','','',0,1,'2025-01-07 18:41:09.918256');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=1194 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dailyproduction`
--

LOCK TABLES `dailyproduction` WRITE;
/*!40000 ALTER TABLE `dailyproduction` DISABLE KEYS */;
INSERT INTO `dailyproduction` VALUES (1,'2024-10-22','2024-10-27 07:05:27.862963','',50,0,0,7053,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(2,'2024-10-22','2024-10-27 07:05:27.875975','',50,0,1000,7052,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,5),(3,'2024-10-22','2024-10-27 07:05:27.894986','',0,0,0,7054,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(4,'2024-10-22','2024-10-27 07:05:27.904993','',0,0,0,7059,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(5,'2024-10-22','2024-10-27 07:05:27.911997','',0,0,0,7060,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,0),(6,'2024-10-22','2024-10-27 07:05:27.928009','',0,0,0,7055,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,0),(7,'2024-10-22','2024-10-27 07:05:27.943020','',48,0,45,6993,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1422),(8,'2024-10-22','2024-10-27 07:05:27.956029','',48,0,45,6994,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1422),(9,'2024-10-22','2024-10-27 07:05:27.969038','',45,0,45,6995,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1389),(10,'2024-10-22','2024-10-27 07:05:27.983049','',48,0,45,6997,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1272),(11,'2024-10-22','2024-10-27 07:05:27.994056','',48,0,45,6999,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1278),(12,'2024-10-22','2024-10-27 07:05:28.003062','',48,742505,90,7001,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,745158),(13,'2024-10-22','2024-10-27 07:05:28.014070','',45,467910,90,7003,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,470595),(14,'2024-10-22','2024-10-27 07:05:28.024078','',45,813285,90,7005,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,815710),(15,'2024-10-22','2024-10-27 07:05:28.034084','',48,420855,90,7007,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,423240),(16,'2024-10-22','2024-10-27 07:05:28.044091','',48,849700,45,7009,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,852080),(17,'2024-10-22','2024-10-27 07:05:28.053098','',48,274171,45,7047,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,276260),(18,'2024-10-22','2024-10-27 07:05:28.063105','',48,194485,45,7048,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,196534),(19,'2024-10-22','2024-10-27 07:05:28.070110','',45,147580,45,7049,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,149687),(20,'2024-10-22','2024-10-27 07:05:28.084120','',45,251032,90,7050,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,253066),(21,'2024-10-22','2024-10-27 07:05:28.093126','',48,0,0,7062,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(22,'2024-10-22','2024-10-27 07:05:28.101132','',45,0,290,7064,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(23,'2024-10-22','2024-10-27 07:05:28.112141','',48,0,345,7066,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(24,'2024-10-22','2024-10-27 07:05:28.120146','',45,0,265,7068,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(25,'2024-10-22','2024-10-27 07:05:28.132154','',48,0,115,7070,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(26,'2024-10-22','2024-10-27 07:05:28.144162','',0,0,0,7061,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(27,'2024-10-22','2024-10-27 07:05:28.153169','',0,0,0,7082,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(28,'2024-10-22','2024-10-27 07:05:28.163176','',45,0,200,7083,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(29,'2024-10-22','2024-10-27 07:05:28.170181','',45,0,667,7077,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(30,'2024-10-22','2024-10-27 07:05:28.183192','',0,0,0,7250,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(31,'2024-10-22','2024-10-27 07:05:28.195200','',48,0,288,7086,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,96,0),(32,'2024-10-22','2024-10-27 07:05:28.228223','',48,0,144,7119,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,48,0),(33,'2024-10-22','2024-10-27 07:05:28.275256','',0,0,0,7120,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(34,'2024-10-22','2024-10-27 07:05:28.284262','',40,0,0,7121,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(35,'2024-10-22','2024-10-27 07:05:28.322355','',0,0,0,7122,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(36,'2024-10-22','2024-10-27 07:05:28.345872','',48,0,0,7123,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(37,'2024-10-22','2024-10-27 07:05:28.354878','',40,0,264,7124,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,88,0),(38,'2024-10-22','2024-10-27 07:05:28.381398','',40,0,0,7084,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(39,'2024-10-22','2024-10-27 07:48:04.745897','',0,0,0,7053,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(40,'2024-10-22','2024-10-27 07:48:04.752904','',0,0,0,7052,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(41,'2024-10-22','2024-10-27 07:48:04.757906','',0,0,0,7054,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(42,'2024-10-22','2024-10-27 07:48:04.763911','',0,0,0,7059,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(43,'2024-10-22','2024-10-27 07:48:04.769915','',0,0,0,7060,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,0),(44,'2024-10-22','2024-10-27 07:48:04.774919','',0,0,0,7055,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,0),(45,'2024-10-22','2024-10-27 07:48:04.781923','',48,0,45,6993,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1425),(46,'2024-10-22','2024-10-27 07:48:04.786927','',48,0,90,6994,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1407),(47,'2024-10-22','2024-10-27 07:48:04.792931','',45,0,90,6995,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1272),(48,'2024-10-22','2024-10-27 07:48:04.799936','',48,0,45,6997,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1428),(49,'2024-10-22','2024-10-27 07:48:04.806941','',48,0,90,6999,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1410),(50,'2024-10-22','2024-10-27 07:48:04.812945','',48,742505,45,7001,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,743799),(51,'2024-10-22','2024-10-27 07:48:04.819951','',45,467910,0,7003,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,469371),(52,'2024-10-22','2024-10-27 07:48:04.827957','',45,813285,90,7005,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,814385),(53,'2024-10-22','2024-10-27 07:48:04.835964','',48,420855,45,7007,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,422070),(54,'2024-10-22','2024-10-27 07:48:04.842967','',48,849700,90,7009,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,850880),(55,'2024-10-22','2024-10-27 07:48:04.849972','',48,274171,45,7047,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,275230),(56,'2024-10-22','2024-10-27 07:48:04.855976','',48,194485,90,7048,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,195545),(57,'2024-10-22','2024-10-27 07:48:04.862981','',45,147580,90,7049,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,148695),(58,'2024-10-22','2024-10-27 07:48:04.877992','',45,251032,90,7050,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,252058),(59,'2024-10-22','2024-10-27 07:48:04.896005','',48,0,0,7062,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(60,'2024-10-22','2024-10-27 07:48:04.904010','',45,0,290,7064,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(61,'2024-10-22','2024-10-27 07:48:04.915017','',48,0,310,7066,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(62,'2024-10-22','2024-10-27 07:48:04.937034','',45,0,230,7068,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(63,'2024-10-22','2024-10-27 07:48:04.944038','',48,0,170,7070,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(64,'2024-10-22','2024-10-27 07:48:04.950043','',0,0,0,7061,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(65,'2024-10-22','2024-10-27 07:48:04.957048','',0,0,0,7082,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(66,'2024-10-22','2024-10-27 07:48:04.963052','',48,0,200,7083,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(67,'2024-10-22','2024-10-27 07:48:04.971058','',48,0,726,7077,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(68,'2024-10-22','2024-10-27 07:48:04.978064','',0,0,0,7250,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(69,'2024-10-22','2024-10-27 07:48:04.984067','',48,0,0,7086,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(70,'2024-10-22','2024-10-27 07:48:04.991072','',48,0,144,7119,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,48,0),(71,'2024-10-22','2024-10-27 07:48:04.997076','',40,0,324,7120,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,108,0),(72,'2024-10-22','2024-10-27 07:48:05.003080','',48,0,0,7121,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(73,'2024-10-22','2024-10-27 07:48:05.010086','',0,0,0,7122,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(74,'2024-10-22','2024-10-27 07:48:05.016090','',48,0,144,7123,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,48,0),(75,'2024-10-22','2024-10-27 07:48:05.022094','',40,0,21,7124,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,7,0),(76,'2024-10-22','2024-10-27 07:48:05.029099','',45,0,234,7084,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,78,0),(77,'2024-10-22','2024-10-27 08:03:10.224080','',50,0,60,7053,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1200),(78,'2024-10-22','2024-10-27 08:03:10.233086','',50,0,600,7052,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,3),(79,'2024-10-22','2024-10-27 08:03:10.239091','',0,0,0,7054,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(80,'2024-10-22','2024-10-27 08:03:10.245094','',0,0,0,7059,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(81,'2024-10-22','2024-10-27 08:03:10.250098','',0,0,0,7060,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,0),(82,'2024-10-22','2024-10-27 08:03:10.265109','',0,0,0,7055,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,0),(83,'2024-10-22','2024-10-27 08:03:10.271113','',48,0,90,6993,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1368),(84,'2024-10-22','2024-10-27 08:03:10.305137','',48,0,90,6994,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1371),(85,'2024-10-22','2024-10-27 08:03:10.313143','',45,0,0,6995,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1113),(86,'2024-10-22','2024-10-27 08:03:10.330155','',48,0,90,6997,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1374),(87,'2024-10-22','2024-10-27 08:03:10.336159','',48,0,45,6999,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1425),(88,'2024-10-22','2024-10-27 08:03:10.351170','',48,745158,0,7001,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,746529),(89,'2024-10-22','2024-10-27 08:03:10.365180','',45,470595,45,7003,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,471877),(90,'2024-10-22','2024-10-27 08:03:10.371184','',45,815710,45,7005,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,817082),(91,'2024-10-22','2024-10-27 08:03:10.378189','',48,423240,45,7007,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,424412),(92,'2024-10-22','2024-10-27 08:03:10.384193','',48,852080,90,7009,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,853291),(93,'2024-10-22','2024-10-27 08:03:10.390198','',48,276260,45,7047,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,277342),(94,'2024-10-22','2024-10-27 08:03:10.397202','',48,196534,90,7048,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,197539),(95,'2024-10-22','2024-10-27 08:03:10.402206','',45,149687,90,7049,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,150848),(96,'2024-10-22','2024-10-27 08:03:10.408210','',45,253066,45,7050,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,253965),(97,'2024-10-22','2024-10-27 08:03:10.413214','',48,0,150,7062,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(98,'2024-10-22','2024-10-27 08:03:10.420219','',45,0,234,7064,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(99,'2024-10-22','2024-10-27 08:03:10.425222','',48,0,320,7066,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(100,'2024-10-22','2024-10-27 08:03:10.430226','',45,0,251,7068,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(101,'2024-10-22','2024-10-27 08:03:10.435230','',48,0,175,7070,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(102,'2024-10-22','2024-10-27 08:03:10.444236','',0,0,0,7082,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(103,'2024-10-22','2024-10-27 08:03:10.448239','',48,0,140,7083,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(104,'2024-10-22','2024-10-27 08:03:10.454243','',48,0,715,7077,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(105,'2024-10-22','2024-10-27 08:03:10.459246','',0,0,0,7250,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(106,'2024-10-22','2024-10-27 08:03:10.463250','',48,0,288,7086,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,96,0),(107,'2024-10-22','2024-10-27 08:03:10.468253','',48,0,288,7119,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,96,0),(108,'2024-10-22','2024-10-27 08:03:10.473257','',48,0,0,7120,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(109,'2024-10-22','2024-10-27 08:03:10.479261','',48,0,0,7121,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(110,'2024-10-22','2024-10-27 08:03:10.485265','',0,0,0,7122,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(111,'2024-10-22','2024-10-27 08:03:10.491269','',48,0,0,7123,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(112,'2024-10-22','2024-10-27 08:03:10.497274','',40,0,276,7124,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,92,0),(113,'2024-10-22','2024-10-27 08:03:10.503278','',40,0,234,7084,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,78,0),(114,'2024-10-23','2024-10-27 09:46:17.579408','',50,0,345,7053,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,6900),(115,'2024-10-23','2024-10-27 09:46:17.591417','',50,0,1400,7052,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,7),(116,'2024-10-23','2024-10-27 09:46:17.597421','',50,0,250,7054,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,5000),(117,'2024-10-23','2024-10-27 09:46:17.604426','',50,0,260,7059,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,5200),(118,'2024-10-23','2024-10-27 09:46:17.610430','',50,0,120,7060,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,1200),(119,'2024-10-23','2024-10-27 09:46:17.617435','',0,0,0,7055,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,0),(120,'2024-10-23','2024-10-27 09:46:17.624440','',48,0,0,6993,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1425),(121,'2024-10-23','2024-10-27 09:46:17.631445','',48,0,45,6994,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1425),(122,'2024-10-23','2024-10-27 09:46:17.638450','',48,0,0,6995,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1218),(123,'2024-10-23','2024-10-27 09:46:17.644454','',48,0,45,6997,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1425),(124,'2024-10-23','2024-10-27 09:46:17.651460','',48,0,90,6999,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1407),(125,'2024-10-23','2024-10-27 09:46:17.657464','',48,746529,45,7001,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,747849),(126,'2024-10-23','2024-10-27 09:46:17.664469','',48,471877,45,7003,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,473115),(127,'2024-10-23','2024-10-27 09:46:17.671474','',45,817082,0,7005,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,817900),(128,'2024-10-23','2024-10-27 09:46:17.678479','',48,424412,90,7007,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,425653),(129,'2024-10-23','2024-10-27 09:46:17.684483','',48,853291,45,7009,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,854553),(130,'2024-10-23','2024-10-27 09:46:17.691488','',48,277342,45,7047,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,278395),(131,'2024-10-23','2024-10-27 09:46:17.696491','',48,197539,90,7048,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,198635),(132,'2024-10-23','2024-10-27 09:46:17.701495','',45,150848,90,7049,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,152080),(133,'2024-10-23','2024-10-27 09:46:17.706498','',45,253965,90,7050,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,255109),(134,'2024-10-23','2024-10-27 09:46:17.710501','',48,0,69,7062,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(135,'2024-10-23','2024-10-27 09:46:17.715505','',45,0,218,7064,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(136,'2024-10-23','2024-10-27 09:46:17.721509','',48,0,230,7066,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(137,'2024-10-23','2024-10-27 09:46:17.727513','',45,0,245,7068,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(138,'2024-10-23','2024-10-27 09:46:17.732517','',48,0,160,7070,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(139,'2024-10-23','2024-10-27 09:46:17.743525','',0,0,0,7082,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(140,'2024-10-23','2024-10-27 09:46:17.748529','',48,0,186,7083,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(141,'2024-10-23','2024-10-27 09:46:17.753532','',48,0,621,7077,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(142,'2024-10-23','2024-10-27 09:46:17.759537','',0,0,0,7250,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(143,'2024-10-23','2024-10-27 09:46:17.764540','',48,0,0,7086,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(144,'2024-10-23','2024-10-27 09:46:17.769543','',48,0,0,7119,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(145,'2024-10-23','2024-10-27 09:46:17.774547','',48,0,0,7120,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(146,'2024-10-23','2024-10-27 09:46:17.779550','',48,0,588,7121,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,196,0),(147,'2024-10-23','2024-10-27 09:46:17.785555','',0,0,0,7122,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(148,'2024-10-23','2024-10-27 09:46:17.791559','',48,0,288,7123,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,96,0),(149,'2024-10-23','2024-10-27 09:46:17.796563','',40,0,24,7124,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,8,0),(150,'2024-10-23','2024-10-27 09:46:17.801566','',45,0,0,7084,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(151,'2024-10-23','2024-10-27 09:51:03.164339','',50,0,0,7053,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(152,'2024-10-23','2024-10-27 09:51:03.176347','',50,0,400,7052,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,2),(153,'2024-10-23','2024-10-27 09:51:03.182350','',50,0,170,7054,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,3400),(154,'2024-10-23','2024-10-27 09:51:03.189356','',50,0,220,7059,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,4400),(155,'2024-10-23','2024-10-27 09:51:03.196361','',50,0,250,7060,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,2500),(156,'2024-10-23','2024-10-27 09:51:03.203365','',0,0,0,7055,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,0),(157,'2024-10-23','2024-10-27 09:51:03.210371','',48,0,45,6993,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1302),(158,'2024-10-23','2024-10-27 09:51:03.217377','',48,0,90,6994,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1287),(159,'2024-10-23','2024-10-27 09:51:03.225381','',48,0,45,6995,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1311),(160,'2024-10-23','2024-10-27 09:51:03.231387','',48,0,90,6997,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1299),(161,'2024-10-23','2024-10-27 09:51:03.238391','',48,0,45,6999,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1317),(162,'2024-10-23','2024-10-27 09:51:03.244395','',48,747849,90,7001,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,749100),(163,'2024-10-23','2024-10-27 09:51:03.250399','',48,473115,90,7003,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,474295),(164,'2024-10-23','2024-10-27 09:51:03.257404','',45,817900,0,7005,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,818590),(165,'2024-10-23','2024-10-27 09:51:03.264409','',48,425653,45,7007,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,426695),(166,'2024-10-23','2024-10-27 09:51:03.271415','',48,854553,90,7009,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,855640),(167,'2024-10-23','2024-10-27 09:51:03.277418','',48,278395,45,7047,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,279355),(168,'2024-10-23','2024-10-27 09:51:03.284423','',48,198635,45,7048,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,199590),(169,'2024-10-23','2024-10-27 09:51:03.296432','',45,152080,90,7049,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,153055),(170,'2024-10-23','2024-10-27 09:51:03.302436','',45,255109,90,7050,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,255914),(171,'2024-10-23','2024-10-27 09:51:03.309441','',48,0,70,7062,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(172,'2024-10-23','2024-10-27 09:51:03.315446','',48,0,215,7064,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(173,'2024-10-23','2024-10-27 09:51:03.321450','',48,0,210,7066,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(174,'2024-10-23','2024-10-27 09:51:03.328455','',48,0,250,7068,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(175,'2024-10-23','2024-10-27 09:51:03.334460','',48,0,100,7070,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(176,'2024-10-23','2024-10-27 09:51:03.343465','',0,0,0,7082,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(177,'2024-10-23','2024-10-27 09:51:03.349470','',45,0,186,7083,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(178,'2024-10-23','2024-10-27 09:51:03.354473','',45,0,604,7077,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(179,'2024-10-23','2024-10-27 09:51:03.360478','',0,0,0,7250,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(180,'2024-10-23','2024-10-27 09:51:03.365481','',48,0,0,7086,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(181,'2024-10-23','2024-10-27 09:51:03.371486','',48,0,0,7119,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(182,'2024-10-23','2024-10-27 09:51:03.378491','',48,0,0,7120,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(183,'2024-10-23','2024-10-27 09:51:03.383494','',48,0,0,7121,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(184,'2024-10-23','2024-10-27 09:51:03.389498','',0,0,0,7122,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(185,'2024-10-23','2024-10-27 09:51:03.394502','',48,0,288,7123,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,96,0),(186,'2024-10-23','2024-10-27 09:51:03.400507','',40,0,0,7124,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(187,'2024-10-23','2024-10-27 09:51:03.406510','',45,0,234,7084,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,78,0),(188,'2024-10-23','2024-10-27 09:54:58.280518','',50,0,100,7053,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,2000),(189,'2024-10-23','2024-10-27 09:54:58.292527','',50,0,400,7052,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,2),(190,'2024-10-23','2024-10-27 09:54:58.300533','',50,0,110,7054,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,2200),(191,'2024-10-23','2024-10-27 09:54:58.307538','',50,0,210,7059,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,4200),(192,'2024-10-23','2024-10-27 09:54:58.313542','',50,0,720,7060,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,7200),(193,'2024-10-23','2024-10-27 09:54:58.320546','',1.5,0,1107,7055,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,4100),(194,'2024-10-23','2024-10-27 09:54:58.326551','',48,0,90,6993,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1407),(195,'2024-10-23','2024-10-27 09:54:58.330554','',48,0,45,6994,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1425),(196,'2024-10-23','2024-10-27 09:54:58.335557','',48,0,45,6995,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1425),(197,'2024-10-23','2024-10-27 09:54:58.340561','',48,0,45,6997,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1425),(198,'2024-10-23','2024-10-27 09:54:58.345565','',48,0,0,6999,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1389),(199,'2024-10-23','2024-10-27 09:54:58.350568','',48,749100,45,7001,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,750358),(200,'2024-10-23','2024-10-27 09:54:58.355572','',48,474295,45,7003,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,475598),(201,'2024-10-23','2024-10-27 09:54:58.365579','',45,818590,90,7005,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,819658),(202,'2024-10-23','2024-10-27 09:54:58.371583','',48,426695,90,7007,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,427829),(203,'2024-10-23','2024-10-27 09:54:58.376587','',48,855640,45,7009,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,856855),(204,'2024-10-23','2024-10-27 09:54:58.381590','',48,279355,45,7047,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,280338),(205,'2024-10-23','2024-10-27 09:54:58.385593','',48,199590,45,7048,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,200629),(206,'2024-10-23','2024-10-27 09:54:58.390597','',45,153055,0,7049,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,154229),(207,'2024-10-23','2024-10-27 09:54:58.395600','',45,255914,0,7050,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,255951),(208,'2024-10-23','2024-10-27 09:54:58.400604','',48,0,258,7062,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(209,'2024-10-23','2024-10-27 09:54:58.405607','',45,0,269,7064,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(210,'2024-10-23','2024-10-27 09:54:58.410611','',48,0,320,7066,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(211,'2024-10-23','2024-10-27 09:54:58.416615','',48,0,300,7068,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(212,'2024-10-23','2024-10-27 09:54:58.422620','',48,0,129,7070,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(213,'2024-10-23','2024-10-27 09:54:58.431626','',0,0,0,7082,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(214,'2024-10-23','2024-10-27 09:54:58.436630','',48,0,140,7083,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(215,'2024-10-23','2024-10-27 09:54:58.441633','',48,0,712,7077,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(216,'2024-10-23','2024-10-27 09:54:58.445636','',0,0,0,7250,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(217,'2024-10-23','2024-10-27 09:54:58.451640','',48,0,0,7086,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(218,'2024-10-23','2024-10-27 09:54:58.455643','',48,0,0,7119,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(219,'2024-10-23','2024-10-27 09:54:58.460646','',48,0,0,7120,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(220,'2024-10-23','2024-10-27 09:54:58.466651','',48,0,0,7121,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(221,'2024-10-23','2024-10-27 09:54:58.471654','',0,0,0,7122,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(222,'2024-10-23','2024-10-27 09:54:58.476657','',48,0,0,7123,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(223,'2024-10-23','2024-10-27 09:54:58.482662','',40,0,0,7124,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(224,'2024-10-23','2024-10-27 09:54:58.487666','',45,0,108,7084,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,36,0),(225,'2024-10-24','2024-10-27 10:53:21.064738','',50,0,345,7053,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,6900),(226,'2024-10-24','2024-10-27 10:53:21.075746','',50,0,1400,7052,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,7),(227,'2024-10-24','2024-10-27 10:53:21.082751','',50,0,350,7054,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,7000),(228,'2024-10-24','2024-10-27 10:53:21.089755','',50,0,525,7059,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,10500),(229,'2024-10-24','2024-10-27 10:53:21.095760','',50,0,660,7060,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,6600),(230,'2024-10-24','2024-10-27 10:53:21.102765','',1.5,0,1350,7055,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,5000),(231,'2024-10-24','2024-10-27 10:53:21.111771','',48,0,45,6993,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1425),(232,'2024-10-24','2024-10-27 10:53:21.117775','',48,0,90,6994,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1410),(233,'2024-10-24','2024-10-27 10:53:21.122779','',48,0,90,6995,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1395),(234,'2024-10-24','2024-10-27 10:53:21.131785','',48,0,90,6997,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1407),(235,'2024-10-24','2024-10-27 10:53:21.136789','',48,0,45,6999,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1425),(236,'2024-10-24','2024-10-27 10:53:21.143794','',48,750358,45,7001,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,751673),(237,'2024-10-24','2024-10-27 10:53:21.148797','',48,475598,90,7003,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,476995),(238,'2024-10-24','2024-10-27 10:53:21.153801','',48,819658,45,7005,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,820854),(239,'2024-10-24','2024-10-27 10:53:21.169813','',48,427829,90,7007,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,429022),(240,'2024-10-24','2024-10-27 10:53:21.175816','',48,856855,45,7009,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,858086),(241,'2024-10-24','2024-10-27 10:53:21.180820','',48,280338,45,7047,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,281382),(242,'2024-10-24','2024-10-27 10:53:21.185823','',48,200629,0,7048,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,201835),(243,'2024-10-24','2024-10-27 10:53:21.191829','',45,154229,90,7049,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,155665),(244,'2024-10-24','2024-10-27 10:53:21.198833','',50,255951,0,7050,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,257060),(245,'2024-10-24','2024-10-27 10:53:21.213843','',48,0,320,7062,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(246,'2024-10-24','2024-10-27 10:53:21.220849','',45,0,313,7064,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(247,'2024-10-24','2024-10-27 10:53:21.228855','',48,0,325,7066,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(248,'2024-10-24','2024-10-27 10:53:21.237861','',48,0,295,7068,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(249,'2024-10-24','2024-10-27 10:53:21.244865','',48,0,103,7070,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(250,'2024-10-24','2024-10-27 10:53:21.254873','',0,0,0,7082,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(251,'2024-10-24','2024-10-27 10:53:21.261877','',48,0,210,7083,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(252,'2024-10-24','2024-10-27 10:53:21.268882','',48,0,756,7077,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(253,'2024-10-24','2024-10-27 10:53:21.276888','',0,0,0,7250,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(254,'2024-10-24','2024-10-27 10:53:21.283893','',48,0,288,7086,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,96,0),(255,'2024-10-24','2024-10-27 10:53:21.290898','',48,0,288,7119,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,96,0),(256,'2024-10-24','2024-10-27 10:53:21.297903','',48,0,588,7120,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,196,0),(257,'2024-10-24','2024-10-27 10:53:21.303908','',48,0,0,7121,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(258,'2024-10-24','2024-10-27 10:53:21.310913','',48,0,0,7122,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(259,'2024-10-24','2024-10-27 10:53:21.320919','',48,0,0,7123,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(260,'2024-10-24','2024-10-27 10:53:21.328926','',40,0,144,7124,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,48,0),(261,'2024-10-24','2024-10-27 10:53:21.335930','',45,0,0,7084,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(262,'2024-10-24','2024-10-27 10:56:21.193885','',50,0,350,7053,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,7000),(263,'2024-10-24','2024-10-27 10:56:21.199888','',50,0,1600,7052,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(264,'2024-10-24','2024-10-27 10:56:21.204892','',50,0,250,7054,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,5000),(265,'2024-10-24','2024-10-27 10:56:21.208895','',50,0,285,7059,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,5700),(266,'2024-10-24','2024-10-27 10:56:21.213898','',50,0,500,7060,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,5000),(267,'2024-10-24','2024-10-27 10:56:21.218902','',1.5,0,785.7,7055,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,2910),(268,'2024-10-24','2024-10-27 10:56:21.223905','',48,0,90,6993,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1401),(269,'2024-10-24','2024-10-27 10:56:21.229909','',48,0,90,6994,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1401),(270,'2024-10-24','2024-10-27 10:56:21.239916','',48,0,45,6995,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1422),(271,'2024-10-24','2024-10-27 10:56:21.254927','',48,0,90,6997,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1401),(272,'2024-10-24','2024-10-27 10:56:21.261932','',48,0,90,6999,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1401),(273,'2024-10-24','2024-10-27 10:56:21.268937','',48,751673,90,7001,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,753123),(274,'2024-10-24','2024-10-27 10:56:21.274941','',48,476995,45,7003,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,478350),(275,'2024-10-24','2024-10-27 10:56:21.281946','',48,820854,45,7005,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,821985),(276,'2024-10-24','2024-10-27 10:56:21.289952','',48,429022,45,7007,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,430240),(277,'2024-10-24','2024-10-27 10:56:21.296957','',48,858086,90,7009,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,859270),(278,'2024-10-24','2024-10-27 10:56:21.303962','',48,281382,90,7047,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,282440),(279,'2024-10-24','2024-10-27 10:56:21.309966','',48,201835,45,7048,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,202895),(280,'2024-10-24','2024-10-27 10:56:21.316971','',45,155665,90,7049,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,156950),(281,'2024-10-24','2024-10-27 10:56:21.323976','',50,257060,45,7050,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,257565),(282,'2024-10-24','2024-10-27 10:56:21.330981','',48,0,285,7062,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(283,'2024-10-24','2024-10-27 10:56:21.336986','',45,0,257,7064,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(284,'2024-10-24','2024-10-27 10:56:21.343990','',48,0,300,7066,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(285,'2024-10-24','2024-10-27 10:56:21.349995','',48,0,305,7068,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(286,'2024-10-24','2024-10-27 10:56:21.355999','',48,0,110,7070,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(287,'2024-10-24','2024-10-27 10:56:21.371010','',0,0,0,7082,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(288,'2024-10-24','2024-10-27 10:56:21.378014','',48,0,210,7083,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(289,'2024-10-24','2024-10-27 10:56:21.384019','',48,0,671,7077,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(290,'2024-10-24','2024-10-27 10:56:21.389022','',0,0,0,7250,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(291,'2024-10-24','2024-10-27 10:56:21.395026','',48,0,288,7086,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,96,0),(292,'2024-10-24','2024-10-27 10:56:21.400030','',48,0,0,7119,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(293,'2024-10-24','2024-10-27 10:56:21.406034','',48,0,0,7120,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(294,'2024-10-24','2024-10-27 10:56:21.412040','',48,0,0,7121,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(295,'2024-10-24','2024-10-27 10:56:21.418043','',0,0,0,7122,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(296,'2024-10-24','2024-10-27 10:56:21.424047','',48,0,0,7123,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(297,'2024-10-24','2024-10-27 10:56:21.429050','',40,0,0,7124,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(298,'2024-10-24','2024-10-27 10:56:21.434055','',45,0,0,7084,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(299,'2024-10-24','2024-10-27 11:01:06.984060','',50,0,360,7053,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,7200),(300,'2024-10-24','2024-10-27 11:01:06.990064','',50,0,1200,7052,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,6),(301,'2024-10-24','2024-10-27 11:01:06.994067','',50,0,355,7054,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,7100),(302,'2024-10-24','2024-10-27 11:01:06.999071','',50,0,465,7059,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,9300),(303,'2024-10-24','2024-10-27 11:01:07.004075','',50,0,750,7060,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,7500),(304,'2024-10-24','2024-10-27 11:01:07.010078','',1.5,0,1080,7055,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,4000),(305,'2024-10-24','2024-10-27 11:01:07.014081','',48,0,45,6993,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1416),(306,'2024-10-24','2024-10-27 11:01:07.019085','',48,0,45,6994,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1419),(307,'2024-10-24','2024-10-27 11:01:07.024088','',48,0,45,6995,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1425),(308,'2024-10-24','2024-10-27 11:01:07.029091','',48,0,45,6997,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1428),(309,'2024-10-24','2024-10-27 11:01:07.038098','',48,0,45,6999,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1425),(310,'2024-10-24','2024-10-27 11:01:07.044103','',48,753123,45,7001,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,754608),(311,'2024-10-24','2024-10-27 11:01:07.050107','',48,478350,45,7003,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,479762),(312,'2024-10-24','2024-10-27 11:01:07.056110','',48,821985,90,7005,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,823109),(313,'2024-10-24','2024-10-27 11:01:07.061115','',48,430240,45,7007,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,431452),(314,'2024-10-24','2024-10-27 11:01:07.066118','',48,859270,45,7009,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,860459),(315,'2024-10-24','2024-10-27 11:01:07.071122','',48,282440,45,7047,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,283542),(316,'2024-10-24','2024-10-27 11:01:07.076125','',48,202895,90,7048,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,204009),(317,'2024-10-24','2024-10-27 11:01:07.082130','',45,156950,90,7049,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,158335),(318,'2024-10-24','2024-10-27 11:01:07.089134','',50,257565,45,7050,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,258569),(319,'2024-10-24','2024-10-27 11:01:07.095139','',48,0,329,7062,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(320,'2024-10-24','2024-10-27 11:01:07.102143','',50,0,285,7064,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(321,'2024-10-24','2024-10-27 11:01:07.108148','',48,0,310,7066,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(322,'2024-10-24','2024-10-27 11:01:07.115153','',48,0,290,7068,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(323,'2024-10-24','2024-10-27 11:01:07.128162','',48,0,185,7070,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(324,'2024-10-24','2024-10-27 11:01:07.139171','',0,0,0,7082,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(325,'2024-10-24','2024-10-27 11:01:07.155182','',48,0,145,7083,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(326,'2024-10-24','2024-10-27 11:01:07.163187','',48,0,761,7077,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(327,'2024-10-24','2024-10-27 11:01:07.170192','',0,0,0,7250,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(328,'2024-10-24','2024-10-27 11:01:07.178198','',48,0,0,7086,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(329,'2024-10-24','2024-10-27 11:01:07.184202','',48,0,288,7119,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,96,0),(330,'2024-10-24','2024-10-27 11:01:07.191207','',48,0,0,7120,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(331,'2024-10-24','2024-10-27 11:01:07.197212','',48,0,432,7121,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,144,0),(332,'2024-10-24','2024-10-27 11:01:07.204216','',0,0,0,7122,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(333,'2024-10-24','2024-10-27 11:01:07.210220','',48,0,432,7123,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,144,0),(334,'2024-10-24','2024-10-27 11:01:07.216225','',40,0,57,7124,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,19,0),(335,'2024-10-24','2024-10-27 11:01:07.223230','',45,0,231,7084,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,77,0),(336,'2024-10-25','2024-10-27 11:08:28.203823','',50,0,360,7053,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,7200),(337,'2024-10-25','2024-10-27 11:08:28.209828','',50,0,1400,7052,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,7),(338,'2024-10-25','2024-10-27 11:08:28.214830','',50,0,350,7054,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,7000),(339,'2024-10-25','2024-10-27 11:08:28.221836','',50,0,482.5,7059,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,9650),(340,'2024-10-25','2024-10-27 11:08:28.227840','',50,0,755,7060,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,7550),(341,'2024-10-25','2024-10-27 11:08:28.238847','',1.5,0,1161,7055,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,4300),(342,'2024-10-25','2024-10-27 11:08:28.244852','',48,0,45,6993,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1428),(343,'2024-10-25','2024-10-27 11:08:28.255860','',48,0,90,6994,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1398),(344,'2024-10-25','2024-10-27 11:08:28.262865','',48,0,90,6995,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1392),(345,'2024-10-25','2024-10-27 11:08:28.270871','',48,0,90,6997,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1410),(346,'2024-10-25','2024-10-27 11:08:28.277875','',48,0,0,6999,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1398),(347,'2024-10-25','2024-10-27 11:08:28.284880','',48,754608,45,7001,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,755999),(348,'2024-10-25','2024-10-27 11:08:28.292886','',48,479762,90,7003,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,481275),(349,'2024-10-25','2024-10-27 11:08:28.298891','',48,823109,45,7005,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,824340),(350,'2024-10-25','2024-10-27 11:08:28.304895','',48,431452,90,7007,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,432720),(351,'2024-10-25','2024-10-27 11:08:28.311900','',48,860459,90,7009,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,861719),(352,'2024-10-25','2024-10-27 11:08:28.318905','',48,283542,45,7047,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,284610),(353,'2024-10-25','2024-10-27 11:08:28.324910','',50,204009,45,7048,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,205235),(354,'2024-10-25','2024-10-27 11:08:28.331913','',45,158335,0,7049,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,159380),(355,'2024-10-25','2024-10-27 11:08:28.337918','',50,258569,45,7050,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,259525),(356,'2024-10-25','2024-10-27 11:08:28.344924','',48,0,278,7062,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(357,'2024-10-25','2024-10-27 11:08:28.351928','',50,0,322,7064,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(358,'2024-10-25','2024-10-27 11:08:28.359934','',48,0,290,7066,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(359,'2024-10-25','2024-10-27 11:08:28.368940','',48,0,300,7068,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(360,'2024-10-25','2024-10-27 11:08:28.378947','',48,0,105,7070,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(361,'2024-10-25','2024-10-27 11:08:28.389955','',0,0,0,7082,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(362,'2024-10-25','2024-10-27 11:08:28.395959','',48,0,200,7083,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(363,'2024-10-25','2024-10-27 11:08:28.401964','',48,0,694,7077,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(364,'2024-10-25','2024-10-27 11:08:28.409969','',0,0,0,7250,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(365,'2024-10-25','2024-10-27 11:08:28.418976','',48,0,0,7086,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(366,'2024-10-25','2024-10-27 11:08:28.426981','',48,0,0,7119,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(367,'2024-10-25','2024-10-27 11:08:28.433987','',48,0,0,7120,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(368,'2024-10-25','2024-10-27 11:08:28.441992','',48,0,144,7121,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,48,0),(369,'2024-10-25','2024-10-27 11:08:28.461005','',0,0,0,7122,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(370,'2024-10-25','2024-10-27 11:08:28.467010','',48,0,144,7123,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,48,0),(371,'2024-10-25','2024-10-27 11:08:28.481019','',40,0,12,7124,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,4,0),(372,'2024-10-25','2024-10-27 11:08:28.498032','',45,0,234,7084,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,78,0),(373,'2024-10-25','2024-10-27 11:11:33.332416','',50,0,385,7053,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,7700),(374,'2024-10-25','2024-10-27 11:11:33.340422','',50,0,1600,7052,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(375,'2024-10-25','2024-10-27 11:11:33.346426','',50,0,375,7054,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,7500),(376,'2024-10-25','2024-10-27 11:11:33.353432','',50,0,480,7059,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,9600),(377,'2024-10-25','2024-10-27 11:11:33.368442','',50,0,840,7060,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,8400),(378,'2024-10-25','2024-10-27 11:11:33.375447','',1.5,0,1080,7055,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,4000),(379,'2024-10-25','2024-10-27 11:11:33.382452','',48,0,90,6993,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1356),(380,'2024-10-25','2024-10-27 11:11:33.389457','',48,0,45,6994,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1398),(381,'2024-10-25','2024-10-27 11:11:33.396463','',48,0,45,6995,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1368),(382,'2024-10-25','2024-10-27 11:11:33.402466','',48,0,45,6997,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1398),(383,'2024-10-25','2024-10-27 11:11:33.408471','',48,0,90,6999,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1365),(384,'2024-10-25','2024-10-27 11:11:33.414475','',48,755999,90,7001,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,757370),(385,'2024-10-25','2024-10-27 11:11:33.421480','',48,481275,45,7003,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,482582),(386,'2024-10-25','2024-10-27 11:11:33.429486','',48,824340,45,7005,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,825595),(387,'2024-10-25','2024-10-27 11:11:33.435490','',48,432720,45,7007,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,433890),(388,'2024-10-25','2024-10-27 11:11:33.443496','',48,861719,45,7009,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,862900),(389,'2024-10-25','2024-10-27 11:11:33.450500','',48,284610,90,7047,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,285515),(390,'2024-10-25','2024-10-27 11:11:33.456504','',50,205235,45,7048,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,206242),(391,'2024-10-25','2024-10-27 11:11:33.461508','',45,159380,90,7049,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,160493),(392,'2024-10-25','2024-10-27 11:11:33.466512','',50,0,0,7050,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(393,'2024-10-25','2024-10-27 11:11:33.472516','',48,0,175,7062,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(394,'2024-10-25','2024-10-27 11:11:33.477519','',50,0,300,7064,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(395,'2024-10-25','2024-10-27 11:11:33.483524','',48,0,300,7066,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(396,'2024-10-25','2024-10-27 11:11:33.488528','',48,0,300,7068,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(397,'2024-10-25','2024-10-27 11:11:33.493531','',48,0,225,7070,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(398,'2024-10-25','2024-10-27 11:11:33.502537','',0,0,0,7082,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(399,'2024-10-25','2024-10-27 11:11:33.507541','',48,0,220,7083,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(400,'2024-10-25','2024-10-27 11:11:33.512544','',48,0,705,7077,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(401,'2024-10-25','2024-10-27 11:11:33.518548','',0,0,0,7250,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(402,'2024-10-25','2024-10-27 11:11:33.525554','',48,0,0,7086,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(403,'2024-10-25','2024-10-27 11:11:33.531558','',48,0,0,7119,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(404,'2024-10-25','2024-10-27 11:11:33.557576','',48,0,0,7120,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(405,'2024-10-25','2024-10-27 11:11:33.563581','',48,0,0,7121,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(406,'2024-10-25','2024-10-27 11:11:33.574589','',0,0,0,7122,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(407,'2024-10-25','2024-10-27 11:11:33.580592','',48,0,0,7123,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(408,'2024-10-25','2024-10-27 11:11:33.586597','',40,0,0,7124,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(409,'2024-10-25','2024-10-27 11:11:33.592601','',45,0,0,7084,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(410,'2024-10-23','2024-10-28 08:37:55.205213','',0,0,0,7061,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(411,'2024-10-24','2024-10-28 09:18:57.472784','',0,0,0,7061,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(412,'2024-10-26','2024-10-28 10:00:38.640071','',50,0,150,7053,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,3000),(413,'2024-10-26','2024-10-28 10:00:38.652080','',50,0,1000,7052,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,5),(414,'2024-10-26','2024-10-28 10:00:38.663088','',50,0,285,7054,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,5700),(415,'2024-10-26','2024-10-28 10:00:38.695110','',50,0,325,7059,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,6500),(416,'2024-10-26','2024-10-28 10:00:38.712122','',50,0,350,7060,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,3500),(417,'2024-10-26','2024-10-28 10:00:38.721129','',1.5,0,1161,7055,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,4300),(418,'2024-10-26','2024-10-28 10:00:38.727134','',48,0,45,6993,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1416),(419,'2024-10-26','2024-10-28 10:00:38.735139','',50,0,0,6994,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1380),(420,'2024-10-26','2024-10-28 10:00:38.742144','',48,0,45,6995,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1419),(421,'2024-10-26','2024-10-28 10:00:38.750149','',48,0,90,6997,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1371),(422,'2024-10-26','2024-10-28 10:00:38.756154','',50,0,45,6999,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1392),(423,'2024-10-26','2024-10-28 10:00:38.763159','',48,757370,45,7001,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,758900),(424,'2024-10-26','2024-10-28 10:00:38.770165','',48,482582,90,7003,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,483922),(425,'2024-10-26','2024-10-28 10:00:38.777169','',48,825595,90,7005,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,826842),(426,'2024-10-26','2024-10-28 10:00:38.787176','',48,433890,90,7007,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,435060),(427,'2024-10-26','2024-10-28 10:00:38.794181','',48,862900,45,7009,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,864097),(428,'2024-10-26','2024-10-28 10:00:38.802186','',50,285515,0,7047,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,286533),(429,'2024-10-26','2024-10-28 10:00:38.809191','',50,206242,45,7048,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,206910),(430,'2024-10-26','2024-10-28 10:00:38.816196','',50,160493,45,7049,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,161626),(431,'2024-10-26','2024-10-28 10:00:38.822201','',50,259525,45,7050,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,260468),(432,'2024-10-26','2024-10-28 10:00:38.829206','',48,0,0,7062,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(433,'2024-10-26','2024-10-28 10:00:38.836211','',50,0,284,7064,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(434,'2024-10-26','2024-10-28 10:00:38.844217','',48,0,245,7066,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(435,'2024-10-26','2024-10-28 10:00:38.851222','',48,0,290,7068,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(436,'2024-10-26','2024-10-28 10:00:38.858226','',48,0,167,7070,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(437,'2024-10-26','2024-10-28 10:00:38.869235','',0,0,0,7082,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(438,'2024-10-26','2024-10-28 10:00:38.876239','',1.75,0,218.75,7083,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,125,0),(439,'2024-10-26','2024-10-28 10:00:38.882243','',1.75,0,992.25,7077,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,567,0),(440,'2024-10-26','2024-10-28 10:00:38.889248','',0,0,0,7250,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(441,'2024-10-26','2024-10-28 10:00:38.896253','',48,0,288,7086,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,96,0),(442,'2024-10-26','2024-10-28 10:00:38.904259','',48,0,0,7119,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(443,'2024-10-26','2024-10-28 10:00:38.910263','',48,0,0,7120,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(444,'2024-10-26','2024-10-28 10:00:38.915266','',48,0,0,7121,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(445,'2024-10-26','2024-10-28 10:00:38.922272','',48,0,0,7122,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(446,'2024-10-26','2024-10-28 10:00:38.928276','',48,0,0,7123,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(447,'2024-10-26','2024-10-28 10:00:38.933279','',45,0,0,7124,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(448,'2024-10-26','2024-10-28 10:00:38.938283','',45,0,0,7084,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(449,'2024-10-26','2024-10-28 10:11:16.739959','',50,0,0,7053,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(450,'2024-10-26','2024-10-28 10:11:16.751967','',50,0,1000,7052,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,5),(451,'2024-10-26','2024-10-28 10:11:16.761975','',50,0,217.5,7054,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,4350),(452,'2024-10-26','2024-10-28 10:11:16.787993','',50,0,540,7059,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,10800),(453,'2024-10-26','2024-10-28 10:11:16.794998','',50,0,930,7060,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,9300),(454,'2024-10-26','2024-10-28 10:11:16.808007','',1.5,0,1350,7055,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,5000),(455,'2024-10-26','2024-10-28 10:11:16.817014','',48,0,45,6993,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1422),(456,'2024-10-26','2024-10-28 10:11:16.825020','',50,0,45,6994,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1422),(457,'2024-10-26','2024-10-28 10:11:16.838029','',48,0,45,6995,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1419),(458,'2024-10-26','2024-10-28 10:11:16.851038','',48,0,45,6997,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1419),(459,'2024-10-26','2024-10-28 10:11:16.859043','',50,0,45,6999,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1422),(460,'2024-10-26','2024-10-28 10:11:16.865048','',48,758900,45,7001,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,760260),(461,'2024-10-26','2024-10-28 10:11:16.873054','',48,483922,45,7003,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,485399),(462,'2024-10-26','2024-10-28 10:11:16.880059','',48,826842,45,7005,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,828216),(463,'2024-10-26','2024-10-28 10:11:16.887063','',48,435060,0,7007,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,435978),(464,'2024-10-26','2024-10-28 10:11:16.894069','',48,864097,45,7009,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,865410),(465,'2024-10-26','2024-10-28 10:11:16.899072','',50,286533,90,7047,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,287582),(466,'2024-10-26','2024-10-28 10:11:16.905077','',50,206910,45,7048,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,208050),(467,'2024-10-26','2024-10-28 10:11:16.913082','',50,161626,45,7049,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,162858),(468,'2024-10-26','2024-10-28 10:11:16.918085','',50,260468,90,7050,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,261435),(469,'2024-10-26','2024-10-28 10:11:16.922089','',48,0,0,7062,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(470,'2024-10-26','2024-10-28 10:11:16.927091','',50,0,338,7064,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(471,'2024-10-26','2024-10-28 10:11:16.933096','',48,0,255,7066,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(472,'2024-10-26','2024-10-28 10:11:16.939100','',48,0,310,7068,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(473,'2024-10-26','2024-10-28 10:11:16.944104','',48,0,200,7070,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(474,'2024-10-26','2024-10-28 10:11:16.953110','',0,0,0,7082,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(475,'2024-10-26','2024-10-28 10:11:16.959115','',48,0,160,7083,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(476,'2024-10-26','2024-10-28 10:11:16.964118','',45,0,787,7077,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(477,'2024-10-26','2024-10-28 10:11:16.972124','',0,0,0,7250,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(478,'2024-10-26','2024-10-28 10:11:16.977127','',48,0,288,7086,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,96,0),(479,'2024-10-26','2024-10-28 10:11:16.989136','',48,0,0,7119,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(480,'2024-10-26','2024-10-28 10:11:16.994139','',48,0,570,7120,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,190,0),(481,'2024-10-26','2024-10-28 10:11:16.999143','',48,0,288,7121,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,96,0),(482,'2024-10-26','2024-10-28 10:11:17.005147','',48,0,0,7122,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(483,'2024-10-26','2024-10-28 10:11:17.010151','',48,0,432,7123,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,144,0),(484,'2024-10-26','2024-10-28 10:11:17.015154','',45,0,0,7124,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(485,'2024-10-26','2024-10-28 10:11:17.020158','',45,0,0,7084,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(486,'2024-10-26','2024-10-28 10:16:55.473681','',50,0,290,7053,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,5800),(487,'2024-10-26','2024-10-28 10:16:55.485691','',50,0,1800,7052,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,9),(488,'2024-10-26','2024-10-28 10:16:55.494696','',50,0,290,7054,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,5800),(489,'2024-10-26','2024-10-28 10:16:55.503702','',50,0,320,7059,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,6400),(490,'2024-10-26','2024-10-28 10:16:55.510707','',50,0,490,7060,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,4900),(491,'2024-10-26','2024-10-28 10:16:55.517712','',1.5,0,783,7055,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,2900),(492,'2024-10-26','2024-10-28 10:16:55.524718','',48,0,90,6993,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1401),(493,'2024-10-26','2024-10-28 10:16:55.530722','',50,0,90,6994,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1386),(494,'2024-10-26','2024-10-28 10:16:55.536726','',48,0,90,6995,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1401),(495,'2024-10-26','2024-10-28 10:16:55.542731','',48,0,90,6997,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1401),(496,'2024-10-26','2024-10-28 10:16:55.549735','',50,0,90,6999,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1401),(497,'2024-10-26','2024-10-28 10:16:55.556740','',48,760260,90,7001,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,761755),(498,'2024-10-26','2024-10-28 10:16:55.562745','',48,485399,90,7003,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,486754),(499,'2024-10-26','2024-10-28 10:16:55.568748','',48,828216,45,7005,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,829470),(500,'2024-10-26','2024-10-28 10:16:55.574753','',48,435978,90,7007,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,437223),(501,'2024-10-26','2024-10-28 10:16:55.580757','',48,865410,45,7009,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,866670),(502,'2024-10-26','2024-10-28 10:16:55.589764','',50,287582,45,7047,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,288630),(503,'2024-10-26','2024-10-28 10:16:55.596769','',50,208050,45,7048,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,209090),(504,'2024-10-26','2024-10-28 10:16:55.601772','',50,162858,90,7049,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,164082),(505,'2024-10-26','2024-10-28 10:16:55.607777','',50,261435,45,7050,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,262368),(506,'2024-10-26','2024-10-28 10:16:55.620786','',48,0,0,7062,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(507,'2024-10-26','2024-10-28 10:16:55.627790','',50,0,365,7064,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(508,'2024-10-26','2024-10-28 10:16:55.632794','',48,0,290,7066,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(509,'2024-10-26','2024-10-28 10:16:55.637798','',50,0,290,7068,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(510,'2024-10-26','2024-10-28 10:16:55.643802','',48,0,230,7070,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(511,'2024-10-26','2024-10-28 10:16:55.651808','',0,0,0,7082,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(512,'2024-10-26','2024-10-28 10:16:55.657812','',48,0,180,7083,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(513,'2024-10-26','2024-10-28 10:16:55.662816','',48,0,697,7077,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(514,'2024-10-26','2024-10-28 10:16:55.666818','',0,0,0,7250,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(515,'2024-10-26','2024-10-28 10:16:55.671822','',48,0,0,7086,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(516,'2024-10-26','2024-10-28 10:16:55.677826','',48,0,0,7119,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(517,'2024-10-26','2024-10-28 10:16:55.682830','',48,0,0,7120,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(518,'2024-10-26','2024-10-28 10:16:55.687833','',48,0,0,7121,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(519,'2024-10-26','2024-10-28 10:16:55.693837','',48,0,0,7122,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(520,'2024-10-26','2024-10-28 10:16:55.698841','',48,0,144,7123,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,48,0),(521,'2024-10-26','2024-10-28 10:16:55.702844','',45,0,573,7124,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,191,0),(522,'2024-10-26','2024-10-28 10:16:55.709849','',45,0,0,7084,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(523,'2024-10-26','2024-10-28 10:20:21.609414','',0,0,0,7061,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(524,'2024-10-27','2024-10-28 11:17:46.779313','',50,0,210,7053,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,4200),(525,'2024-10-27','2024-10-28 11:17:46.812336','',50,0,400,7052,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,2),(526,'2024-10-27','2024-10-28 11:17:46.819341','',50,0,225,7054,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,4500),(527,'2024-10-27','2024-10-28 11:17:46.848362','',50,0,310,7059,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,6200),(528,'2024-10-27','2024-10-28 11:17:46.901400','',50,0,500,7060,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,5000),(529,'2024-10-27','2024-10-28 11:17:46.908405','',1.5,0,0,7055,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,0),(530,'2024-10-27','2024-10-28 11:17:46.915410','',48,0,45,6993,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1410),(531,'2024-10-27','2024-10-28 11:17:46.920414','',50,0,45,6994,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1419),(532,'2024-10-27','2024-10-28 11:17:46.925417','',48,0,45,6995,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1419),(533,'2024-10-27','2024-10-28 11:17:46.930420','',48,0,45,6997,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1413),(534,'2024-10-27','2024-10-28 11:17:46.934423','',50,0,45,6999,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1428),(535,'2024-10-27','2024-10-28 11:17:46.939427','',48,761755,45,7001,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,763197),(536,'2024-10-27','2024-10-28 11:17:46.959441','',48,486754,45,7003,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,488076),(537,'2024-10-27','2024-10-28 11:17:47.005000','',48,829470,90,7005,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,830700),(538,'2024-10-27','2024-10-28 11:17:47.047030','',50,437223,45,7007,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,438460),(539,'2024-10-27','2024-10-28 11:17:47.064042','',48,866670,0,7009,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,867930),(540,'2024-10-27','2024-10-28 11:17:47.071548','',50,288630,45,7047,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,289685),(541,'2024-10-27','2024-10-28 11:17:47.077552','',50,209090,90,7048,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,210237),(542,'2024-10-27','2024-10-28 11:17:47.083056','',50,164082,45,7049,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,165387),(543,'2024-10-27','2024-10-28 11:17:47.099567','',50,262368,45,7050,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,263397),(544,'2024-10-27','2024-10-28 11:17:47.119081','',48,0,0,7062,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(545,'2024-10-27','2024-10-28 11:17:47.124585','',50,0,310,7064,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(546,'2024-10-27','2024-10-28 11:17:47.139596','',48,0,290,7066,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(547,'2024-10-27','2024-10-28 11:17:47.144600','',50,0,330,7068,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(548,'2024-10-27','2024-10-28 11:17:47.149603','',48,0,36,7070,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(549,'2024-10-27','2024-10-28 11:17:47.157609','',0,0,0,7082,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(550,'2024-10-27','2024-10-28 11:17:47.163113','',48,0,120,7083,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(551,'2024-10-27','2024-10-28 11:17:47.168116','',48,0,789,7077,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(552,'2024-10-27','2024-10-28 11:17:47.173120','',0,0,0,7250,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(553,'2024-10-27','2024-10-28 11:17:47.178623','',48,0,0,7086,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(554,'2024-10-27','2024-10-28 11:17:47.185129','',48,0,288,7119,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,96,0),(555,'2024-10-27','2024-10-28 11:17:47.191633','',48,0,0,7120,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(556,'2024-10-27','2024-10-28 11:17:47.199139','',48,0,279,7121,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,93,0),(557,'2024-10-27','2024-10-28 11:17:47.206143','',48,0,0,7122,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(558,'2024-10-27','2024-10-28 11:17:47.213649','',48,0,0,7123,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(559,'2024-10-27','2024-10-28 11:17:47.220153','',45,0,0,7124,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(560,'2024-10-27','2024-10-28 11:17:47.226657','',45,0,0,7084,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(561,'2024-10-27','2024-10-28 11:22:43.145313','',50,0,373.25,7053,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,7465),(562,'2024-10-27','2024-10-28 11:22:43.157322','',50,0,1600,7052,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(563,'2024-10-27','2024-10-28 11:22:43.162325','',50,0,347.5,7054,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,6950),(564,'2024-10-27','2024-10-28 11:22:43.169330','',50,0,525,7059,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,10500),(565,'2024-10-27','2024-10-28 11:22:43.175335','',50,0,760,7060,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,7600),(566,'2024-10-27','2024-10-28 11:22:43.182340','',1.5,0,1080,7055,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,4000),(567,'2024-10-27','2024-10-28 11:22:43.190345','',48,0,45,6993,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1410),(568,'2024-10-27','2024-10-28 11:22:43.195349','',50,0,90,6994,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1422),(569,'2024-10-27','2024-10-28 11:22:43.200352','',48,0,45,6995,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1425),(570,'2024-10-27','2024-10-28 11:22:43.204355','',48,0,0,6997,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1335),(571,'2024-10-27','2024-10-28 11:22:43.209359','',50,0,45,6999,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1425),(572,'2024-10-27','2024-10-28 11:22:43.215363','',48,763197,45,7001,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,764598),(573,'2024-10-27','2024-10-28 11:22:43.220367','',48,488076,0,7003,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,489399),(574,'2024-10-27','2024-10-28 11:22:43.226371','',48,830700,45,7005,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,832085),(575,'2024-10-27','2024-10-28 11:22:43.232375','',50,438460,90,7007,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,439770),(576,'2024-10-27','2024-10-28 11:22:43.267401','',48,867930,45,7009,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,869246),(577,'2024-10-27','2024-10-28 11:22:43.290416','',50,289685,45,7047,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,290780),(578,'2024-10-27','2024-10-28 11:22:43.295420','',50,210237,45,7048,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,211410),(579,'2024-10-27','2024-10-28 11:22:43.300423','',50,165387,45,7049,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,166699),(580,'2024-10-27','2024-10-28 11:22:43.305427','',50,263397,45,7050,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,264163),(581,'2024-10-27','2024-10-28 11:22:43.311432','',48,0,0,7062,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(582,'2024-10-27','2024-10-28 11:22:43.317436','',50,0,355,7064,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(583,'2024-10-27','2024-10-28 11:22:43.322439','',48,0,330,7066,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(584,'2024-10-27','2024-10-28 11:22:43.327443','',50,0,350,7068,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(585,'2024-10-27','2024-10-28 11:22:43.332446','',48,0,20,7070,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(586,'2024-10-27','2024-10-28 11:22:43.340452','',0,0,0,7082,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(587,'2024-10-27','2024-10-28 11:22:43.345456','',48,0,170,7083,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(588,'2024-10-27','2024-10-28 11:22:43.350459','',48,0,731,7077,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(589,'2024-10-27','2024-10-28 11:22:43.355462','',0,0,0,7250,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(590,'2024-10-27','2024-10-28 11:22:43.361467','',48,0,288,7086,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,96,0),(591,'2024-10-27','2024-10-28 11:22:43.365470','',48,0,288,7119,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,96,0),(592,'2024-10-27','2024-10-28 11:22:43.369472','',48,0,0,7120,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(593,'2024-10-27','2024-10-28 11:22:43.375477','',48,0,0,7121,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(594,'2024-10-27','2024-10-28 11:22:43.380481','',48,0,0,7122,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(595,'2024-10-27','2024-10-28 11:22:43.385485','',48,0,0,7123,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(596,'2024-10-27','2024-10-28 11:22:43.394490','',45,0,0,7124,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(597,'2024-10-27','2024-10-28 11:22:43.399494','',45,0,234,7084,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,78,0),(598,'2024-10-27','2024-10-28 11:26:34.036082','',50,0,315,7053,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,6300),(599,'2024-10-27','2024-10-28 11:26:34.047089','',50,0,1600,7052,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(600,'2024-10-27','2024-10-28 11:26:34.054094','',50,0,200,7054,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,4000),(601,'2024-10-27','2024-10-28 11:26:34.069105','',50,0,390,7059,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,7800),(602,'2024-10-27','2024-10-28 11:26:34.076110','',50,0,340,7060,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,3400),(603,'2024-10-27','2024-10-28 11:26:34.082114','',1.5,0,945,7055,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,3500),(604,'2024-10-27','2024-10-28 11:26:34.087118','',48,0,90,6993,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1401),(605,'2024-10-27','2024-10-28 11:26:34.107132','',50,0,45,6994,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1410),(606,'2024-10-27','2024-10-28 11:26:34.113137','',48,0,90,6995,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1395),(607,'2024-10-27','2024-10-28 11:26:34.118140','',48,0,90,6997,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1392),(608,'2024-10-27','2024-10-28 11:26:34.126146','',50,0,45,6999,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1377),(609,'2024-10-27','2024-10-28 11:26:34.132150','',48,764598,90,7001,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,766076),(610,'2024-10-27','2024-10-28 11:26:34.139155','',48,489399,45,7003,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,490805),(611,'2024-10-27','2024-10-28 11:26:34.145159','',48,832085,45,7005,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,833360),(612,'2024-10-27','2024-10-28 11:26:34.150163','',50,439770,45,7007,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,441025),(613,'2024-10-27','2024-10-28 11:26:34.155166','',48,869246,90,7009,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,870500),(614,'2024-10-27','2024-10-28 11:26:34.160169','',50,290780,45,7047,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,291820),(615,'2024-10-27','2024-10-28 11:26:34.165173','',50,211410,45,7048,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,212470),(616,'2024-10-27','2024-10-28 11:26:34.174180','',50,166699,45,7049,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,167997),(617,'2024-10-27','2024-10-28 11:26:34.180184','',50,264163,90,7050,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,265120),(618,'2024-10-27','2024-10-28 11:26:34.185188','',48,0,0,7062,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(619,'2024-10-27','2024-10-28 11:26:34.191192','',50,0,300,7064,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(620,'2024-10-27','2024-10-28 11:26:34.197196','',48,0,305,7066,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(621,'2024-10-27','2024-10-28 11:26:34.202199','',50,0,270,7068,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(622,'2024-10-27','2024-10-28 11:26:34.207203','',48,0,0,7070,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(623,'2024-10-27','2024-10-28 11:26:34.217210','',0,0,0,7082,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(624,'2024-10-27','2024-10-28 11:26:34.222214','',48,0,170,7083,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(625,'2024-10-27','2024-10-28 11:26:34.228218','',48,0,719,7077,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(626,'2024-10-27','2024-10-28 11:26:34.232220','',0,0,0,7250,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(627,'2024-10-27','2024-10-28 11:26:34.237224','',48,0,0,7086,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(628,'2024-10-27','2024-10-28 11:26:34.242228','',48,0,0,7119,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(629,'2024-10-27','2024-10-28 11:26:34.247232','',48,0,0,7120,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(630,'2024-10-27','2024-10-28 11:26:34.253263','',48,0,0,7121,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(631,'2024-10-27','2024-10-28 11:26:34.258767','',48,0,0,7122,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(632,'2024-10-27','2024-10-28 11:26:34.264772','',48,0,0,7123,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(633,'2024-10-27','2024-10-28 11:26:34.269775','',45,0,288,7124,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,96,0),(634,'2024-10-27','2024-10-28 11:26:34.274278','',45,0,234,7084,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,78,0),(635,'2024-10-28','2024-10-30 05:45:32.666758','',50,0,300,7053,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,6000),(636,'2024-10-28','2024-10-30 05:45:32.678766','',50,0,200,7052,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1),(637,'2024-10-28','2024-10-30 05:45:32.685772','',50,0,350,7054,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,7000),(638,'2024-10-28','2024-10-30 05:45:32.692777','',50,0,375,7059,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,7500),(639,'2024-10-28','2024-10-30 05:45:32.699782','',50,0,750,7060,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,7500),(640,'2024-10-28','2024-10-30 05:45:32.705786','',1.5,0,1350,7055,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,5000),(641,'2024-10-28','2024-10-30 05:45:32.711790','',48,0,45,6993,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1425),(642,'2024-10-28','2024-10-30 05:45:32.717795','',50,0,90,6994,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1392),(643,'2024-10-28','2024-10-30 05:45:32.723799','',48,0,45,6995,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1425),(644,'2024-10-28','2024-10-30 05:45:32.728802','',50,0,45,6997,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1419),(645,'2024-10-28','2024-10-30 05:45:32.734806','',50,0,90,6999,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1395),(646,'2024-10-28','2024-10-30 05:45:32.740811','',48,766076,0,7001,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,767177),(647,'2024-10-28','2024-10-30 05:45:32.745814','',50,490805,45,7003,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,492132),(648,'2024-10-28','2024-10-30 05:45:32.752820','',50,833360,90,7005,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,834558),(649,'2024-10-28','2024-10-30 05:45:32.758823','',50,441025,90,7007,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,442247),(650,'2024-10-28','2024-10-30 05:45:32.765829','',48,870500,45,7009,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,871757),(651,'2024-10-28','2024-10-30 05:45:32.772834','',50,291820,45,7047,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,292838),(652,'2024-10-28','2024-10-30 05:45:32.778838','',50,212470,90,7048,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,213467),(653,'2024-10-28','2024-10-30 05:45:32.784842','',50,167997,90,7049,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,169250),(654,'2024-10-28','2024-10-30 05:45:32.790846','',50,265120,45,7050,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,266110),(655,'2024-10-28','2024-10-30 05:45:32.795850','',48,0,0,7062,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(656,'2024-10-28','2024-10-30 05:45:32.801854','',50,0,370,7064,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(657,'2024-10-28','2024-10-30 05:45:32.806858','',50,0,255,7066,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(658,'2024-10-28','2024-10-30 05:45:32.812862','',50,0,310,7068,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(659,'2024-10-28','2024-10-30 05:45:32.818867','',48,0,44,7070,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(660,'2024-10-28','2024-10-30 05:45:32.826872','',0,0,0,7082,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(661,'2024-10-28','2024-10-30 05:45:32.831876','',48,0,120,7083,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(662,'2024-10-28','2024-10-30 05:45:32.836879','',48,0,701,7077,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(663,'2024-10-28','2024-10-30 05:45:32.842884','',0,0,0,7250,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(664,'2024-10-28','2024-10-30 05:45:32.847887','',48,0,288,7086,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,96,0),(665,'2024-10-28','2024-10-30 05:45:32.852891','',48,0,0,7119,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(666,'2024-10-28','2024-10-30 05:45:32.857894','',48,0,0,7120,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(667,'2024-10-28','2024-10-30 05:45:32.862898','',48,0,0,7121,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(668,'2024-10-28','2024-10-30 05:45:32.867901','',48,0,0,7122,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(669,'2024-10-28','2024-10-30 05:45:32.871904','',48,0,432,7123,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,144,0),(670,'2024-10-28','2024-10-30 05:45:32.875907','',45,0,288,7124,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,96,0),(671,'2024-10-28','2024-10-30 05:45:32.880910','',45,0,0,7084,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(672,'2024-10-28','2024-10-30 05:54:49.835415','',50,0,280,7053,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,5600),(673,'2024-10-28','2024-10-30 05:54:49.842421','',50,0,1600,7052,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(674,'2024-10-28','2024-10-30 05:54:49.847424','',50,0,375,7054,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,7500),(675,'2024-10-28','2024-10-30 05:54:49.851427','',50,0,520,7059,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,10400),(676,'2024-10-28','2024-10-30 05:54:49.856430','',50,0,800,7060,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,8000),(677,'2024-10-28','2024-10-30 05:54:49.863436','',1.5,0,1080,7055,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,4000),(678,'2024-10-28','2024-10-30 05:54:49.868439','',48,0,45,6993,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1410),(679,'2024-10-28','2024-10-30 05:54:49.873442','',50,0,45,6994,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1398),(680,'2024-10-28','2024-10-30 05:54:49.877445','',48,0,45,6995,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1413),(681,'2024-10-28','2024-10-30 05:54:49.881448','',50,0,45,6997,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1404),(682,'2024-10-28','2024-10-30 05:54:49.885451','',50,0,45,6999,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1422),(683,'2024-10-28','2024-10-30 05:54:49.890454','',50,767177,45,7001,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,768535),(684,'2024-10-28','2024-10-30 05:54:49.894457','',50,492132,45,7003,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,493555),(685,'2024-10-28','2024-10-30 05:54:49.900462','',50,834558,0,7005,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,835420),(686,'2024-10-28','2024-10-30 05:54:49.923478','',50,442247,45,7007,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,443499),(687,'2024-10-28','2024-10-30 05:54:49.935487','',50,871757,0,7009,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,872930),(688,'2024-10-28','2024-10-30 05:54:49.941492','',50,292838,45,7047,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,293864),(689,'2024-10-28','2024-10-30 05:54:49.953500','',50,213467,45,7048,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,214599),(690,'2024-10-28','2024-10-30 05:54:49.961505','',50,169250,45,7049,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,170536),(691,'2024-10-28','2024-10-30 05:54:49.970511','',50,266110,45,7050,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,267040),(692,'2024-10-28','2024-10-30 05:54:49.976516','',48,0,160,7062,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(693,'2024-10-28','2024-10-30 05:54:49.987523','',50,0,348,7064,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(694,'2024-10-28','2024-10-30 05:54:49.991527','',50,0,300,7066,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(695,'2024-10-28','2024-10-30 05:54:50.006537','',50,0,331,7068,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(696,'2024-10-28','2024-10-30 05:54:50.013542','',48,0,150,7070,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(697,'2024-10-28','2024-10-30 05:54:50.029554','',0,0,0,7082,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(698,'2024-10-28','2024-10-30 05:54:50.036559','',48,0,180,7083,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(699,'2024-10-28','2024-10-30 05:54:50.043092','',48,0,723,7077,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(700,'2024-10-28','2024-10-30 05:54:50.050096','',0,0,0,7250,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(701,'2024-10-28','2024-10-30 05:54:50.056101','',48,0,0,7086,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(702,'2024-10-28','2024-10-30 05:54:50.062105','',48,0,0,7119,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(703,'2024-10-28','2024-10-30 05:54:50.067609','',48,0,432,7120,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,144,0),(704,'2024-10-28','2024-10-30 05:54:50.073614','',48,0,288,7121,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,96,0),(705,'2024-10-28','2024-10-30 05:54:50.079117','',48,0,0,7122,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(706,'2024-10-28','2024-10-30 05:54:50.085122','',48,0,144,7123,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,48,0),(707,'2024-10-28','2024-10-30 05:54:50.091626','',45,0,0,7124,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(708,'2024-10-28','2024-10-30 05:54:50.097630','',45,0,0,7084,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(709,'2024-10-28','2024-10-30 05:59:28.127021','',0,0,0,7061,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(710,'2024-10-28','2024-10-30 06:00:46.213507','',50,0,365,7053,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,7300),(711,'2024-10-28','2024-10-30 06:00:46.264043','',50,0,1000,7052,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,5),(712,'2024-10-28','2024-10-30 06:00:46.291062','',50,0,315,7054,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,6300),(713,'2024-10-28','2024-10-30 06:00:46.447673','',50,0,500,7059,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,10000),(714,'2024-10-28','2024-10-30 06:00:46.602784','',50,0,700,7060,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,7000),(715,'2024-10-28','2024-10-30 06:00:46.736880','',1.5,0,1107,7055,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,4100),(716,'2024-10-28','2024-10-30 06:00:46.842454','',48,0,90,6993,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1341),(717,'2024-10-28','2024-10-30 06:00:46.918508','',50,0,90,6994,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1398),(718,'2024-10-28','2024-10-30 06:00:46.960538','',48,0,90,6995,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1389),(719,'2024-10-28','2024-10-30 06:00:47.032089','',50,0,45,6997,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1419),(720,'2024-10-28','2024-10-30 06:00:47.136163','',50,0,45,6999,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1416),(721,'2024-10-28','2024-10-30 06:00:47.274761','',50,768535,90,7001,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,770094),(722,'2024-10-28','2024-10-30 06:00:47.425368','',50,493555,90,7003,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,494997),(723,'2024-10-28','2024-10-30 06:00:47.537448','',50,835420,45,7005,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,836598),(724,'2024-10-28','2024-10-30 06:00:47.625010','',50,443499,45,7007,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,444698),(725,'2024-10-28','2024-10-30 06:00:47.706068','',50,872930,90,7009,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,874187),(726,'2024-10-28','2024-10-30 06:00:47.727083','',50,293864,45,7047,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,294898),(727,'2024-10-28','2024-10-30 06:00:47.764109','',50,214599,45,7048,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,215694),(728,'2024-10-28','2024-10-30 06:00:47.845166','',50,170536,45,7049,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,171749),(729,'2024-10-28','2024-10-30 06:00:48.073829','',50,267040,45,7050,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,268034),(730,'2024-10-28','2024-10-30 06:00:48.225937','',48,0,0,7062,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(731,'2024-10-28','2024-10-30 06:00:48.258460','',50,0,255,7064,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(732,'2024-10-28','2024-10-30 06:00:48.364035','',50,0,320,7066,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(733,'2024-10-28','2024-10-30 06:00:48.459603','',50,0,365,7068,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(734,'2024-10-28','2024-10-30 06:00:48.623220','',50,0,200,7070,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(735,'2024-10-28','2024-10-30 06:00:48.840874','',0,0,0,7082,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(736,'2024-10-28','2024-10-30 06:00:48.987478','',48,0,192,7083,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(737,'2024-10-28','2024-10-30 06:00:49.069036','',50,0,710,7077,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(738,'2024-10-28','2024-10-30 06:00:49.155598','',0,0,0,7250,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(739,'2024-10-28','2024-10-30 06:00:49.223146','',48,0,0,7086,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(740,'2024-10-28','2024-10-30 06:00:49.362244','',50,0,0,7119,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(741,'2024-10-28','2024-10-30 06:00:49.513351','',50,0,0,7120,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(742,'2024-10-28','2024-10-30 06:00:49.587905','',48,0,288,7121,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,96,0),(743,'2024-10-28','2024-10-30 06:00:49.648448','',0,0,0,7122,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(744,'2024-10-28','2024-10-30 06:00:49.719999','',48,0,0,7123,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(745,'2024-10-28','2024-10-30 06:00:49.806560','',45,0,0,7124,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(746,'2024-10-28','2024-10-30 06:00:49.883615','',45,0,0,7084,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(747,'2024-10-28','2024-10-30 06:05:07.748006','',0,0,0,7061,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(748,'2024-10-30','2024-10-30 09:10:17.775690','',50,0,200,7053,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,4000),(749,'2024-10-30','2024-10-30 09:10:17.783695','',50,0,400,7052,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,2),(750,'2024-10-30','2024-10-30 09:10:17.792703','',50,0,315,7054,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,6300),(751,'2024-10-30','2024-10-30 09:10:17.807712','',50,0,500,7059,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,10000),(752,'2024-10-30','2024-10-30 09:10:17.814717','',50,0,900,7060,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,9000),(753,'2024-10-30','2024-10-30 09:10:17.824724','',1.5,0,1377,7055,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,5100),(754,'2024-10-30','2024-10-30 09:10:17.830728','',48,0,45,6993,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,702),(755,'2024-10-30','2024-10-30 09:10:17.842737','',50,0,90,6994,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1416),(756,'2024-10-30','2024-10-30 09:10:17.848741','',48,0,45,6995,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1410),(757,'2024-10-30','2024-10-30 09:10:17.858750','',50,0,45,6997,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1401),(758,'2024-10-30','2024-10-30 09:10:17.865753','',50,0,45,6999,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1401),(759,'2024-10-30','2024-10-30 09:10:17.876762','',50,770094,45,7001,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,771588),(760,'2024-10-30','2024-10-30 09:10:17.883766','',50,494997,90,7003,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,496461),(761,'2024-10-30','2024-10-30 09:10:17.891772','',50,836598,45,7005,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,837842),(762,'2024-10-30','2024-10-30 09:10:17.896776','',50,444698,45,7007,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,445919),(763,'2024-10-30','2024-10-30 09:10:17.900779','',50,874187,45,7009,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,875419),(764,'2024-10-30','2024-10-30 09:10:17.957819','',50,294898,45,7047,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,295915),(765,'2024-10-30','2024-10-30 09:10:18.009440','',50,215694,45,7048,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,216759),(766,'2024-10-30','2024-10-30 09:10:18.020947','',50,171749,45,7049,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,172950),(767,'2024-10-30','2024-10-30 09:10:18.029453','',50,268034,45,7050,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,268969),(768,'2024-10-30','2024-10-30 09:10:18.034457','',48,0,148,7062,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(769,'2024-10-30','2024-10-30 09:10:18.043463','',50,0,361,7064,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(770,'2024-10-30','2024-10-30 09:10:18.047466','',50,0,270,7066,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(771,'2024-10-30','2024-10-30 09:10:18.052970','',50,0,285,7068,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(772,'2024-10-30','2024-10-30 09:10:18.060976','',50,0,77,7070,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(773,'2024-10-30','2024-10-30 09:10:18.073985','',0,0,0,7082,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(774,'2024-10-30','2024-10-30 09:10:18.079989','',48,0,125,7083,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(775,'2024-10-30','2024-10-30 09:10:18.084993','',50,0,771,7077,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(776,'2024-10-30','2024-10-30 09:10:18.089496','',0,0,0,7250,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(777,'2024-10-30','2024-10-30 09:10:18.094500','',48,0,0,7086,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(778,'2024-10-30','2024-10-30 09:10:18.103506','',48,0,0,7119,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(779,'2024-10-30','2024-10-30 09:10:18.110010','',50,0,186,7120,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,62,0),(780,'2024-10-30','2024-10-30 09:10:18.117516','',48,0,84,7121,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,28,0),(781,'2024-10-30','2024-10-30 09:10:18.174556','',48,0,0,7122,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(782,'2024-10-30','2024-10-30 09:10:18.195071','',48,0,0,7123,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(783,'2024-10-30','2024-10-30 09:10:18.255113','',45,0,210,7124,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,70,0),(784,'2024-10-30','2024-10-30 09:10:18.289639','',45,0,0,7084,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(785,'2024-10-29','2024-10-30 09:26:44.076043','',50,0,260,7053,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,5200),(786,'2024-10-29','2024-10-30 09:26:44.086051','',50,0,1400,7052,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,7),(787,'2024-10-29','2024-10-30 09:26:44.094057','',50,0,340,7054,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,6800),(788,'2024-10-29','2024-10-30 09:26:44.101062','',50,0,440,7059,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8800),(789,'2024-10-29','2024-10-30 09:26:44.106065','',50,0,680,7060,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,6800),(790,'2024-10-29','2024-10-30 09:26:44.111068','',1.5,0,1350,7055,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,5000),(791,'2024-10-29','2024-10-30 09:26:44.116073','',50,0,45,6993,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1410),(792,'2024-10-29','2024-10-30 09:26:44.121076','',50,0,90,6994,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1410),(793,'2024-10-29','2024-10-30 09:26:44.126079','',48,0,0,6995,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1290),(794,'2024-10-29','2024-10-30 09:26:44.131083','',50,0,45,6997,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1419),(795,'2024-10-29','2024-10-30 09:26:44.137087','',50,0,45,6999,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1413),(796,'2024-10-29','2024-10-30 09:26:44.145093','',50,771588,45,7001,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,773060),(797,'2024-10-29','2024-10-30 09:26:44.149095','',50,496461,45,7003,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,497942),(798,'2024-10-29','2024-10-30 09:26:44.154099','',50,837842,45,7005,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,839146),(799,'2024-10-29','2024-10-30 09:26:44.158102','',50,445919,45,7007,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,447141),(800,'2024-10-29','2024-10-30 09:26:44.163106','',50,875419,45,7009,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,876688),(801,'2024-10-29','2024-10-30 09:26:44.168109','',50,295915,45,7047,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,296963),(802,'2024-10-29','2024-10-30 09:26:44.173113','',50,216759,45,7048,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,217875),(803,'2024-10-29','2024-10-30 09:26:44.180117','',50,172950,45,7049,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,174219),(804,'2024-10-29','2024-10-30 09:26:44.185121','',50,268969,45,7050,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,269875),(805,'2024-10-29','2024-10-30 09:26:44.189124','',48,0,192,7062,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(806,'2024-10-29','2024-10-30 09:26:44.194127','',50,0,335,7064,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(807,'2024-10-29','2024-10-30 09:26:44.198131','',50,0,275,7066,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(808,'2024-10-29','2024-10-30 09:26:44.203134','',50,0,315,7068,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(809,'2024-10-29','2024-10-30 09:26:44.207137','',50,0,176,7070,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(810,'2024-10-29','2024-10-30 09:26:44.215143','',0,0,0,7082,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(811,'2024-10-29','2024-10-30 09:26:44.220146','',48,0,168,7083,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(812,'2024-10-29','2024-10-30 09:26:44.225150','',50,0,749,7077,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(813,'2024-10-29','2024-10-30 09:26:44.230154','',0,0,0,7250,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(814,'2024-10-29','2024-10-30 09:26:44.235157','',48,0,288,7086,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,96,0),(815,'2024-10-29','2024-10-30 09:26:44.239160','',50,0,144,7119,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,48,0),(816,'2024-10-29','2024-10-30 09:26:44.244164','',50,0,0,7120,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(817,'2024-10-29','2024-10-30 09:26:44.249167','',48,0,0,7121,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(818,'2024-10-29','2024-10-30 09:26:44.254170','',0,0,0,7122,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(819,'2024-10-29','2024-10-30 09:26:44.260175','',48,0,432,7123,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,144,0),(820,'2024-10-29','2024-10-30 09:26:44.266179','',45,0,288,7124,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,96,0),(821,'2024-10-29','2024-10-30 09:26:44.272183','',45,0,234,7084,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,78,0),(822,'2024-10-29','2024-10-30 09:41:08.753190','',50,0,250,7053,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,5000),(823,'2024-10-29','2024-10-30 09:41:08.771703','',50,0,1600,7052,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8),(824,'2024-10-29','2024-10-30 09:41:08.800723','',50,0,290,7054,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,5800),(825,'2024-10-29','2024-10-30 09:41:08.819236','',50,0,385,7059,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,7700),(826,'2024-10-29','2024-10-30 09:41:08.830745','',50,0,770,7060,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,7700),(827,'2024-10-29','2024-10-30 09:41:08.867270','',1.5,0,1247.4,7055,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,4620),(828,'2024-10-29','2024-10-30 09:41:08.935318','',50,0,90,6993,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1392),(829,'2024-10-29','2024-10-30 09:41:08.961337','',50,0,45,6994,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1419),(830,'2024-10-29','2024-10-30 09:41:08.966841','',50,0,45,6995,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1413),(831,'2024-10-29','2024-10-30 09:41:08.975347','',50,0,45,6997,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1380),(832,'2024-10-29','2024-10-30 09:41:08.980850','',50,0,45,6999,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1404),(833,'2024-10-29','2024-10-30 09:41:08.985854','',50,773066,90,7001,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,774534),(834,'2024-10-29','2024-10-30 09:41:08.995361','',50,497942,45,7003,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,499385),(835,'2024-10-29','2024-10-30 09:41:09.008871','',50,839146,90,7005,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,840412),(836,'2024-10-29','2024-10-30 09:41:09.016877','',50,447141,90,7007,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,448367),(837,'2024-10-29','2024-10-30 09:41:09.023882','',50,876688,45,7009,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,877507),(838,'2024-10-29','2024-10-30 09:41:09.030887','',50,296963,45,7047,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,298980),(839,'2024-10-29','2024-10-30 09:41:09.037892','',50,217875,45,7048,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,218945),(840,'2024-10-29','2024-10-30 09:41:09.045397','',50,174219,90,7049,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,175359),(841,'2024-10-29','2024-10-30 09:41:09.052402','',50,269875,45,7050,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,270763),(842,'2024-10-29','2024-10-30 09:41:09.059907','',48,0,143,7062,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(843,'2024-10-29','2024-10-30 09:41:09.066913','',50,0,340,7064,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(844,'2024-10-29','2024-10-30 09:41:09.074919','',50,0,280,7066,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(845,'2024-10-29','2024-10-30 09:41:09.083424','',50,0,305,7068,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(846,'2024-10-29','2024-10-30 09:41:09.091429','',50,0,195,7070,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(847,'2024-10-29','2024-10-30 09:41:09.102938','',0,0,0,7082,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(848,'2024-10-29','2024-10-30 09:41:09.109942','',48,0,172,7083,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(849,'2024-10-29','2024-10-30 09:41:09.117949','',50,0,702,7077,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(850,'2024-10-29','2024-10-30 09:41:09.124453','',0,0,0,7250,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(851,'2024-10-29','2024-10-30 09:41:09.131458','',48,0,0,7086,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(852,'2024-10-29','2024-10-30 09:41:09.140465','',50,0,144,7119,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,48,0),(853,'2024-10-29','2024-10-30 09:41:09.147469','',50,0,0,7120,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(854,'2024-10-29','2024-10-30 09:41:09.154474','',48,0,0,7121,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(855,'2024-10-29','2024-10-30 09:41:09.160979','',0,0,0,7122,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(856,'2024-10-29','2024-10-30 09:41:09.172987','',48,0,144,7123,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,48,0),(857,'2024-10-29','2024-10-30 09:41:09.178992','',45,0,0,7124,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(858,'2024-10-29','2024-10-30 09:41:09.191000','',45,0,0,7084,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(859,'2024-10-29','2024-10-30 09:45:01.409524','',0,0,0,7061,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(860,'2024-10-29','2024-10-31 07:00:56.729098','',50,0,0,7053,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(861,'2024-10-29','2024-10-31 07:00:56.741107','',50,0,0,7052,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(862,'2024-10-29','2024-10-31 07:00:56.748112','',50,0,0,7054,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(863,'2024-10-29','2024-10-31 07:00:56.754116','',50,0,0,7059,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(864,'2024-10-29','2024-10-31 07:00:56.760120','',50,0,0,7060,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,0),(865,'2024-10-29','2024-10-31 07:00:56.765124','',1.5,0,1350,7055,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,5000),(866,'2024-10-29','2024-10-31 07:00:56.771128','',50,0,0,6993,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,702),(867,'2024-10-29','2024-10-31 07:00:56.780134','',50,0,45,6994,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1416),(868,'2024-10-29','2024-10-31 07:00:56.789141','',48,0,45,6995,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1410),(869,'2024-10-29','2024-10-31 07:00:56.794144','',50,0,90,6997,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1401),(870,'2024-10-29','2024-10-31 07:00:56.807154','',50,0,90,6999,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,1401),(871,'2024-10-29','2024-10-31 07:00:56.814159','',50,770094,45,7001,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,771588),(872,'2024-10-29','2024-10-31 07:00:56.825167','',50,494997,45,7003,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,496461),(873,'2024-10-29','2024-10-31 07:00:56.831171','',50,836598,45,7005,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,837842),(874,'2024-10-29','2024-10-31 07:00:56.841178','',50,444698,90,7007,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,445919),(875,'2024-10-29','2024-10-31 07:00:56.847182','',50,874187,45,7009,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,875419),(876,'2024-10-29','2024-10-31 07:00:56.859190','',50,294898,45,7047,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,295915),(877,'2024-10-29','2024-10-31 07:00:56.864194','',50,215694,90,7048,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,216759),(878,'2024-10-29','2024-10-31 07:00:56.875202','',50,171749,90,7049,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,172950),(879,'2024-10-29','2024-10-31 07:00:56.880205','',50,268034,90,7050,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,268969),(880,'2024-10-29','2024-10-31 07:00:56.894216','',48,0,0,7062,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(881,'2024-10-29','2024-10-31 07:00:56.904227','',50,0,0,7064,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(882,'2024-10-29','2024-10-31 07:00:56.912228','',50,0,0,7066,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(883,'2024-10-29','2024-10-31 07:00:56.923237','',50,0,0,7068,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(884,'2024-10-29','2024-10-31 07:00:56.928240','',50,0,0,7070,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(885,'2024-10-29','2024-10-31 07:00:56.942249','',0,0,0,7082,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(886,'2024-10-29','2024-10-31 07:00:56.947253','',48,0,0,7083,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(887,'2024-10-29','2024-10-31 07:00:56.958353','',50,0,0,7077,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(888,'2024-10-29','2024-10-31 07:00:56.967360','',0,0,0,7250,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(889,'2024-10-29','2024-10-31 07:00:56.976867','',48,0,288,7086,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,96,0),(890,'2024-10-29','2024-10-31 07:00:56.987375','',50,0,288,7119,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,96,0),(891,'2024-10-29','2024-10-31 07:00:56.995880','',50,0,0,7120,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(892,'2024-10-29','2024-10-31 07:00:57.009389','',48,0,0,7121,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(893,'2024-10-29','2024-10-31 07:00:57.015894','',48,0,0,7122,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(894,'2024-10-29','2024-10-31 07:00:57.025901','',48,0,0,7123,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(895,'2024-10-29','2024-10-31 07:00:57.032406','',45,0,288,7124,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,96,0),(896,'2024-10-29','2024-10-31 07:00:57.041413','',45,0,231,7084,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,77,0),(897,'2024-10-30','2024-11-02 10:05:57.240162','',50,0,0,7053,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(898,'2024-10-30','2024-11-02 10:05:57.290197','',50,0,0,7052,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(899,'2024-10-30','2024-11-02 10:05:57.312713','',50,0,0,7054,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(900,'2024-10-30','2024-11-02 10:05:57.369754','',50,0,0,7059,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(901,'2024-10-30','2024-11-02 10:05:57.398774','',50,0,0,7060,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,0),(902,'2024-10-30','2024-11-02 10:05:57.481833','',1.5,0,850.5,7055,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,3150),(903,'2024-10-30','2024-11-02 10:05:57.526365','',50,0,45,6993,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(904,'2024-10-30','2024-11-02 10:05:57.566393','',50,0,90,6994,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(905,'2024-10-30','2024-11-02 10:05:57.628437','',50,0,90,6995,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(906,'2024-10-30','2024-11-02 10:05:57.717500','',50,0,45,6997,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(907,'2024-10-30','2024-11-02 10:05:57.759030','',50,0,90,6999,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(908,'2024-10-30','2024-11-02 10:05:57.801560','',50,0,45,7001,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(909,'2024-10-30','2024-11-02 10:05:57.828079','',50,0,45,7003,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(910,'2024-10-30','2024-11-02 10:05:57.847593','',50,0,45,7005,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(911,'2024-10-30','2024-11-02 10:05:57.901632','',50,0,45,7007,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(912,'2024-10-30','2024-11-02 10:05:58.036228','',50,0,45,7009,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(913,'2024-10-30','2024-11-02 10:05:58.164319','',50,0,45,7047,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(914,'2024-10-30','2024-11-02 10:05:58.282902','',50,0,45,7048,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(915,'2024-10-30','2024-11-02 10:05:58.467034','',50,0,90,7049,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(916,'2024-10-30','2024-11-02 10:05:58.648663','',50,0,90,7050,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(917,'2024-10-30','2024-11-02 10:05:58.781257','',48,0,0,7062,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(918,'2024-10-30','2024-11-02 10:05:58.882829','',50,0,0,7064,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(919,'2024-10-30','2024-11-02 10:05:58.912350','',50,0,0,7066,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(920,'2024-10-30','2024-11-02 10:05:58.988905','',50,0,0,7068,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(921,'2024-10-30','2024-11-02 10:05:59.079970','',50,0,0,7070,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(922,'2024-10-30','2024-11-02 10:05:59.221070','',0,0,0,7082,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(923,'2024-10-30','2024-11-02 10:05:59.237080','',48,0,0,7083,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(924,'2024-10-30','2024-11-02 10:05:59.300125','',50,0,0,7077,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(925,'2024-10-30','2024-11-02 10:05:59.329146','',0,0,0,7250,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(926,'2024-10-30','2024-11-02 10:05:59.387187','',48,0,333,7086,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,111,0),(927,'2024-10-30','2024-11-02 10:05:59.410203','',48,0,225,7119,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,75,0),(928,'2024-10-30','2024-11-02 10:05:59.470247','',48,0,36,7120,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,12,0),(929,'2024-10-30','2024-11-02 10:05:59.602840','',48,0,60,7121,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,0),(930,'2024-10-30','2024-11-02 10:05:59.664885','',48,0,0,7122,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(931,'2024-10-30','2024-11-02 10:05:59.705413','',48,0,0,7123,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(932,'2024-10-30','2024-11-02 10:05:59.753948','',45,0,0,7124,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(933,'2024-10-30','2024-11-02 10:05:59.780467','',45,0,0,7084,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(934,'2024-10-30','2024-11-02 10:06:39.015346','',50,0,0,7053,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(935,'2024-10-30','2024-11-02 10:06:39.026855','',50,0,0,7052,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(936,'2024-10-30','2024-11-02 10:06:39.034360','',50,0,0,7054,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(937,'2024-10-30','2024-11-02 10:06:39.042866','',50,0,0,7059,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(938,'2024-10-30','2024-11-02 10:06:39.050371','',50,0,0,7060,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,0),(939,'2024-10-30','2024-11-02 10:06:39.058377','',1.5,0,918,7055,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,3400),(940,'2024-10-30','2024-11-02 10:06:39.065882','',50,0,45,6993,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(941,'2024-10-30','2024-11-02 10:06:39.075889','',50,0,45,6994,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(942,'2024-10-30','2024-11-02 10:06:39.084896','',50,0,45,6995,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(943,'2024-10-30','2024-11-02 10:06:39.092902','',50,0,90,6997,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(944,'2024-10-30','2024-11-02 10:06:39.100407','',50,0,45,6999,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(945,'2024-10-30','2024-11-02 10:06:39.106411','',50,0,45,7001,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(946,'2024-10-30','2024-11-02 10:06:39.112415','',50,0,45,7003,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(947,'2024-10-30','2024-11-02 10:06:39.119420','',50,0,45,7005,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(948,'2024-10-30','2024-11-02 10:06:39.129928','',50,0,45,7007,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(949,'2024-10-30','2024-11-02 10:06:39.136932','',50,0,90,7009,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(950,'2024-10-30','2024-11-02 10:06:39.142937','',50,0,45,7047,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(951,'2024-10-30','2024-11-02 10:06:39.148941','',50,0,90,7048,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(952,'2024-10-30','2024-11-02 10:06:39.154945','',50,0,0,7049,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(953,'2024-10-30','2024-11-02 10:06:39.162951','',50,0,45,7050,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(954,'2024-10-30','2024-11-02 10:06:39.168955','',48,0,0,7062,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(955,'2024-10-30','2024-11-02 10:06:39.175460','',50,0,0,7064,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(956,'2024-10-30','2024-11-02 10:06:39.182965','',50,0,0,7066,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(957,'2024-10-30','2024-11-02 10:06:39.188969','',50,0,0,7068,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(958,'2024-10-30','2024-11-02 10:06:39.196475','',50,0,0,7070,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(959,'2024-10-30','2024-11-02 10:06:39.210485','',0,0,0,7082,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(960,'2024-10-30','2024-11-02 10:06:39.215989','',48,0,0,7083,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(961,'2024-10-30','2024-11-02 10:06:39.223494','',50,0,0,7077,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(962,'2024-10-30','2024-11-02 10:06:39.230499','',0,0,0,7250,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(963,'2024-10-30','2024-11-02 10:06:39.240006','',48,0,0,7086,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(964,'2024-10-30','2024-11-02 10:06:39.246511','',50,0,12,7119,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,4,0),(965,'2024-10-30','2024-11-02 10:06:39.253515','',50,0,351,7120,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,117,0),(966,'2024-10-30','2024-11-02 10:06:39.262522','',48,0,423,7121,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,141,0),(967,'2024-10-30','2024-11-02 10:06:39.268526','',48,0,0,7122,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(968,'2024-10-30','2024-11-02 10:06:39.274030','',48,0,0,7123,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(969,'2024-10-30','2024-11-02 10:06:39.285038','',45,0,369,7124,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,123,0),(970,'2024-10-30','2024-11-02 10:06:39.292043','',45,0,234,7084,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,78,0),(971,'2024-10-31','2024-11-02 10:07:06.717055','',50,0,0,7053,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(972,'2024-10-31','2024-11-02 10:07:06.726061','',50,0,0,7052,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(973,'2024-10-31','2024-11-02 10:07:06.734067','',50,0,0,7054,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(974,'2024-10-31','2024-11-02 10:07:06.741072','',50,0,0,7059,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(975,'2024-10-31','2024-11-02 10:07:06.747076','',50,0,0,7060,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,0),(976,'2024-10-31','2024-11-02 10:07:06.761086','',1.5,0,1350,7055,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,5000),(977,'2024-10-31','2024-11-02 10:07:06.772095','',50,0,90,6993,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(978,'2024-10-31','2024-11-02 10:07:06.778098','',50,0,0,6994,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(979,'2024-10-31','2024-11-02 10:07:06.785104','',50,0,45,6995,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(980,'2024-10-31','2024-11-02 10:07:06.792108','',50,0,45,6997,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(981,'2024-10-31','2024-11-02 10:07:06.801114','',50,0,45,6999,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(982,'2024-10-31','2024-11-02 10:07:06.808119','',50,0,90,7001,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(983,'2024-10-31','2024-11-02 10:07:06.814124','',50,0,90,7003,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(984,'2024-10-31','2024-11-02 10:07:06.821129','',50,0,90,7005,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(985,'2024-10-31','2024-11-02 10:07:06.828134','',50,0,90,7007,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(986,'2024-10-31','2024-11-02 10:07:06.834138','',50,0,45,7009,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(987,'2024-10-31','2024-11-02 10:07:06.840143','',50,0,45,7047,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(988,'2024-10-31','2024-11-02 10:07:06.851150','',50,0,45,7048,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(989,'2024-10-31','2024-11-02 10:07:06.856153','',50,0,45,7049,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(990,'2024-10-31','2024-11-02 10:07:06.861157','',50,0,0,7050,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(991,'2024-10-31','2024-11-02 10:07:06.866161','',48,0,0,7062,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(992,'2024-10-31','2024-11-02 10:07:06.872165','',50,0,0,7064,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(993,'2024-10-31','2024-11-02 10:07:06.889177','',50,0,0,7066,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(994,'2024-10-31','2024-11-02 10:07:06.899184','',50,0,0,7068,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(995,'2024-10-31','2024-11-02 10:07:06.923201','',50,0,0,7070,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(996,'2024-10-31','2024-11-02 10:07:06.962229','',0,0,0,7082,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(997,'2024-10-31','2024-11-02 10:07:06.982243','',48,0,0,7083,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(998,'2024-10-31','2024-11-02 10:07:06.991250','',50,0,0,7077,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(999,'2024-10-31','2024-11-02 10:07:06.996253','',0,0,0,7250,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1000,'2024-10-31','2024-11-02 10:07:07.002257','',48,0,243,7086,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,81,0),(1001,'2024-10-31','2024-11-02 10:07:07.006260','',50,0,198,7119,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,66,0),(1002,'2024-10-31','2024-11-02 10:07:07.020270','',50,0,0,7120,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(1003,'2024-10-31','2024-11-02 10:07:07.030278','',48,0,0,7121,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(1004,'2024-10-31','2024-11-02 10:07:07.035281','',48,0,0,7122,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(1005,'2024-10-31','2024-11-02 10:07:07.040285','',48,0,0,7123,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(1006,'2024-10-31','2024-11-02 10:07:07.045288','',45,0,0,7124,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(1007,'2024-10-31','2024-11-02 10:07:07.050292','',45,0,234,7084,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,78,0),(1008,'2024-10-31','2024-11-02 10:07:31.515781','',50,0,0,7053,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1009,'2024-10-31','2024-11-02 10:07:31.531791','',50,0,0,7052,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1010,'2024-10-31','2024-11-02 10:07:31.536795','',50,0,0,7054,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1011,'2024-10-31','2024-11-02 10:07:31.542799','',50,0,0,7059,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1012,'2024-10-31','2024-11-02 10:07:31.548803','',50,0,0,7060,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,0),(1013,'2024-10-31','2024-11-02 10:07:31.553808','',1.5,0,1080,7055,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,4000),(1014,'2024-10-31','2024-11-02 10:07:31.559812','',50,0,45,6993,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1015,'2024-10-31','2024-11-02 10:07:31.565815','',50,0,90,6994,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1016,'2024-10-31','2024-11-02 10:07:31.572821','',50,0,45,6995,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1017,'2024-10-31','2024-11-02 10:07:31.580826','',50,0,45,6997,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1018,'2024-10-31','2024-11-02 10:07:31.586831','',50,0,0,6999,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1019,'2024-10-31','2024-11-02 10:07:31.592835','',50,0,45,7001,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1020,'2024-10-31','2024-11-02 10:07:31.598840','',50,0,45,7003,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1021,'2024-10-31','2024-11-02 10:07:31.604844','',50,0,45,7005,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1022,'2024-10-31','2024-11-02 10:07:31.622856','',50,0,0,7007,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1023,'2024-10-31','2024-11-02 10:07:31.635866','',50,0,45,7009,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1024,'2024-10-31','2024-11-02 10:07:31.647874','',50,0,45,7047,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1025,'2024-10-31','2024-11-02 10:07:31.685901','',50,0,45,7048,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1026,'2024-10-31','2024-11-02 10:07:31.710919','',50,0,45,7049,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1027,'2024-10-31','2024-11-02 10:07:31.731934','',50,0,45,7050,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1028,'2024-10-31','2024-11-02 10:07:31.742942','',48,0,0,7062,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1029,'2024-10-31','2024-11-02 10:07:31.749947','',50,0,0,7064,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1030,'2024-10-31','2024-11-02 10:07:31.756951','',50,0,0,7066,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1031,'2024-10-31','2024-11-02 10:07:31.764958','',50,0,0,7068,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1032,'2024-10-31','2024-11-02 10:07:31.771962','',50,0,0,7070,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1033,'2024-10-31','2024-11-02 10:07:31.784972','',0,0,0,7082,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1034,'2024-10-31','2024-11-02 10:07:31.791976','',48,0,0,7083,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1035,'2024-10-31','2024-11-02 10:07:31.799982','',50,0,0,7077,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1036,'2024-10-31','2024-11-02 10:07:31.808989','',0,0,0,7250,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1037,'2024-10-31','2024-11-02 10:07:31.815993','',48,0,0,7086,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(1038,'2024-10-31','2024-11-02 10:07:31.823999','',50,0,135,7119,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,45,0),(1039,'2024-10-31','2024-11-02 10:07:31.831005','',50,0,255,7120,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,85,0),(1040,'2024-10-31','2024-11-02 10:07:31.838009','',48,0,0,7121,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(1041,'2024-10-31','2024-11-02 10:07:31.849017','',48,0,0,7122,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(1042,'2024-10-31','2024-11-02 10:07:31.855021','',48,0,573,7123,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,191,0),(1043,'2024-10-31','2024-11-02 10:07:31.863027','',45,0,0,7124,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(1044,'2024-10-31','2024-11-02 10:07:31.870032','',45,0,0,7084,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(1045,'2024-10-31','2024-11-02 10:07:56.470176','',50,0,0,7053,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1046,'2024-10-31','2024-11-02 10:07:56.483186','',50,0,0,7052,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1047,'2024-10-31','2024-11-02 10:07:56.497196','',50,0,0,7054,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1048,'2024-10-31','2024-11-02 10:07:56.542227','',50,0,0,7059,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1049,'2024-10-31','2024-11-02 10:07:56.564243','',50,0,0,7060,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,0),(1050,'2024-10-31','2024-11-02 10:07:56.593263','',1.5,0,945,7055,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,3500),(1051,'2024-10-31','2024-11-02 10:07:56.623285','',50,0,45,6993,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1052,'2024-10-31','2024-11-02 10:07:56.634321','',50,0,45,6994,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1053,'2024-10-31','2024-11-02 10:07:56.642326','',50,0,45,6995,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1054,'2024-10-31','2024-11-02 10:07:56.650332','',50,0,45,6997,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1055,'2024-10-31','2024-11-02 10:07:56.658338','',50,0,45,6999,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1056,'2024-10-31','2024-11-02 10:07:56.675850','',50,0,45,7001,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1057,'2024-10-31','2024-11-02 10:07:56.683855','',50,0,45,7003,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1058,'2024-10-31','2024-11-02 10:07:56.691361','',50,0,45,7005,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1059,'2024-10-31','2024-11-02 10:07:56.698366','',50,0,90,7007,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1060,'2024-10-31','2024-11-02 10:07:56.705871','',50,0,90,7009,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1061,'2024-10-31','2024-11-02 10:07:56.712876','',50,0,90,7047,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1062,'2024-10-31','2024-11-02 10:07:56.720882','',50,0,90,7048,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1063,'2024-10-31','2024-11-02 10:07:56.727887','',50,0,90,7049,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1064,'2024-10-31','2024-11-02 10:07:56.736393','',50,0,90,7050,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1065,'2024-10-31','2024-11-02 10:07:56.743398','',48,0,0,7062,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1066,'2024-10-31','2024-11-02 10:07:56.750903','',50,0,0,7064,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1067,'2024-10-31','2024-11-02 10:07:56.758409','',50,0,0,7066,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1068,'2024-10-31','2024-11-02 10:07:56.767415','',50,0,0,7068,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1069,'2024-10-31','2024-11-02 10:07:56.773420','',50,0,0,7070,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1070,'2024-10-31','2024-11-02 10:07:56.787429','',0,0,0,7082,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1071,'2024-10-31','2024-11-02 10:07:56.792934','',48,0,0,7083,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1072,'2024-10-31','2024-11-02 10:07:56.798437','',50,0,0,7077,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1073,'2024-10-31','2024-11-02 10:07:56.804442','',0,0,0,7250,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1074,'2024-10-31','2024-11-02 10:07:56.809946','',48,0,0,7086,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(1075,'2024-10-31','2024-11-02 10:07:56.814949','',50,0,0,7119,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(1076,'2024-10-31','2024-11-02 10:07:56.821454','',50,0,15,7120,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5,0),(1077,'2024-10-31','2024-11-02 10:07:56.826957','',50,0,264,7121,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,88,0),(1078,'2024-10-31','2024-11-02 10:07:56.832461','',48,0,0,7122,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(1079,'2024-10-31','2024-11-02 10:07:56.838466','',48,0,0,7123,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(1080,'2024-10-31','2024-11-02 10:07:56.843970','',50,0,51,7124,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,17,0),(1081,'2024-10-31','2024-11-02 10:07:56.848473','',45,0,0,7084,0,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(1082,'2024-11-01','2024-11-02 10:08:16.410072','',50,0,0,7053,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1083,'2024-11-01','2024-11-02 10:08:16.417077','',50,0,0,7052,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1084,'2024-11-01','2024-11-02 10:08:16.430086','',50,0,0,7054,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1085,'2024-11-01','2024-11-02 10:08:16.438092','',50,0,0,7059,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1086,'2024-11-01','2024-11-02 10:08:16.445097','',50,0,0,7060,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,0),(1087,'2024-11-01','2024-11-02 10:08:16.453103','',1.5,0,1350,7055,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,5000),(1088,'2024-11-01','2024-11-02 10:08:16.460108','',50,0,45,6993,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1089,'2024-11-01','2024-11-02 10:08:16.467113','',50,0,90,6994,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1090,'2024-11-01','2024-11-02 10:08:16.476119','',50,0,90,6995,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1091,'2024-11-01','2024-11-02 10:08:16.484124','',50,0,90,6997,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1092,'2024-11-01','2024-11-02 10:08:16.491130','',50,0,90,6999,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1093,'2024-11-01','2024-11-02 10:08:16.498134','',50,0,45,7001,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1094,'2024-11-01','2024-11-02 10:08:16.505139','',50,0,45,7003,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1095,'2024-11-01','2024-11-02 10:08:16.512145','',50,0,90,7005,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1096,'2024-11-01','2024-11-02 10:08:16.525153','',50,0,45,7007,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1097,'2024-11-01','2024-11-02 10:08:16.531158','',50,0,45,7009,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1098,'2024-11-01','2024-11-02 10:08:16.537162','',50,0,45,7047,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1099,'2024-11-01','2024-11-02 10:08:16.543166','',50,0,45,7048,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1100,'2024-11-01','2024-11-02 10:08:16.549171','',50,0,45,7049,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1101,'2024-11-01','2024-11-02 10:08:16.556176','',50,0,45,7050,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1102,'2024-11-01','2024-11-02 10:08:16.561179','',48,0,0,7062,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1103,'2024-11-01','2024-11-02 10:08:16.566183','',50,0,0,7064,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1104,'2024-11-01','2024-11-02 10:08:16.571186','',50,0,0,7066,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1105,'2024-11-01','2024-11-02 10:08:16.583195','',50,0,0,7068,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1106,'2024-11-01','2024-11-02 10:08:16.589199','',50,0,0,7070,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1107,'2024-11-01','2024-11-02 10:08:16.599206','',0,0,0,7082,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1108,'2024-11-01','2024-11-02 10:08:16.604210','',48,0,0,7083,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1109,'2024-11-01','2024-11-02 10:08:16.610214','',50,0,0,7077,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1110,'2024-11-01','2024-11-02 10:08:16.615218','',0,0,0,7250,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1111,'2024-11-01','2024-11-02 10:08:16.621222','',48,0,0,7086,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(1112,'2024-11-01','2024-11-02 10:08:16.627226','',50,0,0,7119,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(1113,'2024-11-01','2024-11-02 10:08:16.632230','',50,0,48,7120,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,16,0),(1114,'2024-11-01','2024-11-02 10:08:16.638234','',50,0,186,7121,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,62,0),(1115,'2024-11-01','2024-11-02 10:08:16.644238','',48,0,0,7122,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(1116,'2024-11-01','2024-11-02 10:08:16.649243','',48,0,0,7123,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(1117,'2024-11-01','2024-11-02 10:08:16.653245','',50,0,429,7124,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,143,0),(1118,'2024-11-01','2024-11-02 10:08:16.660250','',45,0,0,7084,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(1119,'2024-11-01','2024-11-02 10:08:34.389056','',50,0,0,7053,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1120,'2024-11-01','2024-11-02 10:08:34.397061','',50,0,0,7052,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1121,'2024-11-01','2024-11-02 10:08:34.404066','',50,0,0,7054,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1122,'2024-11-01','2024-11-02 10:08:34.412072','',50,0,0,7059,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1123,'2024-11-01','2024-11-02 10:08:34.418076','',50,0,0,7060,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,0),(1124,'2024-11-01','2024-11-02 10:08:34.423079','',1.5,0,810,7055,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,3000),(1125,'2024-11-01','2024-11-02 10:08:34.430085','',50,0,90,6993,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1126,'2024-11-01','2024-11-02 10:08:34.435088','',50,0,45,6994,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1127,'2024-11-01','2024-11-02 10:08:34.443094','',50,0,45,6995,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1128,'2024-11-01','2024-11-02 10:08:34.450099','',50,0,0,6997,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1129,'2024-11-01','2024-11-02 10:08:34.455103','',50,0,45,6999,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1130,'2024-11-01','2024-11-02 10:08:34.461107','',50,0,90,7001,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1131,'2024-11-01','2024-11-02 10:08:34.466110','',50,0,0,7003,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1132,'2024-11-01','2024-11-02 10:08:34.472115','',50,0,45,7005,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1133,'2024-11-01','2024-11-02 10:08:34.478119','',50,0,90,7007,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1134,'2024-11-01','2024-11-02 10:08:34.484123','',50,0,45,7009,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1135,'2024-11-01','2024-11-02 10:08:34.490127','',50,0,45,7047,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1136,'2024-11-01','2024-11-02 10:08:34.497132','',50,0,45,7048,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1137,'2024-11-01','2024-11-02 10:08:34.503136','',50,0,45,7049,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1138,'2024-11-01','2024-11-02 10:08:34.508140','',50,0,45,7050,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1139,'2024-11-01','2024-11-02 10:08:34.524152','',48,0,0,7062,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1140,'2024-11-01','2024-11-02 10:08:34.532157','',50,0,0,7064,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1141,'2024-11-01','2024-11-02 10:08:34.538162','',50,0,0,7066,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1142,'2024-11-01','2024-11-02 10:08:34.547167','',50,0,0,7068,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1143,'2024-11-01','2024-11-02 10:08:34.552171','',50,0,0,7070,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1144,'2024-11-01','2024-11-02 10:08:34.562179','',0,0,0,7082,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1145,'2024-11-01','2024-11-02 10:08:34.567182','',48,0,0,7083,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1146,'2024-11-01','2024-11-02 10:08:34.572185','',50,0,0,7077,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1147,'2024-11-01','2024-11-02 10:08:34.579191','',0,0,0,7250,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1148,'2024-11-01','2024-11-02 10:08:34.585194','',48,0,288,7086,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,96,0),(1149,'2024-11-01','2024-11-02 10:08:34.591199','',50,0,234,7119,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,78,0),(1150,'2024-11-01','2024-11-02 10:08:34.597204','',50,0,0,7120,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(1151,'2024-11-01','2024-11-02 10:08:34.606210','',50,0,126,7121,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,42,0),(1152,'2024-11-01','2024-11-02 10:08:34.614216','',48,0,0,7122,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(1153,'2024-11-01','2024-11-02 10:08:34.622221','',48,0,6,7123,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,0),(1154,'2024-11-01','2024-11-02 10:08:34.630227','',50,0,51,7124,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,17,0),(1155,'2024-11-01','2024-11-02 10:08:34.638232','',45,0,0,7084,0,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0),(1156,'2024-11-02','2024-11-02 11:37:33.614815','',50,0,0,7053,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1157,'2024-11-02','2024-11-02 11:37:33.680863','',50,0,0,7052,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1158,'2024-11-02','2024-11-02 11:37:33.694873','',50,0,0,7054,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1159,'2024-11-02','2024-11-02 11:37:33.706881','',50,0,0,7059,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1160,'2024-11-02','2024-11-02 11:37:33.713886','',50,0,0,7060,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2,0),(1161,'2024-11-02','2024-11-02 11:37:33.727896','',1.5,0,0,7055,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,0),(1162,'2024-11-02','2024-11-02 11:37:33.796470','',50,0,0,6993,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1163,'2024-11-02','2024-11-02 11:37:33.820487','',50,0,0,6994,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1164,'2024-11-02','2024-11-02 11:37:33.865019','',50,0,0,6995,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1165,'2024-11-02','2024-11-02 11:37:33.882031','',50,0,0,6997,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1166,'2024-11-02','2024-11-02 11:37:33.901545','',50,0,0,6999,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1167,'2024-11-02','2024-11-02 11:37:33.920059','',50,0,0,7001,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1168,'2024-11-02','2024-11-02 11:37:33.947578','',50,0,0,7003,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,700,0),(1169,'2024-11-02','2024-11-02 11:37:33.953582','',50,0,0,7005,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1170,'2024-11-02','2024-11-02 11:37:33.958585','',50,0,0,7007,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1171,'2024-11-02','2024-11-02 11:37:33.963589','',50,0,0,7009,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1172,'2024-11-02','2024-11-02 11:37:33.968092','',50,0,0,7047,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1173,'2024-11-02','2024-11-02 11:37:33.972596','',50,0,0,7048,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1174,'2024-11-02','2024-11-02 11:37:33.977099','',50,0,0,7049,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1175,'2024-11-02','2024-11-02 11:37:33.983102','',50,0,0,7050,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,820,0),(1176,'2024-11-02','2024-11-02 11:37:33.988106','',48,0,0,7062,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1177,'2024-11-02','2024-11-02 11:37:33.992610','',50,0,0,7064,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1178,'2024-11-02','2024-11-02 11:37:33.997113','',50,0,0,7066,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1179,'2024-11-02','2024-11-02 11:37:34.026634','',50,0,0,7068,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1180,'2024-11-02','2024-11-02 11:37:34.036641','',50,0,0,7070,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1181,'2024-11-02','2024-11-02 11:37:34.043145','',0,0,0,7061,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1182,'2024-11-02','2024-11-02 11:37:34.050151','',0,0,0,7082,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1183,'2024-11-02','2024-11-02 11:37:34.056155','',48,0,0,7083,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1184,'2024-11-02','2024-11-02 11:37:34.062660','',50,0,0,7077,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1185,'2024-11-02','2024-11-02 11:37:34.068663','',0,0,0,7250,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1186,'2024-11-02','2024-11-02 11:37:34.075168','',48,0,0,7086,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1187,'2024-11-02','2024-11-02 11:37:34.082173','',50,0,0,7119,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1188,'2024-11-02','2024-11-02 11:37:34.088177','',50,0,0,7120,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1189,'2024-11-02','2024-11-02 11:37:34.102688','',48,0,0,7121,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1190,'2024-11-02','2024-11-02 11:37:34.109192','',48,0,0,7122,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1191,'2024-11-02','2024-11-02 11:37:34.116197','',48,0,0,7123,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1192,'2024-11-02','2024-11-02 11:37:34.122702','',45,0,0,7124,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0),(1193,'2024-11-02','2024-11-02 11:37:34.130207','',45,0,0,7084,0,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0);
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
  `action_flag` smallint(5) unsigned NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2024-12-21 08:27:29.811076','1','admin',1,'[{\"added\": {}}]',12,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(9,'mrp','asset'),(39,'mrp','asset2'),(7,'mrp','assetcategory'),(19,'mrp','assetfailure'),(20,'mrp','assetrandemaninit'),(22,'mrp','assetrandemanlist'),(21,'mrp','assetrandemanpermonth'),(11,'mrp','dailyproduction'),(18,'mrp','failure'),(27,'mrp','financialprofile'),(10,'mrp','formula'),(8,'mrp','machinecategory'),(23,'mrp','nezafatpadash'),(24,'mrp','nezafatranking'),(38,'mrp','order'),(28,'mrp','part'),(37,'mrp','partcategory'),(29,'mrp','partcsvfile'),(36,'mrp','partfile'),(35,'mrp','partuser'),(15,'mrp','productionstandard'),(30,'mrp','purchaserequest'),(31,'mrp','requestitem'),(32,'mrp','rfq'),(13,'mrp','shift'),(14,'mrp','speedformula'),(33,'mrp','supplier'),(34,'mrp','supplierresponse'),(12,'mrp','sysuser'),(25,'mrp','tolidpadash'),(26,'mrp','tolidranking'),(16,'mrp','zayeat'),(17,'mrp','zayeatvaz'),(6,'sessions','session');
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
) ENGINE=InnoDB AUTO_INCREMENT=94 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2024-10-26 11:40:49.505952'),(2,'auth','0001_initial','2024-10-26 11:40:50.077357'),(3,'admin','0001_initial','2024-10-26 11:40:50.223462'),(4,'admin','0002_logentry_remove_auto_add','2024-10-26 11:40:50.231467'),(5,'admin','0003_logentry_add_action_flag_choices','2024-10-26 11:40:50.240474'),(6,'contenttypes','0002_remove_content_type_name','2024-10-26 11:40:50.282504'),(7,'auth','0002_alter_permission_name_max_length','2024-10-26 11:40:50.338543'),(8,'auth','0003_alter_user_email_max_length','2024-10-26 11:40:50.423604'),(9,'auth','0004_alter_user_username_opts','2024-10-26 11:40:50.432610'),(10,'auth','0005_alter_user_last_login_null','2024-10-26 11:40:50.465634'),(11,'auth','0006_require_contenttypes_0002','2024-10-26 11:40:50.469636'),(12,'auth','0007_alter_validators_add_error_messages','2024-10-26 11:40:50.478643'),(13,'auth','0008_alter_user_username_max_length','2024-10-26 11:40:50.493654'),(14,'auth','0009_alter_user_last_name_max_length','2024-10-26 11:40:50.507664'),(15,'auth','0010_alter_group_name_max_length','2024-10-26 11:40:50.569708'),(16,'auth','0011_update_proxy_permissions','2024-10-26 11:40:50.579715'),(17,'auth','0012_alter_user_first_name_max_length','2024-10-26 11:40:50.595726'),(18,'mrp','0001_initial','2024-10-26 11:40:50.663774'),(19,'mrp','0002_asset_machinecategory','2024-10-26 11:40:50.943974'),(20,'mrp','0003_dailyproduction_formula','2024-10-26 11:40:51.146117'),(21,'mrp','0004_dailyproduction_speed','2024-10-26 11:40:51.165130'),(22,'mrp','0005_sysuser','2024-10-26 11:40:51.271206'),(23,'mrp','0006_auto_20231202_2059','2024-10-26 11:40:51.367275'),(24,'mrp','0007_remove_dailyproduction_shift','2024-10-26 11:40:51.402300'),(25,'mrp','0008_dailyproduction_shift','2024-10-26 11:40:51.453335'),(26,'mrp','0009_remove_dailyproduction_shift','2024-10-26 11:40:51.492363'),(27,'mrp','0010_dailyproduction_shift','2024-10-26 11:40:51.578424'),(28,'mrp','0011_speedformula','2024-10-26 11:40:51.636465'),(29,'mrp','0012_delete_speedformula','2024-10-26 11:40:51.653478'),(30,'mrp','0013_speedformula','2024-10-26 11:40:51.727531'),(31,'mrp','0014_delete_speedformula','2024-10-26 11:40:51.736537'),(32,'mrp','0015_speedformula','2024-10-26 11:40:51.796579'),(33,'mrp','0016_auto_20231205_0937','2024-10-26 11:40:51.868631'),(34,'mrp','0017_productionstandard','2024-10-26 11:40:51.916664'),(35,'mrp','0018_zayeat_zayeatvaz','2024-10-26 11:40:52.196864'),(36,'mrp','0019_auto_20231218_1228','2024-10-26 11:40:52.250903'),(37,'mrp','0020_zayeatvaz_dayofissue','2024-10-26 11:40:52.264912'),(38,'mrp','0021_zayeatvaz_shift','2024-10-26 11:40:52.335963'),(39,'mrp','0022_assetfailure_failure','2024-10-26 11:40:52.532102'),(40,'mrp','0023_auto_20231231_1318','2024-10-26 11:40:52.589143'),(41,'mrp','0024_auto_20240109_1354','2024-10-26 11:40:54.564548'),(42,'mrp','0025_assetrandemanpermonth','2024-10-26 11:40:54.707648'),(43,'mrp','0026_assetrandemanlist','2024-10-26 11:40:54.720657'),(44,'mrp','0027_auto_20240112_1534','2024-10-26 11:40:54.883773'),(45,'mrp','0028_auto_20240117_1052','2024-10-26 11:40:55.050892'),(46,'mrp','0029_auto_20240122_1121','2024-10-26 11:40:55.183986'),(47,'mrp','0030_auto_20240122_1142','2024-10-26 11:40:55.348103'),(48,'mrp','0031_auto_20240129_1627','2024-10-26 11:40:55.409146'),(49,'mrp','0032_alter_dailyproduction_unique_together','2024-10-26 11:40:55.434164'),(50,'mrp','0033_alter_assetfailure_unique_together','2024-10-26 11:40:55.464186'),(51,'mrp','0034_auto_20240321_0924','2024-10-26 11:40:55.712362'),(52,'mrp','0035_auto_20240321_0942','2024-10-26 11:40:55.966542'),(53,'mrp','0036_auto_20240321_0944','2024-10-26 11:40:56.190702'),(54,'mrp','0037_auto_20240321_0951','2024-10-26 11:40:56.273761'),(55,'mrp','0038_nezafatpadash_asset_randeman_list','2024-10-26 11:40:56.319793'),(56,'mrp','0039_auto_20240321_0952','2024-10-26 11:40:56.435876'),(57,'mrp','0040_remove_tolidpadash_asset_randeman_list','2024-10-26 11:40:56.472903'),(58,'mrp','0041_tolidpadash_asset_randeman_list','2024-10-26 11:40:56.520936'),(59,'mrp','0042_nezafatpadash_asset_randeman_list','2024-10-26 11:40:56.598992'),(60,'mrp','0043_auto_20240321_1028','2024-10-26 11:40:56.710070'),(61,'mrp','0044_auto_20240321_1031','2024-10-26 11:40:56.751100'),(62,'mrp','0045_auto_20240321_1327','2024-10-26 11:40:56.867182'),(63,'mrp','0046_auto_20240321_1328','2024-10-26 11:40:56.924223'),(64,'mrp','0047_auto_20240327_1340','2024-10-26 11:40:57.102350'),(65,'mrp','0048_auto_20240329_1405','2024-10-26 11:40:57.369539'),(66,'mrp','0049_auto_20240329_1406','2024-10-26 11:40:57.645736'),(67,'mrp','0050_auto_20240329_1406','2024-10-26 11:40:57.981974'),(68,'mrp','0051_auto_20240329_2110','2024-10-26 11:40:58.024004'),(69,'mrp','0052_auto_20240329_2229','2024-10-26 11:40:58.127078'),(70,'mrp','0053_auto_20240329_2326','2024-10-26 11:40:58.266177'),(71,'mrp','0054_auto_20240330_1029','2024-10-26 11:40:58.307206'),(72,'mrp','0055_auto_20240331_0023','2024-10-26 11:40:58.423288'),(73,'mrp','0056_auto_20240412_1834','2024-10-26 11:40:58.456312'),(74,'mrp','0057_auto_20240412_1842','2024-10-26 11:40:58.511350'),(75,'mrp','0058_financialprofile_tolid_randeman_mazrab_3','2024-10-26 11:40:58.526361'),(76,'mrp','0059_alter_sysuser_options','2024-10-26 11:40:58.537369'),(77,'mrp','0060_failure_is_it_count','2024-10-26 11:40:58.550378'),(78,'mrp','0061_alter_failure_is_it_count','2024-10-26 11:40:58.608420'),(79,'mrp','0062_alter_failure_is_it_count','2024-10-26 11:40:58.617426'),(80,'mrp','0063_auto_20240529_2018','2024-10-26 11:40:58.721502'),(81,'mrp','0064_alter_assetrandemanpermonth_tolid_value','2024-10-26 11:40:58.892621'),(82,'mrp','0065_asset_assetvahed','2024-10-26 11:40:58.917639'),(83,'mrp','0066_dailyproduction_vahed','2024-10-26 11:40:58.943658'),(84,'mrp','0067_auto_20241019_1910','2024-10-26 11:40:58.983686'),(85,'sessions','0001_initial','2024-10-26 11:40:59.009705'),(86,'mrp','0068_zayeatvaz_makan','2024-12-13 11:52:06.112976'),(87,'mrp','0069_auto_20241207_1052','2024-12-13 11:52:07.890440'),(88,'mrp','0070_auto_20241207_1347','2024-12-13 11:52:08.138442'),(89,'mrp','0071_requestitem_price','2025-01-04 09:05:40.614561'),(90,'mrp','0072_auto_20250107_0939','2025-01-07 17:19:50.975380'),(91,'mrp','0073_alter_requestitem_consume_place','2025-01-07 17:19:51.206861'),(92,'mrp','0074_alter_requestitem_consume_place','2025-01-07 17:19:51.460997'),(93,'mrp','0075_alter_sysuser_options','2025-01-07 17:19:51.492292');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('2j0i8lv85dznosmqoirp5brkwok3u0dl','.eJxVjMsOgjAQRf-la9PM0AwWl-79hmYeVFBTEgor4r8rCQvd3nPO3VzidRnSWvs5jeYuDt3pdxPWZ192YA8u98nrVJZ5FL8r_qDV3ybrX9fD_TsYuA7fmtEYKXSkMcaWMkBDJpSJCAgtgLSZ1SKIikLQwBpzc-6QW5DI6N4f2W835A:1t5N3q:SVB5I7eLU_LXU9af68AWBIdDQA960tIUbpRVSV3kjtc','2024-11-11 10:33:22.410159'),('9qby1rqc1s2drvtjx0xjtfz5x15y6aq7','.eJxVjMsOgjAQRf-la9PM0AwWl-79hmYeVFBTEgor4r8rCQvd3nPO3VzidRnSWvs5jeYuDt3pdxPWZ192YA8u98nrVJZ5FL8r_qDV3ybrX9fD_TsYuA7fmtEYKXSkMcaWMkBDJpSJCAgtgLSZ1SKIikLQwBpzc-6QW5DI6N4f2W835A:1tM4jJ:0JL1joAy_9MAPJJ2YZ_6LkckhtYeKgBPFREdpWh_GRI','2024-12-27 12:25:13.345841'),('atn4h141q0ifzsrfpoxl00d7lll951cf','.eJxVjMsOgjAQRf-la9PM0AwWl-79hmYeVFBTEgor4r8rCQvd3nPO3VzidRnSWvs5jeYuDt3pdxPWZ192YA8u98nrVJZ5FL8r_qDV3ybrX9fD_TsYuA7fmtEYKXSkMcaWMkBDJpSJCAgtgLSZ1SKIikLQwBpzc-6QW5DI6N4f2W835A:1tVD2z:xLS1mlYDvjfEX2QhVx3k7nGqNHRxu0XMYUNZElVgfv0','2025-01-21 17:07:17.971190'),('b3boc3plcjinz77ap8mtlxnwlroannow','.eJxVjMsOgjAQRf-la9PM0AwWl-79hmYeVFBTEgor4r8rCQvd3nPO3VzidRnSWvs5jeYuDt3pdxPWZ192YA8u98nrVJZ5FL8r_qDV3ybrX9fD_TsYuA7fmtEYKXSkMcaWMkBDJpSJCAgtgLSZ1SKIikLQwBpzc-6QW5DI6N4f2W835A:1t4y5A:AUDEYuUbATyw3BBS9LZQkwJgSrgcCz9xWcnuvavLKPA','2024-11-10 07:53:04.569907'),('bnvnrtnr2vtxr9x161s639rw77ss33pm','.eJxVjMsOgjAQRf-la9PM0AwWl-79hmYeVFBTEgor4r8rCQvd3nPO3VzidRnSWvs5jeYuDt3pdxPWZ192YA8u98nrVJZ5FL8r_qDV3ybrX9fD_TsYuA7fmtEYKXSkMcaWMkBDJpSJCAgtgLSZ1SKIikLQwBpzc-6QW5DI6N4f2W835A:1tTz4s:XyfOwCDKN8yEJNmVGVmFOVXu-okJRXBHuDx36t3SeUc','2025-01-18 08:00:10.519065'),('c9qts6e600q6ftm117bijmayoo59bzcb','.eJxVjMsOgjAQRf-la9PM0AwWl-79hmYeVFBTEgor4r8rCQvd3nPO3VzidRnSWvs5jeYuDt3pdxPWZ192YA8u98nrVJZ5FL8r_qDV3ybrX9fD_TsYuA7fmtEYKXSkMcaWMkBDJpSJCAgtgLSZ1SKIikLQwBpzc-6QW5DI6N4f2W835A:1t7c8X:mdEe96t8-sMDx6S8-9k_IYQH1R7oycMK-Ti9W5pIKrk','2024-11-17 15:03:29.473241'),('cfdmwhjg7our5it2h303cnc11lx5u685','.eJxVjMsOgjAQRf-la9PM0AwWl-79hmYeVFBTEgor4r8rCQvd3nPO3VzidRnSWvs5jeYuDt3pdxPWZ192YA8u98nrVJZ5FL8r_qDV3ybrX9fD_TsYuA7fmtEYKXSkMcaWMkBDJpSJCAgtgLSZ1SKIikLQwBpzc-6QW5DI6N4f2W835A:1t4fB3:FOCFNT_K95-L0aaJRIuSB-ppA5j2D1PTVnITgtSILHQ','2024-11-09 11:41:53.539452'),('sh92lw654jvjdwn8419uc44m3iyttz1h','.eJxVjMsOgjAQRf-la9PM0AwWl-79hmYeVFBTEgor4r8rCQvd3nPO3VzidRnSWvs5jeYuDt3pdxPWZ192YA8u98nrVJZ5FL8r_qDV3ybrX9fD_TsYuA7fmtEYKXSkMcaWMkBDJpSJCAgtgLSZ1SKIikLQwBpzc-6QW5DI6N4f2W835A:1t62SK:iGM-69v4vUKvp4WmIOglmfkWnjLOeR3bGjKIybdGeGI','2024-11-13 06:45:24.303203'),('ubhcs0nwvyhgcxmcn0t05g2ilbykbh95','.eJxVjMsOgjAQRf-la9PM0AwWl-79hmYeVFBTEgor4r8rCQvd3nPO3VzidRnSWvs5jeYuDt3pdxPWZ192YA8u98nrVJZ5FL8r_qDV3ybrX9fD_TsYuA7fmtEYKXSkMcaWMkBDJpSJCAgtgLSZ1SKIikLQwBpzc-6QW5DI6N4f2W835A:1t4ws8:BvAXrWAPl40GRom6eHYtAjgX3wYU_HTUC29hNyXGsvs','2024-11-10 06:35:32.129986'),('vcjmb84m4pzjfr63savcqswpd3yz5h96','.eJxVjMsOgjAQRf-la9PM0AwWl-79hmYeVFBTEgor4r8rCQvd3nPO3VzidRnSWvs5jeYuDt3pdxPWZ192YA8u98nrVJZ5FL8r_qDV3ybrX9fD_TsYuA7fmtEYKXSkMcaWMkBDJpSJCAgtgLSZ1SKIikLQwBpzc-6QW5DI6N4f2W835A:1tOxNy:bcbmzI9cSsqVgDtaeOeB-DHkJ4E3zra_3GeMkV5kL94','2025-01-04 11:11:06.213747');
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
  `is_it_count` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
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
  `description` longtext NOT NULL,
  `time_created` datetime(6) NOT NULL,
  `mablagh_kol_randeman` decimal(10,0) NOT NULL,
  `tolid_randeman` decimal(10,0) NOT NULL,
  `tolid_randeman_mazrab_3` decimal(10,0) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
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
  `formula` varchar(255) NOT NULL,
  `machine_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `machine_id` (`machine_id`),
  CONSTRAINT `formula_machine_id_bc181d55_fk_assets_id` FOREIGN KEY (`machine_id`) REFERENCES `assets` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `formula`
--

LOCK TABLES `formula` WRITE;
/*!40000 ALTER TABLE `formula` DISABLE KEYS */;
INSERT INTO `formula` VALUES (5,'Q*200',7052),(7,'(P*Q*Z)/1000',7053),(8,'(P*Q*Z)/1000',7054),(9,'(P*Q*Z)/1000',7059),(10,'(P*Q*Z)/1000',7060),(11,'((P*Q*Z)/100)-(0.1*(P*Q*Z)/100)',7055),(12,'(Q*Z)/(P*1000)',6993),(13,'(Q*Z)/(P*1000)',6994),(14,'(Q*Z)/(P*1000)',6995),(15,'(Q*Z)/(P*1000)',6997),(16,'(Q*Z)/(P*1000)',6999),(17,'(Q*Z)/(P*1000)',7001),(18,'(Q*Z)/(P*1000)',7003),(19,'(Q*Z)/(P*1000)',7005),(20,'(Q*Z)/(P*1000)',7007),(21,'(Q*Z)/(P*1000)',7009),(22,'(Q*Z)/(P*1000)',7047),(23,'(Q*Z)/(P*1000)',7048),(24,'(Q*Z)/(P*1000)',7049),(25,'(Q*Z)/(P*1000)',7050),(26,'(Q*Z)/(P*1000)',7062),(27,'(Q*Z)/(P*1000)',7064),(28,'(Q*Z)/(P*1000)',7066),(29,'(Q*Z)/(P*1000)',7068),(30,'(Q*Z)/(P*1000)',7070),(31,'Z*P',7082),(32,'Z*P',7083),(33,'Z*P',7077),(34,'Z*P',7250),(35,'Z*3',7086),(36,'Z*3',7119),(37,'Z*3',7120),(38,'Z*3',7121),(39,'Z*3',7122),(40,'Z*3',7123),(41,'Z*3',7124),(42,'Z*3',7084);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mrp_assetfailure`
--

LOCK TABLES `mrp_assetfailure` WRITE;
/*!40000 ALTER TABLE `mrp_assetfailure` DISABLE KEYS */;
/*!40000 ALTER TABLE `mrp_assetfailure` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mrp_order`
--

DROP TABLE IF EXISTS `mrp_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mrp_order` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `total_price` decimal(10,2) NOT NULL,
  `payment_terms` longtext NOT NULL,
  `arrival_date` date NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `supplier_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mrp_order_supplier_id_031f2f76_fk_mrp_supplier_id` (`supplier_id`),
  CONSTRAINT `mrp_order_supplier_id_031f2f76_fk_mrp_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `mrp_supplier` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mrp_order`
--

LOCK TABLES `mrp_order` WRITE;
/*!40000 ALTER TABLE `mrp_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `mrp_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mrp_order_items`
--

DROP TABLE IF EXISTS `mrp_order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mrp_order_items` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) NOT NULL,
  `requestitem_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mrp_order_items_order_id_requestitem_id_2274cfee_uniq` (`order_id`,`requestitem_id`),
  KEY `mrp_order_items_requestitem_id_c5ea6dc8_fk_mrp_requestitem_id` (`requestitem_id`),
  CONSTRAINT `mrp_order_items_order_id_210ef832_fk_mrp_order_id` FOREIGN KEY (`order_id`) REFERENCES `mrp_order` (`id`),
  CONSTRAINT `mrp_order_items_requestitem_id_c5ea6dc8_fk_mrp_requestitem_id` FOREIGN KEY (`requestitem_id`) REFERENCES `mrp_requestitem` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mrp_order_items`
--

LOCK TABLES `mrp_order_items` WRITE;
/*!40000 ALTER TABLE `mrp_order_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `mrp_order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mrp_purchaserequest`
--

DROP TABLE IF EXISTS `mrp_purchaserequest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mrp_purchaserequest` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `status` varchar(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mrp_purchaserequest_user_id_d5062a2b_fk_sysusers_id` (`user_id`),
  CONSTRAINT `mrp_purchaserequest_user_id_d5062a2b_fk_sysusers_id` FOREIGN KEY (`user_id`) REFERENCES `sysusers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mrp_purchaserequest`
--

LOCK TABLES `mrp_purchaserequest` WRITE;
/*!40000 ALTER TABLE `mrp_purchaserequest` DISABLE KEYS */;
INSERT INTO `mrp_purchaserequest` VALUES (11,'2025-01-07 18:39:29.308375','Approved',1),(12,'2025-01-07 18:41:43.320016','Approved',2);
/*!40000 ALTER TABLE `mrp_purchaserequest` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mrp_requestitem`
--

DROP TABLE IF EXISTS `mrp_requestitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mrp_requestitem` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `quantity` int(10) unsigned NOT NULL CHECK (`quantity` >= 0),
  `item_name_id` bigint(20) NOT NULL,
  `purchase_request_id` bigint(20) NOT NULL,
  `supplier_assigned_id` bigint(20) DEFAULT NULL,
  `consume_place_id` bigint(20) NOT NULL,
  `description` longtext DEFAULT NULL,
  `price` double NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mrp_requestitem_supplier_assigned_id_96d9b0b1_fk_mrp_supplier_id` (`supplier_assigned_id`),
  KEY `mrp_requestitem_item_name_id_2b911956_fk_parts_id` (`item_name_id`),
  KEY `mrp_requestitem_purchase_request_id_644153ca_fk_mrp_purch` (`purchase_request_id`),
  KEY `mrp_requestitem_consume_place_id_b925e243_fk_assets2_id` (`consume_place_id`),
  CONSTRAINT `mrp_requestitem_consume_place_id_b925e243_fk_assets2_id` FOREIGN KEY (`consume_place_id`) REFERENCES `assets2` (`id`),
  CONSTRAINT `mrp_requestitem_item_name_id_2b911956_fk_parts_id` FOREIGN KEY (`item_name_id`) REFERENCES `parts` (`id`),
  CONSTRAINT `mrp_requestitem_purchase_request_id_644153ca_fk_mrp_purch` FOREIGN KEY (`purchase_request_id`) REFERENCES `mrp_purchaserequest` (`id`),
  CONSTRAINT `mrp_requestitem_supplier_assigned_id_96d9b0b1_fk_mrp_supplier_id` FOREIGN KEY (`supplier_assigned_id`) REFERENCES `mrp_supplier` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mrp_requestitem`
--

LOCK TABLES `mrp_requestitem` WRITE;
/*!40000 ALTER TABLE `mrp_requestitem` DISABLE KEYS */;
INSERT INTO `mrp_requestitem` VALUES (13,100,8,11,NULL,3,'شرح',0),(14,100,8,12,NULL,3,'شرح',0);
/*!40000 ALTER TABLE `mrp_requestitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mrp_rfq`
--

DROP TABLE IF EXISTS `mrp_rfq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mrp_rfq` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `issued_at` datetime(6) NOT NULL,
  `issued_by_id` int(11) NOT NULL,
  `supplier_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mrp_rfq_supplier_id_b8d84b37_fk_mrp_supplier_id` (`supplier_id`),
  KEY `mrp_rfq_issued_by_id_9fb10c29_fk_auth_user_id` (`issued_by_id`),
  CONSTRAINT `mrp_rfq_issued_by_id_9fb10c29_fk_auth_user_id` FOREIGN KEY (`issued_by_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `mrp_rfq_supplier_id_b8d84b37_fk_mrp_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `mrp_supplier` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mrp_rfq`
--

LOCK TABLES `mrp_rfq` WRITE;
/*!40000 ALTER TABLE `mrp_rfq` DISABLE KEYS */;
/*!40000 ALTER TABLE `mrp_rfq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mrp_rfq_items`
--

DROP TABLE IF EXISTS `mrp_rfq_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mrp_rfq_items` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `rfq_id` bigint(20) NOT NULL,
  `requestitem_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mrp_rfq_items_rfq_id_requestitem_id_9c44fab2_uniq` (`rfq_id`,`requestitem_id`),
  KEY `mrp_rfq_items_requestitem_id_d5a86d0e_fk_mrp_requestitem_id` (`requestitem_id`),
  CONSTRAINT `mrp_rfq_items_requestitem_id_d5a86d0e_fk_mrp_requestitem_id` FOREIGN KEY (`requestitem_id`) REFERENCES `mrp_requestitem` (`id`),
  CONSTRAINT `mrp_rfq_items_rfq_id_07c62aa8_fk_mrp_rfq_id` FOREIGN KEY (`rfq_id`) REFERENCES `mrp_rfq` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mrp_rfq_items`
--

LOCK TABLES `mrp_rfq_items` WRITE;
/*!40000 ALTER TABLE `mrp_rfq_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `mrp_rfq_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mrp_supplier`
--

DROP TABLE IF EXISTS `mrp_supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mrp_supplier` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(254) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `address` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mrp_supplier`
--

LOCK TABLES `mrp_supplier` WRITE;
/*!40000 ALTER TABLE `mrp_supplier` DISABLE KEYS */;
/*!40000 ALTER TABLE `mrp_supplier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mrp_supplier_provided_items`
--

DROP TABLE IF EXISTS `mrp_supplier_provided_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mrp_supplier_provided_items` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `supplier_id` bigint(20) NOT NULL,
  `requestitem_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mrp_supplier_provided_it_supplier_id_requestitem__ba4f7826_uniq` (`supplier_id`,`requestitem_id`),
  KEY `mrp_supplier_provide_requestitem_id_783d59a6_fk_mrp_reque` (`requestitem_id`),
  CONSTRAINT `mrp_supplier_provide_requestitem_id_783d59a6_fk_mrp_reque` FOREIGN KEY (`requestitem_id`) REFERENCES `mrp_requestitem` (`id`),
  CONSTRAINT `mrp_supplier_provide_supplier_id_fddea068_fk_mrp_suppl` FOREIGN KEY (`supplier_id`) REFERENCES `mrp_supplier` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mrp_supplier_provided_items`
--

LOCK TABLES `mrp_supplier_provided_items` WRITE;
/*!40000 ALTER TABLE `mrp_supplier_provided_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `mrp_supplier_provided_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mrp_supplierresponse`
--

DROP TABLE IF EXISTS `mrp_supplierresponse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mrp_supplierresponse` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `total_price` decimal(10,2) NOT NULL,
  `payment_terms` longtext NOT NULL,
  `arrival_date` date NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `rfq_id` bigint(20) NOT NULL,
  `supplier_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mrp_supplierresponse_rfq_id_db72afbd_fk_mrp_rfq_id` (`rfq_id`),
  KEY `mrp_supplierresponse_supplier_id_59935309_fk_mrp_supplier_id` (`supplier_id`),
  CONSTRAINT `mrp_supplierresponse_rfq_id_db72afbd_fk_mrp_rfq_id` FOREIGN KEY (`rfq_id`) REFERENCES `mrp_rfq` (`id`),
  CONSTRAINT `mrp_supplierresponse_supplier_id_59935309_fk_mrp_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `mrp_supplier` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mrp_supplierresponse`
--

LOCK TABLES `mrp_supplierresponse` WRITE;
/*!40000 ALTER TABLE `mrp_supplierresponse` DISABLE KEYS */;
/*!40000 ALTER TABLE `mrp_supplierresponse` ENABLE KEYS */;
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
  `description` longtext NOT NULL,
  `price_sarshift` decimal(10,0) NOT NULL,
  `profile_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nezafatpadash_profile_id_73222534_fk_financialprofile_id` (`profile_id`),
  CONSTRAINT `nezafatpadash_profile_id_73222534_fk_financialprofile_id` FOREIGN KEY (`profile_id`) REFERENCES `financialprofile` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nezafatranking`
--

LOCK TABLES `nezafatranking` WRITE;
/*!40000 ALTER TABLE `nezafatranking` DISABLE KEYS */;
/*!40000 ALTER TABLE `nezafatranking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `partcategory`
--

DROP TABLE IF EXISTS `partcategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `partcategory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `code` varchar(50) NOT NULL,
  `description` varchar(50) NOT NULL,
  `priority` int(11) DEFAULT NULL,
  `isPartOf_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `partcategory_isPartOf_id_bc42f41a_fk_partcategory_id` (`isPartOf_id`),
  CONSTRAINT `partcategory_isPartOf_id_bc42f41a_fk_partcategory_id` FOREIGN KEY (`isPartOf_id`) REFERENCES `partcategory` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `partcategory`
--

LOCK TABLES `partcategory` WRITE;
/*!40000 ALTER TABLE `partcategory` DISABLE KEYS */;
/*!40000 ALTER TABLE `partcategory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `partcsvfile`
--

DROP TABLE IF EXISTS `partcsvfile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `partcsvfile` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `msgFile` varchar(200) NOT NULL,
  `msgFiledateAdded` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `partcsvfile`
--

LOCK TABLES `partcsvfile` WRITE;
/*!40000 ALTER TABLE `partcsvfile` DISABLE KEYS */;
/*!40000 ALTER TABLE `partcsvfile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `partfile`
--

DROP TABLE IF EXISTS `partfile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `partfile` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `partFile` varchar(200) NOT NULL,
  `partFiledateAdded` datetime(6) NOT NULL,
  `partFilePartId_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `partfile_partFilePartId_id_8b8c4a5c_fk_parts_id` (`partFilePartId_id`),
  CONSTRAINT `partfile_partFilePartId_id_8b8c4a5c_fk_parts_id` FOREIGN KEY (`partFilePartId_id`) REFERENCES `parts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `partfile`
--

LOCK TABLES `partfile` WRITE;
/*!40000 ALTER TABLE `partfile` DISABLE KEYS */;
/*!40000 ALTER TABLE `partfile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parts`
--

DROP TABLE IF EXISTS `parts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `parts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `partName` varchar(100) NOT NULL,
  `partDescription` varchar(100) NOT NULL,
  `partCode` varchar(50) NOT NULL,
  `partMake` varchar(100) DEFAULT NULL,
  `partModel` varchar(50) DEFAULT NULL,
  `partLastPrice` double DEFAULT NULL,
  `partAccount` varchar(100) DEFAULT NULL,
  `partChargeDepartment` varchar(100) DEFAULT NULL,
  `partNotes` varchar(100) DEFAULT NULL,
  `partBarcode` int(11) DEFAULT NULL,
  `partInventoryCode` varchar(50) DEFAULT NULL,
  `partCategory_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `parts_partCategory_id_e090a33a_fk_partcategory_id` (`partCategory_id`),
  CONSTRAINT `parts_partCategory_id_e090a33a_fk_partcategory_id` FOREIGN KEY (`partCategory_id`) REFERENCES `partcategory` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `parts`
--

LOCK TABLES `parts` WRITE;
/*!40000 ALTER TABLE `parts` DISABLE KEYS */;
INSERT INTO `parts` VALUES (1,'مهتابی','','مهتابی',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),(2,'لامپ','','لامپ',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),(3,'لامپ 1000','','لامپ_1000',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),(4,'پیچ سرمته 12','','پیچ_سرمته_12',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),(5,'تست','','تست',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),(6,'کالا','','کالا',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),(7,'dsd','','dsd',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),(8,'مداد','','مداد',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL),(9,'جامدادی','','جامدادی',NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `parts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `partuser`
--

DROP TABLE IF EXISTS `partuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `partuser` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `PartUserPartId_id` bigint(20) DEFAULT NULL,
  `PartUserUserId_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `partuser_PartUserPartId_id_ae6a0d45_fk_parts_id` (`PartUserPartId_id`),
  KEY `partuser_PartUserUserId_id_3ef299c8_fk_sysusers_id` (`PartUserUserId_id`),
  CONSTRAINT `partuser_PartUserPartId_id_ae6a0d45_fk_parts_id` FOREIGN KEY (`PartUserPartId_id`) REFERENCES `parts` (`id`),
  CONSTRAINT `partuser_PartUserUserId_id_3ef299c8_fk_sysusers_id` FOREIGN KEY (`PartUserUserId_id`) REFERENCES `sysusers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `partuser`
--

LOCK TABLES `partuser` WRITE;
/*!40000 ALTER TABLE `partuser` DISABLE KEYS */;
/*!40000 ALTER TABLE `partuser` ENABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
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
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shift`
--

LOCK TABLES `shift` WRITE;
/*!40000 ALTER TABLE `shift` DISABLE KEYS */;
INSERT INTO `shift` VALUES (1,'شیفت A'),(2,'شیفت B'),(3,'شیفت C');
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
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `speedformula`
--

LOCK TABLES `speedformula` WRITE;
/*!40000 ALTER TABLE `speedformula` DISABLE KEYS */;
INSERT INTO `speedformula` VALUES (5,'(P*Q*Z)/1000',7052),(7,'(P*Q*Z)/1000',7053),(8,'(P*Q*Z)/1000',7054),(9,'(P*Q*Z)/1000',7059),(10,'(P*Q*Z)/1000',7060),(11,'(P*Q*Z)/1000',7055),(12,'(Q*Z)/(P*1000)',6993),(13,'(Q*Z)/(P*1000)',6994),(14,'(Q*Z)/(P*1000)',6995),(15,'(Q*Z)/(P*1000)',6997),(16,'(Q*Z)/(P*1000)',6999),(17,'(Q*Z)/(P*1000)',7001),(18,'(Q*Z)/(P*1000)',7003),(19,'(Q*Z)/(P*1000)',7005),(20,'(Q*Z)/(P*1000)',7007),(21,'(Q*Z)/(P*1000)',7009),(22,'(Q*Z)/(P*1000)',7047),(23,'(Q*Z)/(P*1000)',7048),(24,'(Q*Z)/(P*1000)',7049),(25,'(Q*Z)/(P*1000)',7050),(26,'(Q*Z)/(P*1000)',7062),(27,'(Q*Z)/(P*1000)',7064),(28,'(Q*Z)/(P*1000)',7066),(29,'(Q*Z)/(P*1000)',7068),(30,'(Q*Z)/(P*1000)',7070),(31,'(Q*3)/(P)',7082),(32,'(Q*3)/(P)',7083),(33,'(Q*3)/(P)',7077),(34,'(Q*3)/(P)',7250),(35,'Z*3',7086),(36,'Z*3',7119),(37,'Z*3',7120),(38,'Z*3',7121),(39,'Z*3',7122),(40,'Z*3',7123),(41,'Z*3',7124),(42,'Z*3',7084);
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sysusers`
--

LOCK TABLES `sysusers` WRITE;
/*!40000 ALTER TABLE `sysusers` DISABLE KEYS */;
INSERT INTO `sysusers` VALUES (1,'123456Man',NULL,'admin','1234',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,'',1,1),(2,'123456',NULL,'sayahi','123','sayahi',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,'',1,2);
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
  `price_sarshift` decimal(10,0) NOT NULL,
  `price_personnel` decimal(10,0) NOT NULL,
  `profile_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tolidpadash_profile_id_9fd627e7_fk_financialprofile_id` (`profile_id`),
  CONSTRAINT `tolidpadash_profile_id_9fd627e7_fk_financialprofile_id` FOREIGN KEY (`profile_id`) REFERENCES `financialprofile` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
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
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zayeat`
--

LOCK TABLES `zayeat` WRITE;
/*!40000 ALTER TABLE `zayeat` DISABLE KEYS */;
INSERT INTO `zayeat` VALUES (1,'تاپس نواری'),(2,'ریبریکر'),(3,'فتیله و نیمچه'),(4,'هواکش رینگ'),(5,'سرنخ'),(6,'سرنخ دولاتاب و برگردان'),(7,'پرز'),(8,'سایر');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zayeatvazn`
--

LOCK TABLES `zayeatvazn` WRITE;
/*!40000 ALTER TABLE `zayeatvazn` DISABLE KEYS */;
INSERT INTO `zayeatvazn` VALUES (1,0,1,'2024-10-22',1,NULL),(2,0,2,'2024-10-22',1,NULL),(3,0,3,'2024-10-22',1,NULL),(4,43,4,'2024-10-22',1,NULL),(5,18,5,'2024-10-22',1,NULL),(6,4,6,'2024-10-22',1,NULL),(7,0,7,'2024-10-22',1,NULL),(8,0,8,'2024-10-22',1,NULL),(9,17.4,1,'2024-10-22',2,NULL),(10,0,2,'2024-10-22',2,NULL),(11,0,3,'2024-10-22',2,NULL),(12,48.8,4,'2024-10-22',2,NULL),(13,17,5,'2024-10-22',2,NULL),(14,1.5,6,'2024-10-22',2,NULL),(15,0,7,'2024-10-22',2,NULL),(16,0,8,'2024-10-22',2,NULL),(17,13,1,'2024-10-22',3,NULL),(18,0,2,'2024-10-22',3,NULL),(19,0,3,'2024-10-22',3,NULL),(20,41.5,4,'2024-10-22',3,NULL),(21,12,5,'2024-10-22',3,NULL),(22,3.95,6,'2024-10-22',3,NULL),(23,0,7,'2024-10-22',3,NULL),(24,0,8,'2024-10-22',3,NULL),(25,19,1,'2024-10-23',1,NULL),(26,0,2,'2024-10-23',1,NULL),(27,6,3,'2024-10-23',1,NULL),(28,46,4,'2024-10-23',1,NULL),(29,14,5,'2024-10-23',1,NULL),(30,4.8,6,'2024-10-23',1,NULL),(31,0,7,'2024-10-23',1,NULL),(32,0,8,'2024-10-23',1,NULL),(33,6.2,1,'2024-10-23',2,NULL),(34,5.2,2,'2024-10-23',2,NULL),(35,0,3,'2024-10-23',2,NULL),(36,34.8,4,'2024-10-23',2,NULL),(37,14.4,5,'2024-10-23',2,NULL),(38,0,6,'2024-10-23',2,NULL),(39,0,7,'2024-10-23',2,NULL),(40,0,8,'2024-10-23',2,NULL),(41,8,1,'2024-10-23',3,NULL),(42,0,2,'2024-10-23',3,NULL),(43,1.2,3,'2024-10-23',3,NULL),(44,38,4,'2024-10-23',3,NULL),(45,10,5,'2024-10-23',3,NULL),(46,2.9,6,'2024-10-23',3,NULL),(47,0,7,'2024-10-23',3,NULL),(48,0,8,'2024-10-23',3,NULL),(49,18,1,'2024-10-24',1,NULL),(50,4,2,'2024-10-24',1,NULL),(51,3.5,3,'2024-10-24',1,NULL),(52,36,4,'2024-10-24',1,NULL),(53,15,5,'2024-10-24',1,NULL),(54,3,6,'2024-10-24',1,NULL),(55,0,7,'2024-10-24',1,NULL),(56,0,8,'2024-10-24',1,NULL),(57,22.4,1,'2024-10-24',2,NULL),(58,1.6,2,'2024-10-24',2,NULL),(59,4.2,3,'2024-10-24',2,NULL),(60,47.2,4,'2024-10-24',2,NULL),(61,13.9,5,'2024-10-24',2,NULL),(62,0,6,'2024-10-24',2,NULL),(63,0,7,'2024-10-24',2,NULL),(64,0,8,'2024-10-24',2,NULL),(65,21,1,'2024-10-24',3,NULL),(66,0,2,'2024-10-24',3,NULL),(67,14,3,'2024-10-24',3,NULL),(68,40,4,'2024-10-24',3,NULL),(69,12,5,'2024-10-24',3,NULL),(70,2.85,6,'2024-10-24',3,NULL),(71,0,7,'2024-10-24',3,NULL),(72,0,8,'2024-10-24',3,NULL),(73,18,1,'2024-10-27',1,NULL),(74,4,2,'2024-10-27',1,NULL),(75,3,3,'2024-10-27',1,NULL),(76,45,4,'2024-10-27',1,NULL),(77,13.5,5,'2024-10-27',1,NULL),(78,3.2,6,'2024-10-27',1,NULL),(79,0,7,'2024-10-27',1,NULL),(80,0,8,'2024-10-27',1,NULL),(81,16.8,1,'2024-10-27',2,NULL),(82,2,2,'2024-10-27',2,NULL),(83,3,3,'2024-10-27',2,NULL),(84,39.2,4,'2024-10-27',2,NULL),(85,13.9,5,'2024-10-27',2,NULL),(86,1.4,6,'2024-10-27',2,NULL),(87,0,7,'2024-10-27',2,NULL),(88,0,8,'2024-10-27',2,NULL),(89,23,1,'2024-10-27',3,NULL),(90,5,2,'2024-10-27',3,NULL),(91,6,3,'2024-10-27',3,NULL),(92,44,4,'2024-10-27',3,NULL),(93,11,5,'2024-10-27',3,NULL),(94,1.8,6,'2024-10-27',3,NULL),(95,0,7,'2024-10-27',3,NULL),(96,0,8,'2024-10-27',3,NULL),(97,13,1,'2024-10-28',1,NULL),(98,3,2,'2024-10-28',1,NULL),(99,5,3,'2024-10-28',1,NULL),(100,33,4,'2024-10-28',1,NULL),(101,16,5,'2024-10-28',1,NULL),(102,0,6,'2024-10-28',1,NULL),(103,0,7,'2024-10-28',1,NULL),(104,0,8,'2024-10-28',1,NULL),(105,3.2,1,'2024-10-28',2,NULL),(106,1.8,2,'2024-10-28',2,NULL),(107,3,3,'2024-10-28',2,NULL),(108,36.2,4,'2024-10-28',2,NULL),(109,13.8,5,'2024-10-28',2,NULL),(110,1.1,6,'2024-10-28',2,NULL),(111,0,7,'2024-10-28',2,NULL),(112,0,8,'2024-10-28',2,NULL),(113,9,1,'2024-10-28',3,NULL),(114,5,2,'2024-10-28',3,NULL),(115,6,3,'2024-10-28',3,NULL),(116,44.5,4,'2024-10-28',3,NULL),(117,10,5,'2024-10-28',3,NULL),(118,1.45,6,'2024-10-28',3,NULL),(119,0,7,'2024-10-28',3,NULL),(120,0,8,'2024-10-28',3,NULL),(121,20,1,'2024-10-29',1,NULL),(122,5,2,'2024-10-29',1,NULL),(123,3.2,3,'2024-10-29',1,NULL),(124,33,4,'2024-10-29',1,NULL),(125,11,5,'2024-10-29',1,NULL),(126,2.3,6,'2024-10-29',1,NULL),(127,0,7,'2024-10-29',1,NULL),(128,0,8,'2024-10-29',1,NULL),(129,3.2,1,'2024-10-29',2,NULL),(130,3,2,'2024-10-29',2,NULL),(131,2,3,'2024-10-29',2,NULL),(132,35,4,'2024-10-29',2,NULL),(133,13.85,5,'2024-10-29',2,NULL),(134,0,6,'2024-10-29',2,NULL),(135,0,7,'2024-10-29',2,NULL),(136,0,8,'2024-10-29',2,NULL),(137,20,1,'2024-10-29',3,NULL),(138,3,2,'2024-10-29',3,NULL),(139,6.5,3,'2024-10-29',3,NULL),(140,39,4,'2024-10-29',3,NULL),(141,13,5,'2024-10-29',3,NULL),(142,1.7,6,'2024-10-29',3,NULL),(143,0,7,'2024-10-29',3,NULL),(144,19,8,'2024-10-29',3,NULL);
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

-- Dump completed on 2025-01-11 19:05:55
