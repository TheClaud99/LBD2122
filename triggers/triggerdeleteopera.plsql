CREATE OR REPLACE TRIGGER triggerDeleteOpera 
BEFORE UPDATE ON opere
FOR EACH ROW
DECLARE
    v_quanti NUMBER(10);
BEGIN
    IF (:new.eliminato = 1 AND :old.eliminato = 0) THEN
       select COUNT(*)
       into v_quanti
       from SALEOPERE
       where (DATAUSCITA is null or DATAUSCITA > CURRENT_DATE) and OPERA = :old.idopera;

       IF (v_quanti > 0) THEN
	   raise_application_error(-20000, 'l''opera '||to_char(:old.idopera)||' non puo'' essere eliminata, in quanto ancora esposta.');
       end IF;
    END IF;
END triggerDeleteOpera;
