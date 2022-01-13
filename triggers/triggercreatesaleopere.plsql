CREATE OR REPLACE TRIGGER triggerCreateSaleOpere 
BEFORE INSERT ON SALEOPERE
FOR EACH ROW
DECLARE
    v_quanti NUMBER(10);
BEGIN
    SELECT COUNT(*)
    INTO v_quanti
    FROM saleopere so
    WHERE (so.datauscita > SYSDATE OR so.datauscita IS NULL)
	  AND so.Opera = :new.Opera;

    IF (v_quanti > 0) THEN
       raise_application_error(-20000, 'L''opera è già esposta');
    END IF;
END triggerCreateSaleOpere;
