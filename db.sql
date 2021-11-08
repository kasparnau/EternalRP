-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.6.4-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for sitt
CREATE DATABASE IF NOT EXISTS `sitt` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;
USE `sitt`;

-- Dumping structure for table sitt.admins
CREATE TABLE IF NOT EXISTS `admins` (
  `hex` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `level` int(11) DEFAULT 100,
  PRIMARY KEY (`hex`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt.admins: ~1 rows (approximately)
/*!40000 ALTER TABLE `admins` DISABLE KEYS */;
INSERT INTO `admins` (`hex`, `level`) VALUES
	('steam:11000010c692ef1', 100);
/*!40000 ALTER TABLE `admins` ENABLE KEYS */;

-- Dumping structure for table sitt.admin_logs
CREATE TABLE IF NOT EXISTS `admin_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license2` text DEFAULT 'unknown',
  `name` text DEFAULT 'unknown',
  `action` text DEFAULT 'unknown',
  `log` text DEFAULT 'unknown',
  `date` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=468 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table sitt.admin_logs: ~0 rows (approximately)
/*!40000 ALTER TABLE `admin_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `admin_logs` ENABLE KEYS */;

-- Dumping structure for table sitt.bank_accounts
CREATE TABLE IF NOT EXISTS `bank_accounts` (
  `account_id` int(11) NOT NULL AUTO_INCREMENT,
  `character_id` int(11) DEFAULT 0,
  `account_name` varchar(50) DEFAULT 'Personal Account',
  `account_balance` int(11) DEFAULT 0,
  `type` enum('PERSONAL','OTHER') DEFAULT 'PERSONAL',
  PRIMARY KEY (`account_id`) USING BTREE,
  KEY `character` (`character_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=172 DEFAULT CHARSET=latin1;

-- Dumping data for table sitt.bank_accounts: ~6 rows (approximately)
/*!40000 ALTER TABLE `bank_accounts` DISABLE KEYS */;
INSERT INTO `bank_accounts` (`account_id`, `character_id`, `account_name`, `account_balance`, `type`) VALUES
	(1, 0, 'State', 0, 'OTHER'),
	(2, 3, 'LSPD', 0, 'OTHER'),
	(3, 0, 'EMS', 0, 'OTHER'),
	(167, 63, 'Personal Account', 0, 'PERSONAL'),
	(170, 66, 'Personal Account', 0, 'PERSONAL'),
	(171, 67, 'Personal Account', 0, 'PERSONAL');
/*!40000 ALTER TABLE `bank_accounts` ENABLE KEYS */;

-- Dumping structure for table sitt.bank_transactions
CREATE TABLE IF NOT EXISTS `bank_transactions` (
  `transaction_id` int(11) NOT NULL AUTO_INCREMENT,
  `payee_account_id` int(11) NOT NULL DEFAULT 0,
  `receiver_account_id` int(11) NOT NULL DEFAULT 0,
  `amount` int(11) NOT NULL DEFAULT 0,
  `transaction_type` enum('withdraw','deposit','transfer','payslip','purchase','forfeiture','grant','bill') NOT NULL DEFAULT 'deposit',
  `comment` text DEFAULT '',
  `timestamp` int(11) DEFAULT unix_timestamp(),
  PRIMARY KEY (`transaction_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1216 DEFAULT CHARSET=latin1;

-- Dumping data for table sitt.bank_transactions: ~0 rows (approximately)
/*!40000 ALTER TABLE `bank_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `bank_transactions` ENABLE KEYS */;

-- Dumping structure for table sitt.bans
CREATE TABLE IF NOT EXISTS `bans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `enabled` int(11) DEFAULT 1,
  `license` varchar(60) COLLATE utf8mb4_bin DEFAULT 'none',
  `license2` varchar(50) COLLATE utf8mb4_bin DEFAULT 'none',
  `steam` varchar(60) COLLATE utf8mb4_bin DEFAULT 'none',
  `discord` varchar(60) COLLATE utf8mb4_bin DEFAULT 'none',
  `fivem` varchar(60) COLLATE utf8mb4_bin DEFAULT 'none',
  `date` int(11) DEFAULT unix_timestamp(),
  `length` int(11) DEFAULT 1605196234,
  `reason` text COLLATE utf8mb4_bin DEFAULT 'None',
  `banner` text COLLATE utf8mb4_bin DEFAULT 'Unknown',
  `secret_reason` text COLLATE utf8mb4_bin DEFAULT 'Unknown',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `license` (`license`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table sitt.bans: ~0 rows (approximately)
/*!40000 ALTER TABLE `bans` DISABLE KEYS */;
/*!40000 ALTER TABLE `bans` ENABLE KEYS */;

-- Dumping structure for table sitt.bills
CREATE TABLE IF NOT EXISTS `bills` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text DEFAULT '',
  `reason` text DEFAULT '',
  `amount` int(11) NOT NULL DEFAULT 0,
  `owner` int(11) NOT NULL DEFAULT 0,
  `date` int(11) DEFAULT unix_timestamp(),
  `paid` int(11) DEFAULT 0,
  `receiver` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=latin1;

-- Dumping data for table sitt.bills: ~44 rows (approximately)
/*!40000 ALTER TABLE `bills` DISABLE KEYS */;
INSERT INTO `bills` (`id`, `title`, `reason`, `amount`, `owner`, `date`, `paid`, `receiver`) VALUES
	(9, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper for: Trahv', 2020, 1, 1609098484, 1, 0),
	(10, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper for: Trahv', 2020, 1, 1609098534, 1, 0),
	(11, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper for: Trahv', 2020, 1, 1609098618, 1, 0),
	(12, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper for: Trahv', 2020, 1, 1609098621, 1, 0),
	(13, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper for: Trahv', 2020, 1, 1609098621, 1, 0),
	(14, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper for: Trahv', 2020, 1, 1609098622, 1, 0),
	(15, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper for: Trahv', 2020, 1, 1609098622, 1, 0),
	(16, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper for: Trahv kiirustamise eest!', 2020, 1, 1609099200, 1, 1),
	(17, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper for: Trahv\\', 1500, 1, 1609099933, 1, 1),
	(18, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper for: Trahv', 15000, 1, 1609099997, 1, 1),
	(19, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper for: Trahv', 15000, 1, 1609100063, 1, 1),
	(20, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper for: HAHA HOMO', 999, 1, 1609102114, 1, 1),
	(21, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper for: HAHHAHA PEDE', 50, 1, 1609102257, 1, 1),
	(22, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper for: Speeding, reckless evading, narko omamine 5g, narko myymine,', 6000, 1, 1609105734, 1, 1),
	(23, 'EMS Bill', 'Issued by Teet Ruuper to Teet Ruuper for: Arve', 5000, 1, 1609120097, 1, 3),
	(24, 'EMS Bill', 'Issued by Teet Ruuper to Teet Ruuper', 2500, 1, 1609120100, 1, 3),
	(25, 'EMS Bill', 'Issued by Teet Ruuper to Teet Ruuper for: Ara maksa mind lol!', 69420, 1, 1609030200, 1, 3),
	(26, 'EMS Bill', 'Issued by Teet Ruuper to Teet Ruuper for: UUS ARVE', 4000, 1, 1609120242, 1, 3),
	(27, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper for: trahv millegi eest woowowowo', 4600, 1, 1609120256, 1, 1),
	(28, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper for: Trahv auto varastamise eest!!!', 7000, 1, 1609209996, 1, 1),
	(29, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper for: Trahv auto varastamise eest!!!', 7000, 1, 1609210040, 1, 1),
	(30, 'LSPD Bill', 'Issued by Teet Ruuper to Stepi Procent for: Trahv auto varastamise eest!!!', 7000, 3, 1609210088, 1, 1),
	(31, 'LSPD Bill', 'Issued by Teet Ruuper to Stepi Procent for: haha vaene', 1000000, 3, 1609254121, 0, 1),
	(32, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper', 5000, 1, 1609581082, 1, 1),
	(33, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper', 5000, 1, 1609581303, 1, 1),
	(34, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper', 165, 1, 1609581447, 1, 1),
	(35, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper', 5000000, 1, 1609581457, 0, 1),
	(36, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper', 12, 1, 1609581537, 1, 1),
	(37, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper', 12, 1, 1609581746, 1, 1),
	(38, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper', 12, 1, 1609581746, 1, 1),
	(39, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper', 12, 1, 1609581747, 1, 1),
	(40, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper', 12, 1, 1609581748, 1, 1),
	(41, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper', 12, 1, 1609581776, 1, 1),
	(42, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper for: Please kill me', 70000, 1, 1609582322, 1, 1),
	(43, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper for: Please kill me', 70000, 1, 1609582370, 1, 1),
	(44, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper for: Please kill me', 70000, 1, 1609582375, 1, 1),
	(45, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper for: Please kill me', 70000, 1, 1609582375, 1, 1),
	(46, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper for: Kuhu kiire', 5000, 1, 1617170166, 1, 1),
	(47, 'LSPD Bill', 'Issued by Teet Ruuper to Teet Ruuper for: Kuhu kiire', 5000, 1, 1617170282, 1, 1),
	(48, 'LSPD Bill', 'Issued by 1 to 1 for: Traffic Stop', 5000, 1, 1617397135, 0, 1),
	(49, 'LSPD Bill', 'Issued by 1 to 1 for: Lol', 5000, 1, 1617401810, 0, 1),
	(50, 'LSPD Bill', 'Issued by 3 to 3 for: Mechanic', 500, 3, 1618172449, 1, 1),
	(51, 'LSPD Bill', 'Issued by 3 to 3 for: Mechanic', 500, 3, 1618173579, 1, 1),
	(52, 'LSPD Bill', 'Issued by 3 to 3 for: LOL GET REKET', 5000, 3, 1619723304, 1, 1);
/*!40000 ALTER TABLE `bills` ENABLE KEYS */;

-- Dumping structure for table sitt.characters
CREATE TABLE IF NOT EXISTS `characters` (
  `cid` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) DEFAULT 0,
  `gender` int(11) DEFAULT 0,
  `dob` varchar(10) DEFAULT '1899-01-01',
  `first_name` varchar(25) DEFAULT 'John',
  `last_name` varchar(25) DEFAULT 'Doe',
  `position` text DEFAULT '{"x":0,"y":0,"z":0,"heading":0}',
  `outfit` varchar(3000) DEFAULT '{"new":true}',
  `phone_number` text DEFAULT NULL,
  `job` text DEFAULT '',
  `inventory` text DEFAULT '{}',
  `status` text DEFAULT '{"hunger":100,"health":200,"thirst":100,"armor":0}',
  `dead` tinyint(1) DEFAULT 0,
  `jail_time` double DEFAULT 0,
  PRIMARY KEY (`cid`) USING BTREE,
  KEY `playerId` (`pid`) USING BTREE,
  KEY `characters_idx_phone_number` (`phone_number`(768)),
  CONSTRAINT `on_player_deleted` FOREIGN KEY (`pid`) REFERENCES `players` (`pid`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table sitt.characters: ~2 rows (approximately)
/*!40000 ALTER TABLE `characters` DISABLE KEYS */;
INSERT INTO `characters` (`cid`, `pid`, `gender`, `dob`, `first_name`, `last_name`, `position`, `outfit`, `phone_number`, `job`, `inventory`, `status`, `dead`, `jail_time`) VALUES
	(63, 1013, 0, '1999-01-01', 'Sass', 'Juss', '{"z":235.119140625,"y":-195.31863403320313,"x":-407.19085693359377,"heading":356.6499938964844}', '{"headStructure":[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0],"headBlend":{"shapeMix":0.0,"skinMix":1.0,"hasParent":false,"shapeSecond":0,"skinSecond":3,"skinThird":0,"thirdMix":0.0,"shapeFirst":3,"shapeThird":0,"skinFirst":11},"drawables":{"1":["masks",0],"2":["hair",0],"3":["torsos",0],"4":["legs",0],"5":["bags",0],"6":["shoes",1],"7":["neck",0],"8":["undershirts",0],"9":["vest",0],"10":["decals",0],"11":["jackets",0],"0":["face",0]},"headOverlay":[{"colourType":0,"firstColour":0,"name":"Blemishes","secondColour":0,"overlayOpacity":1.0,"overlayValue":255},{"colourType":1,"firstColour":0,"name":"FacialHair","secondColour":0,"overlayOpacity":0.0,"overlayValue":255},{"colourType":1,"firstColour":0,"name":"Eyebrows","secondColour":0,"overlayOpacity":1.0,"overlayValue":255},{"colourType":0,"firstColour":0,"name":"Ageing","secondColour":0,"overlayOpacity":1.0,"overlayValue":255},{"colourType":2,"firstColour":0,"name":"Makeup","secondColour":0,"overlayOpacity":1.0,"overlayValue":255},{"colourType":2,"firstColour":0,"name":"Blush","secondColour":0,"overlayOpacity":1.0,"overlayValue":255},{"colourType":0,"firstColour":0,"name":"Complexion","secondColour":0,"overlayOpacity":1.0,"overlayValue":255},{"colourType":0,"firstColour":0,"name":"SunDamage","secondColour":0,"overlayOpacity":1.0,"overlayValue":255},{"colourType":2,"firstColour":0,"name":"Lipstick","secondColour":0,"overlayOpacity":1.0,"overlayValue":255},{"colourType":0,"firstColour":0,"name":"MolesFreckles","secondColour":0,"overlayOpacity":1.0,"overlayValue":255},{"colourType":1,"firstColour":0,"name":"ChestHair","secondColour":0,"overlayOpacity":1.0,"overlayValue":255},{"colourType":0,"firstColour":0,"name":"BodyBlemishes","secondColour":0,"overlayOpacity":1.0,"overlayValue":255},{"colourType":0,"firstColour":0,"name":"AddBodyBlemishes","secondColour":0,"overlayOpacity":1.0,"overlayValue":255}],"proptextures":[["hats",0],["glasses",-1],["earrings",-1],["mouth",-1],["lhand",-1],["rhand",-1],["watches",-1],["braclets",-1]],"drawtextures":[["face",0],["masks",0],["hair",0],["torsos",0],["legs",0],["bags",0],["shoes",2],["neck",0],["undershirts",1],["vest",0],["decals",0],["jackets",11]],"hairColor":[1,1],"props":{"1":["glasses",-1],"2":["earrings",-1],"3":["mouth",-1],"4":["lhand",-1],"5":["rhand",-1],"6":["watches",-1],"7":["braclets",-1],"0":["hats",4]},"model":1885233650}', '1438754', '', '{"2":{"qty":1,"itemId":"phone"},"3":{"qty":1,"itemId":"citizen-card","metadata":{"Sex":"Male","Date of Birth":"1999-01-01","Citizen ID":63,"Full Name":"Sass Juss"}}}', '{"health":198,"hunger":94,"thirst":85,"armor":0}', 0, 0),
	(67, 1013, 0, '2000-01-01', 'Pederast', 'Pederastpederast', '{"z":29.49113464355468,"y":-809.5934448242188,"x":422.0314025878906,"heading":60.06784439086914}', '{"headStructure":[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0],"props":{"1":["glasses",-1],"2":["earrings",-1],"3":["mouth",-1],"4":["lhand",-1],"5":["rhand",-1],"6":["watches",-1],"7":["braclets",-1],"0":["hats",-1]},"drawables":{"1":["masks",0],"2":["hair",0],"3":["torsos",1],"4":["legs",0],"5":["bags",0],"6":["shoes",0],"7":["neck",0],"8":["undershirts",0],"9":["vest",0],"10":["decals",0],"11":["jackets",0],"0":["face",0]},"hairColor":[-1,-1],"headOverlay":[],"drawtextures":[["face",0],["masks",0],["hair",0],["torsos",0],["legs",1],["bags",0],["shoes",0],["neck",0],["undershirts",0],["vest",0],["decals",0],["jackets",0]],"proptextures":[["hats",-1],["glasses",-1],["earrings",-1],["mouth",-1],["lhand",-1],["rhand",-1],["watches",-1],["braclets",-1]],"model":-872673803}', '8754845', '', '{"7":{"qty":1,"itemId":"phone"},"9":{"qty":1,"itemId":"citizen-card","metadata":{"Sex":"Male","Citizen ID":67,"Date of Birth":"2000-01-01","Full Name":"Pederast Pederastpederast"}}}', '{"health":175,"hunger":97,"thirst":92,"armor":0}', 0, 0);
/*!40000 ALTER TABLE `characters` ENABLE KEYS */;

-- Dumping structure for table sitt.inventory_economy
CREATE TABLE IF NOT EXISTS `inventory_economy` (
  `citizen_id` int(11) NOT NULL,
  `action` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_qty` int(11) DEFAULT NULL,
  `content` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `timestamp` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt.inventory_economy: ~570 rows (approximately)
/*!40000 ALTER TABLE `inventory_economy` DISABLE KEYS */;
INSERT INTO `inventory_economy` (`citizen_id`, `action`, `item_id`, `item_qty`, `content`, `timestamp`) VALUES
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-14 20:46:41'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-14 20:47:03'),
	(48, 'REMOVE ITEM', 'cash', 2, '', '2021-10-14 20:49:31'),
	(48, 'ADD ITEM', 'pistol', 1, 'ADMIN', '2021-10-14 21:13:29'),
	(48, 'ADD ITEM', 'cash', 10000, 'ADMIN', '2021-10-14 22:02:37'),
	(48, 'ADD ITEM', 'cash', 10000, 'ADMIN', '2021-10-14 22:02:38'),
	(48, 'SHOP PURCHASE', 'pistol', 1, '1000', '2021-10-14 22:02:39'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-14 22:02:39'),
	(48, 'SHOP PURCHASE', 'pistol', 1, '1000', '2021-10-14 22:05:08'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-14 22:05:08'),
	(48, 'SHOP PURCHASE', 'pistol', 1, '1000', '2021-10-14 22:05:30'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-14 22:05:30'),
	(48, 'SHOP PURCHASE', 'pistol', 1, '1000', '2021-10-14 22:05:55'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-14 22:05:55'),
	(48, 'SHOP PURCHASE', 'pistol', 1, '1000', '2021-10-14 22:06:51'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-14 22:06:51'),
	(48, 'SHOP PURCHASE', 'pistol', 1, '1000', '2021-10-14 22:07:01'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-14 22:07:01'),
	(48, 'SHOP PURCHASE', 'pistol', 1, '1000', '2021-10-14 22:17:34'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-14 22:17:34'),
	(48, 'SHOP PURCHASE', 'pistol', 1, '1000', '2021-10-14 22:17:35'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-14 22:17:35'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-14 22:28:57'),
	(48, 'REMOVE ITEM', 'cash', 750, '', '2021-10-14 22:35:26'),
	(48, 'ADD ITEM', 'cash', 19999, 'ADMIN', '2021-10-15 00:29:27'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 00:29:28'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 00:29:30'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 00:30:24'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 00:32:02'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 00:42:32'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-15 01:10:17'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-15 01:10:26'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 01:19:09'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 01:19:22'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 01:19:25'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-15 01:29:56'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-15 01:30:40'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-15 01:30:43'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-15 01:30:48'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-15 01:30:51'),
	(48, 'REMOVE ITEM', 'cash', 1, '', '2021-10-15 01:42:38'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-15 01:42:51'),
	(48, 'ADD ITEM', 'cash', 99999, 'ADMIN', '2021-10-15 13:16:53'),
	(48, 'REMOVE ITEM', 'cash', 15, '', '2021-10-15 13:16:56'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:17:08'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:17:19'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:17:42'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-15 13:18:00'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:18:53'),
	(48, 'REMOVE ITEM', 'cash', 33, '', '2021-10-15 13:27:13'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:27:16'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:29:51'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:29:56'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:30:21'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:30:33'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:32:01'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:32:17'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-15 13:32:25'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:33:28'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:36:20'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-15 13:36:26'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:36:32'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-15 13:36:39'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-15 13:36:47'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:36:58'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:37:55'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:40:25'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:40:45'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:41:18'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:41:20'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:41:22'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:41:24'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:41:29'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:41:37'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:41:46'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:42:29'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:43:58'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:44:06'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-15 13:44:37'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:45:06'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:45:08'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 13:48:24'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-15 13:48:55'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-15 13:52:08'),
	(48, 'ADD ITEM', 'pistol', 1, 'ADMIN', '2021-10-15 15:04:51'),
	(48, 'ADD ITEM', 'ifak', 10, 'ADMIN', '2021-10-15 15:09:59'),
	(48, 'USE ITEM', 'ifak', 1, '', '2021-10-15 15:10:08'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 16:18:37'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 16:18:43'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 16:19:10'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 16:19:19'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 16:19:29'),
	(48, 'REMOVE ITEM', 'cash', 20000, '', '2021-10-15 16:19:32'),
	(48, 'REMOVE ITEM', 'cash', 20000, '', '2021-10-15 16:19:34'),
	(48, 'REMOVE ITEM', 'cash', 3, '', '2021-10-15 16:47:18'),
	(48, 'REMOVE ITEM', 'cash', 19, '', '2021-10-15 17:24:07'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 17:24:21'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 17:24:24'),
	(48, 'REMOVE ITEM', 'cash', 750, '', '2021-10-15 17:25:26'),
	(48, 'ADD ITEM', 'machine-pistol', 1, 'ADMIN', '2021-10-15 17:29:57'),
	(48, 'ADD ITEM', 'pistol-ammo', 3, 'ADMIN', '2021-10-15 17:30:00'),
	(48, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-15 17:30:10'),
	(48, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-15 17:30:16'),
	(48, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-15 17:30:21'),
	(48, 'ADD ITEM', 'rifle-ammo', 1, 'ADMIN', '2021-10-15 17:30:40'),
	(48, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-15 17:30:46'),
	(48, 'ADD ITEM', 'sub-ammo', 3, 'ADMIN', '2021-10-15 17:32:21'),
	(48, 'USE ITEM', 'sub-ammo', 1, '', '2021-10-15 17:32:29'),
	(48, 'USE ITEM', 'sub-ammo', 1, '', '2021-10-15 17:32:35'),
	(48, 'USE ITEM', 'sub-ammo', 1, '', '2021-10-15 17:32:40'),
	(48, 'ADD ITEM', 'sniper-rifle', 1, 'ADMIN', '2021-10-15 17:34:37'),
	(48, 'ADD ITEM', 'pistol-ammo', 1, 'ADMIN', '2021-10-15 17:38:13'),
	(48, '[ERROR] ADD ITEM FAIL | DROPPED TO GROUND', 'sniper-ammo', 1, 'ADMIN', '2021-10-15 17:38:46'),
	(48, 'USE ITEM', 'sniper-ammo', 1, '', '2021-10-15 17:39:17'),
	(48, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-15 17:39:49'),
	(48, '[ERROR] ADD ITEM FAIL | DROPPED TO GROUND', 'sniper-ammo', 1, 'ADMIN', '2021-10-15 17:40:22'),
	(48, 'USE ITEM', 'sniper-ammo', 1, '', '2021-10-15 17:40:31'),
	(48, 'ADD ITEM', 'rifle-ammo', 5, 'ADMIN', '2021-10-15 17:41:19'),
	(48, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-15 17:41:25'),
	(48, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-15 17:41:31'),
	(48, 'ADD ITEM', 'phone', 1, 'ADMIN', '2021-10-15 17:41:43'),
	(48, '[ERROR] ADD ITEM FAIL | DROPPED TO GROUND', 'baseball-bat', 1, 'ADMIN', '2021-10-15 17:58:42'),
	(48, 'ADD ITEM', 'weapon-cash', 1, 'ADMIN', '2021-10-15 18:05:47'),
	(48, 'ADD ITEM', 'cash-ammo', 1, 'ADMIN', '2021-10-15 18:05:49'),
	(48, 'USE ITEM', 'cash-ammo', 1, '', '2021-10-15 18:06:10'),
	(48, 'ADD ITEM', 'cash-ammo', 10, 'ADMIN', '2021-10-15 18:06:34'),
	(48, 'USE ITEM', 'cash-ammo', 1, '', '2021-10-15 18:06:41'),
	(48, 'USE ITEM', 'cash-ammo', 1, '', '2021-10-15 18:06:46'),
	(48, 'USE ITEM', 'cash-ammo', 1, '', '2021-10-15 18:17:52'),
	(48, 'ADD ITEM', 'stun-grenade', 1, 'ADMIN', '2021-10-15 18:40:08'),
	(48, 'ADD ITEM', 'stun-grenade', 10, 'ADMIN', '2021-10-15 18:40:09'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-15 18:48:19'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-15 18:50:55'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-15 18:50:58'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-15 18:51:05'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-15 18:52:24'),
	(48, 'ADD ITEM', 'stun-grenade', 5, 'ADMIN', '2021-10-15 18:54:44'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-15 18:54:58'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-15 18:55:36'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-15 18:56:52'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-15 18:57:49'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-15 19:20:45'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-15 19:21:51'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-15 19:22:20'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-15 19:23:38'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-15 19:24:07'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-15 19:24:32'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-15 19:24:43'),
	(48, 'ADD ITEM', 'stun-grenade', 3, 'ADMIN', '2021-10-15 19:25:14'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-15 19:25:19'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-15 19:26:30'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-15 19:28:56'),
	(48, '[ERROR] ADD ITEM FAIL | DROPPED TO GROUND', 'stun-grenade', 100, 'ADMIN', '2021-10-15 19:29:20'),
	(48, 'ADD ITEM', 'stun-grenade', 5, 'ADMIN', '2021-10-15 19:29:26'),
	(48, 'ADD ITEM', 'stun-grenade', 5, 'ADMIN', '2021-10-15 19:29:27'),
	(48, 'ADD ITEM', 'stun-grenade', 5, 'ADMIN', '2021-10-15 19:29:27'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-15 19:29:31'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-15 19:29:49'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-15 19:29:58'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-15 19:31:39'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-15 19:34:28'),
	(48, '[ERROR] ADD ITEM FAIL | DROPPED TO GROUND', 'sub-ammo', 100, 'ADMIN', '2021-10-15 19:35:31'),
	(48, 'ADD ITEM', 'sub-ammo', 1, 'ADMIN', '2021-10-15 19:35:37'),
	(48, 'USE ITEM', 'sub-ammo', 1, '', '2021-10-15 19:35:42'),
	(48, '[ERROR] ADD ITEM FAIL | DROPPED TO GROUND', 'weapon-brick', 1, 'ADMIN', '2021-10-15 19:47:37'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-15 19:50:37'),
	(48, 'ADD ITEM', 'weapon-brick', 5, 'ADMIN', '2021-10-15 19:58:57'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-15 20:00:43'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-15 20:00:48'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-15 20:01:33'),
	(48, 'ADD ITEM', 'stun-grenade', 1, 'ADMIN', '2021-10-15 20:09:49'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-15 20:09:59'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-15 20:10:03'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-15 20:10:12'),
	(48, 'ADD ITEM', 'weapon-brick', 5, 'ADMIN', '2021-10-15 20:10:34'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-15 20:10:39'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-15 20:10:44'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-15 20:13:33'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-15 20:13:37'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-15 20:13:41'),
	(48, 'ADD ITEM', 'weapon-brick', 3, 'ADMIN', '2021-10-15 20:14:09'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-15 20:14:15'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-15 20:14:21'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-15 20:14:25'),
	(48, 'ADD ITEM', 'glock', 1, 'ADMIN', '2021-10-15 20:18:33'),
	(48, '[ERROR] ADD ITEM FAIL | DROPPED TO GROUND', 'm4', 1, 'ADMIN', '2021-10-15 20:18:35'),
	(48, '[ERROR] ADD ITEM FAIL | DROPPED TO GROUND', 'm4', 1, 'ADMIN', '2021-10-15 20:19:49'),
	(48, 'ADD ITEM', 'assault-rifle', 1, 'ADMIN', '2021-10-15 20:20:15'),
	(48, 'ADD ITEM', 'weapon-brick', 2, 'ADMIN', '2021-10-15 20:20:43'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-15 20:21:18'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-15 20:21:23'),
	(48, 'REMOVE ITEM', 'cash', 750, '', '2021-10-15 20:22:57'),
	(48, 'REMOVE ITEM', 'cash', 116, '', '2021-10-15 20:45:45'),
	(48, 'REMOVE ITEM', 'cash', 116, '', '2021-10-15 20:45:47'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 20:46:09'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 20:46:21'),
	(48, 'SHOP PURCHASE', 'pistol-ammo', 1, '100', '2021-10-15 21:12:58'),
	(48, 'REMOVE ITEM', 'cash', 100, '', '2021-10-15 21:12:58'),
	(48, 'SHOP PURCHASE', 'weapon-ltl', 1, '500', '2021-10-15 21:13:00'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 21:13:00'),
	(48, 'SHOP PURCHASE', 'weapon-ltl', 1, '500', '2021-10-15 21:13:01'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-15 21:13:01'),
	(48, 'SHOP PURCHASE', 'shotgun-ammo', 1, '150', '2021-10-15 21:13:19'),
	(48, 'REMOVE ITEM', 'cash', 150, '', '2021-10-15 21:13:19'),
	(48, 'SHOP PURCHASE', 'shotgun-ammo', 1, '150', '2021-10-15 21:13:20'),
	(48, 'REMOVE ITEM', 'cash', 150, '', '2021-10-15 21:13:20'),
	(48, 'USE ITEM', 'shotgun-ammo', 1, '', '2021-10-15 21:13:26'),
	(48, 'USE ITEM', 'shotgun-ammo', 1, '', '2021-10-15 21:13:31'),
	(48, 'ADD ITEM', 'ltl-ammo', 1, 'ADMIN', '2021-10-15 21:19:52'),
	(48, 'USE ITEM', 'ltl-ammo', 1, '', '2021-10-15 21:20:49'),
	(48, 'SHOP PURCHASE', 'stun-gun', 1, '100', '2021-10-15 21:23:18'),
	(48, 'REMOVE ITEM', 'cash', 100, '', '2021-10-15 21:23:18'),
	(48, 'SHOP PURCHASE', 'stun-gun', 1, '100', '2021-10-15 21:28:12'),
	(48, 'REMOVE ITEM', 'cash', 100, '', '2021-10-15 21:28:12'),
	(48, 'SHOP PURCHASE', 'taser-ammo', 1, '50', '2021-10-15 21:28:34'),
	(48, 'REMOVE ITEM', 'cash', 50, '', '2021-10-15 21:28:34'),
	(48, 'USE ITEM', 'taser-ammo', 1, '', '2021-10-15 21:28:57'),
	(48, 'SHOP PURCHASE', 'taser-ammo', 1, '50', '2021-10-15 21:29:52'),
	(48, 'REMOVE ITEM', 'cash', 50, '', '2021-10-15 21:29:52'),
	(48, 'USE ITEM', 'taser-ammo', 1, '', '2021-10-15 21:29:59'),
	(48, 'SHOP PURCHASE', 'taser-ammo', 1, '50', '2021-10-15 21:32:44'),
	(48, 'REMOVE ITEM', 'cash', 50, '', '2021-10-15 21:32:44'),
	(48, 'SHOP PURCHASE', 'taser-ammo', 1, '50', '2021-10-15 21:32:45'),
	(48, 'REMOVE ITEM', 'cash', 50, '', '2021-10-15 21:32:45'),
	(48, 'SHOP PURCHASE', 'taser-ammo', 1, '50', '2021-10-15 21:32:46'),
	(48, 'REMOVE ITEM', 'cash', 50, '', '2021-10-15 21:32:46'),
	(48, 'USE ITEM', 'taser-ammo', 1, '', '2021-10-15 21:32:53'),
	(48, 'USE ITEM', 'taser-ammo', 1, '', '2021-10-15 21:32:59'),
	(48, 'USE ITEM', 'taser-ammo', 1, '', '2021-10-15 21:34:26'),
	(48, 'REMOVE ITEM', 'cash', 750, '', '2021-10-15 22:06:39'),
	(48, 'ADD ITEM', 'joint', 1, '', '2021-10-15 23:37:14'),
	(48, 'ADD ITEM', 'lockpick-set', 1, '', '2021-10-15 23:37:14'),
	(48, 'ADD ITEM', 'apple-iphone', 1, '', '2021-10-15 23:37:14'),
	(48, 'ADD ITEM', 'vodka', 1, '', '2021-10-15 23:37:14'),
	(48, 'ADD ITEM', 'joint', 1, '', '2021-10-15 23:37:14'),
	(48, 'ADD ITEM', 'cigarette', 1, '', '2021-10-15 23:37:14'),
	(48, 'ADD ITEM', 'aluminium-oxide', 1, '', '2021-10-15 23:38:41'),
	(48, 'ADD ITEM', 'milk', 1, '', '2021-10-15 23:38:41'),
	(48, 'ADD ITEM', 'beer', 1, '', '2021-10-15 23:38:41'),
	(48, 'ADD ITEM', 'joint', 1, '', '2021-10-15 23:38:41'),
	(48, 'ADD ITEM', 'lockpick-set', 1, '', '2021-10-15 23:38:41'),
	(48, 'ADD ITEM', 'apple-iphone', 1, '', '2021-10-15 23:38:41'),
	(49, 'USE ITEM', 'holy-water', 1, '', '2021-10-16 19:46:18'),
	(48, 'ADD ITEM', 'ltl-ammo', 1, 'ADMIN', '2021-10-16 19:46:48'),
	(48, 'ADD ITEM', 'ltl-ammo', 1, 'ADMIN', '2021-10-16 19:46:49'),
	(48, 'ADD ITEM', 'ltl-ammo', 1, 'ADMIN', '2021-10-16 19:46:50'),
	(48, 'ADD ITEM', 'ltl-ammo', 1, 'ADMIN', '2021-10-16 19:46:50'),
	(48, 'ADD ITEM', 'ltl-ammo', 1, 'ADMIN', '2021-10-16 19:46:50'),
	(48, 'ADD ITEM', 'weapon-brick', 1, 'ADMIN', '2021-10-16 19:46:54'),
	(48, 'ADD ITEM', 'weapon-brick', 1, 'ADMIN', '2021-10-16 19:46:54'),
	(48, 'ADD ITEM', 'weapon-brick', 1, 'ADMIN', '2021-10-16 19:46:55'),
	(48, 'ADD ITEM', 'taser-ammo', 1, 'ADMIN', '2021-10-16 19:47:05'),
	(48, 'ADD ITEM', 'taser-ammo', 1, 'ADMIN', '2021-10-16 19:47:05'),
	(48, 'ADD ITEM', 'taser-ammo', 1, 'ADMIN', '2021-10-16 19:47:06'),
	(48, 'ADD ITEM', 'weapon-ltl', 1, 'ADMIN', '2021-10-16 19:47:50'),
	(49, 'USE ITEM', 'taser-ammo', 1, '', '2021-10-16 19:48:03'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-16 19:48:03'),
	(48, 'USE ITEM', 'ltl-ammo', 1, '', '2021-10-16 19:48:18'),
	(49, 'USE ITEM', 'ltl-ammo', 1, '', '2021-10-16 19:48:20'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-16 19:52:56'),
	(49, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-16 19:53:10'),
	(49, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 19:53:27'),
	(49, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-16 19:56:14'),
	(49, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 19:56:51'),
	(48, 'ADD ITEM', 'weapon-brick', 3, 'ADMIN', '2021-10-16 19:59:26'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-16 20:00:25'),
	(48, 'SHOP PURCHASE', 'glock', 1, '500', '2021-10-16 20:03:20'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-16 20:03:20'),
	(48, 'SHOP PURCHASE', 'pistol-ammo', 1, '100', '2021-10-16 20:03:21'),
	(48, 'REMOVE ITEM', 'cash', 100, '', '2021-10-16 20:03:21'),
	(49, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-16 20:03:25'),
	(49, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-16 20:03:31'),
	(48, 'SHOP PURCHASE', 'rifle-ammo', 1, '150', '2021-10-16 20:03:35'),
	(48, 'REMOVE ITEM', 'cash', 150, '', '2021-10-16 20:03:35'),
	(48, 'REMOVE ITEM', 'cash', 750, '', '2021-10-16 20:05:11'),
	(48, 'REMOVE ITEM', 'cash', 79, '', '2021-10-16 20:07:26'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-16 20:08:02'),
	(48, 'ADD ITEM', 'safe-cracking-tool', 1, 'ADMIN', '2021-10-16 20:15:16'),
	(48, 'REMOVE ITEM', 'safe-cracking-tool', 1, '', '2021-10-16 20:15:22'),
	(49, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-16 20:15:25'),
	(48, 'ADD ITEM', 'safe-cracking-tool', 2, 'ADMIN', '2021-10-16 20:15:30'),
	(49, 'ADD ITEM', 'cash-stack', 55, '', '2021-10-16 20:15:58'),
	(49, 'ADD ITEM', 'cash', 13750, '', '2021-10-16 20:16:12'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-16 20:16:34'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-16 20:16:39'),
	(48, 'ADD ITEM', 'stun-grenade', 1, 'ADMIN', '2021-10-16 20:17:29'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-16 20:17:33'),
	(48, 'ADD ITEM', 'stun-grenade', 10, 'ADMIN', '2021-10-16 20:18:01'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-16 20:18:19'),
	(49, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-16 20:18:28'),
	(49, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-16 20:18:31'),
	(49, 'USE ITEM', 'milk', 1, '', '2021-10-16 20:19:10'),
	(49, 'USE ITEM', 'ifak', 1, '', '2021-10-16 20:19:44'),
	(49, 'USE ITEM', 'ifak', 1, '', '2021-10-16 20:19:53'),
	(48, 'USE ITEM', 'ifak', 1, '', '2021-10-16 20:19:54'),
	(49, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-16 20:23:32'),
	(49, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 20:23:48'),
	(48, 'ADD ITEM', 'stun-gun', 1, 'ADMIN', '2021-10-16 20:29:56'),
	(48, '[ERROR] ADD ITEM FAIL | DROPPED TO GROUND', 'weapon-brick', 10, 'ADMIN', '2021-10-16 20:36:09'),
	(48, '[ERROR] ADD ITEM FAIL | DROPPED TO GROUND', 'weapon-brick', 10, 'ADMIN', '2021-10-16 20:36:16'),
	(48, 'ADD ITEM', 'weapon-brick', 5, 'ADMIN', '2021-10-16 20:36:16'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-16 20:41:23'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-16 20:41:40'),
	(49, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-16 20:42:46'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-16 20:42:49'),
	(49, 'ADD ITEM', 'cash', 110, 'ROB CASH REGISTER', '2021-10-16 20:43:19'),
	(49, 'USE ITEM', 'ltl-ammo', 1, '', '2021-10-16 20:44:14'),
	(48, 'ADD ITEM', 'cash', 106, 'ROB CASH REGISTER', '2021-10-16 20:45:48'),
	(49, '[ERROR] ADD ITEM FAIL | DROPPED TO GROUND', 'safe-cracking-tool', 5, 'ADMIN', '2021-10-16 20:47:33'),
	(49, 'ADD ITEM', 'safe-cracking-tool', 1, 'ADMIN', '2021-10-16 20:47:34'),
	(49, 'ADD ITEM', 'safe-cracking-tool', 1, 'ADMIN', '2021-10-16 20:47:35'),
	(49, 'ADD ITEM', 'safe-cracking-tool', 1, 'ADMIN', '2021-10-16 20:47:35'),
	(49, 'ADD ITEM', 'safe-cracking-tool', 1, 'ADMIN', '2021-10-16 20:47:36'),
	(49, '[ERROR] ADD ITEM FAIL | DROPPED TO GROUND', 'safe-cracking-tool', 1, 'ADMIN', '2021-10-16 20:47:36'),
	(48, 'REMOVE ITEM', 'safe-cracking-tool', 1, '', '2021-10-16 20:48:41'),
	(49, 'REMOVE ITEM', 'safe-cracking-tool', 1, '', '2021-10-16 20:48:50'),
	(48, 'ADD ITEM', 'safe-cracking-tool', 10, 'ADMIN', '2021-10-16 20:49:14'),
	(49, 'USE ITEM', 'sprunk', 1, '', '2021-10-16 20:50:02'),
	(48, 'USE ITEM', 'ifak', 1, '', '2021-10-16 20:54:04'),
	(48, 'ADD ITEM', 'm4', 1, 'ADMIN', '2021-10-16 21:08:44'),
	(49, 'ADD ITEM', 'm4', 1, 'ADMIN', '2021-10-16 21:09:52'),
	(49, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 21:10:14'),
	(49, 'ADD ITEM', 'rifle-ammo', 3, 'ADMIN', '2021-10-16 21:11:55'),
	(49, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 21:12:03'),
	(49, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 21:13:43'),
	(49, 'ADD ITEM', 'rifle-ammo', 1, 'ADMIN', '2021-10-16 21:14:24'),
	(49, 'ADD ITEM', 'rifle-ammo', 1, 'ADMIN', '2021-10-16 21:14:25'),
	(49, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 21:14:34'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-16 21:15:03'),
	(49, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 21:16:30'),
	(48, 'ADD ITEM', 'rifle-ammo', 10, 'ADMIN', '2021-10-16 21:16:33'),
	(48, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 21:16:39'),
	(49, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 21:17:08'),
	(48, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 21:17:33'),
	(49, 'USE ITEM', 'ltl-ammo', 1, '', '2021-10-16 21:18:14'),
	(48, 'ADD ITEM', 'pistol-ammo', 5, 'ADMIN', '2021-10-16 21:18:29'),
	(49, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 21:18:33'),
	(48, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-16 21:18:37'),
	(49, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 21:19:00'),
	(48, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 21:19:29'),
	(49, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 21:19:32'),
	(48, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 21:19:37'),
	(49, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 21:19:38'),
	(48, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 21:19:43'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-16 21:21:07'),
	(48, 'ADD ITEM', 'stun-grenade', 3, 'ADMIN', '2021-10-16 21:21:43'),
	(48, 'ADD ITEM', 'weapon-brick', 3, 'ADMIN', '2021-10-16 21:21:46'),
	(48, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-16 21:22:48'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-16 21:25:58'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-16 21:26:03'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-16 21:26:29'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-16 21:27:15'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-16 21:27:31'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-16 21:28:50'),
	(48, 'ADD ITEM', 'weapon-brick', 3, 'ADMIN', '2021-10-16 21:28:56'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-16 21:29:09'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-16 21:29:40'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-16 21:29:47'),
	(48, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 21:42:48'),
	(48, 'ADD ITEM', 'rifle-ammo', 10, 'ADMIN', '2021-10-16 21:45:11'),
	(48, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 21:45:47'),
	(48, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 21:45:53'),
	(48, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 21:45:58'),
	(48, 'ADD ITEM', 'stun-grenade', 1, 'ADMIN', '2021-10-16 21:57:01'),
	(48, 'REMOVE ITEM', 'stun-grenade', 1, '', '2021-10-16 21:57:07'),
	(48, 'REMOVE ITEM', 'cash', 750, '', '2021-10-16 22:59:10'),
	(48, 'REMOVE ITEM', 'cash', 750, '', '2021-10-16 22:59:15'),
	(48, 'REMOVE ITEM', 'cash', 750, '', '2021-10-16 22:59:17'),
	(48, 'ADD ITEM', 'taser-ammo', 2, 'ADMIN', '2021-10-16 23:03:46'),
	(48, 'USE ITEM', 'taser-ammo', 1, '', '2021-10-16 23:03:54'),
	(48, 'USE ITEM', 'taser-ammo', 1, '', '2021-10-16 23:04:00'),
	(48, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 23:05:46'),
	(48, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 23:06:07'),
	(48, 'ADD ITEM', 'hand-cuffs', 1, 'ADMIN', '2021-10-16 23:21:20'),
	(48, 'REMOVE ITEM', 'cash', 750, '', '2021-10-16 23:26:12'),
	(48, 'ADD ITEM', 'taser-ammo', 1, 'ADMIN', '2021-10-16 23:33:30'),
	(48, 'USE ITEM', 'taser-ammo', 1, '', '2021-10-16 23:33:38'),
	(48, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-16 23:52:24'),
	(48, 'ADD ITEM', 'glock', 1, 'ADMIN', '2021-10-16 23:53:55'),
	(48, 'ADD ITEM', 'pistol-ammo', 3, 'ADMIN', '2021-10-16 23:53:57'),
	(48, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-16 23:54:04'),
	(48, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-16 23:54:10'),
	(55, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-16 23:54:13'),
	(48, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-16 23:54:17'),
	(55, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-16 23:54:20'),
	(48, 'ADD ITEM', 'm4', 1, 'ADMIN', '2021-10-16 23:57:25'),
	(48, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 23:57:37'),
	(55, 'ADD ITEM', 'm4', 1, 'ADMIN', '2021-10-16 23:57:46'),
	(48, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 23:58:09'),
	(55, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 23:58:17'),
	(55, 'ADD ITEM', 'rifle-ammo', 56, 'ADMIN', '2021-10-16 23:59:05'),
	(55, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 23:59:06'),
	(48, '[ERROR] ADD ITEM FAIL | DROPPED TO GROUND', 'rifle-ammo', 56, 'ADMIN', '2021-10-16 23:59:10'),
	(48, 'ADD ITEM', 'rifle-ammo', 3, 'ADMIN', '2021-10-16 23:59:12'),
	(48, 'ADD ITEM', 'rifle-ammo', 3, 'ADMIN', '2021-10-16 23:59:12'),
	(48, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 23:59:28'),
	(48, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 23:59:34'),
	(48, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-16 23:59:44'),
	(48, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-17 00:00:15'),
	(55, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-17 00:00:20'),
	(48, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-17 00:00:21'),
	(48, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-17 00:00:26'),
	(55, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-17 00:00:36'),
	(48, 'ADD ITEM', 'rifle-ammo', 1, 'ADMIN', '2021-10-17 00:00:42'),
	(55, 'USE ITEM', 'rifle-ammo', 1, '', '2021-10-17 00:00:44'),
	(55, 'ADD ITEM', 'ifak', 1, 'ADMIN', '2021-10-17 00:01:00'),
	(55, 'USE ITEM', 'ifak', 1, '', '2021-10-17 00:01:31'),
	(48, 'ADD ITEM', 'pistol-50', 1, 'ADMIN', '2021-10-17 00:03:27'),
	(55, '[ERROR] ADD ITEM FAIL | DROPPED TO GROUND', 'pistol-50', 1, 'ADMIN', '2021-10-17 00:03:31'),
	(55, '[ERROR] ADD ITEM FAIL | DROPPED TO GROUND', 'pistol-50', 1, 'ADMIN', '2021-10-17 00:03:37'),
	(48, 'ADD ITEM', 'pistol-ammo', 10, 'ADMIN', '2021-10-17 00:04:23'),
	(48, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-17 00:04:38'),
	(48, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-17 00:04:45'),
	(48, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-17 00:04:51'),
	(55, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-17 00:04:53'),
	(55, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-17 00:06:49'),
	(48, 'SHOP PURCHASE', 'knife', 1, '550', '2021-10-17 03:40:05'),
	(48, 'REMOVE ITEM', 'cash', 550, '', '2021-10-17 03:40:05'),
	(48, 'SHOP PURCHASE', 'switchblade', 1, '700', '2021-10-17 03:40:06'),
	(48, 'REMOVE ITEM', 'cash', 700, '', '2021-10-17 03:40:06'),
	(48, 'SHOP PURCHASE', 'baseball-bat', 1, '450', '2021-10-17 03:40:08'),
	(48, 'REMOVE ITEM', 'cash', 450, '', '2021-10-17 03:40:08'),
	(48, 'SHOP PURCHASE', 'flashlight', 1, '400', '2021-10-17 03:40:09'),
	(48, 'REMOVE ITEM', 'cash', 400, '', '2021-10-17 03:40:09'),
	(48, 'SHOP PURCHASE', 'combat-pistol', 1, '2000', '2021-10-17 03:46:51'),
	(48, 'REMOVE ITEM', 'cash', 2000, '', '2021-10-17 03:46:51'),
	(48, 'ADD ITEM', 'pistol', 1, 'ADMIN', '2021-10-17 17:20:03'),
	(48, 'REMOVE ITEM', 'cash', 63, '', '2021-10-17 18:11:18'),
	(48, 'ADD ITEM', 'hamburger', 1, 'ADMIN', '2021-10-17 18:42:56'),
	(48, 'ADD ITEM', 'water', 1, 'ADMIN', '2021-10-17 18:44:09'),
	(48, 'USE ITEM', 'water', 1, '', '2021-10-17 18:44:17'),
	(48, 'ADD ITEM', 'pistol-50', 1, 'ADMIN', '2021-10-17 18:45:04'),
	(48, 'ADD ITEM', 'hamburger', 1, 'ADMIN', '2021-10-17 18:46:44'),
	(48, 'REMOVE ITEM', 'cash', 3, '', '2021-10-17 18:47:59'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-17 18:48:06'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-17 18:48:08'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-17 18:48:11'),
	(48, 'ADD ITEM', 'water', 5, 'ADMIN', '2021-10-17 18:51:53'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-17 18:52:15'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-17 18:52:17'),
	(48, 'REMOVE ITEM', 'cash', 750, '', '2021-10-17 22:57:04'),
	(48, 'REMOVE ITEM', 'cash', 18, '', '2021-10-17 23:00:09'),
	(48, 'REMOVE ITEM', 'cash', 1000, '', '2021-10-17 23:00:20'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-17 23:00:49'),
	(48, 'ADD ITEM', 'cash', 100000, 'ADMIN', '2021-10-17 23:01:51'),
	(48, 'ADD ITEM', 'cash', 100000, 'ADMIN', '2021-10-17 23:01:51'),
	(48, 'ADD ITEM', 'cash', 100000, 'ADMIN', '2021-10-17 23:01:51'),
	(48, 'ADD ITEM', 'cash', 100000, 'ADMIN', '2021-10-17 23:01:51'),
	(48, 'ADD ITEM', 'cash', 100000, 'ADMIN', '2021-10-17 23:01:52'),
	(48, 'ADD ITEM', 'cash', 100000, 'ADMIN', '2021-10-17 23:01:52'),
	(48, 'ADD ITEM', 'cash', 100000, 'ADMIN', '2021-10-17 23:01:52'),
	(48, 'ADD ITEM', 'cash', 100000, 'ADMIN', '2021-10-17 23:01:52'),
	(48, 'ADD ITEM', 'cash', 100000, 'ADMIN', '2021-10-17 23:01:52'),
	(48, 'ADD ITEM', 'cash', 100000, 'ADMIN', '2021-10-17 23:01:52'),
	(48, 'ADD ITEM', 'cash', 100000, 'ADMIN', '2021-10-17 23:01:52'),
	(48, 'ADD ITEM', 'cash', 100000, 'ADMIN', '2021-10-17 23:01:55'),
	(48, 'REMOVE ITEM', 'cash', 37500, '', '2021-10-17 23:02:00'),
	(48, 'REMOVE ITEM', 'cash', 20000, '', '2021-10-17 23:02:01'),
	(48, 'ADD ITEM', 'prison-food', 1, '', '2021-10-18 00:15:21'),
	(48, 'ADD ITEM', 'prison-food', 1, '', '2021-10-18 00:15:27'),
	(48, 'ADD ITEM', 'prison-food', 1, '', '2021-10-18 00:15:40'),
	(48, 'USE ITEM', 'prison-food', 1, '', '2021-10-18 00:16:29'),
	(48, 'USE ITEM', 'prison-food', 1, '', '2021-10-18 00:17:29'),
	(48, 'ADD ITEM', 'prison-food', 1, '', '2021-10-18 00:19:37'),
	(48, 'ADD ITEM', 'prison-food', 1, '', '2021-10-18 00:19:47'),
	(48, 'ADD ITEM', 'prison-food', 1, '', '2021-10-18 00:19:52'),
	(48, 'ADD ITEM', 'prison-food', 1, '', '2021-10-18 00:20:54'),
	(48, 'ADD ITEM', 'prison-food', 1, '', '2021-10-18 00:23:19'),
	(48, 'ADD ITEM', 'prison-food', 1, '', '2021-10-18 00:23:58'),
	(48, 'ADD ITEM', 'prison-food', 1, '', '2021-10-18 00:24:29'),
	(48, 'ADD ITEM', 'lockpick-set', 1, 'ADMIN', '2021-10-18 00:31:06'),
	(48, 'REMOVE ITEM', 'cash', 750, '', '2021-10-18 01:23:22'),
	(48, 'REMOVE ITEM', 'cash', 750, '', '2021-10-18 01:23:24'),
	(48, 'REMOVE ITEM', 'cash', 750, '', '2021-10-18 01:23:28'),
	(48, 'REMOVE ITEM', 'cash', 750, '', '2021-10-18 01:23:29'),
	(48, 'ADD ITEM', 'phone', 1, 'ADMIN', '2021-10-18 20:14:03'),
	(48, 'ADD ITEM', 'sprunk', 1, 'ADMIN', '2021-10-18 22:33:13'),
	(48, 'ADD ITEM', 'banana', 1, 'ADMIN', '2021-10-18 22:33:18'),
	(48, 'ADD ITEM', 'glock', 1, 'ADMIN', '2021-10-18 22:33:20'),
	(48, 'ADD ITEM', '8ct-gold-chain', 1, 'ADMIN', '2021-10-18 22:33:22'),
	(48, 'ADD ITEM', 'pixel-2-phone', 1, 'ADMIN', '2021-10-18 22:33:28'),
	(48, 'ADD ITEM', 'knife', 1, 'ADMIN', '2021-10-18 22:49:15'),
	(48, 'ADD ITEM', 'phone', 1, 'ADMIN', '2021-10-20 01:07:48'),
	(48, 'ADD ITEM', 'pistol', 1, 'ADMIN', '2021-10-20 02:27:35'),
	(48, 'ADD ITEM', 'pistol-ammo', 1, 'ADMIN', '2021-10-20 02:27:39'),
	(48, 'ADD ITEM', 'pistol-ammo', 1, 'ADMIN', '2021-10-20 02:27:40'),
	(48, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-20 02:28:33'),
	(48, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-20 02:28:53'),
	(48, 'ADD ITEM', 'pistol-ammo', 1, 'ADMIN', '2021-10-20 14:21:14'),
	(48, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-20 14:21:21'),
	(48, 'ADD ITEM', 'cash', 1000000, 'ADMIN', '2021-10-20 15:03:47'),
	(48, 'REMOVE ITEM', 'cash', 750, '', '2021-10-20 15:03:52'),
	(48, 'ADD ITEM', 'water', 3, 'ADMIN', '2021-10-20 15:29:01'),
	(48, 'USE ITEM', 'water', 1, '', '2021-10-20 15:29:08'),
	(48, 'ADD ITEM', 'casino-chips', 100000, 'ADMIN', '2021-10-20 18:15:05'),
	(48, 'ADD ITEM', 'casino-chips', 100000, 'ADMIN', '2021-10-20 18:15:06'),
	(48, 'ADD ITEM', 'casino-chips', 100000, 'ADMIN', '2021-10-20 18:15:06'),
	(48, 'ADD ITEM', 'casino-chips', 100000, 'ADMIN', '2021-10-20 18:15:06'),
	(48, 'ADD ITEM', 'casino-chips', 100000, 'ADMIN', '2021-10-20 18:15:06'),
	(48, 'ADD ITEM', 'casino-chips', 100000, 'ADMIN', '2021-10-20 18:15:06'),
	(48, 'ADD ITEM', 'casino-chips', 100000, 'ADMIN', '2021-10-20 18:15:06'),
	(48, 'REMOVE ITEM', 'casino-chips', 50000, '', '2021-10-20 18:15:11'),
	(48, 'REMOVE ITEM', 'casino-chips', 50000, '', '2021-10-20 18:17:17'),
	(48, 'REMOVE ITEM', 'casino-chips', 50000, '', '2021-10-20 18:17:38'),
	(48, 'REMOVE ITEM', 'casino-chips', 50000, '', '2021-10-20 18:17:49'),
	(48, 'REMOVE ITEM', 'casino-chips', 50000, '', '2021-10-20 18:18:33'),
	(48, 'REMOVE ITEM', 'casino-chips', 50000, '', '2021-10-20 18:20:47'),
	(48, 'REMOVE ITEM', 'casino-chips', 50000, '', '2021-10-20 18:22:41'),
	(48, 'ADD ITEM', 'casino-chips', 100000, '', '2021-10-20 18:23:13'),
	(48, 'REMOVE ITEM', 'casino-chips', 10, '', '2021-10-20 18:24:02'),
	(48, 'ADD ITEM', 'casino-chips', 10, '', '2021-10-20 18:24:47'),
	(48, 'REMOVE ITEM', 'casino-chips', 450000, '', '2021-10-20 18:26:25'),
	(48, 'ADD ITEM', 'casino-chips', 10000000, 'ADMIN', '2021-10-20 18:28:37'),
	(48, 'REMOVE ITEM', 'casino-chips', 10000000, '', '2021-10-20 18:28:40'),
	(48, 'ADD ITEM', 'casino-chips', 10000000, 'ADMIN', '2021-10-20 18:29:12'),
	(48, 'REMOVE ITEM', 'casino-chips', 10000000, '', '2021-10-20 18:29:14'),
	(48, 'ADD ITEM', 'casino-chips', 20000000, '', '2021-10-20 18:29:40'),
	(48, 'REMOVE ITEM', 'cash', 500, '', '2021-10-20 21:04:28'),
	(48, 'ADD ITEM', 'safe-cracking-tool', 1, 'ADMIN', '2021-10-20 22:29:07'),
	(48, 'ADD ITEM', 'cash', 119, 'ROB CASH REGISTER', '2021-10-20 22:29:59'),
	(48, 'ADD ITEM', 'cash', 145, 'ROB CASH REGISTER', '2021-10-20 22:39:20'),
	(48, 'ADD ITEM', 'cash-stack', 59, '', '2021-10-20 22:39:29'),
	(48, 'ADD ITEM', 'heist-usb-green', 1, '', '2021-10-20 22:39:29'),
	(48, 'ADD ITEM', 'gold-bar', 1, 'ADMIN', '2021-10-20 23:05:37'),
	(48, 'ADD ITEM', 'gold-bar', 1, 'ADMIN', '2021-10-20 23:05:38'),
	(48, 'ADD ITEM', 'cash', 99, 'ROB CASH REGISTER', '2021-10-23 19:54:34'),
	(48, 'ADD ITEM', 'cash', 92, 'ROB CASH REGISTER', '2021-10-23 19:54:58'),
	(48, 'ADD ITEM', 'cash', 122, 'ROB CASH REGISTER', '2021-10-23 19:56:54'),
	(48, 'USE ITEM', 'water', 1, '', '2021-10-24 00:25:35'),
	(48, 'USE ITEM', 'water', 1, '', '2021-10-24 00:25:45'),
	(48, 'ADD ITEM', 'phone', 1, 'ADMIN', '2021-10-24 00:51:08'),
	(48, 'ADD ITEM', 'weapon-brick', 1, 'ADMIN', '2021-10-24 01:06:36'),
	(48, 'ADD ITEM', 'weapon-brick', 1, 'ADMIN', '2021-10-24 01:06:36'),
	(48, 'ADD ITEM', 'weapon-brick', 1, 'ADMIN', '2021-10-24 01:06:36'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-24 01:06:40'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-24 01:06:45'),
	(48, 'REMOVE ITEM', 'weapon-brick', 1, '', '2021-10-24 01:06:58'),
	(58, 'ADD ITEM', 'prison-food', 1, '', '2021-10-24 01:09:48'),
	(58, 'USE ITEM', 'prison-food', 1, '', '2021-10-24 01:10:20'),
	(58, 'ADD ITEM', 'lockpick-set', 1, 'ADMIN', '2021-10-24 01:11:05'),
	(58, 'ADD ITEM', 'lockpick-set', 1, 'ADMIN', '2021-10-24 01:11:05'),
	(58, 'ADD ITEM', 'lockpick-set', 1, 'ADMIN', '2021-10-24 01:11:06'),
	(58, 'ADD ITEM', 'pistol-50', 1, 'ADMIN', '2021-10-24 01:15:32'),
	(58, 'ADD ITEM', 'pistol-ammo', 1, 'ADMIN', '2021-10-24 01:15:35'),
	(58, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-24 01:16:10'),
	(48, 'ADD ITEM', 'pistol-50', 1, 'ADMIN', '2021-10-24 01:16:26'),
	(48, 'ADD ITEM', 'pistol-ammo', 1, 'ADMIN', '2021-10-24 01:16:33'),
	(48, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-24 01:16:40'),
	(48, 'ADD ITEM', 'pistol-ammo', 5, 'ADMIN', '2021-10-24 01:17:54'),
	(58, 'ADD ITEM', 'pistol-ammo', 5, 'ADMIN', '2021-10-24 01:17:56'),
	(48, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-24 01:18:04'),
	(48, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-24 01:18:10'),
	(48, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-24 01:18:17'),
	(48, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-24 01:18:22'),
	(48, 'ADD ITEM', 'water', 100, 'ADMIN', '2021-10-28 18:13:19'),
	(48, 'USE ITEM', 'water', 1, '', '2021-10-28 18:13:26'),
	(48, 'USE ITEM', 'water', 1, '', '2021-10-28 18:13:33'),
	(48, 'USE ITEM', 'water', 1, '', '2021-10-28 18:13:52'),
	(48, 'USE ITEM', 'water', 1, '', '2021-10-28 18:13:58'),
	(48, 'REMOVE ITEM', 'water', 1, '', '2021-10-29 22:56:09'),
	(48, 'ADD ITEM', 'pistol', 1, 'ADMIN', '2021-10-30 00:52:10'),
	(48, 'ADD ITEM', 'pistol-ammo', 1, 'ADMIN', '2021-10-30 00:56:13'),
	(48, 'USE ITEM', 'pistol-ammo', 1, '', '2021-10-30 00:56:18'),
	(48, 'ADD ITEM', 'pistol-ammo', 1, 'ADMIN', '2021-11-06 15:13:48'),
	(48, 'ADD ITEM', 'pistol', 1, 'ADMIN', '2021-11-06 15:13:53'),
	(48, 'USE ITEM', 'pistol-ammo', 1, '', '2021-11-06 15:14:01'),
	(48, 'ADD ITEM', 'pistol-ammo', 1, 'ADMIN', '2021-11-06 15:14:52'),
	(48, 'USE ITEM', 'pistol-ammo', 1, '', '2021-11-06 15:14:58'),
	(48, 'ADD ITEM', 'pistol-ammo', 1, 'ADMIN', '2021-11-06 15:15:56'),
	(48, 'USE ITEM', 'pistol-ammo', 1, '', '2021-11-06 15:16:02');
/*!40000 ALTER TABLE `inventory_economy` ENABLE KEYS */;

-- Dumping structure for table sitt.lockers
CREATE TABLE IF NOT EXISTS `lockers` (
  `owner` text DEFAULT NULL,
  `inventory` text DEFAULT '{}',
  KEY `owner` (`owner`(768))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table sitt.lockers: ~0 rows (approximately)
/*!40000 ALTER TABLE `lockers` DISABLE KEYS */;
/*!40000 ALTER TABLE `lockers` ENABLE KEYS */;

-- Dumping structure for table sitt.logs
CREATE TABLE IF NOT EXISTS `logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` text COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `data` text COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `timestamp` text COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT unix_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt.logs: ~0 rows (approximately)
/*!40000 ALTER TABLE `logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `logs` ENABLE KEYS */;

-- Dumping structure for table sitt.phone_contacts
CREATE TABLE IF NOT EXISTS `phone_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizen_id` int(11) DEFAULT 0,
  `number` int(11) DEFAULT 1234567,
  `name` text COLLATE utf8mb4_unicode_ci DEFAULT unix_timestamp(),
  PRIMARY KEY (`id`),
  KEY `citizen_id` (`citizen_id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt.phone_contacts: ~0 rows (approximately)
/*!40000 ALTER TABLE `phone_contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_contacts` ENABLE KEYS */;

-- Dumping structure for table sitt.phone_tweets
CREATE TABLE IF NOT EXISTS `phone_tweets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizen_id` int(11) DEFAULT 0,
  `text` text COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `poster` text COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Unknown?',
  `date` int(11) NOT NULL DEFAULT unix_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt.phone_tweets: ~0 rows (approximately)
/*!40000 ALTER TABLE `phone_tweets` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_tweets` ENABLE KEYS */;

-- Dumping structure for table sitt.players
CREATE TABLE IF NOT EXISTS `players` (
  `pid` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT '?',
  `license2` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT '?',
  `steam` text COLLATE utf8mb4_unicode_ci DEFAULT '?',
  `display_name` tinytext COLLATE utf8mb4_unicode_ci DEFAULT '',
  `play_time` int(11) DEFAULT 0,
  `last_played` int(11) DEFAULT unix_timestamp(),
  PRIMARY KEY (`pid`) USING BTREE,
  KEY `license` (`license`)
) ENGINE=InnoDB AUTO_INCREMENT=1014 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt.players: ~1 rows (approximately)
/*!40000 ALTER TABLE `players` DISABLE KEYS */;
INSERT INTO `players` (`pid`, `license`, `license2`, `steam`, `display_name`, `play_time`, `last_played`) VALUES
	(1013, 'license:4944817e5645aa0b5d4b886064f4c473821ff39e', 'license2:0f3a0ce22c22368c7f0dabe6987fd470a2ba63e6', 'steam:11000010c692ef1', 'klicer csgoempire.com', 1203, 1636219294);
/*!40000 ALTER TABLE `players` ENABLE KEYS */;

-- Dumping structure for table sitt.vehicles
CREATE TABLE IF NOT EXISTS `vehicles` (
  `vin` int(11) NOT NULL AUTO_INCREMENT,
  `cid` int(11) DEFAULT 0,
  `faction` int(11) DEFAULT 0,
  `model` varchar(255) DEFAULT 'none',
  `stats` varchar(255) DEFAULT '{"fuel":100.0,"engineHealth":1000.0,"bodyHealth":1000.0}',
  `mods` text DEFAULT '{}',
  `plate` varchar(8) DEFAULT 'NOPLATE1',
  `inGarage` int(11) DEFAULT 2,
  `glovebox` text DEFAULT '{}',
  `trunk` text DEFAULT '{}',
  `created_at` int(11) DEFAULT unix_timestamp(),
  PRIMARY KEY (`vin`),
  UNIQUE KEY `plate` (`plate`),
  KEY `cid` (`cid`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table sitt.vehicles: ~0 rows (approximately)
/*!40000 ALTER TABLE `vehicles` DISABLE KEYS */;
/*!40000 ALTER TABLE `vehicles` ENABLE KEYS */;

-- Dumping structure for table sitt.warns
CREATE TABLE IF NOT EXISTS `warns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license2` text DEFAULT 'license:0',
  `reason` varchar(255) DEFAULT NULL,
  `date` int(11) DEFAULT unix_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table sitt.warns: ~0 rows (approximately)
/*!40000 ALTER TABLE `warns` DISABLE KEYS */;
/*!40000 ALTER TABLE `warns` ENABLE KEYS */;

-- Dumping structure for table sitt.whitelist
CREATE TABLE IF NOT EXISTS `whitelist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `steam` varchar(255) DEFAULT NULL,
  `priority` int(11) DEFAULT 0,
  `date` int(11) DEFAULT unix_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `steam` (`steam`),
  KEY `fivem` (`steam`) USING BTREE,
  KEY `priority_idx_priority` (`priority`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;

-- Dumping data for table sitt.whitelist: ~1 rows (approximately)
/*!40000 ALTER TABLE `whitelist` DISABLE KEYS */;
INSERT INTO `whitelist` (`id`, `steam`, `priority`, `date`) VALUES
	(13, 'steam:11000010c692ef1', 100, 1633873160);
/*!40000 ALTER TABLE `whitelist` ENABLE KEYS */;

-- Dumping structure for table sitt.whitelist_applications
CREATE TABLE IF NOT EXISTS `whitelist_applications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hex` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `answers` text COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `timestamp` int(11) DEFAULT unix_timestamp(),
  `status` int(11) DEFAULT 0,
  `admin_comment` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `processed_by` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt.whitelist_applications: ~0 rows (approximately)
/*!40000 ALTER TABLE `whitelist_applications` DISABLE KEYS */;
/*!40000 ALTER TABLE `whitelist_applications` ENABLE KEYS */;

-- Dumping structure for table sitt._economy_money
CREATE TABLE IF NOT EXISTS `_economy_money` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cid` int(11) DEFAULT 0,
  `amount` int(11) DEFAULT 0,
  `comment` varchar(255) DEFAULT '',
  `date` int(11) DEFAULT unix_timestamp(),
  `sink_type` enum('add','remove') DEFAULT NULL,
  `sink_location` enum('cash','balance') DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=190 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table sitt._economy_money: ~0 rows (approximately)
/*!40000 ALTER TABLE `_economy_money` DISABLE KEYS */;
/*!40000 ALTER TABLE `_economy_money` ENABLE KEYS */;

-- Dumping structure for table sitt._faction_groups
CREATE TABLE IF NOT EXISTS `_faction_groups` (
  `faction_id` tinyint(4) NOT NULL AUTO_INCREMENT,
  `faction_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `max_members` int(11) NOT NULL DEFAULT 20,
  `bank_account` int(11) DEFAULT NULL,
  `garage` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`faction_id`) USING BTREE,
  KEY `name` (`faction_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt._faction_groups: ~2 rows (approximately)
/*!40000 ALTER TABLE `_faction_groups` DISABLE KEYS */;
INSERT INTO `_faction_groups` (`faction_id`, `faction_name`, `max_members`, `bank_account`, `garage`) VALUES
	(1, 'LSPD', 100, 2, '[445.80, -986.20, 25.69, 269.37]'),
	(2, 'EMS', 100, 3, '[295.27,-607.14,43.11, 68.03]');
/*!40000 ALTER TABLE `_faction_groups` ENABLE KEYS */;

-- Dumping structure for table sitt._faction_logs
CREATE TABLE IF NOT EXISTS `_faction_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `faction_id` int(11) DEFAULT 0,
  `character_id` int(11) DEFAULT 0,
  `action` char(50) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `content` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `timestamp` int(11) DEFAULT unix_timestamp(),
  PRIMARY KEY (`id`),
  KEY `action` (`action`),
  KEY `_faction_logs_idx_faction_id_character_id` (`faction_id`,`character_id`)
) ENGINE=InnoDB AUTO_INCREMENT=337 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt._faction_logs: ~0 rows (approximately)
/*!40000 ALTER TABLE `_faction_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `_faction_logs` ENABLE KEYS */;

-- Dumping structure for table sitt._faction_members
CREATE TABLE IF NOT EXISTS `_faction_members` (
  `character_id` int(11) NOT NULL,
  `faction_id` tinyint(4) NOT NULL DEFAULT 0,
  `rank_name` char(50) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `alias` char(50) COLLATE utf8mb4_unicode_ci DEFAULT '',
  PRIMARY KEY (`character_id`),
  KEY `faction_id` (`faction_id`),
  KEY `character_id` (`character_id`),
  CONSTRAINT `character_deleted` FOREIGN KEY (`character_id`) REFERENCES `characters` (`cid`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt._faction_members: ~0 rows (approximately)
/*!40000 ALTER TABLE `_faction_members` DISABLE KEYS */;
/*!40000 ALTER TABLE `_faction_members` ENABLE KEYS */;

-- Dumping structure for table sitt._faction_ranks
CREATE TABLE IF NOT EXISTS `_faction_ranks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `faction_id` tinyint(4) NOT NULL DEFAULT 0,
  `rank_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `rank_level` int(11) DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `_faction_ranks_idx_faction_id_rank_name` (`faction_id`,`rank_name`),
  CONSTRAINT `on_deleted` FOREIGN KEY (`faction_id`) REFERENCES `_faction_groups` (`faction_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt._faction_ranks: ~14 rows (approximately)
/*!40000 ALTER TABLE `_faction_ranks` DISABLE KEYS */;
INSERT INTO `_faction_ranks` (`id`, `faction_id`, `rank_name`, `rank_level`) VALUES
	(6, 1, 'Peadirektor', 100),
	(11, 2, 'Peadirektor', 100),
	(20, 1, 'Komandör', 30),
	(21, 1, 'Inspektor', 29),
	(22, 1, 'Palgatapuhkus', 0),
	(23, 1, 'Abipolitsei', 1),
	(24, 1, 'K-9', 2),
	(27, 1, 'Kapten', 28),
	(28, 1, 'Välijuht', 16),
	(32, 1, 'Kadett', 3),
	(33, 1, 'Asedirektor', 95),
	(35, 1, 'Admin', 1000),
	(36, 2, 'Admin', 1000),
	(38, 1, 'Ohvitser', 4);
/*!40000 ALTER TABLE `_faction_ranks` ENABLE KEYS */;

-- Dumping structure for table sitt._faction_vehicle_options
CREATE TABLE IF NOT EXISTS `_faction_vehicle_options` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `faction_id` int(11) NOT NULL DEFAULT 0,
  `cost` int(11) NOT NULL DEFAULT 50000,
  `model` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `mods` text COLLATE utf8mb4_unicode_ci DEFAULT '{}',
  PRIMARY KEY (`id`),
  KEY `faction_id` (`faction_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt._faction_vehicle_options: ~9 rows (approximately)
/*!40000 ALTER TABLE `_faction_vehicle_options` DISABLE KEYS */;
INSERT INTO `_faction_vehicle_options` (`id`, `faction_id`, `cost`, `model`, `mods`) VALUES
	(8, 2, 50000, 'ambulance', '{}'),
	(9, 2, 50000, 'emsv', '{}'),
	(10, 2, 50000, 'emsnspeedo', '{}'),
	(11, 1, 170000, 'npolstang', '{"Turbo":1,"Fender":-1,"Transmission":3,"ArchCover":4,"FrontWheels":-1,"Speakers":-1,"Dial":0,"WheelType":7,"Dashboard":0,"FrontBumper":-1,"Smoke":false,"Brakes":2,"Seats":-1,"VanityPlate":-1,"Engine":4,"SecondaryColour":11,"Horns":-1,"Extras":[4,5,6],"PlateHolder":-1,"WindowTint":-1,"Hydrolic":-1,"Exhaust":-1,"APlate":-1,"Armor":4,"DoorSpeaker":-1,"RightFender":-1,"SteeringWheel":-1,"Roof":2,"Livery":-1,"Trunk":1,"Windows":-1,"Hood":-1,"Ornaments":-1,"AirFilter":-1,"RearBumper":-1,"Struts":-1,"TrimA":-1,"Aerials":-1,"WheelColour":0,"TrimB":2,"Xenon":false,"Tank":0,"Grille":-1,"PerleascentColour":66,"EngineBlock":-1,"Spoilers":2,"XenonColor":255,"ShifterLeavers":-1,"Suspension":3,"SideSkirt":-1,"Frame":-1,"BackWheels":-1,"PrimaryColour":11}'),
	(12, 1, 170000, 'npolvette', '{"Turbo":1,"Fender":-1,"Transmission":3,"ArchCover":6,"FrontWheels":-1,"Speakers":-1,"Dial":0,"WheelType":0,"Dashboard":0,"FrontBumper":1,"Smoke":false,"Brakes":2,"Seats":-1,"VanityPlate":-1,"Engine":4,"SecondaryColour":141,"Horns":-1,"Extras":[4,5,6],"PlateHolder":-1,"WindowTint":-1,"Hydrolic":-1,"Exhaust":-1,"APlate":-1,"Armor":4,"DoorSpeaker":-1,"RightFender":-1,"SteeringWheel":-1,"Roof":1,"Livery":-1,"Trunk":-1,"Windows":-1,"Hood":0,"Ornaments":0,"AirFilter":-1,"RearBumper":0,"Struts":-1,"TrimA":-1,"Aerials":-1,"WheelColour":0,"TrimB":6,"Xenon":false,"Tank":6,"Grille":-1,"PerleascentColour":66,"EngineBlock":-1,"Spoilers":1,"XenonColor":255,"ShifterLeavers":-1,"Suspension":3,"SideSkirt":1,"Frame":0,"BackWheels":-1,"PrimaryColour":141}'),
	(13, 1, 170000, 'npolchal', '{"Turbo":1,"Fender":5,"Transmission":3,"ArchCover":9,"FrontWheels":-1,"Speakers":-1,"Dial":0,"WheelType":7,"Dashboard":0,"FrontBumper":-1,"Smoke":false,"Brakes":2,"Seats":-1,"VanityPlate":-1,"Engine":4,"SecondaryColour":147,"Horns":-1,"Extras":[5,6],"PlateHolder":-1,"WindowTint":-1,"Hydrolic":-1,"Exhaust":-1,"APlate":-1,"Armor":4,"DoorSpeaker":-1,"RightFender":1,"SteeringWheel":-1,"Roof":1,"Livery":-1,"Trunk":1,"Windows":-1,"Hood":-1,"Ornaments":0,"AirFilter":-1,"RearBumper":-1,"Struts":-1,"TrimA":-1,"Aerials":0,"WheelColour":0,"TrimB":9,"Xenon":false,"Tank":9,"Grille":-1,"PerleascentColour":0,"EngineBlock":-1,"Spoilers":0,"XenonColor":255,"ShifterLeavers":-1,"Suspension":3,"SideSkirt":-1,"Frame":0,"BackWheels":-1,"PrimaryColour":147}'),
	(14, 1, 75000, 'npolvic', '{"Turbo":1,"Fender":2,"Transmission":3,"ArchCover":8,"FrontWheels":-1,"Speakers":-1,"Dial":0,"WheelType":1,"Dashboard":0,"FrontBumper":0,"Smoke":false,"Brakes":2,"Seats":0,"VanityPlate":-1,"Engine":4,"SecondaryColour":147,"Horns":-1,"Extras":[1,4,5,6,7],"PlateHolder":-1,"WindowTint":-1,"Hydrolic":-1,"Exhaust":-1,"APlate":-1,"Armor":4,"DoorSpeaker":-1,"RightFender":4,"SteeringWheel":-1,"Roof":0,"Livery":-1,"Trunk":1,"Windows":-1,"Hood":-1,"Ornaments":0,"AirFilter":-1,"RearBumper":-1,"Struts":-1,"TrimA":-1,"Aerials":1,"WheelColour":0,"TrimB":8,"Xenon":false,"Tank":9,"Grille":-1,"PerleascentColour":0,"EngineBlock":-1,"Spoilers":-1,"XenonColor":255,"ShifterLeavers":-1,"Suspension":3,"SideSkirt":-1,"Frame":0,"BackWheels":-1,"PrimaryColour":111}{"Turbo":1,"Fender":2,"Transmission":3,"ArchCover":8,"FrontWheels":-1,"Speakers":-1,"Dial":0,"WheelType":1,"Dashboard":0,"FrontBumper":0,"Smoke":false,"Brakes":2,"Seats":0,"VanityPlate":-1,"Engine":4,"SecondaryColour":147,"Horns":-1,"Extras":[1,4,5,6,7],"PlateHolder":-1,"WindowTint":-1,"Hydrolic":-1,"Exhaust":-1,"APlate":-1,"Armor":4,"DoorSpeaker":-1,"RightFender":4,"SteeringWheel":-1,"Roof":0,"Livery":-1,"Trunk":1,"Windows":-1,"Hood":-1,"Ornaments":0,"AirFilter":-1,"RearBumper":-1,"Struts":-1,"TrimA":-1,"Aerials":1,"WheelColour":0,"TrimB":8,"Xenon":false,"Tank":9,"Grille":-1,"PerleascentColour":0,"EngineBlock":-1,"Spoilers":-1,"XenonColor":255,"ShifterLeavers":-1,"Suspension":3,"SideSkirt":-1,"Frame":0,"BackWheels":-1,"PrimaryColour":111}'),
	(15, 1, 90000, 'npolmm', '{"EngineBlock":-1,"FrontWheels":-1,"XenonColor":255,"Brakes":-1,"Turbo":1,"RightFender":-1,"SteeringWheel":-1,"Armor":4,"Smoke":false,"Struts":-1,"Trunk":-1,"Hood":-1,"Grille":-1,"Hydrolic":-1,"FrontBumper":-1,"Exhaust":-1,"TrimB":-1,"PerleascentColour":0,"Roof":-1,"Livery":-1,"Aerials":-1,"ShifterLeavers":-1,"Suspension":-1,"WindowTint":-1,"ArchCover":-1,"DoorSpeaker":-1,"RearBumper":-1,"Xenon":false,"Dashboard":-1,"Seats":-1,"VanityPlate":-1,"BackWheels":-1,"Fender":-1,"APlate":-1,"Engine":3,"Windows":-1,"Ornaments":-1,"AirFilter":-1,"Spoilers":-1,"PlateHolder":-1,"Horns":-1,"Tank":-1,"TrimA":-1,"Dial":-1,"PrimaryColour":62,"SecondaryColour":62,"SideSkirt":-1,"Transmission":-1,"Frame":-1,"WheelColour":0,"WheelType":6,"Speakers":-1,"Extras":[1,2]}'),
	(16, 1, 350000, 'polas350', '{}');
/*!40000 ALTER TABLE `_faction_vehicle_options` ENABLE KEYS */;

-- Dumping structure for table sitt._housing_properties
CREATE TABLE IF NOT EXISTS `_housing_properties` (
  `property_id` int(11) NOT NULL,
  `owner` int(11) NOT NULL DEFAULT 0,
  `stash` text COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '{}',
  UNIQUE KEY `housing_id` (`property_id`) USING BTREE,
  KEY `owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt._housing_properties: ~0 rows (approximately)
/*!40000 ALTER TABLE `_housing_properties` DISABLE KEYS */;
/*!40000 ALTER TABLE `_housing_properties` ENABLE KEYS */;

-- Dumping structure for table sitt._licenses
CREATE TABLE IF NOT EXISTS `_licenses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizen_id` int(11) NOT NULL,
  `license_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `citizen_id` (`citizen_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt._licenses: ~2 rows (approximately)
/*!40000 ALTER TABLE `_licenses` DISABLE KEYS */;
INSERT INTO `_licenses` (`id`, `citizen_id`, `license_id`) VALUES
	(16, 66, 1),
	(17, 67, 1);
/*!40000 ALTER TABLE `_licenses` ENABLE KEYS */;

-- Dumping structure for table sitt._mdt_bulletins
CREATE TABLE IF NOT EXISTS `_mdt_bulletins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` int(11) DEFAULT unix_timestamp(),
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table sitt._mdt_bulletins: ~0 rows (approximately)
/*!40000 ALTER TABLE `_mdt_bulletins` DISABLE KEYS */;
INSERT INTO `_mdt_bulletins` (`id`, `timestamp`, `title`, `description`) VALUES
	(4, 1634488610, 'yo kutid', 'tere tulemast MDTsse');
/*!40000 ALTER TABLE `_mdt_bulletins` ENABLE KEYS */;

-- Dumping structure for table sitt._mdt_charges
CREATE TABLE IF NOT EXISTS `_mdt_charges` (
  `charge_id` int(11) NOT NULL AUTO_INCREMENT,
  `citizen_id` int(11) NOT NULL,
  `charges` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `totalFine` int(11) DEFAULT 0,
  `totalJail` int(11) DEFAULT 0,
  `issued_by` int(11) NOT NULL,
  `date` int(11) DEFAULT unix_timestamp(),
  PRIMARY KEY (`charge_id`),
  KEY `citizen_id` (`citizen_id`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt._mdt_charges: ~0 rows (approximately)
/*!40000 ALTER TABLE `_mdt_charges` DISABLE KEYS */;
/*!40000 ALTER TABLE `_mdt_charges` ENABLE KEYS */;

-- Dumping structure for table sitt._mdt_profile_data
CREATE TABLE IF NOT EXISTS `_mdt_profile_data` (
  `citizen_id` int(11) NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `profile_image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`citizen_id`),
  CONSTRAINT `character_gone3` FOREIGN KEY (`citizen_id`) REFERENCES `characters` (`cid`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt._mdt_profile_data: ~0 rows (approximately)
/*!40000 ALTER TABLE `_mdt_profile_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `_mdt_profile_data` ENABLE KEYS */;

-- Dumping structure for table sitt._mdt_warrants
CREATE TABLE IF NOT EXISTS `_mdt_warrants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizen_id` int(11) NOT NULL,
  `reason` text DEFAULT NULL,
  `last_update` int(11) DEFAULT unix_timestamp(),
  `enabled` int(11) DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `character_gone` (`citizen_id`),
  CONSTRAINT `character_gone` FOREIGN KEY (`citizen_id`) REFERENCES `characters` (`cid`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table sitt._mdt_warrants: ~0 rows (approximately)
/*!40000 ALTER TABLE `_mdt_warrants` DISABLE KEYS */;
/*!40000 ALTER TABLE `_mdt_warrants` ENABLE KEYS */;

-- Dumping structure for table sitt._weapon_ammo
CREATE TABLE IF NOT EXISTS `_weapon_ammo` (
  `citizen_id` int(11) DEFAULT 0,
  `hash` int(11) DEFAULT 0,
  `ammo` int(11) DEFAULT 0,
  KEY `citizen_id` (`citizen_id`),
  KEY `hash` (`hash`),
  CONSTRAINT `character_gone2` FOREIGN KEY (`citizen_id`) REFERENCES `characters` (`cid`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt._weapon_ammo: ~0 rows (approximately)
/*!40000 ALTER TABLE `_weapon_ammo` DISABLE KEYS */;
/*!40000 ALTER TABLE `_weapon_ammo` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
