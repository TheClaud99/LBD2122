CREATE OR REPLACE PACKAGE BODY AcquistaBiglietto AS

PROCEDURE AcquistoBiglietto(
 	sessionID NUMBER DEFAULT 0,
	dataEmiss VARCHAR2 DEFAULT NULL,
	dataScad VARCHAR2 DEFAULT NULL,
	nomeUtente VARCHAR2 DEFAULT NULL,
	cognomeUtente VARCHAR2 DEFAULT NULL,
	idutenteselezionato NUMBER DEFAULT NULL,
	idmuseoselezionato NUMBER DEFAULT NULL,
	
	tipologiaTitolo VARCHAR2 DEFAULT NULL,
	idtitoloselezionato VARCHAR2 DEFAULT NULL,
	convalida NUMBER DEFAULT NULL
) IS
	varIdUtente NUMBER(5);
	varIdMuseo NUMBER(5);
	NomeMuseo VARCHAR2 DEFAULT NULL;

BEGIN

    MODGUI1.ApriPagina('Acquisto Biglietto', 0);
	
	MODGUI1.Header();
	HTP.header(1,'Inserisci un nuovo biglietto', 'center');
	MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%;"');

	if convalida is null
		MODGUI1.ApriForm('gruppo1.ConfermaAcquistoBiglietto');
		HTP.FORMHIDDEN('sessionID',0);
    	MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%;"');
		MODGUI1.Label('Data Emissione*');
		MODGUI1.InputDate('dataEmiss', 'Data emissione');
		HTP.BR;
		MODGUI1.Label('Data Scadenza*');
		MODGUI1.InputDate('dataScad', 'Data Scadenza');
		HTP.BR;
	
		MODGUI1.Label('Utente');
		MODGUI1.SelectOpen('idutenteselezionato');
		for utente in (SELECT IdUtente from UTENTIMUSEO)
			loop
				SELECT IdUtente, Nome, Cognome INTO varIdUtente, nomeUtente, cognomeUtente
				FROM UTENTI
				where IdUtente=utente.IdUtente;
				MODGUI1.SelectOption(varIdUtente, ''|| nomeUtente ||' '||cognomeUtente||'');
			end loop;
		MODGUI1.SelectClose();
		HTP.BR;
	
		MODGUI1.Label('Museo');
		MODGUI1.SelectOpen('idmuseoselezionato', 'museo-selezionato');
	    for museo in (SELECT IdMuseo from MUSEI)
	    	loop
	        	SELECT IdMuseo, Nome INTO varIdMuseo, NomeMuseo
	        	FROM MUSEI
	        	WHERE IdMuseo=museo.IdMuseo;
	        	MODGUI1.SelectOption(varIdMuseo, NomeMuseo);
	    	end loop;
    	MODGUI1.SelectClose();

    	MODGUI1.Label('Tipologia di Ingresso');
    	MODGUI1.SelectOpen()
    	for tipologia in (SELECT Tipologieingressomusei.IdTipologiaIng, Nome FROM TIPOLOGIEINGRESSOMUSEI, TIPOLOGIEINGRESSO
						 WHERE IdMuseo=idmuseoselezionato AND TIPOLOGIEINGRESSOMUSEI.IdTipologiaIng=TIPOLOGIEINGRESSO.IdTipologiaIng)
		loop
			MODGUI1.SelectOption(tipologia.IdTipologiaIng, tipologia.Nome)
		end loop;
		htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit" name="convalida" value="1">Acquista</button>')
    	MODGUI1.ChiudiDiv();
		MODGUI1.ChiudiForm();
	
	MODGUI1.ChiudiDiv();
	htp.prn('<script>
            document.getElementById("museo-selezionato").onchange = function inviaFormCreaMuseo() {
                document.AcquistaBiglietto.submit();
            }
        </script>');
	HTP.BodyClose;
	HTP.HtmlClose;

END;

-- Procedura per confermare i dati dell'inserimento di un Utente
PROCEDURE ConfermaAcquistoBiglietto(
	sessionID NUMBER DEFAULT 0,
	dataEmiss VARCHAR2 DEFAULT NULL,
	dataScad VARCHAR2 DEFAULT NULL,
	nomeUtente VARCHAR2 DEFAULT NULL,
	cognomeUtente VARCHAR2 DEFAULT NULL,
	varIdUtente NUMBER DEFAULT NULL,
	varIdMuseo NUMBER DEFAULT NULL,
	NomeMuseo VARCHAR2 DEFAULT NULL
) IS
BEGIN
	-- se utente non autorizzato: messaggio errore
	IF nomeUtente IS NULL 
	OR cognomeUtente IS NULL 
	OR (dataEmiss IS NOT NULL 
		AND to_date(dataEmiss, 'YYYY-MM-DD') > sysdate)
	OR (dataScad IS NOT NULL
		AND to_date(dataScad, 'YYYY-MM-DD') < sysdate)
	OR (dataEmiss IS NOT NULL AND dataScad IS NOT NULL
		AND to_date(dataEmiss, 'YYYY-MM-DD') > to_date(dataScad, 'YYYY-MM-DD'))
	OR cognomeUtente IS NULL
    OR nomeUtente IS NULL
	OR varIdUtente IS NULL
	OR varIdMuseo IS NULL
	OR NomeMuseo IS NULL
	THEN
		-- uno dei parametri con vincoli ha valori non validi
		MODGUI1.APRIPAGINA('Pagina errore', 0);
		HTP.BodyOpen;
		MODGUI1.ApriDiv;
		HTP.PRINT('Uno dei parametri immessi non valido');
		MODGUI1.ChiudiDiv;
		HTP.BodyClose;
		HTP.HtmlClose;
	ELSE
		MODGUI1.APRIPAGINA('Pagina OK', 0);
		HTP.BodyOpen;
		HTP.header(1, 'Conferma immissione dati');

		MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%;"');
		HTP.header(2, 'Nuovo utente');

		HTP.TableOpen;
		HTP.TableRowOpen;
		HTP.TableData('Nome utente: ');
		HTP.TableData(nomeUtente);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Cognome utente: ');
		HTP.TableData(cognomeUtente);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Nome Museo: ');
		HTP.TableData(NomeMuseo);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Data Emissione biglietto: ');
		HTP.TableData(dataEmiss);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Data Scadenza biglietto: ');
		HTP.TableData(dataScad);
		HTP.TableRowClose;

		MODGUI1.ApriForm('InserisciDatiBigliettoAcquistato');
		HTP.FORMHIDDEN('sessionID', 0);
		HTP.FORMHIDDEN('NomeUtente', nomeUtente);
		HTP.FORMHIDDEN('CognomeUtente', cognomeUtente);
		HTP.FORMHIDDEN('IDUtente', varIdUtente);
		HTP.FORMHIDDEN('DataEmissione', dataEmiss);
		HTP.FORMHIDDEN('DataScadenza', dataScad);
		HTP.FORMHIDDEN('NomeMuseo', nomeMuseo);
        HTP.FORMHIDDEN('IDMuseo', varIdMuseo);
		MODGUI1.InputSubmit('Conferma');
		MODGUI1.ChiudiForm;
		MODGUI1.Collegamento('Annulla', 'InserisciUtente', 'w3-btn');
		MODGUI1.ChiudiDiv;
		HTP.BodyClose;
		HTP.HtmlClose;
	END IF;
	EXCEPTION WHEN OTHERS THEN
		dbms_output.put_line('Error: '||sqlerrm);
END;

PROCEDURE InserisciDatiBigliettoAcquistato (
    sessionID NUMBER DEFAULT 0,
	dataEmiss VARCHAR2 DEFAULT NULL,
	dataScad VARCHAR2 DEFAULT NULL,
	nomeUtente VARCHAR2 DEFAULT NULL,
	cognomeUtente VARCHAR2 DEFAULT NULL,
	varIdUtente NUMBER DEFAULT NULL,
	varIdMuseo NUMBER DEFAULT NULL,
	NomeMuseo VARCHAR2 DEFAULT NULL
) IS 
    emiss DATE := TO_DATE(dataEmiss default NULL on conversion error, 'YYYY-MM-DD');
	scad DATE := TO_DATE(dataScad default NULL on conversion error, 'YYYY-MM-DD');

BEGIN
    -- tutti i parametri sono stati controllati prima, dobbiamo solo inserirli nella tabella
    INSERT INTO TITOLIINGRESSO 
    VALUES (IDTITOLOING.nextval, emiss, scad, user,)

END; 

END gruppo1;
