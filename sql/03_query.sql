USE soccorso;

-- Query 1: inserimento di una richiesta di soccorso
INSERT INTO richiesta(
   descrizione,
   indirizzo,
   latitudine,
   longitudine,
   nome_segnalante,
   email_segnalante,
   ip_origine,
   foto_path,
   token_validazione,
   stato
   ) VALUES('Persona ferita in seguito a incidente stradale',
    'Via Roma 10, L\'Aquila',
    42.3498,
    13.3995,
    'Mario Rossi',
    'mario.rossi@email.it',
    '192.168.1.1',
    NULL,
    SHA2(CONCAT('mario.rossi@email.it', NOW(), RAND()), 256),
    'inviata'
);

-- Query 2: creazione di una missione connessa a una richiesta di soccorso attiva
UPDATE richiesta SET stato = 'attiva' WHERE id = 1;

INSERT INTO missione (
   richiesta_id,
   obiettivo,
   posizione,
   inizio
) VALUES (
   1,
   'Prestare soccorso alla persone ferita',
   'Via Roma 10, L Aquila',
   NOW()
);

-- Query 3: chiusura di una missione
UPDATE missione
SET 
   stato = 'chiusa',
   fine = NOW(),
   livello_successo = 4,
   commenti = 'Intervento completato con successo'
WHERE id = 1;

   

