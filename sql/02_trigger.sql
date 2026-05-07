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
DROP TRIGGER IF EXISTS trg_check_chiusura_missione$$
CREATE TRIGGER trg_check_chiusura_missione
BEFORE UPDATE ON missione
FOR EACH ROW
BEGIN
  IF NEW.stato = 'chiusa' THEN
     IF NEW.fine IS NULL THEN
        SIGNAL SQLSTATE '45000'
           SET MESSAGE_TEXT = 'Per chiudere la missione bisogna specificare la data di fine.';
	 END IF;
     
     IF NEW.livello_successo IS NULL THEN
        SIGNAL SQLSTATE '45000'
           SET MESSAGE_TEXT = 'Per chiudere una missione bisogna specificare il livello successivo.';
	 END IF;
  END IF;
END$$ 

DELIMITER ;

         