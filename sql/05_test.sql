USE soccorso;

-- Verifica dati di base
SELECT * FROM utente;
SELECT * FROM richiesta;
SELECT * FROM missione;
SELECT * FROM partecipazione;

-- Test Query 1: inserimento nuova richiesta
CALL Query_1(
    'Incendio in appartamento',
    'Via Verdi 20, L\'Aquila',
    42.3500, 13.3990,
    'Luigi Bianchi',
    'luigi@mail.it',
    '192.168.1.50',
    NULL
);
SELECT * FROM richiesta; -- verifica che la nuova richiesta sia stata inserita

-- Test Query 2: crea missione sulla richiesta 3 (attiva)
CALL Query_2(3, 'Gestire allagamento scantinato', 'Via Napoli 5, L\'Aquila', 1);
SELECT * FROM missione; -- verifica che la missione sia stata creata

-- Test Query 3: chiudi la missione 2
CALL Query_3(2, 3, 'Intervento completato parzialmente');
SELECT * FROM missione; -- verifica che la missione sia chiusa

-- Test Query 4: operatori non coinvolti in missioni in corso
CALL Query_4();

-- Test Query 5: numero missioni per operatore
CALL Query_5();

-- Test Query 6.1: tempo medio missioni nel 2026
CALL Query_6_1(2026);

-- Test Query 6.2: tempo medio per caposquadra
CALL Query_6_2();

-- Test Query 7.1: richieste per email nelle ultime 36 ore
CALL Query_7_1();

-- Test Query 7.2: richieste per IP nelle ultime 36 ore
CALL Query_7_2();

-- Test Query 8: tempo totale operatore Marco Verdi (id=3)
CALL Query_8(3);

-- Test Query 9: missioni nello stesso luogo della missione 1
CALL Query_9(1);

-- Test Query 10: richieste chiuse con esito negativo
CALL Query_10();

-- Test Query 11: operatori in missioni con esito negativo
CALL Query_11();

-- Test Query 12: storico missioni Ambulanza A1 (id=1)
CALL Query_12(1);

-- Test Query 13: ore uso Kit medico base (id=1)
CALL Query_13(1);