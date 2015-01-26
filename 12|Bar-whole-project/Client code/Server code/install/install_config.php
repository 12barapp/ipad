<?php

define ('CHORDS_TABLE', "CREATE TABLE `chords` (`id` int(11) unsigned NOT NULL AUTO_INCREMENT,`created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,`last_updated_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',`data` text,`chord_id` text,PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=latin1;");
define ('SETS_TABLE', "CREATE TABLE `sets` (`id` int(11) unsigned NOT NULL AUTO_INCREMENT,`cTitle` text,`data` text,`created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,`last_updated_time` timestamp NULL DEFAULT NULL,`set_id` text,PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=latin1;");
define ('CHORDS_OWNER', "CREATE TABLE `chord_owner` (`id` int(11) unsigned NOT NULL AUTO_INCREMENT,`chord_id` int(11) DEFAULT NULL,`user_id` int(11) DEFAULT NULL,`created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,`share_status` int(11) NOT NULL DEFAULT '0' COMMENT 'ENUM: 0 - start value; 1 - accepted; 2 - declined',PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=latin1;");
define('CHORDS_INSIDE_SETS', "CREATE TABLE `chords_inside_sets` (`id` int(11) unsigned NOT NULL AUTO_INCREMENT,`set_id` int(11) DEFAULT NULL,`chord_id` int(11) DEFAULT NULL,`created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=latin1;");
define('SETS_OWNER', "CREATE TABLE `set_owner` (`id` int(11) unsigned NOT NULL AUTO_INCREMENT,`set_id` int(11) DEFAULT NULL,`user_id` int(11) DEFAULT NULL,`created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,`share_status` int(11) NOT NULL DEFAULT '0',PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=latin1;");

