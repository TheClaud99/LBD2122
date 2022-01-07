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
