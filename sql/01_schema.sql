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
CREATE TABLE IF NOT EXISTS amministratore (
  utente_id INT PRIMARY KEY,

  CONSTRAINT fk_admin_utente
    FOREIGN KEY (utente_id) REFERENCES utente(id)
    ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS operatore (
  utente_id INT PRIMARY KEY,

  CONSTRAINT fk_op_utente
    FOREIGN KEY (utente_id) REFERENCES utente(id)
    ON DELETE CASCADE
);
CREATE TABLE abilita (
  id          INT          AUTO_INCREMENT PRIMARY KEY,
  nome        VARCHAR(100) NOT NULL UNIQUE,
  descrizione TEXT
);
CREATE TABLE utente_abilita (
  utente_id  INT NOT NULL,
  abilita_id INT NOT NULL,

  PRIMARY KEY (utente_id, abilita_id),

  CONSTRAINT fk_ua_utente
    FOREIGN KEY (utente_id)  REFERENCES utente(id)  ON DELETE CASCADE,
  CONSTRAINT fk_ua_abilita
    FOREIGN KEY (abilita_id) REFERENCES abilita(id) ON DELETE CASCADE
);