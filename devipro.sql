-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jun 04, 2025 at 12:55 PM
-- Server version: 9.1.0
-- PHP Version: 8.3.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `devipro`
--

-- --------------------------------------------------------

--
-- Table structure for table `arrets`
--

DROP TABLE IF EXISTS `arrets`;
CREATE TABLE IF NOT EXISTS `arrets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `timestamp` datetime DEFAULT NULL,
  `ligne_id` varchar(50) DEFAULT NULL,
  `poste_id` varchar(50) DEFAULT NULL,
  `type_arret` varchar(100) DEFAULT NULL,
  `cause` text,
  `duree_minutes` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `indicateurs`
--

DROP TABLE IF EXISTS `indicateurs`;
CREATE TABLE IF NOT EXISTS `indicateurs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `timestamp` datetime NOT NULL,
  `ligne_id` varchar(50) NOT NULL,
  `TRS` decimal(5,2) DEFAULT NULL,
  `TQ` decimal(5,2) DEFAULT NULL,
  `TD` decimal(5,2) DEFAULT NULL,
  `TP` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `machine_status_events`
--

DROP TABLE IF EXISTS `machine_status_events`;
CREATE TABLE IF NOT EXISTS `machine_status_events` (
  `id` int NOT NULL AUTO_INCREMENT,
  `shift_id` int DEFAULT NULL,
  `ligne_id` varchar(20) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `status` enum('OK','HS') DEFAULT NULL,
  `raison` text,
  PRIMARY KEY (`id`),
  KEY `shift_id` (`shift_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `production_events`
--

DROP TABLE IF EXISTS `production_events`;
CREATE TABLE IF NOT EXISTS `production_events` (
  `id` int NOT NULL AUTO_INCREMENT,
  `timestamp` datetime DEFAULT NULL,
  `shift_id` int DEFAULT NULL,
  `produit_ok` int DEFAULT NULL,
  `raison_defaut` text,
  `qr_code` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `shift_id` (`shift_id`),
  KEY `timestamp` (`timestamp`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `shift_stat`
--

DROP TABLE IF EXISTS `shift_stat`;
CREATE TABLE IF NOT EXISTS `shift_stat` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` date DEFAULT NULL,
  `shift` varchar(10) DEFAULT NULL,
  `ligne_id` varchar(20) DEFAULT NULL,
  `prod` int DEFAULT '0',
  `defauts` int DEFAULT '0',
  `temps_hs` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
