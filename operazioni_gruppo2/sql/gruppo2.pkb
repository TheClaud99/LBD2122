CREATE OR REPLACE PACKAGE BODY gruppo2 AS

/*
 * OPERAZIONI SULLE OPERE
 * - Inserimento ❌
 * - Modifica ❌
 * - Visualizzazione ❌
 * - Cancellazione (rimozione) ❌
 * - Spostamento ❌
 * - Aggiunta Autore ❌
 * OPERAZIONI STATISTICHE E MONITORAGGIO
 * - Storico prestiti dell’Opera ❌
 * - Storico spostamenti relativi ad un Museo ❌
 * - Opera non spostata da più tempo ❌
 * - Autori dell’Opera ❌
 * - Tipo Sala in cui si trova l’Opera ❌
 * - Descrizioni dell’Opera ❌
 * - Lista Opere ordinate per numero di Autori in ordine decrescente ❌
 */

/*
 * OPERAZIONI SUGLI AUTORI
 * - Inserimento ✅
 * - Modifica ❌
 * - Visualizzazione ❌
 * - Cancellazione (rimozione) ❌
 * OPERAZIONI STATISTICHE E MONITORAGGIO
 * - Opere realizzate dall’Autore ❌
 * - Musei con Opere dell’Autore esposte ❌
 * - Collaborazioni effettuate ❌
 * - Opere dell’Autore presenti in un Museo scelto ❌
 * - Autori in vita le cui Opere sono esposte in un Museo scelto ❌
 */

-- Procedura per l'inserimento di nuovi Autori nella base di dati
PROCEDURE InserisciAutore(
	sessionID NUMBER DEFAULT NULL
) IS
BEGIN
	-- sessionID sono hard-coded fino ad uno standard
	MODGUI1.ApriPagina('Inserimento autore', 0);
	
	HTP.BodyOpen;
	HTP.header(1,'Inserisci un nuovo autore', 'center');
	MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%;"');

	MODGUI1.ApriForm('ConfermaDatiAutore');
	HTP.FORMHIDDEN('sessionID',0);

	MODGUI1.Label('Nome*');
	MODGUI1.InputText('nome', 'Nome autore', 1);
	MODGUI1.Label('Cognome*');
	MODGUI1.InputText('cognome', 'Cognome autore', 1);
	MODGUI1.Label('Data nascita');
	MODGUI1.InputDate('dataNascita', 'dataNascita');
	MODGUI1.Label('Data morte');
	MODGUI1.InputDate('dataMorte', 'dataMorte');
	HTP.BR;
	MODGUI1.Label('Nazionalità*');
	MODGUI1.InputText('nazionalita', 'Nazionalita', 1);
	HTP.BR;
	MODGUI1.InputSubmit('Inserisci');
	MODGUI1.ChiudiForm;
	
	MODGUI1.ChiudiDiv;

	HTP.BodyClose;
	HTP.HtmlClose;
END;

-- Procedura per confermare i dati dell'inserimento di un Autore
PROCEDURE ConfermaDatiAutore(
	sessionID NUMBER DEFAULT 0,
	nome VARCHAR2 DEFAULT 'Sconosciuto',
	cognome VARCHAR2 DEFAULT 'Sconosciuto',
	dataNascita VARCHAR2 DEFAULT NULL,
	dataMorte VARCHAR2 DEFAULT NULL,
	nazionalita VARCHAR2 DEFAULT 'Sconosciuta'
) IS
BEGIN
	-- se utente non autorizzato: messaggio errore
	IF nome IS NULL 
	OR cognome IS NULL
	OR (dataNascita IS NOT NULL 
		AND dataMorte IS NOT NULL 
		AND to_date(dataNascita, 'YYYY-MM-DD') > to_date(dataMorte, 'YYYY-MM-DD'))
	OR nazionalita IS NULL
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
		HTP.header(2, 'Nuovo autore');

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
		HTP.TableData('Data Morte: ');
		HTP.TableData(dataMorte);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Nazionalità: ');
		HTP.TableData(nazionalita);
		HTP.TableRowClose;
		HTP.TableClose;

		MODGUI1.ApriForm('InserisciDatiAutore');
		HTP.FORMHIDDEN('sessionID', 0);
		HTP.FORMHIDDEN('nome', nome);
		HTP.FORMHIDDEN('cognome', cognome);
		HTP.FORMHIDDEN('dataNascita', dataNascita);
		HTP.FORMHIDDEN('dataMorte', dataMorte);
		HTP.FORMHIDDEN('nazionalita', nazionalita);
		MODGUI1.InputSubmit('Conferma');
		MODGUI1.ChiudiForm;
		MODGUI1.Collegamento('Annulla', 'InserisciAutore', 'w3-btn');
		MODGUI1.ChiudiDiv;
		HTP.BodyClose;
		HTP.HtmlClose;
	END IF;
	EXCEPTION WHEN OTHERS THEN
		dbms_output.put_line('Error: '||sqlerrm);
END;

-- Effettua l'inserimento di un nuovo Autore nella base di dati
PROCEDURE InserisciDatiAutore(
	sessionID NUMBER DEFAULT 0,
	nome VARCHAR2 DEFAULT 'Sconosciuto',
	cognome VARCHAR2 DEFAULT 'Sconosciuto',
	dataNascita VARCHAR2 DEFAULT NULL,
	dataMorte VARCHAR2 DEFAULT NULL,
	nazionalita VARCHAR2 DEFAULT 'Sconosciuta'
) IS
birth DATE := TO_DATE(dataNascita default NULL on conversion error, 'YYYY-MM-DD');
death DATE := TO_DATE(dataMorte default NULL on conversion error, 'YYYY-MM-DD');
numAutori NUMBER(10) := 0;
AutorePresente EXCEPTION;
BEGIN
	-- Cerco se vi sono autori con gli stessi dati già nella tabella
	SELECT count(*) INTO numAutori FROM Autori 
	WHERE Nome=nome AND Cognome=cognome 
		AND dataNascita=birth AND dataMorte=death 
		AND nazionalità=nazionalita;
	IF numAutori > 0
	THEN
		-- errore: esiste già un Autore nella base di dati
		RAISE AutorePresente;
	END IF;
	INSERT INTO Autori VALUES 
	(IdAutoreSeq.NEXTVAL, nome, cognome, birth, death, nazionalita);

	IF SQL%FOUND
	THEN
		-- faccio il commit dello statement precedente
		commit;

		MODGUI1.ApriPagina('Autore inserito', sessionID);
		HTP.BodyOpen;

		MODGUI1.ApriDiv;
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
		HTP.tabledata('Data Morte: '||death);
		HTP.tablerowopen;
		HTP.tablerowclose;
		HTP.tablerowopen;
		HTP.tabledata('Nazionalità: '||nazionalita);
		HTP.tablerowclose;
		HTP.tableClose;
		MODGUI1.ChiudiDiv;

		HTP.BodyClose;
		HTP.HtmlClose;
	ELSE
		MODGUI1.ApriPagina('Autore non inserito', sessionID);
		HTP.BodyOpen;

		HTP.PRN('Autore non inserito');

		HTP.BodyClose;
		HTP.HtmlClose;
	END IF;
	EXCEPTION
	WHEN AutorePresente THEN
		MODGUI1.ApriPagina('Errore', sessionID);
		HTP.BodyOpen;

		MODGUI1.ApriDiv;
		HTP.PRN('Autore già presente');
		MODGUI1.collegamento('Inserisci nuovo autore', 'InserisciAutore');
		MODGUI1.ChiudiDiv;

		HTP.BodyClose;
		HTP.HtmlClose;
END;


/*
 * OPERAZIONI SULLE DESCRIZIONI
 * - Inserimento ❌
 * - Modifica ❌
 * - Visualizzazione ❌
 * - Cancellazione (rimozione) ❌
 * OPERAZIONI STATISTICHE E MONITORAGGIO
 * - Livello descrizione più presente ❌
 * - Lingua più presente ❌
 */

-- Procedura per l'inserimento di nuove descrizioni nella base di dati
PROCEDURE InserisciDescrizione(
	sessionID NUMBER DEFAULT NULL
) IS
BEGIN
	-- sessionID sono hard-coded fino ad uno standard
	MODGUI1.ApriPagina('Inserimento descrizione', 0);
	
	HTP.BodyOpen;
	HTP.header(1,'Inserisci una nuova descrizione', 'center');
	MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%;"');

	MODGUI1.ApriForm('ConfermaDatiDescrizione');
	HTP.FORMHIDDEN('sessionID',0);
	MODGUI1.Label('Lingua*'); -- TODO: usare dropdown per avere nome standardizzato
	MODGUI1.InputText('lingua', 'Italiano', 1);
	MODGUI1.Label('Livello*'); -- TODO: usare radiobutton
	MODGUI1.InputText('livello', 'bambino || adulto || esperto', 1);
	MODGUI1.Label('Testo descrizione*');
	HTP.BR;
	MODGUI1.InputTextArea('testodescr', '', 1); -- 1 significa campo obbligatorio
	HTP.BR;
	MODGUI1.Label('ID opera*');
	MODGUI1.InputText('operaID', '', 1);
	HTP.BR;
	MODGUI1.InputSubmit('Inserisci');
	MODGUI1.ChiudiForm;
	
	MODGUI1.ChiudiDiv;

	HTP.BodyClose;
	HTP.HtmlClose;
END;

PROCEDURE ConfermaDatiDescrizione(
	sessionID NUMBER DEFAULT 0,
	lingua VARCHAR2 DEFAULT 'Sconosciuta',
	livello VARCHAR2 DEFAULT 'Sconosciuto',
	testodescr VARCHAR2 DEFAULT NULL,
	operaID NUMBER DEFAULT NULL
) IS

BEGIN
	-- TODO: controllo sessione 
	IF lingua IS NULL 
		OR livello not in ('bambino', 'adulto', 'esperto')
		OR testodescr IS NULL
		OR OperaID IS NULL
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
		HTP.header(1, 'Conferma immissione dati', 'center');

		MODGUI1.ApriDiv('style="margin-left: 2%; margin-right: 2%;"');
		HTP.header(2, 'Nuova Descrizione per l''Opera '||operaID); -- modo per fare escape ' dentro stringa

		HTP.TableOpen;
		HTP.TableRowOpen;
		HTP.TableData('Lingua: ');
		HTP.TableData(lingua);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Livello: ');
		HTP.TableData(livello);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Testo: ');
		HTP.TableData(testodescr);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('ID opera: ');
		HTP.TableData(operaID);
		HTP.TableRowClose;
		HTP.TableClose;

		MODGUI1.ApriForm('InserisciDatiDescr');
		HTP.FORMHIDDEN('sessionID', 0);
		HTP.FORMHIDDEN('lingua', lingua);
		HTP.FORMHIDDEN('livello', livello);
		HTP.FORMHIDDEN('testodescr', testodescr);
		HTP.FORMHIDDEN('operaID', operaID);
		MODGUI1.InputSubmit('Conferma');
		MODGUI1.ChiudiForm;
		MODGUI1.Collegamento('Annulla', 'InserisciDescrizione', 'w3-btn');
		MODGUI1.ChiudiDiv;
		HTP.BodyClose;
		HTP.HtmlClose;
	END IF;
END;
/*
	OperaInesistente EXCEPTION; -- eccezione lanciata se l'opera operaID non esiste

	-- Controllo esistenza dell'opera riferita
	Opera Opere%ROWTYPE := (SELECT IdOpera FROM Opere WHERE IdOpera=operaID);

	EXCEPTION
		WHEN OperaInesistente THEN
		-- TODO: msg errore opera non esiste
*/
END gruppo2;