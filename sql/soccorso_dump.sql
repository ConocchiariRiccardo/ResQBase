-- MySQL dump 10.13  Distrib 9.3.0, for macos15 (arm64)
--
-- Host: localhost    Database: soccorso
-- ------------------------------------------------------
-- Server version	9.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `abilita`
--

DROP TABLE IF EXISTS `abilita`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `abilita` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descrizione` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nome` (`nome`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `abilita`
--

LOCK TABLES `abilita` WRITE;
/*!40000 ALTER TABLE `abilita` DISABLE KEYS */;
INSERT INTO `abilita` VALUES (1,'Primo soccorso','Certificazione BLS e BLSD'),(2,'Guida mezzi pesanti','Abilitazione alla guida di mezzi superiori a 3.5t'),(3,'Subacqueo','Brevetto per interventi in acqua'),(4,'Elettricista','Interventi su impianti elettrici');
/*!40000 ALTER TABLE `abilita` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aggiornamento`
--

DROP TABLE IF EXISTS `aggiornamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `aggiornamento` (
  `id` int NOT NULL AUTO_INCREMENT,
  `missione_id` int NOT NULL,
  `admin_id` int NOT NULL,
  `testo` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `inserito_il` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_agg_missione` (`missione_id`),
  KEY `fk_agg_admin` (`admin_id`),
  CONSTRAINT `fk_agg_admin` FOREIGN KEY (`admin_id`) REFERENCES `utente` (`id`),
  CONSTRAINT `fk_agg_missione` FOREIGN KEY (`missione_id`) REFERENCES `missione` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aggiornamento`
--

LOCK TABLES `aggiornamento` WRITE;
/*!40000 ALTER TABLE `aggiornamento` DISABLE KEYS */;
INSERT INTO `aggiornamento` VALUES (1,1,1,'Squadra sul posto, paziente cosciente','2026-01-10 07:45:00'),(2,1,1,'Paziente stabilizzato, in attesa ambulanza','2026-01-10 08:15:00'),(3,2,1,'Squadra arrivata sul posto, due feriti lievi','2026-03-15 13:45:00');
/*!40000 ALTER TABLE `aggiornamento` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_check_ruolo_admin` BEFORE INSERT ON `aggiornamento` FOR EACH ROW BEGIN
   DECLARE v_ruolo ENUM('admin', 'operatore');
   
   SELECT ruolo INTO v_ruolo
   FROM utente
   WHERE id = NEW.admin_id;
   
   IF v_ruolo != 'admin' THEN
   SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Solo gli amministratori possono inserire aggornamenti.';
   END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `materiale`
--

DROP TABLE IF EXISTS `materiale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `materiale` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descrizione` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `materiale`
--

LOCK TABLES `materiale` WRITE;
/*!40000 ALTER TABLE `materiale` DISABLE KEYS */;
INSERT INTO `materiale` VALUES (1,'Kit medico base','Bende, disinfettanti, cerotti, garze'),(2,'Defibrillatore','AED portatile con istruzioni vocali'),(3,'Scala telescopica','Scala allungabile fino a 8 metri');
/*!40000 ALTER TABLE `materiale` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mezzo`
--

DROP TABLE IF EXISTS `mezzo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mezzo` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descrizione` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mezzo`
--

LOCK TABLES `mezzo` WRITE;
/*!40000 ALTER TABLE `mezzo` DISABLE KEYS */;
INSERT INTO `mezzo` VALUES (1,'Ambulanza A1','Ambulanza medicalizzata con defibrillatore'),(2,'Auto 4x4 B2','Fuoristrada per interventi in zone difficili'),(3,'Gommone G1','Imbarcazione gonfiabile per interventi in acqua');
/*!40000 ALTER TABLE `mezzo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `missione`
--

DROP TABLE IF EXISTS `missione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `missione` (
  `id` int NOT NULL AUTO_INCREMENT,
  `richiesta_id` int NOT NULL,
  `obiettivo` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `posizione` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `inizio` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fine` datetime DEFAULT NULL,
  `livello_successo` tinyint DEFAULT NULL,
  `commenti` text COLLATE utf8mb4_unicode_ci,
  `stato` enum('in_corso','chiusa') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'in_corso',
  `admin_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `richiesta_id` (`richiesta_id`),
  KEY `admin_id` (`admin_id`),
  CONSTRAINT `missione_ibfk_1` FOREIGN KEY (`richiesta_id`) REFERENCES `richiesta` (`id`),
  CONSTRAINT `missione_ibfk_2` FOREIGN KEY (`admin_id`) REFERENCES `utente` (`id`) ON DELETE SET NULL,
  CONSTRAINT `missione_chk_1` CHECK ((`livello_successo` between 0 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `missione`
--

LOCK TABLES `missione` WRITE;
/*!40000 ALTER TABLE `missione` DISABLE KEYS */;
INSERT INTO `missione` VALUES (1,1,'Prestare soccorso a persona anziana caduta','Via Roma 10, L\'Aquila','2026-01-10 08:30:00','2026-01-10 10:00:00',5,'Intervento riuscito, paziente trasportato in ospedale','chiusa',1),(2,2,'Gestire incidente stradale e soccorrere i feriti','SS17 km 12, L\'Aquila','2026-03-15 14:30:00','2026-06-01 09:02:29',3,'Intervento completato parzialmente','chiusa',1),(3,3,'Gestire allagamento scantinato','Via Napoli 5, L\'Aquila','2026-06-01 09:02:11',NULL,NULL,NULL,'in_corso',1);
/*!40000 ALTER TABLE `missione` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_check_richiesta_attiva` BEFORE INSERT ON `missione` FOR EACH ROW BEGIN
    DECLARE v_stato ENUM('inviata','attiva','in_corso','chiusa','annullata');
    
    SELECT stato INTO v_stato
    FROM richiesta
    WHERE id = NEW.richiesta_id;
    
    IF v_stato != 'attiva' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La richiesta deve essere in stato attivo per avviare una missione.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_aggiorna_stato_richiesta` AFTER INSERT ON `missione` FOR EACH ROW BEGIN
    UPDATE richiesta 
    SET stato = 'in_corso'
    WHERE id = NEW.richiesta_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_check_update_missione` BEFORE UPDATE ON `missione` FOR EACH ROW BEGIN
  -- controlli sulla chiusura
  IF NEW.stato = 'chiusa' THEN
    IF NEW.fine IS NULL THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Per chiudere la missione bisogna specificare la data di fine.';
    END IF;
    IF NEW.livello_successo IS NULL THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Per chiudere una missione bisogna specificare il livello di successo.';
    END IF;
  END IF;

  -- fine deve essere successiva all'inizio
  IF NEW.fine IS NOT NULL AND NEW.fine <= NEW.inizio THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La data di fine deve essere successiva alla data di inizio.';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_chiudi_richiesta` AFTER UPDATE ON `missione` FOR EACH ROW BEGIN
    IF NEW.stato = 'chiusa' AND OLD.stato != 'chiusa' THEN
        UPDATE richiesta 
        SET stato = 'chiusa'
        WHERE id = NEW.richiesta_id;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `missione_materiale`
--

DROP TABLE IF EXISTS `missione_materiale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `missione_materiale` (
  `missione_id` int NOT NULL,
  `materiale_id` int NOT NULL,
  PRIMARY KEY (`missione_id`,`materiale_id`),
  KEY `fk_mmat_materiale` (`materiale_id`),
  CONSTRAINT `fk_mmat_materiale` FOREIGN KEY (`materiale_id`) REFERENCES `materiale` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_mmat_missione` FOREIGN KEY (`missione_id`) REFERENCES `missione` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `missione_materiale`
--

LOCK TABLES `missione_materiale` WRITE;
/*!40000 ALTER TABLE `missione_materiale` DISABLE KEYS */;
INSERT INTO `missione_materiale` VALUES (1,1),(2,1),(1,2);
/*!40000 ALTER TABLE `missione_materiale` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_check_immutabilita_materiale` BEFORE DELETE ON `missione_materiale` FOR EACH ROW BEGIN
    DECLARE v_stato ENUM('in_corso', 'chiusa');
    
    SELECT stato INTO v_stato
    FROM missione
    WHERE id = OLD.missione_id;
    
    IF v_stato = 'chiusa' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Non è possibile modificare lo storico di una missione chiusa.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `missione_mezzo`
--

DROP TABLE IF EXISTS `missione_mezzo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `missione_mezzo` (
  `missione_id` int NOT NULL,
  `mezzo_id` int NOT NULL,
  PRIMARY KEY (`missione_id`,`mezzo_id`),
  KEY `fk_mm_mezzo` (`mezzo_id`),
  CONSTRAINT `fk_mm_mezzo` FOREIGN KEY (`mezzo_id`) REFERENCES `mezzo` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_mm_missione` FOREIGN KEY (`missione_id`) REFERENCES `missione` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `missione_mezzo`
--

LOCK TABLES `missione_mezzo` WRITE;
/*!40000 ALTER TABLE `missione_mezzo` DISABLE KEYS */;
INSERT INTO `missione_mezzo` VALUES (1,1),(2,1),(2,2);
/*!40000 ALTER TABLE `missione_mezzo` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_check_immutabilita_mezzo` BEFORE DELETE ON `missione_mezzo` FOR EACH ROW BEGIN
    DECLARE v_stato ENUM('in_corso', 'chiusa');
    
    SELECT stato INTO v_stato
    FROM missione
    WHERE id = OLD.missione_id;
    
    IF v_stato = 'chiusa' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Non è possibile modificare lo storico di una missione chiusa.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `partecipazione`
--

DROP TABLE IF EXISTS `partecipazione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `partecipazione` (
  `missione_id` int NOT NULL,
  `operatore_id` int NOT NULL,
  `ruolo` enum('caposquadra','membro') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'membro',
  PRIMARY KEY (`missione_id`,`operatore_id`),
  KEY `fk_part_operatore` (`operatore_id`),
  CONSTRAINT `fk_part_missione` FOREIGN KEY (`missione_id`) REFERENCES `missione` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_part_operatore` FOREIGN KEY (`operatore_id`) REFERENCES `utente` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `partecipazione`
--

LOCK TABLES `partecipazione` WRITE;
/*!40000 ALTER TABLE `partecipazione` DISABLE KEYS */;
INSERT INTO `partecipazione` VALUES (1,3,'caposquadra'),(1,4,'membro'),(2,5,'caposquadra'),(2,6,'membro');
/*!40000 ALTER TABLE `partecipazione` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_check_ruolo_operatore` BEFORE INSERT ON `partecipazione` FOR EACH ROW BEGIN
   DECLARE v_ruolo ENUM('admin', 'operatore'); -- variabile temporanea
   
   SELECT ruolo INTO v_ruolo -- la variabile temporanea prende il ruolo dell'utente che si sta inserendo
   FROM utente
   WHERE id = NEW.operatore_id;
   
   IF v_ruolo != 'operatore' THEN -- se non è un operatore viene bloccato tutto
      SIGNAL SQLSTATE '45000' -- lancia errore personalizzato
         SET MESSAGE_TEXT = 'Solo gli operatori possono far parte di una squadra.';
   END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_check_caposquadra` AFTER INSERT ON `partecipazione` FOR EACH ROW BEGIN
   DECLARE v_caposquadra INT; -- variabile per il caposquadra
   
   SELECT COUNT(*) INTO v_caposquadra
   FROM partecipazione
   WHERE missione_id = NEW.missione_id
      AND ruolo = 'caposquadra';
      
   IF v_caposquadra = 0 THEN -- se il numero di caposquadra è pari a 0 deve lanciare eccezione
      SIGNAL SQLSTATE '45000' 
         SET MESSAGE_TEXT = 'Ogni missione deve avere almeno un caposquadra.';
   END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_check_immutabilita_storico` BEFORE DELETE ON `partecipazione` FOR EACH ROW BEGIN
    DECLARE v_stato ENUM('in_corso', 'chiusa');
    
    SELECT stato INTO v_stato
    FROM missione
    WHERE id = OLD.missione_id;
    
    IF v_stato = 'chiusa' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Non è possibile modificare lo storico di una missione chiusa.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `patente`
--

DROP TABLE IF EXISTS `patente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patente` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tipo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `data_scadenza` date DEFAULT NULL,
  `utente_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `utente_id` (`utente_id`),
  CONSTRAINT `patente_ibfk_1` FOREIGN KEY (`utente_id`) REFERENCES `utente` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patente`
--

LOCK TABLES `patente` WRITE;
/*!40000 ALTER TABLE `patente` DISABLE KEYS */;
INSERT INTO `patente` VALUES (1,'B','2028-05-10',3),(2,'C','2026-11-20',3),(3,'B','2027-03-15',4),(4,'B','2029-01-08',5),(5,'A','2027-08-30',5),(6,'nautica','2026-06-15',6);
/*!40000 ALTER TABLE `patente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `richiesta`
--

DROP TABLE IF EXISTS `richiesta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `richiesta` (
  `id` int NOT NULL AUTO_INCREMENT,
  `descrizione` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `indirizzo` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitudine` decimal(9,6) DEFAULT NULL,
  `longitudine` decimal(9,6) DEFAULT NULL,
  `nome_segnalante` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_segnalante` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip_origine` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token_validazione` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `creata_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `validata_at` datetime DEFAULT NULL,
  `stato` enum('inviata','attiva','in_corso','chiusa','annullata') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'inviata',
  `foto_path` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token_validazione` (`token_validazione`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `richiesta`
--

LOCK TABLES `richiesta` WRITE;
/*!40000 ALTER TABLE `richiesta` DISABLE KEYS */;
INSERT INTO `richiesta` VALUES (1,'Persona anziana caduta in strada','Via Roma 10, L\'Aquila',42.349800,13.399500,'Carlo Esposito','carlo@mail.it','192.168.1.1','80b3ad2d438bfafa1ea690c5a59f54548dcc76ad6a839c6704ac1d9d565d9c80','2026-01-10 08:00:00','2026-01-10 08:05:00','chiusa',NULL),(2,'Incidente stradale con feriti','SS17 km 12, L\'Aquila',42.351000,13.401000,'Anna Giusti','anna@mail.it','10.0.0.5','8690c3af015e6294ff67fcfd334f181a4704b579e9b2bce79ec9716ac62da2d6','2026-03-15 14:00:00','2026-03-15 14:10:00','chiusa',NULL),(3,'Allagamento scantinato','Via Napoli 5, L\'Aquila',42.352000,13.398000,'Paolo Conti','paolo@mail.it','172.16.0.3','0de90da5aa026ef0c704b7a7c6eed5981af4f7c5c95539afc605a621f39e1c13','2026-04-20 10:00:00','2026-06-01 09:02:11','in_corso',NULL),(4,'Persona dispersa in montagna','Campo Imperatore, L\'Aquila',42.430000,13.550000,'Maria Ricci','maria@mail.it','192.168.2.10','479b2f01fa93f6cf14c1e3bb176cd5df8c29c6b8eb164ea2962984d61f667996','2026-06-01 09:01:38',NULL,'inviata',NULL),(5,'Incendio in appartamento','Via Verdi 20, L\'Aquila',42.350000,13.399000,'Luigi Bianchi','luigi@mail.it','192.168.1.50','5d091c4653f6d4c246adb53617ae8cdb3c4789b3e35038e8e5b285ed5fbef01b','2026-06-01 09:01:48',NULL,'inviata',NULL);
/*!40000 ALTER TABLE `richiesta` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_check_immutabilita_richiesta` BEFORE UPDATE ON `richiesta` FOR EACH ROW BEGIN
   IF NEW.ip_origine != OLD.ip_origine THEN
   SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'L origine dell ip non è modificabile dopo l inserimento';
   END IF;
   
   IF NEW.email_segnalante != OLD.email_segnalante THEN
   SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'L email del segnalante non è modificabile dopo l inserimento';
   END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `utente`
--

DROP TABLE IF EXISTS `utente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utente` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cognome` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ruolo` enum('admin','operatore') COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `creato_il` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `creato_da` int DEFAULT NULL,
  `data_nascita` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `creato_da` (`creato_da`),
  CONSTRAINT `utente_ibfk_1` FOREIGN KEY (`creato_da`) REFERENCES `utente` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utente`
--

LOCK TABLES `utente` WRITE;
/*!40000 ALTER TABLE `utente` DISABLE KEYS */;
INSERT INTO `utente` VALUES (1,'Giuseppe','Rossi','giuseppe.rossi@soccorso.it','240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9','admin','3201234567','2026-06-01 09:01:38',NULL,'1980-03-15'),(2,'Laura','Bianchi','laura.bianchi@soccorso.it','becf77f3ec82a43422b7712134d1860e3205c6ce778b08417a7389b43f2b4661','admin','3207654321','2026-06-01 09:01:38',NULL,'1985-07-22'),(3,'Marco','Verdi','marco.verdi@soccorso.it','13a93f9a5502e71eed80a806f87bc4424e03e6b0d90acd513ea9d561c853b738','operatore','3291234567','2026-06-01 09:01:38',NULL,'1990-05-10'),(4,'Anna','Neri','anna.neri@soccorso.it','29093164efff44e1c0ba8c4c1883eeaf7b88603813d6f088afd0d197cfcb9383','operatore','3297654321','2026-06-01 09:01:38',NULL,'1992-09-18'),(5,'Luca','Russo','luca.russo@soccorso.it','cadfa070005b2ac0f945c93fc4be4ad98f36ef809bef0eedb8358b1b96e4abca','operatore','3281234567','2026-06-01 09:01:38',NULL,'1988-12-03'),(6,'Sara','Esposito','sara.esposito@soccorso.it','7638f077fd875f1d752ae9d03feb8c072d1966885fa709267b018ce515cb1a36','operatore','3287654321','2026-06-01 09:01:38',NULL,'1995-04-27');
/*!40000 ALTER TABLE `utente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utente_abilita`
--

DROP TABLE IF EXISTS `utente_abilita`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utente_abilita` (
  `utente_id` int NOT NULL,
  `abilita_id` int NOT NULL,
  PRIMARY KEY (`utente_id`,`abilita_id`),
  KEY `fk_ua_abilita` (`abilita_id`),
  CONSTRAINT `fk_ua_abilita` FOREIGN KEY (`abilita_id`) REFERENCES `abilita` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ua_utente` FOREIGN KEY (`utente_id`) REFERENCES `utente` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utente_abilita`
--

LOCK TABLES `utente_abilita` WRITE;
/*!40000 ALTER TABLE `utente_abilita` DISABLE KEYS */;
INSERT INTO `utente_abilita` VALUES (3,1),(4,1),(6,1),(3,2),(5,3),(6,4);
/*!40000 ALTER TABLE `utente_abilita` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'soccorso'
--
/*!50003 DROP PROCEDURE IF EXISTS `Query_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Query_1`(
    IN p_descrizione TEXT,
    IN p_indirizzo VARCHAR(255),
    IN p_lat DECIMAL(9,6),
    IN p_lng DECIMAL(9,6),
    IN p_nome_segnalante VARCHAR(200),
    IN p_email_segnalante VARCHAR(255),
    IN p_ip VARCHAR(45),
    IN p_foto VARCHAR(500)
)
BEGIN
    INSERT INTO richiesta (
        descrizione, indirizzo, latitudine, longitudine,
        nome_segnalante, email_segnalante, ip_origine,
        foto_path, token_validazione, stato
    ) VALUES (
        p_descrizione, p_indirizzo, p_lat, p_lng,
        p_nome_segnalante, p_email_segnalante, p_ip,
        p_foto,
        SHA2(CONCAT(p_email_segnalante, NOW(), RAND()), 256),
        'inviata'
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Query_10` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Query_10`()
BEGIN
    SELECT r.id, r.descrizione, r.nome_segnalante, r.email_segnalante,
           m.livello_successo, m.fine AS chiusa_il
    FROM richiesta r
    JOIN missione m ON m.richiesta_id = r.id
    WHERE m.fine IS NOT NULL
    AND m.livello_successo < 5
    ORDER BY m.livello_successo ASC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Query_11` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Query_11`()
BEGIN
    SELECT u.id, u.nome, u.cognome,
           COUNT(p.missione_id) AS missioni_non_positive
    FROM utente u
    JOIN partecipazione p ON p.operatore_id = u.id
    JOIN missione m ON m.id = p.missione_id
    WHERE m.fine IS NOT NULL
    AND m.livello_successo < 5
    GROUP BY u.id, u.nome, u.cognome
    ORDER BY missioni_non_positive DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Query_12` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Query_12`(IN p_mezzo_id INT)
BEGIN
    SELECT me.id AS mezzo_id, me.nome AS mezzo_nome,
           m.id AS missione_id, m.obiettivo, m.posizione,
           m.inizio, m.fine, m.livello_successo
    FROM missione_mezzo mm
    JOIN mezzo me ON me.id = mm.mezzo_id
    JOIN missione m ON m.id = mm.missione_id
    WHERE me.id = p_mezzo_id
    ORDER BY m.inizio DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Query_13` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Query_13`(IN p_materiale_id INT)
BEGIN
    SELECT ma.id AS materiale_id, ma.nome AS materiale_nome,
           SUM(TIMESTAMPDIFF(MINUTE, m.inizio, m.fine)) AS minuti_uso,
           ROUND(SUM(TIMESTAMPDIFF(MINUTE, m.inizio, m.fine)) / 60.0, 2) AS ore_uso
    FROM missione_materiale mm
    JOIN materiale ma ON ma.id = mm.materiale_id
    JOIN missione m ON m.id = mm.missione_id
    WHERE m.fine IS NOT NULL
    AND ma.id = p_materiale_id
    GROUP BY ma.id, ma.nome;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Query_2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Query_2`(
    IN p_richiesta_id INT,
    IN p_obiettivo TEXT,
    IN p_posizione VARCHAR(255),
    IN p_admin_id INT
)
BEGIN
    UPDATE richiesta SET stato = 'attiva', validata_at = NOW()
    WHERE id = p_richiesta_id;

    INSERT INTO missione (
        richiesta_id, obiettivo, posizione, inizio, admin_id
    ) VALUES (
        p_richiesta_id, p_obiettivo, p_posizione, NOW(), p_admin_id
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Query_3` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Query_3`(IN p_missione_id INT, IN p_livello INT, IN p_commenti TEXT)
BEGIN
    UPDATE missione
    SET 
        stato            = 'chiusa',
        fine             = NOW(),
        livello_successo = p_livello,
        commenti         = p_commenti
    WHERE id = p_missione_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Query_4` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Query_4`()
BEGIN
    SELECT u.id, u.nome, u.cognome, u.email
    FROM utente u
    WHERE u.ruolo = 'operatore'
    AND u.id NOT IN (
        SELECT p.operatore_id
        FROM partecipazione p
        JOIN missione m ON m.id = p.missione_id
        WHERE m.stato = 'in_corso'
    );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Query_5` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Query_5`()
BEGIN
    SELECT u.id, u.nome, u.cognome,
           COUNT(p.missione_id) AS num_missioni
    FROM utente u
    LEFT JOIN partecipazione p ON p.operatore_id = u.id
    WHERE u.ruolo = 'operatore'
    GROUP BY u.id, u.nome, u.cognome
    ORDER BY num_missioni DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Query_6_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Query_6_1`(IN p_anno INT)
BEGIN
    SELECT YEAR(inizio) AS anno,
           AVG(TIMESTAMPDIFF(MINUTE, inizio, fine)) AS durata_media_minuti
    FROM missione
    WHERE fine IS NOT NULL
    AND YEAR(inizio) = p_anno
    GROUP BY YEAR(inizio);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Query_6_2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Query_6_2`()
BEGIN
    SELECT u.id, u.nome, u.cognome,
           AVG(TIMESTAMPDIFF(MINUTE, m.inizio, m.fine)) AS durata_media_minuti
    FROM partecipazione p
    JOIN missione m ON m.id = p.missione_id
    JOIN utente u ON u.id = p.operatore_id
    WHERE p.ruolo = 'caposquadra'
    AND m.fine IS NOT NULL
    GROUP BY u.id, u.nome, u.cognome
    ORDER BY durata_media_minuti ASC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Query_7_1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Query_7_1`()
BEGIN
    SELECT email_segnalante, COUNT(*) AS num_richieste
    FROM richiesta
    WHERE creata_at >= NOW() - INTERVAL 36 HOUR
    GROUP BY email_segnalante
    ORDER BY num_richieste DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Query_7_2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Query_7_2`()
BEGIN
    SELECT ip_origine, COUNT(*) AS num_richieste
    FROM richiesta
    WHERE creata_at >= NOW() - INTERVAL 36 HOUR
    GROUP BY ip_origine
    ORDER BY num_richieste DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Query_8` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Query_8`(IN p_operatore_id INT)
BEGIN
    SELECT u.id, u.nome, u.cognome,
           SUM(TIMESTAMPDIFF(MINUTE, m.inizio, m.fine)) AS minuti_totali,
           ROUND(SUM(TIMESTAMPDIFF(MINUTE, m.inizio, m.fine)) / 60.0, 2) AS ore_totali
    FROM utente u
    JOIN partecipazione p ON p.operatore_id = u.id
    JOIN missione m ON m.id = p.missione_id
    WHERE m.fine IS NOT NULL
    AND u.id = p_operatore_id
    GROUP BY u.id, u.nome, u.cognome;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Query_9` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Query_9`(IN p_missione_id INT)
BEGIN
    SELECT m.*
    FROM missione m
    WHERE m.posizione = (
        SELECT posizione
        FROM missione
        WHERE id = p_missione_id
    )
    AND m.id != p_missione_id
    AND m.inizio >= NOW() - INTERVAL 3 YEAR;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-01 11:55:41
