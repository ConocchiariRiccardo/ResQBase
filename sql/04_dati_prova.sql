USE soccorso;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE aggiornamento;
TRUNCATE TABLE partecipazione;
TRUNCATE TABLE missione_mezzo;
TRUNCATE TABLE missione_materiale;
TRUNCATE TABLE missione;
TRUNCATE TABLE richiesta;
TRUNCATE TABLE utente_abilita;
TRUNCATE TABLE patente;
TRUNCATE TABLE utente;
TRUNCATE TABLE mezzo;
TRUNCATE TABLE materiale;
TRUNCATE TABLE abilita;
SET FOREIGN_KEY_CHECKS = 1;

-- Utenti: 2 admin e 4 operatori
INSERT INTO utente (nome, cognome, email, password, ruolo, telefono, data_nascita) VALUES
('Giuseppe', 'Rossi',    'giuseppe.rossi@soccorso.it',  SHA2('admin123', 256), 'admin',    '3201234567', '1980-03-15'),
('Laura',    'Bianchi',  'laura.bianchi@soccorso.it',   SHA2('admin456', 256), 'admin',    '3207654321', '1985-07-22'),
('Marco',    'Verdi',    'marco.verdi@soccorso.it',     SHA2('oper123',  256), 'operatore','3291234567', '1990-05-10'),
('Anna',     'Neri',     'anna.neri@soccorso.it',       SHA2('oper456',  256), 'operatore','3297654321', '1992-09-18'),
('Luca',     'Russo',    'luca.russo@soccorso.it',      SHA2('oper789',  256), 'operatore','3281234567', '1988-12-03'),
('Sara',     'Esposito', 'sara.esposito@soccorso.it',   SHA2('oper000',  256), 'operatore','3287654321', '1995-04-27');

-- Patenti
INSERT INTO patente (tipo, data_scadenza, utente_id) VALUES
('B',       '2028-05-10', 3),
('C',       '2026-11-20', 3),
('B',       '2027-03-15', 4),
('B',       '2029-01-08', 5),
('A',       '2027-08-30', 5),
('nautica', '2026-06-15', 6);

-- Abilità
INSERT INTO abilita (nome, descrizione) VALUES
('Primo soccorso',       'Certificazione BLS e BLSD'),
('Guida mezzi pesanti',  'Abilitazione alla guida di mezzi superiori a 3.5t'),
('Subacqueo',            'Brevetto per interventi in acqua'),
('Elettricista',         'Interventi su impianti elettrici');

-- Utente_Abilita
INSERT INTO utente_abilita (utente_id, abilita_id) VALUES
(3, 1), (3, 2),
(4, 1),
(5, 3),
(6, 1), (6, 4);

-- Mezzi
INSERT INTO mezzo (nome, descrizione) VALUES
('Ambulanza A1',    'Ambulanza medicalizzata con defibrillatore'),
('Auto 4x4 B2',    'Fuoristrada per interventi in zone difficili'),
('Gommone G1',     'Imbarcazione gonfiabile per interventi in acqua');

-- Materiali
INSERT INTO materiale (nome, descrizione) VALUES
('Kit medico base',    'Bende, disinfettanti, cerotti, garze'),
('Defibrillatore',     'AED portatile con istruzioni vocali'),
('Scala telescopica',  'Scala allungabile fino a 8 metri');

-- Richieste
INSERT INTO richiesta (
    descrizione, indirizzo, latitudine, longitudine,
    nome_segnalante, email_segnalante, ip_origine,
    token_validazione, stato, creata_at, validata_at
) VALUES
(
    'Persona anziana caduta in strada',
    'Via Roma 10, L\'Aquila', 42.3498, 13.3995,
    'Carlo Esposito', 'carlo@mail.it', '192.168.1.1',
    SHA2('tok1', 256), 'chiusa',
    '2026-01-10 08:00:00', '2026-01-10 08:05:00'
),
(
    'Incidente stradale con feriti',
    'SS17 km 12, L\'Aquila', 42.3510, 13.4010,
    'Anna Giusti', 'anna@mail.it', '10.0.0.5',
    SHA2('tok2', 256), 'in_corso',
    '2026-03-15 14:00:00', '2026-03-15 14:10:00'
),
(
    'Allagamento scantinato',
    'Via Napoli 5, L\'Aquila', 42.3520, 13.3980,
    'Paolo Conti', 'paolo@mail.it', '172.16.0.3',
    SHA2('tok3', 256), 'attiva',
    '2026-04-20 10:00:00', '2026-04-20 10:15:00'
),
(
    'Persona dispersa in montagna',
    'Campo Imperatore, L\'Aquila', 42.4300, 13.5500,
    'Maria Ricci', 'maria@mail.it', '192.168.2.10',
    SHA2('tok4', 256), 'inviata',
    NOW(), NULL
);

-- Missioni
INSERT INTO missione (
    richiesta_id, obiettivo, posizione,
    inizio, fine, livello_successo, commenti, stato, admin_id
) VALUES
(
    1,
    'Prestare soccorso a persona anziana caduta',
    'Via Roma 10, L\'Aquila',
    '2026-01-10 08:30:00', '2026-01-10 10:00:00',
    5, 'Intervento riuscito, paziente trasportato in ospedale',
    'chiusa', 1
),
(
    2,
    'Gestire incidente stradale e soccorrere i feriti',
    'SS17 km 12, L\'Aquila',
    '2026-03-15 14:30:00', NULL,
    NULL, NULL,
    'in_corso', 1
);

-- Partecipazioni
INSERT INTO partecipazione (missione_id, operatore_id, ruolo) VALUES
(1, 3, 'caposquadra'),
(1, 4, 'membro'),
(2, 5, 'caposquadra'),
(2, 6, 'membro');

-- Missione_Mezzo
INSERT INTO missione_mezzo (missione_id, mezzo_id) VALUES
(1, 1),
(2, 1),
(2, 2);

-- Missione_Materiale
INSERT INTO missione_materiale (missione_id, materiale_id) VALUES
(1, 1),
(1, 2),
(2, 1);

-- Aggiornamenti
INSERT INTO aggiornamento (missione_id, admin_id, testo, inserito_il) VALUES
(1, 1, 'Squadra sul posto, paziente cosciente', '2026-01-10 08:45:00'),
(1, 1, 'Paziente stabilizzato, in attesa ambulanza', '2026-01-10 09:15:00'),
(2, 1, 'Squadra arrivata sul posto, due feriti lievi', '2026-03-15 14:45:00');