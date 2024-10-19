-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: aria_mrp
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

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
INSERT INTO `assetcategory` VALUES (1,'سایدل','','',2,NULL),(2,'پاساژ','','',3,NULL),(3,'فینیشر','','',4,NULL),(4,'رینگ','','',5,NULL),(5,'اتوکنر','','',6,NULL),(6,'لاکنی','','',7,NULL),(7,'دولاتاب','','',8,NULL),(8,'هیت ست','','',9,NULL),(9,'ریبریکر','','',1,NULL),(10,'آزاد','','',10,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assetrandemaninit`
--

LOCK TABLES `assetrandemaninit` WRITE;
/*!40000 ALTER TABLE `assetrandemaninit` DISABLE KEYS */;
INSERT INTO `assetrandemaninit` VALUES (1,1,6800000,6800000,20400000,0,0,0,9,NULL),(2,1,4900000,4900000,14700000,24054545,24050000,19240000,1,NULL),(3,1,4900000,4900000,14700000,24054545,24050000,19240000,2,NULL),(4,1,4900000,4900000,14700000,24054545,24050000,19240000,3,NULL),(5,8,5900000,47200000,141600000,231709091,231710000,185368000,4,NULL),(6,3,4900000,14700000,44100000,72163636,72160000,57728000,5,NULL),(7,3,4900000,14700000,44100000,72163636,72160000,57728000,6,NULL),(8,3,6400000,19200000,57600000,94254545,94250000,75400000,7,NULL),(9,3,4900000,14700000,44100000,72163636,72160000,57728000,8,NULL),(10,1,5400000,5400000,16200000,26509091,26510000,21208000,10,NULL),(11,1,10000000,10000000,30000000,49090909,26510000,39272727,10,1),(12,3,9200000,27600000,82800000,135490909,72160000,108392727,8,1),(13,3,11000000,33000000,99000000,162000000,94250000,129600000,7,1),(14,3,9200000,27600000,82800000,135490909,72160000,108392727,6,1),(15,3,9200000,27600000,82800000,135490909,72160000,108392727,5,1),(16,8,11000000,88000000,264000000,432000000,231710000,345600000,4,1),(17,1,9200000,9200000,27600000,45163636,24050000,36130909,3,1),(18,1,9200000,9200000,27600000,45163636,24050000,36130909,2,1),(19,1,9200000,9200000,27600000,45163636,24050000,36130909,1,1),(20,1,6800000,6800000,20400000,0,0,0,9,1),(31,1,6800000,6800000,20400000,0,0,0,9,3),(32,1,9200000,9200000,27600000,45163636,24050000,36130909,1,3),(33,1,9200000,9200000,27600000,45163636,24050000,36130909,2,3),(34,1,9200000,9200000,27600000,45163636,24050000,36130909,3,3),(35,8,11000000,88000000,264000000,432000000,231710000,345600000,4,3),(36,3,9200000,27600000,82800000,135490909,72160000,108392727,5,3),(37,3,9200000,27600000,82800000,135490909,72160000,108392727,6,3),(38,3,11000000,33000000,99000000,162000000,94250000,129600000,7,3),(39,3,9200000,27600000,82800000,135490909,72160000,108392727,8,3),(40,1,10000000,10000000,30000000,49090909,26510000,39272727,10,3);
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
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assetrandemanlist`
--

LOCK TABLES `assetrandemanlist` WRITE;
/*!40000 ALTER TABLE `assetrandemanlist` DISABLE KEYS */;
INSERT INTO `assetrandemanlist` VALUES (38,11,1402,NULL),(42,1,1403,1),(47,2,1403,1),(50,3,1402,3),(51,3,1403,3),(54,4,1403,3),(55,5,1403,3);
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
) ENGINE=InnoDB AUTO_INCREMENT=1201 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assetrandemanpermonth`
--

LOCK TABLES `assetrandemanpermonth` WRITE;
/*!40000 ALTER TABLE `assetrandemanpermonth` DISABLE KEYS */;
INSERT INTO `assetrandemanpermonth` VALUES (460,20695691.09,5,1,NULL),(461,16069129.23,5,2,NULL),(462,20963179.68,5,3,NULL),(463,7834300.21,2,1,NULL),(464,4048670.90,2,2,NULL),(465,7357028.89,2,3,NULL),(466,19242666.67,7,1,NULL),(467,19242666.67,7,2,NULL),(468,19242666.67,7,3,NULL),(469,67792781.27,4,1,NULL),(470,50890766.32,4,2,NULL),(471,66684452.42,4,3,NULL),(472,6382911.36,3,1,NULL),(473,6499845.84,3,2,NULL),(474,6357242.81,3,3,NULL),(475,8756742.47,1,1,NULL),(476,2208401.97,1,2,NULL),(477,8274855.56,1,3,NULL),(478,19621706.16,6,1,NULL),(479,19296815.17,6,2,NULL),(480,18809478.67,6,3,NULL),(481,16203107.99,8,1,NULL),(482,20605576.44,8,2,NULL),(483,20919315.57,8,3,NULL),(490,32075703.85,5,1,NULL),(491,12516138.05,5,2,NULL),(492,13136158.10,5,3,NULL),(493,994327.74,2,1,NULL),(494,1689031.28,2,2,NULL),(495,16556640.98,2,3,NULL),(496,19313822.33,7,1,NULL),(497,19100355.34,7,2,NULL),(498,19313822.33,7,3,NULL),(499,63960455.98,4,1,NULL),(500,61345749.38,4,2,NULL),(501,60061794.64,4,3,NULL),(502,111550.33,3,1,NULL),(503,18985.01,3,2,NULL),(504,19109464.67,3,3,NULL),(505,4006080.31,1,1,NULL),(506,7616959.85,1,2,NULL),(507,7616959.85,1,3,NULL),(508,27755425.32,6,1,NULL),(509,1751821.72,6,2,NULL),(510,28220752.96,6,3,NULL),(511,55527287.92,8,1,NULL),(512,1207938.97,8,2,NULL),(513,992773.10,8,3,NULL),(643,7069334.00,10,1,NULL),(644,7069334.00,10,2,NULL),(645,7069334.00,10,3,NULL),(646,19020798.00,5,1,NULL),(647,19071472.00,5,2,NULL),(648,19635732.00,5,3,NULL),(649,6823076.00,2,1,NULL),(650,6471380.00,2,2,NULL),(651,5945545.00,2,3,NULL),(652,24653839.00,7,1,NULL),(653,25531891.00,7,2,NULL),(654,25214272.00,7,3,NULL),(655,68395613.00,4,1,NULL),(656,58823087.00,4,2,NULL),(657,58149302.00,4,3,NULL),(658,6707843.00,3,1,NULL),(659,6621161.00,3,2,NULL),(660,5910997.00,3,3,NULL),(661,6715490.00,1,1,NULL),(662,6567984.00,1,2,NULL),(663,5956528.00,1,3,NULL),(664,18438477.00,6,1,NULL),(665,20236415.00,6,2,NULL),(666,19053110.00,6,3,NULL),(667,20735835.00,8,1,NULL),(668,19523124.00,8,2,NULL),(669,17469042.00,8,3,NULL),(730,7069334.00,10,1,NULL),(731,7069334.00,10,2,NULL),(732,7069334.00,10,3,NULL),(733,19288708.00,5,1,NULL),(734,19159473.00,5,2,NULL),(735,19279820.00,5,3,NULL),(736,6391972.00,2,1,NULL),(737,6310655.00,2,2,NULL),(738,6537375.00,2,3,NULL),(739,0.00,9,1,NULL),(740,0.00,9,2,NULL),(741,0.00,9,3,NULL),(742,25149360.00,7,1,NULL),(743,25259495.00,7,2,NULL),(744,24991146.00,7,3,NULL),(745,62184535.00,4,1,NULL),(746,62042608.00,4,2,NULL),(747,61140859.00,4,3,NULL),(748,6751728.00,3,1,NULL),(749,6523289.00,3,2,NULL),(750,5964985.00,3,3,NULL),(751,6330181.00,1,1,NULL),(752,6351355.00,1,2,NULL),(753,6558465.00,1,3,NULL),(754,18337340.00,6,1,NULL),(755,19393705.00,6,2,NULL),(756,19996957.00,6,3,NULL),(757,19990640.00,8,1,NULL),(758,18753978.00,8,2,NULL),(759,18983384.00,8,3,NULL),(850,7069334.00,10,1,NULL),(851,7069334.00,10,2,NULL),(852,7069334.00,10,3,NULL),(853,20865384.00,5,1,NULL),(854,19380645.00,5,2,NULL),(855,17481972.00,5,3,NULL),(856,14115135.00,2,1,NULL),(857,12452720.00,2,2,NULL),(858,9563055.00,2,3,NULL),(859,0.00,9,1,NULL),(860,0.00,9,2,NULL),(861,0.00,9,3,NULL),(862,27306900.00,7,1,NULL),(863,26798997.00,7,2,NULL),(864,21294105.00,7,3,NULL),(865,67885598.00,4,1,NULL),(866,61616685.00,4,2,NULL),(867,55865718.00,4,3,NULL),(868,7475102.00,3,1,NULL),(869,7262931.00,3,2,NULL),(870,4501969.00,3,3,NULL),(871,14240366.00,1,1,NULL),(872,11802136.00,1,2,NULL),(873,10088408.00,1,3,NULL),(874,20531448.00,6,1,NULL),(875,19049803.00,6,2,NULL),(876,18146750.00,6,3,NULL),(877,19908110.00,8,1,NULL),(878,18077433.00,8,2,NULL),(879,19742459.00,8,3,NULL),(910,7069334.00,10,1,NULL),(911,7069334.00,10,2,NULL),(912,7069334.00,10,3,NULL),(913,0.00,9,1,NULL),(914,0.00,9,2,NULL),(915,0.00,9,3,NULL),(946,13090909.00,10,1,NULL),(947,13090909.00,10,2,NULL),(948,13090909.00,10,3,NULL),(949,37264445.00,5,1,NULL),(950,34716168.00,5,2,NULL),(951,36412116.00,5,3,NULL),(952,13285293.00,2,1,NULL),(953,10601594.00,2,2,NULL),(954,12244024.00,2,3,NULL),(955,0.00,9,1,NULL),(956,0.00,9,2,NULL),(957,0.00,9,3,NULL),(958,43130401.00,7,1,NULL),(959,43286830.00,7,2,NULL),(960,43182770.00,7,3,NULL),(961,99999999.99,4,1,NULL),(962,99999999.99,4,2,NULL),(963,99999999.99,4,3,NULL),(964,13310819.00,3,1,NULL),(965,12089098.00,3,2,NULL),(966,10730994.00,3,3,NULL),(967,12713295.00,1,1,NULL),(968,11274173.00,1,2,NULL),(969,12143442.00,1,3,NULL),(970,37739155.00,6,1,NULL),(971,32713544.00,6,2,NULL),(972,37940030.00,6,3,NULL),(973,37084212.00,8,1,NULL),(974,35207177.00,8,2,NULL),(975,36101340.00,8,3,NULL),(976,13090909.00,10,1,47),(977,13090909.00,10,2,47),(978,13090909.00,10,3,47),(979,37264445.00,5,1,47),(980,34716168.00,5,2,47),(981,36412116.00,5,3,47),(982,13285293.00,2,1,47),(983,10601594.00,2,2,47),(984,12244024.00,2,3,47),(985,0.00,9,1,47),(986,0.00,9,2,47),(987,0.00,9,3,47),(988,43130401.00,7,1,47),(989,43286830.00,7,2,47),(990,43182770.00,7,3,47),(991,117905235.00,4,1,47),(992,111004766.00,4,2,47),(993,116690001.00,4,3,47),(994,13310819.00,3,1,47),(995,12089098.00,3,2,47),(996,10730994.00,3,3,47),(997,12713295.00,1,1,47),(998,11274173.00,1,2,47),(999,12143442.00,1,3,47),(1000,37739155.00,6,1,47),(1001,32713544.00,6,2,47),(1002,37940030.00,6,3,47),(1003,37084212.00,8,1,47),(1004,35207177.00,8,2,47),(1005,36101340.00,8,3,47),(1045,13090909.00,10,1,50),(1046,13090909.00,10,2,50),(1047,13090909.00,10,3,50),(1048,0.00,9,1,50),(1049,0.00,9,2,50),(1050,0.00,9,3,50),(1051,13090909.00,10,1,51),(1052,13090909.00,10,2,51),(1053,13090909.00,10,3,51),(1054,37911892.00,5,1,51),(1055,34198140.00,5,2,51),(1056,36282696.00,5,3,51),(1057,13043786.00,2,1,51),(1058,11604292.00,2,2,51),(1059,11482832.00,2,3,51),(1060,0.00,9,1,51),(1061,0.00,9,2,51),(1062,0.00,9,3,51),(1063,43160751.00,7,1,51),(1064,42978356.00,7,2,51),(1065,43460895.00,7,3,51),(1066,116194400.00,4,1,51),(1067,111591052.00,4,2,51),(1068,117814550.00,4,3,51),(1069,13034299.00,3,1,51),(1070,11927256.00,3,2,51),(1071,11169355.00,3,3,51),(1072,12707882.00,1,1,51),(1073,11499990.00,1,2,51),(1074,11923038.00,1,3,51),(1075,37341793.00,6,1,51),(1076,33316186.00,6,2,51),(1077,37734749.00,6,3,51),(1078,37316608.00,8,1,51),(1079,34016583.00,8,2,51),(1080,37059537.00,8,3,51),(1141,13090909.00,10,1,54),(1142,13090909.00,10,2,54),(1143,13090909.00,10,3,54),(1144,36929140.00,5,1,54),(1145,34265872.00,5,2,54),(1146,37197716.00,5,3,54),(1147,12752917.00,2,1,54),(1148,11250775.00,2,2,54),(1149,12127219.00,2,3,54),(1150,0.00,9,1,54),(1151,0.00,9,2,54),(1152,0.00,9,3,54),(1153,43903367.00,7,1,54),(1154,41842207.00,7,2,54),(1155,43854428.00,7,3,54),(1156,117961416.00,4,1,54),(1157,112734188.00,4,2,54),(1158,114904397.00,4,3,54),(1159,12633901.00,3,1,54),(1160,11851046.00,3,2,54),(1161,11645964.00,3,3,54),(1162,12994799.00,1,1,54),(1163,11090979.00,1,2,54),(1164,12045133.00,1,3,54),(1165,35337320.00,6,1,54),(1166,35272734.00,6,2,54),(1167,37782674.00,6,3,54),(1168,38560675.00,8,1,54),(1169,32859931.00,8,2,54),(1170,36972123.00,8,3,54),(1171,13090909.00,10,1,55),(1172,13090909.00,10,2,55),(1173,13090909.00,10,3,55),(1174,35700983.00,5,1,55),(1175,34611566.00,5,2,55),(1176,38080179.00,5,3,55),(1177,10567746.00,2,1,55),(1178,11954807.00,2,2,55),(1179,13608358.00,2,3,55),(1180,0.00,9,1,55),(1181,0.00,9,2,55),(1182,0.00,9,3,55),(1183,41715607.00,7,1,55),(1184,42502410.00,7,2,55),(1185,45381985.00,7,3,55),(1186,110970240.00,4,1,55),(1187,115171011.00,4,2,55),(1188,119458751.00,4,3,55),(1189,11185489.00,3,1,55),(1190,12144138.00,3,2,55),(1191,12801284.00,3,3,55),(1192,10466360.00,1,1,55),(1193,12458371.00,1,2,55),(1194,13206179.00,1,3,55),(1195,32985336.00,6,1,55),(1196,34048150.00,6,2,55),(1197,41359242.00,6,3,55),(1198,37152325.00,8,1,55),(1199,34248026.00,8,2,55),(1200,36992378.00,8,3,55);
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
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assets`
--

LOCK TABLES `assets` WRITE;
/*!40000 ALTER TABLE `assets` DISABLE KEYS */;
INSERT INTO `assets` VALUES (1,3,'سایدل',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,1,NULL,NULL,NULL,1),(2,3,'ریبریکر',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,9,NULL,NULL,NULL,1),(11,3,'فینیشر',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,3,NULL,NULL,NULL,24),(12,3,'پاساژ 1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,2,NULL,NULL,NULL,1),(13,3,'پاساژ 2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,2,2,NULL,NULL,NULL,1),(14,3,'پاساژ 3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,3,2,NULL,NULL,NULL,2),(27,3,'رینگ 1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,4,NULL,NULL,NULL,250),(28,3,'رینگ 2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,2,4,NULL,NULL,NULL,250),(29,3,'رینگ 3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,3,4,NULL,NULL,NULL,250),(30,3,'رینگ 4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,4,4,NULL,NULL,NULL,250),(31,3,'رینگ 5',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,5,4,NULL,NULL,NULL,250),(32,3,'رینگ 6',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,6,4,NULL,NULL,NULL,250),(33,3,'رینگ 7',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,7,4,NULL,NULL,NULL,250),(34,3,'رینگ 8',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,8,4,NULL,NULL,NULL,250),(35,3,'رینگ 9',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,9,4,NULL,NULL,NULL,250),(36,3,'رینگ 10',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,10,4,NULL,NULL,NULL,250),(40,3,'دولاتاب 1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,7,NULL,NULL,NULL,240),(41,3,'دولاتاب 2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,2,7,NULL,NULL,NULL,240),(42,3,'دولاتاب 3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,3,7,NULL,NULL,NULL,240),(43,3,'دولاتاب 4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,4,7,NULL,NULL,NULL,240),(44,3,'دولاتاب 5',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,5,7,NULL,NULL,NULL,240),(45,3,'دولاتاب 6',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,6,7,NULL,NULL,NULL,240),(46,3,'دولاتاب 7',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,7,7,NULL,NULL,NULL,240),(47,3,'دولاتاب 8',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,8,7,NULL,NULL,NULL,240),(48,3,'دولاتاب 9',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,9,7,NULL,NULL,NULL,240),(49,3,'لاکنی 1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,6,NULL,NULL,NULL,32),(50,3,'لاکنی 2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,2,6,NULL,NULL,NULL,32),(51,3,'لاکنی 3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,3,6,NULL,NULL,NULL,32),(52,3,'لاکنی 4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,4,6,NULL,NULL,NULL,32),(53,3,'اتوکنر 1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,5,NULL,NULL,NULL,70),(54,3,'اتوکنر 2',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,2,5,NULL,NULL,NULL,70),(55,3,'اتوکنر 3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,3,5,NULL,NULL,NULL,70),(56,3,'اتوکنر 4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,0,0,4,5,NULL,NULL,NULL,70);
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
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add asset category',7,'add_assetcategory'),(26,'Can change asset category',7,'change_assetcategory'),(27,'Can delete asset category',7,'delete_assetcategory'),(28,'Can view asset category',7,'view_assetcategory'),(29,'Can add machine category',8,'add_machinecategory'),(30,'Can change machine category',8,'change_machinecategory'),(31,'Can delete machine category',8,'delete_machinecategory'),(32,'Can view machine category',8,'view_machinecategory'),(33,'Can add asset',9,'add_asset'),(34,'Can change asset',9,'change_asset'),(35,'Can delete asset',9,'delete_asset'),(36,'Can view asset',9,'view_asset'),(37,'Can add daily production',10,'add_dailyproduction'),(38,'Can change daily production',10,'change_dailyproduction'),(39,'Can delete daily production',10,'delete_dailyproduction'),(40,'Can view daily production',10,'view_dailyproduction'),(41,'Can add formula',11,'add_formula'),(42,'Can change formula',11,'change_formula'),(43,'Can delete formula',11,'delete_formula'),(44,'Can view formula',11,'view_formula'),(45,'Can add sys user',12,'add_sysuser'),(46,'Can change sys user',12,'change_sysuser'),(47,'Can delete sys user',12,'delete_sysuser'),(48,'Can view sys user',12,'view_sysuser'),(49,'Can add shift',13,'add_shift'),(50,'Can change shift',13,'change_shift'),(51,'Can delete shift',13,'delete_shift'),(52,'Can view shift',13,'view_shift'),(53,'Can add speed formula',14,'add_speedformula'),(54,'Can change speed formula',14,'change_speedformula'),(55,'Can delete speed formula',14,'delete_speedformula'),(56,'Can view speed formula',14,'view_speedformula'),(57,'Can add production standard',15,'add_productionstandard'),(58,'Can change production standard',15,'change_productionstandard'),(59,'Can delete production standard',15,'delete_productionstandard'),(60,'Can view production standard',15,'view_productionstandard'),(61,'Can add zayeat vaz',16,'add_zayeatvaz'),(62,'Can change zayeat vaz',16,'change_zayeatvaz'),(63,'Can delete zayeat vaz',16,'delete_zayeatvaz'),(64,'Can view zayeat vaz',16,'view_zayeatvaz'),(65,'Can add zayeat',17,'add_zayeat'),(66,'Can change zayeat',17,'change_zayeat'),(67,'Can delete zayeat',17,'delete_zayeat'),(68,'Can view zayeat',17,'view_zayeat'),(69,'Can add failure',18,'add_failure'),(70,'Can change failure',18,'change_failure'),(71,'Can delete failure',18,'delete_failure'),(72,'Can view failure',18,'view_failure'),(73,'Can add asset failure',19,'add_assetfailure'),(74,'Can change asset failure',19,'change_assetfailure'),(75,'Can delete asset failure',19,'delete_assetfailure'),(76,'Can view asset failure',19,'view_assetfailure'),(77,'Can add asset randeman init',20,'add_assetrandemaninit'),(78,'Can change asset randeman init',20,'change_assetrandemaninit'),(79,'Can delete asset randeman init',20,'delete_assetrandemaninit'),(80,'Can view asset randeman init',20,'view_assetrandemaninit'),(81,'Can add asset randeman per month',21,'add_assetrandemanpermonth'),(82,'Can change asset randeman per month',21,'change_assetrandemanpermonth'),(83,'Can delete asset randeman per month',21,'delete_assetrandemanpermonth'),(84,'Can view asset randeman per month',21,'view_assetrandemanpermonth'),(85,'Can add asset randeman list',22,'add_assetrandemanlist'),(86,'Can change asset randeman list',22,'change_assetrandemanlist'),(87,'Can delete asset randeman list',22,'delete_assetrandemanlist'),(88,'Can view asset randeman list',22,'view_assetrandemanlist'),(89,'Can add nezafat padash',23,'add_nezafatpadash'),(90,'Can change nezafat padash',23,'change_nezafatpadash'),(91,'Can delete nezafat padash',23,'delete_nezafatpadash'),(92,'Can view nezafat padash',23,'view_nezafatpadash'),(93,'Can add nezafat ranking',24,'add_nezafatranking'),(94,'Can change nezafat ranking',24,'change_nezafatranking'),(95,'Can delete nezafat ranking',24,'delete_nezafatranking'),(96,'Can view nezafat ranking',24,'view_nezafatranking'),(97,'Can add tolid padash',25,'add_tolidpadash'),(98,'Can change tolid padash',25,'change_tolidpadash'),(99,'Can delete tolid padash',25,'delete_tolidpadash'),(100,'Can view tolid padash',25,'view_tolidpadash'),(101,'Can add tolid ranking',26,'add_tolidranking'),(102,'Can change tolid ranking',26,'change_tolidranking'),(103,'Can delete tolid ranking',26,'delete_tolidranking'),(104,'Can view tolid ranking',26,'view_tolidranking'),(105,'can view dashboard',12,'can_view_dashboard'),(106,'Can add financial profile',27,'add_financialprofile'),(107,'Can change financial profile',27,'change_financialprofile'),(108,'Can delete financial profile',27,'delete_financialprofile'),(109,'Can view financial profile',27,'view_financialprofile');
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
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$260000$3d2GboOdP16IRGYtBrclBN$j6zofB3TcG6687Yjkj9clxu8YogjilUqBmDXhEyCag8=','2024-10-19 07:39:36.245941',1,'admin','','','dsa@ds.com',1,1,'2023-12-02 06:27:37.902847');
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
  `vahed` double NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dailyproduction_machine_id_shift_id_dayOfIssue_e9a55b55_uniq` (`machine_id`,`shift_id`,`dayOfIssue`),
  KEY `dailyproduction_machine_id_3581c565_fk_assets_id` (`machine_id`),
  KEY `dailyproduction_shift_id_b0e36c70_fk_shift_id` (`shift_id`),
  CONSTRAINT `dailyproduction_machine_id_3581c565_fk_assets_id` FOREIGN KEY (`machine_id`) REFERENCES `assets` (`id`),
  CONSTRAINT `dailyproduction_shift_id_b0e36c70_fk_shift_id` FOREIGN KEY (`shift_id`) REFERENCES `shift` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12808 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(9,'mrp','asset'),(7,'mrp','assetcategory'),(19,'mrp','assetfailure'),(20,'mrp','assetrandemaninit'),(22,'mrp','assetrandemanlist'),(21,'mrp','assetrandemanpermonth'),(10,'mrp','dailyproduction'),(18,'mrp','failure'),(27,'mrp','financialprofile'),(11,'mrp','formula'),(8,'mrp','machinecategory'),(23,'mrp','nezafatpadash'),(24,'mrp','nezafatranking'),(15,'mrp','productionstandard'),(13,'mrp','shift'),(14,'mrp','speedformula'),(12,'mrp','sysuser'),(25,'mrp','tolidpadash'),(26,'mrp','tolidranking'),(17,'mrp','zayeat'),(16,'mrp','zayeatvaz'),(6,'sessions','session');
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
) ENGINE=InnoDB AUTO_INCREMENT=95 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2023-12-02 06:24:13.783483'),(2,'auth','0001_initial','2023-12-02 06:24:14.306854'),(3,'admin','0001_initial','2023-12-02 06:24:14.467969'),(4,'admin','0002_logentry_remove_auto_add','2023-12-02 06:24:14.479978'),(5,'admin','0003_logentry_add_action_flag_choices','2023-12-02 06:24:14.488984'),(6,'contenttypes','0002_remove_content_type_name','2023-12-02 06:24:14.550027'),(7,'auth','0002_alter_permission_name_max_length','2023-12-02 06:24:14.609068'),(8,'auth','0003_alter_user_email_max_length','2023-12-02 06:24:14.658104'),(9,'auth','0004_alter_user_username_opts','2023-12-02 06:24:14.669111'),(10,'auth','0005_alter_user_last_login_null','2023-12-02 06:24:14.698132'),(11,'auth','0006_require_contenttypes_0002','2023-12-02 06:24:14.701135'),(12,'auth','0007_alter_validators_add_error_messages','2023-12-02 06:24:14.714144'),(13,'auth','0008_alter_user_username_max_length','2023-12-02 06:24:14.784192'),(14,'auth','0009_alter_user_last_name_max_length','2023-12-02 06:24:14.852241'),(15,'auth','0010_alter_group_name_max_length','2023-12-02 06:24:14.895272'),(16,'auth','0011_update_proxy_permissions','2023-12-02 06:24:14.907282'),(17,'auth','0012_alter_user_first_name_max_length','2023-12-02 06:24:14.965322'),(18,'sessions','0001_initial','2023-12-02 06:24:15.009353'),(19,'mrp','0001_initial','2023-12-02 06:25:06.352450'),(20,'mrp','0002_asset_machinecategory','2023-12-02 06:26:56.001683'),(21,'mrp','0003_dailyproduction_formula','2023-12-02 08:08:20.450086'),(22,'mrp','0004_dailyproduction_speed','2023-12-03 03:36:18.525305'),(23,'mrp','0005_sysuser','2023-12-03 03:36:18.641388'),(24,'mrp','0006_auto_20231202_2059','2023-12-03 03:37:03.323095'),(25,'mrp','0007_remove_dailyproduction_shift','2023-12-03 03:37:03.329098'),(26,'mrp','0008_dailyproduction_shift','2023-12-03 03:37:03.334103'),(27,'mrp','0009_remove_dailyproduction_shift','2023-12-03 03:37:03.340106'),(28,'mrp','0010_dailyproduction_shift','2023-12-03 03:38:14.317473'),(29,'mrp','0011_speedformula','2023-12-03 05:26:20.336424'),(30,'mrp','0012_delete_speedformula','2023-12-03 05:27:26.992725'),(31,'mrp','0013_speedformula','2023-12-03 05:27:26.995727'),(32,'mrp','0014_delete_speedformula','2023-12-03 05:27:47.721434'),(33,'mrp','0015_speedformula','2023-12-03 05:28:02.280765'),(34,'mrp','0016_auto_20231205_0937','2023-12-05 06:07:40.216791'),(35,'mrp','0017_productionstandard','2023-12-05 06:56:38.863099'),(36,'mrp','0018_zayeat_zayeatvaz','2023-12-18 08:51:07.854573'),(37,'mrp','0019_auto_20231218_1228','2023-12-18 08:58:10.592329'),(38,'mrp','0020_zayeatvaz_dayofissue','2023-12-18 09:26:53.157079'),(39,'mrp','0021_zayeatvaz_shift','2023-12-19 04:54:29.641796'),(40,'mrp','0022_assetfailure_failure','2023-12-31 08:58:22.278272'),(41,'mrp','0023_auto_20231231_1318','2023-12-31 09:48:25.717589'),(42,'mrp','0024_auto_20240109_1354','2024-01-09 10:24:46.574230'),(43,'mrp','0025_assetrandemanpermonth','2024-01-10 06:10:14.371648'),(44,'mrp','0026_assetrandemanlist','2024-01-10 06:56:01.829428'),(45,'mrp','0027_auto_20240112_1534','2024-01-13 05:36:54.091834'),(46,'mrp','0028_auto_20240117_1052','2024-01-17 07:22:47.934822'),(47,'mrp','0029_auto_20240122_1121','2024-01-22 07:51:45.817471'),(48,'mrp','0030_auto_20240122_1142','2024-01-22 08:12:39.056234'),(49,'mrp','0031_auto_20240129_0458','2024-01-29 12:58:42.509719'),(50,'mrp','0031_auto_20240129_1627','2024-02-06 12:00:28.306476'),(51,'mrp','0032_alter_dailyproduction_unique_together','2024-02-06 12:00:28.379125'),(52,'mrp','0033_merge_20240206_0400','2024-02-06 12:00:28.394287'),(53,'mrp','0034_alter_assetfailure_unique_together','2024-03-02 09:43:50.091856'),(54,'mrp','0033_alter_assetfailure_unique_together','2024-03-02 09:45:26.137974'),(55,'mrp','0035_merge_20240302_0145','2024-03-02 09:45:26.150968'),(56,'mrp','0036_alter_assetfailure_options','2024-03-02 09:50:43.762689'),(57,'mrp','0034_auto_20240321_0924','2024-03-26 07:42:30.268942'),(58,'mrp','0035_auto_20240321_0942','2024-03-26 07:42:30.588147'),(59,'mrp','0036_auto_20240321_0944','2024-03-26 07:42:30.888410'),(60,'mrp','0037_auto_20240321_0951','2024-03-26 07:42:31.005048'),(61,'mrp','0038_nezafatpadash_asset_randeman_list','2024-03-26 07:42:31.087821'),(62,'mrp','0039_auto_20240321_0952','2024-03-26 07:42:31.276191'),(63,'mrp','0040_remove_tolidpadash_asset_randeman_list','2024-03-26 07:42:31.351707'),(64,'mrp','0041_tolidpadash_asset_randeman_list','2024-03-26 07:42:31.433214'),(65,'mrp','0042_nezafatpadash_asset_randeman_list','2024-03-26 07:42:31.523917'),(66,'mrp','0043_auto_20240321_1028','2024-03-26 07:42:31.573943'),(67,'mrp','0044_auto_20240321_1031','2024-03-26 07:42:31.629883'),(68,'mrp','0045_auto_20240321_1327','2024-03-26 07:42:31.710610'),(69,'mrp','0046_auto_20240321_1328','2024-03-26 07:42:31.788922'),(70,'mrp','0047_merge_20240326_0042','2024-03-26 07:42:31.793276'),(71,'mrp','0047_auto_20240327_1340','2024-03-28 06:39:25.657280'),(72,'mrp','0048_merge_20240327_2339','2024-03-28 06:39:25.661896'),(73,'mrp','0048_auto_20240329_1405','2024-04-24 08:06:50.218619'),(74,'mrp','0049_auto_20240329_1406','2024-04-24 08:06:51.270940'),(75,'mrp','0050_auto_20240329_1406','2024-04-24 08:06:52.925201'),(76,'mrp','0051_auto_20240329_2110','2024-04-24 08:06:53.134789'),(77,'mrp','0052_auto_20240329_2229','2024-04-24 08:06:53.926915'),(78,'mrp','0053_auto_20240329_2326','2024-04-24 08:06:54.473467'),(79,'mrp','0054_auto_20240330_1029','2024-04-24 08:06:54.521359'),(80,'mrp','0055_auto_20240331_0023','2024-04-24 08:06:54.908629'),(81,'mrp','0056_auto_20240412_1834','2024-04-24 08:06:55.094350'),(82,'mrp','0057_auto_20240412_1842','2024-04-24 08:06:55.429142'),(83,'mrp','0058_financialprofile_tolid_randeman_mazrab_3','2024-04-24 08:06:55.479112'),(84,'mrp','0059_alter_sysuser_options','2024-04-24 08:06:55.511092'),(85,'mrp','0060_failure_is_it_count','2024-04-24 08:06:55.635015'),(86,'mrp','0061_alter_failure_is_it_count','2024-04-24 08:06:55.867869'),(87,'mrp','0062_alter_failure_is_it_count','2024-04-24 08:06:55.875865'),(88,'mrp','0063_merge_20240424_0106','2024-04-24 08:06:55.880862'),(89,'mrp','0064_alter_shift_name','2024-05-15 06:05:45.314305'),(90,'mrp','0063_auto_20240529_2018','2024-05-30 07:03:10.556090'),(91,'mrp','0064_alter_assetrandemanpermonth_tolid_value','2024-05-30 07:03:10.788814'),(92,'mrp','0065_merge_20240529_2338','2024-05-30 07:03:10.819956'),(93,'mrp','0065_asset_assetvahed','2024-10-19 07:39:57.197959'),(94,'mrp','0066_dailyproduction_vahed','2024-10-19 09:40:52.836876');
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
INSERT INTO `django_session` VALUES ('0cmqy3sifa31e4xyok44w7cqxdcuco5b','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1s9M8D:aE8gtKG0wAWq68b-sVhx8ngQz94SHgC8dOpfndr-34o','2024-06-04 09:50:05.167786'),('0s3itgfy5jewh2gvchgwpc8530zq0fa4','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1sBscP:hHreH7Ok9YUIsz4gd_YRl-m_sR0FgUkqdZwsxWNr-74','2024-06-11 08:55:41.875680'),('22ed0xe3qq8dgl36udgfbpjdv2ir7d06','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1sGtIB:MFSS9GASwJ0JlSAm9UDPcep8vxiTHmDTQ0KXNLMonQ4','2024-06-25 04:39:31.823094'),('2dxlzo8gc084zt9ozu5c2tmihpscefo8','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rp0WR:Q4azxHFe4XrYyTfNf8yqw0Rg_Y1Mj7OvRt0UGNaDjBs','2024-04-09 06:42:59.806787'),('2fpjrkrm5q9n0nicit57umkbiueezz6m','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1ra9pS:am7Whagd3fhPHzyxu5pogA_QS4kOQ7QNKuuu0n3OCDc','2024-02-28 07:37:14.927705'),('38qufhtnm9hqfp5k76qp6i56ekb927h2','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rUQOU:_DISoLeoKtOyFYV6CBJAcPvr1XiahMvijd2-LhqUDWA','2024-02-12 12:05:42.669927'),('57p1q8t2rrjqn32rlqshwybt11axxped','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1sgJJd:T8mxocOZoJ7eENJ59W9m3Lrc-MrjqmctUSokEKsI_e4','2024-09-03 07:30:05.047833'),('7k0k2bpm4hsdf1ah62v5r6r0stn91fdf','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rDO2k:tXJZ--0FvCy1mLM9sr5ZYWYl0dtW8n9cKKDf_COydO0','2023-12-27 12:08:50.884359'),('7ojhhy9kxzw71ew7d7brkk9vwq1q14zx','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1sOXbY:9uNN2qsKByBoHEPBRtDoqPfUKufR_C6whkGEajp_d7M','2024-07-16 07:07:08.118869'),('7x1ihd5gwj65lojbjszhvowdcn248d9i','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1s6nlw:NSlu81beAPiymGIEiBhdVTjwBOiL8_mxtwZOtlklEYU','2024-05-28 08:44:32.648041'),('9owh2npgza2yz4a7kx2pp6kp6d02uf9p','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1s0dyF:75EuCau3QJx5C1Th9ZU8t1LWPGPP2j3IaJyaqx5lS1c','2024-05-11 09:03:47.672140'),('9u3es1mv7f4ogzto7uxx6gtkpmrm99at','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1s78m6:DioMG6YMeQGDPwtzHeCrGdiPhKtNbzbMvIQbg8hqdyE','2024-05-29 07:10:06.598166'),('au6ut6acjh8wqh54qhdb6s359q6whjho','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rJreV:_d-NjLvPO5zQVsRrZVBi7_dGwTteGk5R801tzWO4zE4','2024-01-14 08:58:35.369055'),('au974wtk1joxw50sd48vicnavm91dqra','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1sB94x:rKaRImiuOTNBFOjzAnCDc45Bt38vtQmaWveVQgb3x_E','2024-06-09 08:18:07.443101'),('ay1nffa08tau4u4t83mf0x1feh8e9nt1','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1sBA8n:UizIgx3lyIXrtEskEIh0y_6V_zmjuIsGfBeqgaLtWGY','2024-06-09 09:26:09.178167'),('b39ggxssso96tkam2cfeusu5tf93u3k8','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rSERp:OnIxSvZCBKrETbGQLxrzWyvu2F7WtyMrnQEOQ6PgnKc','2024-02-06 10:56:05.101511'),('bdz7tgr9bby4woe4xjsg4akueekn44ap','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rpO46:iqdABJRVS-kIk9R8BEKxL5KwwvrhxkMjU1HZIHcZLN4','2024-04-10 07:51:18.693761'),('btkyg92ceh7lcktjevlh5624iw04toe4','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rU2Mt:hAVMPyfbKV2scJNmIER9hClMLRghbPqpOpICeW6oI4g','2024-02-11 10:26:27.312700'),('ceznq65xfzh3u9ln9fticzsb673vgqnf','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1sCZvF:nG7j8GaFUFkCO2c3eHH_BkTdB9wAWfrpZYGM8KW_zN8','2024-06-13 07:10:01.104772'),('dgkip5b7apbglbxc0hhyc2rzfk0a58xd','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1t243k:m2oREZH4HmIu84zLhMaL39YsuFJpuxGusR7Fuo9z3uo','2024-11-02 07:39:36.250945'),('fauodtzdutn1geg2cz5oa9gzx1udbkfz','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rCyom:Mv_RcGJiW4EZCryGv_khmLKn6y6WqEgsjnXxN6enIjQ','2023-12-26 09:12:44.419167'),('fivbgzcmk8ipcrf0lrnttt49kk9qeqly','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1s0ge9:CFbvAVfEwZZsQ7SLbO3Ak-HK-3vf8Kvym9O9fWE_1sM','2024-05-11 11:55:13.268182'),('hj5ahbpxbwex532hh858asu1gzt6ugse','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1s8Gjj:xndme8M3r_xNzzneFMdoIycTNXcZtawUgTFBdK659_A','2024-06-01 09:52:19.562697'),('hv4qq686fqza9l94owfhwkzt5jweg2tv','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1sZ3N1:R3GwOPjwP9QiNkMUBnEZNqZDXTOzI8DXrnRUIsUIe0E','2024-08-14 07:03:35.329013'),('i401su1yf08cove076pfewtxa20za59j','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rCcpp:WmvEx2qA5fFma9GPBf8QTBsna4m4Ctt4xCvntrN6-OE','2023-12-25 09:44:21.643394'),('i6rrosj1kma7jehcv4392jmeauwqzknn','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rp1eo:J1xs3RRojOw3I4LXl01a5mHZfjEfuIaTzDDu3su_N64','2024-04-09 07:55:42.327739'),('i6yneopyuygq7345h0aqgdrxirbkowpe','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1sVkHT:IjSs2pWKzEMu5OccfsSI0_e4kg85x0std8cArJ1JQYw','2024-08-05 04:04:11.059555'),('msug6ljakqitc612ddfis1ndswhk2mgr','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1s7U1V:62dDXhvjIpUWxuqjJLKD9rHJWZvtWtkaUYLG-2r2yrA','2024-05-30 05:51:25.492678'),('mtts10yommv21feic40u4rao8jxk1o2k','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rUMtk:ToXmydYzg6QFBRmpo4z-znf7wpIMM3yHg_yWcgH7Nbw','2024-02-12 08:21:44.815977'),('n4nywac0vgovd9xms1c73s9mbh48nler','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1sjYlg:EWUMkpE4GgME-EjKLbFtqo6XiJIZ6rLMxiHemm-Tw7A','2024-09-12 06:36:28.438864'),('nkya8enuhhzf8wu0khc1bkvs7tqebl0e','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1sVlE5:z3-WWJwNimUo7jvSvRI_tOtwhtH0vS2ijomMFr9HC9U','2024-08-05 05:04:45.976584'),('pkkak6krp8lamuaidz9o7fhhy7a8mw5y','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1s8cCf:Txaujrj-3RjKyC05CrxFYw067EXvkZuZscwIIF9jGAI','2024-06-02 08:47:37.294231'),('ri3dp5ye4pasd1hiwn1huv061gs6dysv','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rN9hQ:4otptzdX6CzKkjfaiw9pAJXsbw4LKD9Dk7JHNjQiunY','2024-01-23 10:51:12.722759'),('rlrk1rsp66951plh1queyol2tdxmybx0','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1sOAOr:8QhZ8f_XKbV0LNj9eJ2yq9LwPcejTMeDam0DSCNazjA','2024-07-15 06:20:29.529281'),('ruk9e17jb7uhf5b87olur1kir7zh2ang','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rjbWP:RM9KUuB0fQvl2gxb7py23T9j0aC35jvUH_6blSCBRC8','2024-03-25 09:00:37.908796'),('s6wfxjzo3f09uelm511tcxpdben2k6xi','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rUQCu:Yf8lx6NQoR-2fcYZ-bHzkUBSn9C8nC7STOe9f_LozIY','2024-02-12 11:53:44.562747'),('sirdzxcbx72dajgjcazhqrrpy5k2pmkw','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1sNQiY:BFbY_f2-Q8_SBr-OZykqljHuaYwdXxel2N6jH5kUSqI','2024-07-13 05:33:46.216464'),('stvf66e6t44b8hvmdsn1frxnvwi3l60x','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1s6PTu:Rf0h2Wmvo_bZ4BvkptqqBmYEP-Bk3m-DJMZF-Nf0w_Q','2024-05-27 06:48:18.486703'),('tl0j6qlf5e7kb1tvihp1k1uyplebr9ob','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rvWt3:AbsDLocG1aAn35fnEfTxO0GTWqmjScfqWrEjFj9i0mM','2024-04-27 06:29:17.179086'),('tlv4iuvdhib9xvnm0kw2peijywngu31f','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1sAkmM:MaTmEV9ytf98fdzDWhVa3gLhocDk0AT1gUeatO9P-Uo','2024-06-08 06:21:18.755809'),('tsgplhjmy4or4nf893eb3jivr8wni7rj','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rCdGz:2N1cMSHyz16I6DmA8r-WGoltBZ-nldhzJzDHic-Ch5Q','2023-12-25 10:12:25.036309'),('vzxt8o187z5dn4mjkhcz0zwk1y5fbd2l','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rpkEU:wsIkXjR-arH1GwxB4rkjjkYezLaZbXRpkaMINLkWXhw','2024-04-11 07:31:30.194305'),('wbyc4lbc47skknr4089l9v9cn9zs54m1','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rM6AC:Z_1ouzEIJGo5v8829BzH_2SH7v9d23o19vGLWfN3pMQ','2024-01-20 12:52:32.051849'),('wjlulan5ohco15zb7apu26tqxlx2ryff','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1ryrr0:XJGvPWuV2QZhfrKNWtiGkIvYMvT2QqShw9-G4eWnCFQ','2024-05-06 11:28:58.096604'),('wntxrulnzee1nzvngw9whpnwmohdprby','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1s3Y7r:nUySE6FBGDxQgMK_atn0yTzsVGtoffARTE_jyt5hqkw','2024-05-19 09:25:43.298140'),('x7w0y4t3j4min7unaaxhb3f422xpv63x','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1saqbS:82wgJ6CuVdKKPVQ2lnvUa1EDSyCzR7_F-tiOEvVXew0','2024-08-19 05:49:54.095661'),('xjyiy9z93rfyul3w9fpdmqq2dud73z1m','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1s62qj:7gfQ3fnY_TBVdgMyacNMFPHL_tSGiYY2OEc-M0UdcB8','2024-05-26 06:38:21.059635'),('z67ydsqbpexjoi0n9htlywkqw67xpm3y','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1reWXl:1U1GB_SUGhhkPAms45HgQ7IzvAv0OISWBOQ5TsisQpI','2024-03-11 08:41:01.749117'),('zkehen0fz757kgxxlymeqjjk73uys8iy','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1rZRr1:mZWPTOj7v_9zxcnSNhMZDb1xxXGZJPgh-s2crdgUnhs','2024-02-26 08:39:55.061033'),('zxncvax8s8d2tdeeutngigh4zhf5adn8','.eJxVjDsOwjAQRO_iGlnrxbGzlPScwVr_cADZUpxUiLuTSCmgmWLem3kLx-tS3NrT7KYoLkKJ02_nOTxT3UF8cL03GVpd5snLXZEH7fLWYnpdD_fvoHAv2zplDibgQIxszwk0okGjGNjgOGxh2cTgIymfEcasIgRNFgA1EFkSny_g0jcw:1sO9lp:tm8RKcGHNMpHU7EIDKhx-bBGFcIrfstJCK4fBTstm8g','2024-07-15 05:40:09.630038');
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
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failure`
--

LOCK TABLES `failure` WRITE;
/*!40000 ALTER TABLE `failure` DISABLE KEYS */;
INSERT INTO `failure` VALUES (12,'01','برقی',1),(13,'02','فنی',1),(14,'03','کمبود مواد',1),(15,'04','کمبود بانکه',1),(16,'05','تعویض رنگ',1),(17,'06','عدم نیاز',1),(18,'07','کمبود نیرو',1),(19,'08','استارت رینگ',1),(20,'09','افت دما',1),(21,'10','عقب افتادن ریل',1),(22,'11','برقی و فنی',1),(23,'12','پارگی نخ ها و سربندی مجدد',1),(24,'13','عیب تاسیساتی',1),(25,'14','نشتی هوای فشرده',1),(26,'15','تاب گیری کریل',1),(27,'16','کمبود بوبین',1),(28,'17','تنظیمی زدن برای فینیشر',1),(29,'18','شافت پیچی',1),(30,'19','نظافت',1),(31,'20','قطع برق',1),(32,'21','خالی بودن مخزن آب و روغن',1),(33,'22','گره در ساندویچی',1),(34,'23','اتمام خط',1),(35,'24','نمونه گیری',1),(36,'25','پر کردن کریل',1),(37,'26','سرویس کاری',1),(38,'27','کمبود ماسوره',1),(39,'28','کمبود نیرو',0),(40,'29','متفرقه',1);
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `financialprofile`
--

LOCK TABLES `financialprofile` WRITE;
/*!40000 ALTER TABLE `financialprofile` DISABLE KEYS */;
INSERT INTO `financialprofile` VALUES (1,'فروردین 1403','2024-04-27 11:59:40.655293',90000000,36000000,55000000),(3,'خرداد 1403','2024-07-01 10:41:24.972395',90000000,36000000,55000000);
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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
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
  UNIQUE KEY `mrp_assetfailure_asset_name_id_shift_id_f_cd2a2ae3_uniq` (`asset_name_id`,`shift_id`,`failure_name_id`,`dayOfIssue`),
  KEY `mrp_assetfailure_asset_name_id_c2925acd_fk_assets_id` (`asset_name_id`),
  KEY `mrp_assetfailure_failure_name_id_519162f5_fk_failure_id` (`failure_name_id`),
  KEY `mrp_assetfailure_shift_id_b5d785e5_fk_shift_id` (`shift_id`),
  CONSTRAINT `mrp_assetfailure_asset_name_id_c2925acd_fk_assets_id` FOREIGN KEY (`asset_name_id`) REFERENCES `assets` (`id`),
  CONSTRAINT `mrp_assetfailure_failure_name_id_519162f5_fk_failure_id` FOREIGN KEY (`failure_name_id`) REFERENCES `failure` (`id`),
  CONSTRAINT `mrp_assetfailure_shift_id_b5d785e5_fk_shift_id` FOREIGN KEY (`shift_id`) REFERENCES `shift` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6284 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
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
  `description` longtext NOT NULL,
  `price_sarshift` decimal(10,0) NOT NULL,
  `profile_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `nezafatpadash_profile_id_73222534_fk_financialprofile_id` (`profile_id`),
  CONSTRAINT `nezafatpadash_profile_id_73222534_fk_financialprofile_id` FOREIGN KEY (`profile_id`) REFERENCES `financialprofile` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nezafatpadash`
--

LOCK TABLES `nezafatpadash` WRITE;
/*!40000 ALTER TABLE `nezafatpadash` DISABLE KEYS */;
INSERT INTO `nezafatpadash` VALUES (13,1,50000000,'ds',8000000,NULL),(14,2,35000000,'2',6000000,NULL),(15,3,20000000,'2',4000000,NULL),(16,3,30000000,'رتبه سوم',6000000,1),(17,2,50000000,'رتبه دوم',8000000,1),(18,1,70000000,'رتبه اول',10000000,1),(22,1,70000000,'رتبه اول',10000000,3),(23,2,50000000,'رتبه دوم',8000000,3),(24,3,30000000,'رتبه سوم',6000000,3);
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
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nezafatranking`
--

LOCK TABLES `nezafatranking` WRITE;
/*!40000 ALTER TABLE `nezafatranking` DISABLE KEYS */;
INSERT INTO `nezafatranking` VALUES (43,1,38,1,50000000,8000000),(44,2,38,2,20000000,4000000),(45,3,38,3,35000000,6000000),(55,1,42,1,70000000,10000000),(56,3,42,2,30000000,6000000),(57,2,42,3,50000000,8000000),(70,1,47,1,70000000,10000000),(71,3,47,2,30000000,6000000),(72,2,47,3,50000000,8000000),(79,1,50,1,0,0),(80,2,50,2,0,0),(81,3,50,3,0,0),(82,2,51,1,50000000,8000000),(83,3,51,2,30000000,6000000),(84,1,51,3,70000000,10000000),(91,2,54,1,50000000,8000000),(92,3,54,2,30000000,6000000),(93,1,54,3,70000000,10000000),(94,2,55,1,50000000,8000000),(95,1,55,2,70000000,10000000),(96,3,55,3,30000000,6000000);
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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
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
  `price_sarshift` decimal(10,0) NOT NULL,
  `price_personnel` decimal(10,0) NOT NULL,
  `profile_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tolidpadash_profile_id_9fd627e7_fk_financialprofile_id` (`profile_id`),
  CONSTRAINT `tolidpadash_profile_id_9fd627e7_fk_financialprofile_id` FOREIGN KEY (`profile_id`) REFERENCES `financialprofile` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tolidpadash`
--

LOCK TABLES `tolidpadash` WRITE;
/*!40000 ALTER TABLE `tolidpadash` DISABLE KEYS */;
INSERT INTO `tolidpadash` VALUES (13,'e2',1,9500000,95000000,NULL),(14,'e1',2,7500000,7500000,NULL),(15,'e1',3,5500000,5500000,NULL),(16,'رتبه سوم',3,7000000,70000000,1),(17,'رتبه دوم',2,10000000,100000000,1),(18,'رتبه اول',1,13000000,130000000,1),(22,'رتبه اول',1,14000000,165000000,3),(23,'رتبه دوم',2,11000000,135000000,3),(24,'رتبه سوم',3,7100000,105000000,3);
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
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tolidranking`
--

LOCK TABLES `tolidranking` WRITE;
/*!40000 ALTER TABLE `tolidranking` DISABLE KEYS */;
INSERT INTO `tolidranking` VALUES (43,1,38,1,75000000,7500000),(44,3,38,2,75000000,7500000),(45,2,38,3,75000000,7500000),(55,1,42,1,130000000,13000000),(56,2,42,2,100000000,10000000),(57,3,42,3,70000000,7000000),(70,1,47,1,130000000,13000000),(71,3,47,2,70000000,7000000),(72,2,47,3,100000000,10000000),(79,1,50,1,165000000,14000000),(80,2,50,2,135000000,11000000),(81,3,50,3,105000000,7100000),(82,1,51,1,165000000,14000000),(83,3,51,2,105000000,7100000),(84,2,51,3,135000000,11000000),(91,1,54,1,165000000,14000000),(92,3,54,2,105000000,7100000),(93,2,54,3,135000000,11000000),(94,1,55,1,165000000,14000000),(95,2,55,2,135000000,11000000),(96,3,55,3,105000000,7100000);
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
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zayeatvazn`
--

LOCK TABLES `zayeatvazn` WRITE;
/*!40000 ALTER TABLE `zayeatvazn` DISABLE KEYS */;
INSERT INTO `zayeatvazn` VALUES (73,0,1,'2024-06-24',1),(74,0,2,'2024-06-24',1),(75,0,1,'2024-06-24',2),(76,0,2,'2024-06-24',2),(77,0,1,'2024-06-24',3),(78,0,2,'2024-06-24',3);
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

-- Dump completed on 2024-10-19 14:59:49
