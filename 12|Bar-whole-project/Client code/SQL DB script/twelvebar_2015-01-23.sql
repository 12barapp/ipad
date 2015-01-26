# ************************************************************
# Sequel Pro SQL dump
# Version 4135
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: 192.169.197.8 (MySQL 5.5.37-MariaDB)
# Database: twelvebar
# Generation Time: 2015-01-23 15:56:15 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table chord_owner
# ------------------------------------------------------------

CREATE TABLE `chord_owner` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `chord_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `share_status` int(11) NOT NULL DEFAULT '0' COMMENT 'ENUM: 0 - start value; 1 - accepted; 2 - declined',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table chords
# ------------------------------------------------------------

CREATE TABLE `chords` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_updated_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `data` text,
  `chord_id` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table chords_inside_sets
# ------------------------------------------------------------

CREATE TABLE `chords_inside_sets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `set_id` int(11) DEFAULT NULL,
  `chord_id` int(11) DEFAULT NULL,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table set_owner
# ------------------------------------------------------------

CREATE TABLE `set_owner` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `set_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `share_status` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table sets
# ------------------------------------------------------------

CREATE TABLE `sets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `cTitle` text,
  `data` text,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_updated_time` timestamp NULL DEFAULT NULL,
  `set_id` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table vf_users
# ------------------------------------------------------------

CREATE TABLE `vf_users` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_login` varchar(60) NOT NULL DEFAULT '',
  `user_pass` varchar(64) NOT NULL DEFAULT '',
  `user_nicename` varchar(50) NOT NULL DEFAULT '',
  `user_email` varchar(100) NOT NULL DEFAULT '',
  `user_url` varchar(100) NOT NULL DEFAULT '',
  `user_registered` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `user_activation_key` varchar(60) NOT NULL DEFAULT '',
  `user_status` int(11) NOT NULL DEFAULT '0',
  `display_name` varchar(250) NOT NULL DEFAULT '',
  `facebook_ID` text NOT NULL,
  `data` text NOT NULL,
  `last_update_date` int(11) NOT NULL,
  `secret_key` int(11) DEFAULT NULL,
  `facebook_ID1` text NOT NULL,
  `devices` text NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `user_login_key` (`user_login`),
  KEY `user_nicename` (`user_nicename`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
