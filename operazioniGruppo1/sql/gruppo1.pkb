CREATE OR REPLACE PACKAGE BODY gruppo1 AS

/*
 grant execute on gruppo1 to anonymous;
 *http://131.114.73.203:8080/apex/fgiannotti.gruppo1.InserisciUtente
 * OPERAZIONI SUGLI UTENTI
 * - Inserimento ✅ 
 * - Modifica ❌
 * - Visualizzazione ❌
 * - Cancellazione (rimozione) ❌
 * OPERAZIONI STATISTICHE E MONITORAGGIO
 * - Numero Musei visitati in un arco temporale scelto ❌
 * - Numero Titoli d’Ingresso  acquistati in un arco temporale scelto ❌
 * - Numero medio Titoli d’Ingresso acquistati in un arco temporale scelto ❌
 * - Età media utenti ❌
 * - Spesa media di un visitatore in un arco temporale scelto ❌
 */


/*
 *  OPERAZIONI SULLE TIPOLOGIE DI INGRESSO
 * - Inserimento ❌
 * - Modifica ❌
 * - Visualizzazione ❌
 * - Cancellazione (rimozione) ❌
 * OPERAZIONI STATISTICHE E MONITORAGGIO
 * - Tipologia più scelta in un arco temporale scelto ❌
 * - Lista Tipologie in ordine di prezzo crescente ❌
*/

/*
 *  OPERAZIONI SUI TITOLI DI INGRESSO
 * - Modifica ❌
 * - Cancellazione❌
 * - Visualizzazione ❌
 * - Acquisto abbonamento museale ❌
 * - Acquisto biglietto ❌
 * OPERAZIONI STATISTICHE E MONITORAGGIO
 * - Numero Titoli d’Ingresso emessi in un arco temporale scelto ❌
 * - Numero Titoli d’Ingresso emessi da un Museo in un arco temporale scelto ❌
 * - Abbonamenti in scadenza nel mese corrente ❌
*/

--Procedura per inserimento Utente
PROCEDURE InserisciUtente(
    sessionID NUMBER DEFAULT 0
) IS
BEGIN

    MODGUI1.ApriPagina('Inserimento utenti', 0);
	
	HTP.BodyOpen;
	MODGUI1.Header(); --da capire come combinarlo con il resto
	HTP.header(1,'Inserisci un nuovo utente', 'center');
	MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%;"');

	MODGUI1.ApriForm('ConfermaDatiUtente');
	HTP.FORMHIDDEN('sessionID',0);

	MODGUI1.Label('Nome*');
	MODGUI1.InputText('nome', 'Nome utente', 1);
	HTP.BR;
	MODGUI1.Label('Cognome*');
	MODGUI1.InputText('cognome', 'Cognome utente', 1);
	HTP.BR;
	MODGUI1.Label('Data nascita*');
	MODGUI1.InputDate('dataNascita', 'dataNascita');
	HTP.BR;
	MODGUI1.Label('Indirizzo*');
	MODGUI1.InputText('indirizzo', 'Indirizzo', 1);
	HTP.BR;
	MODGUI1.Label('Email*');
	MODGUI1.InputText('email', 'Email', 1);
	HTP.BR;
	MODGUI1.Label('Telefono');
	MODGUI1.InputText('telefono', 'Telefono', 0);
	HTP.BR;
	MODGUI1.InputCheckboxOnClick('Utente museo', 'utentemuseo','check()','utentemuseo');
	HTP.BR;
	MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%; display: none" id="first"');
	HTP.BR;
	MODGUI1.InputCheckbox('Donatore', 'donatore');
	HTP.BR;
	MODGUI1.ChiudiDiv;
	HTP.BR;
	MODGUI1.InputCheckboxOnClick('Utente campi estivi', 'utentecampiestivi', 'check2()', 'utentecampiestivi');
	HTP.BR;
	MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%; display: none" id="second"');
	MODGUI1.InputCheckbox('Richiede assistenza', 'assistenza');
	HTP.BR;
	MODGUI1.ChiudiDiv;
	
	MODGUI1.InputSubmit('Inserisci');
	MODGUI1.ChiudiForm;
	
	MODGUI1.ChiudiDiv;

	htp.print('<script type="text/javascript">
			function check() {
				const div1 = document.getElementById("first")
				const checkbox1 = document.getElementById("utentemuseo")
				if(checkbox1.checked == true) {
					div1.style.display = "block"
				}
				else {
					div1.style.display = "none"
					const inputs = div1.getElementsByTagName("input")
					for (let input of inputs) {
						input.checked = false
					}
				}
			}

			function check2() {
				const div1 = document.getElementById("second")
				const checkbox1 = document.getElementById("utentecampiestivi")
				if(checkbox1.checked == true) {
					div1.style.display = "block"
				}
				else {
					div1.style.display = "none"
					const inputs = div1.getElementsByTagName("input")
					for (let input of inputs) {
						input.checked = false
					}
				}
			}
        </script>');

	HTP.BodyClose;
	HTP.HtmlClose;
END;

-- Procedura per confermare i dati dell'inserimento di un Utente
PROCEDURE ConfermaDatiUtente(
	sessionID NUMBER DEFAULT 0,
	nome VARCHAR2 DEFAULT NULL,
	cognome VARCHAR2 DEFAULT NULL,
	dataNascita VARCHAR2 DEFAULT NULL,
	indirizzo VARCHAR2 DEFAULT NULL,
	email VARCHAR2 DEFAULT NULL,
    telefono VARCHAR2 DEFAULT NULL
) IS
BEGIN
	-- se utente non autorizzato: messaggio errore
	IF nome IS NULL 
	OR cognome IS NULL 
	OR (dataNascita IS NOT NULL 
		AND to_date(dataNascita, 'YYYY-MM-DD') > sysdate)
	OR indirizzo IS NULL
    OR email IS NULL
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
		HTP.TableData('Nome: ');
		HTP.TableData(nome);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Cognome: ');
		HTP.TableData(cognome);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Data Nascita: ');
		HTP.TableData(dataNascita);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Indirizzo: ');
		HTP.TableData(indirizzo);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Email: ');
		HTP.TableData(email);
		HTP.TableRowClose;
		HTP.TableRowOpen;
        HTP.TableData('Telefono: ');
		HTP.TableData(telefono);
		HTP.TableRowClose;
		HTP.TableClose;

		MODGUI1.ApriForm('InserisciDatiUtente');
		HTP.FORMHIDDEN('sessionID', 0);
		HTP.FORMHIDDEN('nome', nome);
		HTP.FORMHIDDEN('cognome', cognome);
		HTP.FORMHIDDEN('dataNascita', dataNascita);
		HTP.FORMHIDDEN('Indirizzo', indirizzo);
		HTP.FORMHIDDEN('Email', email);
        HTP.FORMHIDDEN('Telefono', telefono);
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

PROCEDURE InserisciDatiUtente (
    sessionID NUMBER DEFAULT 0,
	nome VARCHAR2,
	cognome VARCHAR2,
	dataNascita VARCHAR2 DEFAULT NULL,
	indirizzo VARCHAR2 DEFAULT NULL,
	email VARCHAR2 DEFAULT NULL,
    telefono VARCHAR2 DEFAULT NULL
) IS 
    birth DATE := TO_DATE(dataNascita default NULL on conversion error, 'YYYY-MM-DD');
    EmailPresente EXCEPTION;
    TelefonoPresente EXCEPTION;
    temp NUMBER(10) := 0;
    temp2 NUMBER(10) := 0;

BEGIN
    -- tutti i parametri sono stati controllati prima, dobbiamo solo inserirli nella tabella
    SELECT count(*) INTO temp FROM UTENTI WHERE UTENTI.Email = email;

    IF temp > 0 THEN
        RAISE EmailPresente;
    END IF;

    select count(*) INTO temp2 from UTENTI where RecapitoTelefonico = telefono;

    IF temp2 > 0 THEN
        RAISE TelefonoPresente;
    END IF;

    insert into UTENTI
    values (IdUtenteSeq.NEXTVAL, nome, cognome, birth, indirizzo, email, telefono);

	IF SQL%FOUND
	THEN
		-- faccio il commit dello statement precedente
		commit;

		MODGUI1.ApriPagina('Utente inserito', sessionID);
		HTP.BodyOpen;
		MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%;"');
		HTP.tableopen;
		HTP.tablerowopen;
		HTP.tabledata('Nome: '||nome);
		HTP.tablerowclose;
		HTP.tablerowopen;
		HTP.tabledata('Cognome: '||cognome);
		HTP.tablerowclose;
		HTP.tablerowopen;
		HTP.tabledata('Data nascita: '||birth);
		HTP.tablerowclose;
		HTP.tablerowopen;
		HTP.tabledata('Indirizzo: '||indirizzo);
		HTP.tablerowopen;
		HTP.tablerowclose;
		HTP.tablerowopen;
		HTP.tabledata('Email: '||email);
		HTP.tablerowclose;
		HTP.tablerowopen;
		HTP.tabledata('Telefono: '||telefono);
		HTP.tablerowclose;
		HTP.tableClose;
		MODGUI1.ChiudiDiv;
		HTP.BodyClose;
		HTP.HtmlClose;
	ELSE
		MODGUI1.ApriPagina('Utente non inserito', sessionID);
		HTP.BodyOpen;

		HTP.PRN('Utente non inserito');

		HTP.BodyClose;
		HTP.HtmlClose;
	END IF;

    EXCEPTION
      when EmailPresente then
        MODGUI1.ApriPagina('Errore', sessionID);
		HTP.BodyOpen;

		MODGUI1.ApriDiv;
		HTP.PRN('Email già presente');
		MODGUI1.collegamento('Inserisci nuovo utente', 'InserisciUtente');
		MODGUI1.ChiudiDiv;

		HTP.BodyClose;
		HTP.HtmlClose;
    when TelefonoPresente then 
        MODGUI1.ApriPagina('Errore', sessionID);
		HTP.BodyOpen;

		MODGUI1.ApriDiv;
		HTP.PRN('Telefono già presente');
		MODGUI1.collegamento('Inserisci nuovo utente', 'InserisciUtente');
		MODGUI1.ChiudiDiv;

		HTP.BodyClose;
		HTP.HtmlClose;
END;

PROCEDURE VisualizzaDatiUtente (
    sessionID NUMBER DEFAULT 0,
	utenteID NUMBER 
) 
IS
	NomeUtente UTENTI.Nome%TYPE;
    CognomeUtente UTENTI.Cognome%TYPE;
    DataNascitaUtente UTENTI.DataNascita%TYPE;
	IndirizzoUtente UTENTI.Indirizzo%TYPE;
	EmailUtente UTENTI.Email%TYPE;
	RecapitoTelefonicoUtente UTENTI.RecapitoTelefonico%TYPE;

BEGIN

	select NOME, COGNOME, DATANASCITA, INDIRIZZO, EMAIL, RECAPITOTELEFONICO
	into NomeUtente, CognomeUtente, DataNascitaUtente, IndirizzoUtente, EmailUtente, RecapitoTelefonicoUtente
	from UTENTI
	where IDUTENTE = utenteID;

	IF SQL%FOUND
	THEN
	
		MODGUI1.ApriPagina('Profile utente', sessionID);
		HTP.BodyOpen;
		MODGUI1.Header(sessionID);
		MODGUI1.ApriDiv('class="w3-center" style="margin: 0;
							position: absolute;
							top: 40%;
							left: 50%;
							margin-right: -50%;
							transform: translate(-50%, -50%)"');
		HTP.tableopen;
		HTP.tablerowopen;
		HTP.tabledata('Nome: '||NomeUtente);
		HTP.tablerowclose;
		HTP.tablerowopen;
		HTP.tabledata('Cognome: '||CognomeUtente);
		HTP.tablerowclose;
		HTP.tablerowopen;
		HTP.tabledata('Data nascita: '||DataNascitaUtente);
		HTP.tablerowclose;
		HTP.tablerowopen;
		HTP.tabledata('Indirizzo: '||IndirizzoUtente);
		HTP.tablerowopen;
		HTP.tablerowclose;
		HTP.tablerowopen;
		HTP.tabledata('Email: '||EmailUtente);
		HTP.tablerowclose;
		HTP.tablerowopen;
		HTP.tabledata('Telefono: '||RecapitoTelefonicoUtente);
		HTP.tablerowclose;
		HTP.tableClose;
		MODGUI1.Collegamento('Modifica', '/ModificaDatiUtente?sessionID=' || sessionID, 'w3-button w3-blue');
		MODGUI1.ChiudiDiv;
		HTP.BodyClose;
		HTP.HtmlClose;
	ELSE
		MODGUI1.ApriPagina('Utente non trovato', sessionID);
		HTP.BodyOpen;

		HTP.PRN('Utente non trovato');

		HTP.BodyClose;
		HTP.HtmlClose;
	END IF;
END;

PROCEDURE ModificaDatiUtente (
    sessionID NUMBER DEFAULT 0,
	utenteID NUMBER DEFAULT NULL
) 
IS
	NomeUtente UTENTI.Nome%TYPE;
    CognomeUtente UTENTI.Cognome%TYPE;
    DataNascitaUtente UTENTI.DataNascita%TYPE;
	IndirizzoUtente UTENTI.Indirizzo%TYPE;
	EmailUtente UTENTI.Email%TYPE;
	RecapitoTelefonicoUtente UTENTI.RecapitoTelefonico%TYPE;

BEGIN

	select NOME, COGNOME, DATANASCITA, INDIRIZZO, EMAIL, RECAPITOTELEFONICO
	into NomeUtente, CognomeUtente, DataNascitaUtente, IndirizzoUtente, EmailUtente, RecapitoTelefonicoUtente
	from UTENTI
	where IDUTENTE = utenteID;

	IF SQL%FOUND
	THEN
	
		MODGUI1.ApriPagina('Profile utente', sessionID);
		HTP.BodyOpen;
		MODGUI1.Header(sessionID);
		MODGUI1.ApriDiv('style="margin: 0;
							position: absolute;
							top: 40%;
							left: 50%;
							margin-right: -50%;
							transform: translate(-50%, -50%)"');
		MODGUI1.ApriForm('ConfermaDatiUtente');
		HTP.FORMHIDDEN('sessionID',0);

		MODGUI1.Label('Nome*');
		MODGUI1.InputText('nome', 'Nome utente', 1, NomeUtente);
		HTP.BR;
		MODGUI1.Label('Cognome*');
		MODGUI1.InputText('cognome', 'Cognome utente', 1, CognomeUtente);
		HTP.BR;
		MODGUI1.Label('Data nascita*');
		MODGUI1.InputDate('dataNascita', 'dataNascita', 1, DataNascitaUtente);
		HTP.BR;
		MODGUI1.Label('Indirizzo*');
		MODGUI1.InputText('indirizzo', 'Indirizzo', 1, IndirizzoUtente);
		HTP.BR;
		MODGUI1.Label('Email*');
		MODGUI1.InputText('email', 'Email', 1, EmailUtente);
		HTP.BR;
		MODGUI1.Label('Telefono');
		MODGUI1.InputText('telefono', 'Telefono', 0, RecapitoTelefonicoUtente);
		HTP.BR;
		MODGUI1.InputCheckboxOnClick('Utente museo', 'utentemuseo','check()','utentemuseo');
		HTP.BR;
		MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%; display: none" id="first"');
		HTP.BR;
		MODGUI1.InputCheckbox('Donatore', 'donatore');
		HTP.BR;
		MODGUI1.ChiudiDiv;
		HTP.BR;
		MODGUI1.InputCheckboxOnClick('Utente campi estivi', 'utentecampiestivi', 'check2()', 'utentecampiestivi');
		HTP.BR;
		MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%; display: none" id="second"');
		MODGUI1.InputCheckbox('Richiede assistenza', 'assistenza');
		HTP.BR;
		MODGUI1.ChiudiDiv;
		
		MODGUI1.InputSubmit('Salva');
		MODGUI1.ChiudiForm;
		
		MODGUI1.ChiudiDiv;

		HTP.BodyClose;
		HTP.HtmlClose;
	ELSE
		MODGUI1.ApriPagina('Utente non trovato', sessionID);
		HTP.BodyOpen;

		HTP.PRN('Utente non trovato');

		HTP.BodyClose;
		HTP.HtmlClose;
	END IF;
END;

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
	nometiping VARCHAR(25);
BEGIN
	modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
	modgui1.apriform('pagina_acquista_biglietto', 'formAcquistaBiglietto', 'w3-container');
	modgui1.apridiv('class="w3-section"');

	modgui1.Label('Data emissione biglietto*: ');
	modgui1.inputdate('DataEmissioneChar', 'DataEmissioneChar', 1, dataEmissionechar);
	HTP.br;

	modgui1.label('Data scadenza biglietto*: ');
	modgui1.inputdate('DataScadenzaChar', 'DataScadenzaChar', 1, dataScadenzachar);
	htp.br;

	modgui1.label('Utente*: ');
	modgui1.selectopen('idutenteselezionato', 'utente-selezionato');
	for utente in (select idutente from utenti)
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
	for museo in (select idmuseo, nome from musei )
	loop
		if museo.idmuseo=idmuseoselezionato
		then modgui1.SelectOption(museo.idmuseo, museo.nome, 1);
		else modgui1.SelectOption(museo.idmuseo, museo.nome, 0);
		end if;
	end loop;
	modgui1.SelectClose();
	htp.br;
	
	modgui1.label('Tipologia di biglietto*: ');
	modgui1.selectopen('idtipologiaselezionata', 'tipologia-selezionata');
	for tipologia in (		
		select TIPOLOGIEINGRESSO.IDTIPOLOGIAING, NOME
		into varidtipologia, nometiping
		from TIPOLOGIEINGRESSOMUSEI JOIN TIPOLOGIEINGRESSO
        ON TIPOLOGIEINGRESSO.IDTIPOLOGIAING=TIPOLOGIEINGRESSOMUSEI.IDTIPOLOGIAING   
		where IdMuseo=idmuseoselezionato
	)
	LOOP
		if idtipologiaselezionata= tipologia.idtipologiaing
		then
			modgui1.SelectOption(tipologia.idtipologiaing, tipologia.nome, 1);
		else
			modgui1.SelectOption(tipologia.idtipologiaing, tipologia.nome, 0);
		end if;
	end loop;
	modgui1.selectclose();

	htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit" name="convalida" value="1">Acquista</button>');
	modgui1.ChiudiDiv();
	modgui1.chiudiform();
	modgui1.chiudidiv();
	htp.prn('<script> 
				document.getElementById("museo-selezionato").onchange= function inviaFormAcquistaBiglietto(){
					document.formAcquistaBiglietto.submit();
					}
	</script>');
END;

PROCEDURE pagina_acquista_biglietto(
	dataEmissionechar VARCHAR2 DEFAULT NULL,
	dataScadenzachar VARCHAR2 DEFAULT NULL,
	idmuseoselezionato VARCHAR2 DEFAULT NULL,
	idtipologiaselezionata VARCHAR2 DEFAULT NULL,
	idutenteselezionato VARCHAR2 DEFAULT NULL,
	convalida IN NUMBER DEFAULT NULL
) IS 
BEGIN 
	modgui1.apripagina();
	modgui1.header();
	modgui1.apridiv('style="margin-top: 110px"');
	htp.prn('<h1> Acquisto biglietto </h1>');
	
	if convalida IS NULL
	then 
		formacquistabiglietto(dataEmissionechar, dataScadenzachar,
					idmuseoselezionato, idtipologiaselezionata, idutenteselezionato);
	else 
		htp.print('<h3>Biglietto acquistato</h3>');
		confermaacquistobiglietto(dataEmissionechar, dataScadenzachar,
							idmuseoselezionato, idtipologiaselezionata, idutenteselezionato);
	end if;
	
	modgui1.chiudidiv(); 
	HTP.BodyClose;
	HTP.HtmlClose;
END;




END GRUPPO1;

/*
 *  OPERAZIONI SUI TITOLI DI INGRESSO
 * - Modifica ❌
 * - Cancellazione❌
 * - Visualizzazione ❌
 * - Acquisto abbonamento museale ❌
 * - Acquisto biglietto ❌
 * OPERAZIONI STATISTICHE E MONITORAGGIO
 * - Numero Titoli d’Ingresso emessi in un arco temporale scelto ❌
 * - Numero Titoli d’Ingresso emessi da un Museo in un arco temporale scelto ❌
 * - Abbonamenti in scadenza nel mese corrente ❌
*/
/*

/*
 *  OPERAZIONI SULLE NEWSLETTER
 * - Inserimento ❌
 * - Cancellazione❌
 * - Visualizzazione❌
 * - Iscrizione(rimozione)❌
 * - Cancellazione Iscrizione❌
 * OPERAZIONI STATISTICHE E MONITORAGGIO
 * - Numero visitatori iscritti alla Newsletter scelta❌
 * - Età media dei visitatori iscritti alla Newsletter scelta ❌
 * - Titoli d’ingresso appartenenti ai visitatori iscritti alla Newsletter scelta❌
 * - Lista Opere ordinate per numero di Autori in ordine decrescente ❌
*/