CREATE OR REPLACE TRIGGER triggerUpdateVisita
    BEFORE INSERT ON ATTRAVERSAMENTO
    FOR EACH ROW
DECLARE
    varVisiteVarchi ATTRAVERSAMENTO%ROWTYPE; --mi serve per avere l'ultimo
    -- varco attraversato prima di quello che vado a inserire
    -- e che scatena il trigger
    varNuovaDurata NUMBER(10);
BEGIN
    -- seleziono l'ultimo varco attraversato
    SELECT * INTO varVisiteVarchi FROM
	   (SELECT * FROM attraversamento
	   WHERE :new.IdVisita = IdVisita
	   ORDER BY ATTRAVERSAMENTO.AttraversamentoVarco DESC)
    WHERE ROWNUM = 1;

    varNuovaDurata := TO_NUMBER(
		   :new.AttraversamentoVarco - varVisiteVarchi.AttraversamentoVarco
		   );
    -- calcolo il tempo trascorso (il TO_NUMBER serve per avere il tempo giusto
    -- altrimenti da errore)
    UPDATE visite
    SET duratavisita = duratavisita + varNuovaDurata
    WHERE visite.IdVisita = :new.IdVisita; --aggiorno la durata della visita
END triggerUpdateVisita;

--------------------------------------------------------------------------------
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
       where (DATAUSCITA is null or DATAUSCITA > CURRENT_DATE) and OPERA = old.idopera;

       IF (v_quanti > 0) THEN
	   raise_application_error(4040, 'l''opera '||to_char(:old.idopera)||' non puo'' essere eliminata, in quanto ancora esposta.');
       end IF;
    END IF;
END triggerDeleteOpera;

--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
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
       raise_application_error(4040, 'L''opera è già esposta');
    END IF;
END triggerCreateSaleOpere;

--------------------------------------------------------------------------------
create OR REPLACE trigger triggerDeleteStanza 
after update on STANZE
for each row
begin
if(:new.eliminato = 1) then
    UPDATE sale s
    SET s.eliminato = 1
    WHERE s.idStanza = :new.idStanza;

    UPDATE AMBIENTIDISERVIZIO ads
    SET ads.eliminato = 1
    WHERE ads.idStanza = :new.idStanza;
end if;
end triggerDeleteStanza;

--------------------------------------------------------------------------------
create OR REPLACE trigger triggerDeleteSalaAfter
after update on SALE
for each row
begin
    if(:new.eliminato = 1) then
	update varchi
	set varchi.eliminato = 1
	where Stanza1=:new.idstanza OR Stanza2 = :new.idstanza;
    end if;
end triggerDeleteSalaAfter;
