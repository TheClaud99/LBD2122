CREATE OR REPLACE TRIGGER triggerDeleteSalaBefore 
BEFORE UPDATE ON SALE
FOR EACH ROW
DECLARE
    v_quanti NUMBER(10);
BEGIN
    IF (:new.eliminato = 1 AND :old.eliminato = 0) THEN
	SELECT COUNT(*)
	INTO v_quanti
	FROM sale JOIN saleopere ON sale.idstanza = saleopere.sala
	WHERE sale.idstanza = :new.idstanza AND
	      (saleopere.datauscita IS NULL OR saleopere.datauscita > SYSDATE);

	IF (v_quanti > 0) THEN
		raise_application_error(4040, 'la sala '||to_char(:new.idstanza)||' non puo'' essere eliminata.');
	END IF;
    END IF;
END triggerDeleteSalaBefore;