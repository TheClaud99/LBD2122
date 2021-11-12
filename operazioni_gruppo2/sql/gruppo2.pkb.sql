CREATE OR REPLACE PACKAGE BODY gruppo2 AS

/*
 * OPERAZIONI SULLE OPERE
 * - Inserimento 
 * - Modifica  
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

/*procedure menuOpere (sessionID NUMBER DEFAULT NULL) is
    begin
        modGUI1.ApriPagina('Opere',sessionID);
        modGUI1.Header(sessionID);
        htp.br;
        htp.br;
        htp.br;
        htp.br;
        modGUI1.ApriDiv('class="w3-center"');
            htp.prn('<h1>OPERE</h1>');
        modGUI1.ChiudiDiv;
        htp.br;
        modGUI1.ApriDiv('class="w3-row w3-container"');
        if (sessionID=1)
        then
            InserisciOpera(sessionID);
        end if;
    --Visualizzazione TUTTE LE OPERE *temporanea*
            FOR opera IN (Select * from Opere)
            LOOP
                modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                    modGUI1.ApriDiv('class="w3-card-4"');
                    htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%;">');
                            modGUI1.ApriDiv('class="w3-container w3-center"');
                                htp.prn('<p>'|| opera.titolo ||'</p>');
                                htp.br;
                                htp.prn('<p>'|| opera.anno ||'</p>');
                            modGUI1.ChiudiDiv;
                            if(sessionID = 1) then
                                modGUI1.Bottone('w3-black','Visualizza');
                                modGUI1.Bottone('w3-green','Modifica');
                                modGUI1.Bottone('w3-red','Rimuovi');
                            else
                            modGUI1.Bottone('w3-black','Visualizza');
                            end if;
		     -- Azioni di modifica e rimozione mostrate solo se autorizzatii
                    modGUI1.Collegamento('Visualizza',
                        'VisualizzaOpera?sessionID='||sessionID||'&operaID='||opera.IdOpera||'&titoloOpera='||opera.titolo,
                        'w3-black w3-margin w3-button');
                    if sessionID = 1 then
                        -- parametro modifica messo a true: possibile fare editing dell'autore
                        modGUI1.Collegamento('Modifica',
                            'VisualizzaOpera?sessionID='||sessionID||'&operaID='||opera.IdOpera||'&titoloOpera='||opera.titolo||'&modifica=1',
                            'w3-green w3-margin w3-button');
                        -- TODO: sostituire con rimozione
                        modGUI1.Collegamento('Rimuovi',
                            'RimozioneOpera?sessionID='||sessionID||'&operaID='||opera.IdOpera||'&titoloOpera='||opera.titolo,
                            'w3-red w3-margin w3-button');
                    end if;

                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
            END LOOP;
        modGUI1.chiudiDiv;
    end menuOpere;


-- Procedura per l'inserimento di nuove Opere nella base di dati
PROCEDURE InserisciOpera(
    sessionID NUMBER DEFAULT NULL
) IS
BEGIN
   modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
        modGUI1.ApriDiv('class="w3-card-4" style="height:420px;"');
            htp.br;
            modGUI1.InputImage('ImmOpera','fotoopera');
            modGUI1.ApriDiv('class="w3-container w3-margin w3-center"');
                modGUI1.ApriForm('ConfermaDatiOpera');
                modGUI1.Label('Titolo*:');
                modGUI1.InputText('titolo','Inserisci il titolo ...', 1);
                htp.br;
                modGUI1.Label('Anno*:');
                modGUI1.InputText('anno','Inserisci anno ...', 1);
                htp.br;
                modGUI1.Label('Museo*:');
                MODGUI1.SelectOpen('idmusei');
                for museo in (SELECT idMuseo,nome FROM Musei)
                loop
                MODGUI1.SelectOption(museo.idMuseo,museo.nome);
                end loop;
                MODGUI1.SelectClose;
                htp.br;
                modGUI1.Label('Fine periodo:');
                modGUI1.InputText('fineperiodo','Inserisci fine periodo...', 0);
                htp.br;
                modGUI1.InputSubmit('Aggiungi');
                modGUI1.ChiudiForm;
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
    modGUI1.ChiudiDiv;
END;

PROCEDURE InserisciDatiOpera(
    sessionID NUMBER DEFAULT 0,
    titolo VARCHAR2 DEFAULT 'Sconosciuto',
    anno VARCHAR2 DEFAULT NULL,
    fineperiodo VARCHAR2 DEFAULT NULL,
    idmusei NUMBER DEFAULT NULL
)IS
age DATE :=TO_DATE(anno,'yyyy-mm-dd');
periodo DATE :=TO_DATE(fineperiodo,'yyyy-mm-dd');
BEGIN
    INSERT INTO Opere VALUES
    (IdOperaSeq.NEXTVAL,titolo,10,periodo,idmusei);
    IF SQL%FOUND
    THEN
        -- faccio il commit dello statement precedente
        commit;
 
        HTP.BodyOpen;
        MODGUI1.ApriDiv;
        HTP.tableopen;
        HTP.tablerowopen;
        HTP.tabledata('Nome: '||titolo);
        HTP.tablerowclose;
        HTP.tablerowopen;
        HTP.tabledata('Anno: '||age);
        HTP.tablerowclose;
        HTP.tablerowopen;
        HTP.tabledata('Periodo: '||periodo);
        HTP.tablerowclose;
        MODGUI1.ChiudiDiv;
 
        HTP.BodyClose;
        HTP.HtmlClose;
    ELSE
        MODGUI1.ApriPagina('Opera non inserita', sessionID);
        HTP.BodyOpen;
 
        HTP.PRN('Opera non inserita');
 
        HTP.BodyClose;
        HTP.HtmlClose;
    END IF;
     EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line('Error: '||sqlerrm);
 
END InserisciDatiOpera;

PROCEDURE ConfermaDatiOpera(
    sessionID NUMBER DEFAULT 0,
    titolo VARCHAR2 DEFAULT 'Sconosciuto',
    anno VARCHAR2 DEFAULT NULL,
    fineperiodo VARCHAR2 DEFAULT NULL,
    idmusei NUMBER DEFAULT NULL
) IS
var1 varchar2(40);
    BEGIN
    IF titolo IS NULL
    OR anno IS NULL
    OR idmusei IS NULL
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
        modGUI1.ApriPagina('Opere',sessionID);
        modGUI1.Header(sessionID);
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px" ');
            modGUI1.ApriDiv('class="w3-section"');
            htp.br;
                    modGUI1.Label(' Titolo:');
                    HTP.PRINT(titolo);
                    htp.br;
                    htp.br;
                    modGUI1.Label(' Anno:');
                    HTP.PRINT(anno);
                    htp.br;
                    htp.br;
                    SELECT nome into var1 FROM Musei
                    WHERE Musei.idMuseo=idmusei;
                    modGUI1.Label(' Museo:');
                    HTP.PRINT(var1);
                    htp.br;
                    htp.br;
                modGUI1.ChiudiDiv;
            MODGUI1.ApriForm('InserisciDatiOpera');
            HTP.FORMHIDDEN('sessionID', sessionID);
            HTP.FORMHIDDEN('titolo', titolo);
            HTP.FORMHIDDEN('anno', anno);
            HTP.FORMHIDDEN('idmusei', idmusei);
            MODGUI1.InputSubmit('Conferma');
            MODGUI1.ChiudiForm;
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
    END IF;
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line('Error: '||sqlerrm);
END;
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


--procedura per la visualizzazione del menu Autori
procedure menuAutori (
    sessionID NUMBER DEFAULT NULL,
    authName VARCHAR2 DEFAULT NULL,
    authSurname VARCHAR2 DEFAULT NULL,
    dataNascita VARCHAR2 DEFAULT NULL,
    dataMorte VARCHAR2 DEFAULT NULL,
    nation VARCHAR2 DEFAULT NULL
    ) is
    begin
        modGUI1.ApriPagina('Autori',sessionID);
        modGUI1.Header(sessionID);
        htp.br;htp.br;htp.br;htp.br;
        modGUI1.ApriDiv('class="w3-center"');
            htp.prn('<h1>Autori</h1>');
        modGUI1.ChiudiDiv;
        htp.br;
        modGUI1.ApriDiv('class="w3-row w3-container"');
        -- Mostra form inserimento autori sse loggato con sessionID=1
        IF (sessionID=1)
        THEN
            modGUI1.Collegamento('Inserisci', 'InserisciAutore?sessionID='||sessionID, 'w3-button w3-margin');
            htp.br;
        END IF;
        --Visualizzazione TUTTI GLI AUTORI *temporanea*
        -- TODO: filtraggio
        FOR autore IN (Select IdAutore,nome,cognome from Autori)
        LOOP
            modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                modGUI1.ApriDiv('class="w3-card-4"');
                    htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%;">');
                    modGUI1.ApriDiv('class="w3-container w3-center"');
                        htp.prn('<p>'|| autore.Nome ||' '||autore.Cognome||'</p>');
                    modGUI1.ChiudiDiv;
                    -- Azioni di modifica e rimozione mostrate solo se autorizzatii
                    modGUI1.Collegamento('Visualizza', 
                        'ModificaAutore?sessionID='||sessionID||'&authorID='||autore.IdAutore||'&operazione=0', 
                        'w3-black w3-margin w3-button');
                    if(sessionID=1) then
                        -- parametro modifica messo a true: possibile fare editing dell'autore
                        modGUI1.Collegamento('Modifica',
                            'ModificaAutore?sessionID='||sessionID||'&authorID='||autore.IdAutore||'&operazione=1', 
                            'w3-green w3-margin w3-button');
                        -- TODO: sostituire con rimozione
                        modGUI1.Collegamento('Rimuovi', 
                            'ModificaAutore?sessionID='||sessionID||'&authorID='||autore.IdAutore||'&operazione=0', 
                            'w3-red w3-margin w3-button');
                    end if;
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
        END LOOP;
        modGUI1.chiudiDiv;
    end menuAutori;

-- Procedura per l'inserimento di nuovi Autori nella base di dati
-- I parametri (a parte sessionID) sono usati per effettuare il riempimento automatico del form ove necessario
PROCEDURE InserisciAutore(
    sessionID NUMBER DEFAULT NULL,
    authName VARCHAR2 DEFAULT NULL,
    authSurname VARCHAR2 DEFAULT NULL,
    dataNascita VARCHAR2 DEFAULT NULL,
    dataMorte VARCHAR2 DEFAULT NULL,
    nation VARCHAR2 DEFAULT NULL
) IS
placeholderNome VARCHAR2(255) := 'Inserisci il nome...';
placeholderCognome VARCHAR2(255) := 'Inserisci il cognome...';
placeholderNazionalita VARCHAR2(255) := 'Inserisci nazionalità...';
BEGIN
    -- script disabilita data
    htp.script('function disable_date(name) {
        var in_date = (document.getElementById(name));
        in_date.disabled = !(in_date.disabled);
        }', 'Javascript');
    modGUI1.ApriPagina('Inserimento Autore', sessionID);

    modGUI1.Header(sessionID);
    htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
    htp.prn('<h1 align="center">Inserimento Autore</h1>');--DA MODIFICARE
    modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
        modGUI1.ApriDiv('class="w3-section"');
        modGUI1.Collegamento('X','menuAutori?sessionID='||sessionID,' w3-btn w3-large w3-red w3-display-topright'); --Bottone per tornare indietro, cambiare COLLEGAMENTOPROVA
        -- Form per mandare dati alla procedura di conferma
        modGUI1.ApriForm('ConfermaDatiAutore');
        htp.FORMHIDDEN('sessionID',sessionID);
        htp.br;
        modGUI1.Label('Nome*');
        modGUI1.InputText('authName', placeholderNome, 1, authName);
        htp.br;
        modGUI1.Label('Cognome*');
        modGUI1.InputText('authSurname', placeholderCognome, 1, authSurname);
        htp.br;
        -- L'input di tipo data si disattiva se spuntata checkbox e viceversa
        MODGUI1.Label('Data nascita');
        MODGUI1.inputcheckboxonclick('Sconosciuta', null, 
            'disable_date(''dataNascita'')', null, 0, 0);
        htp.br;
        MODGUI1.InputDate('dataNascita', 'dataNascita', 0, dataNascita);
        htp.br;
        MODGUI1.Label('Data morte');
        MODGUI1.inputcheckboxonclick('Sconosciuta', null, 
            'disable_date(''dataMorte'')', null, 0, 0);
        htp.br;
        MODGUI1.InputDate('dataMorte', 'dataMorte', 0, dataMorte);
        htp.br;
        modGUI1.Label('Nazionalita*');
        modGUI1.InputText('nation', placeholderNazionalita, 1, nation);
        htp.br;
        modGUI1.InputSubmit('Aggiungi');
        modGUI1.ChiudiForm;
    
        modGUI1.ChiudiDiv;
    modGUI1.ChiudiDiv;

    /*modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
        modGUI1.ApriDiv('class="w3-card-4"');           
            htp.br;
            modGUI1.InputImage('ImmAutore','fotoautore');
            modGUI1.ApriDiv('class="w3-container w3-margin w3-center"');
				-- Form per mandare dati alla procedura di conferma
                modGUI1.ApriForm('ConfermaDatiAutore');
                htp.FORMHIDDEN('sessionID',sessionID);
                modGUI1.Label('Nome*');
                htp.br;
                modGUI1.InputText('authName', placeholderNome, 1, authName);
                htp.br;
                modGUI1.Label('Cognome*');
                htp.br;
                modGUI1.InputText('authSurname', placeholderCognome, 1, authSurname);
                htp.br;
                -- L'input di tipo data si disattiva se spuntata checkbox e viceversa
                MODGUI1.Label('Data nascita');
                MODGUI1.inputcheckboxonclick('Sconosciuta', null, 
                    'disable_date(''dataNascita'')', null, 0, 0);
                htp.br;
                MODGUI1.InputDate('dataNascita', 'dataNascita', 0, dataNascita);
                htp.br;
                MODGUI1.Label('Data morte');
                MODGUI1.inputcheckboxonclick('Sconosciuta', null, 
                    'disable_date(''dataMorte'')', null, 0, 0);
                htp.br;
                MODGUI1.InputDate('dataMorte', 'dataMorte', 0, dataMorte);
                htp.br;
                modGUI1.Label('Nazionalita*');
                htp.br;
                modGUI1.InputText('nation', placeholderNazionalita, 1, nation);
                htp.br;
                modGUI1.InputSubmit('Aggiungi');
                modGUI1.Collegamento('Torna al menu Autori', 
                        'menuAutori?sessionID='||sessionID, 
                        'w3-black w3-margin w3-button');
                modGUI1.ChiudiForm;
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
    modGUI1.ChiudiDiv;*/
END;

-- Procedura per confermare i dati dell'inserimento di un Autore
PROCEDURE ConfermaDatiAutore(
    sessionID NUMBER DEFAULT 0,
    authName VARCHAR2 DEFAULT 'Sconosciuto',
    authSurname VARCHAR2 DEFAULT 'Sconosciuto',
    dataNascita VARCHAR2 DEFAULT NULL,
    dataMorte VARCHAR2 DEFAULT NULL,
    nation VARCHAR2 DEFAULT 'Sconosciuta' 
) IS
numAutori NUMBER := 0;
birth DATE := to_date(dataNascita, 'YYYY-MM-DD');
death DATE := to_date(dataMorte, 'YYYY-MM-DD');
BEGIN
    -- controllo parametri
    SELECT count(*) INTO numAutori FROM Autori A 
    WHERE A.Nome = authName
        AND A.Cognome = authSurname
        AND (A.DataNascita = birth OR (A.DataNascita IS NULL AND birth IS NULL))
        AND (A.DataMorte = death OR (A.DataMorte IS NULL AND death IS NULL))
        AND A.Nazionalita = nation;
    IF numAutori > 0
    OR sessionID = 0
    OR authName IS NULL
    OR authSurname IS NULL
    OR (birth IS NOT NULL AND death IS NOT NULL AND death < birth)
    OR nation IS NULL
    THEN
        -- uno dei parametri con vincoli ha valori non validi
        MODGUI1.APRIPAGINA('Errore', sessionID);
        HTP.BodyOpen;
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:1000px" ');
            modGUI1.label(' Errore: ');
            IF sessionID <> 1 THEN
                htp.prn('Operazione non autorizzata');
            ELSIF numAutori > 0 THEN
                htp.prn('Autore già presente');
            ELSE
				-- I tre rami che seguono non possono essere raggiunti chiamando
				-- InserisciAutore, ma sono possibili chiamando direttamente ConfermaDatiAutore
                IF authName IS NULL THEN
                    htp.prn('Nome nullo');
                ELSIF authSurname IS NULL THEN
                    htp.prn('Cognome nullo');
                ELSIF nation IS NULL THEN
                    htp.prn('Nazionalita nulla');
                ELSIF to_date(dataNascita, 'YYYY-MM-DD') > to_date(dataMorte, 'YYYY-MM-DD') THEN
                    htp.prn('La data di nascita ('||dataNascita
                        ||') è posteriore alla data di morte ('||dataMorte||')');
                END IF;
            END IF;
			-- Un unico bottone OK per rimandare alla procedura di inserimento
            MODGUI1.ApriForm('InserisciAutore');
            HTP.FORMHIDDEN('sessionID', sessionID);
            HTP.FORMHIDDEN('authName', authName);
            HTP.FORMHIDDEN('authSurname', authSurname);
            HTP.FORMHIDDEN('dataNascita', dataNascita);
            HTP.FORMHIDDEN('dataMorte', dataMorte);
            HTP.FORMHIDDEN('nation', nation);
            MODGUI1.InputSubmit('OK');
        MODGUI1.ChiudiDiv;
    ELSE
		-- Parametri OK, pulsante conferma o annulla
        modGUI1.ApriPagina('Conferma dati',sessionID);
        modGUI1.Header(sessionID);
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;

        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px" ');
            modGUI1.ApriDiv('class="w3-section"');
            htp.br;
            modGUI1.Label('Nome:');
            HTP.PRINT(authName);
            htp.br;
            modGUI1.Label('Cognome:');
			HTP.PRINT(authSurname);
            htp.br;
            modGUI1.Label('Data nascita:');
            IF dataNascita IS NOT NULL THEN
                HTP.PRINT(dataNascita);
            ELSE
                HTP.print('Non specificata');
            END IF;
            htp.br;
            modGUI1.Label('Data morte:');
            IF dataMorte IS NOT NULL THEN
                HTP.PRINT(dataMorte);
            ELSE
                HTP.print('Non specificata');
            END IF;
            htp.br;
            modGUI1.Label('Nazionalita:');
            HTP.PRINT(nation);
            htp.br;
            modGUI1.ChiudiDiv;
            -- Form nascosto per conferma insert
            MODGUI1.ApriForm('InserisciDatiAutore');
            HTP.FORMHIDDEN('sessionID', sessionID);
            HTP.FORMHIDDEN('authName', authName);
            HTP.FORMHIDDEN('authSurname', authSurname);
            HTP.FORMHIDDEN('dataNascita', dataNascita);
            HTP.FORMHIDDEN('dataMorte', dataMorte);
            HTP.FORMHIDDEN('nation', nation);
            MODGUI1.InputSubmit('Conferma');
            MODGUI1.ChiudiForm;
            -- Form nascosto per ritorno ad InserisciAutore con form precompilato
            MODGUI1.ApriForm('InserisciAutore');
            HTP.FORMHIDDEN('sessionID', sessionID);
            HTP.FORMHIDDEN('authName', authName);
            HTP.FORMHIDDEN('authSurname', authSurname);
            HTP.FORMHIDDEN('dataNascita', dataNascita);
            HTP.FORMHIDDEN('dataMorte', dataMorte);
            HTP.FORMHIDDEN('nation', nation);
            MODGUI1.InputSubmit('Annulla');
            MODGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
    END IF;
	-- Solo per testing
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line('Error: '||sqlerrm);
END;

-- Effettua l'inserimento di un nuovo Autore nella base di dati
PROCEDURE InserisciDatiAutore(
    sessionID NUMBER DEFAULT 0,
    authName VARCHAR2 DEFAULT 'Sconosciuto',
    authSurname VARCHAR2 DEFAULT 'Sconosciuto',
    dataNascita VARCHAR2 DEFAULT NULL,
    dataMorte VARCHAR2 DEFAULT NULL,
    nation VARCHAR2 DEFAULT 'Sconosciuta'
) IS
birth DATE := TO_DATE(dataNascita default NULL on conversion error, 'YYYY-MM-DD');
death DATE := TO_DATE(dataMorte default NULL on conversion error, 'YYYY-MM-DD');
numAutori NUMBER(10) := 0;
AutorePresente EXCEPTION;
BEGIN
    -- Cognome autore maiuscolo
    INSERT INTO Autori VALUES
    (IdAutoreSeq.NEXTVAL, authName, UPPER(authSurname), birth, death, nation);
    IF SQL%FOUND
    THEN
        -- faccio il commit dello statement precedente  
        commit;
		-- Ritorno al menu Autori direttamente
        gruppo2.menuautori(sessionID);
    ELSE
        MODGUI1.ApriPagina('Errore', sessionID);
        modGUI1.ApriDiv;
		modGUI1.Label('Errore: ');
		htp.prn('Fallito inserimento autore');
		modGUI1.ChiudiDiv;
    END IF;
    EXCEPTION
    WHEN AutorePresente THEN
        MODGUI1.ApriPagina('Errore', sessionID);
        MODGUI1.ApriDiv;
        HTP.PRN('Autore già presente');
        MODGUI1.collegamento('Inserisci nuovo autore', 'InserisciAutore');
        MODGUI1.ChiudiDiv;
END;

-- Procedura per visualizzare/modificare un Autore presente nella base di dati (raggiungibile dal menuAutori)
PROCEDURE ModificaAutore(
	sessionID NUMBER DEFAULT 0,
	authorID NUMBER DEFAULT 0,
    operazione NUMBER DEFAULT 0
) IS
this_autore Autori%ROWTYPE;
BEGIN
    SELECT * INTO this_autore FROM Autori where IdAutore = authorID;
    IF operazione = 1 THEN
        modGUI1.ApriPagina('Modifica Autore', sessionID);
    ELSIF operazione = 2 THEN
        modGUI1.ApriPagina('Rimuovi Autore', sessionID);
	ELSE
		modGUI1.ApriPagina('Visualizza Autore', sessionID);
    END IF;
	modGUI1.Header(sessionID);
	htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
	modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px" ');
		modGUI1.ApriDiv('class="w3-section"');
		htp.br;
		htp.header(2, 'Dettagli Autore', 'center');
		-- caso modifica: un form
		IF operazione != 0 THEN
			modGUI1.ApriForm('UpdateAutore');
                modGUI1.Label('Nome:'); 
				modGUI1.InputText('authName', this_autore.Nome, 1);
                htp.br;
                modGUI1.Label('Cognome:');
				modGUI1.InputText('authSurname', this_autore.Cognome, 1);
                htp.br;
                modGUI1.Label('Data nascita:');
				modGUI1.InputDate('', 'dataNascita', 1, TO_DATE(this_autore.DataNascita, 'DD-Mon-YYYY'));
                htp.br;
                modGUI1.Label('Data morte:');
				modGUI1.InputDate('', 'dataMorte', 1, TO_DATE(this_autore.DataMorte, 'DD-Mon-YYYY'));
                htp.br;
                modGUI1.Label('Nazionalità:');
				modGUI1.InputText('nation', this_autore.Nazionalita, 1);
                htp.br;
				modGUI1.InputSubmit('Conferma');
			modGUI1.ChiudiForm;
		-- caso visualizza: label + valore
		ELSE
			modGUI1.Label('Nome:');
			htp.prn(this_autore.Nome);
			htp.br;
			modGUI1.Label('Cognome:');
			htp.prn(this_autore.Cognome);
			htp.br;
			modGUI1.Label('Data nascita:');
			IF this_autore.DataNascita IS NULL THEN
				htp.prn(this_autore.DataNascita);
			ELSE
				htp.prn('Sconosciuta');
			END IF;
			htp.br;
			modGUI1.Label('Data morte:');
			IF this_autore.DataMorte IS NULL THEN
				htp.prn(this_autore.DataMorte);
			ELSE
				htp.prn('Sconosciuta');
			END IF;
			htp.br;
			modGUI1.Label('Nazionalità:');
			htp.prn(this_autore.Nazionalita);
			htp.br;
		END IF;
		modGUI1.Collegamento('Torna al menu principale', 
					'menuAutori?sessionID='||sessionID, 
					'w3-black w3-margin w3-button');
		modGUI1.ChiudiDiv;
	modGUI1.ChiudiDiv;
END ModificaAutore;

PROCEDURE UpdateAutore(
	sessionID NUMBER DEFAULT 0,
	authID NUMBER DEFAULT 0,
	newName VARCHAR2 DEFAULT 'Sconosciuto',
	newSurname VARCHAR2 DEFAULT 'Sconosciuto',
	newBirth VARCHAR2 DEFAULT NULL,
	newDeath VARCHAR2 DEFAULT NULL,
	newNation VARCHAR2 DEFAULT 'Sconosciuta'
) IS
Errore_data EXCEPTION;
BEGIN
	IF TO_DATE(newBirth, 'YYYY-MM-DD') < TO_DATE(newDeath, 'YYYY-MM-DD') THEN
		RAISE Errore_data;
	END IF;
	UPDATE Autori SET 
		Nome=newName, 
		Cognome=newSurname, 
		DataNascita=newBirth, 
		DataMorte=newDeath, 
		Nazionalita=newNation
	WHERE IdAutore=authID;
	EXCEPTION 
		WHEN Errore_data THEN
			DBMS_OUTPUT.PUT_LINE('A');
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
-- TODO: autofill provenedo da ConfermaDatiDescrizione
PROCEDURE InserisciDescrizione(
    sessionID NUMBER DEFAULT NULL,
    lingua VARCHAR2 DEFAULT NULL,
    livello VARCHAR2 DEFAULT NULL,
    testodescr VARCHAR2 DEFAULT NULL,
    operaID NUMBER DEFAULT NULL
) IS
BEGIN
    modGUI1.ApriPagina('Inserimento Descrizione', sessionID);

    modGUI1.Header(sessionID);
    htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
    htp.prn('<h1 align="center">Inserimento Descrizione</h1>');--DA MODIFICARE
    modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
        modGUI1.ApriDiv('class="w3-section"');
        modGUI1.Collegamento('X','menuOpere?sessionID='||sessionID,' w3-btn w3-large w3-red w3-display-topright'); --Bottone per tornare indietro, cambiare COLLEGAMENTOPROVA
        -- Form per mandare dati alla procedura di conferma
        modGUI1.ApriForm('ConfermaDatiDescrizione');
        htp.FORMHIDDEN('sessionID',sessionID);
        htp.br;
        MODGUI1.Label('Lingua*'); -- TODO: usare dropdown per avere nome standardizzato
        MODGUI1.InputText('lingua', 'Italiano', 1);
        htp.br;
        MODGUI1.Label('Livello*');
        modGUI1.InputRadioButton('Bambino', 'livello', 'bambino', 0, 0);
        modGUI1.InputRadioButton('Adulto', 'livello', 'adulto', 0, 0);
        modGUI1.InputRadioButton('Esperto', 'livello', 'esperto', 0, 0);
        htp.br;
        MODGUI1.Label('Testo descrizione*');
        HTP.BR;
        MODGUI1.InputTextArea('testodescr', '', 1);
        HTP.BR;
        MODGUI1.Label('ID opera*');
        MODGUI1.InputText('operaID', '', 1);
        HTP.BR;
        MODGUI1.InputSubmit('Inserisci');
    MODGUI1.ChiudiDiv;
    MODGUI1.ChiudiDiv;
END;

PROCEDURE ConfermaDatiDescrizione(
    sessionID NUMBER DEFAULT 0,
    lingua VARCHAR2 DEFAULT 'Sconosciuta',
    livello VARCHAR2 DEFAULT 'Sconosciuto',
    testodescr VARCHAR2 DEFAULT NULL,
    operaID NUMBER DEFAULT NULL
) IS

BEGIN
    IF lingua IS NULL
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
        	-- Parametri OK, pulsante conferma o annulla
        modGUI1.ApriPagina('Conferma dati',sessionID);
        modGUI1.Header(sessionID);
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;

        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px" ');
            modGUI1.ApriDiv('class="w3-section"');
            htp.br;
            modGUI1.Label('Lingua:');
            HTP.PRINT(lingua);
            htp.br;
            modGUI1.Label('Livello:');
			HTP.PRINT(livello);
            htp.br;
            modGUI1.Label('Testo descrizione:');
            HTP.PRINT(testodescr);
            htp.br;
            modGUI1.ChiudiDiv;
            -- Form nascosto per conferma insert
            MODGUI1.ApriForm('InserisciDatiDescrizione');
            HTP.FORMHIDDEN('sessionID', sessionID);
            HTP.FORMHIDDEN('lingua', lingua);
            HTP.FORMHIDDEN('livello', livello);
            HTP.FORMHIDDEN('testodescr', testodescr);
            HTP.FORMHIDDEN('operaID', 0);
            MODGUI1.InputSubmit('Conferma');
            MODGUI1.ChiudiForm;
            -- Form nascosto per ritorno ad InserisciAutore con form precompilato
            MODGUI1.ApriForm('InserisciDescrizione');
            HTP.FORMHIDDEN('sessionID', sessionID);
            HTP.FORMHIDDEN('lingua', lingua);
            HTP.FORMHIDDEN('livello', livello);
            HTP.FORMHIDDEN('testodescr', testodescr);
            HTP.FORMHIDDEN('operaID', 0);
            MODGUI1.InputSubmit('Annulla');
            MODGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
    END IF;
END;

-- Effettua l'inserimento di una nuova descrizione nella base di dati
PROCEDURE InserisciDatiDescrizione(
    sessionID NUMBER DEFAULT 0,
    lingua VARCHAR2 DEFAULT 'Sconosciuta',
    livello VARCHAR2 DEFAULT 'Sconosciuto',
    testodescr VARCHAR2 DEFAULT NULL,
    operaID NUMBER DEFAULT NULL
) IS
OperaInesistente EXCEPTION; -- eccezione lanciata se l'opera operaID non esiste
Opera Opere%ROWTYPE;
BEGIN
    -- Controllo esistenza dell'opera riferita
    --SELECT * INTO Opera FROM Opere WHERE IdOpera=operaID;
    IF true
    THEN
    -- faccio il commit dello statement precedente
        commit;

        MODGUI1.ApriPagina('Descrizione inserita', sessionID);
        HTP.BodyOpen;

        MODGUI1.ApriDiv;
        HTP.tableopen;
        HTP.tablerowopen;
        HTP.tabledata('Lingua: '||lingua);
        HTP.tablerowclose;
        HTP.tablerowopen;
        HTP.tabledata('Livello: '||livello);
        HTP.tablerowclose;
        HTP.tablerowopen;
        HTP.tabledata('Testo: '||testodescr);
        HTP.tablerowclose;
        HTP.tablerowopen;
        HTP.tabledata('Opera: '||operaID);
        HTP.tablerowopen;
        HTP.tablerowclose;
        HTP.tableClose;
        MODGUI1.ChiudiDiv;

        HTP.BodyClose;
        HTP.HtmlClose;
     ELSE
    -- opera non presente: eccezione
        RAISE OperaInesistente;
    END IF;

    EXCEPTION
        WHEN OperaInesistente THEN
        -- TODO: msg errore opera non esiste
    DBMS_OUTPUT.PUT_LINE('Errore');
   END;


END gruppo2;
