# ************************************************************
# Sequel Pro SQL dump
# Version 3408
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: localhost (MySQL 5.5.18)
# Database: eliminator
# Generation Time: 2012-02-07 00:29:46 +0000
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



# Dump of table full_records
# ------------------------------------------------------------

DROP TABLE IF EXISTS `full_records`;

CREATE TABLE `full_records` (
  `team_id` tinyint(4) NOT NULL DEFAULT '0',
  `season` smallint(6) NOT NULL DEFAULT '0',
  `won` smallint(6) DEFAULT NULL,
  `lost` smallint(6) DEFAULT NULL,
  `tied` smallint(6) DEFAULT NULL,
  `home_won` smallint(6) DEFAULT NULL,
  `home_lost` smallint(6) DEFAULT NULL,
  `home_tied` smallint(6) DEFAULT NULL,
  `away_won` smallint(6) DEFAULT NULL,
  `away_lost` smallint(6) DEFAULT NULL,
  `away_tied` smallint(6) DEFAULT NULL,
  `conference_won` smallint(6) DEFAULT NULL,
  `conference_lost` smallint(6) DEFAULT NULL,
  `conference_tied` smallint(6) DEFAULT NULL,
  `nonconference_won` smallint(6) DEFAULT NULL,
  `nonconference_lost` smallint(6) DEFAULT NULL,
  `nonconference_tied` smallint(6) DEFAULT NULL,
  `nfc_north_won` smallint(6) DEFAULT NULL,
  `nfc_north_lost` smallint(6) DEFAULT NULL,
  `nfc_north_tied` smallint(6) DEFAULT NULL,
  `nfc_south_won` smallint(6) DEFAULT NULL,
  `nfc_south_lost` smallint(6) DEFAULT NULL,
  `nfc_south_tied` smallint(6) DEFAULT NULL,
  `nfc_east_won` smallint(6) DEFAULT NULL,
  `nfc_east_lost` smallint(6) DEFAULT NULL,
  `nfc_east_tied` smallint(6) DEFAULT NULL,
  `nfc_west_won` smallint(6) DEFAULT NULL,
  `nfc_west_lost` smallint(6) DEFAULT NULL,
  `nfc_west_tied` smallint(6) DEFAULT NULL,
  `afc_north_won` smallint(6) DEFAULT NULL,
  `afc_north_lost` smallint(6) DEFAULT NULL,
  `afc_north_tied` smallint(6) DEFAULT NULL,
  `afc_south_won` smallint(6) DEFAULT NULL,
  `afc_south_lost` smallint(6) DEFAULT NULL,
  `afc_south_tied` smallint(6) DEFAULT NULL,
  `afc_east_won` smallint(6) DEFAULT NULL,
  `afc_east_lost` smallint(6) DEFAULT NULL,
  `afc_east_tied` smallint(6) DEFAULT NULL,
  `afc_west_won` smallint(6) DEFAULT NULL,
  `afc_west_lost` smallint(6) DEFAULT NULL,
  `afc_west_tied` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`team_id`,`season`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table game_results
# ------------------------------------------------------------

DROP TABLE IF EXISTS `game_results`;

CREATE TABLE `game_results` (
  `game_id` varchar(255) NOT NULL DEFAULT '',
  `home_score` smallint(4) DEFAULT NULL,
  `away_score` smallint(4) DEFAULT NULL,
  `game_clock` varchar(255) DEFAULT NULL,
  `quarter` tinyint(4) DEFAULT NULL,
  `status` enum('NOT_STARTED','IN_PROGRESS','HALFTIME','FINAL') DEFAULT NULL,
  `possession` tinyint(1) DEFAULT NULL,
  `in_red_zone` tinyint(1) DEFAULT NULL,
  `winning_team_id` tinyint(4) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  KEY `game_id` (`game_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DELIMITER ;;
/*!50003 SET SESSION SQL_MODE="" */;;
/*!50003 CREATE */ /*!50003 TRIGGER `on_insert_update_full_records` AFTER INSERT ON `game_results` FOR EACH ROW begin if NEW.status ='FINAL' then call generate_full_records(); end if; end */;;
/*!50003 SET SESSION SQL_MODE="" */;;
/*!50003 CREATE */ /*!50003 TRIGGER `on_update_update_full_records` AFTER UPDATE ON `game_results` FOR EACH ROW begin if NEW.status ='FINAL' then call generate_full_records(); end if; end */;;
/*!50003 SET SESSION SQL_MODE="" */;;
/*!50003 CREATE */ /*!50003 TRIGGER `on_delete_update_full_records` AFTER DELETE ON `game_results` FOR EACH ROW call generate_full_records() */;;
DELIMITER ;
/*!50003 SET SESSION SQL_MODE=@OLD_SQL_MODE */;


# Dump of table game_stats
# ------------------------------------------------------------

DROP TABLE IF EXISTS `game_stats`;

CREATE TABLE `game_stats` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` varchar(255) DEFAULT NULL,
  `team_id` tinyint(4) DEFAULT NULL,
  `points` smallint(6) DEFAULT NULL,
  `turnovers` smallint(4) DEFAULT NULL,
  `rushing_yards` smallint(6) DEFAULT NULL,
  `rushing_attempts` smallint(6) DEFAULT NULL,
  `passing_yards` smallint(6) DEFAULT NULL,
  `passing_attempts` smallint(6) DEFAULT NULL,
  `passing_completions` smallint(6) DEFAULT NULL,
  `sacks` tinyint(4) DEFAULT NULL,
  `sack_yards_lost` mediumint(9) unsigned zerofill DEFAULT NULL,
  `interceptions_thrown` smallint(6) DEFAULT NULL,
  `interception_return_yards` smallint(6) DEFAULT NULL,
  `interception_returns` smallint(6) DEFAULT NULL,
  `rushing_1st_downs` smallint(6) DEFAULT NULL,
  `passing_1st_downs` smallint(6) DEFAULT NULL,
  `penalty_1st_downs` smallint(6) DEFAULT NULL,
  `third_down_attempts` smallint(6) DEFAULT NULL,
  `third_down_conversions` smallint(6) DEFAULT NULL,
  `fourth_down_attempts` smallint(6) DEFAULT NULL,
  `fourth_down_conversions` smallint(6) DEFAULT NULL,
  `punts` smallint(6) DEFAULT NULL,
  `punts_blocked` tinyint(4) DEFAULT NULL,
  `punt_average_distance` float DEFAULT NULL,
  `punt_net_average` float DEFAULT NULL,
  `punt_returns` smallint(6) DEFAULT NULL,
  `punt_return_yards` smallint(6) DEFAULT NULL,
  `kickoffs` smallint(6) DEFAULT NULL,
  `kickoffs_in_endzone` smallint(6) DEFAULT NULL,
  `kickoffs_touchback` smallint(6) DEFAULT NULL,
  `kickoff_returns` smallint(6) DEFAULT NULL,
  `kickoff_return_yards` smallint(6) DEFAULT NULL,
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
  `xp_blocked` smallint(6) DEFAULT NULL,
  `fg_attempts` smallint(6) DEFAULT NULL,
  `fg_conversions` smallint(6) DEFAULT NULL,
  `fg_blocked` smallint(6) DEFAULT NULL,
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
  KEY `game_id` (`game_id`),
  KEY `team_id` (`team_id`)
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
  `group_id` int(11) unsigned NOT NULL DEFAULT '0',
  `user_id` int(11) unsigned NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table groups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `groups`;

CREATE TABLE `groups` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
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
  PRIMARY KEY (`id`),
  KEY `game_id` (`game_id`)
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
  `passwd` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `active` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table v_bet_records
# ------------------------------------------------------------

DROP VIEW IF EXISTS `v_bet_records`;

CREATE TABLE `v_bet_records` (
   `user_id` INT(11) DEFAULT NULL,
   `season` SMALLINT(6) DEFAULT NULL,
   `s_h_reg_won` DECIMAL(32) DEFAULT NULL,
   `s_h_reg_lost` DECIMAL(32) DEFAULT NULL,
   `s_h_rev_won` DECIMAL(32) DEFAULT NULL,
   `s_h_rev_lost` DECIMAL(32) DEFAULT NULL,
   `p_h_reg_won` DECIMAL(32) DEFAULT NULL,
   `p_h_reg_lost` DECIMAL(32) DEFAULT NULL,
   `p_h_rev_won` DECIMAL(32) DEFAULT NULL,
   `p_h_rev_lost` DECIMAL(32) DEFAULT NULL,
   `s_a_reg_won` DECIMAL(32) DEFAULT NULL,
   `s_a_reg_lost` DECIMAL(32) DEFAULT NULL,
   `s_a_reg_push` DECIMAL(32) DEFAULT NULL,
   `s_a_rev_won` DECIMAL(32) DEFAULT NULL,
   `s_a_rev_lost` DECIMAL(32) DEFAULT NULL,
   `s_a_rev_push` DECIMAL(32) DEFAULT NULL,
   `p_a_reg_won` DECIMAL(32) DEFAULT NULL,
   `p_a_reg_lost` DECIMAL(32) DEFAULT NULL,
   `p_a_reg_push` DECIMAL(32) DEFAULT NULL,
   `p_a_rev_won` DECIMAL(32) DEFAULT NULL,
   `p_a_rev_lost` DECIMAL(32) DEFAULT NULL,
   `p_a_rev_push` DECIMAL(32) DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table v_bet_records_unsummed
# ------------------------------------------------------------

DROP VIEW IF EXISTS `v_bet_records_unsummed`;

CREATE TABLE `v_bet_records_unsummed` (
   `user_id` INT(11) DEFAULT NULL,
   `season` SMALLINT(6) DEFAULT NULL,
   `week_number` TINYINT(4) DEFAULT NULL,
   `week_type` VARCHAR(255) DEFAULT NULL,
   `game_id` VARCHAR(255) DEFAULT NULL,
   `team_id` TINYINT(4) DEFAULT NULL,
   `s_h_reg_won` INT(0) DEFAULT NULL,
   `s_h_reg_lost` INT(0) DEFAULT NULL,
   `s_h_rev_won` INT(0) DEFAULT NULL,
   `s_h_rev_lost` INT(0) DEFAULT NULL,
   `p_h_reg_won` INT(0) DEFAULT NULL,
   `p_h_reg_lost` INT(0) DEFAULT NULL,
   `p_h_rev_won` INT(0) DEFAULT NULL,
   `p_h_rev_lost` INT(0) DEFAULT NULL,
   `s_a_reg_won` INT(0) DEFAULT NULL,
   `s_a_reg_lost` INT(0) DEFAULT NULL,
   `s_a_reg_push` INT(0) DEFAULT NULL,
   `s_a_rev_won` INT(0) DEFAULT NULL,
   `s_a_rev_lost` INT(0) DEFAULT NULL,
   `s_a_rev_push` INT(0) DEFAULT NULL,
   `p_a_reg_won` INT(0) DEFAULT NULL,
   `p_a_reg_lost` INT(0) DEFAULT NULL,
   `p_a_reg_push` INT(0) DEFAULT NULL,
   `p_a_rev_won` INT(0) DEFAULT NULL,
   `p_a_rev_lost` INT(0) DEFAULT NULL,
   `p_a_rev_push` INT(0) DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table v_bets_with_users_teams_results
# ------------------------------------------------------------

DROP VIEW IF EXISTS `v_bets_with_users_teams_results`;

CREATE TABLE `v_bets_with_users_teams_results` (
   `id` INT(11) UNSIGNED NOT NULL DEFAULT '0',
   `created_at` DATETIME DEFAULT NULL,
   `updated_at` DATETIME DEFAULT NULL,
   `user_id` INT(11) DEFAULT NULL,
   `season` SMALLINT(6) DEFAULT NULL,
   `week_number` TINYINT(4) DEFAULT NULL,
   `week_type` VARCHAR(255) DEFAULT NULL,
   `game_id` VARCHAR(255) DEFAULT NULL,
   `team_id` TINYINT(4) DEFAULT NULL,
   `spread_id` INT(11) DEFAULT NULL,
   `bet_set_id` INT(11) DEFAULT NULL,
   `survival_pickem` TINYINT(1) NOT NULL,
   `headsup_ats` TINYINT(1) NOT NULL,
   `regular_reverse` TINYINT(1) NOT NULL,
   `username` VARCHAR(255) DEFAULT NULL,
   `team_name` VARCHAR(255) DEFAULT NULL,
   `short_name` VARCHAR(3) DEFAULT NULL,
   `status` ENUM('NOT_STARTED','IN_PROGRESS','HALFTIME','FINAL') DEFAULT NULL,
   `winning_team_id` TINYINT(4) DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table v_opponent_statistics
# ------------------------------------------------------------

DROP VIEW IF EXISTS `v_opponent_statistics`;

CREATE TABLE `v_opponent_statistics` (
   `team_id` TINYINT(4) DEFAULT NULL,
   `season` SMALLINT(6) DEFAULT NULL,
   `total_points` DECIMAL(27) DEFAULT NULL,
   `avg_points` DECIMAL(9) DEFAULT NULL,
   `total_turnovers` DECIMAL(27) DEFAULT NULL,
   `avg_turnovers` DECIMAL(9) DEFAULT NULL,
   `total_rushing_yards` DECIMAL(27) DEFAULT NULL,
   `avg_rushing_yards` DECIMAL(9) DEFAULT NULL,
   `total_passing_yards` DECIMAL(27) DEFAULT NULL,
   `avg_passing_yards` DECIMAL(9) DEFAULT NULL,
   `total_passing_completions` DECIMAL(27) DEFAULT NULL,
   `avg_passing_completions` DECIMAL(9) DEFAULT NULL,
   `total_sacks` DECIMAL(25) DEFAULT NULL,
   `avg_sacks` DECIMAL(7) DEFAULT NULL,
   `total_sack_yards_lost` DECIMAL(31) DEFAULT NULL,
   `avg_sack_yards_lost` DECIMAL(13) DEFAULT NULL,
   `total_interceptions_thrown` DECIMAL(27) DEFAULT NULL,
   `avg_interceptions_thrown` DECIMAL(9) DEFAULT NULL,
   `total_interception_return_yards` DECIMAL(27) DEFAULT NULL,
   `avg_interception_return_yards` DECIMAL(9) DEFAULT NULL,
   `total_interception_returns` DECIMAL(27) DEFAULT NULL,
   `avg_interception_returns` DECIMAL(9) DEFAULT NULL,
   `total_rushing_1st_downs` DECIMAL(27) DEFAULT NULL,
   `avg_rushing_1st_downs` DECIMAL(9) DEFAULT NULL,
   `total_passing_1st_downs` DECIMAL(27) DEFAULT NULL,
   `avg_passing_1st_downs` DECIMAL(9) DEFAULT NULL,
   `total_penalty_1st_downs` DECIMAL(27) DEFAULT NULL,
   `avg_penalty_1st_downs` DECIMAL(9) DEFAULT NULL,
   `total_third_down_attempts` DECIMAL(27) DEFAULT NULL,
   `avg_third_down_attempts` DECIMAL(9) DEFAULT NULL,
   `total_third_down_conversions` DECIMAL(27) DEFAULT NULL,
   `avg_third_down_conversions` DECIMAL(9) DEFAULT NULL,
   `total_fourth_down_attempts` DECIMAL(27) DEFAULT NULL,
   `avg_fourth_down_attempts` DECIMAL(9) DEFAULT NULL,
   `total_fourth_down_conversions` DECIMAL(27) DEFAULT NULL,
   `avg_fourth_down_conversions` DECIMAL(9) DEFAULT NULL,
   `total_punts` DECIMAL(27) DEFAULT NULL,
   `avg_punts` DECIMAL(9) DEFAULT NULL,
   `total_punts_blocked` DECIMAL(25) DEFAULT NULL,
   `avg_punts_blocked` DECIMAL(7) DEFAULT NULL,
   `total_punt_average_distance` DOUBLE DEFAULT NULL,
   `avg_punt_average_distance` DOUBLE DEFAULT NULL,
   `total_punt_net_average` DOUBLE DEFAULT NULL,
   `avg_punt_net_average` DOUBLE DEFAULT NULL,
   `total_punt_returns` DECIMAL(27) DEFAULT NULL,
   `avg_punt_returns` DECIMAL(9) DEFAULT NULL,
   `total_punt_return_yards` DECIMAL(27) DEFAULT NULL,
   `avg_punt_return_yards` DECIMAL(9) DEFAULT NULL,
   `total_kickoffs` DECIMAL(27) DEFAULT NULL,
   `avg_kickoffs` DECIMAL(9) DEFAULT NULL,
   `total_kickoffs_in_endzone` DECIMAL(27) DEFAULT NULL,
   `avg_kickoffs_in_endzone` DECIMAL(9) DEFAULT NULL,
   `total_kickoffs_touchback` DECIMAL(27) DEFAULT NULL,
   `avg_kickoffs_touchback` DECIMAL(9) DEFAULT NULL,
   `total_kickoff_returns` DECIMAL(27) DEFAULT NULL,
   `avg_kickoff_returns` DECIMAL(9) DEFAULT NULL,
   `total_kickoff_return_yards` DECIMAL(27) DEFAULT NULL,
   `avg_kickoff_return_yards` DECIMAL(9) DEFAULT NULL,
   `total_penalties` DECIMAL(27) DEFAULT NULL,
   `avg_penalties` DECIMAL(9) DEFAULT NULL,
   `total_penalty_yards` DECIMAL(27) DEFAULT NULL,
   `avg_penalty_yards` DECIMAL(9) DEFAULT NULL,
   `total_fumbles` DECIMAL(27) DEFAULT NULL,
   `avg_fumbles` DECIMAL(9) DEFAULT NULL,
   `total_fumbles_lost` DECIMAL(27) DEFAULT NULL,
   `avg_fumbles_lost` DECIMAL(9) DEFAULT NULL,
   `total_time_of_possession` DECIMAL(27) DEFAULT NULL,
   `avg_time_of_possession` DECIMAL(9) DEFAULT NULL,
   `total_rushing_tds` DECIMAL(27) DEFAULT NULL,
   `avg_rushing_tds` DECIMAL(9) DEFAULT NULL,
   `total_passing_tds` DECIMAL(27) DEFAULT NULL,
   `avg_passing_tds` DECIMAL(9) DEFAULT NULL,
   `total_other_tds` DECIMAL(27) DEFAULT NULL,
   `avg_other_tds` DECIMAL(9) DEFAULT NULL,
   `total_xp_attempts` DECIMAL(27) DEFAULT NULL,
   `avg_xp_attempts` DECIMAL(9) DEFAULT NULL,
   `total_xp_conversions` DECIMAL(27) DEFAULT NULL,
   `avg_xp_conversions` DECIMAL(9) DEFAULT NULL,
   `total_xp_blocked` DECIMAL(27) DEFAULT NULL,
   `avg_xp_blocked` DECIMAL(9) DEFAULT NULL,
   `total_fg_attempts` DECIMAL(27) DEFAULT NULL,
   `avg_fg_attempts` DECIMAL(9) DEFAULT NULL,
   `total_fg_conversions` DECIMAL(27) DEFAULT NULL,
   `avg_fg_conversions` DECIMAL(9) DEFAULT NULL,
   `total_fg_blocked` DECIMAL(27) DEFAULT NULL,
   `avg_fg_blocked` DECIMAL(9) DEFAULT NULL,
   `total_goal_to_go_attempts` DECIMAL(27) DEFAULT NULL,
   `avg_goal_to_go_attempts` DECIMAL(9) DEFAULT NULL,
   `total_goal_to_go_successes` DECIMAL(27) DEFAULT NULL,
   `avg_goal_to_go_successes` DECIMAL(9) DEFAULT NULL,
   `total_red_zone_attempts` DECIMAL(27) DEFAULT NULL,
   `avg_red_zone_attempts` DECIMAL(9) DEFAULT NULL,
   `total_red_zone_successes` DECIMAL(27) DEFAULT NULL,
   `avg_red_zone_successes` DECIMAL(9) DEFAULT NULL,
   `total_safeties` DECIMAL(25) DEFAULT NULL,
   `avg_safeties` DECIMAL(7) DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table v_schedule_and_results
# ------------------------------------------------------------

DROP VIEW IF EXISTS `v_schedule_and_results`;

CREATE TABLE `v_schedule_and_results` (
   `game_id` VARCHAR(255) DEFAULT NULL,
   `season` SMALLINT(6) DEFAULT NULL,
   `week_number` TINYINT(4) DEFAULT NULL,
   `week_type` VARCHAR(255) DEFAULT NULL,
   `home_team_id` TINYINT(4) DEFAULT NULL,
   `away_team_id` TINYINT(4) DEFAULT NULL,
   `game_time` DATETIME DEFAULT NULL,
   `home_score` SMALLINT(4) DEFAULT NULL,
   `away_score` SMALLINT(4) DEFAULT NULL,
   `game_clock` VARCHAR(255) DEFAULT NULL,
   `quarter` TINYINT(4) DEFAULT NULL,
   `status` ENUM('NOT_STARTED','IN_PROGRESS','HALFTIME','FINAL') DEFAULT NULL,
   `possession` TINYINT(1) DEFAULT NULL,
   `in_red_zone` TINYINT(1) DEFAULT NULL,
   `winning_team_id` TINYINT(4) DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table v_team_schedule
# ------------------------------------------------------------

DROP VIEW IF EXISTS `v_team_schedule`;

CREATE TABLE `v_team_schedule` (
   `game_id` VARCHAR(255) DEFAULT NULL,
   `season` SMALLINT(6) DEFAULT NULL,
   `week_number` TINYINT(4) DEFAULT NULL,
   `opponent_id` TINYINT(4) DEFAULT NULL,
   `team_id` TINYINT(4) DEFAULT NULL,
   `home` BIGINT(20) NOT NULL DEFAULT '0',
   `away` BIGINT(20) NOT NULL DEFAULT '0'
) ENGINE=MyISAM;



# Dump of table v_team_statistics
# ------------------------------------------------------------

DROP VIEW IF EXISTS `v_team_statistics`;

CREATE TABLE `v_team_statistics` (
   `team_id` TINYINT(4) DEFAULT NULL,
   `season` SMALLINT(6) DEFAULT NULL,
   `total_points` DECIMAL(27) DEFAULT NULL,
   `avg_points` DECIMAL(9) DEFAULT NULL,
   `total_turnovers` DECIMAL(27) DEFAULT NULL,
   `avg_turnovers` DECIMAL(9) DEFAULT NULL,
   `total_rushing_yards` DECIMAL(27) DEFAULT NULL,
   `avg_rushing_yards` DECIMAL(9) DEFAULT NULL,
   `total_passing_yards` DECIMAL(27) DEFAULT NULL,
   `avg_passing_yards` DECIMAL(9) DEFAULT NULL,
   `total_passing_completions` DECIMAL(27) DEFAULT NULL,
   `avg_passing_completions` DECIMAL(9) DEFAULT NULL,
   `total_sacks` DECIMAL(25) DEFAULT NULL,
   `avg_sacks` DECIMAL(7) DEFAULT NULL,
   `total_sack_yards_lost` DECIMAL(31) DEFAULT NULL,
   `avg_sack_yards_lost` DECIMAL(13) DEFAULT NULL,
   `total_interceptions_thrown` DECIMAL(27) DEFAULT NULL,
   `avg_interceptions_thrown` DECIMAL(9) DEFAULT NULL,
   `total_interception_return_yards` DECIMAL(27) DEFAULT NULL,
   `avg_interception_return_yards` DECIMAL(9) DEFAULT NULL,
   `total_interception_returns` DECIMAL(27) DEFAULT NULL,
   `avg_interception_returns` DECIMAL(9) DEFAULT NULL,
   `total_rushing_1st_downs` DECIMAL(27) DEFAULT NULL,
   `avg_rushing_1st_downs` DECIMAL(9) DEFAULT NULL,
   `total_passing_1st_downs` DECIMAL(27) DEFAULT NULL,
   `avg_passing_1st_downs` DECIMAL(9) DEFAULT NULL,
   `total_penalty_1st_downs` DECIMAL(27) DEFAULT NULL,
   `avg_penalty_1st_downs` DECIMAL(9) DEFAULT NULL,
   `total_third_down_attempts` DECIMAL(27) DEFAULT NULL,
   `avg_third_down_attempts` DECIMAL(9) DEFAULT NULL,
   `total_third_down_conversions` DECIMAL(27) DEFAULT NULL,
   `avg_third_down_conversions` DECIMAL(9) DEFAULT NULL,
   `total_fourth_down_attempts` DECIMAL(27) DEFAULT NULL,
   `avg_fourth_down_attempts` DECIMAL(9) DEFAULT NULL,
   `total_fourth_down_conversions` DECIMAL(27) DEFAULT NULL,
   `avg_fourth_down_conversions` DECIMAL(9) DEFAULT NULL,
   `total_punts` DECIMAL(27) DEFAULT NULL,
   `avg_punts` DECIMAL(9) DEFAULT NULL,
   `total_punts_blocked` DECIMAL(25) DEFAULT NULL,
   `avg_punts_blocked` DECIMAL(7) DEFAULT NULL,
   `total_punt_average_distance` DOUBLE DEFAULT NULL,
   `avg_punt_average_distance` DOUBLE DEFAULT NULL,
   `total_punt_net_average` DOUBLE DEFAULT NULL,
   `avg_punt_net_average` DOUBLE DEFAULT NULL,
   `total_punt_returns` DECIMAL(27) DEFAULT NULL,
   `avg_punt_returns` DECIMAL(9) DEFAULT NULL,
   `total_punt_return_yards` DECIMAL(27) DEFAULT NULL,
   `avg_punt_return_yards` DECIMAL(9) DEFAULT NULL,
   `total_kickoffs` DECIMAL(27) DEFAULT NULL,
   `avg_kickoffs` DECIMAL(9) DEFAULT NULL,
   `total_kickoffs_in_endzone` DECIMAL(27) DEFAULT NULL,
   `avg_kickoffs_in_endzone` DECIMAL(9) DEFAULT NULL,
   `total_kickoffs_touchback` DECIMAL(27) DEFAULT NULL,
   `avg_kickoffs_touchback` DECIMAL(9) DEFAULT NULL,
   `total_kickoff_returns` DECIMAL(27) DEFAULT NULL,
   `avg_kickoff_returns` DECIMAL(9) DEFAULT NULL,
   `total_kickoff_return_yards` DECIMAL(27) DEFAULT NULL,
   `avg_kickoff_return_yards` DECIMAL(9) DEFAULT NULL,
   `total_penalties` DECIMAL(27) DEFAULT NULL,
   `avg_penalties` DECIMAL(9) DEFAULT NULL,
   `total_penalty_yards` DECIMAL(27) DEFAULT NULL,
   `avg_penalty_yards` DECIMAL(9) DEFAULT NULL,
   `total_fumbles` DECIMAL(27) DEFAULT NULL,
   `avg_fumbles` DECIMAL(9) DEFAULT NULL,
   `total_fumbles_lost` DECIMAL(27) DEFAULT NULL,
   `avg_fumbles_lost` DECIMAL(9) DEFAULT NULL,
   `total_time_of_possession` DECIMAL(27) DEFAULT NULL,
   `avg_time_of_possession` DECIMAL(9) DEFAULT NULL,
   `total_rushing_tds` DECIMAL(27) DEFAULT NULL,
   `avg_rushing_tds` DECIMAL(9) DEFAULT NULL,
   `total_passing_tds` DECIMAL(27) DEFAULT NULL,
   `avg_passing_tds` DECIMAL(9) DEFAULT NULL,
   `total_other_tds` DECIMAL(27) DEFAULT NULL,
   `avg_other_tds` DECIMAL(9) DEFAULT NULL,
   `total_xp_attempts` DECIMAL(27) DEFAULT NULL,
   `avg_xp_attempts` DECIMAL(9) DEFAULT NULL,
   `total_xp_conversions` DECIMAL(27) DEFAULT NULL,
   `avg_xp_conversions` DECIMAL(9) DEFAULT NULL,
   `total_xp_blocked` DECIMAL(27) DEFAULT NULL,
   `avg_xp_blocked` DECIMAL(9) DEFAULT NULL,
   `total_fg_attempts` DECIMAL(27) DEFAULT NULL,
   `avg_fg_attempts` DECIMAL(9) DEFAULT NULL,
   `total_fg_conversions` DECIMAL(27) DEFAULT NULL,
   `avg_fg_conversions` DECIMAL(9) DEFAULT NULL,
   `total_fg_blocked` DECIMAL(27) DEFAULT NULL,
   `avg_fg_blocked` DECIMAL(9) DEFAULT NULL,
   `total_goal_to_go_attempts` DECIMAL(27) DEFAULT NULL,
   `avg_goal_to_go_attempts` DECIMAL(9) DEFAULT NULL,
   `total_goal_to_go_successes` DECIMAL(27) DEFAULT NULL,
   `avg_goal_to_go_successes` DECIMAL(9) DEFAULT NULL,
   `total_red_zone_attempts` DECIMAL(27) DEFAULT NULL,
   `avg_red_zone_attempts` DECIMAL(9) DEFAULT NULL,
   `total_red_zone_successes` DECIMAL(27) DEFAULT NULL,
   `avg_red_zone_successes` DECIMAL(9) DEFAULT NULL,
   `total_safeties` DECIMAL(25) DEFAULT NULL,
   `avg_safeties` DECIMAL(7) DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table v_teams_with_records
# ------------------------------------------------------------

DROP VIEW IF EXISTS `v_teams_with_records`;

CREATE TABLE `v_teams_with_records` (
   `id` INT(11) UNSIGNED NOT NULL DEFAULT '0',
   `name` VARCHAR(255) DEFAULT NULL,
   `short_name` VARCHAR(3) DEFAULT NULL,
   `stadium_name` VARCHAR(255) DEFAULT NULL,
   `stadium_capacity` INT(11) DEFAULT NULL,
   `conference` VARCHAR(255) NOT NULL DEFAULT '',
   `division` VARCHAR(255) NOT NULL DEFAULT '',
   `season` SMALLINT(6) NOT NULL DEFAULT '0',
   `won` SMALLINT(6) DEFAULT NULL,
   `lost` SMALLINT(6) DEFAULT NULL,
   `tied` SMALLINT(6) DEFAULT NULL,
   `conference_won` SMALLINT(6) DEFAULT NULL,
   `conference_lost` SMALLINT(6) DEFAULT NULL,
   `conference_tied` SMALLINT(6) DEFAULT NULL,
   `nonconference_won` SMALLINT(6) DEFAULT NULL,
   `nonconference_lost` SMALLINT(6) DEFAULT NULL,
   `nfc_north_won` SMALLINT(6) DEFAULT NULL,
   `nfc_north_lost` SMALLINT(6) DEFAULT NULL,
   `nfc_north_tied` SMALLINT(6) DEFAULT NULL,
   `nfc_south_won` SMALLINT(6) DEFAULT NULL,
   `nfc_south_lost` SMALLINT(6) DEFAULT NULL,
   `nfc_south_tied` SMALLINT(6) DEFAULT NULL,
   `nfc_east_won` SMALLINT(6) DEFAULT NULL,
   `nfc_east_lost` SMALLINT(6) DEFAULT NULL,
   `nfc_east_tied` SMALLINT(6) DEFAULT NULL,
   `nfc_west_won` SMALLINT(6) DEFAULT NULL,
   `nfc_west_lost` SMALLINT(6) DEFAULT NULL,
   `nfc_west_tied` SMALLINT(6) DEFAULT NULL,
   `afc_north_won` SMALLINT(6) DEFAULT NULL,
   `afc_north_lost` SMALLINT(6) DEFAULT NULL,
   `afc_north_tied` SMALLINT(6) DEFAULT NULL,
   `afc_south_won` SMALLINT(6) DEFAULT NULL,
   `afc_south_lost` SMALLINT(6) DEFAULT NULL,
   `afc_south_tied` SMALLINT(6) DEFAULT NULL,
   `afc_east_won` SMALLINT(6) DEFAULT NULL,
   `afc_east_lost` SMALLINT(6) DEFAULT NULL,
   `afc_east_tied` SMALLINT(6) DEFAULT NULL,
   `afc_west_won` SMALLINT(6) DEFAULT NULL,
   `afc_west_lost` SMALLINT(6) DEFAULT NULL,
   `afc_west_tied` SMALLINT(6) DEFAULT NULL
) ENGINE=MyISAM;





# Replace placeholder table for v_opponent_statistics with correct view syntax
# ------------------------------------------------------------

DROP TABLE `v_opponent_statistics`;
CREATE ALGORITHM=UNDEFINED VIEW `v_opponent_statistics`
AS select
   `oid`.`team_id` AS `team_id`,
   `oid`.`season` AS `season`,sum(`gs`.`points`) AS `total_points`,avg(`gs`.`points`) AS `avg_points`,sum(`gs`.`turnovers`) AS `total_turnovers`,avg(`gs`.`turnovers`) AS `avg_turnovers`,sum(`gs`.`rushing_yards`) AS `total_rushing_yards`,avg(`gs`.`rushing_yards`) AS `avg_rushing_yards`,sum(`gs`.`passing_yards`) AS `total_passing_yards`,avg(`gs`.`passing_yards`) AS `avg_passing_yards`,sum(`gs`.`passing_completions`) AS `total_passing_completions`,avg(`gs`.`passing_completions`) AS `avg_passing_completions`,sum(`gs`.`sacks`) AS `total_sacks`,avg(`gs`.`sacks`) AS `avg_sacks`,sum(`gs`.`sack_yards_lost`) AS `total_sack_yards_lost`,avg(`gs`.`sack_yards_lost`) AS `avg_sack_yards_lost`,sum(`gs`.`interceptions_thrown`) AS `total_interceptions_thrown`,avg(`gs`.`interceptions_thrown`) AS `avg_interceptions_thrown`,sum(`gs`.`interception_return_yards`) AS `total_interception_return_yards`,avg(`gs`.`interception_return_yards`) AS `avg_interception_return_yards`,sum(`gs`.`interception_returns`) AS `total_interception_returns`,avg(`gs`.`interception_returns`) AS `avg_interception_returns`,sum(`gs`.`rushing_1st_downs`) AS `total_rushing_1st_downs`,avg(`gs`.`rushing_1st_downs`) AS `avg_rushing_1st_downs`,sum(`gs`.`passing_1st_downs`) AS `total_passing_1st_downs`,avg(`gs`.`passing_1st_downs`) AS `avg_passing_1st_downs`,sum(`gs`.`penalty_1st_downs`) AS `total_penalty_1st_downs`,avg(`gs`.`penalty_1st_downs`) AS `avg_penalty_1st_downs`,sum(`gs`.`third_down_attempts`) AS `total_third_down_attempts`,avg(`gs`.`third_down_attempts`) AS `avg_third_down_attempts`,sum(`gs`.`third_down_conversions`) AS `total_third_down_conversions`,avg(`gs`.`third_down_conversions`) AS `avg_third_down_conversions`,sum(`gs`.`fourth_down_attempts`) AS `total_fourth_down_attempts`,avg(`gs`.`fourth_down_attempts`) AS `avg_fourth_down_attempts`,sum(`gs`.`fourth_down_conversions`) AS `total_fourth_down_conversions`,avg(`gs`.`fourth_down_conversions`) AS `avg_fourth_down_conversions`,sum(`gs`.`punts`) AS `total_punts`,avg(`gs`.`punts`) AS `avg_punts`,sum(`gs`.`punts_blocked`) AS `total_punts_blocked`,avg(`gs`.`punts_blocked`) AS `avg_punts_blocked`,sum(`gs`.`punt_average_distance`) AS `total_punt_average_distance`,avg(`gs`.`punt_average_distance`) AS `avg_punt_average_distance`,sum(`gs`.`punt_net_average`) AS `total_punt_net_average`,avg(`gs`.`punt_net_average`) AS `avg_punt_net_average`,sum(`gs`.`punt_returns`) AS `total_punt_returns`,avg(`gs`.`punt_returns`) AS `avg_punt_returns`,sum(`gs`.`punt_return_yards`) AS `total_punt_return_yards`,avg(`gs`.`punt_return_yards`) AS `avg_punt_return_yards`,sum(`gs`.`kickoffs`) AS `total_kickoffs`,avg(`gs`.`kickoffs`) AS `avg_kickoffs`,sum(`gs`.`kickoffs_in_endzone`) AS `total_kickoffs_in_endzone`,avg(`gs`.`kickoffs_in_endzone`) AS `avg_kickoffs_in_endzone`,sum(`gs`.`kickoffs_touchback`) AS `total_kickoffs_touchback`,avg(`gs`.`kickoffs_touchback`) AS `avg_kickoffs_touchback`,sum(`gs`.`kickoff_returns`) AS `total_kickoff_returns`,avg(`gs`.`kickoff_returns`) AS `avg_kickoff_returns`,sum(`gs`.`kickoff_return_yards`) AS `total_kickoff_return_yards`,avg(`gs`.`kickoff_return_yards`) AS `avg_kickoff_return_yards`,sum(`gs`.`penalties`) AS `total_penalties`,avg(`gs`.`penalties`) AS `avg_penalties`,sum(`gs`.`penalty_yards`) AS `total_penalty_yards`,avg(`gs`.`penalty_yards`) AS `avg_penalty_yards`,sum(`gs`.`fumbles`) AS `total_fumbles`,avg(`gs`.`fumbles`) AS `avg_fumbles`,sum(`gs`.`fumbles_lost`) AS `total_fumbles_lost`,avg(`gs`.`fumbles_lost`) AS `avg_fumbles_lost`,sum(`gs`.`time_of_possession`) AS `total_time_of_possession`,avg(`gs`.`time_of_possession`) AS `avg_time_of_possession`,sum(`gs`.`rushing_tds`) AS `total_rushing_tds`,avg(`gs`.`rushing_tds`) AS `avg_rushing_tds`,sum(`gs`.`passing_tds`) AS `total_passing_tds`,avg(`gs`.`passing_tds`) AS `avg_passing_tds`,sum(`gs`.`other_tds`) AS `total_other_tds`,avg(`gs`.`other_tds`) AS `avg_other_tds`,sum(`gs`.`xp_attempts`) AS `total_xp_attempts`,avg(`gs`.`xp_attempts`) AS `avg_xp_attempts`,sum(`gs`.`xp_conversions`) AS `total_xp_conversions`,avg(`gs`.`xp_conversions`) AS `avg_xp_conversions`,sum(`gs`.`xp_blocked`) AS `total_xp_blocked`,avg(`gs`.`xp_blocked`) AS `avg_xp_blocked`,sum(`gs`.`fg_attempts`) AS `total_fg_attempts`,avg(`gs`.`fg_attempts`) AS `avg_fg_attempts`,sum(`gs`.`fg_conversions`) AS `total_fg_conversions`,avg(`gs`.`fg_conversions`) AS `avg_fg_conversions`,sum(`gs`.`fg_blocked`) AS `total_fg_blocked`,avg(`gs`.`fg_blocked`) AS `avg_fg_blocked`,sum(`gs`.`goal_to_go_attempts`) AS `total_goal_to_go_attempts`,avg(`gs`.`goal_to_go_attempts`) AS `avg_goal_to_go_attempts`,sum(`gs`.`goal_to_go_successes`) AS `total_goal_to_go_successes`,avg(`gs`.`goal_to_go_attempts`) AS `avg_goal_to_go_successes`,sum(`gs`.`red_zone_attempts`) AS `total_red_zone_attempts`,avg(`gs`.`red_zone_attempts`) AS `avg_red_zone_attempts`,sum(`gs`.`red_zone_successes`) AS `total_red_zone_successes`,avg(`gs`.`red_zone_attempts`) AS `avg_red_zone_successes`,sum(`gs`.`safeties`) AS `total_safeties`,avg(`gs`.`safeties`) AS `avg_safeties`
from (`game_stats` `gs` join `v_team_schedule` `oid` on(((`gs`.`game_id` = `oid`.`game_id`) and (`gs`.`team_id` = `oid`.`opponent_id`)))) group by `oid`.`season`,`oid`.`team_id`;


# Replace placeholder table for v_team_schedule with correct view syntax
# ------------------------------------------------------------

DROP TABLE `v_team_schedule`;
CREATE ALGORITHM=UNDEFINED VIEW `v_team_schedule`
AS select
   `schedule`.`game_id` AS `game_id`,
   `schedule`.`season` AS `season`,
   `schedule`.`week_number` AS `week_number`,
   `schedule`.`away_team_id` AS `opponent_id`,
   `schedule`.`home_team_id` AS `team_id`,1 AS `home`,0 AS `away`
from `schedule` union select `schedule`.`game_id` AS `game_id`,`schedule`.`season` AS `season`,`schedule`.`week_number` AS `week_number`,`schedule`.`home_team_id` AS `opponent_id`,`schedule`.`away_team_id` AS `team_id`,0 AS `home`,1 AS `away` from `schedule` order by `game_id`;


# Replace placeholder table for v_teams_with_records with correct view syntax
# ------------------------------------------------------------

DROP TABLE `v_teams_with_records`;
CREATE ALGORITHM=UNDEFINED VIEW `v_teams_with_records`
AS select
   `teams`.`id` AS `id`,
   `teams`.`name` AS `name`,
   `teams`.`short_name` AS `short_name`,
   `teams`.`stadium_name` AS `stadium_name`,
   `teams`.`stadium_capacity` AS `stadium_capacity`,
   `teams`.`conference` AS `conference`,
   `teams`.`division` AS `division`,
   `full_records`.`season` AS `season`,
   `full_records`.`won` AS `won`,
   `full_records`.`lost` AS `lost`,
   `full_records`.`tied` AS `tied`,
   `full_records`.`conference_won` AS `conference_won`,
   `full_records`.`conference_lost` AS `conference_lost`,
   `full_records`.`conference_tied` AS `conference_tied`,
   `full_records`.`nonconference_won` AS `nonconference_won`,
   `full_records`.`nonconference_lost` AS `nonconference_lost`,
   `full_records`.`nfc_north_won` AS `nfc_north_won`,
   `full_records`.`nfc_north_lost` AS `nfc_north_lost`,
   `full_records`.`nfc_north_tied` AS `nfc_north_tied`,
   `full_records`.`nfc_south_won` AS `nfc_south_won`,
   `full_records`.`nfc_south_lost` AS `nfc_south_lost`,
   `full_records`.`nfc_south_tied` AS `nfc_south_tied`,
   `full_records`.`nfc_east_won` AS `nfc_east_won`,
   `full_records`.`nfc_east_lost` AS `nfc_east_lost`,
   `full_records`.`nfc_east_tied` AS `nfc_east_tied`,
   `full_records`.`nfc_west_won` AS `nfc_west_won`,
   `full_records`.`nfc_west_lost` AS `nfc_west_lost`,
   `full_records`.`nfc_west_tied` AS `nfc_west_tied`,
   `full_records`.`afc_north_won` AS `afc_north_won`,
   `full_records`.`afc_north_lost` AS `afc_north_lost`,
   `full_records`.`afc_north_tied` AS `afc_north_tied`,
   `full_records`.`afc_south_won` AS `afc_south_won`,
   `full_records`.`afc_south_lost` AS `afc_south_lost`,
   `full_records`.`afc_south_tied` AS `afc_south_tied`,
   `full_records`.`afc_east_won` AS `afc_east_won`,
   `full_records`.`afc_east_lost` AS `afc_east_lost`,
   `full_records`.`afc_east_tied` AS `afc_east_tied`,
   `full_records`.`afc_west_won` AS `afc_west_won`,
   `full_records`.`afc_west_lost` AS `afc_west_lost`,
   `full_records`.`afc_west_tied` AS `afc_west_tied`
from (`teams` join `full_records` on((`teams`.`id` = `full_records`.`team_id`)));


# Replace placeholder table for v_bet_records with correct view syntax
# ------------------------------------------------------------

DROP TABLE `v_bet_records`;
CREATE ALGORITHM=UNDEFINED VIEW `v_bet_records`
AS select
   `v_bet_records_unsummed`.`user_id` AS `user_id`,
   `v_bet_records_unsummed`.`season` AS `season`,sum(`v_bet_records_unsummed`.`s_h_reg_won`) AS `s_h_reg_won`,sum(`v_bet_records_unsummed`.`s_h_reg_lost`) AS `s_h_reg_lost`,sum(`v_bet_records_unsummed`.`s_h_rev_won`) AS `s_h_rev_won`,sum(`v_bet_records_unsummed`.`s_h_rev_lost`) AS `s_h_rev_lost`,sum(`v_bet_records_unsummed`.`p_h_reg_won`) AS `p_h_reg_won`,sum(`v_bet_records_unsummed`.`p_h_reg_lost`) AS `p_h_reg_lost`,sum(`v_bet_records_unsummed`.`p_h_rev_won`) AS `p_h_rev_won`,sum(`v_bet_records_unsummed`.`p_h_rev_lost`) AS `p_h_rev_lost`,sum(`v_bet_records_unsummed`.`s_a_reg_won`) AS `s_a_reg_won`,sum(`v_bet_records_unsummed`.`s_a_reg_lost`) AS `s_a_reg_lost`,sum(`v_bet_records_unsummed`.`s_a_reg_push`) AS `s_a_reg_push`,sum(`v_bet_records_unsummed`.`s_a_rev_won`) AS `s_a_rev_won`,sum(`v_bet_records_unsummed`.`s_a_rev_lost`) AS `s_a_rev_lost`,sum(`v_bet_records_unsummed`.`s_a_reg_push`) AS `s_a_rev_push`,sum(`v_bet_records_unsummed`.`p_a_reg_won`) AS `p_a_reg_won`,sum(`v_bet_records_unsummed`.`p_a_reg_lost`) AS `p_a_reg_lost`,sum(`v_bet_records_unsummed`.`p_a_reg_push`) AS `p_a_reg_push`,sum(`v_bet_records_unsummed`.`p_a_rev_won`) AS `p_a_rev_won`,sum(`v_bet_records_unsummed`.`p_a_rev_lost`) AS `p_a_rev_lost`,sum(`v_bet_records_unsummed`.`p_a_reg_push`) AS `p_a_rev_push`
from `v_bet_records_unsummed` group by `v_bet_records_unsummed`.`user_id`,`v_bet_records_unsummed`.`season`;


# Replace placeholder table for v_bets_with_users_teams_results with correct view syntax
# ------------------------------------------------------------

DROP TABLE `v_bets_with_users_teams_results`;
CREATE ALGORITHM=UNDEFINED VIEW `v_bets_with_users_teams_results`
AS select
   `bets`.`id` AS `id`,
   `bets`.`created_at` AS `created_at`,
   `bets`.`updated_at` AS `updated_at`,
   `bets`.`user_id` AS `user_id`,
   `bets`.`season` AS `season`,
   `bets`.`week_number` AS `week_number`,
   `bets`.`week_type` AS `week_type`,
   `bets`.`game_id` AS `game_id`,
   `bets`.`team_id` AS `team_id`,
   `bets`.`spread_id` AS `spread_id`,
   `bets`.`bet_set_id` AS `bet_set_id`,
   `bets`.`survival_pickem` AS `survival_pickem`,
   `bets`.`headsup_ats` AS `headsup_ats`,
   `bets`.`regular_reverse` AS `regular_reverse`,
   `users`.`username` AS `username`,
   `teams`.`name` AS `team_name`,
   `teams`.`short_name` AS `short_name`,
   `game_results`.`status` AS `status`,
   `game_results`.`winning_team_id` AS `winning_team_id`
from (((`bets` join `users` on((`users`.`id` = `bets`.`user_id`))) join `teams` on((`bets`.`team_id` = `teams`.`id`))) join `game_results` on((`bets`.`game_id` = `game_results`.`game_id`)));


# Replace placeholder table for v_schedule_and_results with correct view syntax
# ------------------------------------------------------------

DROP TABLE `v_schedule_and_results`;
CREATE ALGORITHM=UNDEFINED VIEW `v_schedule_and_results`
AS select
   `s`.`game_id` AS `game_id`,
   `s`.`season` AS `season`,
   `s`.`week_number` AS `week_number`,
   `s`.`week_type` AS `week_type`,
   `s`.`home_team_id` AS `home_team_id`,
   `s`.`away_team_id` AS `away_team_id`,
   `s`.`game_time` AS `game_time`,
   `gr`.`home_score` AS `home_score`,
   `gr`.`away_score` AS `away_score`,
   `gr`.`game_clock` AS `game_clock`,
   `gr`.`quarter` AS `quarter`,
   `gr`.`status` AS `status`,
   `gr`.`possession` AS `possession`,
   `gr`.`in_red_zone` AS `in_red_zone`,
   `gr`.`winning_team_id` AS `winning_team_id`
from (`schedule` `s` join `game_results` `gr` on((`s`.`game_id` = `gr`.`game_id`)));


# Replace placeholder table for v_team_statistics with correct view syntax
# ------------------------------------------------------------

DROP TABLE `v_team_statistics`;
CREATE ALGORITHM=UNDEFINED VIEW `v_team_statistics`
AS select
   `gs`.`team_id` AS `team_id`,
   `schedule`.`season` AS `season`,sum(`gs`.`points`) AS `total_points`,avg(`gs`.`points`) AS `avg_points`,sum(`gs`.`turnovers`) AS `total_turnovers`,avg(`gs`.`turnovers`) AS `avg_turnovers`,sum(`gs`.`rushing_yards`) AS `total_rushing_yards`,avg(`gs`.`rushing_yards`) AS `avg_rushing_yards`,sum(`gs`.`passing_yards`) AS `total_passing_yards`,avg(`gs`.`passing_yards`) AS `avg_passing_yards`,sum(`gs`.`passing_completions`) AS `total_passing_completions`,avg(`gs`.`passing_completions`) AS `avg_passing_completions`,sum(`gs`.`sacks`) AS `total_sacks`,avg(`gs`.`sacks`) AS `avg_sacks`,sum(`gs`.`sack_yards_lost`) AS `total_sack_yards_lost`,avg(`gs`.`sack_yards_lost`) AS `avg_sack_yards_lost`,sum(`gs`.`interceptions_thrown`) AS `total_interceptions_thrown`,avg(`gs`.`interceptions_thrown`) AS `avg_interceptions_thrown`,sum(`gs`.`interception_return_yards`) AS `total_interception_return_yards`,avg(`gs`.`interception_return_yards`) AS `avg_interception_return_yards`,sum(`gs`.`interception_returns`) AS `total_interception_returns`,avg(`gs`.`interception_returns`) AS `avg_interception_returns`,sum(`gs`.`rushing_1st_downs`) AS `total_rushing_1st_downs`,avg(`gs`.`rushing_1st_downs`) AS `avg_rushing_1st_downs`,sum(`gs`.`passing_1st_downs`) AS `total_passing_1st_downs`,avg(`gs`.`passing_1st_downs`) AS `avg_passing_1st_downs`,sum(`gs`.`penalty_1st_downs`) AS `total_penalty_1st_downs`,avg(`gs`.`penalty_1st_downs`) AS `avg_penalty_1st_downs`,sum(`gs`.`third_down_attempts`) AS `total_third_down_attempts`,avg(`gs`.`third_down_attempts`) AS `avg_third_down_attempts`,sum(`gs`.`third_down_conversions`) AS `total_third_down_conversions`,avg(`gs`.`third_down_conversions`) AS `avg_third_down_conversions`,sum(`gs`.`fourth_down_attempts`) AS `total_fourth_down_attempts`,avg(`gs`.`fourth_down_attempts`) AS `avg_fourth_down_attempts`,sum(`gs`.`fourth_down_conversions`) AS `total_fourth_down_conversions`,avg(`gs`.`fourth_down_conversions`) AS `avg_fourth_down_conversions`,sum(`gs`.`punts`) AS `total_punts`,avg(`gs`.`punts`) AS `avg_punts`,sum(`gs`.`punts_blocked`) AS `total_punts_blocked`,avg(`gs`.`punts_blocked`) AS `avg_punts_blocked`,sum(`gs`.`punt_average_distance`) AS `total_punt_average_distance`,avg(`gs`.`punt_average_distance`) AS `avg_punt_average_distance`,sum(`gs`.`punt_net_average`) AS `total_punt_net_average`,avg(`gs`.`punt_net_average`) AS `avg_punt_net_average`,sum(`gs`.`punt_returns`) AS `total_punt_returns`,avg(`gs`.`punt_returns`) AS `avg_punt_returns`,sum(`gs`.`punt_return_yards`) AS `total_punt_return_yards`,avg(`gs`.`punt_return_yards`) AS `avg_punt_return_yards`,sum(`gs`.`kickoffs`) AS `total_kickoffs`,avg(`gs`.`kickoffs`) AS `avg_kickoffs`,sum(`gs`.`kickoffs_in_endzone`) AS `total_kickoffs_in_endzone`,avg(`gs`.`kickoffs_in_endzone`) AS `avg_kickoffs_in_endzone`,sum(`gs`.`kickoffs_touchback`) AS `total_kickoffs_touchback`,avg(`gs`.`kickoffs_touchback`) AS `avg_kickoffs_touchback`,sum(`gs`.`kickoff_returns`) AS `total_kickoff_returns`,avg(`gs`.`kickoff_returns`) AS `avg_kickoff_returns`,sum(`gs`.`kickoff_return_yards`) AS `total_kickoff_return_yards`,avg(`gs`.`kickoff_return_yards`) AS `avg_kickoff_return_yards`,sum(`gs`.`penalties`) AS `total_penalties`,avg(`gs`.`penalties`) AS `avg_penalties`,sum(`gs`.`penalty_yards`) AS `total_penalty_yards`,avg(`gs`.`penalty_yards`) AS `avg_penalty_yards`,sum(`gs`.`fumbles`) AS `total_fumbles`,avg(`gs`.`fumbles`) AS `avg_fumbles`,sum(`gs`.`fumbles_lost`) AS `total_fumbles_lost`,avg(`gs`.`fumbles_lost`) AS `avg_fumbles_lost`,sum(`gs`.`time_of_possession`) AS `total_time_of_possession`,avg(`gs`.`time_of_possession`) AS `avg_time_of_possession`,sum(`gs`.`rushing_tds`) AS `total_rushing_tds`,avg(`gs`.`rushing_tds`) AS `avg_rushing_tds`,sum(`gs`.`passing_tds`) AS `total_passing_tds`,avg(`gs`.`passing_tds`) AS `avg_passing_tds`,sum(`gs`.`other_tds`) AS `total_other_tds`,avg(`gs`.`other_tds`) AS `avg_other_tds`,sum(`gs`.`xp_attempts`) AS `total_xp_attempts`,avg(`gs`.`xp_attempts`) AS `avg_xp_attempts`,sum(`gs`.`xp_conversions`) AS `total_xp_conversions`,avg(`gs`.`xp_conversions`) AS `avg_xp_conversions`,sum(`gs`.`xp_blocked`) AS `total_xp_blocked`,avg(`gs`.`xp_blocked`) AS `avg_xp_blocked`,sum(`gs`.`fg_attempts`) AS `total_fg_attempts`,avg(`gs`.`fg_attempts`) AS `avg_fg_attempts`,sum(`gs`.`fg_conversions`) AS `total_fg_conversions`,avg(`gs`.`fg_conversions`) AS `avg_fg_conversions`,sum(`gs`.`fg_blocked`) AS `total_fg_blocked`,avg(`gs`.`fg_blocked`) AS `avg_fg_blocked`,sum(`gs`.`goal_to_go_attempts`) AS `total_goal_to_go_attempts`,avg(`gs`.`goal_to_go_attempts`) AS `avg_goal_to_go_attempts`,sum(`gs`.`goal_to_go_successes`) AS `total_goal_to_go_successes`,avg(`gs`.`goal_to_go_attempts`) AS `avg_goal_to_go_successes`,sum(`gs`.`red_zone_attempts`) AS `total_red_zone_attempts`,avg(`gs`.`red_zone_attempts`) AS `avg_red_zone_attempts`,sum(`gs`.`red_zone_successes`) AS `total_red_zone_successes`,avg(`gs`.`red_zone_attempts`) AS `avg_red_zone_successes`,sum(`gs`.`safeties`) AS `total_safeties`,avg(`gs`.`safeties`) AS `avg_safeties`
from (`game_stats` `gs` join `schedule` on((`schedule`.`game_id` = `gs`.`game_id`))) group by `gs`.`team_id`,`schedule`.`season`;


# Replace placeholder table for v_bet_records_unsummed with correct view syntax
# ------------------------------------------------------------

DROP TABLE `v_bet_records_unsummed`;
CREATE ALGORITHM=UNDEFINED VIEW `v_bet_records_unsummed`
AS select
   `b`.`user_id` AS `user_id`,
   `b`.`season` AS `season`,
   `b`.`week_number` AS `week_number`,
   `b`.`week_type` AS `week_type`,
   `b`.`game_id` AS `game_id`,
   `b`.`team_id` AS `team_id`,(case when ((`gr`.`status` = 'FINAL') and (`gr`.`winning_team_id` = `b`.`team_id`) and (`b`.`survival_pickem` = 0) and (`b`.`headsup_ats` = 0) and (`b`.`regular_reverse` = 0)) then 1 else 0 end) AS `s_h_reg_won`,(case when ((`gr`.`status` = 'FINAL') and ((`gr`.`winning_team_id` <> `b`.`team_id`) or isnull(`gr`.`winning_team_id`)) and (`b`.`survival_pickem` = 0) and (`b`.`headsup_ats` = 0) and (`b`.`regular_reverse` = 0)) then 1 else 0 end) AS `s_h_reg_lost`,(case when ((`gr`.`status` = 'FINAL') and (`gr`.`winning_team_id` is not null) and (`gr`.`winning_team_id` <> `b`.`team_id`) and (`b`.`survival_pickem` = 0) and (`b`.`headsup_ats` = 0) and (`b`.`regular_reverse` = 1)) then 1 else 0 end) AS `s_h_rev_won`,(case when ((`gr`.`status` = 'FINAL') and ((`gr`.`winning_team_id` = `b`.`team_id`) or isnull(`gr`.`winning_team_id`)) and (`b`.`survival_pickem` = 0) and (`b`.`headsup_ats` = 0) and (`b`.`regular_reverse` = 1)) then 1 else 0 end) AS `s_h_rev_lost`,(case when ((`gr`.`status` = 'FINAL') and (`gr`.`winning_team_id` = `b`.`team_id`) and (`b`.`survival_pickem` = 1) and (`b`.`headsup_ats` = 0) and (`b`.`regular_reverse` = 0)) then 1 else 0 end) AS `p_h_reg_won`,(case when ((`gr`.`status` = 'FINAL') and ((`gr`.`winning_team_id` <> `b`.`team_id`) or isnull(`gr`.`winning_team_id`)) and (`b`.`survival_pickem` = 1) and (`b`.`headsup_ats` = 0) and (`b`.`regular_reverse` = 0)) then 1 else 0 end) AS `p_h_reg_lost`,(case when ((`gr`.`status` = 'FINAL') and (`gr`.`winning_team_id` is not null) and (`gr`.`winning_team_id` <> `b`.`team_id`) and (`b`.`survival_pickem` = 1) and (`b`.`headsup_ats` = 0) and (`b`.`regular_reverse` = 1)) then 1 else 0 end) AS `p_h_rev_won`,(case when ((`gr`.`status` = 'FINAL') and ((`gr`.`winning_team_id` = `b`.`team_id`) or isnull(`gr`.`winning_team_id`)) and (`b`.`survival_pickem` = 1) and (`b`.`headsup_ats` = 0) and (`b`.`regular_reverse` = 1)) then 1 else 0 end) AS `p_h_rev_lost`,(case when ((`gr`.`status` = 'FINAL') and ((`gr`.`away_score` - `gr`.`home_score`) < `s`.`spread`) and (`b`.`survival_pickem` = 0) and (`b`.`headsup_ats` = 1) and (`b`.`regular_reverse` = 0)) then 1 else 0 end) AS `s_a_reg_won`,(case when ((`gr`.`status` = 'FINAL') and ((`gr`.`away_score` - `gr`.`home_score`) > `s`.`spread`) and (`b`.`survival_pickem` = 0) and (`b`.`headsup_ats` = 1) and (`b`.`regular_reverse` = 0)) then 1 else 0 end) AS `s_a_reg_lost`,(case when ((`gr`.`status` = 'FINAL') and ((`gr`.`away_score` - `gr`.`home_score`) = `s`.`spread`) and (`b`.`survival_pickem` = 0) and (`b`.`headsup_ats` = 1) and (`b`.`regular_reverse` = 0)) then 1 else 0 end) AS `s_a_reg_push`,(case when ((`gr`.`status` = 'FINAL') and ((`gr`.`away_score` - `gr`.`home_score`) > `s`.`spread`) and (`b`.`survival_pickem` = 0) and (`b`.`headsup_ats` = 1) and (`b`.`regular_reverse` = 1)) then 1 else 0 end) AS `s_a_rev_won`,(case when ((`gr`.`status` = 'FINAL') and ((`gr`.`away_score` - `gr`.`home_score`) < `s`.`spread`) and (`b`.`survival_pickem` = 0) and (`b`.`headsup_ats` = 1) and (`b`.`regular_reverse` = 1)) then 1 else 0 end) AS `s_a_rev_lost`,(case when ((`gr`.`status` = 'FINAL') and ((`gr`.`away_score` - `gr`.`home_score`) = `s`.`spread`) and (`b`.`survival_pickem` = 0) and (`b`.`headsup_ats` = 1) and (`b`.`regular_reverse` = 1)) then 1 else 0 end) AS `s_a_rev_push`,(case when ((`gr`.`status` = 'FINAL') and ((`gr`.`away_score` - `gr`.`home_score`) < `s`.`spread`) and (`b`.`survival_pickem` = 1) and (`b`.`headsup_ats` = 1) and (`b`.`regular_reverse` = 0)) then 1 else 0 end) AS `p_a_reg_won`,(case when ((`gr`.`status` = 'FINAL') and ((`gr`.`away_score` - `gr`.`home_score`) > `s`.`spread`) and (`b`.`survival_pickem` = 1) and (`b`.`headsup_ats` = 1) and (`b`.`regular_reverse` = 0)) then 1 else 0 end) AS `p_a_reg_lost`,(case when ((`gr`.`status` = 'FINAL') and ((`gr`.`away_score` - `gr`.`home_score`) = `s`.`spread`) and (`b`.`survival_pickem` = 1) and (`b`.`headsup_ats` = 1) and (`b`.`regular_reverse` = 0)) then 1 else 0 end) AS `p_a_reg_push`,(case when ((`gr`.`status` = 'FINAL') and ((`gr`.`away_score` - `gr`.`home_score`) > `s`.`spread`) and (`b`.`survival_pickem` = 1) and (`b`.`headsup_ats` = 1) and (`b`.`regular_reverse` = 1)) then 1 else 0 end) AS `p_a_rev_won`,(case when ((`gr`.`status` = 'FINAL') and ((`gr`.`away_score` - `gr`.`home_score`) < `s`.`spread`) and (`b`.`survival_pickem` = 1) and (`b`.`headsup_ats` = 1) and (`b`.`regular_reverse` = 1)) then 1 else 0 end) AS `p_a_rev_lost`,(case when ((`gr`.`status` = 'FINAL') and ((`gr`.`away_score` - `gr`.`home_score`) = `s`.`spread`) and (`b`.`survival_pickem` = 1) and (`b`.`headsup_ats` = 1) and (`b`.`regular_reverse` = 1)) then 1 else 0 end) AS `p_a_rev_push`
from ((`bets` `b` join `game_results` `gr` on((`gr`.`game_id` = `b`.`game_id`))) join `spread` `s` on((`b`.`spread_id` = `s`.`id`)));

--
-- Dumping routines (PROCEDURE) for database 'eliminator'
--
DELIMITER ;;

# Dump of PROCEDURE generate_full_records
# ------------------------------------------------------------

/*!50003 DROP PROCEDURE IF EXISTS `generate_full_records` */;;
/*!50003 SET SESSION SQL_MODE=""*/;;
/*!50003 CREATE*/ /*!50003 PROCEDURE `generate_full_records`()
begin
delete from full_records;
insert into full_records
select
team_id,season,
sum(won) as won,
sum(lost) as lost,
sum(tied) as tied,
sum(home_won) as home_won,
sum(home_lost) as home_lost,
sum(home_tied) as home_tied,
sum(away_won) as away_won,
sum(away_lost) as away_lost,
sum(away_tied) as away_tied,
sum(conference_won) as conference_won,
sum(conference_lost) as conference_lost,
sum(conference_tied) as conference_tied,
sum(nonconference_won) as nonconference_won,
sum(nonconference_lost) as nonconference_lost,
sum(nonconference_tied) as nonconference_tied,
sum(nfc_north_won) as nfc_north_won,
sum(nfc_north_lost) as nfc_north_lost,
sum(nfc_north_tied) as nfc_north_tied,
sum(nfc_south_won) as nfc_south_won,
sum(nfc_south_lost) as nfc_south_lost,
sum(nfc_south_tied) as nfc_south_tied,
sum(nfc_east_won) as nfc_east_won,
sum(nfc_east_lost) as nfc_east_lost,
sum(nfc_east_tied) as nfc_east_tied,
sum(nfc_west_won) as nfc_west_won,
sum(nfc_west_lost) as nfc_west_lost,
sum(nfc_west_tied) as nfc_west_tied,
sum(afc_north_won) as afc_north_won,
sum(afc_north_lost) as afc_north_lost,
sum(afc_north_tied) as afc_north_tied,
sum(afc_south_won) as afc_south_won,
sum(afc_south_lost) as afc_south_lost,
sum(afc_south_tied) as afc_south_tied,
sum(afc_east_won) as afc_east_won,
sum(afc_east_lost) as afc_east_lost,
sum(afc_east_tied) as afc_east_tied,
sum(afc_west_won) as afc_west_won,
sum(afc_west_lost) as afc_west_lost,
sum(afc_west_tied) as afc_west_tied
from (select game_id,season,home_team_id as team_id,
case when (home_team_id = winning_team_id) then 1 else 0 end as won,
case when (home_team_id <> winning_team_id and winning_team_id is not null) then 1 else 0 end as lost,
case when (winning_team_id is null) then 1 else 0 end as tied,

case when (home_team_id = winning_team_id) then 1 else 0 end as home_won,
case when (home_team_id <> winning_team_id and winning_team_id is not null) then 1 else 0 end as home_lost,
case when (winning_team_id is null) then 1 else 0 end as home_tied,

0 as away_won, 0 as away_lost, 0 as away_tied,

case when (home_team_id = winning_team_id and t.conference = ot.conference) then 1 else 0 end as conference_won,
case when (home_team_id <> winning_team_id and winning_team_id is not null and t.conference = ot.conference) then 1 else 0 end as conference_lost,
case when (winning_team_id is null and t.conference = ot.conference) then 1 else 0 end as conference_tied,
case when (home_team_id = winning_team_id and t.conference <> ot.conference) then 1 else 0 end as nonconference_won,
case when (home_team_id <> winning_team_id and winning_team_id is not null and t.conference <> ot.conference) then 1 else 0 end as nonconference_lost,
case when (winning_team_id is null and t.conference <> ot.conference) then 1 else 0 end as nonconference_tied,

case when (home_team_id = winning_team_id and ot.conference = "AFC" and ot.division = "North") then 1 else 0 end as afc_north_won,
case when (home_team_id <> winning_team_id and winning_team_id is not null and ot.conference = "AFC" and ot.division = "North") then 1 else 0 end as afc_north_lost,
case when (winning_team_id is null and ot.conference = "AFC" and ot.division = "North") then 1 else 0 end as afc_north_tied,

case when (home_team_id = winning_team_id and ot.conference = "AFC" and ot.division = "South") then 1 else 0 end as afc_south_won,
case when (home_team_id <> winning_team_id and winning_team_id is not null and ot.conference = "AFC" and ot.division = "South") then 1 else 0 end as afc_south_lost,
case when (winning_team_id is null and ot.conference = "AFC" and ot.division = "South") then 1 else 0 end as afc_south_tied,

case when (home_team_id = winning_team_id and ot.conference = "AFC" and ot.division = "East") then 1 else 0 end as afc_east_won,
case when (home_team_id <> winning_team_id and winning_team_id is not null and ot.conference = "AFC" and ot.division = "East") then 1 else 0 end as afc_east_lost,
case when (winning_team_id is null and ot.conference and ot.conference = "AFC" and ot.division = "East") then 1 else 0 end as afc_east_tied,

case when (home_team_id = winning_team_id and ot.conference = "AFC" and ot.division = "West") then 1 else 0 end as afc_west_won,
case when (home_team_id <> winning_team_id and winning_team_id is not null and ot.conference = "AFC" and ot.division = "West") then 1 else 0 end as afc_west_lost,
case when (winning_team_id is null and ot.conference and ot.conference = "AFC" and ot.division = "West") then 1 else 0 end as afc_west_tied,

case when (home_team_id = winning_team_id and ot.conference = "NFC" and ot.division = "North") then 1 else 0 end as nfc_north_won,
case when (home_team_id <> winning_team_id and winning_team_id is not null and ot.conference = "NFC" and ot.division = "North") then 1 else 0 end as nfc_north_lost,
case when (winning_team_id is null and ot.conference = "NFC" and ot.division = "North") then 1 else 0 end as nfc_north_tied,

case when (home_team_id = winning_team_id and ot.conference = "NFC" and ot.division = "South") then 1 else 0 end as nfc_south_won,
case when (home_team_id <> winning_team_id and winning_team_id is not null and ot.conference = "NFC" and ot.division = "South") then 1 else 0 end as nfc_south_lost,
case when (winning_team_id is null and ot.conference = "NFC" and ot.division = "South") then 1 else 0 end as nfc_south_tied,

case when (home_team_id = winning_team_id and ot.conference = "NFC" and ot.division = "East") then 1 else 0 end as nfc_east_won,
case when (home_team_id <> winning_team_id and winning_team_id is not null and ot.conference = "NFC" and ot.division = "East") then 1 else 0 end as nfc_east_lost,
case when (winning_team_id is null and ot.conference = "NFC" and ot.division = "East") then 1 else 0 end as nfc_east_tied,

case when (home_team_id = winning_team_id and ot.conference = "NFC" and ot.division = "West") then 1 else 0 end as nfc_west_won,
case when (home_team_id <> winning_team_id and winning_team_id is not null and ot.conference = "NFC" and ot.division = "West") then 1 else 0 end as nfc_west_lost,
case when (winning_team_id is null and ot.conference = "NFC" and ot.division = "West") then 1 else 0 end as nfc_west_tied

from v_schedule_and_results
join teams t on t.id=home_team_id
join teams ot on ot.id=away_team_id
where status='FINAL'
union all
select game_id,season,away_team_id as team_id,
case when (away_team_id = winning_team_id) then 1 else 0 end as won,
case when (away_team_id <> winning_team_id and winning_team_id is not null) then 1 else 0 end as lost,
case when (winning_team_id is null) then 1 else 0 end as tied,

0 as home_won, 0 as home_lost, 0 as home_tied,

case when (away_team_id = winning_team_id) then 1 else 0 end as away_won,
case when (away_team_id <> winning_team_id and winning_team_id is not null) then 1 else 0 end as away_lost,
case when (winning_team_id is null) then 1 else 0 end as away_tied,


case when (away_team_id = winning_team_id and t.conference = ot.conference) then 1 else 0 end as conference_won,
case when (away_team_id <> winning_team_id and winning_team_id is not null and t.conference = ot.conference) then 1 else 0 end as conference_lost,
case when (winning_team_id is null and t.conference = ot.conference) then 1 else 0 end as conference_tied,
case when (away_team_id = winning_team_id and t.conference <> ot.conference) then 1 else 0 end as nonconference_won,
case when (away_team_id <> winning_team_id and winning_team_id is not null and t.conference <> ot.conference) then 1 else 0 end as nonconference_lost,
case when (winning_team_id is null and t.conference <> ot.conference) then 1 else 0 end as nonconference_tied,

case when (away_team_id = winning_team_id and ot.conference = "AFC" and ot.division = "North") then 1 else 0 end as afc_north_won,
case when (away_team_id <> winning_team_id and winning_team_id is not null and ot.conference = "AFC" and ot.division = "North") then 1 else 0 end as afc_north_lost,
case when (winning_team_id is null and ot.conference = "AFC" and ot.division = "North") then 1 else 0 end as afc_north_tied,

case when (away_team_id = winning_team_id and ot.conference = "AFC" and ot.division = "South") then 1 else 0 end as afc_south_won,
case when (away_team_id <> winning_team_id and winning_team_id is not null and ot.conference = "AFC" and ot.division = "South") then 1 else 0 end as afc_south_lost,
case when (winning_team_id is null and ot.conference = "AFC" and ot.division = "South") then 1 else 0 end as afc_south_tied,

case when (away_team_id = winning_team_id and ot.conference = "AFC" and ot.division = "East") then 1 else 0 end as afc_east_won,
case when (away_team_id <> winning_team_id and winning_team_id is not null and ot.conference = "AFC" and ot.division = "East") then 1 else 0 end as afc_east_lost,
case when (winning_team_id is null and ot.conference = "AFC" and ot.division = "East") then 1 else 0 end as afc_east_tied,

case when (away_team_id = winning_team_id and ot.conference = "AFC" and ot.division = "West") then 1 else 0 end as afc_west_won,
case when (away_team_id <> winning_team_id and winning_team_id is not null and ot.conference = "AFC" and ot.division = "West") then 1 else 0 end as afc_west_lost,
case when (winning_team_id is null and ot.conference = "AFC" and ot.division = "West") then 1 else 0 end as afc_west_tied,

case when (away_team_id = winning_team_id and ot.conference = "NFC" and ot.division = "North") then 1 else 0 end as nfc_north_won,
case when (away_team_id <> winning_team_id and winning_team_id is not null and ot.conference = "NFC" and ot.division = "North") then 1 else 0 end as nfc_north_lost,
case when (winning_team_id is null and ot.conference = "NFC" and ot.division = "North") then 1 else 0 end as nfc_north_tied,

case when (away_team_id = winning_team_id and ot.conference = "NFC" and ot.division = "South") then 1 else 0 end as nfc_south_won,
case when (away_team_id <> winning_team_id and winning_team_id is not null and ot.conference = "NFC" and ot.division = "South") then 1 else 0 end as nfc_south_lost,
case when (winning_team_id is null and ot.conference = "NFC" and ot.division = "South") then 1 else 0 end as nfc_south_tied,

case when (away_team_id = winning_team_id and ot.conference = "NFC" and ot.division = "East") then 1 else 0 end as nfc_east_won,
case when (away_team_id <> winning_team_id and winning_team_id is not null and ot.conference = "NFC" and ot.division = "East") then 1 else 0 end as nfc_east_lost,
case when (winning_team_id is null and ot.conference = "NFC" and ot.division = "East") then 1 else 0 end as nfc_east_tied,

case when (away_team_id = winning_team_id and ot.conference = "NFC" and ot.division = "West") then 1 else 0 end as nfc_west_won,
case when (away_team_id <> winning_team_id and winning_team_id is not null and ot.conference = "NFC" and ot.division = "West") then 1 else 0 end as nfc_west_lost,
case when (winning_team_id is null and ot.conference = "NFC" and ot.division = "West") then 1 else 0 end as nfc_west_tied

from v_schedule_and_results
join teams t on t.id=away_team_id
join teams ot on ot.id=home_team_id
where status='FINAL') gamestats
group by season,team_id;
end */;;

/*!50003 SET SESSION SQL_MODE=@OLD_SQL_MODE */;;
DELIMITER ;

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
