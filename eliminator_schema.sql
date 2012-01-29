# ************************************************************
# Sequel Pro SQL dump
# Version 3408
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: localhost (MySQL 5.5.18)
# Database: eliminator
# Generation Time: 2012-01-29 23:28:42 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table bet_sets
# ------------------------------------------------------------

DROP TABLE IF EXISTS `bet_sets`;

CREATE TABLE `bet_sets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned DEFAULT NULL,
  `group_id` int(11) unsigned DEFAULT NULL,
  `survival_pickem` tinyint(1) NOT NULL,
  `headsup_ats` tinyint(1) NOT NULL,
  `regular_reverse` tinyint(1) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table bets
# ------------------------------------------------------------

DROP TABLE IF EXISTS `bets`;

CREATE TABLE `bets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `season` smallint(6) DEFAULT NULL,
  `week_number` tinyint(4) DEFAULT NULL,
  `week_type` varchar(255) DEFAULT NULL,
  `game_id` varchar(255) DEFAULT NULL,
  `team_id` tinyint(4) DEFAULT NULL,
  `spread_id` int(11) DEFAULT NULL,
  `bet_set_id` int(11) DEFAULT NULL,
  `survival_pickem` tinyint(1) NOT NULL,
  `headsup_ats` tinyint(1) NOT NULL,
  `regular_reverse` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `game_id` (`game_id`),
  KEY `user_id` (`user_id`),
  KEY `season` (`season`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table game_results
# ------------------------------------------------------------

DROP TABLE IF EXISTS `game_results`;

CREATE TABLE `game_results` (
  `game_id` varchar(255) NOT NULL DEFAULT '',
  `home_score` tinyint(4) unsigned DEFAULT NULL,
  `away_score` tinyint(4) unsigned DEFAULT NULL,
  `game_clock` varchar(255) DEFAULT NULL,
  `quarter` tinyint(4) DEFAULT NULL,
  `status` enum('NOT_STARTED','IN_PROGRESS','HALFTIME','FINAL') DEFAULT NULL,
  `possession` tinyint(1) DEFAULT NULL,
  `in_red_zone` tinyint(1) DEFAULT NULL,
  `winning_team_id` tinyint(4) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  KEY `game_id` (`game_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table game_stats
# ------------------------------------------------------------

DROP TABLE IF EXISTS `game_stats`;

CREATE TABLE `game_stats` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` varchar(255) DEFAULT NULL,
  `team_id` tinyint(4) DEFAULT NULL,
  `turnovers` smallint(4) DEFAULT NULL,
  `rushing_yards` smallint(6) DEFAULT NULL,
  `rushing_attempts` smallint(6) DEFAULT NULL,
  `passing_yards` smallint(6) DEFAULT NULL,
  `passing_attempts` smallint(6) DEFAULT NULL,
  `passing_completions` smallint(6) DEFAULT NULL,
  `sacks` tinyint(4) DEFAULT NULL,
  `sack_yards_lost` mediumint(9) DEFAULT NULL,
  `interceptions_thrown` smallint(6) DEFAULT NULL,
  `interception_return_yards` smallint(6) DEFAULT NULL,
  `rushing_1st_downs` smallint(6) DEFAULT NULL,
  `passing_1st_downs` smallint(6) DEFAULT NULL,
  `penalty_1st_downs` smallint(6) DEFAULT NULL,
  `third_down_attempts` smallint(6) DEFAULT NULL,
  `third_down_conversions` smallint(6) DEFAULT NULL,
  `fourth_down_attempts` smallint(6) DEFAULT NULL,
  `fourth_down_conversions` smallint(6) DEFAULT NULL,
  `punts` smallint(6) DEFAULT NULL,
  `punt_average_distance` float DEFAULT NULL,
  `punt_returns` smallint(6) DEFAULT NULL,
  `kickoffs` smallint(6) DEFAULT NULL,
  `kickoff_returns` smallint(6) DEFAULT NULL,
  `penalties` smallint(6) DEFAULT NULL,
  `penalty_yards` smallint(6) DEFAULT NULL,
  `fumbles` smallint(6) DEFAULT NULL,
  `fumbles_lost` smallint(6) DEFAULT NULL,
  `time_of_possession` smallint(6) DEFAULT NULL,
  `rushing_tds` smallint(6) DEFAULT NULL,
  `passing_tds` smallint(6) DEFAULT NULL,
  `other_tds` smallint(6) DEFAULT NULL,
  `xp_attempts` smallint(6) DEFAULT NULL,
  `xp_conversions` smallint(6) DEFAULT NULL,
  `fg_attempts` smallint(6) DEFAULT NULL,
  `fg_conversions` smallint(6) DEFAULT NULL,
  `goal_to_go_attempts` smallint(6) DEFAULT NULL,
  `goal_to_go_successes` smallint(6) DEFAULT NULL,
  `red_zone_attempts` smallint(6) DEFAULT NULL,
  `red_zone_successes` smallint(6) DEFAULT NULL,
  `safeties` tinyint(4) DEFAULT NULL,
  `total_drives` smallint(6) DEFAULT NULL,
  `average_drive_start` smallint(6) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `game_id` (`game_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table group_features
# ------------------------------------------------------------

DROP TABLE IF EXISTS `group_features`;

CREATE TABLE `group_features` (
  `group_id` int(11) unsigned DEFAULT NULL,
  `feature_name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table group_members
# ------------------------------------------------------------

DROP TABLE IF EXISTS `group_members`;

CREATE TABLE `group_members` (
  `group_id` int(11) unsigned DEFAULT NULL,
  `user_id` int(11) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table groups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `groups`;

CREATE TABLE `groups` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `owner_id` int(11) unsigned DEFAULT NULL,
  `public` tinyint(1) NOT NULL,
  `visible` tinyint(1) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `pickem_allowed` tinyint(1) DEFAULT NULL,
  `survival_allowed` tinyint(1) DEFAULT NULL,
  `headsup_allowed` tinyint(1) DEFAULT NULL,
  `ats_allowed` tinyint(1) DEFAULT NULL,
  `regular_allowed` tinyint(1) DEFAULT NULL,
  `reverse_allowed` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table over_under
# ------------------------------------------------------------

DROP TABLE IF EXISTS `over_under`;

CREATE TABLE `over_under` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` varchar(255) DEFAULT NULL,
  `over_under` tinyint(4) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table power_ranking_algorithms
# ------------------------------------------------------------

DROP TABLE IF EXISTS `power_ranking_algorithms`;

CREATE TABLE `power_ranking_algorithms` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned DEFAULT NULL,
  `algorithm` text,
  `name` varchar(255) DEFAULT NULL,
  `public` tinyint(1) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table schedule
# ------------------------------------------------------------

DROP TABLE IF EXISTS `schedule`;

CREATE TABLE `schedule` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` varchar(255) DEFAULT NULL,
  `season` smallint(6) DEFAULT NULL,
  `week_number` tinyint(4) DEFAULT NULL,
  `week_type` varchar(255) DEFAULT NULL,
  `home_team_id` tinyint(4) DEFAULT NULL,
  `away_team_id` tinyint(4) DEFAULT NULL,
  `game_time` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table spread
# ------------------------------------------------------------

DROP TABLE IF EXISTS `spread`;

CREATE TABLE `spread` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` varchar(255) DEFAULT NULL,
  `spread` float DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table teams
# ------------------------------------------------------------

DROP TABLE IF EXISTS `teams`;

CREATE TABLE `teams` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `short_name` varchar(3) DEFAULT NULL,
  `stadium_name` varchar(255) DEFAULT NULL,
  `stadium_capacity` int(11) DEFAULT NULL,
  `conference` varchar(255) NOT NULL DEFAULT '',
  `division` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table user_info
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user_info`;

CREATE TABLE `user_info` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned NOT NULL,
  `token` varchar(255) DEFAULT NULL,
  `time_zone` varchar(255) DEFAULT NULL,
  `email_reminder` tinyint(1) NOT NULL,
  `favorite_team_id` tinyint(4) DEFAULT NULL,
  `hated_team_id` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `old_password` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `active` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
