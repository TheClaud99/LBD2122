
CREATE OR REPLACE PACKAGE BODY gruppo1 AS

/*
 grant execute on gruppo1 to anonymous;
 *http://131.114.73.203:8080/apex/fgiannotti.gruppo1.InserisciUtente
 * OPERAZIONI SUGLI UTENTI
 * - Inserimento ✅
 * - Modifica ✅
 * - Visualizzazione ✅
 * - Cancellazione (rimozione) ✅
 * OPERAZIONI STATISTICHE E MONITORAGGIO
 * - Numero Musei visitati in un arco temporale scelto ✅
 * - Numero Titoli d’Ingresso  acquistati in un arco temporale scelto ✅
 * - Numero medio Titoli d’Ingresso acquistati in un arco temporale scelto ❌
 * - Età media utenti ✅
 * - Spesa media di un visitatore in un arco temporale scelto ✅
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
CREATE OR REPLACE PACKAGE BODY gruppo1 AS

/*
 grant execute on gruppo1 to anonymous;
 *http://131.114.73.203:8080/apex/fgiannotti.gruppo1.InserisciUtente
 * OPERAZIONI SUGLI UTENTI
 * - Inserimento ✅
 * - Modifica ✅
 * - Visualizzazione ✅
 * - Cancellazione (rimozione) ✅
 * OPERAZIONI STATISTICHE E MONITORAGGIO
 * - Numero Musei visitati in un arco temporale scelto ✅
 * - Numero Titoli d’Ingresso  acquistati in un arco temporale scelto ✅
 * - Numero medio Titoli d’Ingresso acquistati in un arco temporale scelto ❌
 * - Età media utenti ✅
 * - Spesa media di un visitatore in un arco temporale scelto ✅
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
	nome VARCHAR2 DEFAULT NULL,
	cognome VARCHAR2 DEFAULT NULL,
	dataNascita VARCHAR2 DEFAULT NULL,
	indirizzo VARCHAR2 DEFAULT NULL,
	email VARCHAR2 DEFAULT NULL,
    telefono VARCHAR2 DEFAULT NULL,
	utenteMuseo VARCHAR2 DEFAULT NULL,
	utenteDonatore VARCHAR2 DEFAULT NULL,
	utenteCampiEstivi VARCHAR2 DEFAULT NULL,
	utenteAssistenza VARCHAR2 DEFAULT NULL,
	utenteTutore NUMBER DEFAULT 0
) IS
	nomeutente utenti.nome%TYPE;
	cognomeutente utenti.cognome%TYPE;
	varidutente utenti.Idutente%TYPE;
	idSessione NUMBER(5) := modgui1.get_id_sessione();
BEGIN

    MODGUI1.ApriPagina('Inserimento utenti', idSessione);

	HTP.BodyOpen;
	if idSessione IS NULL then
            modGUI1.Header(0);
    else
            modGUI1.Header(idSessione);
    end if;
	HTP.header(1,'Inserisci un nuovo utente', 'center');
	modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom w3-padding-large" style="max-width:600px; margin-top:110px"');
	HTP.header(2, 'Inserisci utente');
	MODGUI1.ApriForm('ConfermaDatiUtente');
	MODGUI1.Label('Nome*');
	MODGUI1.InputText('nome', 'Nome utente', 1, nome);
	HTP.BR;
	MODGUI1.Label('Cognome*');
	MODGUI1.InputText('cognome', 'Cognome utente', 1, cognome);
	HTP.BR;
	MODGUI1.Label('Data nascita*');
	MODGUI1.InputDate('dataNascita', 'dataNascita', 1, dataNascita);
	HTP.BR;
	modgui1.label('Tutore*');
	modgui1.selectopen('utenteTutore', 'idutentetutore');
	MODGUI1.SelectOption(0, 'Tutore non necessario', 0);
	for utente in (select idutente from utenti where ELIMINATO = 0)
	loop
		select idutente, nome, cognome
		into varidutente, nomeutente, cognomeutente
		from utenti
		where idutente=utente.idutente;
		if utenteTutore = varidutente then 
			MODGUI1.SelectOption(varidutente, ''|| nomeutente ||' '||cognomeutente||'', 1);
		else
			MODGUI1.SelectOption(varidutente, ''|| nomeutente ||' '||cognomeutente||'', 0);
		end if;
	end loop;
	modgui1.selectclose();
	HTP.BR;
	MODGUI1.Label('Indirizzo*');
	MODGUI1.InputText('indirizzo', 'Indirizzo', 1, indirizzo);
	HTP.BR;
	MODGUI1.Label('Email*');
	MODGUI1.InputText('email', 'Email', 1, email);
	HTP.BR;
	MODGUI1.Label('Telefono');
	MODGUI1.InputText('telefono', 'Telefono', 0, telefono);
	HTP.BR;
	if utenteMuseo = 'on' then
		MODGUI1.InputCheckboxOnClick('Utente museo', 'utenteMuseo','check()','utentemuseo', 1);
		MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%; display: block" id="first"');
	else
		MODGUI1.InputCheckboxOnClick('Utente museo', 'utenteMuseo','check()','utentemuseo');
		MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%; display: none" id="first"');
	end if;
	HTP.BR;
	if utenteDonatore = 'on' then
		MODGUI1.InputCheckbox('Donatore', 'utenteDonatore', 1);
	else
		MODGUI1.InputCheckbox('Donatore', 'utenteDonatore');
	end if;
	HTP.BR;
	MODGUI1.ChiudiDiv;
	HTP.BR;
	if utenteCampiEstivi = 'on' then
		MODGUI1.InputCheckboxOnClick('Utente campi estivi', 'utenteCampiEstivi', 'check2()', 'utentecampiestivi', 1);
		MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%; display: block" id="second"');
	else
		MODGUI1.InputCheckboxOnClick('Utente campi estivi', 'utenteCampiEstivi', 'check2()', 'utentecampiestivi');
		MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%; display: none" id="second"');
	end if;
	HTP.BR;
	if utenteAssistenza = 'on' then
		MODGUI1.InputCheckbox('Richiede assistenza', 'utenteAssistenza', 1);
	else
		MODGUI1.InputCheckbox('Richiede assistenza', 'utenteAssistenza');
	end if;
	HTP.BR;
	MODGUI1.ChiudiDiv;

	MODGUI1.InputSubmit('Inserisci');
	MODGUI1.ChiudiForm;
	MODGUI1.collegamento('Annulla','ListaUtenti','w3-button w3-block w3-black w3-section w3-padding');
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
	nome VARCHAR2 DEFAULT NULL,
	cognome VARCHAR2 DEFAULT NULL,
	dataNascita VARCHAR2 DEFAULT NULL,
	indirizzo VARCHAR2 DEFAULT NULL,
	email VARCHAR2 DEFAULT NULL,
    telefono VARCHAR2 DEFAULT NULL,
	utenteMuseo VARCHAR2 DEFAULT NULL,
	utenteDonatore VARCHAR2 DEFAULT NULL,
	utenteCampiEstivi VARCHAR2 DEFAULT NULL,
	utenteAssistenza VARCHAR2 DEFAULT NULL,
	utenteTutore NUMBER DEFAULT 0
) IS
	nomeutente utenti.nome%TYPE;
	cognomeutente utenti.cognome%TYPE;
	varidutente utenti.Idutente%TYPE;
	idSessione NUMBER(5) := modgui1.get_id_sessione();
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
		if idSessione IS NULL then
            modGUI1.Header(0);
		else
				modGUI1.Header(idSessione);
		end if;
		MODGUI1.ApriDiv;
		HTP.PRINT('Uno dei parametri immessi non valido');
		MODGUI1.ChiudiDiv;
		HTP.BodyClose;
		HTP.HtmlClose;
	ELSE
		MODGUI1.APRIPAGINA('Conferma dati utenti', idSessione);
		HTP.BodyOpen;
		if idSessione IS NULL then
            modGUI1.Header(0);
		else
				modGUI1.Header(idSessione);
		end if;
		modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom w3-padding-large" style="max-width:600px; margin-top:110px"');
		HTP.header(2, 'Conferma dati utente');

		HTP.TableOpen;
		HTP.TableRowOpen;
		HTP.TableData('Nome: ');
		HTP.TableData(nome);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Cognome: ');
		HTP.TableData(cognome);
		HTP.TableRowClose;
		if utenteTutore != 0 then
			select nome, cognome
			into nomeutente, cognomeutente
			from utenti
			where idutente=utenteTutore;               
			HTP.TableRowOpen;
			HTP.TableData('Tutore: ');
			HTP.TableData(nomeutente||' '||cognomeutente);
			HTP.TableRowClose;
		end if;
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
		if utenteMuseo = 'on' then
			HTP.TableRowOpen;
			HTP.TableData('Utente museo: ');
			HTP.TableData('&#10004');
			HTP.TableRowClose;
			if utenteDonatore = 'on' then
				HTP.TableRowOpen;
				HTP.TableData('Donatore: ');
				HTP.TableData('&#10004');
				HTP.TableRowClose;
			end if;
		end if;
		if utenteCampiEstivi = 'on' then
			HTP.TableRowOpen;
			HTP.TableData('Utente campi estivo: ');
			HTP.TableData('&#10004');
			HTP.TableRowClose;
			if utenteAssistenza = 'on' then
				HTP.TableRowOpen;
				HTP.TableData('Richiesta assistenza: ');
				HTP.TableData('&#10004');
				HTP.TableRowClose;
			end if;
		end if;
		HTP.TableClose;

		MODGUI1.ApriForm('InserisciDatiUtente');
		HTP.FORMHIDDEN('nome', nome);
		HTP.FORMHIDDEN('cognome', cognome);
		HTP.FORMHIDDEN('dataNascita', dataNascita);
		if utenteTutore != 0 then
			HTP.FORMHIDDEN('utenteTutore', utenteTutore);
		end if;
		HTP.FORMHIDDEN('Indirizzo', indirizzo);
		HTP.FORMHIDDEN('utenteEmail', email);
        HTP.FORMHIDDEN('Telefono', telefono);
		if utenteMuseo = 'on' then
			HTP.FORMHIDDEN('utenteMuseo', utenteMuseo);
			if utenteDonatore = 'on' then
				 HTP.FORMHIDDEN('utenteDonatore', utenteDonatore);
			end if;
		end if;
		if utenteCampiEstivi = 'on' then
			HTP.FORMHIDDEN('utenteCampiEstivi', utenteCampiEstivi);
			if utenteAssistenza = 'on' then
				HTP.FORMHIDDEN('utenteAssistenza', utenteAssistenza);
			end if;
		end if;
		MODGUI1.InputSubmit('Conferma');
		MODGUI1.ChiudiForm;
		MODGUI1.Collegamento(
            'Annulla',
			'InserisciUtente?nome='||nome||'&cognome='||cognome||'&dataNascita='||dataNascita||'&indirizzo='||indirizzo||'&email='||email||'&telefono='||telefono||'&utenteMuseo='||utenteMuseo||'&utenteDonatore='||utenteDonatore||'&utenteCampiEstivi='||utenteCampiEstivi||'&utenteAssistenza='||utenteAssistenza||'&utenteTutore='||utenteTutore,
			'w3-button w3-block w3-black w3-section w3-padding'
        );
		MODGUI1.ChiudiDiv;
		HTP.BodyClose;
		HTP.HtmlClose;
	END IF;
	EXCEPTION WHEN OTHERS THEN
		dbms_output.put_line('Error: '||sqlerrm);
END;

PROCEDURE InserisciDatiUtente (
	nome VARCHAR2 DEFAULT NULL,
	cognome VARCHAR2 DEFAULT NULL,
	dataNascita VARCHAR2 DEFAULT NULL,
	indirizzo VARCHAR2 DEFAULT NULL,
	utenteEmail VARCHAR2 DEFAULT NULL,
    telefono VARCHAR2 DEFAULT NULL,
	utenteMuseo VARCHAR2 DEFAULT NULL,
	utenteDonatore VARCHAR2 DEFAULT NULL,
	utenteCampiEstivi VARCHAR2 DEFAULT NULL,
	utenteAssistenza VARCHAR2 DEFAULT NULL,
	utenteTutore NUMBER DEFAULT 0
) IS
    birth DATE := TO_DATE(dataNascita default NULL on conversion error, 'YYYY-MM-DD');
    EmailPresente EXCEPTION;
    TelefonoPresente EXCEPTION;
    temp NUMBER(10) := 0;
    temp2 NUMBER(10) := 0;
	tempIdUtente NUMBER(10) := 0;
	idSessione NUMBER(5) := modgui1.get_id_sessione();

BEGIN

    -- tutti i parametri sono stati controllati prima, dobbiamo solo inserirli nella tabella
    SELECT count(*) INTO temp FROM UTENTI WHERE UTENTI.Email = utenteEmail;

    IF temp > 0 THEN
        RAISE EmailPresente;
    END IF;

    select count(*) INTO temp2 from UTENTI where RecapitoTelefonico = telefono;

    IF temp2 > 0 THEN
        RAISE TelefonoPresente;
    END IF;

    insert into UTENTI
    values (IdUtenteSeq.NEXTVAL, nome, cognome, birth, indirizzo, utenteEmail, telefono, 0);

	select IdUtente into tempIdUtente from UTENTI where UTENTI.Email = utenteEmail;

	if utenteMuseo = 'on' then
		if utenteDonatore = 'on' then
			insert into UTENTIMUSEO
			values (tempIdUtente, 1);
		else
			insert into UTENTIMUSEO
			values (tempIdUtente, 0);
		end if;
	end if;

	if utenteCampiEstivi = 'on' then
		if utenteAssistenza = 'on' then
			insert into UTENTICAMPIESTIVI
			values (tempIdUtente, 1);
		else
			insert into UTENTICAMPIESTIVI
			values (tempIdUtente, 0);
		end if;
	end if;

	if utenteTutore != 0 then
		insert into TUTORI
		values (utenteTutore, tempIdUtente);
	end if;

	IF SQL%FOUND
	THEN
		-- faccio il commit dello statement precedente
		commit;
		modGUI1.RedirectEsito('Successo', 
            'L''utente '||nome||' '||cognome||' è stato inserito correttamente', 
            'Inserisci un nuovo utente', 'InserisciUtente', null,
            'Torna al menu utenti', 'ListaUtenti', null);

	ELSE
		modGUI1.RedirectEsito('Errore', 
            'L''utente '||nome||' '||cognome||' non è stato inserito', 
            'Riprova', 'InserisciUtente', null,
            'Torna al menu utenti', 'ListaUtenti', null);

	END IF;

    EXCEPTION
      when EmailPresente then
       modGUI1.RedirectEsito('Errore', 
            'Email non valida', 
            'Riprova', 'InserisciUtente', null,
            'Torna al menu utenti', 'ListaUtenti', null);
    when TelefonoPresente then
       modGUI1.RedirectEsito('Errore', 
            'Recapito telefonico non valido', 
            'Riprova', 'InserisciUtente', null,
            'Torna al menu utenti', 'ListaUtenti', null);
END;

procedure EsitoPositivoUtenti
 is
	idSessione NUMBER(5) := modgui1.get_id_sessione();
    begin
        modGUI1.ApriPagina('EsitoPositivoUtenti',idSessione);
        if idSessione IS NULL then
            modGUI1.Header(0);
		else
				modGUI1.Header(idSessione);
		end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom w3-padding-large" style="max-width:450px"');
                modGUI1.ApriDiv('class="w3-center"');
                htp.print('<h1>Operazione eseguita correttamente </h1>');
                MODGUI1.collegamento('Torna al menu','ListaUtenti','w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
			HTP.BodyClose;
		HTP.HtmlClose;
end;

procedure EsitoNegativoUtenti
 is
	idSessione NUMBER(5) := modgui1.get_id_sessione();
    begin
        modGUI1.ApriPagina('EsitoPositivoUtenti',idSessione);
        if idSessione IS NULL then
            modGUI1.Header(0);
		else
				modGUI1.Header(idSessione);
		end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom w3-padding-large" style="max-width:450px"');
                modGUI1.ApriDiv('class="w3-center"');
                htp.print('<h1>Operazione NON eseguita</h1>');
                MODGUI1.collegamento('Torna al menu','ListaUtenti?','w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
			HTP.BodyClose;
		HTP.HtmlClose;
end;

PROCEDURE VisualizzaUtente (
	utenteID NUMBER
)
IS
	NomeUtente UTENTI.Nome%TYPE;
    CognomeUtente UTENTI.Cognome%TYPE;
    DataNascitaUtente UTENTI.DataNascita%TYPE;
	IndirizzoUtente UTENTI.Indirizzo%TYPE;
	EmailUtente UTENTI.Email%TYPE;
	RecapitoTelefonicoUtente UTENTI.RecapitoTelefonico%TYPE;
	UtenteDonatore UTENTIMUSEO.Donatore%TYPE;
	UtenteAssistenza UTENTICAMPIESTIVI.Richiestaassistenza%TYPE;
	temp NUMBER(10) := 0;
    temp2 NUMBER(10) := 0;
	temp3 NUMBER(10) := 0;
	NomeTutore UTENTI.Nome%TYPE;
    CognomeTutore UTENTI.Cognome%TYPE;
	idTutoreUtente UTENTI.idutente%TYPE;
	idSessione NUMBER(5) := modgui1.get_id_sessione();


BEGIN

	select NOME, COGNOME, DATANASCITA, INDIRIZZO, EMAIL, RECAPITOTELEFONICO
	into NomeUtente, CognomeUtente, DataNascitaUtente, IndirizzoUtente, EmailUtente, RecapitoTelefonicoUtente
	from UTENTI
	where IDUTENTE = utenteID;

	select count(*) into temp from UTENTIMUSEO
	where utenteID = UTENTIMUSEO.idutente;

	if temp > 0 then
		select Donatore into UtenteDonatore from UTENTIMUSEO
		where utenteID = UTENTIMUSEO.idutente;
	end if;

	select count(*) into temp2 from UTENTICAMPIESTIVI
	where utenteID = UTENTICAMPIESTIVI.idutente;

	if temp2 > 0 then
		select Richiestaassistenza into UtenteAssistenza from UTENTICAMPIESTIVI
		where utenteID = UTENTICAMPIESTIVI.idutente;
	end if;

	select count(*) into temp3 from TUTORI
	where IDTUTELATO = utenteID;

	
	if temp3 > 0 THEN
		select idtutore into idTutoreUtente from TUTORI
		where IDTUTELATO = utenteID;
		
		select nome, cognome into NomeTutore, CognomeTutore from UTENTI
		where idutente = idTutoreUtente;
		
	end if;
	
	
	IF SQL%FOUND
	THEN

		MODGUI1.ApriPagina('Profile utente', idSessione);
		HTP.BodyOpen;
		if idSessione IS NULL then
            modGUI1.Header(0);
		else
				modGUI1.Header(idSessione);
		end if;
		modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom w3-padding-large" style="max-width:600px; margin-top:110px"');
		HTP.header(2, 'Profilo utente');
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
		
		if temp3 > 0 then
			HTP.tablerowopen;
			HTP.tabledata('Tutore: '||NomeTutore|| ' '||CognomeTutore);
			HTP.tablerowclose;
		end if;
		
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
		if temp > 0 then
			HTP.TableRowOpen;
			HTP.TableData('Utente museo: ');
			HTP.TableData('&#10004');
			HTP.TableRowClose;
			if utenteDonatore > 0 then
				HTP.TableRowOpen;
				HTP.TableData('Donatore: ');
				HTP.TableData('&#10004');
				HTP.TableRowClose;
			end if;
		end if;
		if temp2 > 0 then
			HTP.TableRowOpen;
			HTP.TableData('Utente campi estivo: ');
			HTP.TableData('&#10004');
			HTP.TableRowClose;
			if UtenteAssistenza > 0 then
				HTP.TableRowOpen;
				HTP.TableData('Richiesta assistenza: ');
				HTP.TableData('&#10004');
				HTP.TableRowClose;
			end if;
		end if;
		HTP.tableClose;
		if hasRole(idSessione, 'DBA') or hasRole(idSessione, 'SU') then
		MODGUI1.Collegamento('Modifica', 'ModificaUtente?utenteID='||utenteID, 'w3-button w3-blue w3-margin');
			MODGUI1.Collegamento('Elimina',
				'EliminaUtente?utenteID='||utenteID,
				'w3-button w3-red w3-margin',
				'return confirm(''Sei sicuro di voler eliminare il profilo di '||NomeUtente||' '||CognomeUtente||'?'')'
			);
		end if;
		MODGUI1.collegamento('Torna al menu','ListaUtenti','w3-button w3-block w3-black w3-section w3-padding');
		MODGUI1.ChiudiDiv;
		HTP.BodyClose;
		HTP.HtmlClose;
	ELSE
		modGUI1.RedirectEsito('Errore', 
            'Impossibile visualizzare l''utente selezionato', 
            'Riprova', 'VisualizzaUtente?utenteID='||utenteID, null,
            'Torna al menu utenti', 'ListaUtenti', null);
	END IF;
END;

PROCEDURE ModificaUtente (
	utenteID NUMBER DEFAULT NULL
)
IS
	NomeUtente UTENTI.Nome%TYPE;
    CognomeUtente UTENTI.Cognome%TYPE;
    DataNascitaUtente UTENTI.DataNascita%TYPE;
	IndirizzoUtente UTENTI.Indirizzo%TYPE;
	EmailUtente UTENTI.Email%TYPE;
	RecapitoTelefonicoUtente UTENTI.RecapitoTelefonico%TYPE;
	UtenteDonatore UTENTIMUSEO.Donatore%TYPE;
	UtenteAssistenza UTENTICAMPIESTIVI.Richiestaassistenza%TYPE;
	temp NUMBER(10) := 0;
    temp2 NUMBER(10) := 0;
	temp3 NUMBER(10) := 0;
	NomeTutore UTENTI.Nome%TYPE;
    CognomeTutore UTENTI.Cognome%TYPE;
	idTutoreUtente UTENTI.idutente%TYPE;
	varidTutore UTENTI.idutente%TYPE;
	idSessione NUMBER(5) := modgui1.get_id_sessione();

BEGIN

	select NOME, COGNOME, DATANASCITA, INDIRIZZO, EMAIL, RECAPITOTELEFONICO
	into NomeUtente, CognomeUtente, DataNascitaUtente, IndirizzoUtente, EmailUtente, RecapitoTelefonicoUtente
	from UTENTI
	where IDUTENTE = utenteID;
	
	select count(*) into temp from UTENTIMUSEO
	where utenteID = UTENTIMUSEO.idutente;

	if temp > 0 then
		select Donatore into UtenteDonatore from UTENTIMUSEO
		where utenteID = UTENTIMUSEO.idutente;
	end if;

	select count(*) into temp2 from UTENTICAMPIESTIVI
	where utenteID = UTENTICAMPIESTIVI.idutente;

	if temp2 > 0 then
		select Richiestaassistenza into UtenteAssistenza from UTENTICAMPIESTIVI
		where utenteID = UTENTICAMPIESTIVI.idutente;
	end if;

	select count(*) into temp3 from TUTORI
	where IDTUTELATO = utenteID;

	
	if temp3 > 0 THEN
		select idtutore into idTutoreUtente from TUTORI
		where IDTUTELATO = utenteID;
	end if;
	

	IF SQL%FOUND
	THEN

		MODGUI1.ApriPagina('Profile utente', idSessione);
		HTP.BodyOpen;
		if idSessione IS NULL then
            modGUI1.Header(0);
		else
				modGUI1.Header(idSessione);
		end if;
		modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom w3-padding-large" style="max-width:600px; margin-top:110px"');
		HTP.header(2, 'Modifica utente');
		MODGUI1.ApriForm('ModificaDatiUtente');
		HTP.FORMHIDDEN('utenteID',utenteID);
		MODGUI1.Label('Nome*');
		MODGUI1.InputText('nomeNew', 'Nome utente', 1, NomeUtente);
		HTP.BR;
		MODGUI1.Label('Cognome*');
		MODGUI1.InputText('cognomeNew', 'Cognome utente', 1, CognomeUtente);
		HTP.BR;
		MODGUI1.Label('Data nascita*');
		MODGUI1.InputDate('dataNascita', 'dataNascitaNew', 1, DataNascitaUtente);
		HTP.BR;
		modgui1.label('Tutore*');
		modgui1.selectopen('utenteTutoreNew', 'idutentetutore');
		MODGUI1.SelectOption(0, 'Tutore non necessario', 0);
		for utente in (select idutente from utenti where ELIMINATO = 0)
		loop
			select idutente, nome, cognome
			into varidTutore, NomeTutore, CognomeTutore
			from utenti
			where idutente=utente.idutente;
			if idTutoreUtente = varidTutore then 
				MODGUI1.SelectOption(varidTutore, ''|| NomeTutore ||' '||CognomeTutore||'', 1);
			else
				MODGUI1.SelectOption(varidTutore, ''|| NomeTutore ||' '||CognomeTutore||'', 0);
			end if;
		end loop;
		modgui1.selectclose();
		HTP.BR;
		MODGUI1.Label('Indirizzo*');
		MODGUI1.InputText('indirizzoNew', 'Indirizzo', 1, IndirizzoUtente);
		HTP.BR;
		MODGUI1.Label('Email*');
		MODGUI1.InputText('utenteEmailNEW', 'Email', 1, EmailUtente);
		HTP.BR;
		MODGUI1.Label('Telefono');
		MODGUI1.InputText('telefonoNew', 'Telefono', 0, RecapitoTelefonicoUtente);
		HTP.BR;
		if temp > 0 then
		MODGUI1.InputCheckboxOnClick('Utente museo', 'utenteMuseoNew','check()','utentemuseo', 1);
		MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%; display: block" id="first"');
		else
			MODGUI1.InputCheckboxOnClick('Utente museo', 'utenteMuseoNew','check()','utentemuseo');
			MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%; display: none" id="first"');
		end if;
		HTP.BR;
		if utenteDonatore = 1 then
			MODGUI1.InputCheckbox('Donatore', 'utenteDonatoreNew', 1);
		else
			MODGUI1.InputCheckbox('Donatore', 'utenteDonatoreNew');
		end if;
		HTP.BR;
		MODGUI1.ChiudiDiv;
		HTP.BR;
		if temp2 > 0 then
			MODGUI1.InputCheckboxOnClick('Utente campi estivi', 'utenteCampiEstiviNew', 'check2()', 'utentecampiestivi', 1);
			MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%; display: block" id="second"');
		else
			MODGUI1.InputCheckboxOnClick('Utente campi estivi', 'utenteCampiEstiviNew', 'check2()', 'utentecampiestivi');
			MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%; display: none" id="second"');
		end if;
		HTP.BR;
		if utenteAssistenza = 1 then
			MODGUI1.InputCheckbox('Richiede assistenza', 'utenteAssistenzaNew', 1);
		else
			MODGUI1.InputCheckbox('Richiede assistenza', 'utenteAssistenzaNew');
		end if;
		HTP.BR;
		MODGUI1.ChiudiDiv;

		MODGUI1.InputSubmit('Salva');
		MODGUI1.ChiudiForm;
		MODGUI1.Collegamento(
            'Annulla',
			'VisualizzaUtente?utenteID='||utenteID,
			'w3-button w3-block w3-black w3-section w3-padding'
        );
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
	ELSE
		modGUI1.RedirectEsito('Errore', 
            'Impossibile visualizzare l''utente selezionato', 
            'Riprova', 'ModificaUtente?utenteID='||utenteID, null,
            'Torna al menu utenti', 'ListaUtenti', null);
	END IF;
END;

PROCEDURE ModificaDatiUtente (
	utenteID NUMBER,
	nomeNew VARCHAR2 DEFAULT NULL,
	cognomeNew VARCHAR2 DEFAULT NULL,
	dataNascitaNew VARCHAR2 DEFAULT NULL,
	indirizzoNew VARCHAR2 DEFAULT NULL,
	utenteEmailNew VARCHAR2 DEFAULT NULL,
    telefonoNew VARCHAR2 DEFAULT NULL,
	utenteMuseoNew VARCHAR2 DEFAULT NULL,
	utenteDonatoreNew VARCHAR2 DEFAULT NULL,
	utenteCampiEstiviNew VARCHAR2 DEFAULT NULL,
	utenteAssistenzaNew VARCHAR2 DEFAULT NULL,
	utenteTutoreNew NUMBER DEFAULT 0
) IS
    birth DATE := TO_DATE(dataNascitaNew default NULL on conversion error, 'YYYY-MM-DD');
    EmailPresente EXCEPTION;
    TelefonoPresente EXCEPTION;
    temp NUMBER(10) := 0;
    temp2 NUMBER(10) := 0;
	temp3 NUMBER(10) := 0;
    temp4 NUMBER(10) := 0;
	temp5 NUMBER(10) := 0;
	EmailUtente UTENTI.Email%TYPE;
	RecapitoTelefonicoUtente UTENTI.RecapitoTelefonico%TYPE;
	idSessione NUMBER(5) := modgui1.get_id_sessione();

BEGIN

	select email into EmailUtente from UTENTI where utenteID = UTENTI.IDutente;

	if EmailUtente != utenteEmailNew then
		SELECT count(*) INTO temp FROM UTENTI WHERE UTENTI.Email = utenteEmailNew;
		IF temp > 0 THEN
			RAISE EmailPresente;
		END IF;
	end if;

	select RecapitoTelefonico into RecapitoTelefonicoUtente from UTENTI where utenteID = UTENTI.IDutente;

	if RecapitoTelefonicoUtente != telefonoNew then
		select count(*) INTO temp2 from UTENTI where RecapitoTelefonico = telefonoNew;
		IF temp2 > 0 THEN
			RAISE TelefonoPresente;
		END IF;
	end if;

	UPDATE UTENTI SET
		nome=nomeNew,
		cognome=cognomeNew,
		dataNascita=birth,
		indirizzo=indirizzoNew,
		email=utenteEmailNew,
		recapitotelefonico=telefonoNew
	WHERE IDutente=utenteID;


	select count(*) into temp3 from UTENTIMUSEO where UTENTIMUSEO.IdUtente = utenteID;

	if temp3 > 0 then
		if utenteMuseoNew = 'on' then
			if utenteDonatoreNew = 'on' then
				update UTENTIMUSEO set
					donatore=1
				where idutente=utenteID;
			else
				update UTENTIMUSEO set
					donatore=0
				where idutente=utenteID;
			end if;
		else
			delete from UTENTIMUSEO where idutente=utenteID;
		end if;
	else
		if utenteDonatoreNew = 'on' then
			insert into UTENTIMUSEO
			values (utenteID, 1);
		else
			insert into UTENTIMUSEO
			values (utenteID, 0);
		end if;
	end if;

	select count(*) into temp4 from UTENTICAMPIESTIVI where UTENTICAMPIESTIVI.IdUtente = utenteID;

	if temp4 > 0 then
		if utenteCampiEstiviNew = 'on' then
			if utenteCampiEstiviNew = 'on' then
				update UTENTICAMPIESTIVI set
					Richiestaassistenza=1
				where idutente=utenteID;
			else
				update UTENTICAMPIESTIVI set
					Richiestaassistenza=0
				where idutente=utenteID;
			end if;
		else
			delete from UTENTICAMPIESTIVI where idutente=utenteID;
		end if;
	else
		if utenteCampiEstiviNew = 'on' then
			insert into UTENTICAMPIESTIVI
			values (utenteID, 1);
		else
			insert into UTENTICAMPIESTIVI
			values (utenteID, 0);
		end if;
	end if;

	select count(*) into temp5 from TUTORI where IDTUTELATO = utenteID;

	if temp5 > 0 THEN
		if utenteTutoreNew = 0 then
			delete from TUTORI where IDTUTELATO = utenteID;
		else
			update tutori set
				IDTUTORE = utenteTutoreNew
			where IDTUTELATO = utenteID;
		end if;
	else
		if utenteTutoreNew != 0 THEN
			insert into TUTORI
			values (utenteTutoreNew, utenteID);
		end if;
	end if;
	 
	IF SQL%FOUND THEN
		commit;
		modGUI1.RedirectEsito('Successo', 
            'L''utente '||nomeNew||' '||cognomeNew||' è stato modificato correttamente', 
            'Visualizza utente', 'VisualizzaUtente?utenteID='||utenteID, null,
            'Torna al menu utenti', 'ListaUtenti', null);
	ELSE
		modGUI1.RedirectEsito('Errore', 
            'L''utente non è stato modificato', 
            'Riprova', 'ModificaUtente?utenteID='||utenteID, null,
            'Torna al menu utenti', 'ListaUtenti', null);
	END IF;


END;

PROCEDURE EliminaUtente(
	utenteID NUMBER
)
IS
BEGIN

	/*delete from UTENTIMUSEO where IDUTENTE=utenteID;
	delete from UTENTICAMPIESTIVI where IDUTENTE=utenteID;*/
	update UTENTI 
	set ELIMINATO = 1
	where IDUTENTE=utenteID;

	IF SQL%FOUND THEN
		commit;
		EsitoPositivoUtenti;
	ELSE
		EsitoNegativoUtenti;
	END IF;

END;

PROCEDURE ListaUtenti(
	pcognome VARCHAR2 DEFAULT NULL
)
is
idSessione NUMBER(5) := modgui1.get_id_sessione();
begin
        modGUI1.ApriPagina('Lista utenti',idSessione);
        if idSessione IS NULL then
            modGUI1.Header(0);
		else
				modGUI1.Header(idSessione);
		end if;
		modGUI1.ApriDiv('class="w3-center" style="margin-top:110px;"');
        htp.prn('<h1>Lista utenti</h1>');
		if hasRole(idSessione, 'DBA') or hasRole(idSessione, 'SU')
        then
            modGUI1.Collegamento('Inserisci','InserisciUtente','w3-btn w3-round-xxlarge w3-black');
            htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
        end if;
            modGUI1.Collegamento('Statistiche','StatisticheUtenti','w3-btn w3-round-xxlarge w3-black');
			modgui1.APRIDIV('style="width: 150px; margin: auto"');
			MODGUI1.ApriForm('ListaUtenti');
			MODGUI1.InputText('pcognome', 'Filtra per cognome', 1);
			MODGUI1.InputSubmit('Filtra');
			MODGUI1.ChiudiForm;
			 modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
        htp.br;
        modGUI1.ApriDiv('class="w3-row w3-container"');
   		for utente in (select * from utenti where ELIMINATO = 0 and cognome LIKE '%'||pcognome||'%' order by cognome, nome)  loop
                modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                    modGUI1.ApriDiv('class="w3-card-4" style="height:200px;"');
						modGUI1.ApriDiv('class="w3-container w3-center"');
							htp.prn('<p>'|| utente.nome || ' ' || utente.cognome ||'</p>');
							htp.br;
						modGUI1.ChiudiDiv;
						modGUI1.Collegamento('Visualizza',
                            'VisualizzaUtente?utenteID='||utente.Idutente,
                            'w3-margin w3-green w3-button');
                        if hasRole(idSessione, 'DBA') or hasRole(idSessione, 'SU') then
						modGUI1.Collegamento('Modifica',
                            'ModificaUtente?utenteID='||utente.Idutente,
                            'w3-margin w3-blue w3-button');
                        modGUI1.Collegamento('Elimina',
                            'EliminaUtente?utenteID='||utente.Idutente,
                            'w3-red w3-margin w3-button',
							'return confirm(''Sei sicuro di voler eliminare il profilo di '||utente.nome||' '||utente.cognome||'?'')'
							);
                    	end if;
                	modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
        END LOOP;
        modGUI1.chiudiDiv;
end;

procedure etaMediaUtenti
is
	tempMedia NUMBER := 0;
	res INTEGER := 0;
	idSessione NUMBER(5) := modgui1.get_id_sessione();
	BEGIN
		select AVG(to_number((EXTRACT(YEAR FROM dataNascita)))) into tempMedia from utenti;
		res := to_number((EXTRACT(YEAR FROM SYSDATE()))) - tempMedia;

		modGUI1.ApriPagina('EsitoPositivoUtenti',idSessione);
         if idSessione IS NULL then
            modGUI1.Header(0);
		else
				modGUI1.Header(idSessione);
		end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom w3-padding-large" style="max-width:450px"');
                modGUI1.ApriDiv('class="w3-center"');
                htp.print('<h1>Operazione eseguita correttamente </h1>');
				htp.print('<h3>Il risultato è '||res||'</h3>');
                MODGUI1.collegamento('Torna alle statistiche','StatisticheUtenti','w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
			HTP.BodyClose;
		HTP.HtmlClose;

END;

procedure sommaTitoli(
	dataInizioFun VARCHAR2 DEFAULT NULL,
	dataFineFun VARCHAR2 DEFAULT NULL,
	utenteID NUMBER DEFAULT 0,
	museoID NUMBER DEFAULT 0
)
is
	dataInizio DATE := TO_DATE(dataInizioFun default NULL on conversion error, 'YYYY-MM-DD');
	dataFine DATE := TO_DATE(dataFineFun default NULL on conversion error, 'YYYY-MM-DD');
	tempMedia NUMBER := 0;
	res NUMBER := 0;
	idSessione NUMBER(5) := modgui1.get_id_sessione();
	cursor musei_c is (
				select museo, count(*) as ctitoli
				from TITOLIINGRESSO
				where Emissione > dataInizio and Emissione < dataFine
				group by MUSEO
			);
	cursor musei_cu is (
				select museo, count(*) as ctitoli
				from TITOLIINGRESSO
				where Emissione > dataInizio and Emissione < dataFine and titoliingresso.ACQUIRENTE = utenteID
				group by MUSEO
			);
	BEGIN
		if utenteID = 0 and museoID = 0 then
			select COUNT(*)
			into res
			from titoliingresso
			where Emissione > dataInizio and Emissione < dataFine;
		ELSIF utenteID = 0 and museoID != 0 then
			select COUNT(*)
			into res
			from titoliingresso
			where Emissione > dataInizio and Emissione < dataFine and MUSEO = museoID;
		ELSIF utenteID != 0 and museoID = 0 then
			select COUNT(*)
			into res
			from titoliingresso
			where Emissione > dataInizio and Emissione < dataFine and titoliingresso.ACQUIRENTE = utenteID;
		else
			select COUNT(*)
			into res
			from titoliingresso
			where Emissione > dataInizio and Emissione < dataFine and titoliingresso.ACQUIRENTE = utenteID and MUSEO = museoID;
		end if;

		modGUI1.ApriPagina('Statistiche utenti',idSessione);
         if idSessione IS NULL then
            modGUI1.Header(0);
		else
				modGUI1.Header(idSessione);
		end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom w3-padding-large" style="max-width:450px"');
                modGUI1.ApriDiv('class="w3-center"');
                htp.print('<h1>Operazione eseguita correttamente </h1>');
				if res > 0 then
					htp.print('<h3>Il risultato è '||res||'</h3>');
					if utenteID = 0 and museoID = 0 then
						modgui1.apriTabella('w3-table w3-striped w3-centered');
						modgui1.apriRigaTabella;
						modgui1.intestazioneTabella('Museo');
						modgui1.intestazioneTabella('Somma titoli di ingresso');
						modgui1.chiudiRigaTabella;
						for x in musei_c
						LOOP
						modgui1.apriRigaTabella;
						modgui1.apriElementoTabella;
						htp.print(x.museo);
						modgui1.chiudiElementoTabella;
						modgui1.apriElementoTabella;
						htp.print(x.ctitoli);
						modgui1.chiudiElementoTabella;
						modgui1.chiudiRigaTabella;
						end LOOP;
						modgui1.chiudiTabella;
					ELSIF utenteID != 0 and museoID = 0 then
						modgui1.apriTabella('w3-table w3-striped w3-centered');
						modgui1.apriRigaTabella;
						modgui1.intestazioneTabella('Museo');
						modgui1.intestazioneTabella('Somma titoli di ingresso');
						modgui1.chiudiRigaTabella;
						for x in musei_cu
						LOOP
						modgui1.apriRigaTabella;
						modgui1.apriElementoTabella;
						htp.print(x.museo);
						modgui1.chiudiElementoTabella;
						modgui1.apriElementoTabella;
						htp.print(x.ctitoli);
						modgui1.chiudiElementoTabella;
						modgui1.chiudiRigaTabella;
						end LOOP;
						modgui1.chiudiTabella;
					end if;
				else
					htp.print('<h3>Il risultato è 0</h3>');
				end if;
                MODGUI1.collegamento('Torna alle statistiche','StatisticheUtenti','w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
			HTP.BodyClose;
		HTP.HtmlClose;
END;

procedure mediaCostoTitoli(
	dataInizioFun VARCHAR2 DEFAULT NULL,
	dataFineFun VARCHAR2 DEFAULT NULL,
	utenteID NUMBER DEFAULT 0,
	museoID NUMBER DEFAULT 0
)
is
	dataInizio DATE := TO_DATE(dataInizioFun default NULL on conversion error, 'YYYY-MM-DD');
	dataFine DATE := TO_DATE(dataFineFun default NULL on conversion error, 'YYYY-MM-DD');
	tempMedia NUMBER := 0;
	res NUMBER(6) := 0;
	idSessione NUMBER(5) := modgui1.get_id_sessione();
	cursor musei_c is (
				select museo, AVG(COSTOTOTALE) as mtitoli
				from tipologieingresso
				join titoliingresso on idtipologiaing = tipologia
				where Emissione > dataInizio and Emissione < dataFine
				group by museo
			);
	cursor musei_cu is (
				select museo, AVG(COSTOTOTALE) as mtitoli
				from tipologieingresso
				join titoliingresso on idtipologiaing = tipologia
				where Emissione > dataInizio and Emissione < dataFine and titoliingresso.ACQUIRENTE = utenteID
				group by museo
			);
	BEGIN
		if utenteID = 0 and museoID = 0 then
			select AVG(COSTOTOTALE)
			into res
			from tipologieingresso
			join titoliingresso on idtipologiaing = tipologia
			where Emissione > dataInizio and Emissione < dataFine;
		ELSIF utenteID = 0 and museoID != 0 then
			select AVG(COSTOTOTALE)
			into res
			from tipologieingresso
			join titoliingresso on idtipologiaing = tipologia
			where Emissione > dataInizio and Emissione < dataFine and MUSEO = museoID;
		ELSIF utenteID != 0 and museoID = 0 then
			select AVG(COSTOTOTALE)
			into res
			from tipologieingresso
			join titoliingresso on idtipologiaing = tipologia
			where Emissione > dataInizio and Emissione < dataFine and titoliingresso.ACQUIRENTE = utenteID;
		else
			select AVG(COSTOTOTALE)
			into res
			from tipologieingresso
			join titoliingresso on idtipologiaing = tipologia
			where Emissione > dataInizio and Emissione < dataFine and titoliingresso.ACQUIRENTE = utenteID and MUSEO = museoID;
		end if;

		modGUI1.ApriPagina('Statistiche utenti',idSessione);
         if idSessione IS NULL then
            modGUI1.Header(0);
		else
				modGUI1.Header(idSessione);
		end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom w3-padding-large" style="max-width:450px"');
                modGUI1.ApriDiv('class="w3-center"');
                htp.print('<h1>Operazione eseguita correttamente </h1>');
				if res > 0 then
					htp.print('<h3>Il risultato è '||res||'</h3>');
					if utenteID = 0 and museoID = 0 then
						modgui1.apriTabella('w3-table w3-striped w3-centered');
						modgui1.apriRigaTabella;
						modgui1.intestazioneTabella('Museo');
						modgui1.intestazioneTabella('Media titoli di ingresso');
						modgui1.chiudiRigaTabella;
						for x in musei_c
						LOOP
						modgui1.apriRigaTabella;
						modgui1.apriElementoTabella;
						htp.print(x.museo);
						modgui1.chiudiElementoTabella;
						modgui1.apriElementoTabella;
						htp.print(x.mtitoli);
						modgui1.chiudiElementoTabella;
						modgui1.chiudiRigaTabella;
						end LOOP;
						modgui1.chiudiTabella;
					ELSIF utenteID != 0 and museoID = 0 then
						modgui1.apriTabella('w3-table w3-striped w3-centered');
						modgui1.apriRigaTabella;
						modgui1.intestazioneTabella('Museo');
						modgui1.intestazioneTabella('Media titoli di ingresso');
						modgui1.chiudiRigaTabella;
						for x in musei_cu
						LOOP
						modgui1.apriRigaTabella;
						modgui1.apriElementoTabella;
						htp.print(x.museo);
						modgui1.chiudiElementoTabella;
						modgui1.apriElementoTabella;
						htp.print(x.mtitoli);
						modgui1.chiudiElementoTabella;
						modgui1.chiudiRigaTabella;
						end LOOP;
						modgui1.chiudiTabella;
					end if;
				else
					htp.print('<h3>Il risultato è 0</h3>');
				end if;
                MODGUI1.collegamento('Torna alle statistiche','StatisticheUtenti','w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
			HTP.BodyClose;
		HTP.HtmlClose;
END;

procedure NumeroVisiteMusei(
	dataInizioFun VARCHAR2 DEFAULT NULL,
	dataFineFun VARCHAR2 DEFAULT NULL,
	utenteID NUMBER DEFAULT 0,
	museoID NUMBER DEFAULT 0
)
is
	dataInizio DATE := TO_DATE(dataInizioFun default NULL on conversion error, 'YYYY-MM-DD');
	dataFine DATE := TO_DATE(dataFineFun default NULL on conversion error, 'YYYY-MM-DD');
	tempMedia NUMBER := 0;
	res NUMBER(6) := 0;
	idSessione NUMBER(5) := modgui1.get_id_sessione();
	cursor musei_c is (
				select MUSEO, COUNT(*) as cvisite
				from visite
				join TITOLIINGRESSO on visite.TITOLOINGRESSO = IDTITOLOING
				where datavisita > dataInizio and datavisita < dataFine
				GROUP BY MUSEO
			);
	cursor musei_cu is (
				select MUSEO, COUNT(*) cvisite
				from visite
				join TITOLIINGRESSO on visite.TITOLOINGRESSO = IDTITOLOING
				where datavisita > dataInizio and datavisita < dataFine and visite.visitatore = utenteID
				GROUP BY MUSEO
			);
	BEGIN
		if utenteID = 0 and museoID = 0 then
			select COUNT(*)
			into res
			from visite
			where datavisita > dataInizio and datavisita < dataFine;
		ELSIF utenteID != 0 and museoID = 0 THEN
			select COUNT(*)
			into res
			from visite
			where datavisita > dataInizio and datavisita < dataFine and visite.visitatore = utenteID;
		ELSIF utenteID = 0 and museoID != 0 THEN
			select COUNT(*)
			into res
			from visite
			join titoliingresso on IDTITOLOING = TITOLOINGRESSO
			where datavisita > dataInizio and datavisita < dataFine and MUSEO = museoID;
		else 
			select COUNT(*)
			into res
			from visite
			join titoliingresso on IDTITOLOING = TITOLOINGRESSO
			where datavisita > dataInizio and datavisita < dataFine and visite.visitatore = utenteID and MUSEO = museoID;
		end if;

		modGUI1.ApriPagina('Statistiche utenti',idSessione);
        if idSessione IS NULL then
            modGUI1.Header(0);
		else
				modGUI1.Header(idSessione);
		end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom w3-padding-large" style="max-width:450px"');
                modGUI1.ApriDiv('class="w3-center"');
                htp.print('<h1>Operazione eseguita correttamente </h1>');
				if res > 0 then
					htp.print('<h3>Il risultato è '||res||'</h3>');
					if utenteID = 0 and museoID = 0 then
						modgui1.apriTabella('w3-table w3-striped w3-centered');
						modgui1.apriRigaTabella;
						modgui1.intestazioneTabella('Museo');
						modgui1.intestazioneTabella('Numero visite musei');
						modgui1.chiudiRigaTabella;
						for x in musei_c
						LOOP
						modgui1.apriRigaTabella;
						modgui1.apriElementoTabella;
						htp.print(x.museo);
						modgui1.chiudiElementoTabella;
						modgui1.apriElementoTabella;
						htp.print(x.cvisite);
						modgui1.chiudiElementoTabella;
						modgui1.chiudiRigaTabella;
						end LOOP;
						modgui1.chiudiTabella;
					ELSIF utenteID != 0 and museoID = 0 then
						modgui1.apriTabella('w3-table w3-striped w3-centered');
						modgui1.apriRigaTabella;
						modgui1.intestazioneTabella('Museo');
						modgui1.intestazioneTabella('Numero visite musei');
						modgui1.chiudiRigaTabella;
						for x in musei_cu
						LOOP
						modgui1.apriRigaTabella;
						modgui1.apriElementoTabella;
						htp.print(x.museo);
						modgui1.chiudiElementoTabella;
						modgui1.apriElementoTabella;
						htp.print(x.cvisite);
						modgui1.chiudiElementoTabella;
						modgui1.chiudiRigaTabella;
						end LOOP;
						modgui1.chiudiTabella;
					end if;
				else
					htp.print('<h3>Il risultato è 0</h3>');
				end if;
                MODGUI1.collegamento('Torna alle statistiche','StatisticheUtenti','w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
			HTP.BodyClose;
		HTP.HtmlClose;
END;

procedure NumeroMedioTitoli(
	dataInizioFun VARCHAR2 DEFAULT NULL,
	dataFineFun VARCHAR2 DEFAULT NULL,
	museoID NUMBER DEFAULT 0
)
is
	dataInizio DATE := TO_DATE(dataInizioFun default NULL on conversion error, 'YYYY-MM-DD');
	dataFine DATE := TO_DATE(dataFineFun default NULL on conversion error, 'YYYY-MM-DD');
	tempMedia NUMBER := 0;
	res NUMBER(6) := 0;
	res2 NUMBER(6) := 0;
	idSessione NUMBER(5) := modgui1.get_id_sessione();
	cursor musei_c is (
				select MUSEO, COUNT(*) as cvisite
				from TITOLIINGRESSO
				where emissione > dataInizio and emissione < dataFine
				GROUP BY MUSEO
			);
	BEGIN

		select COUNT(*)
		into res
		from utenti;

		if museoID = 0 then 
			select COUNT(*)
			into res2
			from titoliingresso
			where emissione > dataInizio and emissione < dataFine;
		else
			select COUNT(*)
			into res2
			from titoliingresso
			where emissione > dataInizio and emissione < dataFine and museoID = MUSEO;
		end if;


		modGUI1.ApriPagina('Statistiche utenti',idSessione);
        if idSessione IS NULL then
            modGUI1.Header(0);
		else
				modGUI1.Header(idSessione);
		end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom w3-padding-large" style="max-width:450px"');
                modGUI1.ApriDiv('class="w3-center"');
                htp.print('<h1>Operazione eseguita correttamente </h1>');
				if res > 0 then
					htp.print('<h3>Il risultato è '||res2/res||'</h3>');
					if museoID = 0 then
						modgui1.apriTabella('w3-table w3-striped w3-centered');
						modgui1.apriRigaTabella;
						modgui1.intestazioneTabella('Museo');
						modgui1.intestazioneTabella('Numero medio visite musei');
						modgui1.chiudiRigaTabella;
						for x in musei_c
						LOOP
						modgui1.apriRigaTabella;
						modgui1.apriElementoTabella;
						htp.print(x.museo);
						modgui1.chiudiElementoTabella;
						modgui1.apriElementoTabella;
						htp.print(x.cvisite/res);
						modgui1.chiudiElementoTabella;
						modgui1.chiudiRigaTabella;
						end LOOP;
						modgui1.chiudiTabella;
					end if;
				else
					htp.print('<h3>Il risultato è 0</h3>');
				end if;
                MODGUI1.collegamento('Torna alle statistiche','StatisticheUtenti','w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
			HTP.BodyClose;
		HTP.HtmlClose;
END;


procedure StatisticheUtenti
is
	nomeutente utenti.nome%TYPE;
	cognomeutente utenti.cognome%TYPE;
	varidutente utenti.Idutente%TYPE;
	varidmuseo musei.idmuseo%TYPE;
	nomemuseo musei.nome%TYPE;
	idSessione NUMBER(5) := modgui1.get_id_sessione();
begin
		MODGUI1.ApriPagina('Statistiche utente', idSessione);
			HTP.BodyOpen;
			if idSessione IS NULL then
            modGUI1.Header(0);
		else
				modGUI1.Header(idSessione);
		end if;
			modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="margin-top:110px"');
			htp.print('<h1 class="w3-center">Statistiche</h1>');
			htp.br;htp.br;
			modgui1.apriTabella('w3-table w3-striped w3-centered');
				modgui1.apriRigaTabella;
				modgui1.intestazioneTabella('Dati');
				modgui1.intestazioneTabella('Operazione');
				modgui1.intestazioneTabella('Risultato');
				modgui1.chiudiRigaTabella;

				modgui1.apriRigaTabella;
					MODGUI1.ApriForm('etaMediaUtenti');
					modgui1.apriElementoTabella;
						modgui1.apridiv('class="w3-padding-24"');
						modgui1.elementoTabella('Tutti gli utenti');
						modgui1.chiudiDiv;
					modgui1.chiudiElementoTabella;
					modgui1.apriElementoTabella;
						modgui1.apridiv('class="w3-padding-24"');
						modgui1.elementoTabella('Media delle date di nascita');
						modgui1.chiudiDiv;
					modgui1.chiudiElementoTabella;
					modgui1.apriElementoTabella;
						MODGUI1.InputSubmit('Calcola');
					modgui1.chiudiElementoTabella;
					MODGUI1.ChiudiForm;
				modgui1.chiudiRigaTabella;

				modgui1.apriRigaTabella;
					MODGUI1.ApriForm('sommaTitoli');
					modgui1.apriElementoTabella;
						modgui1.label('Utente');
							modgui1.selectopen('utenteID', 'idutenteSommaTitoli');
							MODGUI1.SelectOption(0, 'Tutti gli utenti', 0);
							for utente in (select idutente from utentimuseo)
							loop
								select idutente, nome, cognome
								into varidutente, nomeutente, cognomeutente
								from utenti
								where idutente=utente.idutente;
								MODGUI1.SelectOption(varidutente, ''|| nomeutente ||' '||cognomeutente||'', 0);
							end loop;
							modgui1.selectclose();
							htp.br;
							modgui1.label('Museo');
							modgui1.selectopen('museoID', 'idmuseiSommaTitoli');
							MODGUI1.SelectOption(0, 'Tutti i musei', 0);
							for museo in (select idmuseo from musei)
							loop
								select idmuseo, nome
								into varidmuseo, nomemuseo
								from musei
								where idmuseo=museo.idmuseo;
								MODGUI1.SelectOption(varidmuseo, ''|| nomemuseo ||'', 0);
							end loop;
							modgui1.selectclose();
							htp.br;
							MODGUI1.Label('Data inizio');
							MODGUI1.InputDate('dataInizioFun', 'dataInizioFun', 1);
							htp.br;
							MODGUI1.Label('Data fine');
							MODGUI1.InputDate('dataFineFun', 'dataFineFun', 1);
					modgui1.chiudiElementoTabella;
					modgui1.apriElementoTabella;
						modgui1.apridiv('class="w3-padding-24"');
						modgui1.elementoTabella('Numero Titoli d’Ingresso acquistati');
						modgui1.chiudiDiv;
					modgui1.chiudiElementoTabella;
					modgui1.apriElementoTabella;
						MODGUI1.InputSubmit('Calcola');
					modgui1.chiudiElementoTabella;
					MODGUI1.ChiudiForm;
				modgui1.chiudiRigaTabella;

				modgui1.apriRigaTabella;
					MODGUI1.ApriForm('mediaCostoTitoli');
					modgui1.apriElementoTabella;
						modgui1.label('Utente');
							modgui1.selectopen('utenteID', 'idutenteSommaTitoli');
							MODGUI1.SelectOption(0, 'Tutti gli utenti', 0);
							for utente in (select idutente from utentimuseo)
							loop
								select idutente, nome, cognome
								into varidutente, nomeutente, cognomeutente
								from utenti
								where idutente=utente.idutente;
								MODGUI1.SelectOption(varidutente, ''|| nomeutente ||' '||cognomeutente||'', 0);
							end loop;
							modgui1.selectclose();
							htp.br;
							modgui1.label('Museo');
							modgui1.selectopen('museoID', 'idmuseiSommaTitoli');
							MODGUI1.SelectOption(0, 'Tutti i musei', 0);
							for museo in (select idmuseo from musei)
							loop
								select idmuseo, nome
								into varidmuseo, nomemuseo
								from musei
								where idmuseo=museo.idmuseo;
								MODGUI1.SelectOption(varidmuseo, ''|| nomemuseo ||'', 0);
							end loop;
							modgui1.selectclose();
							htp.br;
							MODGUI1.Label('Data inizio');
							MODGUI1.InputDate('dataInizioFun', 'dataInizioFun', 1);
							htp.br;
							MODGUI1.Label('Data fine');
							MODGUI1.InputDate('dataFineFun', 'dataFineFun', 1);
					modgui1.chiudiElementoTabella;
					modgui1.apriElementoTabella;
						modgui1.apridiv('class="w3-padding-24"');
						modgui1.elementoTabella('Costo medio Titoli d’Ingresso acquistati');
						modgui1.chiudiDiv;
					modgui1.chiudiElementoTabella;
					modgui1.apriElementoTabella;
						MODGUI1.InputSubmit('Calcola');
					modgui1.chiudiElementoTabella;
					MODGUI1.ChiudiForm;
				modgui1.chiudiRigaTabella;

				modgui1.apriRigaTabella;
					MODGUI1.ApriForm('NumeroVisiteMusei');
					modgui1.apriElementoTabella;
						modgui1.label('Utente');
							modgui1.selectopen('utenteID', 'idutenteSommaTitoli');
							MODGUI1.SelectOption(0, 'Tutti gli utenti', 0);
							for utente in (select idutente from utentimuseo)
							loop
								select idutente, nome, cognome
								into varidutente, nomeutente, cognomeutente
								from utenti
								where idutente=utente.idutente;
								MODGUI1.SelectOption(varidutente, ''|| nomeutente ||' '||cognomeutente||'', 0);
							end loop;
							modgui1.selectclose();
							htp.br;
							modgui1.label('Museo');
							modgui1.selectopen('museoID', 'idmuseiSommaTitoli');
							MODGUI1.SelectOption(0, 'Tutti i musei', 0);
							for museo in (select idmuseo from musei)
							loop
								select idmuseo, nome
								into varidmuseo, nomemuseo
								from musei
								where idmuseo=museo.idmuseo;
								MODGUI1.SelectOption(varidmuseo, ''|| nomemuseo ||'', 0);
							end loop;
							modgui1.selectclose();
							htp.br;
							MODGUI1.Label('Data inizio');
							MODGUI1.InputDate('dataInizioFun', 'dataInizioFun', 1);
							htp.br;
							MODGUI1.Label('Data fine');
							MODGUI1.InputDate('dataFineFun', 'dataFineFun', 1);
					modgui1.chiudiElementoTabella;
					modgui1.apriElementoTabella;
						modgui1.apridiv('class="w3-padding-24"');
						modgui1.elementoTabella('Numero visite musei');
						modgui1.chiudiDiv;
					modgui1.chiudiElementoTabella;
					modgui1.apriElementoTabella;
						MODGUI1.InputSubmit('Calcola');
					modgui1.chiudiElementoTabella;
					MODGUI1.ChiudiForm;
				modgui1.chiudiRigaTabella;

				modgui1.apriRigaTabella;
					MODGUI1.ApriForm('NumeroMedioTitoli');
					modgui1.apriElementoTabella;
						modgui1.apridiv('class="w3-padding-24"');
						modgui1.elementoTabella('Tutti gli utenti');
						modgui1.chiudiDiv;
						htp.br;
						modgui1.label('Museo');
						modgui1.selectopen('museoID', 'idmuseiSommaTitoli');
						MODGUI1.SelectOption(0, 'Tutti i musei', 0);
						for museo in (select idmuseo from musei)
						loop
							select idmuseo, nome
							into varidmuseo, nomemuseo
							from musei
							where idmuseo=museo.idmuseo;
							MODGUI1.SelectOption(varidmuseo, ''|| nomemuseo ||'', 0);
						end loop;
						modgui1.selectclose();
						htp.br;
						MODGUI1.Label('Data inizio');
						MODGUI1.InputDate('dataInizioFun', 'dataInizioFun', 1);
						htp.br;
						MODGUI1.Label('Data fine');
						MODGUI1.InputDate('dataFineFun', 'dataFineFun', 1);
					modgui1.chiudiElementoTabella;
					modgui1.apriElementoTabella;
						modgui1.apridiv('class="w3-padding-24"');
						modgui1.elementoTabella('Numero medio visite musei');
						modgui1.chiudiDiv;
					modgui1.chiudiElementoTabella;
					modgui1.apriElementoTabella;
						MODGUI1.InputSubmit('Calcola');
					modgui1.chiudiElementoTabella;
					MODGUI1.ChiudiForm;
				modgui1.chiudiRigaTabella;



			modgui1.chiudiTabella;

			MODGUI1.collegamento('Torna al menu','ListaUtenti?','w3-button w3-block w3-black w3-section w3-padding');
		HTP.BodyClose;
		HTP.HtmlClose;
end;

-------------------------------------------------------------TODO DA TESTARE
/*
PROCEDURE inserisciNewsLetter (
    idSessione NUMBER DEFAULT 0
) IS
BEGIN
	MODGUI1.ApriPagina('Inserimento newsletter', 0);

	HTP.BodyOpen;
	MODGUI1.Header(); --da capire come combinarlo con il resto
	HTP.header(1,'Inserisci una nuova newsletter', 'center');
	MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%;"');

	MODGUI1.ApriForm('inserisci_newsletter');
	HTP.FORMHIDDEN('idSessione',0);

	MODGUI1.Label('Nome*');
	MODGUI1.InputText('nome', 'Nome newsletter', 1);
	HTP.BR;
	MODGUI1.ChiudiDiv;

	MODGUI1.InputSubmit('Inserisci');
	MODGUI1.ChiudiForm;

	MODGUI1.ChiudiDiv;

END;

PROCEDURE inserisci_newsletter (
    idSessione NUMBER DEFAULT 0
	nome varchar2(25) not null
) IS
BEGIN
	MODGUI1.ApriPagina('Inserimento utenti', 0);

	insert into NEWSLETTER
    values (IdNewsSeq.NEXTVAL, nome);

	HTP.BodyOpen;
	MODGUI1.Header(); --da capire come combinarlo con il resto
	HTP.header(1,'Newsletter inserita', 'center');
	MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%;"');

	MODGUI1.ApriForm('inseriscinewsletter');
	HTP.FORMHIDDEN('idSessione',0);

	MODGUI1.Label('Nome');
	MODGUI1.label(nome);
	MODGUI1.ChiudiDiv;

	MODGUI1.InputSubmit('Continuare?');
	MODGUI1.ChiudiForm;

	MODGUI1.ChiudiDiv;

END;




-------------------------------------------------------------FINE TODO */


PROCEDURE statisticheNewsLetter (
	newsletterID NUMBER DEFAULT -1
) IS
	id_sessione NUMBER(10) := NULL;
	temp NUMBER(10) := 0;
	nomeNew VARCHAR2(100) := '';
	numeroVisitatori NUMBER(10) := 0;
	etaMediaIscritti NUMBER(10) := 0;


	--utente
	U_NOME UTENTI.NOME%TYPE :='';
	U_COGNOME UTENTI.COGNOME%TYPE :='';
	U_NASCITA UTENTI.DATANASCITA%TYPE :='';
	U_EMAIL UTENTI.EMAIL%TYPE :='';
	U_INDIRIZZO UTENTI.INDIRIZZO%TYPE :='';
	U_RECAPITO UTENTI.RECAPITOTELEFONICO%TYPE :='';

    newsletterInesistente EXCEPTION;
	idSessioneExecption EXCEPTION;
BEGIN

	id_sessione := modgui1.get_id_sessione;
	if id_sessione = 0
	THEN
		RAISE idSessioneExecption;
	end if;

	if newsletterID = -1
	THEN
		RAISE newsletterInesistente;
	end if;

	SELECT count(*) into temp FROM NEWSLETTER where NEWSLETTER.IDNEWS = newsletterID;

	if temp = 0
	THEN
		RAISE newsletterInesistente;
	end if;

	SELECT NOME into nomeNew FROM NEWSLETTER WHERE NEWSLETTER.IDNEWS = newsletterID;
	SELECT count(*) into numeroVisitatori from UTENTI where IdUtente IN (select VISITATORE from VISITE) AND IDUTENTE IN (SELECT IDUTENTE FROM NEWSLETTERUTENTI WHERE IDNEWS = newsletterID);

	SELECT avg(age) into etaMediaIscritti FROM (SELECT MONTHS_BETWEEN(sysdate, UTENTI.DATANASCITA) / 12 age FROM UTENTI WHERE UTENTI.IDUTENTE IN (SELECT NEWSLETTERUTENTI.IDUTENTE FROM NEWSLETTERUTENTI WHERE NEWSLETTERUTENTI.IDNEWS = newsletterID));


	MODGUI1.ApriPagina('Statistiche');
	modgui1.header();
	modgui1.apridiv('style="margin-top: 110px;text-align:center;"');
	htp.prn(CONCAT('<h1> statistiche per newsletter </h1>', nomeNew));
	htp.br();
	modgui1.Label('Numero visitatori: ');
	modgui1.Label(TO_CHAR(numeroVisitatori));
	htp.br();
	modgui1.Label('Età media iscritti: ');
	modgui1.Label(TO_CHAR(etaMediaIscritti));
	htp.br();

	--hdaidhiaodh
	modgui1.Label('Titoli di ingresso degli iscritti alla newsletter:');
	--per ogni utente che è iscitto alla newsletter
	--mostrare TUTTI i titoli di ingresso che ha acquistato

	SELECT MAX(numb) INTO temp FROM (SELECT count(*) numb FROM TITOLIINGRESSO GROUP BY TITOLIINGRESSO.ACQUIRENTE);

	htp.prn('<table style="width:100%" border="2">');
	htp.prn('<tr>');
		htp.prn('<th> utente </th>');
		for k in 0..temp
		LOOP
			htp.prn(CONCAT(CONCAT('<th> acquisto ', k + 1), '</th>'));
		END LOOP;
	htp.prn('</tr>');
	for id_utente in (	SELECT NEWSLETTERUTENTI.IDUTENTE
						FROM NEWSLETTERUTENTI
						WHERE NEWSLETTERUTENTI.IDNEWS = newsletterID
								AND NEWSLETTERUTENTI.IDUTENTE IN (	SELECT TITOLIINGRESSO.ACQUIRENTE
																	FROM TITOLIINGRESSO))
	LOOP
		--id_utente.IDUTENTE tiene id dell'utente
		htp.prn('<tr>');
		htp.prn('<td>');
		--primo printare i dati dell'utente.
		SELECT UTENTI.NOME, UTENTI.COGNOME, UTENTI.DATANASCITA, UTENTI.INDIRIZZO, UTENTI.EMAIL, UTENTI.RECAPITOTELEFONICO
			INTO U_NOME, U_COGNOME, U_NASCITA, U_INDIRIZZO, U_EMAIL, U_RECAPITO
			FROM UTENTI
			WHERE UTENTI.IDUTENTE = id_utente.IDUTENTE;

		htp.prn(TO_CHAR(U_NOME));
		htp.prn(TO_CHAR(U_COGNOME));
		htp.br;
		htp.prn(TO_CHAR(U_NASCITA, 'YYYY-MM-DD'));
		htp.br;
		htp.prn(TO_CHAR(U_INDIRIZZO));
		htp.br;
		htp.prn(TO_CHAR(U_EMAIL));
		htp.br;
		htp.prn(TO_CHAR(U_RECAPITO));
		htp.prn('</td>');

		FOR titolo IN (
			SELECT *
			FROM TITOLIINGRESSO
			WHERE TITOLIINGRESSO.ACQUIRENTE = id_utente.IDUTENTE
		)
		LOOP
		htp.prn('<td>');
		htp.prn(CONCAT('ID: ', TO_CHAR(titolo.IDTITOLOING)));
		htp.br;
		htp.prn(CONCAT('EMISSIONE: ', TO_CHAR(titolo.EMISSIONE, 'YYYY-MM-DD HH24:MI')));
		htp.br;
		htp.prn(CONCAT('SCADENZA: ', TO_CHAR(titolo.SCADENZA, 'YYYY-MM-DD')));
		htp.br;
		htp.prn(CONCAT('TIPOLOGIA: ', TO_CHAR(titolo.TIPOLOGIA)));
		htp.br;

		htp.prn('</td>');
		END LOOP;

		htp.prn('</tr>');

	END LOOP;
	htp.prn('</table>');
	----dshaheoh
	MODGUI1.chiudiDiv;
	htp.bodyclose;
	htp.htmlclose;
	
	EXCEPTION
	when newsletterInesistente THEN
		MODGUI1.ApriPagina('Errore', id_sessione);
		MODGUI1.Header();
		HTP.BodyOpen;

		MODGUI1.ApriDiv;
		MODGUI1.LABEL('newsletter inesistente');
		MODGUI1.collegamento('visualizza newsletter', 'visualizzaNewsletter');
		MODGUI1.ChiudiDiv;

		HTP.BodyClose;
		HTP.HtmlClose;
	WHEN idSessioneExecption THEN
		MODGUI1.ApriPagina('Errore', id_sessione);
		MODGUI1.Header();
		HTP.BodyOpen;

		MODGUI1.ApriDiv;
		MODGUI1.LABEL('idSessione non settato o corretto');
		MODGUI1.collegamento('visualizza newsletter', 'visualizzaNewsletter');
		MODGUI1.ChiudiDiv;

		HTP.BodyClose;
		HTP.HtmlClose;
	
END;
END GRUPPO1;


			'InserisciUtente?nome='||nome||'&cognome='||cognome||'&dataNascita='||dataNascita||'&indirizzo='||indirizzo||'&email='||email||'&telefono='||telefono||'&utenteMuseo='||utenteMuseo||'&utenteDonatore='||utenteDonatore||'&utenteCampiEstivi='||utenteCampiEstivi||'&utenteAssistenza='||utenteAssistenza||'&utenteTutore='||utenteTutore,
			'w3-button w3-block w3-black w3-section w3-padding'
        );
		MODGUI1.ChiudiDiv;
		HTP.BodyClose;
		HTP.HtmlClose;
	END IF;
	EXCEPTION WHEN OTHERS THEN
		dbms_output.put_line('Error: '||sqlerrm);
END;

PROCEDURE InserisciDatiUtente (
	nome VARCHAR2 DEFAULT NULL,
	cognome VARCHAR2 DEFAULT NULL,
	dataNascita VARCHAR2 DEFAULT NULL,
	indirizzo VARCHAR2 DEFAULT NULL,
	utenteEmail VARCHAR2 DEFAULT NULL,
    telefono VARCHAR2 DEFAULT NULL,
	utenteMuseo VARCHAR2 DEFAULT NULL,
	utenteDonatore VARCHAR2 DEFAULT NULL,
	utenteCampiEstivi VARCHAR2 DEFAULT NULL,
	utenteAssistenza VARCHAR2 DEFAULT NULL,
	utenteTutore NUMBER DEFAULT 0
) IS
    birth DATE := TO_DATE(dataNascita default NULL on conversion error, 'YYYY-MM-DD');
    EmailPresente EXCEPTION;
    TelefonoPresente EXCEPTION;
    temp NUMBER(10) := 0;
    temp2 NUMBER(10) := 0;
	tempIdUtente NUMBER(10) := 0;
	idSessione NUMBER(5) := modgui1.get_id_sessione();

BEGIN

    -- tutti i parametri sono stati controllati prima, dobbiamo solo inserirli nella tabella
    SELECT count(*) INTO temp FROM UTENTI WHERE UTENTI.Email = utenteEmail;

    IF temp > 0 THEN
        RAISE EmailPresente;
    END IF;

    select count(*) INTO temp2 from UTENTI where RecapitoTelefonico = telefono;

    IF temp2 > 0 THEN
        RAISE TelefonoPresente;
    END IF;

    insert into UTENTI
    values (IdUtenteSeq.NEXTVAL, nome, cognome, birth, indirizzo, utenteEmail, telefono, 0);

	select IdUtente into tempIdUtente from UTENTI where UTENTI.Email = utenteEmail;

	if utenteMuseo = 'on' then
		if utenteDonatore = 'on' then
			insert into UTENTIMUSEO
			values (tempIdUtente, 1);
		else
			insert into UTENTIMUSEO
			values (tempIdUtente, 0);
		end if;
	end if;

	if utenteCampiEstivi = 'on' then
		if utenteAssistenza = 'on' then
			insert into UTENTICAMPIESTIVI
			values (tempIdUtente, 1);
		else
			insert into UTENTICAMPIESTIVI
			values (tempIdUtente, 0);
		end if;
	end if;

	if utenteTutore != 0 then
		insert into TUTORI
		values (utenteTutore, tempIdUtente);
	end if;

	IF SQL%FOUND
	THEN
		-- faccio il commit dello statement precedente
		commit;
		modGUI1.RedirectEsito('Successo', 
            'L''utente '||nome||' '||cognome||' è stato inserito correttamente', 
            'Inserisci un nuovo utente', 'InserisciUtente', null,
            'Torna al menu utenti', 'ListaUtenti', null);

	ELSE
		modGUI1.RedirectEsito('Errore', 
            'L''utente '||nome||' '||cognome||' non è stato inserito', 
            'Riprova', 'InserisciUtente', null,
            'Torna al menu utenti', 'ListaUtenti', null);

	END IF;

    EXCEPTION
      when EmailPresente then
       modGUI1.RedirectEsito('Errore', 
            'Email non valida', 
            'Riprova', 'InserisciUtente', null,
            'Torna al menu utenti', 'ListaUtenti', null);
    when TelefonoPresente then
       modGUI1.RedirectEsito('Errore', 
            'Recapito telefonico non valido', 
            'Riprova', 'InserisciUtente', null,
            'Torna al menu utenti', 'ListaUtenti', null);
END;

procedure EsitoPositivoUtenti
 is
	idSessione NUMBER(5) := modgui1.get_id_sessione();
    begin
        modGUI1.ApriPagina('EsitoPositivoUtenti',idSessione);
        if idSessione IS NULL then
            modGUI1.Header(0);
		else
				modGUI1.Header(idSessione);
		end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom w3-padding-large" style="max-width:450px"');
                modGUI1.ApriDiv('class="w3-center"');
                htp.print('<h1>Operazione eseguita correttamente </h1>');
                MODGUI1.collegamento('Torna al menu','ListaUtenti','w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
			HTP.BodyClose;
		HTP.HtmlClose;
end;

procedure EsitoNegativoUtenti
 is
	idSessione NUMBER(5) := modgui1.get_id_sessione();
    begin
        modGUI1.ApriPagina('EsitoPositivoUtenti',idSessione);
        if idSessione IS NULL then
            modGUI1.Header(0);
		else
				modGUI1.Header(idSessione);
		end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom w3-padding-large" style="max-width:450px"');
                modGUI1.ApriDiv('class="w3-center"');
                htp.print('<h1>Operazione NON eseguita</h1>');
                MODGUI1.collegamento('Torna al menu','ListaUtenti?','w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
			HTP.BodyClose;
		HTP.HtmlClose;
end;

PROCEDURE VisualizzaUtente (
	utenteID NUMBER
)
IS
	NomeUtente UTENTI.Nome%TYPE;
    CognomeUtente UTENTI.Cognome%TYPE;
    DataNascitaUtente UTENTI.DataNascita%TYPE;
	IndirizzoUtente UTENTI.Indirizzo%TYPE;
	EmailUtente UTENTI.Email%TYPE;
	RecapitoTelefonicoUtente UTENTI.RecapitoTelefonico%TYPE;
	UtenteDonatore UTENTIMUSEO.Donatore%TYPE;
	UtenteAssistenza UTENTICAMPIESTIVI.Richiestaassistenza%TYPE;
	temp NUMBER(10) := 0;
    temp2 NUMBER(10) := 0;
	temp3 NUMBER(10) := 0;
	NomeTutore UTENTI.Nome%TYPE;
    CognomeTutore UTENTI.Cognome%TYPE;
	idTutoreUtente UTENTI.idutente%TYPE;
	idSessione NUMBER(5) := modgui1.get_id_sessione();


BEGIN

	select NOME, COGNOME, DATANASCITA, INDIRIZZO, EMAIL, RECAPITOTELEFONICO
	into NomeUtente, CognomeUtente, DataNascitaUtente, IndirizzoUtente, EmailUtente, RecapitoTelefonicoUtente
	from UTENTI
	where IDUTENTE = utenteID;

	select count(*) into temp from UTENTIMUSEO
	where utenteID = UTENTIMUSEO.idutente;

	if temp > 0 then
		select Donatore into UtenteDonatore from UTENTIMUSEO
		where utenteID = UTENTIMUSEO.idutente;
	end if;

	select count(*) into temp2 from UTENTICAMPIESTIVI
	where utenteID = UTENTICAMPIESTIVI.idutente;

	if temp2 > 0 then
		select Richiestaassistenza into UtenteAssistenza from UTENTICAMPIESTIVI
		where utenteID = UTENTICAMPIESTIVI.idutente;
	end if;

	select count(*) into temp3 from TUTORI
	where IDTUTELATO = utenteID;

	
	if temp3 > 0 THEN
		select idtutore into idTutoreUtente from TUTORI
		where IDTUTELATO = utenteID;
		
		select nome, cognome into NomeTutore, CognomeTutore from UTENTI
		where idutente = idTutoreUtente;
		
	end if;
	
	
	IF SQL%FOUND
	THEN

		MODGUI1.ApriPagina('Profile utente', idSessione);
		HTP.BodyOpen;
		if idSessione IS NULL then
            modGUI1.Header(0);
		else
				modGUI1.Header(idSessione);
		end if;
		modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom w3-padding-large" style="max-width:600px; margin-top:110px"');
		HTP.header(2, 'Profilo utente');
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
		
		if temp3 > 0 then
			HTP.tablerowopen;
			HTP.tabledata('Tutore: '||NomeTutore|| ' '||CognomeTutore);
			HTP.tablerowclose;
		end if;
		
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
		if temp > 0 then
			HTP.TableRowOpen;
			HTP.TableData('Utente museo: ');
			HTP.TableData('&#10004');
			HTP.TableRowClose;
			if utenteDonatore > 0 then
				HTP.TableRowOpen;
				HTP.TableData('Donatore: ');
				HTP.TableData('&#10004');
				HTP.TableRowClose;
			end if;
		end if;
		if temp2 > 0 then
			HTP.TableRowOpen;
			HTP.TableData('Utente campi estivo: ');
			HTP.TableData('&#10004');
			HTP.TableRowClose;
			if UtenteAssistenza > 0 then
				HTP.TableRowOpen;
				HTP.TableData('Richiesta assistenza: ');
				HTP.TableData('&#10004');
				HTP.TableRowClose;
			end if;
		end if;
		HTP.tableClose;
		if hasRole(idSessione, 'DBA') or hasRole(idSessione, 'SU') then
		MODGUI1.Collegamento('Modifica', 'ModificaUtente?utenteID='||utenteID, 'w3-button w3-blue w3-margin');
			MODGUI1.Collegamento('Elimina',
				'EliminaUtente?utenteID='||utenteID,
				'w3-button w3-red w3-margin',
				'return confirm(''Sei sicuro di voler eliminare il profilo di '||NomeUtente||' '||CognomeUtente||'?'')'
			);
		end if;
		MODGUI1.collegamento('Torna al menu','ListaUtenti','w3-button w3-block w3-black w3-section w3-padding');
		MODGUI1.ChiudiDiv;
		HTP.BodyClose;
		HTP.HtmlClose;
	ELSE
		modGUI1.RedirectEsito('Errore', 
            'Impossibile visualizzare l''utente selezionato', 
            'Riprova', 'VisualizzaUtente?utenteID='||utenteID, null,
            'Torna al menu utenti', 'ListaUtenti', null);
	END IF;
END;

PROCEDURE ModificaUtente (
	utenteID NUMBER DEFAULT NULL
)
IS
	NomeUtente UTENTI.Nome%TYPE;
    CognomeUtente UTENTI.Cognome%TYPE;
    DataNascitaUtente UTENTI.DataNascita%TYPE;
	IndirizzoUtente UTENTI.Indirizzo%TYPE;
	EmailUtente UTENTI.Email%TYPE;
	RecapitoTelefonicoUtente UTENTI.RecapitoTelefonico%TYPE;
	UtenteDonatore UTENTIMUSEO.Donatore%TYPE;
	UtenteAssistenza UTENTICAMPIESTIVI.Richiestaassistenza%TYPE;
	temp NUMBER(10) := 0;
    temp2 NUMBER(10) := 0;
	temp3 NUMBER(10) := 0;
	NomeTutore UTENTI.Nome%TYPE;
    CognomeTutore UTENTI.Cognome%TYPE;
	idTutoreUtente UTENTI.idutente%TYPE;
	varidTutore UTENTI.idutente%TYPE;
	idSessione NUMBER(5) := modgui1.get_id_sessione();

BEGIN

	select NOME, COGNOME, DATANASCITA, INDIRIZZO, EMAIL, RECAPITOTELEFONICO
	into NomeUtente, CognomeUtente, DataNascitaUtente, IndirizzoUtente, EmailUtente, RecapitoTelefonicoUtente
	from UTENTI
	where IDUTENTE = utenteID;
	
	select count(*) into temp from UTENTIMUSEO
	where utenteID = UTENTIMUSEO.idutente;

	if temp > 0 then
		select Donatore into UtenteDonatore from UTENTIMUSEO
		where utenteID = UTENTIMUSEO.idutente;
	end if;

	select count(*) into temp2 from UTENTICAMPIESTIVI
	where utenteID = UTENTICAMPIESTIVI.idutente;

	if temp2 > 0 then
		select Richiestaassistenza into UtenteAssistenza from UTENTICAMPIESTIVI
		where utenteID = UTENTICAMPIESTIVI.idutente;
	end if;

	select count(*) into temp3 from TUTORI
	where IDTUTELATO = utenteID;

	
	if temp3 > 0 THEN
		select idtutore into idTutoreUtente from TUTORI
		where IDTUTELATO = utenteID;
	end if;
	

	IF SQL%FOUND
	THEN

		MODGUI1.ApriPagina('Profile utente', idSessione);
		HTP.BodyOpen;
		if idSessione IS NULL then
            modGUI1.Header(0);
		else
				modGUI1.Header(idSessione);
		end if;
		modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom w3-padding-large" style="max-width:600px; margin-top:110px"');
		HTP.header(2, 'Modifica utente');
		MODGUI1.ApriForm('ModificaDatiUtente');
		HTP.FORMHIDDEN('utenteID',utenteID);
		MODGUI1.Label('Nome*');
		MODGUI1.InputText('nomeNew', 'Nome utente', 1, NomeUtente);
		HTP.BR;
		MODGUI1.Label('Cognome*');
		MODGUI1.InputText('cognomeNew', 'Cognome utente', 1, CognomeUtente);
		HTP.BR;
		MODGUI1.Label('Data nascita*');
		MODGUI1.InputDate('dataNascita', 'dataNascitaNew', 1, DataNascitaUtente);
		HTP.BR;
		modgui1.label('Tutore*');
		modgui1.selectopen('utenteTutoreNew', 'idutentetutore');
		MODGUI1.SelectOption(0, 'Tutore non necessario', 0);
		for utente in (select idutente from utenti)
		loop
			select idutente, nome, cognome
			into varidTutore, NomeTutore, CognomeTutore
			from utenti
			where idutente=utente.idutente;
			if idTutoreUtente = varidTutore then 
				MODGUI1.SelectOption(varidTutore, ''|| NomeTutore ||' '||CognomeTutore||'', 1);
			else
				MODGUI1.SelectOption(varidTutore, ''|| NomeTutore ||' '||CognomeTutore||'', 0);
			end if;
		end loop;
		modgui1.selectclose();
		HTP.BR;
		MODGUI1.Label('Indirizzo*');
		MODGUI1.InputText('indirizzoNew', 'Indirizzo', 1, IndirizzoUtente);
		HTP.BR;
		MODGUI1.Label('Email*');
		MODGUI1.InputText('utenteEmailNEW', 'Email', 1, EmailUtente);
		HTP.BR;
		MODGUI1.Label('Telefono');
		MODGUI1.InputText('telefonoNew', 'Telefono', 0, RecapitoTelefonicoUtente);
		HTP.BR;
		if temp > 0 then
		MODGUI1.InputCheckboxOnClick('Utente museo', 'utenteMuseoNew','check()','utentemuseo', 1);
		MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%; display: block" id="first"');
		else
			MODGUI1.InputCheckboxOnClick('Utente museo', 'utenteMuseoNew','check()','utentemuseo');
			MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%; display: none" id="first"');
		end if;
		HTP.BR;
		if utenteDonatore = 1 then
			MODGUI1.InputCheckbox('Donatore', 'utenteDonatoreNew', 1);
		else
			MODGUI1.InputCheckbox('Donatore', 'utenteDonatoreNew');
		end if;
		HTP.BR;
		MODGUI1.ChiudiDiv;
		HTP.BR;
		if temp2 > 0 then
			MODGUI1.InputCheckboxOnClick('Utente campi estivi', 'utenteCampiEstiviNew', 'check2()', 'utentecampiestivi', 1);
			MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%; display: block" id="second"');
		else
			MODGUI1.InputCheckboxOnClick('Utente campi estivi', 'utenteCampiEstiviNew', 'check2()', 'utentecampiestivi');
			MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%; display: none" id="second"');
		end if;
		HTP.BR;
		if utenteAssistenza = 1 then
			MODGUI1.InputCheckbox('Richiede assistenza', 'utenteAssistenzaNew', 1);
		else
			MODGUI1.InputCheckbox('Richiede assistenza', 'utenteAssistenzaNew');
		end if;
		HTP.BR;
		MODGUI1.ChiudiDiv;

		MODGUI1.InputSubmit('Salva');
		MODGUI1.ChiudiForm;
		MODGUI1.Collegamento(
            'Annulla',
			'VisualizzaUtente?utenteID='||utenteID,
			'w3-button w3-block w3-black w3-section w3-padding'
        );
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
	ELSE
		modGUI1.RedirectEsito('Errore', 
            'Impossibile visualizzare l''utente selezionato', 
            'Riprova', 'ModificaUtente?utenteID='||utenteID, null,
            'Torna al menu utenti', 'ListaUtenti', null);
	END IF;
END;

PROCEDURE ModificaDatiUtente (
	utenteID NUMBER,
	nomeNew VARCHAR2 DEFAULT NULL,
	cognomeNew VARCHAR2 DEFAULT NULL,
	dataNascitaNew VARCHAR2 DEFAULT NULL,
	indirizzoNew VARCHAR2 DEFAULT NULL,
	utenteEmailNew VARCHAR2 DEFAULT NULL,
    telefonoNew VARCHAR2 DEFAULT NULL,
	utenteMuseoNew VARCHAR2 DEFAULT NULL,
	utenteDonatoreNew VARCHAR2 DEFAULT NULL,
	utenteCampiEstiviNew VARCHAR2 DEFAULT NULL,
	utenteAssistenzaNew VARCHAR2 DEFAULT NULL,
	utenteTutoreNew NUMBER DEFAULT 0
) IS
    birth DATE := TO_DATE(dataNascitaNew default NULL on conversion error, 'YYYY-MM-DD');
    EmailPresente EXCEPTION;
    TelefonoPresente EXCEPTION;
    temp NUMBER(10) := 0;
    temp2 NUMBER(10) := 0;
	temp3 NUMBER(10) := 0;
    temp4 NUMBER(10) := 0;
	temp5 NUMBER(10) := 0;
	EmailUtente UTENTI.Email%TYPE;
	RecapitoTelefonicoUtente UTENTI.RecapitoTelefonico%TYPE;
	idSessione NUMBER(5) := modgui1.get_id_sessione();

BEGIN

	select email into EmailUtente from UTENTI where utenteID = UTENTI.IDutente;

	if EmailUtente != utenteEmailNew then
		SELECT count(*) INTO temp FROM UTENTI WHERE UTENTI.Email = utenteEmailNew;
		IF temp > 0 THEN
			RAISE EmailPresente;
		END IF;
	end if;

	select RecapitoTelefonico into RecapitoTelefonicoUtente from UTENTI where utenteID = UTENTI.IDutente;

	if RecapitoTelefonicoUtente != telefonoNew then
		select count(*) INTO temp2 from UTENTI where RecapitoTelefonico = telefonoNew;
		IF temp2 > 0 THEN
			RAISE TelefonoPresente;
		END IF;
	end if;

	UPDATE UTENTI SET
		nome=nomeNew,
		cognome=cognomeNew,
		dataNascita=birth,
		indirizzo=indirizzoNew,
		email=utenteEmailNew,
		recapitotelefonico=telefonoNew
	WHERE IDutente=utenteID;


	select count(*) into temp3 from UTENTIMUSEO where UTENTIMUSEO.IdUtente = utenteID;

	if temp3 > 0 then
		if utenteMuseoNew = 'on' then
			if utenteDonatoreNew = 'on' then
				update UTENTIMUSEO set
					donatore=1
				where idutente=utenteID;
			else
				update UTENTIMUSEO set
					donatore=0
				where idutente=utenteID;
			end if;
		else
			delete from UTENTIMUSEO where idutente=utenteID;
		end if;
	else
		if utenteDonatoreNew = 'on' then
			insert into UTENTIMUSEO
			values (utenteID, 1);
		else
			insert into UTENTIMUSEO
			values (utenteID, 0);
		end if;
	end if;

	select count(*) into temp4 from UTENTICAMPIESTIVI where UTENTICAMPIESTIVI.IdUtente = utenteID;

	if temp4 > 0 then
		if utenteCampiEstiviNew = 'on' then
			if utenteCampiEstiviNew = 'on' then
				update UTENTICAMPIESTIVI set
					Richiestaassistenza=1
				where idutente=utenteID;
			else
				update UTENTICAMPIESTIVI set
					Richiestaassistenza=0
				where idutente=utenteID;
			end if;
		else
			delete from UTENTICAMPIESTIVI where idutente=utenteID;
		end if;
	else
		if utenteCampiEstiviNew = 'on' then
			insert into UTENTICAMPIESTIVI
			values (utenteID, 1);
		else
			insert into UTENTICAMPIESTIVI
			values (utenteID, 0);
		end if;
	end if;

	select count(*) into temp5 from TUTORI where IDTUTELATO = utenteID;

	if temp5 > 0 THEN
		if utenteTutoreNew = 0 then
			delete from TUTORI where IDTUTELATO = utenteID;
		else
			update tutori set
				IDTUTORE = utenteTutoreNew
			where IDTUTELATO = utenteID;
		end if;
	else
		if utenteTutoreNew != 0 THEN
			insert into TUTORI
			values (utenteTutoreNew, utenteID);
		end if;
	end if;
	 
	IF SQL%FOUND THEN
		commit;
		modGUI1.RedirectEsito('Successo', 
            'L''utente '||nomeNew||' '||cognomeNew||' è stato modificato correttamente', 
            'Visualizza utente', 'VisualizzaUtente?utenteID='||utenteID, null,
            'Torna al menu utenti', 'ListaUtenti', null);
	ELSE
		modGUI1.RedirectEsito('Errore', 
            'L''utente non è stato modificato', 
            'Riprova', 'ModificaUtente?utenteID='||utenteID, null,
            'Torna al menu utenti', 'ListaUtenti', null);
	END IF;


END;

PROCEDURE EliminaUtente(
	utenteID NUMBER
)
IS
BEGIN

	delete from UTENTIMUSEO where IDUTENTE=utenteID;
	delete from UTENTICAMPIESTIVI where IDUTENTE=utenteID;
	update UTENTI 
	set ELIMINATO = 1
	where IDUTENTE=utenteID;

	IF SQL%FOUND THEN
		commit;
		EsitoPositivoUtenti;
	ELSE
		EsitoNegativoUtenti;
	END IF;

END;

PROCEDURE ListaUtenti
is
idSessione NUMBER(5) := modgui1.get_id_sessione();
begin
        modGUI1.ApriPagina('Lista utenti',idSessione);
        if idSessione IS NULL then
            modGUI1.Header(0);
		else
				modGUI1.Header(idSessione);
		end if;
		modGUI1.ApriDiv('class="w3-center" style="margin-top:110px;"');
        htp.prn('<h1>Lista utenti</h1>');
		if hasRole(idSessione, 'DBA') or hasRole(idSessione, 'SU')
        then
            modGUI1.Collegamento('Inserisci','InserisciUtente','w3-btn w3-round-xxlarge w3-black');
            htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
        end if;
            modGUI1.Collegamento('Statistiche','StatisticheUtenti','w3-btn w3-round-xxlarge w3-black');
        modGUI1.ChiudiDiv;
        htp.br;
        modGUI1.ApriDiv('class="w3-row w3-container"');
   		for utente in (select * from utenti order by cognome, nome)  loop
                modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                    modGUI1.ApriDiv('class="w3-card-4" style="height:200px;"');
						modGUI1.ApriDiv('class="w3-container w3-center"');
							htp.prn('<p>'|| utente.nome || ' ' || utente.cognome ||'</p>');
							htp.br;
						modGUI1.ChiudiDiv;
						modGUI1.Collegamento('Visualizza',
                            'VisualizzaUtente?utenteID='||utente.Idutente,
                            'w3-margin w3-green w3-button');
                        if hasRole(idSessione, 'DBA') or hasRole(idSessione, 'SU') then
						modGUI1.Collegamento('Modifica',
                            'ModificaUtente?utenteID='||utente.Idutente,
                            'w3-margin w3-blue w3-button');
                        modGUI1.Collegamento('Elimina',
                            'EliminaUtente?utenteID='||utente.Idutente,
                            'w3-red w3-margin w3-button',
							'return confirm(''Sei sicuro di voler eliminare il profilo di '||utente.nome||' '||utente.cognome||'?'')'
							);
                    	end if;
                	modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
        END LOOP;
        modGUI1.chiudiDiv;
end;

procedure etaMediaUtenti
is
	tempMedia NUMBER := 0;
	res INTEGER := 0;
	idSessione NUMBER(5) := modgui1.get_id_sessione();
	BEGIN
		select AVG(to_number((EXTRACT(YEAR FROM dataNascita)))) into tempMedia from utenti;
		res := to_number((EXTRACT(YEAR FROM SYSDATE()))) - tempMedia;

		modGUI1.ApriPagina('EsitoPositivoUtenti',idSessione);
         if idSessione IS NULL then
            modGUI1.Header(0);
		else
				modGUI1.Header(idSessione);
		end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom w3-padding-large" style="max-width:450px"');
                modGUI1.ApriDiv('class="w3-center"');
                htp.print('<h1>Operazione eseguita correttamente </h1>');
				htp.print('<h3>Il risultato è '||res||'</h3>');
                MODGUI1.collegamento('Torna alle statistiche','StatisticheUtenti','w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
			HTP.BodyClose;
		HTP.HtmlClose;

END;

procedure sommaTitoli(
	dataInizioFun VARCHAR2 DEFAULT NULL,
	dataFineFun VARCHAR2 DEFAULT NULL,
	utenteID NUMBER DEFAULT 0
)
is
	dataInizio DATE := TO_DATE(dataInizioFun default NULL on conversion error, 'YYYY-MM-DD');
	dataFine DATE := TO_DATE(dataFineFun default NULL on conversion error, 'YYYY-MM-DD');
	tempMedia NUMBER := 0;
	res NUMBER := 0;
	idSessione NUMBER(5) := modgui1.get_id_sessione();
	BEGIN
		if utenteID = 0 then
			select COUNT(*)
			into res
			from titoliingresso
			where Emissione > dataInizio and Emissione < dataFine;
		else
			select COUNT(*)
			into res
			from titoliingresso
			where Emissione > dataInizio and Emissione < dataFine and titoliingresso.ACQUIRENTE = utenteID;
		end if;

		modGUI1.ApriPagina('Statistiche utenti',idSessione);
         if idSessione IS NULL then
            modGUI1.Header(0);
		else
				modGUI1.Header(idSessione);
		end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom w3-padding-large" style="max-width:450px"');
                modGUI1.ApriDiv('class="w3-center"');
                htp.print('<h1>Operazione eseguita correttamente </h1>');
				if res > 0 then
					htp.print('<h3>Il risultato è '||res||'</h3>');
				else
					htp.print('<h3>Il risultato è 0</h3>');
				end if;
                MODGUI1.collegamento('Torna alle statistiche','StatisticheUtenti','w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
			HTP.BodyClose;
		HTP.HtmlClose;
END;

procedure mediaCostoTitoli(
	dataInizioFun VARCHAR2 DEFAULT NULL,
	dataFineFun VARCHAR2 DEFAULT NULL,
	utenteID NUMBER DEFAULT 0
)
is
	dataInizio DATE := TO_DATE(dataInizioFun default NULL on conversion error, 'YYYY-MM-DD');
	dataFine DATE := TO_DATE(dataFineFun default NULL on conversion error, 'YYYY-MM-DD');
	tempMedia NUMBER := 0;
	res NUMBER(6) := 0;
	idSessione NUMBER(5) := modgui1.get_id_sessione();
	BEGIN
		if utenteID = 0 then
			select AVG(COSTOTOTALE)
			into res
			from tipologieingresso
			join titoliingresso on idtipologiaing = tipologia
			where Emissione > dataInizio and Emissione < dataFine;
		else
			select AVG(COSTOTOTALE)
			into res
			from tipologieingresso
			join titoliingresso on idtipologiaing = tipologia
			where Emissione > dataInizio and Emissione < dataFine and titoliingresso.ACQUIRENTE = utenteID;
		end if;

		modGUI1.ApriPagina('Statistiche utenti',idSessione);
         if idSessione IS NULL then
            modGUI1.Header(0);
		else
				modGUI1.Header(idSessione);
		end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom w3-padding-large" style="max-width:450px"');
                modGUI1.ApriDiv('class="w3-center"');
                htp.print('<h1>Operazione eseguita correttamente </h1>');
				if res > 0 then
					htp.print('<h3>Il risultato è '||res||'</h3>');
				else
					htp.print('<h3>Il risultato è 0</h3>');
				end if;
                MODGUI1.collegamento('Torna alle statistiche','StatisticheUtenti','w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
			HTP.BodyClose;
		HTP.HtmlClose;
END;

procedure NumeroVisiteMusei(
	dataInizioFun VARCHAR2 DEFAULT NULL,
	dataFineFun VARCHAR2 DEFAULT NULL,
	utenteID NUMBER DEFAULT 0
)
is
	dataInizio DATE := TO_DATE(dataInizioFun default NULL on conversion error, 'YYYY-MM-DD');
	dataFine DATE := TO_DATE(dataFineFun default NULL on conversion error, 'YYYY-MM-DD');
	tempMedia NUMBER := 0;
	res NUMBER(6) := 0;
	idSessione NUMBER(5) := modgui1.get_id_sessione();
	BEGIN
		if utenteID = 0 then
			select COUNT(*)
			into res
			from visite
			where datavisita > dataInizio and datavisita < dataFine;
		else
			select COUNT(*)
			into res
			from visite
			where datavisita > dataInizio and datavisita < dataFine and visite.visitatore = utenteID;
		end if;

		modGUI1.ApriPagina('Statistiche utenti',idSessione);
        if idSessione IS NULL then
            modGUI1.Header(0);
		else
				modGUI1.Header(idSessione);
		end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom w3-padding-large" style="max-width:450px"');
                modGUI1.ApriDiv('class="w3-center"');
                htp.print('<h1>Operazione eseguita correttamente </h1>');
				if res > 0 then
					htp.print('<h3>Il risultato è '||res||'</h3>');
				else
					htp.print('<h3>Il risultato è 0</h3>');
				end if;
                MODGUI1.collegamento('Torna alle statistiche','StatisticheUtenti','w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
			HTP.BodyClose;
		HTP.HtmlClose;
END;

procedure NumeroMedioTitoli(
	dataInizioFun VARCHAR2 DEFAULT NULL,
	dataFineFun VARCHAR2 DEFAULT NULL
)
is
	dataInizio DATE := TO_DATE(dataInizioFun default NULL on conversion error, 'YYYY-MM-DD');
	dataFine DATE := TO_DATE(dataFineFun default NULL on conversion error, 'YYYY-MM-DD');
	tempMedia NUMBER := 0;
	res NUMBER(6) := 0;
	res2 NUMBER(6) := 0;
	idSessione NUMBER(5) := modgui1.get_id_sessione();
	BEGIN

		select COUNT(*)
		into res
		from utenti;

		select COUNT(*)
		into res2
		from titoliingresso
		where emissione > dataInizio and emissione < dataFine;


		modGUI1.ApriPagina('Statistiche utenti',idSessione);
        if idSessione IS NULL then
            modGUI1.Header(0);
		else
				modGUI1.Header(idSessione);
		end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom w3-padding-large" style="max-width:450px"');
                modGUI1.ApriDiv('class="w3-center"');
                htp.print('<h1>Operazione eseguita correttamente </h1>');
				if res > 0 then
					htp.print('<h3>Il risultato è '||res2/res||'</h3>');
				else
					htp.print('<h3>Il risultato è 0</h3>');
				end if;
                MODGUI1.collegamento('Torna alle statistiche','StatisticheUtenti','w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
			HTP.BodyClose;
		HTP.HtmlClose;
END;


procedure StatisticheUtenti
is
	nomeutente utenti.nome%TYPE;
	cognomeutente utenti.cognome%TYPE;
	varidutente utenti.Idutente%TYPE;
	varidmuseo musei.idmuseo%TYPE;
	nomemuseo musei.nome%TYPE;
	idSessione NUMBER(5) := modgui1.get_id_sessione();
begin
		MODGUI1.ApriPagina('Statistiche utente', idSessione);
			HTP.BodyOpen;
			if idSessione IS NULL then
            modGUI1.Header(0);
		else
				modGUI1.Header(idSessione);
		end if;
			modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="margin-top:110px"');
			modgui1.apriTabella('w3-table w3-striped w3-centered');
				modgui1.apriRigaTabella;
				modgui1.intestazioneTabella('Dati');
				modgui1.intestazioneTabella('Operazione');
				modgui1.intestazioneTabella('Risultato');
				modgui1.chiudiRigaTabella;

				modgui1.apriRigaTabella;
					MODGUI1.ApriForm('etaMediaUtenti');
					modgui1.apriElementoTabella;
						modgui1.apridiv('class="w3-padding-24"');
						modgui1.elementoTabella('Tutti gli utenti');
						modgui1.chiudiDiv;
					modgui1.chiudiElementoTabella;
					modgui1.apriElementoTabella;
						modgui1.apridiv('class="w3-padding-24"');
						modgui1.elementoTabella('Media delle date di nascita');
						modgui1.chiudiDiv;
					modgui1.chiudiElementoTabella;
					modgui1.apriElementoTabella;
						MODGUI1.InputSubmit('Calcola');
					modgui1.chiudiElementoTabella;
					MODGUI1.ChiudiForm;
				modgui1.chiudiRigaTabella;

				modgui1.apriRigaTabella;
					MODGUI1.ApriForm('sommaTitoli');
					modgui1.apriElementoTabella;
							modgui1.label('Utente');
							modgui1.selectopen('utenteID', 'idutenteSommaTitoli');
							MODGUI1.SelectOption(0, 'Tutti gli utenti', 0);
							for utente in (select idutente from utentimuseo)
							loop
								select idutente, nome, cognome
								into varidutente, nomeutente, cognomeutente
								from utenti
								where idutente=utente.idutente and ELIMINATO = 0;
								MODGUI1.SelectOption(varidutente, ''|| nomeutente ||' '||cognomeutente||'', 0);
							end loop;
							htp.br;
							modgui1.label('Musei');
							modgui1.selectopen('museiID', 'idmuseiSommaTitoli');
							MODGUI1.SelectOption(0, 'Tutti i musei', 0);
							for museo in (select idmuseo from musei)
							loop
								select idmuseo, nome
								into varidmuseo, nomemuseo
								from musei	
								where idmuseo=museo.idmuseo;
								MODGUI1.SelectOption(varidmuseo, ''|| nomemuseo ||'', 0);
							end loop;

							modgui1.selectclose();
							htp.br;
							MODGUI1.Label('Data inizio');
							MODGUI1.InputDate('dataInizioFun', 'dataInizioFun', 1);
							htp.br;
							MODGUI1.Label('Data fine');
							MODGUI1.InputDate('dataFineFun', 'dataFineFun', 1);
					modgui1.chiudiElementoTabella;
					modgui1.apriElementoTabella;
						modgui1.apridiv('class="w3-padding-24"');
						modgui1.elementoTabella('Numero Titoli d’Ingresso acquistati');
						modgui1.chiudiDiv;
					modgui1.chiudiElementoTabella;
					modgui1.apriElementoTabella;
						MODGUI1.InputSubmit('Calcola');
					modgui1.chiudiElementoTabella;
					MODGUI1.ChiudiForm;
				modgui1.chiudiRigaTabella;

				modgui1.apriRigaTabella;
					MODGUI1.ApriForm('mediaCostoTitoli');
					modgui1.apriElementoTabella;
						modgui1.label('Utente');
							modgui1.selectopen('utenteID', 'idutenteSommaTitoli');
							MODGUI1.SelectOption(0, 'Tutti gli utenti', 0);
							for utente in (select idutente from utentimuseo)
							loop
								select idutente, nome, cognome
								into varidutente, nomeutente, cognomeutente
								from utenti
								where idutente=utente.idutente;
								MODGUI1.SelectOption(varidutente, ''|| nomeutente ||' '||cognomeutente||'', 0);
							end loop;
							modgui1.selectclose();
							htp.br;
							MODGUI1.Label('Data inizio');
							MODGUI1.InputDate('dataInizioFun', 'dataInizioFun', 1);
							htp.br;
							MODGUI1.Label('Data fine');
							MODGUI1.InputDate('dataFineFun', 'dataFineFun', 1);
					modgui1.chiudiElementoTabella;
					modgui1.apriElementoTabella;
						modgui1.apridiv('class="w3-padding-24"');
						modgui1.elementoTabella('Costo medio Titoli d’Ingresso acquistati');
						modgui1.chiudiDiv;
					modgui1.chiudiElementoTabella;
					modgui1.apriElementoTabella;
						MODGUI1.InputSubmit('Calcola');
					modgui1.chiudiElementoTabella;
					MODGUI1.ChiudiForm;
				modgui1.chiudiRigaTabella;

				modgui1.apriRigaTabella;
					MODGUI1.ApriForm('NumeroVisiteMusei');
					modgui1.apriElementoTabella;
						modgui1.label('Utente');
							modgui1.selectopen('utenteID', 'idutenteSommaTitoli');
							MODGUI1.SelectOption(0, 'Tutti gli utenti', 0);
							for utente in (select idutente from utentimuseo)
							loop
								select idutente, nome, cognome
								into varidutente, nomeutente, cognomeutente
								from utenti
								where idutente=utente.idutente;
								MODGUI1.SelectOption(varidutente, ''|| nomeutente ||' '||cognomeutente||'', 0);
							end loop;
							modgui1.selectclose();
							htp.br;
							MODGUI1.Label('Data inizio');
							MODGUI1.InputDate('dataInizioFun', 'dataInizioFun', 1);
							htp.br;
							MODGUI1.Label('Data fine');
							MODGUI1.InputDate('dataFineFun', 'dataFineFun', 1);
					modgui1.chiudiElementoTabella;
					modgui1.apriElementoTabella;
						modgui1.apridiv('class="w3-padding-24"');
						modgui1.elementoTabella('Numero visite musei');
						modgui1.chiudiDiv;
					modgui1.chiudiElementoTabella;
					modgui1.apriElementoTabella;
						MODGUI1.InputSubmit('Calcola');
					modgui1.chiudiElementoTabella;
					MODGUI1.ChiudiForm;
				modgui1.chiudiRigaTabella;

				modgui1.apriRigaTabella;
					MODGUI1.ApriForm('NumeroMedioTitoli');
					modgui1.apriElementoTabella;
						modgui1.apridiv('class="w3-padding-24"');
						modgui1.elementoTabella('Tutti gli utenti');
						modgui1.chiudiDiv;
						htp.br;
						MODGUI1.Label('Data inizio');
						MODGUI1.InputDate('dataInizioFun', 'dataInizioFun', 1);
						htp.br;
						MODGUI1.Label('Data fine');
						MODGUI1.InputDate('dataFineFun', 'dataFineFun', 1);
					modgui1.chiudiElementoTabella;
					modgui1.apriElementoTabella;
						modgui1.apridiv('class="w3-padding-24"');
						modgui1.elementoTabella('Numero medio visite musei');
						modgui1.chiudiDiv;
					modgui1.chiudiElementoTabella;
					modgui1.apriElementoTabella;
						MODGUI1.InputSubmit('Calcola');
					modgui1.chiudiElementoTabella;
					MODGUI1.ChiudiForm;
				modgui1.chiudiRigaTabella;



			modgui1.chiudiTabella;

			MODGUI1.collegamento('Torna al menu','ListaUtenti?','w3-button w3-block w3-black w3-section w3-padding');
		HTP.BodyClose;
		HTP.HtmlClose;
end;

-------------------------------------------------------------TODO DA TESTARE
/*
PROCEDURE inserisciNewsLetter (
    idSessione NUMBER DEFAULT 0
) IS
BEGIN
	MODGUI1.ApriPagina('Inserimento newsletter', 0);

	HTP.BodyOpen;
	MODGUI1.Header(); --da capire come combinarlo con il resto
	HTP.header(1,'Inserisci una nuova newsletter', 'center');
	MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%;"');

	MODGUI1.ApriForm('inserisci_newsletter');
	HTP.FORMHIDDEN('idSessione',0);

	MODGUI1.Label('Nome*');
	MODGUI1.InputText('nome', 'Nome newsletter', 1);
	HTP.BR;
	MODGUI1.ChiudiDiv;

	MODGUI1.InputSubmit('Inserisci');
	MODGUI1.ChiudiForm;

	MODGUI1.ChiudiDiv;

END;

PROCEDURE inserisci_newsletter (
    idSessione NUMBER DEFAULT 0
	nome varchar2(25) not null
) IS
BEGIN
	MODGUI1.ApriPagina('Inserimento utenti', 0);

	insert into NEWSLETTER
    values (IdNewsSeq.NEXTVAL, nome);

	HTP.BodyOpen;
	MODGUI1.Header(); --da capire come combinarlo con il resto
	HTP.header(1,'Newsletter inserita', 'center');
	MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%;"');

	MODGUI1.ApriForm('inseriscinewsletter');
	HTP.FORMHIDDEN('idSessione',0);

	MODGUI1.Label('Nome');
	MODGUI1.label(nome);
	MODGUI1.ChiudiDiv;

	MODGUI1.InputSubmit('Continuare?');
	MODGUI1.ChiudiForm;

	MODGUI1.ChiudiDiv;

END;




-------------------------------------------------------------FINE TODO */


PROCEDURE statisticheNewsLetter (
	newsletterID NUMBER DEFAULT -1
) IS
	id_sessione NUMBER(10) := NULL;
	temp NUMBER(10) := 0;
	nomeNew VARCHAR2(100) := '';
	numeroVisitatori NUMBER(10) := 0;
	etaMediaIscritti NUMBER(10) := 0;


	--utente
	U_NOME UTENTI.NOME%TYPE :='';
	U_COGNOME UTENTI.COGNOME%TYPE :='';
	U_NASCITA UTENTI.DATANASCITA%TYPE :='';
	U_EMAIL UTENTI.EMAIL%TYPE :='';
	U_INDIRIZZO UTENTI.INDIRIZZO%TYPE :='';
	U_RECAPITO UTENTI.RECAPITOTELEFONICO%TYPE :='';

    newsletterInesistente EXCEPTION;
	idSessioneExecption EXCEPTION;
BEGIN

	id_sessione := modgui1.get_id_sessione;
	if id_sessione = 0
	THEN
		RAISE idSessioneExecption;
	end if;

	if newsletterID = -1
	THEN
		RAISE newsletterInesistente;
	end if;

	SELECT count(*) into temp FROM NEWSLETTER where NEWSLETTER.IDNEWS = newsletterID;

	if temp = 0
	THEN
		RAISE newsletterInesistente;
	end if;

	SELECT NOME into nomeNew FROM NEWSLETTER WHERE NEWSLETTER.IDNEWS = newsletterID;
	SELECT count(*) into numeroVisitatori from UTENTI where IdUtente IN (select VISITATORE from VISITE) AND IDUTENTE IN (SELECT IDUTENTE FROM NEWSLETTERUTENTI WHERE IDNEWS = newsletterID);

	SELECT avg(age) into etaMediaIscritti FROM (SELECT MONTHS_BETWEEN(sysdate, UTENTI.DATANASCITA) / 12 age FROM UTENTI WHERE UTENTI.IDUTENTE IN (SELECT NEWSLETTERUTENTI.IDUTENTE FROM NEWSLETTERUTENTI WHERE NEWSLETTERUTENTI.IDNEWS = newsletterID));


	MODGUI1.ApriPagina('Statistiche');
	modgui1.header();
	modgui1.apridiv('style="margin-top: 110px;text-align:center;"');
	htp.prn(CONCAT('<h1> statistiche per newsletter </h1>', nomeNew));
	htp.br();
	modgui1.Label('Numero visitatori: ');
	modgui1.Label(TO_CHAR(numeroVisitatori));
	htp.br();
	modgui1.Label('Età media iscritti: ');
	modgui1.Label(TO_CHAR(etaMediaIscritti));
	htp.br();

	--hdaidhiaodh
	modgui1.Label('Titoli di ingresso degli iscritti alla newsletter:');
	--per ogni utente che è iscitto alla newsletter
	--mostrare TUTTI i titoli di ingresso che ha acquistato

	SELECT MAX(numb) INTO temp FROM (SELECT count(*) numb FROM TITOLIINGRESSO GROUP BY TITOLIINGRESSO.ACQUIRENTE);

	htp.prn('<table style="width:100%" border="2">');
	htp.prn('<tr>');
		htp.prn('<th> utente </th>');
		for k in 0..temp
		LOOP
			htp.prn(CONCAT(CONCAT('<th> acquisto ', k + 1), '</th>'));
		END LOOP;
	htp.prn('</tr>');
	for id_utente in (	SELECT NEWSLETTERUTENTI.IDUTENTE
						FROM NEWSLETTERUTENTI
						WHERE NEWSLETTERUTENTI.IDNEWS = newsletterID
								AND NEWSLETTERUTENTI.IDUTENTE IN (	SELECT TITOLIINGRESSO.ACQUIRENTE
																	FROM TITOLIINGRESSO))
	LOOP
		--id_utente.IDUTENTE tiene id dell'utente
		htp.prn('<tr>');
		htp.prn('<td>');
		--primo printare i dati dell'utente.
		SELECT UTENTI.NOME, UTENTI.COGNOME, UTENTI.DATANASCITA, UTENTI.INDIRIZZO, UTENTI.EMAIL, UTENTI.RECAPITOTELEFONICO
			INTO U_NOME, U_COGNOME, U_NASCITA, U_INDIRIZZO, U_EMAIL, U_RECAPITO
			FROM UTENTI
			WHERE UTENTI.IDUTENTE = id_utente.IDUTENTE;

		htp.prn(TO_CHAR(U_NOME));
		htp.prn(TO_CHAR(U_COGNOME));
		htp.br;
		htp.prn(TO_CHAR(U_NASCITA, 'YYYY-MM-DD'));
		htp.br;
		htp.prn(TO_CHAR(U_INDIRIZZO));
		htp.br;
		htp.prn(TO_CHAR(U_EMAIL));
		htp.br;
		htp.prn(TO_CHAR(U_RECAPITO));
		htp.prn('</td>');

		FOR titolo IN (
			SELECT *
			FROM TITOLIINGRESSO
			WHERE TITOLIINGRESSO.ACQUIRENTE = id_utente.IDUTENTE
		)
		LOOP
		htp.prn('<td>');
		htp.prn(CONCAT('ID: ', TO_CHAR(titolo.IDTITOLOING)));
		htp.br;
		htp.prn(CONCAT('EMISSIONE: ', TO_CHAR(titolo.EMISSIONE, 'YYYY-MM-DD HH24:MI')));
		htp.br;
		htp.prn(CONCAT('SCADENZA: ', TO_CHAR(titolo.SCADENZA, 'YYYY-MM-DD')));
		htp.br;
		htp.prn(CONCAT('TIPOLOGIA: ', TO_CHAR(titolo.TIPOLOGIA)));
		htp.br;

		htp.prn('</td>');
		END LOOP;

		htp.prn('</tr>');

	END LOOP;
	htp.prn('</table>');
	----dshaheoh
	MODGUI1.chiudiDiv;
	htp.bodyclose;
	htp.htmlclose;
	
	EXCEPTION
	when newsletterInesistente THEN
		MODGUI1.ApriPagina('Errore', id_sessione);
		MODGUI1.Header();
		HTP.BodyOpen;

		MODGUI1.ApriDiv;
		MODGUI1.LABEL('newsletter inesistente');
		MODGUI1.collegamento('visualizza newsletter', 'visualizzaNewsletter');
		MODGUI1.ChiudiDiv;

		HTP.BodyClose;
		HTP.HtmlClose;
	WHEN idSessioneExecption THEN
		MODGUI1.ApriPagina('Errore', id_sessione);
		MODGUI1.Header();
		HTP.BodyOpen;

		MODGUI1.ApriDiv;
		MODGUI1.LABEL('idSessione non settato o corretto');
		MODGUI1.collegamento('visualizza newsletter', 'visualizzaNewsletter');
		MODGUI1.ChiudiDiv;

		HTP.BodyClose;
		HTP.HtmlClose;
	
END;
END GRUPPO1;

