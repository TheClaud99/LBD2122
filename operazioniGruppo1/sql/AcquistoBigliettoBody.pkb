CREATE OR REPLACE PACKAGE BODY packageAcquistaBiglietto AS
/*
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
		MODGUI1.ApriForm('AcquistaBiglietto.ConfermaAcquistoBiglietto', 'formAcquistoBiglietto', 'w3-container');
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

) IS 
    emiss DATE := TO_DATE(dataEmiss default NULL on conversion error, 'YYYY-MM-DD');
	scad DATE := TO_DATE(dataScad default NULL on conversion error, 'YYYY-MM-DD');

BEGIN 
    -- tutti i parametri sono stati controllati prima, dobbiamo solo inserirli nella tabella
    INSERT INTO TITOLIINGRESSO 
    VALUES (IDTITOLOING.nextval, emiss, scad, user,)

END;
*/
/*
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
'
' SECONDO TENTATIVO
*/

PROCEDURE acquistabiglietto(
	dataEmissionechar IN VARCHAR2,
	dataScadenzachar IN VARCHAR2,
	idmuseoselezionato IN VARCHAR2,
	idtipologiaselezionata IN VARCHAR2,
	idutenteselezionato IN VARCHAR2
) IS
	idbigliettocreato VARCHAR(5);
	emiss DATE := TO_DATE(dataEmissionechar default null on conversion error, 'YYYY-MM-DD');
	scad DATE := TO_DATE(dataScadenzachar default null on conversion error, 'YYYY-MM-DD');
BEGIN
	idbigliettocreato := idtitoloingseq.nextval;

	INSERT INTO TITOLIINGRESSO(
		idtitoloing,
		Emissione,
		Scadenza,
		Acquirente,
		Tipologia,
		Museo
	) VALUES (
		idvisiteseq.nextval,
		emiss,
		scad,
		idutenteselezionato,
		idtipologiaselezionata,
		idmuseoselezionato
	);
	
	--visualizzabiglietto(idbigliettocreato);
END;

PROCEDURE formacquistabiglietto(
	dataEmissionechar IN VARCHAR2,
	dataScadenzachar IN VARCHAR2,
	idmuseoselezionato IN VARCHAR2 default null,
	idtipologiaselezionata IN VARCHAR2 default null,
	idutenteselezionato IN VARCHAR2 default null
)IS 
	nomeutente utenti.nome%TYPE;
	cognomeutente utenti.cognome%TYPE;
	varidutente utenti.Idutente%TYPE;
	nometipologia tipologieingresso.nome%TYPE;
	varidmuseo musei.idmuseo%TYPE;
	nomeMuseo musei.Nome%TYPE;
	varidtipologia tipologieingresso.idtipologiaing%TYPE;
	nometipologia tipologieingresso.Nome%type;
BEGIN
	modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
	modgui1.apriform('package.pagina_acquista_biglietto', 'formCreaBiglietto', 'w3-container');
	modgui1.apridiv('class="w3-section"');

	modgui1.Label('Data emissione biglietto*: ');
	modgui1.inputdate('DataEmissioneChar', 'DataEmissioneChar', 1, dataEmissionechar);
	HTP.br;

	modgui1.label('Data scadenza biglietto*: ');
	modgui1.inputdate('DataScadenzaChar', 'DataScadenzaChar', 1, dataScadenzachar);
	htp.br;

	modgui1.label('Utente*: ');
	modgui1.selectopen('idutenteselezionato', 'utente-selezionato');
	for utente in (select idutente from utentimuseo)
	loop
		select idutente, nome, cognome
		into varidutente, nomeutente, cognomeutente
		from utenti
		where idutente=utente.idutente;
		if utente.idutente = idutenteselezionato
		then
			MODGUI1.SelectOption(varidutente, ''|| nomeutente ||' '||cognomeutente||'', 1);
		else 
			MODGUI1.SelectOption(varidutente, ''|| nomeutente ||' '||cognomeutente||'', 0);
		end if;
	end loop;
	modgui1.selectclose();
	htp.br;
	
	modgui1.label('Museo*: ');
	modgui1.selectopen('idmuseoselezionato', 'museo-selezionato');
	for museo in (select idmuseo from musei)
	loop
		select idmuseo, Nome
		into varidmuseo, nomeMuseo
		from musei;
		if museo.idmuseo=idmuseoselezionato
		then modgui1.SelectOption(varidmuseo, nomeMuseo, 1);
		else modgui1.SelectOption(varidmuseo, nomeMuseo, 0);
		end if;
	end loop;
	modgui1.SelectClose();
	
	modgui1.label('Tipologia di biglietto*: ');
	modgui1.selectopen('idtipologiaselezionata', 'tipologia-selezionata');
	for tipologia in (select idtipologiaing from TIPOLOGIEINGRESSO)
	loop
		select Tipologieingressomusei.IdTipologiaIng, Nome 
		into varidtipologia, nometipologia
		from TIPOLOGIEINGRESSOMUSEI, TIPOLOGIEINGRESSO
		where IdMuseo=idmuseoselezionato 
			and TIPOLOGIEINGRESSOMUSEI.IdTipologiaIng=TIPOLOGIEINGRESSO.IdTipologiaIng;
		if idtipologiaselezionata= tipologia.idtipologiaing
		then
			modgui.SelectOption(varidtipologia, nometipologia, 1);
		else
			modgui.SelectOption(varidtipologia, nometipologia, 0);
		end if;
	end loop;
	modgui1.selectclose();

	htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit" name="convalida" value="1">Acquista</button>');
	modgui1.ChiudiDiv();
	modgui1.chiudiform();
	modgui1.chiudidiv();
	htp.prn('<script> 
				document.getElementById("museo-selezionato".onchange= function inviaFormAcquistaBiglietto{
					document.formAcquistaBiglietto.submit();
					}
	</script>');
END;

PROCEDURE pagina_acquista_biglietto(
	dataEmissionechar IN VARCHAR2,
	dataScadenzachar IN VARCHAR2,
	idmuseoselezionato IN VARCHAR2,
	idtipologiaselezionata IN VARCHAR2,
	idutenteselezionato IN VARCHAR2,
	convalida IN NUMBER DEFAULT NULL
) IS 
BEGIN 
	modgui1.apripagina();
	modgui1.header();
	modgui1.apridiv('style="margin-top: 110px"');
	htp.prn('<h1> Acquisto biglietto </h1>');
	if convalida is null
	then 
		formvisita(dataEmissionechar, dataScadenzachar,
					idmuseoselezionato, idtipologiaselezionata, idutenteselezionato);
	else 
		htp.prn('<h1> Biglietto acquistato </h1>');
		acquistabiglietto(dataEmissionechar, dataScadenzachar,
							idmuseoselezionato, idtipologiaselezionata, idutenteselezionato);
	end if;
	modgui1.chiudidiv();
	htp.prn('<script> function inviaFormAcquistaBiglietto(){
		document.formAcquistaBiglietto.submit();
		}
	</script>');
	htp.prn('
	</body>
	</html>');
END;

END packageAcquistaBiglietto;
