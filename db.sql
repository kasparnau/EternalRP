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
  PRIMARY KEY (`hex`(4)) USING BTREE,
  UNIQUE KEY `hex` (`hex`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt.admins: ~0 rows (approximately)
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
) ENGINE=InnoDB AUTO_INCREMENT=399 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table sitt.admin_logs: ~2 rows (approximately)
/*!40000 ALTER TABLE `admin_logs` DISABLE KEYS */;
INSERT INTO `admin_logs` (`id`, `license2`, `name`, `action`, `log`, `date`) VALUES
	(394, 'license2:0f3a0ce22c22368c7f0dabe6987fd470a2ba63e6', 'klicer', 'Add Item', 'Gave 1 of heist-usb-green to klicer', '2021-09-27 22:52:45'),
	(395, 'license2:0f3a0ce22c22368c7f0dabe6987fd470a2ba63e6', 'klicer', 'Add Item', 'Gave 3 of safe-cracking-tool to klicer', '2021-09-27 23:08:17'),
	(396, 'license2:0f3a0ce22c22368c7f0dabe6987fd470a2ba63e6', 'klicer', 'Add Item', 'Gave 10 of pistol-ammo to klicer', '2021-09-27 23:13:05'),
	(397, 'license2:0f3a0ce22c22368c7f0dabe6987fd470a2ba63e6', 'klicer', 'Add Item', 'Gave 50009 of cash to klicer', '2021-10-02 19:46:01'),
	(398, 'license2:0f3a0ce22c22368c7f0dabe6987fd470a2ba63e6', 'klicer', 'Ban Player', '(Reason: no reason Length: 10800) Target: klicer', '2021-10-03 21:37:16');
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
) ENGINE=InnoDB AUTO_INCREMENT=146 DEFAULT CHARSET=latin1;

-- Dumping data for table sitt.bank_accounts: ~4 rows (approximately)
/*!40000 ALTER TABLE `bank_accounts` DISABLE KEYS */;
INSERT INTO `bank_accounts` (`account_id`, `character_id`, `account_name`, `account_balance`, `type`) VALUES
	(1, 0, 'State', 0, 'OTHER'),
	(2, 3, 'LSPD', 99799, 'OTHER'),
	(3, 0, 'EMS', 0, 'OTHER'),
	(144, 3, 'Personal Account', 0, 'PERSONAL'),
	(145, 9, 'Personal Account', 0, 'PERSONAL');
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
INSERT INTO `bank_transactions` (`transaction_id`, `payee_account_id`, `receiver_account_id`, `amount`, `transaction_type`, `comment`, `timestamp`) VALUES
	(1215, 2, 0, 1, 'withdraw', NULL, 1632766280);
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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dumping data for table sitt.bans: ~0 rows (approximately)
/*!40000 ALTER TABLE `bans` DISABLE KEYS */;
INSERT INTO `bans` (`id`, `enabled`, `license`, `license2`, `steam`, `discord`, `fivem`, `date`, `length`, `reason`, `banner`, `secret_reason`) VALUES
	(14, 0, 'license:4944817e5645aa0b5d4b886064f4c473821ff39e', 'license2:0f3a0ce22c22368c7f0dabe6987fd470a2ba63e6', 'steam:11000010c692ef1', 'discord:545614467476750337', 'fivem:673480', 1633286236, 808000, 'no reason', 'klicer', 'Manually banned from menu');
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
  `phone_number` int(11) DEFAULT 123456789,
  `job` text DEFAULT '',
  `inventory` text DEFAULT '{}',
  `status` text DEFAULT '{"hunger":100,"health":200,"thirst":100,"armor":0}',
  `dead` tinyint(1) DEFAULT 0,
  `jail_time` double DEFAULT 0,
  PRIMARY KEY (`cid`) USING BTREE,
  UNIQUE KEY `phone_number` (`phone_number`),
  KEY `playerId` (`pid`) USING BTREE,
  KEY `characters_idx_phone_number` (`phone_number`),
  CONSTRAINT `on_player_deleted` FOREIGN KEY (`pid`) REFERENCES `players` (`pid`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table sitt.characters: ~2 rows (approximately)
/*!40000 ALTER TABLE `characters` DISABLE KEYS */;
INSERT INTO `characters` (`cid`, `pid`, `gender`, `dob`, `first_name`, `last_name`, `position`, `outfit`, `phone_number`, `job`, `inventory`, `status`, `dead`, `jail_time`) VALUES
	(3, 7, 0, '1999-01-01', 'Pede', 'Homo', '{"heading":213.2158203125,"x":415.2854919433594,"y":-994.8299560546875,"z":29.3696002960205}', '{"headBlend":{"skinMix":0.0,"hasParent":false,"shapeThird":0,"skinFirst":15,"shapeMix":0.0,"shapeSecond":3,"skinSecond":0,"thirdMix":0.0,"skinThird":0,"shapeFirst":5},"headStructure":[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0],"proptextures":[["hats",0],["glasses",-1],["earrings",-1],["mouth",-1],["lhand",-1],["rhand",-1],["watches",-1],["braclets",-1]],"model":1885233650,"props":{"1":["glasses",-1],"2":["earrings",-1],"3":["mouth",-1],"4":["lhand",-1],"5":["rhand",-1],"6":["watches",-1],"7":["braclets",-1],"0":["hats",46]},"headOverlay":[{"secondColour":0,"overlayOpacity":1.0,"colourType":0,"firstColour":0,"name":"Blemishes","overlayValue":255},{"secondColour":0,"overlayOpacity":0.0,"colourType":1,"firstColour":0,"name":"FacialHair","overlayValue":255},{"secondColour":0,"overlayOpacity":1.0,"colourType":1,"firstColour":0,"name":"Eyebrows","overlayValue":255},{"secondColour":0,"overlayOpacity":1.0,"colourType":0,"firstColour":0,"name":"Ageing","overlayValue":255},{"secondColour":0,"overlayOpacity":1.0,"colourType":2,"firstColour":0,"name":"Makeup","overlayValue":255},{"secondColour":0,"overlayOpacity":1.0,"colourType":2,"firstColour":0,"name":"Blush","overlayValue":255},{"secondColour":0,"overlayOpacity":1.0,"colourType":0,"firstColour":0,"name":"Complexion","overlayValue":255},{"secondColour":0,"overlayOpacity":1.0,"colourType":0,"firstColour":0,"name":"SunDamage","overlayValue":255},{"secondColour":0,"overlayOpacity":1.0,"colourType":2,"firstColour":0,"name":"Lipstick","overlayValue":255},{"secondColour":0,"overlayOpacity":1.0,"colourType":0,"firstColour":0,"name":"MolesFreckles","overlayValue":255},{"secondColour":0,"overlayOpacity":1.0,"colourType":1,"firstColour":0,"name":"ChestHair","overlayValue":255},{"secondColour":0,"overlayOpacity":1.0,"colourType":0,"firstColour":0,"name":"BodyBlemishes","overlayValue":255},{"secondColour":0,"overlayOpacity":1.0,"colourType":0,"firstColour":0,"name":"AddBodyBlemishes","overlayValue":255}],"hairColor":[34,1],"drawtextures":[["face",0],["masks",0],["hair",0],["torsos",0],["legs",4],["bags",0],["shoes",2],["neck",0],["undershirts",5],["vest",0],["decals",0],["jackets",1]],"drawables":{"1":["masks",0],"2":["hair",8],"3":["torsos",0],"4":["legs",60],"5":["bags",0],"6":["shoes",1],"7":["neck",0],"8":["undershirts",14],"9":["vest",9],"10":["decals",0],"11":["jackets",258],"0":["face",0]}}', 3965438, 'Sewer', '[]', '{"hunger":30,"health":197,"thirst":12,"armor":0}', 0, 0),
	(9, 7, 0, '1999-01-01', 'Barack', 'Obama', '{"y":-1929.4473876953126,"z":21.38241004943847,"heading":123.23648071289063,"x":126.45942687988281}', '{"proptextures":[["hats",-1],["glasses",-1],["earrings",-1],["mouth",-1],["lhand",-1],["rhand",-1],["watches",-1],["braclets",-1]],"drawables":{"1":["masks",0],"2":["hair",0],"3":["torsos",0],"4":["legs",0],"5":["bags",0],"6":["shoes",1],"7":["neck",0],"8":["undershirts",0],"9":["vest",0],"10":["decals",0],"11":["jackets",0],"0":["face",0]},"headBlend":{"skinThird":0,"shapeFirst":0,"shapeThird":0,"skinMix":1.0,"skinFirst":15,"shapeSecond":0,"thirdMix":0.0,"shapeMix":0.0,"hasParent":false,"skinSecond":0},"drawtextures":[["face",0],["masks",0],["hair",0],["torsos",0],["legs",0],["bags",0],["shoes",2],["neck",0],["undershirts",1],["vest",0],["decals",0],["jackets",11]],"props":{"1":["glasses",-1],"2":["earrings",-1],"3":["mouth",-1],"4":["lhand",-1],"5":["rhand",-1],"6":["watches",-1],"7":["braclets",-1],"0":["hats",-1]},"headStructure":[0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0],"headOverlay":[{"name":"Blemishes","colourType":0,"secondColour":0,"overlayOpacity":1.0,"firstColour":0,"overlayValue":255},{"name":"FacialHair","colourType":1,"secondColour":0,"overlayOpacity":0.0,"firstColour":0,"overlayValue":255},{"name":"Eyebrows","colourType":1,"secondColour":0,"overlayOpacity":1.0,"firstColour":0,"overlayValue":255},{"name":"Ageing","colourType":0,"secondColour":0,"overlayOpacity":1.0,"firstColour":0,"overlayValue":255},{"name":"Makeup","colourType":2,"secondColour":0,"overlayOpacity":1.0,"firstColour":0,"overlayValue":255},{"name":"Blush","colourType":2,"secondColour":0,"overlayOpacity":1.0,"firstColour":0,"overlayValue":255},{"name":"Complexion","colourType":0,"secondColour":0,"overlayOpacity":1.0,"firstColour":0,"overlayValue":255},{"name":"SunDamage","colourType":0,"secondColour":0,"overlayOpacity":1.0,"firstColour":0,"overlayValue":255},{"name":"Lipstick","colourType":2,"secondColour":0,"overlayOpacity":1.0,"firstColour":0,"overlayValue":255},{"name":"MolesFreckles","colourType":0,"secondColour":0,"overlayOpacity":1.0,"firstColour":0,"overlayValue":255},{"name":"ChestHair","colourType":1,"secondColour":0,"overlayOpacity":1.0,"firstColour":0,"overlayValue":255},{"name":"BodyBlemishes","colourType":0,"secondColour":0,"overlayOpacity":1.0,"firstColour":0,"overlayValue":255},{"name":"AddBodyBlemishes","colourType":0,"secondColour":0,"overlayOpacity":1.0,"firstColour":0,"overlayValue":255}],"model":1885233650,"hairColor":[1,1]}', 3955420, 'Unemployed', '{"1":{"itemId":"water","qty":3}}', '{"thirst":91,"hunger":95,"armor":0,"health":200}', 0, 0);
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

-- Dumping data for table sitt.inventory_economy: ~196 rows (approximately)
/*!40000 ALTER TABLE `inventory_economy` DISABLE KEYS */;
INSERT INTO `inventory_economy` (`citizen_id`, `action`, `item_id`, `item_qty`, `content`, `timestamp`) VALUES
	(3, 'ADD ITEM', 'ifak', 1, NULL, '2021-05-25 18:05:17'),
	(3, 'USE ITEM', 'ifak', 1, NULL, '2021-05-25 18:05:59'),
	(3, '[ERROR] ADD ITEM FAIL', 'ifak', 1, 'ADMIN', '2021-05-25 18:06:30'),
	(3, 'ADD ITEM', 'ifak', 1, 'ADMIN', '2021-05-25 18:06:36'),
	(3, 'ADD ITEM', 'crack', 1, 'ADMIN', '2021-05-25 18:22:52'),
	(9, 'ADD ITEM', 'water', 5, 'ADMIN', '2021-05-25 18:23:11'),
	(9, 'USE ITEM', 'water', 1, '', '2021-05-25 18:23:19'),
	(9, 'ADD ITEM', 'hamburger', 1, 'ADMIN', '2021-05-25 18:23:28'),
	(9, 'USE ITEM', 'hamburger', 1, '', '2021-05-25 18:23:35'),
	(3, 'ADD ITEM', 'water', 1, 'ADMIN', '2021-05-25 18:30:31'),
	(3, 'ADD ITEM', 'cash', 99995, 'ADMIN', '2021-05-25 18:35:07'),
	(3, 'SHOP PURCHASE', 'hot-dog', 5, '100', '2021-05-25 18:35:15'),
	(3, 'REMOVE ITEM', 'cash', 100, '', '2021-05-25 18:35:15'),
	(3, 'USE ITEM', 'holy-water', 1, '', '2021-05-25 21:52:44'),
	(3, 'USE ITEM', 'hot-dog', 1, '', '2021-05-26 18:29:28'),
	(3, 'USE ITEM', 'hot-dog', 1, '', '2021-05-26 22:29:06'),
	(3, 'ADD ITEM', 'pistol', 1, 'ADMIN', '2021-05-26 22:32:41'),
	(3, 'ADD ITEM', 'pistol-ammo', 5, 'ADMIN', '2021-05-26 22:32:52'),
	(3, 'USE ITEM', 'pistol-ammo', 1, '', '2021-05-26 22:32:58'),
	(3, 'USE ITEM', 'pistol-ammo', 1, '', '2021-05-26 22:33:05'),
	(3, 'USE ITEM', 'pistol-ammo', 1, '', '2021-07-01 02:21:01'),
	(3, 'REMOVE ITEM', 'cash', 99800, '', '2021-09-25 11:26:51'),
	(3, 'ADD ITEM', 'casino-chips', 50000, 'ADMIN', '2021-09-25 12:13:42'),
	(3, 'REMOVE ITEM', 'casino-chips', 90, '', '2021-09-25 12:14:02'),
	(3, 'ADD ITEM', 'casino-chips', 180, '', '2021-09-25 12:14:51'),
	(3, 'REMOVE ITEM', 'casino-chips', 400, '', '2021-09-25 12:15:02'),
	(3, 'REMOVE ITEM', 'casino-chips', 1500, '', '2021-09-25 12:15:40'),
	(3, 'ADD ITEM', 'casino-chips', 1500, '', '2021-09-25 12:15:59'),
	(3, 'REMOVE ITEM', 'casino-chips', 1500, '', '2021-09-25 12:16:15'),
	(3, 'REMOVE ITEM', 'casino-chips', 1500, '', '2021-09-25 12:16:41'),
	(3, 'ADD ITEM', 'casino-chips', 3000, '', '2021-09-25 12:17:02'),
	(3, 'REMOVE ITEM', 'casino-chips', 300, '', '2021-09-25 14:52:33'),
	(3, 'REMOVE ITEM', 'casino-chips', 500, '', '2021-09-25 14:53:03'),
	(3, 'REMOVE ITEM', 'casino-chips', 10, '', '2021-09-25 14:54:04'),
	(3, 'ADD ITEM', 'casino-chips', 10, '', '2021-09-25 14:54:36'),
	(3, 'REMOVE ITEM', 'casino-chips', 10000, '', '2021-09-25 14:54:52'),
	(3, 'REMOVE ITEM', 'casino-chips', 10000, '', '2021-09-25 14:55:18'),
	(3, 'REMOVE ITEM', 'cash', 8, '', '2021-09-25 20:31:50'),
	(3, 'ADD ITEM', 'cash', 999999, 'ADMIN', '2021-09-25 20:32:44'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-25 20:32:52'),
	(3, 'REMOVE ITEM', 'cash', 37500, '', '2021-09-25 20:32:56'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-25 20:33:03'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-25 20:33:08'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-25 20:33:15'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-25 20:33:36'),
	(3, 'REMOVE ITEM', 'cash', 20000, '', '2021-09-25 20:33:43'),
	(3, 'REMOVE ITEM', 'cash', 20000, '', '2021-09-25 20:33:46'),
	(3, 'REMOVE ITEM', 'cash', 25000, '', '2021-09-25 20:33:48'),
	(3, 'REMOVE ITEM', 'cash', 30000, '', '2021-09-25 20:33:50'),
	(3, 'REMOVE ITEM', 'cash', 20000, '', '2021-09-25 20:33:57'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-25 20:33:59'),
	(3, 'REMOVE ITEM', 'cash', 1000, '', '2021-09-25 20:34:25'),
	(3, 'REMOVE ITEM', 'cash', 1000, '', '2021-09-25 20:34:42'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-25 20:34:54'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-25 20:35:04'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-25 20:35:12'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-25 20:35:34'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-25 20:35:40'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-25 20:35:52'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-25 20:36:10'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-25 20:36:37'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-25 20:36:45'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-25 20:36:47'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-25 20:36:50'),
	(3, 'SHOP PURCHASE', 'sandwich', 5, '100', '2021-09-25 21:00:04'),
	(3, 'REMOVE ITEM', 'cash', 100, '', '2021-09-25 21:00:04'),
	(3, 'USE ITEM', 'sandwich', 1, '', '2021-09-25 21:00:14'),
	(3, 'REMOVE ITEM', 'casino-chips', 25000, '', '2021-09-25 22:13:25'),
	(3, 'ADD ITEM', 'casino-chips', 50000, '', '2021-09-25 22:13:56'),
	(3, '[ERROR] ADD ITEM FAIL', 'pistol-ammo', 9999, 'ADMIN', '2021-09-25 22:14:31'),
	(3, 'ADD ITEM', 'pistol-ammo', 1, 'ADMIN', '2021-09-25 22:14:38'),
	(3, '[ERROR] ADD ITEM FAIL', 'pistol-ammo', 999, 'ADMIN', '2021-09-25 22:14:42'),
	(3, '[ERROR] ADD ITEM FAIL', 'pistol-ammo', 77, 'ADMIN', '2021-09-25 22:14:46'),
	(3, 'ADD ITEM', 'pistol-ammo', 8, 'ADMIN', '2021-09-25 22:14:51'),
	(3, 'USE ITEM', 'holy-water', 1, '', '2021-09-25 22:14:57'),
	(3, 'USE ITEM', 'pistol-ammo', 1, '', '2021-09-25 22:15:15'),
	(3, 'USE ITEM', 'pistol-ammo', 1, '', '2021-09-25 22:15:23'),
	(3, 'REMOVE ITEM', 'pistol-ammo', 1, '', '2021-09-26 11:53:12'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-26 11:55:15'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-26 11:56:05'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-26 11:57:39'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-26 11:58:00'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-26 11:59:02'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-26 11:59:26'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-26 11:59:36'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-26 12:00:41'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-26 12:01:50'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-26 12:02:15'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-26 12:02:50'),
	(9, 'USE ITEM', 'water', 1, '', '2021-09-26 12:32:41'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-26 14:43:07'),
	(3, 'REMOVE ITEM', 'cash', 16, '', '2021-09-26 14:46:12'),
	(3, 'REMOVE ITEM', 'cash', 37500, '', '2021-09-26 14:46:17'),
	(3, 'REMOVE ITEM', 'cash', 20000, '', '2021-09-26 14:46:19'),
	(3, 'REMOVE ITEM', 'cash', 20000, '', '2021-09-26 14:46:21'),
	(3, 'REMOVE ITEM', 'cash', 25000, '', '2021-09-26 14:46:23'),
	(3, 'REMOVE ITEM', 'cash', 30000, '', '2021-09-26 14:46:25'),
	(3, 'REMOVE ITEM', 'cash', 20000, '', '2021-09-26 14:46:27'),
	(3, 'REMOVE ITEM', 'cash', 1000, '', '2021-09-26 14:46:31'),
	(3, 'REMOVE ITEM', 'cash', 1000, '', '2021-09-26 14:46:33'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-26 14:46:58'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-26 14:47:16'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-26 14:47:28'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-26 14:47:31'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-26 14:47:37'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-26 14:48:07'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-26 14:48:13'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-26 14:48:16'),
	(3, 'REMOVE ITEM', 'cash', 22, '', '2021-09-26 14:51:09'),
	(3, 'ADD ITEM', 'cash', 113, 'ROB CASH REGISTER', '2021-09-27 13:36:18'),
	(3, '[ERROR] ADD ITEM FAIL', 'safe-cracking-tool', 1, 'ADMIN', '2021-09-27 14:44:47'),
	(3, '[ERROR] ADD ITEM FAIL', 'safe-cracking-tool', 1, 'ADMIN', '2021-09-27 14:45:18'),
	(3, '[ERROR] ADD ITEM FAIL', 'safe-cracking-tool', 1, 'ADMIN', '2021-09-27 14:45:32'),
	(3, '[ERROR] ADD ITEM FAIL', 'hand-cuffs', 1, 'ADMIN', '2021-09-27 14:45:38'),
	(3, 'ADD ITEM', 'hamburger', 1, 'ADMIN', '2021-09-27 14:46:14'),
	(3, 'ADD ITEM', 'safe-cracking-tool', 1, 'ADMIN', '2021-09-27 14:46:17'),
	(3, 'REMOVE ITEM', 'safe-cracking-tool', 1, '', '2021-09-27 15:05:08'),
	(3, 'ADD ITEM', 'safe-cracking-tool', 10, 'ADMIN', '2021-09-27 15:05:41'),
	(3, 'REMOVE ITEM', 'safe-cracking-tool', 1, '', '2021-09-27 15:05:44'),
	(3, 'REMOVE ITEM', 'safe-cracking-tool', 1, '', '2021-09-27 15:20:34'),
	(3, 'REMOVE ITEM', 'safe-cracking-tool', 1, '', '2021-09-27 15:21:04'),
	(3, 'REMOVE ITEM', 'safe-cracking-tool', 1, '', '2021-09-27 15:21:31'),
	(3, 'REMOVE ITEM', 'safe-cracking-tool', 1, '', '2021-09-27 15:22:09'),
	(3, 'REMOVE ITEM', 'safe-cracking-tool', 1, '', '2021-09-27 15:22:44'),
	(3, 'REMOVE ITEM', 'safe-cracking-tool', 1, '', '2021-09-27 15:23:01'),
	(3, 'ADD ITEM', 'cash', 4000, '', '2021-09-27 15:24:38'),
	(3, 'ADD ITEM', 'cash', 4000, '', '2021-09-27 15:27:59'),
	(3, 'ADD ITEM', 'cash', 4000, '', '2021-09-27 15:28:07'),
	(3, 'ADD ITEM', 'cash', 4000, '', '2021-09-27 15:39:34'),
	(3, 'REMOVE ITEM', 'safe-cracking-tool', 1, '', '2021-09-27 16:47:01'),
	(3, 'ADD ITEM', 'cash', 4000, '', '2021-09-27 16:47:47'),
	(3, 'ADD ITEM', 'cash', 4000, '', '2021-09-27 16:48:11'),
	(3, 'ADD ITEM', 'cash', 4000, '', '2021-09-27 16:48:26'),
	(3, 'ADD ITEM', 'cash', 4000, '', '2021-09-27 16:49:47'),
	(3, 'ADD ITEM', 'cash', 4000, '', '2021-09-27 16:49:59'),
	(3, 'REMOVE ITEM', 'hamburger', 1, '', '2021-09-27 16:50:46'),
	(3, 'REMOVE ITEM', 'safe-cracking-tool', 1, '', '2021-09-27 16:53:48'),
	(3, 'REMOVE ITEM', 'safe-cracking-tool', 1, '', '2021-09-27 16:56:50'),
	(3, 'ADD ITEM', 'safe-cracking-tool', 10, 'ADMIN', '2021-09-27 16:56:58'),
	(3, 'REMOVE ITEM', 'safe-cracking-tool', 1, '', '2021-09-27 16:57:06'),
	(3, 'ADD ITEM', 'cash', 1677, '', '2021-09-27 17:11:48'),
	(3, 'ADD ITEM', 'cash', 2802, '', '2021-09-27 17:12:09'),
	(3, '[ERROR] ADD ITEM FAIL', 'heist-usb-red', 1, 'ADMIN', '2021-09-27 17:27:07'),
	(3, 'ADD ITEM', 'heist-usb-red', 1, 'ADMIN', '2021-09-27 17:27:18'),
	(3, 'ADD ITEM', 'cash', 1, 'WITHDRAW - 1', '2021-09-27 21:11:20'),
	(3, 'USE ITEM', 'holy-water', 1, '', '2021-09-27 22:52:13'),
	(3, 'ADD ITEM', 'heist-usb-green', 1, 'ADMIN', '2021-09-27 22:52:45'),
	(3, 'SHOP PURCHASE', 'donut', 1, '20', '2021-09-27 22:55:54'),
	(3, 'REMOVE ITEM', 'cash', 20, '', '2021-09-27 22:55:54'),
	(3, 'SHOP PURCHASE', 'donut', 1, '20', '2021-09-27 22:55:57'),
	(3, 'REMOVE ITEM', 'cash', 20, '', '2021-09-27 22:55:57'),
	(3, 'SHOP PURCHASE', 'sandwich', 1, '20', '2021-09-27 22:56:17'),
	(3, 'REMOVE ITEM', 'cash', 20, '', '2021-09-27 22:56:17'),
	(3, 'SHOP PURCHASE', 'sandwich', 1, '20', '2021-09-27 22:56:19'),
	(3, 'REMOVE ITEM', 'cash', 20, '', '2021-09-27 22:56:19'),
	(3, 'SHOP PURCHASE', 'sandwich', 1, '20', '2021-09-27 22:56:19'),
	(3, 'REMOVE ITEM', 'cash', 20, '', '2021-09-27 22:56:19'),
	(3, 'SHOP PURCHASE', 'water', 1, '20', '2021-09-27 22:56:21'),
	(3, 'REMOVE ITEM', 'cash', 20, '', '2021-09-27 22:56:21'),
	(3, 'SHOP PURCHASE', 'sandwich', 1, '20', '2021-09-27 22:56:23'),
	(3, 'REMOVE ITEM', 'cash', 20, '', '2021-09-27 22:56:23'),
	(3, 'SHOP PURCHASE', 'sandwich', 1, '20', '2021-09-27 22:56:28'),
	(3, 'REMOVE ITEM', 'cash', 20, '', '2021-09-27 22:56:28'),
	(3, 'SHOP PURCHASE', 'sandwich', 1, '20', '2021-09-27 22:56:29'),
	(3, 'REMOVE ITEM', 'cash', 20, '', '2021-09-27 22:56:29'),
	(3, 'SHOP PURCHASE', 'sandwich', 1, '20', '2021-09-27 22:56:29'),
	(3, 'REMOVE ITEM', 'cash', 20, '', '2021-09-27 22:56:29'),
	(3, 'SHOP PURCHASE', 'sandwich', 1, '20', '2021-09-27 22:56:31'),
	(3, 'REMOVE ITEM', 'cash', 20, '', '2021-09-27 22:56:31'),
	(3, 'SHOP PURCHASE', 'sandwich', 1, '20', '2021-09-27 22:56:31'),
	(3, 'REMOVE ITEM', 'cash', 20, '', '2021-09-27 22:56:31'),
	(3, 'SHOP PURCHASE', 'sandwich', 1, '20', '2021-09-27 22:56:32'),
	(3, 'REMOVE ITEM', 'cash', 20, '', '2021-09-27 22:56:32'),
	(3, 'SHOP PURCHASE', 'sandwich', 5, '100', '2021-09-27 22:56:33'),
	(3, 'REMOVE ITEM', 'cash', 100, '', '2021-09-27 22:56:33'),
	(3, 'REMOVE ITEM', 'casino-chips', 50000, '', '2021-09-27 22:57:28'),
	(3, 'ADD ITEM', 'casino-chips', 100000, '', '2021-09-27 22:58:15'),
	(3, 'ADD ITEM', 'cash', 111, 'ROB CASH REGISTER', '2021-09-27 23:08:07'),
	(3, 'ADD ITEM', 'safe-cracking-tool', 3, 'ADMIN', '2021-09-27 23:08:17'),
	(3, 'ADD ITEM', 'cash', 103, 'ROB CASH REGISTER', '2021-09-27 23:09:20'),
	(3, 'ADD ITEM', 'pistol-ammo', 10, 'ADMIN', '2021-09-27 23:13:05'),
	(3, 'USE ITEM', 'pistol-ammo', 1, '', '2021-09-27 23:13:11'),
	(3, 'USE ITEM', 'pistol-ammo', 1, '', '2021-09-27 23:13:16'),
	(3, 'USE ITEM', 'pistol-ammo', 1, '', '2021-09-27 23:13:22'),
	(3, 'USE ITEM', 'pistol-ammo', 1, '', '2021-09-27 23:13:27'),
	(3, 'USE ITEM', 'pistol-ammo', 1, '', '2021-09-27 23:13:32'),
	(3, 'ADD ITEM', 'cash', 1625, '', '2021-09-27 23:16:19'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-09-27 23:19:45'),
	(3, 'REMOVE ITEM', 'casino-chips', 3000, '', '2021-09-30 18:32:53'),
	(3, 'ADD ITEM', 'casino-chips', 6000, '', '2021-09-30 18:33:38'),
	(3, 'REMOVE ITEM', 'casino-chips', 5000, '', '2021-09-30 18:34:49'),
	(3, 'REMOVE ITEM', 'casino-chips', 5000, '', '2021-09-30 18:35:05'),
	(3, 'REMOVE ITEM', 'casino-chips', 5000, '', '2021-09-30 18:35:25'),
	(3, 'REMOVE ITEM', 'casino-chips', 5000, '', '2021-09-30 18:36:10'),
	(3, 'REMOVE ITEM', 'casino-chips', 5000, '', '2021-09-30 18:36:25'),
	(3, 'ADD ITEM', 'casino-chips', 20000, '', '2021-09-30 18:36:30'),
	(3, 'REMOVE ITEM', 'casino-chips', 5000, '', '2021-09-30 18:36:40'),
	(3, 'ADD ITEM', 'casino-chips', 10000, '', '2021-09-30 18:37:04'),
	(3, 'ADD ITEM', 'cash', 136, 'ROB CASH REGISTER', '2021-10-02 15:25:49'),
	(3, 'ADD ITEM', 'cash', 2129, '', '2021-10-02 15:39:41'),
	(3, 'ADD ITEM', 'cash', 125, 'ROB CASH REGISTER', '2021-10-02 19:43:16'),
	(3, 'ADD ITEM', 'cash', 50009, 'ADMIN', '2021-10-02 19:46:01'),
	(3, 'REMOVE ITEM', 'cash', 500, '', '2021-10-02 19:46:05'),
	(3, 'REMOVE ITEM', 'casino-chips', 50000, '', '2021-10-02 19:48:00'),
	(3, 'REMOVE ITEM', 'casino-chips', 50000, '', '2021-10-02 19:48:14'),
	(3, 'REMOVE ITEM', 'casino-chips', 5000, '', '2021-10-02 19:49:30'),
	(3, 'ADD ITEM', 'casino-chips', 10000, '', '2021-10-02 19:49:50');
/*!40000 ALTER TABLE `inventory_economy` ENABLE KEYS */;

-- Dumping structure for table sitt.lockers
CREATE TABLE IF NOT EXISTS `lockers` (
  `owner` text DEFAULT NULL,
  `inventory` text DEFAULT '{}',
  KEY `owner` (`owner`(768))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table sitt.lockers: ~0 rows (approximately)
/*!40000 ALTER TABLE `lockers` DISABLE KEYS */;
INSERT INTO `lockers` (`owner`, `inventory`) VALUES
	('evidence1', '{"1":{"itemId":"wine","qty":1}}');
/*!40000 ALTER TABLE `lockers` ENABLE KEYS */;

-- Dumping structure for table sitt.phone_contacts
CREATE TABLE IF NOT EXISTS `phone_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizen_id` int(11) DEFAULT 0,
  `number` int(11) DEFAULT 1234567,
  `name` text COLLATE utf8mb4_unicode_ci DEFAULT unix_timestamp(),
  PRIMARY KEY (`id`),
  KEY `citizen_id` (`citizen_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt.phone_contacts: ~1 rows (approximately)
/*!40000 ALTER TABLE `phone_contacts` DISABLE KEYS */;
INSERT INTO `phone_contacts` (`id`, `citizen_id`, `number`, `name`) VALUES
	(17, 3, 6942069, 'istoprocent');
/*!40000 ALTER TABLE `phone_contacts` ENABLE KEYS */;

-- Dumping structure for table sitt.phone_tweets
CREATE TABLE IF NOT EXISTS `phone_tweets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizen_id` int(11) DEFAULT 0,
  `text` text COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `poster` text COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Unknown?',
  `date` int(11) NOT NULL DEFAULT unix_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt.phone_tweets: ~8 rows (approximately)
/*!40000 ALTER TABLE `phone_tweets` DISABLE KEYS */;
INSERT INTO `phone_tweets` (`id`, `citizen_id`, `text`, `poster`, `date`) VALUES
	(1, 3, 'uus tweet idk', '@Pede_Homo', 1633194848),
	(2, 3, '1366312', '@Pede_Homo', 1633195055),
	(3, 3, 'rwsfghwrshgwhra', '@Pede_Homo', 1633195059),
	(4, 3, 'asdfsafd', '@Pede_Homo', 1633195177),
	(5, 3, 'adfsargejthdgtjsgjtrsftrsfj', '@Pede_Homo', 1633195224),
	(6, 3, 'uus twiit :O', '@Pede_Homo', 1633195230),
	(7, 3, 'trhfgkjrtfheojrfhenjirfswngrfsjbngrfsikhbrgsfihrfjskhwestyjtkirdjstrhfgkjrtfheojrfhenjirfswngrfsjbngrfsikhbrgsfihrfjskhwestyjtkirdjstrhfgkjrtfheojrfhenjirfswngrfsjbngrfsikhbrgsfihrfjskhwestyjtkirdjstrhfgkjrtfheojrfhenjirfswng', '@Pede_Homo', 1633195339),
	(8, 3, '    overflow-wrap: anywhere;    overflow-wrap: anywhere;    overflow-wrap: anywhere;    overflow-wrap: anywhere;    overflow-wrap: anywhere;    overflow-wrap: anywhere;    overflow-wrap: anywhere;    overflow-wrap: anywhere; ', '@Pede_Homo', 1633195468),
	(9, 3, 'trzhthththhttrrtthrxtztjrerdrerhjderhjedrdhjerhjdfehrdfdrhfdhrfhdrhdrrdhfdhdrhhdrfh', '@Pede_Homo', 1633198958),
	(10, 3, 'PEDED ON HOMOD', '@Pede_Homo', 1633272345);
/*!40000 ALTER TABLE `phone_tweets` ENABLE KEYS */;

-- Dumping structure for table sitt.players
CREATE TABLE IF NOT EXISTS `players` (
  `pid` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(60) DEFAULT '?',
  `license2` varchar(60) DEFAULT '?',
  `steam` text DEFAULT '?',
  `display_name` tinytext DEFAULT '',
  `play_time` int(11) DEFAULT 0,
  `last_played` int(11) DEFAULT unix_timestamp(),
  PRIMARY KEY (`pid`) USING BTREE,
  KEY `license` (`license`)
) ENGINE=InnoDB AUTO_INCREMENT=1003 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table sitt.players: ~1 rows (approximately)
/*!40000 ALTER TABLE `players` DISABLE KEYS */;
INSERT INTO `players` (`pid`, `license`, `license2`, `steam`, `display_name`, `play_time`, `last_played`) VALUES
	(7, 'license:4944817e5645aa0b5d4b886064f4c473821ff39e', 'license2:0f3a0ce22c22368c7f0dabe6987fd470a2ba63e6', 'steam:11000010c692ef1', 'klicer', 773115, 1633713818);
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
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table sitt.vehicles: ~24 rows (approximately)
/*!40000 ALTER TABLE `vehicles` DISABLE KEYS */;
INSERT INTO `vehicles` (`vin`, `cid`, `faction`, `model`, `stats`, `mods`, `plate`, `inGarage`, `glovebox`, `trunk`, `created_at`) VALUES
	(2, 3, 0, 'bati', '{"bodyHealth":818.1345825195313,"engineHealth":775.89990234375,"fuel":41}', '{}', 'DRUGBATI', 2, '{"5":{"qty":1,"itemId":"weed-brick-600g"},"4":{"qty":1,"itemId":"weed-brick-600g"},"1":{"qty":1,"itemId":"weed-brick-600g"},"3":{"qty":1,"itemId":"weed-brick-600g"},"2":{"qty":1,"itemId":"weed-brick-600g"}}', '{}', 1621274228),
	(3, 3, 0, 'sultan', '{"fuel":30,"bodyHealth":977.4801635742188,"engineHealth":990.59521484375}', '{}', 'SULTANAN', 2, '{}', '{}', 1621274228),
	(4, 3, 0, 'schafter3', '{"bodyHealth":655.6937866210938,"engineHealth":990.25,"fuel":44}', '{}', 'SCHAFTER', 2, '{}', '{}', 1621274228),
	(6, 3, 0, 'tractor2', '{"bodyHealth":989.6702270507813,"engineHealth":1000.0,"fuel":97}', '{}', 'TRACRACA', 2, '{}', '{}', 1621274228),
	(10, 3, 0, 'tractor', '{"bodyHealth":1000.0,"fuel":90,"engineHealth":1000.0}', '{}', 'TRACFRRR', 2, '{}', '{}', 1621274228),
	(12, 3, 0, 'bulldozer', '{"engineHealth":1000.0,"fuel":100,"bodyHealth":1000.0}', '{}', 'BULLDOZA', 2, '{}', '{}', 1621274228),
	(13, 3, 0, 'penumbra', '{"fuel":77,"bodyHealth":918.4884033203125,"engineHealth":932.9533081054688}', '{}', 'PENUMBRA', 2, '{}', '{}', 1621274228),
	(16, 3, 0, 'divo', '{"fuel":61,"engineHealth":995.5169067382813,"bodyHealth":909.1953125}', '{}', 'LP700YES', 2, '{}', '{}', 1621274228),
	(17, 9, 0, 'amggtc', '{"fuel":65,"engineHealth":998.125,"bodyHealth":998.75}', '{}', 'AMGGTCXX', 2, '{}', '{}', 1621274228),
	(18, 3, 0, 'rmodmustang', '{"fuel":50,"bodyHealth":953.19775390625,"engineHealth":1000.0}', '{}', 'RMODMUST', 2, '{}', '{}', 1621274228),
	(19, 3, 0, 'mustang19', '{"bodyHealth":970.8665161132813,"engineHealth":995.5,"fuel":75}', '{}', 'MUSTANG1', 2, '{"1":{"qty":8,"itemId":"sandwich"}}', '{}', 1621274228),
	(21, 3, 0, 'ellie6str', '{"bodyHealth":72.20697784423828,"engineHealth":747.959228515625,"fuel":37}', '{}', 'ELLI6STR', 2, '{}', '{}', 1621274228),
	(23, 9, 0, 'filthynsx', '{"fuel":65,"engineHealth":1000.0,"bodyHealth":1000.0}', '{}', 'FILTHYNS', 2, '{}', '{}', 1621274228),
	(25, 9, 0, 'r8v10', '{"bodyHealth":606.275146484375,"engineHealth":918.173828125,"fuel":97}', '{}', 'WOWLICEN', 2, '{}', '{}', 1621274228),
	(26, 9, 0, 'audirs6tk', '{"fuel":84,"bodyHealth":978.9036865234375,"engineHealth":990.1055297851563}', '{}', 'LMAOLOLF', 2, '{}', '{}', 1621274228),
	(28, 9, 0, '66fastback', '{"fuel":100,"bodyHealth":1000.0,"engineHealth":1000.0}', '{}', '8REV1XF2', 2, '{}', '{}', 1621274228),
	(51, 0, 2, 'ambulance', '{"fuel":95,"engineHealth":927.95361328125,"bodyHealth":929.2866821289063}', '{}', '7UJ47A5S', 2, '{}', '{}', 1621274228),
	(52, 0, 2, 'ambulance', '{"fuel":95,"engineHealth":927.95361328125,"bodyHealth":929.2866821289063}', '{}', '7UJ47A56', 2, '{}', '{}', 1621274228),
	(56, 0, 1, '2015polstang', '{"engineHealth":989.7754516601563,"bodyHealth":917.9384155273438,"fuel":56}', '{"Livery":0,"Extras":[1,2,3,4,5,7]}', 'Q2QTRK7R', 1, '{}', '{}', 1621274228),
	(57, 0, 1, 'polvic', '{"bodyHealth":983.277099609375,"engineHealth":979.5601806640625,"fuel":96}', '{"Livery":1, "Extras":[1,2,3,4,5,6,7,8]}', 'RAGD8IOY', 2, '{}', '{}', 1621274228),
	(58, 0, 1, 'polvic', '{"engineHealth":1000.0,"bodyHealth":516.3997802734375,"fuel":95}', '{"Livery":1, "Extras":[1,2,3,4,5,6,7,8]}', 'M77UJ47A', 2, '{}', '{}', 1621274228),
	(59, 3, 0, 'zr350', '{"engineHealth":834.0026245117188,"bodyHealth":878.29296875,"fuel":50}', '{"Brakes":2,"Engine":3,"PrimaryColour":27,"Exhaust":8,"Armor":4,"WheelType":5,"Transmission":2,"FrontWheels":17,"FrontBumper":1,"Suspension":3,"Spoilers":1,"Frame":4,"Fender":-1,"Hood":6,"Turbo":1,"WindowTint":1,"SideSkirt":5,"Xenon":1,"Grille":3,"WheelColour":147,"SecondaryColour":27,"XenonColor":8}', 'LOLLOLLL', 1, '{}', '{}', 1632590853),
	(60, 3, 0, 'tailgater2', '{"engineHealth":994.3165283203125,"bodyHealth":984.2418212890625,"fuel":86}', '{"Exhaust":7,"WindowTint":1,"WheelType":7,"Turbo":1,"FrontBumper":8,"FrontWheels":38,"Fender":3,"RearBumper":9,"Hood":22,"Engine":3,"SideSkirt":1,"Spoilers":0,"Suspension":3,"Armor":4,"Transmission":2,"Brakes":2}', 'TAILGATE', 2, '{}', '{}', 1632656715),
	(61, 0, 1, 'polchar', '{"engineHealth":948.66650390625,"bodyHealth":908.1339721679688,"fuel":95}', '{"Livery":1, "Extras":[1,2,3,4]}', 'OQHQH8B3', 3, '{}', '{}', 1632772283);
/*!40000 ALTER TABLE `vehicles` ENABLE KEYS */;

-- Dumping structure for table sitt.vehicles_mods
CREATE TABLE IF NOT EXISTS `vehicles_mods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vin` int(11) NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` int(11) NOT NULL,
  `cost` int(11) DEFAULT 0,
  `timestamp` int(11) NOT NULL DEFAULT unix_timestamp(),
  PRIMARY KEY (`id`),
  KEY `vin` (`vin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt.vehicles_mods: ~0 rows (approximately)
/*!40000 ALTER TABLE `vehicles_mods` DISABLE KEYS */;
/*!40000 ALTER TABLE `vehicles_mods` ENABLE KEYS */;

-- Dumping structure for table sitt.warns
CREATE TABLE IF NOT EXISTS `warns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license2` text DEFAULT 'license:0',
  `reason` varchar(255) DEFAULT NULL,
  `date` int(11) DEFAULT unix_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table sitt.warns: ~5 rows (approximately)
/*!40000 ALTER TABLE `warns` DISABLE KEYS */;
INSERT INTO `warns` (`id`, `license2`, `reason`, `date`) VALUES
	(3, 'license2:0f3a0ce22c22368c7f0dabe6987fd470a2ba63e6', 'LMAO FUCK OFF', 1620049231),
	(4, 'license2:0f3a0ce22c22368c7f0dabe6987fd470a2ba63e6', 'test', 1620049278),
	(5, 'license2:0f3a0ce22c22368c7f0dabe6987fd470a2ba63e6', 'LMAO 995463365946345', 1620049297),
	(6, 'license2:0f3a0ce22c22368c7f0dabe6987fd470a2ba63e6', 'LOPETA ARA', 1620049307),
	(7, 'license2:0f3a0ce22c22368c7f0dabe6987fd470a2ba63e6', 'LMAO', 1620049418);
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

-- Dumping data for table sitt.whitelist: ~1 rows (approximately)
/*!40000 ALTER TABLE `whitelist` DISABLE KEYS */;
INSERT INTO `whitelist` (`id`, `steam`, `priority`, `date`) VALUES
	(5, 'steam:11000010c692ef2', 0, 1620926347);
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt.whitelist_applications: ~2 rows (approximately)
/*!40000 ALTER TABLE `whitelist_applications` DISABLE KEYS */;
INSERT INTO `whitelist_applications` (`id`, `hex`, `name`, `answers`, `timestamp`, `status`, `admin_comment`, `processed_by`) VALUES
	(14, 'steam:11000010c692ef1', 'klicer', '{"Your IRL age":"1","Have you read our server rules? If so, where did you find them.":"ds","What kind of character would you like to roleplay as?":"das","What are your character\'s strengths and weaknesses?":"sad","Someone is aiming at you with a gun, how does your character react?":"sad","You are selling drugs with your friend and a random person starts robbing you at gunpoint. What do you do?":"sda"}', 1633721022, 1, NULL, NULL),
	(15, 'steam:11000010c692ef1', 'klicer', '{"Your IRL age":"1","Have you read our server rules? If so, where did you find them.":"ds","What kind of character would you like to roleplay as?":"ds","What are your character\'s strengths and weaknesses?":"ds","Someone is aiming at you with a gun, how does your character react?":"sd","You are selling drugs with your friend and a random person starts robbing you at gunpoint. What do you do?":"ds"}', 1633721147, 0, NULL, NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=142 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt._faction_logs: ~116 rows (approximately)
/*!40000 ALTER TABLE `_faction_logs` DISABLE KEYS */;
INSERT INTO `_faction_logs` (`id`, `faction_id`, `character_id`, `action`, `content`, `timestamp`) VALUES
	(1, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [2AU6CC6T] polchar ({"fuel":78.0,"engineHealth":943.73,"bodyHealth":932.68})', 1620588798),
	(2, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [2AU6CC6T] polchar ({"bodyHealth":901.74,"engineHealth":943.73,"fuel":75.0})', 1620588858),
	(3, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [F2C8RYVN] polvic ({"bodyHealth":1000.0,"engineHealth":1000.0,"fuel":100.0})', 1620588980),
	(4, 1, 3, 'GARAGE', 'STORED VEHICLE - [F2C8RYVN] -1968900483 ({"bodyHealth":1000.0,"engineHealth":1000.0,"fuel":100.0})', 1620588980),
	(5, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [F2C8RYVN] polvic ({"bodyHealth":1000.0,"engineHealth":1000.0,"fuel":100.0})', 1620588983),
	(6, 1, 3, 'GARAGE', 'STORED VEHICLE - [F2C8RYVN] -1968900483 ({"bodyHealth":1000.0,"engineHealth":1000.0,"fuel":94.0})', 1620589298),
	(7, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [2AU6CC6T] polchar ({"bodyHealth":901.74,"engineHealth":943.73,"fuel":75.0})', 1620589318),
	(8, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [2AU6CC6T] polchar ({"bodyHealth":901.74,"engineHealth":943.73,"fuel":75.0})', 1620589324),
	(9, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [2AU6CC6T] polchar ({"bodyHealth":901.74,"engineHealth":943.73,"fuel":75.0})', 1620589329),
	(10, 1, 3, 'GARAGE', 'STORED VEHICLE - [2AU6CC6T] -1612763217 ({"bodyHealth":901.74,"engineHealth":943.73,"fuel":74.0})', 1620589386),
	(11, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [2AU6CC6T] polchar ({"bodyHealth":901.74,"engineHealth":943.73,"fuel":74.0})', 1620589388),
	(12, 1, 3, 'GARAGE', 'STORED VEHICLE - [2AU6CC6T] -1612763217 ({"bodyHealth":901.74,"engineHealth":943.73,"fuel":74.0})', 1620589389),
	(13, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [2AU6CC6T] polchar ({"bodyHealth":901.74,"engineHealth":943.73,"fuel":74.0})', 1620589391),
	(14, 1, 3, 'GARAGE', 'STORED VEHICLE - [2AU6CC6T] -1612763217 ({"bodyHealth":901.74,"engineHealth":943.73,"fuel":74.0})', 1620589392),
	(15, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [2AU6CC6T] polchar ({"bodyHealth":901.74,"engineHealth":943.73,"fuel":74.0})', 1620589395),
	(16, 1, 3, 'GARAGE', 'STORED VEHICLE - [2AU6CC6T] -1612763217 ({"bodyHealth":901.74,"engineHealth":943.73,"fuel":74.0})', 1620589396),
	(17, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [2AU6CC6T] polchar ({"bodyHealth":901.74,"engineHealth":943.73,"fuel":74.0})', 1620589399),
	(18, 1, 3, 'GARAGE', 'STORED VEHICLE - [2AU6CC6T] -1612763217 ({"bodyHealth":901.74,"engineHealth":943.73,"fuel":74.0})', 1620589416),
	(19, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [2AU6CC6T] polchar ({"bodyHealth":901.74,"engineHealth":943.73,"fuel":74.0})', 1620589418),
	(20, 1, 3, 'GARAGE', 'STORED VEHICLE - [2AU6CC6T] -1612763217 ({"fuel":74.0,"bodyHealth":901.74,"engineHealth":943.73})', 1620589424),
	(21, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [2AU6CC6T] polchar ({"fuel":74.0,"bodyHealth":901.74,"engineHealth":943.73})', 1620589427),
	(22, 1, 3, 'GARAGE', 'STORED VEHICLE - [2AU6CC6T] -1612763217 ({"fuel":74.0,"bodyHealth":901.74,"engineHealth":943.73})', 1620589427),
	(23, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [2AU6CC6T] polchar ({"fuel":74.0,"bodyHealth":901.74,"engineHealth":943.73})', 1620589429),
	(24, 1, 3, 'GARAGE', 'STORED VEHICLE - [2AU6CC6T] -1612763217 ({"fuel":61.0,"bodyHealth":971.76,"engineHealth":976.49})', 1620589544),
	(25, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [2AU6CC6T] polchar ({"engineHealth":976.49,"bodyHealth":971.76,"fuel":61.0})', 1620592274),
	(26, 2, 3, 'CHANGE MEMBER ALIAS', 'CID: 3 | 01 => 02', 1620592469),
	(27, 1, 3, 'CHANGE MEMBER RANK', 'CID: 38 | [0]  => [3] Kadett', 1620593458),
	(28, 1, 3, 'CHANGE MEMBER RANK', 'CID: 39 | [28] Kapten => [3] Kadett', 1620593461),
	(29, 1, 3, 'CHANGE MEMBER RANK', 'CID: 40 | [30] KomandÃ¶r => [99] Asedirektor', 1620593480),
	(30, 2, 3, 'ADD RANK', '[3] Kadett', 1620593518),
	(31, 2, 3, 'CHANGE RANK NAME', 'Kadett => [FTO] Kadett', 1620593523),
	(32, 2, 3, 'CHANGE RANK NAME', '3 => 4', 1620593524),
	(33, 1, 3, 'CHANGE RANK NAME', '99 => 99', 1620593929),
	(34, 1, 3, 'CHANGE RANK NAME', '99 => 5', 1620593931),
	(35, 1, 3, 'CHANGE RANK NAME', '5 => 95', 1620593935),
	(36, 2, 3, 'BUY VEHICLE', '[$50000] ambulance', 1620594127),
	(37, 2, 3, 'GARAGE', 'TAKE VEHICLE OUT - [7UJ47A5S] ambulance ({"bodyHealth":1000.0,"fuel":100.0,"engineHealth":1000.0})', 1620594134),
	(38, 2, 3, 'GARAGE', 'TAKE VEHICLE OUT - [7UJ47A5S] ambulance ({"engineHealth":1000.0,"bodyHealth":1000.0,"fuel":99.0})', 1620594316),
	(39, 2, 3, 'GARAGE', 'TAKE VEHICLE OUT - [7UJ47A5S] ambulance ({"engineHealth":1000.0,"bodyHealth":1000.0,"fuel":99.0})', 1620594327),
	(40, 2, 3, 'GARAGE', 'STORED VEHICLE - [7UJ47A5S] 1171614426 ({"engineHealth":927.95,"bodyHealth":929.29,"fuel":95.0})', 1620594509),
	(41, 1, 3, 'CHANGE MEMBER RANK', 'CID: 40 | [95] Asedirektor => [0] Palgatapuhkus', 1620595135),
	(42, 1, 3, 'CHANGE MEMBER RANK', 'CID: 39 | [0]  => [1] Abipolitsei', 1620595140),
	(43, 1, 3, 'CHANGE RANK NAME', '1 => -555551', 1620595265),
	(44, 1, 3, 'CHANGE RANK NAME', '-555551 => -2000000000.0', 1620595273),
	(45, 1, 3, 'CHANGE MEMBER RANK', 'CID: 39 | [-2000000000] Abipolitsei => [0] Palgatapuhkus', 1620595393),
	(46, 1, 3, 'CHANGE MEMBER RANK', 'CID: 40 | [0] Palgatapuhkus => [4] Ohvitser', 1620595506),
	(47, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [F2C8RYVN] polvic ({"fuel":94.0,"bodyHealth":1000.0,"engineHealth":1000.0})', 1620595696),
	(48, 1, 3, 'CHANGE MEMBER RANK', 'CID: 40 | [4] Ohvitser => [3] Kadett', 1621164986),
	(49, 1, 3, 'REMOVE RANK', '[4] Ohvitser', 1621164999),
	(50, 1, 3, 'ADD RANK', '[4] Lol', 1621165004),
	(51, 1, 3, 'CHANGE MEMBER RANK', 'CID: 37 | [95] Asedirektor => [4] Lol', 1621165010),
	(52, 1, 3, 'BUY VEHICLE', '[$400000] 2015polstang', 1621165022),
	(53, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [U9UBXXV0] 2015polstang ({"fuel":100.0,"bodyHealth":1000.0,"engineHealth":1000.0})', 1621165032),
	(54, 1, 3, 'GARAGE', 'STORED VEHICLE - [U9UBXXV0] 1341474454 ({"fuel":100.0,"bodyHealth":1000.0,"engineHealth":1000.0})', 1621165042),
	(55, 1, 3, 'CHANGE MEMBER RANK', 'CID: 37 | [4] Lol => [28] Kapten', 1621165362),
	(56, 1, 3, 'CHANGE MEMBER ALIAS', 'CID: 37 | 469 => 420', 1621165366),
	(57, 1, 3, 'CHANGE RANK NAME', '-2000000000 => 1', 1621165384),
	(58, 1, 3, 'CHANGE RANK NAME', 'Lol => Ohvitser', 1621165391),
	(59, 1, 3, 'ADD RANK', '[1] deem', 1621165397),
	(60, 1, 3, 'CHANGE RANK NAME', 'deem => idk', 1621165406),
	(61, 1, 3, 'CHANGE RANK NAME', '1 => 69', 1621165408),
	(62, 1, 3, 'CHANGE MEMBER RANK', 'CID: 37 | [28] Kapten => [69] idk', 1621165417),
	(63, 1, 3, 'BUY VEHICLE', '[$400000] 2015polstang', 1621165425),
	(64, 1, 3, 'BUY VEHICLE', '[$250000] poltaurus', 1621165428),
	(65, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [IOTAHTXU] 2015polstang ({"engineHealth":1000.0,"bodyHealth":1000.0,"fuel":100.0})', 1621165438),
	(66, 1, 3, 'GARAGE', 'STORED VEHICLE - [IOTAHTXU] 1341474454 ({"fuel":99.0,"bodyHealth":1000.0,"engineHealth":1000.0})', 1621165458),
	(67, 1, 3, 'CHANGE MEMBER RANK', 'CID: 37 | [69] idk => [3] Kadett', 1621166077),
	(68, 1, 3, 'REMOVE RANK', '[69] idk', 1621166091),
	(69, 1, 3, 'CHANGE RANK NAME', '4 => 5', 1621166095),
	(70, 1, 3, 'CHANGE RANK NAME', '5 => 4', 1621166096),
	(71, 1, 3, 'ADD RANK', '[4] Bruh?', 1621166103),
	(72, 1, 3, 'CHANGE RANK NAME', '4 => 69', 1621166112),
	(73, 1, 3, 'CHANGE MEMBER RANK', 'CID: 39 | [0] Palgatapuhkus => [69] Bruh?', 1621166118),
	(74, 1, 3, 'REMOVE RANK', '[69] Bruh?', 1621166124),
	(75, 1, 3, 'BUY VEHICLE', '[$400000] 2015polstang', 1621166130),
	(76, 1, 3, 'BUY VEHICLE', '[$100000] polvic', 1621166132),
	(77, 1, 3, 'BUY VEHICLE', '[$100000] polvic', 1621166133),
	(78, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [RAGD8IOY] polvic ({"bodyHealth":1000.0,"engineHealth":1000.0,"fuel":100.0})', 1621166149),
	(79, 1, 3, 'GARAGE', 'STORED VEHICLE - [RAGD8IOY] -1968900483 ({"bodyHealth":997.09,"engineHealth":1000.0,"fuel":99.0})', 1621166174),
	(80, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [RAGD8IOY] polvic ({"engineHealth":1000.0,"fuel":99.0,"bodyHealth":997.09})', 1621167310),
	(81, 1, 3, 'GARAGE', 'STORED VEHICLE - [RAGD8IOY] Police Crown Victoria ({"bodyHealth":997.09,"fuel":97.0,"engineHealth":1000.0})', 1621167388),
	(82, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [M77UJ47A] polvic ({"bodyHealth":1000.0,"fuel":100.0,"engineHealth":1000.0})', 1621167524),
	(83, 1, 3, 'GARAGE', 'STORED VEHICLE - [M77UJ47A] Police Crown Victoria ({"bodyHealth":1000.0,"fuel":100.0,"engineHealth":1000.0})', 1621167532),
	(84, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [M77UJ47A] Police Crown Victoria ({"bodyHealth":1000.0,"engineHealth":1000.0,"fuel":100.0})', 1621167571),
	(85, 1, 3, 'GARAGE', 'STORED VEHICLE - [M77UJ47A] Police Crown Victoria ({"engineHealth":1000.0,"bodyHealth":1000.0,"fuel":100.0})', 1621167571),
	(86, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [Q2QTRK7R] Police Mustang ({"bodyHealth":1000.0,"engineHealth":1000.0,"fuel":100.0})', 1621168563),
	(87, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [RAGD8IOY] Police Crown Victoria ({"bodyHealth":997.09,"fuel":97.0,"engineHealth":1000.0})', 1621173111),
	(88, 1, 3, 'GARAGE', 'STORED VEHICLE - [RAGD8IOY] Police Crown Victoria ({"bodyHealth":983.28,"fuel":96.0,"engineHealth":979.56})', 1621173134),
	(89, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [Q2QTRK7R] Police Mustang ({"engineHealth":998.13,"bodyHealth":990.95,"fuel":61.0})', 1621279291),
	(90, 1, 3, 'GARAGE', 'STORED VEHICLE - [MUSTANG1] 2019 Ford Mustang ({"bodyHealth":973.87,"fuel":76.0,"engineHealth":1000.0})', 1621788379),
	(91, 1, 3, 'GARAGE', 'STORED VEHICLE - [AMGGTCXX] AMG GTC ({"bodyHealth":998.75,"fuel":65.0,"engineHealth":998.13})', 1621788399),
	(92, 1, 3, 'GARAGE', 'STORED VEHICLE - [RMODMUST] 2015 Ford Mustang ({"bodyHealth":953.95,"fuel":51.0,"engineHealth":1000.0})', 1621788407),
	(93, 1, 3, 'GARAGE', 'STORED VEHICLE - [FILTHYNS] Acura NSX LW ({"bodyHealth":1000.0,"fuel":65.0,"engineHealth":1000.0})', 1621788417),
	(94, 1, 3, 'GARAGE', 'STORED VEHICLE - [LP700YES] Bugatti Divo ({"fuel":61.0,"engineHealth":995.52,"bodyHealth":909.2})', 1621805379),
	(95, 1, 3, 'CHANGE MEMBER RANK', 'CID: 40 | [3] Kadett => [4] Ohvitser', 1621808616),
	(96, 1, 3, 'CHANGE MEMBER RANK', 'CID: 37 | [3] Kadett => [4] Ohvitser', 1621808620),
	(97, 1, 3, 'CHANGE MEMBER RANK', 'CID: 37 | [4] Ohvitser => [3] Kadett', 1621808659),
	(98, 1, 3, 'GARAGE', 'STORED VEHICLE - [RMODMUST] 2015 Ford Mustang ({"fuel":50.0,"bodyHealth":953.2,"engineHealth":1000.0})', 1621969475),
	(99, 1, 3, 'GARAGE', 'STORED VEHICLE - [ELLI6STR] 6STR Ellie ({"bodyHealth":185.58,"fuel":60.0,"engineHealth":904.7})', 1621970525),
	(100, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [Q2QTRK7R] Police Mustang ({"bodyHealth":1000.0,"engineHealth":1000.0,"fuel":58.0})', 1622057526),
	(101, 1, 3, 'GARAGE', 'STORED VEHICLE - [Q2QTRK7R] Police Mustang ({"bodyHealth":1000.0,"engineHealth":1000.0,"fuel":58.0})', 1622057527),
	(102, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [Q2QTRK7R] Police Mustang ({"bodyHealth":1000.0,"engineHealth":1000.0,"fuel":58.0})', 1622057529),
	(103, 1, 3, 'GARAGE', 'STORED VEHICLE - [MUSTANG1] 2019 Ford Mustang ({"engineHealth":995.5,"fuel":75.0,"bodyHealth":970.87})', 1624760899),
	(104, 1, 3, 'GARAGE', 'STORED VEHICLE - [ELLI6STR] 6STR Ellie ({"fuel":58.0,"engineHealth":904.7,"bodyHealth":182.33})', 1632558232),
	(105, 1, 3, 'GARAGE', 'STORED VEHICLE - [PENUMBRA] Penumbra ({"fuel":77.0,"engineHealth":932.95,"bodyHealth":918.49})', 1632558241),
	(106, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [LOLLOLLL] ZR350 ({"fuel":100.0,"bodyHealth":1000.0,"engineHealth":1000.0})', 1632590977),
	(107, 1, 3, 'GARAGE', 'STORED VEHICLE - [LOLLOLLL] ZR350 ({"bodyHealth":1000.0,"fuel":99.0,"engineHealth":1000.0})', 1632591001),
	(108, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [M77UJ47A] NULL ({"fuel":100.0,"bodyHealth":1000.0,"engineHealth":1000.0})', 1632591006),
	(109, 1, 3, 'GARAGE', 'STORED VEHICLE - [M77UJ47A] Police Crown Victoria ({"bodyHealth":1000.0,"fuel":100.0,"engineHealth":1000.0})', 1632591054),
	(110, 1, 3, 'GARAGE', 'STORED VEHICLE - [LOLLOLLL] ZR350 ({"bodyHealth":1000.0,"fuel":88.0,"engineHealth":1000.0})', 1632591480),
	(111, 1, 3, 'GARAGE', 'STORED VEHICLE - [LOLLOLLL] ZR350 ({"bodyHealth":999.25,"fuel":88.0,"engineHealth":1000.0})', 1632591487),
	(112, 1, 3, 'GARAGE', 'STORED VEHICLE - [LOLLOLLL] ZR350 ({"bodyHealth":991.85,"fuel":77.0,"engineHealth":996.25})', 1632591820),
	(113, 1, 3, 'GARAGE', 'STORED VEHICLE - [TRACFRRR] Tractor ({"engineHealth":1000.0,"fuel":90.0,"bodyHealth":1000.0})', 1632646860),
	(114, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [M77UJ47A] Police Crown Victoria ({"fuel":100.0,"engineHealth":1000.0,"bodyHealth":1000.0})', 1632648912),
	(115, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [M77UJ47A] Police Crown Victoria ({"fuel":100.0,"engineHealth":1000.0,"bodyHealth":1000.0})', 1632648915),
	(116, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [M77UJ47A] Police Crown Victoria ({"fuel":98.0,"engineHealth":1000.0,"bodyHealth":516.4})', 1632649020),
	(117, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [M77UJ47A] Police Crown Victoria ({"bodyHealth":516.4,"fuel":98.0,"engineHealth":1000.0})', 1632649049),
	(118, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [M77UJ47A] Police Crown Victoria ({"engineHealth":1000.0,"fuel":98.0,"bodyHealth":516.4})', 1632649126),
	(119, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [RAGD8IOY] Police Crown Victoria ({"engineHealth":979.56,"fuel":96.0,"bodyHealth":983.28})', 1632649151),
	(120, 1, 3, 'GARAGE', 'STORED VEHICLE - [RAGD8IOY] Police Crown Victoria ({"engineHealth":979.56,"fuel":96.0,"bodyHealth":983.28})', 1632649151),
	(121, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [RAGD8IOY] Police Crown Victoria ({"engineHealth":979.56,"fuel":96.0,"bodyHealth":983.28})', 1632649191),
	(122, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [RAGD8IOY] Police Crown Victoria ({"engineHealth":979.56,"fuel":96.0,"bodyHealth":983.28})', 1632649203),
	(123, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [M77UJ47A] Police Crown Victoria ({"bodyHealth":516.4,"engineHealth":1000.0,"fuel":98.0})', 1632656989),
	(124, 1, 3, 'GARAGE', 'STORED VEHICLE - [M77UJ47A] Police Crown Victoria ({"bodyHealth":516.4,"fuel":97.0,"engineHealth":1000.0})', 1632657005),
	(125, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [Q2QTRK7R] Police Mustang ({"bodyHealth":1000.0,"engineHealth":1000.0,"fuel":57.0})', 1632657016),
	(126, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [M77UJ47A] Police Crown Victoria ({"bodyHealth":516.4,"fuel":97.0,"engineHealth":1000.0})', 1632669517),
	(127, 1, 3, 'GARAGE', 'STORED VEHICLE - [M77UJ47A] Police Crown Victoria ({"engineHealth":1000.0,"fuel":97.0,"bodyHealth":516.4})', 1632669524),
	(128, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [M77UJ47A] Police Crown Victoria ({"engineHealth":1000.0,"fuel":97.0,"bodyHealth":516.4})', 1632739573),
	(129, 1, 3, 'GARAGE', 'STORED VEHICLE - [M77UJ47A] Police Crown Victoria ({"engineHealth":1000.0,"fuel":96.0,"bodyHealth":516.4})', 1632739620),
	(130, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [M77UJ47A] Police Crown Victoria ({"engineHealth":1000.0,"fuel":96.0,"bodyHealth":516.4})', 1632772159),
	(131, 1, 3, 'GARAGE', 'STORED VEHICLE - [M77UJ47A] Police Crown Victoria ({"engineHealth":1000.0,"fuel":96.0,"bodyHealth":516.4})', 1632772161),
	(132, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [RAGD8IOY] Police Crown Victoria ({"engineHealth":979.56,"fuel":96.0,"bodyHealth":983.28})', 1632772163),
	(133, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [M77UJ47A] Police Crown Victoria ({"engineHealth":1000.0,"fuel":96.0,"bodyHealth":516.4})', 1632772166),
	(134, 1, 3, 'GARAGE', 'STORED VEHICLE - [M77UJ47A] Police Crown Victoria ({"engineHealth":1000.0,"fuel":96.0,"bodyHealth":516.4})', 1632772177),
	(135, 1, 3, 'CHANGE MEMBER ALIAS', 'CID: 3 | 02 => 001', 1632772218),
	(136, 1, 3, 'BUY VEHICLE', '[$350000] polchar', 1632772283),
	(137, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [OQHQH8B3] Police Charger ({"engineHealth":1000.0,"bodyHealth":1000.0,"fuel":100.0})', 1632772311),
	(138, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [OQHQH8B3] Police Charger ({"engineHealth":948.67,"bodyHealth":908.13,"fuel":95.0})', 1632837594),
	(139, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [M77UJ47A] Police Crown Victoria ({"bodyHealth":516.4,"engineHealth":1000.0,"fuel":96.0})', 1633193458),
	(140, 1, 3, 'GARAGE', 'STORED VEHICLE - [M77UJ47A] Police Crown Victoria ({"bodyHealth":516.4,"engineHealth":1000.0,"fuel":95.0})', 1633193476),
	(141, 1, 3, 'GARAGE', 'TAKE VEHICLE OUT - [Q2QTRK7R] Police Mustang ({"bodyHealth":1000.0,"engineHealth":1000.0,"fuel":64.0})', 1633193501);
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
INSERT INTO `_faction_members` (`character_id`, `faction_id`, `rank_name`, `alias`) VALUES
	(3, 1, 'Admin', '001');
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

-- Dumping data for table sitt._faction_ranks: ~20 rows (approximately)
/*!40000 ALTER TABLE `_faction_ranks` DISABLE KEYS */;
INSERT INTO `_faction_ranks` (`id`, `faction_id`, `rank_name`, `rank_level`) VALUES
	(6, 1, 'Peadirektor', 100),
	(7, 2, 'Paramedic', 2),
	(8, 2, 'Paramedic FTO', 3),
	(9, 2, 'Lieutenant', 4),
	(10, 2, 'Assistant Chief of EMS	', 5),
	(11, 2, 'Chief of EMS	', 6),
	(12, 2, 'Trainee', 1),
	(20, 1, 'KomandÃ¶r', 30),
	(21, 1, 'Inspektor', 29),
	(22, 1, 'Palgatapuhkus', 0),
	(23, 1, 'Abipolitsei', 1),
	(24, 1, 'K-9', 2),
	(27, 1, 'Kapten', 28),
	(28, 1, 'VÃ¤lijuht', 16),
	(32, 1, 'Kadett', 3),
	(33, 1, 'Asedirektor', 95),
	(35, 1, 'Admin', 1000),
	(36, 2, 'Admin2', 1000),
	(37, 2, '[FTO] Kadett', 4),
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt._faction_vehicle_options: ~8 rows (approximately)
/*!40000 ALTER TABLE `_faction_vehicle_options` DISABLE KEYS */;
INSERT INTO `_faction_vehicle_options` (`id`, `faction_id`, `cost`, `model`, `mods`) VALUES
	(1, 1, 100000, 'polvic', '{"Livery":1, "Extras":[1,2,3,4,5,6,7,8]}'),
	(2, 1, 350000, 'polchar', '{"Livery":1, "Extras":[1,2,3,4]}'),
	(3, 1, 400000, '2015polstang', '{"Livery":0,"Extras":[1,2,3,4,5,7]}'),
	(4, 1, 2500, 'scorcher', '{}'),
	(5, 1, 200000, 'polraptor', '{"Livery":2, "Extras":[1,2,3,4,5]}'),
	(6, 1, 175000, 'poltah', '{"Livery":1, "Extras":[1,2,3,4,5,6,7,8]}'),
	(7, 1, 250000, 'poltaurus', '{"Livery":1, "Extras":[1,3,4,5,7]}'),
	(8, 2, 50000, 'ambulance', '{}');
/*!40000 ALTER TABLE `_faction_vehicle_options` ENABLE KEYS */;

-- Dumping structure for table sitt._housing_properties
CREATE TABLE IF NOT EXISTS `_housing_properties` (
  `property_id` int(11) NOT NULL,
  `owner` int(11) NOT NULL DEFAULT 0,
  `stash` text COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '{}',
  UNIQUE KEY `housing_id` (`property_id`) USING BTREE,
  KEY `owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt._housing_properties: ~3 rows (approximately)
/*!40000 ALTER TABLE `_housing_properties` DISABLE KEYS */;
INSERT INTO `_housing_properties` (`property_id`, `owner`, `stash`) VALUES
	(99, 3, '{"7":{"itemId":"holy-water","qty":5},"6":{"itemId":"cash","qty":716410}}'),
	(139, 9, '{}'),
	(797, 9, '{"1":{"itemId":"pistol-ammo","qty":3}}');
/*!40000 ALTER TABLE `_housing_properties` ENABLE KEYS */;

-- Dumping structure for table sitt._inventory_log
CREATE TABLE IF NOT EXISTS `_inventory_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizen_id` int(11) NOT NULL DEFAULT 0,
  `orig_inv_type` char(50) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `orig_inv_id` char(50) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `dest_inv_type` char(50) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `dest_inv_id` char(50) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `log_type` text COLLATE utf8mb4_unicode_ci DEFAULT '',
  `item_id` text COLLATE utf8mb4_unicode_ci DEFAULT '',
  `item_amount` int(11) NOT NULL DEFAULT 0,
  `content` text COLLATE utf8mb4_unicode_ci DEFAULT '',
  `timestamp` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt._inventory_log: ~57 rows (approximately)
/*!40000 ALTER TABLE `_inventory_log` DISABLE KEYS */;
INSERT INTO `_inventory_log` (`id`, `citizen_id`, `orig_inv_type`, `orig_inv_id`, `dest_inv_type`, `dest_inv_id`, `log_type`, `item_id`, `item_amount`, `content`, `timestamp`) VALUES
	(1, 3, '0', '0', 'player', '3', 'ADD ITEM', 'cigarette', 1, '', '2021-05-16 23:05:08'),
	(2, 3, '0', '0', 'player', '3', 'ADD ITEM', 'donut', 1, '', '2021-05-16 23:05:08'),
	(3, 3, '0', '0', 'player', '3', 'ADD ITEM', 'rolex-watch', 1, '', '2021-05-16 23:05:33'),
	(4, 3, '0', '0', 'player', '3', 'ADD ITEM', 'bandage', 1, '', '2021-05-16 23:05:33'),
	(5, 3, '0', '0', 'player', '3', 'ADD ITEM', 'ifak', 1, '', '2021-05-16 23:05:33'),
	(6, 3, '0', '0', 'player', '3', 'ADD ITEM', '5ct-gold-chain', 1, '', '2021-05-16 23:05:33'),
	(7, 3, '0', '0', 'player', '3', 'ADD ITEM', 'apple-iphone', 1, '', '2021-05-16 23:05:48'),
	(8, 3, '0', '0', 'player', '3', 'ADD ITEM', 'rolex-watch', 1, '', '2021-05-16 23:05:48'),
	(9, 3, '0', '0', 'player', '3', 'ADD ITEM', 'joint', 1, '', '2021-05-16 23:05:48'),
	(10, 3, '0', '0', 'player', '3', 'ADD ITEM', 'cigarette', 1, '', '2021-05-16 23:05:48'),
	(11, 3, '0', '0', 'player', '3', 'ADD ITEM', 'samsung-s8', 1, '', '2021-05-16 23:05:48'),
	(12, 3, '0', '0', 'player', '3', 'ADD ITEM', 'rolex-watch', 1, '', '2021-05-16 23:05:48'),
	(13, 3, '0', '0', 'player', '3', 'ADD ITEM', 'cigarette', 1, '', '2021-05-16 23:06:09'),
	(14, 3, '0', '0', 'player', '3', 'ADD ITEM', 'beer', 1, '', '2021-05-16 23:06:09'),
	(15, 3, '0', '0', 'player', '3', 'ADD ITEM', 'joint', 1, '', '2021-05-16 23:06:09'),
	(16, 3, '0', '0', 'player', '3', 'ADD ITEM', 'aluminium-oxide', 1, '', '2021-05-16 23:06:09'),
	(17, 3, '0', '0', 'player', '3', 'ADD ITEM', 'milk', 1, '', '2021-05-16 23:06:09'),
	(18, 3, '0', '0', 'player', '3', 'ADD ITEM', 'vodka', 1, '', '2021-05-16 23:06:09'),
	(19, 3, '0', '0', 'player', '3', 'ADD ITEM', 'beer', 1, '', '2021-05-16 23:06:22'),
	(20, 3, '0', '0', 'player', '3', 'ADD ITEM', 'joint', 1, '', '2021-05-16 23:06:22'),
	(21, 3, '0', '0', 'player', '3', 'ADD ITEM', 'aluminium-oxide', 1, '', '2021-05-16 23:06:22'),
	(22, 3, '0', '0', 'player', '3', 'ADD ITEM', 'milk', 1, '', '2021-05-16 23:06:22'),
	(23, 3, '0', '0', 'player', '3', 'ADD ITEM', 'vodka', 1, '', '2021-05-16 23:06:22'),
	(24, 3, '0', '0', 'player', '3', 'ADD ITEM', 'joint', 1, '', '2021-05-16 23:06:22'),
	(25, 3, '0', '0', 'player', '3', 'ADD ITEM', 'bandage', 1, '', '2021-05-16 23:16:20'),
	(26, 3, '0', '0', 'player', '3', 'ADD ITEM', 'bandage', 1, '', '2021-05-16 23:16:20'),
	(27, 3, '0', '0', 'player', '3', 'ADD ITEM', '2ct-gold-chain', 1, '', '2021-05-16 23:16:20'),
	(28, 3, '0', '0', 'player', '3', 'ADD ITEM', 'rolex-watch', 1, '', '2021-05-16 23:16:20'),
	(29, 3, '0', '0', 'player', '3', 'ADD ITEM', 'meth-baggy', 1, '', '2021-05-16 23:16:33'),
	(30, 3, '0', '0', 'player', '3', 'ADD ITEM', 'cigarette', 1, '', '2021-05-16 23:16:33'),
	(31, 3, '0', '0', 'player', '3', 'ADD ITEM', 'pixel-2-phone', 1, '', '2021-05-16 23:16:33'),
	(32, 3, '0', '0', 'player', '3', 'ADD ITEM', 'pistol-ammo', 1, '', '2021-05-16 23:16:33'),
	(33, 3, '0', '0', 'player', '3', 'ADD ITEM', 'high-quality-scale', 1, '', '2021-05-16 23:16:33'),
	(34, 3, '0', '0', 'player', '3', 'ADD ITEM', 'cigarette', 1, '', '2021-05-16 23:16:33'),
	(35, 3, '0', '0', 'player', '3', 'ADD ITEM', 'joint', 1, '', '2021-05-16 23:16:48'),
	(36, 3, '0', '0', 'player', '3', 'ADD ITEM', 'advanced-lockpick', 1, '', '2021-05-16 23:16:48'),
	(37, 3, '0', '0', 'player', '3', 'ADD ITEM', 'nokia-phone', 1, '', '2021-05-16 23:16:48'),
	(38, 3, '0', '0', 'player', '3', 'ADD ITEM', 'rolex-watch', 1, '', '2021-05-16 23:16:48'),
	(39, 3, '0', '0', 'player', '3', 'ADD ITEM', 'joint', 1, '', '2021-05-16 23:16:48'),
	(40, 3, '0', '0', 'player', '3', 'ADD ITEM', 'cigarette', 1, '', '2021-05-16 23:16:48'),
	(41, 3, '0', '0', 'player', '3', 'ADD ITEM', 'lockpick-set', 1, '', '2021-05-16 23:17:10'),
	(42, 3, '0', '0', 'player', '3', 'ADD ITEM', 'milk', 1, '', '2021-05-16 23:17:10'),
	(43, 3, '0', '0', 'player', '3', 'ADD ITEM', 'vodka', 1, '', '2021-05-16 23:17:10'),
	(44, 3, '0', '0', 'player', '3', 'ADD ITEM', 'joint', 1, '', '2021-05-16 23:17:10'),
	(45, 3, '0', '0', 'player', '3', 'ADD ITEM', 'advanced-lockpick', 1, '', '2021-05-16 23:17:10'),
	(46, 3, '0', '0', 'player', '3', 'ADD ITEM', 'nokia-phone', 1, '', '2021-05-16 23:17:10'),
	(47, 3, 'shop', '3/10', 'player', '3', 'SHOP PURCHASE', 'sandwich', 5, '100', '2021-05-16 23:18:14'),
	(48, 3, 'shop', '3/10', 'player', '3', 'MOVE', 'sandwich', 5, '', '2021-05-16 23:18:14'),
	(49, 3, '0', '0', 'player', '3', 'REMOVE ITEM', 'cash', 100, '', '2021-05-16 23:18:14'),
	(50, 3, 'player', '3', 'drop', '1', 'MOVE', 'sandwich', 5, '', '2021-05-18 15:15:36'),
	(51, 3, 'player', '3', 'drop', '1', 'MOVE', 'nokia-phone', 3, '', '2021-05-18 15:15:37'),
	(52, 3, 'player', '3', 'drop', '1', 'MOVE', 'cigarette', 5, '', '2021-05-18 15:15:39'),
	(53, 3, 'player', '3', 'drop', '1', 'MOVE', 'lockpick-set', 1, '', '2021-05-18 15:15:41'),
	(54, 3, 'player', '3', 'drop', '1', 'MOVE', 'aluminium-oxide', 2, '', '2021-05-18 15:15:41'),
	(55, 3, '0', '0', 'player', '3', 'ADD ITEM', 'water', 3, 'ADMIN', '2021-05-25 17:38:00'),
	(56, 3, 'player', '3', '0', '0', 'USE ITEM', 'water', 1, '', '2021-05-25 17:38:06'),
	(57, 3, 'player', '3', '0', '0', 'USE ITEM', 'water', 1, '', '2021-05-25 17:38:16');
/*!40000 ALTER TABLE `_inventory_log` ENABLE KEYS */;

-- Dumping structure for table sitt._licenses
CREATE TABLE IF NOT EXISTS `_licenses` (
  `citizen_id` int(11) NOT NULL,
  `license_id` int(11) NOT NULL,
  KEY `citizen_id` (`citizen_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt._licenses: ~0 rows (approximately)
/*!40000 ALTER TABLE `_licenses` DISABLE KEYS */;
/*!40000 ALTER TABLE `_licenses` ENABLE KEYS */;

-- Dumping structure for table sitt._mdt_bulletins
CREATE TABLE IF NOT EXISTS `_mdt_bulletins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` int(11) DEFAULT unix_timestamp(),
  `title` varchar(50) CHARACTER SET latin1 DEFAULT NULL,
  `description` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table sitt._mdt_bulletins: ~3 rows (approximately)
/*!40000 ALTER TABLE `_mdt_bulletins` DISABLE KEYS */;
INSERT INTO `_mdt_bulletins` (`id`, `timestamp`, `title`, `description`) VALUES
	(1, 1608832019, 'Tazers', 'inimeste autodest tazeriga vÃƒÂ¤lja laskmine = ban'),
	(2, 1608832069, 'Tazers', 'tazeriga autode rehvide laskmine = ban'),
	(3, 1620680608, 'MDT', 'tips and tricks kuidas normaalne roolpleier olla ');
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
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt._mdt_charges: ~19 rows (approximately)
/*!40000 ALTER TABLE `_mdt_charges` DISABLE KEYS */;
INSERT INTO `_mdt_charges` (`charge_id`, `citizen_id`, `charges`, `totalFine`, `totalJail`, `issued_by`, `date`) VALUES
	(47, 9, '["Brandishing of a Firearm","Reckless Endangerment","Kidnapping a Government Employee","2nd Degree Murder"]', 34188, 261, 3, 1621956647),
	(48, 9, '["Brandishing of a Firearm","Brandishing of a Firearm","Brandishing of a Firearm","Brandishing of a Firearm"]', 2100, 28, 3, 1621971722),
	(49, 9, '["Assault & Battery","Criminal Threats","Unlawful Imprisonment","Kidnapping"]', 4688, 38, 3, 1621971861),
	(50, 3, '["Brandishing of a Firearm","Reckless Endangerment","Criminal Threats","Manslaughter"]', 13650, 182, 3, 1621971939),
	(51, 3, '["Criminal Threats","Criminal Threats","Criminal Threats","Criminal Threats"]', 4200, 56, 3, 1621971962),
	(52, 3, '["Brandishing of a Firearm","Reckless Endangerment"]', 1485, 16, 3, 1622045575),
	(53, 3, '["Brandishing of a Firearm","Reckless Endangerment"]', 1350, 18, 3, 1622045628),
	(54, 3, '["Fraud","Extortion","Money Laundering","Bribery","Speeding 25-40 km/h","Speeding 60-100 km/h","Speeding 100+ km/h"]', 14070, 44, 3, 1622049991),
	(55, 3, '["Reckless Endangerment","Reckless Endangerment","Reckless Endangerment","Reckless Endangerment","Reckless Endangerment","Reckless Endangerment","Reckless Endangerment","Reckless Endangerment","Reckless Endangerment","Reckless Endangerment","Reckless Endangerment","Reckless Endangerment","Reckless Endangerment","Reckless Endangerment","Reckless Endangerment","Reckless Endangerment","Reckless Endangerment","Reckless Endangerment","Reckless Endangerment","Reckless Endangerment","Reckless Endangerment","Reckless Endangerment","Reckless Endangerment","Reckless Endangerment","Reckless Endangerment","Reckless Endangerment","Reckless Endangerment","Reckless Endangerment","Reckless Endangerment","Reckless Endangerment"]', 24750, 330, 3, 1622050021),
	(56, 3, '["Brandishing of a Firearm","Reckless Endangerment","Assault & Battery","Criminal Threats","Kidnapping a Government Employee","2nd Degree Murder","Gang Related Shooting","Murder of a Government Employee","Serial Assaults and Killings","Manslaughter","Attempted 1st Degree Murder","Assault with a Deadly Weapon","Attempted 2nd Degree Murder","Attempted Murder of a Government Employee","1st Degree Murder","Kidnapping","Unlawful Imprisonment","Negligent Driving","Speeding 25-40 km/h","Speeding 100+ km/h","Joyriding","Speeding 40-60 km/h","Vehicular Assault","Speeding 1-25 km/h","Speeding 60-100 km/h","Reckless Driving","Failure to Obey Traffic Control Devices","Unauthorized Parking","Improper Window Tint","Driving on the Wrong Side of the Road","Petty Theft","Burglary","First Degree Robbery","Grand Theft Auto","Sale of Stolen Goods","Receiving Stolen Goods","Robbery","Fraud","Bribery","Extortion","Money Laundering","Identity Theft","Disturbing the peace","Criminal Possession of a Taser","Disorderly Conduct","Criminal Possession of a Firearm","Resisting Arrest","Terrorism","Disobeying a Peace Officer","Obstruction of Justice","Harrassment","Animal Cruelty","Prostitution","Desecration of a Human Corpse","Public Indecency","Sale of Drugs","Possession of Controlled Dangerous Substances"]', 191935, 102784, 3, 1622054967),
	(57, 3, '["Brandishing of a Firearm","Assault & Battery","Criminal Threats","Assault with a Deadly Weapon","Attempted 1st Degree Murder","Attempted Murder of a Government Employee","1st Degree Murder"]', 54344, 437, 3, 1622055878),
	(58, 3, '["Murder of a Government Employee","Gang Related Shooting","Manslaughter","1st Degree Murder","Attempted Murder of a Government Employee","Attempted 1st Degree Murder","2nd Degree Murder","Kidnapping a Government Employee","Assault with a Deadly Weapon","Attempted 2nd Degree Murder","Kidnapping","Criminal Threats","Reckless Endangerment","Brandishing of a Firearm","Assault & Battery","Unlawful Imprisonment","Speeding 100+ km/h","Speeding 25-40 km/h","Negligent Driving","Joyriding","Speeding 40-60 km/h","Vehicular Assault","Reckless Driving","Speeding 60-100 km/h","Speeding 1-25 km/h","Driving on the Wrong Side of the Road","Improper Window Tint","Failure to Obey Traffic Control Devices","Unauthorized Parking","Petty Theft","Burglary","Sale of Stolen Goods","Grand Theft Auto","Receiving Stolen Goods","Robbery","First Degree Robbery","Bribery","Fraud","Extortion","Money Laundering","Identity Theft","Terrorism","Resisting Arrest","Disorderly Conduct","Criminal Possession of a Firearm","Criminal Possession of a Taser","Disturbing the peace","Obstruction of Justice","Disobeying a Peace Officer","Harrassment","Animal Cruelty","Sale of Drugs","Desecration of a Human Corpse","Prostitution","Public Indecency","Possession of Controlled Dangerous Substances"]', 287903, 1393, 3, 1622057653),
	(59, 3, '["Brandishing of a Firearm","Reckless Endangerment","Kidnapping a Government Employee","2nd Degree Murder","Gang Related Shooting","Murder of a Government Employee","Manslaughter","Attempted 1st Degree Murder","Assault with a Deadly Weapon","Criminal Threats","Assault & Battery","Unlawful Imprisonment","Kidnapping","Attempted 2nd Degree Murder","Attempted Murder of a Government Employee","1st Degree Murder","Speeding 100+ km/h","Vehicular Assault","Reckless Driving","Speeding 60-100 km/h","Speeding 40-60 km/h","Speeding 25-40 km/h","Negligent Driving","Joyriding","Speeding 1-25 km/h","Failure to Obey Traffic Control Devices","Unauthorized Parking","Improper Window Tint","Driving on the Wrong Side of the Road","Petty Theft","Burglary","First Degree Robbery","Sale of Stolen Goods","Grand Theft Auto","Receiving Stolen Goods","Robbery","Fraud","Bribery","Money Laundering","Extortion","Identity Theft","Resisting Arrest","Terrorism","Criminal Possession of a Firearm","Disorderly Conduct","Disturbing the peace","Criminal Possession of a Taser","Obstruction of Justice","Disobeying a Peace Officer","Harrassment","Animal Cruelty","Public Indecency","Sale of Drugs","Desecration of a Human Corpse","Prostitution","Possession of Controlled Dangerous Substances"]', 191935, 2785, 3, 1622057708),
	(60, 3, '["Brandishing of a Firearm","Reckless Endangerment","Kidnapping a Government Employee","2nd Degree Murder","Gang Related Shooting","Murder of a Government Employee","Manslaughter","Attempted 1st Degree Murder","Assault with a Deadly Weapon","Criminal Threats","Assault & Battery","Unlawful Imprisonment","Kidnapping","Attempted 2nd Degree Murder","Attempted Murder of a Government Employee","1st Degree Murder","Negligent Driving","Speeding 25-40 km/h","Speeding 100+ km/h","Vehicular Assault","Speeding 40-60 km/h","Joyriding","Speeding 1-25 km/h","Speeding 60-100 km/h","Reckless Driving","Driving on the Wrong Side of the Road","Improper Window Tint","Failure to Obey Traffic Control Devices","Unauthorized Parking","Petty Theft","Burglary","Sale of Stolen Goods","Grand Theft Auto","Receiving Stolen Goods","Robbery","First Degree Robbery","Fraud","Bribery","Money Laundering","Extortion","Identity Theft","Resisting Arrest","Terrorism","Criminal Possession of a Firearm","Disorderly Conduct","Disturbing the peace","Criminal Possession of a Taser","Disobeying a Peace Officer","Obstruction of Justice","Harrassment","Animal Cruelty","Prostitution","Desecration of a Human Corpse","Sale of Drugs","Public Indecency","Possession of Controlled Dangerous Substances"]', 287903, 1393, 3, 1622057756),
	(61, 3, '["Brandishing of a Firearm","Reckless Endangerment"]', 1485, 16, 3, 1624760882),
	(62, 3, '["Brandishing of a Firearm"]', 525, 7, 3, 1625093162),
	(63, 3, '["Assault with a Deadly Weapon"]', 1575, 21, 3, 1625093329),
	(64, 3, '["Brandishing of a Firearm","Reckless Endangerment"]', 1350, 18, 3, 1625093742),
	(65, 3, '["Prostitution"]', 525, 2, 3, 1625095114),
	(66, 3, '["Speeding 1-25 km/h","Assault & Battery"]', 965, 11, 3, 1632772018);
/*!40000 ALTER TABLE `_mdt_charges` ENABLE KEYS */;

-- Dumping structure for table sitt._mdt_profile_data
CREATE TABLE IF NOT EXISTS `_mdt_profile_data` (
  `citizen_id` int(11) NOT NULL,
  `description` varchar(2550) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `profile_image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`citizen_id`),
  CONSTRAINT `character_gone3` FOREIGN KEY (`citizen_id`) REFERENCES `characters` (`cid`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt._mdt_profile_data: ~0 rows (approximately)
/*!40000 ALTER TABLE `_mdt_profile_data` DISABLE KEYS */;
INSERT INTO `_mdt_profile_data` (`citizen_id`, `description`, `profile_image_url`, `updated_by`) VALUES
	(3, '<p>gang member</p><p>vagos</p><h1><strong>swrghyrswhgysrghysgrhf<em>jdhghdsfhfdsas asffsfas</em></strong></h1><p>aegtagedgad</p><p><br></p><p><br></p>', '', 3),
	(9, '<p>woow real obama? :O</p>', 'https://i.imgur.com/D1SFtD9.png', 3);
/*!40000 ALTER TABLE `_mdt_profile_data` ENABLE KEYS */;

-- Dumping structure for table sitt._mdt_warrants
CREATE TABLE IF NOT EXISTS `_mdt_warrants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizen_id` int(11) NOT NULL,
  `reason` varchar(500) DEFAULT NULL,
  `last_update` int(11) DEFAULT unix_timestamp(),
  `enabled` int(11) DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `character_gone` (`citizen_id`),
  CONSTRAINT `character_gone` FOREIGN KEY (`citizen_id`) REFERENCES `characters` (`cid`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table sitt._mdt_warrants: ~3 rows (approximately)
/*!40000 ALTER TABLE `_mdt_warrants` DISABLE KEYS */;
INSERT INTO `_mdt_warrants` (`id`, `citizen_id`, `reason`, `last_update`, `enabled`) VALUES
	(33, 3, 'trolololololool', 1621970467, 0),
	(34, 9, 'OKOK', 1632771828, 0),
	(35, 3, 'fgxnhdgffdtgjhjhrtdfg', 1632771933, 0),
	(36, 9, 'sadfdafswdagt', 1633193077, 0);
/*!40000 ALTER TABLE `_mdt_warrants` ENABLE KEYS */;

-- Dumping structure for table sitt._sql_error_logs
CREATE TABLE IF NOT EXISTS `_sql_error_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT current_timestamp(),
  `query` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `data` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `error` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table sitt._sql_error_logs: ~0 rows (approximately)
/*!40000 ALTER TABLE `_sql_error_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `_sql_error_logs` ENABLE KEYS */;

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
INSERT INTO `_weapon_ammo` (`citizen_id`, `hash`, `ammo`) VALUES
	(3, 1950175060, 14);
/*!40000 ALTER TABLE `_weapon_ammo` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
