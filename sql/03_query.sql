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
