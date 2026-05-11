USE soccorso;

-- Query 1: inserimento di una richiesta di soccorso
DROP PROCEDURE IF EXISTS Query_1;
DELIMITER $$
CREATE PROCEDURE Query_1(
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
END$$
DELIMITER ;

-- Query 2: creazione di una missione connessa a una richiesta di soccorso attiva
DROP PROCEDURE IF EXISTS Query_2;
DELIMITER $$
CREATE PROCEDURE Query_2(IN p_richiesta_id INT, IN p_obiettivo TEXT, IN p_posizione VARCHAR(255))
BEGIN
    INSERT INTO missione (
        richiesta_id,
        obiettivo,
        posizione,
        inizio
    ) VALUES (
        p_richiesta_id,
        p_obiettivo,
        p_posizione,
        NOW()
    );
END$$
DELIMITER ;

-- Query 3: chiusura di una missione
DROP PROCEDURE IF EXISTS Query_3;
DELIMITER $$
CREATE PROCEDURE Query_3(IN p_missione_id INT, IN p_livello INT, IN p_commenti TEXT)
BEGIN
    UPDATE missione
    SET 
        stato            = 'chiusa',
        fine             = NOW(),
        livello_successo = p_livello,
        commenti         = p_commenti
    WHERE id = p_missione_id;
END$$
DELIMITER ;

-- Query 4: estrazione della lista degli operatori non coinvolti in missioni in corso
SELECT u.id, u.nome, u.cognome, u.email
FROM utente u
WHERE u.ruolo = 'operatore'
AND u.id NOT IN (
    SELECT p.operatore_id
    FROM partecipazione p
    JOIN missione m ON m.id = p.missione_id
    WHERE m.stato = 'in_corso'
);

-- Query 5: calcolo del numero di missioni svolte da un operatore   
SELECT u.id, u.nome, u.cognome,
       COUNT(p.missione_id) AS num_missioni
FROM utente u
LEFT JOIN partecipazione p ON p.operatore_id = u.id
WHERE u.ruolo = 'operatore'
GROUP BY u.id, u.nome, u.cognome
ORDER BY num_missioni DESC;

-- Query 6: questa query abbiamo deciso di dividerla in due sotto-query, entrambe calcolano il tempo medio
-- di svolgimento, ma la 6.1 calcola il tempo medio di svolgimento delle missioni in un anno specifico, mentre
-- la 6.2 calcola il tempo medio di svolgimento per ciascun caposquadra

-- Query 6.1:
SELECT YEAR(inizio) AS anno,
       AVG(TIMESTAMPDIFF(MINUTE, inizio, fine)) AS durata_media_minuti
FROM missione
WHERE fine IS NOT NULL
AND YEAR(inizio) = 2026
GROUP BY YEAR(inizio);

-- Query 6.2:
SELECT u.id, u.nome, u.cognome,
       AVG(TIMESTAMPDIFF(MINUTE, m.inizio, m.fine)) AS durata_media_minuti
FROM partecipazione p
JOIN missione m ON m.id = p.missione_id
JOIN utente u ON u.id = p.operatore_id
WHERE p.ruolo = 'caposquadra'
AND m.fine IS NOT NULL
GROUP BY u.id, u.nome, u.cognome
ORDER BY durata_media_minuti ASC;

-- Query 7: anche questa query è stata divisa in due sotto-query, entrambe calcolano il numero di richieste, ma la 7.1 
-- calcola il numero di richieste dallo stesso indirizzo email nelle ultime 36 ore, mentre la 7.2 calcola
-- il numero di richieste dallo stesso indirizzo IP nelle ultime 36 ore

-- Query 7.1:
SELECT email_segnalante, COUNT(*) AS num_richieste
FROM richiesta
WHERE creata_at >= NOW() - INTERVAL 36 HOUR
GROUP BY email_segnalante
ORDER BY num_richieste DESC;

-- Query 7.2:
SELECT ip_origine, COUNT(*) AS num_richieste
FROM richiesta
WHERE creata_at >= NOW() - INTERVAL 36 HOUR
GROUP BY ip_origine
ORDER BY num_richieste DESC;

-- Query 8: calcolo del tempo totale di impiego in missione di un certo operatore
DROP PROCEDURE IF EXISTS Query_8;
DELIMITER $$
CREATE PROCEDURE Query_8(IN p_operatore_id INT)
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
END$$
DELIMITER ;

-- Query 9: estrazione delle missioni svoltesi negli ultimi 3 anni nello stesso luogo di una missione data
DROP PROCEDURE IF EXISTS Query_9;
DELIMITER $$
CREATE PROCEDURE Query_9(IN p_missione_id INT)
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
END$$
DELIMITER ;

-- Query 10: estrazione della lista delle richieste chiuse con risultato non totalmente positivo
SELECT r.id, r.descrizione, r.nome_segnalante, r.email_segnalante,
       m.livello_successo, m.fine AS chiusa_il
FROM richiesta r
JOIN missione m ON m.richiesta_id = r.id
WHERE m.fine IS NOT NULL
AND m.livello_successo < 5
ORDER BY m.livello_successo ASC;

-- Query 11: estrazione degli operatori maggiormente coinvolti in missioni con esito non positivo
SELECT u.id, u.nome, u.cognome,
   COUNT(p.missione_id) AS missioni_non_positive
FROM utente u
JOIN partecipazione p ON p.operatore_id = u.id
JOIN missione m ON m.id = p.missione_id
WHERE m.fine IS NOT NULL
AND m.livello_successo < 5
GROUP BY u.id, u.nome, u.cognome
ORDER BY missioni_non_positive DESC;   

-- Query 12: estrazione dello storico delle missioni in cui è stato coinvolto un certo mezzo
DROP PROCEDURE IF EXISTS Query_12;
DELIMITER $$
CREATE PROCEDURE Query_12(IN p_mezzo_id INT)
BEGIN
    SELECT me.id AS mezzo_id, me.nome AS mezzo_nome,
           m.id AS missione_id, m.obiettivo, m.posizione,
           m.inizio, m.fine, m.livello_successo
    FROM missione_mezzo mm
    JOIN mezzo me ON me.id = mm.mezzo_id
    JOIN missione m ON m.id = mm.missione_id
    WHERE me.id = p_mezzo_id
    ORDER BY m.inizio DESC;
END$$
DELIMITER ;

-- Query 13: calcolo delle ore d'uso di un certo materiale
DROP PROCEDURE IF EXISTS Query_13;
DELIMITER $$
CREATE PROCEDURE Query_13(IN p_materiale_id INT)
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
END$$
DELIMITER ;
