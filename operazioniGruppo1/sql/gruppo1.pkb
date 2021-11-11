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
    SELECT count(*) INTO temp FROM UTENTI WHERE Email = email;

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
		MODGUI1.Collegamento('Modifica', Costanti.server || Costanti.radice|| '/ModificaDatiUtente?sessionID='||sessionID||'&utenteID='||utenteID, 'w3-button w3-blue');
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
PROCEDURE AcquistoBiglietto(
 	sessionID NUMBER DEFAULT 0
	
) IS
	nomeUtente VARCHAR2(25) DEFAULT NULL;
	cognomeUtente VARCHAR(25) DEFAULT NULL;
	varIdUtente NUMBER(5) DEFAULT NULL;
	varIdMuseo NUMBER(5) DEFAULT NULL;
	NomeMuseo VARCHAR2(40) DEFAULT NULL;
BEGIN

    MODGUI1.ApriPagina('Acquisto Biglietto', 0);
	
	MODGUI1.Header();
	HTP.header(1,'Inserisci un nuovo biglietto', 'center');
	MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%;"');

	MODGUI1.ApriForm('ConfermaAcquistoBiglietto');
	HTP.FORMHIDDEN('sessionID',0);
    MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%;"');
	MODGUI1.Label('Data Emissione*');
	MODGUI1.InputDate('dataEmiss', 'Data emissione');
	HTP.BR;
	MODGUI1.Label('Data Scadenza*');
	MODGUI1.InputDate('dataScad', 'Data Scadenza');
	HTP.BR;
	
	MODGUI1.Label('Utente');
	MODGUI1.SelectOpen();
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
	MODGUI1.SelectOpen();
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
        for tipologie in (SELECT IdTipologi)
	MODGUI1.InputSubmit('Acquista');
    MODGUI1.ChiudiDiv();
	MODGUI1.ChiudiForm();
	
	MODGUI1.ChiudiDiv();

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
