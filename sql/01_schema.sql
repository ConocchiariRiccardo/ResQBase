DROP DATABASE IF EXISTS soccorso;

CREATE DATABASE IF NOT EXISTS soccorso
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE soccorso;

CREATE TABLE IF NOT EXISTS Utente (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    nome         VARCHAR(100)  NOT NULL,
    cognome      VARCHAR(100)  NOT NULL,
    email        VARCHAR(255)  NOT NULL UNIQUE,
    password     VARCHAR(255)  NOT NULL,
    ruolo        ENUM('admin', 'operatore') NOT NULL,
    telefono     VARCHAR(20),
    creato_il    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creato_da    INT,
    data_nascita DATE,
    FOREIGN KEY (creato_da) REFERENCES Utente(id)
        ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS Patente(
    id             INT AUTO_INCREMENT PRIMARY KEY,
    tipo           VARCHAR(50)  NOT NULL,
    data_scadenza  DATE,
    utente_id      INT          NOT NULL,
    FOREIGN KEY (utente_id) REFERENCES Utente(id)
        ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS Abilita (
  id          INT          AUTO_INCREMENT PRIMARY KEY,
  nome        VARCHAR(100) NOT NULL UNIQUE,
  descrizione TEXT
);
CREATE TABLE IF NOT EXISTS Utente_abilita (
  utente_id  INT NOT NULL,
  abilita_id INT NOT NULL,

  PRIMARY KEY (utente_id, abilita_id),

  CONSTRAINT fk_ua_utente
    FOREIGN KEY (utente_id)  REFERENCES utente(id)  ON DELETE CASCADE,
  CONSTRAINT fk_ua_abilita
    FOREIGN KEY (abilita_id) REFERENCES abilita(id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS Mezzo (
id          INT AUTO_INCREMENT PRIMARY KEY,
    nome        VARCHAR(150) NOT NULL,
    descrizione TEXT
);

CREATE TABLE IF NOT EXISTS Materiale (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    nome        VARCHAR(150) NOT NULL,
    descrizione TEXT
);
CREATE TABLE IF NOT EXISTS Richiesta (
  id                INT          AUTO_INCREMENT PRIMARY KEY,
  descrizione       TEXT         NOT NULL,
  indirizzo         VARCHAR(255),
  latitudine        DECIMAL(9,6),
  longitudine       DECIMAL(9,6),
  nome_segnalante   VARCHAR(200) NOT NULL,
  email_segnalante  VARCHAR(255) NOT NULL,
  ip_origine        VARCHAR(45)  NOT NULL,
  token_validazione VARCHAR(128) NOT NULL UNIQUE,
  creata_at         DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  validata_at       DATETIME,
  stato             ENUM('inviata','attiva','in_corso','chiusa','annullata')
                                 NOT NULL DEFAULT 'inviata',
  foto_path         VARCHAR(500)
);
CREATE TABLE IF NOT EXISTS Missione (
id               INT AUTO_INCREMENT PRIMARY KEY,
    richiesta_id     INT          NOT NULL UNIQUE,
    obiettivo        TEXT         NOT NULL,
    posizione        VARCHAR(255),
    inizio           DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fine             DATETIME,
    livello_successo TINYINT      CHECK (livello_successo BETWEEN 0 AND 5),
    commenti         TEXT,
    stato            ENUM('in_corso','chiusa') NOT NULL DEFAULT 'in_corso',
    admin_id         INT,
    FOREIGN KEY (richiesta_id) REFERENCES Richiesta(id),
    FOREIGN KEY (admin_id)     REFERENCES Utente(id)
        ON DELETE SET NULL
);
CREATE TABLE partecipazione (
  missione_id  INT NOT NULL,
  operatore_id INT NOT NULL,
  ruolo        ENUM('caposquadra','membro') NOT NULL DEFAULT 'membro',

  PRIMARY KEY (missione_id, operatore_id),

  CONSTRAINT fk_part_missione
    FOREIGN KEY (missione_id)  REFERENCES missione(id)   ON DELETE CASCADE,
  CONSTRAINT fk_part_operatore
    FOREIGN KEY (operatore_id) REFERENCES utente(id)     ON DELETE CASCADE
);