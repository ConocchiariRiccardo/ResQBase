USE soccorso;

DELIMITER $$

-- Trigger 1: solo gli operatori possono far parte di una squadra ovvero solo gli operatori possono essere inseriti in Partecipazione
DROP TRIGGER IF EXISTS trg_check_ruolo_operatore$$
CREATE TRIGGER trg_check_ruolo_operatore
BEFORE INSERT ON partecipazione
FOR EACH ROW
BEGIN
   DECLARE v_ruolo ENUM('admin', 'operatore'); -- variabile temporanea
   
   SELECT ruolo INTO v_ruolo -- la variabile temporanea prende il ruolo dell'utente che si sta inserendo
   FROM utente
   WHERE id = NEW.operatore_id;
   
   IF v_ruolo != 'operatore' THEN -- se non è un operatore viene bloccato tutto
      SIGNAL SQLSTATE '45000' -- lancia errore personalizzato
         SET MESSAGE_TEXT = 'Solo gli operatori possono far parte di una squadra.';
   END IF;
END $$

-- Trigger 2: deve essere presente almeno un caposquadra per missione
DROP TRIGGER IF EXISTS trg_check_caposquadra$$
CREATE TRIGGER trg_check_caposquadra
AFTER INSERT ON partecipazione
FOR EACH ROW
BEGIN
   DECLARE v_caposquadra INT; -- variabile per il caposquadra
   
   SELECT COUNT(*) INTO v_caposquadra
   FROM partecipazione
   WHERE missione_id = NEW.missione_id
      AND ruolo = 'caposquadra';
      
   IF v_caposquadra = 0 THEN -- se il numero di caposquadra è pari a 0 deve lanciare eccezione
      SIGNAL SQLSTATE '45000' 
         SET MESSAGE_TEXT = 'Ogni missione deve avere almeno un caposquadra.';
   END IF;
END$$

-- Trigger 3: quando si aggiorna una missione portando il suo stato a 'chiusa', bisogna controllare che
-- fine e livello_successivo siano valorizzati. Se mancano l'operazione si blocca
DROP TRIGGER IF EXISTS trg_check_update_missione$$
CREATE TRIGGER trg_check_update_missione
BEFORE UPDATE ON missione
FOR EACH ROW
BEGIN
  -- (ex T3) controlli sulla chiusura
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

  -- (ex T7) fine deve essere successiva all'inizio
  IF NEW.fine IS NOT NULL AND NEW.fine <= NEW.inizio THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La data di fine deve essere successiva alla data di inizio.';
  END IF;
END$$

-- T4.1: PRIMA di creare la missione, verifica che la richiesta sia attiva
DROP TRIGGER IF EXISTS trg_check_richiesta_attiva$$
CREATE TRIGGER trg_check_richiesta_attiva
BEFORE INSERT ON missione
FOR EACH ROW
BEGIN
    DECLARE v_stato ENUM('inviata','attiva','in_corso','chiusa','annullata');
    
    SELECT stato INTO v_stato
    FROM richiesta
    WHERE id = NEW.richiesta_id;
    
    IF v_stato != 'attiva' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La richiesta deve essere in stato attivo per avviare una missione.';
    END IF;
END$$

-- T4.2: DOPO la creazione, porta la richiesta a 'in_corso'
DROP TRIGGER IF EXISTS trg_aggiorna_stato_richiesta$$
CREATE TRIGGER trg_aggiorna_stato_richiesta
AFTER INSERT ON missione
FOR EACH ROW
BEGIN
    UPDATE richiesta 
    SET stato = 'in_corso'
    WHERE id = NEW.richiesta_id;
END$$

-- T4.3: DOPO la chiusura della missione, porta la richiesta a 'chiusa'
DROP TRIGGER IF EXISTS trg_chiudi_richiesta$$
CREATE TRIGGER trg_chiudi_richiesta
AFTER UPDATE ON missione
FOR EACH ROW
BEGIN
    IF NEW.stato = 'chiusa' AND OLD.stato != 'chiusa' THEN
        UPDATE richiesta 
        SET stato = 'chiusa'
        WHERE id = NEW.richiesta_id;
    END IF;
END$$

-- Trigger 5: solo gli admin possono inserire aggiornamenti
DROP TRIGGER IF EXISTS trg_check_ruolo_admin$$
CREATE TRIGGER trg_check_ruolo_admin
BEFORE INSERT ON aggiornamento
FOR EACH ROW
BEGIN
   DECLARE v_ruolo ENUM('admin', 'operatore');
   
   SELECT ruolo INTO v_ruolo
   FROM utente
   WHERE id = NEW.admin_id;
   
   IF v_ruolo != 'admin' THEN
   SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Solo gli amministratori possono inserire aggornamenti.';
   END IF;
END$$   
   
-- Trigger 6: l'origine dell'ip e l'email del segnalante non sono modificabili dopo l'inserimento
DROP TRIGGER IF EXISTS trg_check_immutabilita_richiesta$$
CREATE TRIGGER trg_check_immutabilita_richiesta
BEFORE UPDATE ON richiesta
FOR EACH ROW
BEGIN
   IF NEW.ip_origine != OLD.ip_origine THEN
   SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'L origine dell ip non è modificabile dopo l inserimento';
   END IF;
   
   IF NEW.email_segnalante != OLD.email_segnalante THEN
   SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'L email del segnalante non è modificabile dopo l inserimento';
   END IF;
END$$ 

-- Trigger 8: noi il trigger 8 lo abbiamo diviso in 3 sotto-trigger in quanto
-- rappresentano tutti e tre l'immutabilità dello storico ma in tre contesti diversi:
-- 8.1 rappresenta l'immutabilità dello storico quando la missione è chiusa,
-- 8.2 l'immutabilità dello storico per missione_mezzo e 8.3 l'immutabilità dello storico per missione_materiale

-- Trigger 8.1: 
DROP TRIGGER IF EXISTS trg_check_immutabilita_storico$$
CREATE TRIGGER trg_check_immutabilita_storico
BEFORE DELETE ON partecipazione
FOR EACH ROW
BEGIN
    DECLARE v_stato ENUM('in_corso', 'chiusa');
    
    SELECT stato INTO v_stato
    FROM missione
    WHERE id = OLD.missione_id;
    
    IF v_stato = 'chiusa' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Non è possibile modificare lo storico di una missione chiusa.';
    END IF;
END$$

-- Trigger 8.2:
DROP TRIGGER IF EXISTS trg_check_immutabilita_mezzo$$
CREATE TRIGGER trg_check_immutabilita_mezzo
BEFORE DELETE ON missione_mezzo
FOR EACH ROW
BEGIN
    DECLARE v_stato ENUM('in_corso', 'chiusa');
    
    SELECT stato INTO v_stato
    FROM missione
    WHERE id = OLD.missione_id;
    
    IF v_stato = 'chiusa' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Non è possibile modificare lo storico di una missione chiusa.';
    END IF;
END$$

-- Trigger 8.3: 
DROP TRIGGER IF EXISTS trg_check_immutabilita_materiale$$
CREATE TRIGGER trg_check_immutabilita_materiale
BEFORE DELETE ON missione_materiale
FOR EACH ROW
BEGIN
    DECLARE v_stato ENUM('in_corso', 'chiusa');
    
    SELECT stato INTO v_stato
    FROM missione
    WHERE id = OLD.missione_id;
    
    IF v_stato = 'chiusa' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Non è possibile modificare lo storico di una missione chiusa.';
    END IF;
END$$

DELIMITER ;

         