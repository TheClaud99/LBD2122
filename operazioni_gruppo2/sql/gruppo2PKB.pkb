CREATE OR REPLACE PACKAGE BODY gruppo2 AS

PROCEDURE genericErrorPage(
    idSessione NUMBER DEFAULT 0,
    pageTitle VARCHAR2 DEFAULT 'Errore',
    msg VARCHAR2 DEFAULT 'Errore sconosciuto',
    redirectText VARCHAR2 DEFAULT 'OK',
    redirect VARCHAR2 DEFAULT NULL
) IS
BEGIN
    modGUI1.ApriPagina(pageTitle,idSessione);
        modGUI1.Header(idSessione);
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:450px"');
                modGUI1.ApriDiv('class="w3-center"');
                htp.print('<h1>'||pageTitle||'</h1>');
                htp.print(msg);
                MODGUI1.collegamento(redirectText, redirect,'w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
END;

-- Procedura per feedback
-- pageTitle: titolo della pagina HTML
-- msg: il messaggio di errore (opzionale)
-- nuovaOp: il nome del bottone che porta alla nuova operazione (opzionale)
-- nuovaOpURL: il nome della procedura da ripetere (opzionale)
-- parametrinuovaOp: i parametri da passare alla procedura chiamata (opzionale)
-- backToMenu: il nome del pulsante per tornare al menu (obbligatorio)
-- backToMenuURL: URL del menu a cui andare (obbligatorio)
-- parametribackToMenu: parametri da passare al menu di ritorno

procedure RedirectEsito (
    idSessione NUMBER DEFAULT NULL,
    pageTitle VARCHAR2 DEFAULT NULL,
    msg VARCHAR2 DEFAULT NULL,
    nuovaOp VARCHAR2 DEFAULT NULL, 
    nuovaOpURL VARCHAR2 DEFAULT NULL,
    parametrinuovaOp VARCHAR2 DEFAULT '',
    backToMenu VARCHAR2 DEFAULT NULL,
    backToMenuURL VARCHAR2 DEFAULT NULL,
    parametribackToMenu VARCHAR2 DEFAULT ''
    ) is
    begin
        htp.print('<script> window.location = "'||costanti.server||costanti.radice||
        'EsitoOperazione?idSessione='||IDSESSIONE||
        '&pageTitle='||pageTitle||
        '&msg='||msg||
        '&nuovaOp='||nuovaOp||
        '&nuovaOpURL='||nuovaOpURL||
        '&parametrinuovaOp='||parametrinuovaOp||
        '&backToMenu='||backToMenu||
        '&backToMenuURL='||backToMenuURL||
        '&parametribackToMenu='||parametribackToMenu||'"</script>');
    end RedirectEsito;
 
procedure EsitoOperazione(
    idSessione NUMBER DEFAULT NULL,
    pageTitle VARCHAR2 DEFAULT NULL,
    msg VARCHAR2 DEFAULT NULL,
    nuovaOp VARCHAR2 DEFAULT NULL,
    nuovaOpURL VARCHAR2 DEFAULT NULL,
    parametrinuovaOp VARCHAR2 DEFAULT '',
    backToMenu VARCHAR2 DEFAULT NULL,
    backToMenuURL VARCHAR2 DEFAULT NULL,
    parametribackToMenu VARCHAR2 DEFAULT ''
    ) is 
    paramOp VARCHAR2(250);
    paramBTM VARCHAR2(250);
    begin
    paramOP := REPLACE(parametrinuovaOp,'//','&');
    paramBTM := REPLACE(parametribackToMenu,'//','&');
        modGUI1.ApriPagina(pageTitle, idSessione);
        if idSessione IS NULL then
            modGUI1.Header;
        else
            modGUI1.Header(idSessione);
        end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:450px"');
                modGUI1.ApriDiv('class="w3-center"');
                htp.print('<h1>'||pageTitle||'</h1>');
                if msg IS NOT NULL then
                    htp.prn('<p>'||msg||'</p>');
                end if;
                if nuovaOp IS NOT NULL OR nuovaOpURL IS NOT NULL then
                    MODGUI1.collegamento(nuovaOp, nuovaOpURL||'?idSessione='||idSessione||paramOP,'w3-button w3-block w3-black w3-section w3-padding');
                end if;
                    MODGUI1.collegamento(backToMenu, backToMenuURL||'?idSessione='||idSessione||paramBTM,'w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
end EsitoOperazione;

/*
 * OPERAZIONI SULLE OPERE
 * - Inserimento ✅
 * - Modifica ✅
 * - Visualizzazione ✅
 * - Cancellazione (rimozione) ✅
 * - Spostamento ✅
 * - Aggiunta Autore ✅
 * - Rimozione Autore ✅
 * OPERAZIONI STATISTICHE E MONITORAGGIO
 * - Storico prestiti dell’Opera ✅
 * - Storico spostamenti relativi ad un Museo ❌ //procedura relativa al gruppo museo
 * - Autori dell’Opera ✅
 * - Tipo Sala in cui si trova l’Opera ✅
 * - Descrizioni dell’Opera ✅
 * - Lista Opere ordinate per numero di Autori in ordine decrescente ✅
 * - Opere non spostata da più tempo (le tre più vecchie) ✅
 * - Opere esposte per più tempo (le tre più vecchie)✅
 * - Età media delle opere ✅ 
 * - Ordinamento per anno di realizzazione (le tre più vecchie) ✅ 
 */

procedure menuOpere (idSessione NUMBER DEFAULT NULL) is
    begin
        htp.prn('<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> ');
        modGUI1.ApriPagina('Opere',idSessione);
        if idSessione IS NULL then
            modGUI1.Header(0);
        else
            modGUI1.Header(idSessione);
        end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;
        modGUI1.ApriDiv('class="w3-center"');
        htp.prn('<h1>Opere</h1>'); --TITOLO
        if hasRole(IdSessione, 'DBA') or hasRole(IdSessione, 'GO')
        then
            modGUI1.Collegamento('Inserisci opera','InserisciOpera?idSessione='||idSessione||'','w3-btn w3-round-xxlarge w3-black');
            htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
            modGUI1.Collegamento('Inserisci descrizione','InserisciDescrizione?idSessione='||idSessione||'','w3-btn w3-round-xxlarge w3-black');
            htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
        end if;
            htp.prn('<button onclick="document.getElementById(''11'').style.display=''block''" class="w3-btn w3-round-xxlarge w3-black">Statistiche</button>');
        modGUI1.ChiudiDiv;
            gruppo2.selezioneMuseo(idSessione);
        htp.br;
        modGUI1.ApriDiv('class="w3-row w3-container"');
    --Visualizzazione TUTTE LE OPERE *temporanea*
            FOR opera IN (SELECT * FROM Opere)
            LOOP
                modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                    modGUI1.ApriDiv('class="w3-card-4" style="height:600px;"');
                    htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%;">');
                            modGUI1.ApriDiv('class="w3-container w3-center"');
                                htp.prn('<p><b>Titolo: </b>'|| opera.titolo ||'</p>');
                                htp.br;
                                htp.prn('<p><b>Anno: </b>'|| opera.anno ||'</p>');
                            modGUI1.ChiudiDiv;
                        htp.prn('<button onclick="document.getElementById(''LinguaeLivelloOpera'||opera.idOpera||''').style.display=''block''" class="w3-margin w3-button w3-black w3-hover-white">Visualizza</button>');
                        gruppo2.linguaELivello(idSessione,opera.idOpera);

                        if hasRole(IdSessione, 'DBA') or hasRole(IdSessione, 'GO') then
                        --bottone modifica
                        modGUI1.Collegamento('Modifica',
                            'ModificaOpera?idSessione='||idSessione||'&operaID='||opera.IdOpera||'&titoloOpera='||opera.titolo,
                            'w3-green w3-margin w3-button');
                        --bottone elimina
                        htp.prn('<button onclick="document.getElementById(''ElimOpera'||opera.idOpera||''').style.display=''block''" class="w3-margin w3-button w3-red w3-hover-white">Elimina</button>');
                        gruppo2.EliminazioneOpera(idSessione,opera.idOpera);
                        htp.br;
                    end if;
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
            END LOOP;

        modGUI1.chiudiDiv;
end menuOpere;

--Procedura popUp per la conferma
procedure EliminazioneOpera(
    idSessione NUMBER default 0,
    operaID NUMBER default 0
)is /*Form popup lingua */
var1 VARCHAR2(100);
    begin
        modGUI1.ApriDiv('id="ElimOpera'||operaID||'" class="w3-modal"');
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
                modGUI1.ApriDiv('class="w3-center"');
                    htp.br;
                    htp.prn('<span onclick="document.getElementById(''ElimOpera'||operaID||''').style.display=''none''" class="w3-button w3-xlarge w3-red w3-display-topright" title="Close Modal">X</span>');
                htp.print('<h1><b>Confermi?</b></h1>');
                modGUI1.ChiudiDiv;
                        modGUI1.ApriDiv('class="w3-section"');
                            htp.br;
                            SELECT titolo INTO var1 FROM OPERE WHERE idOpera=operaId;
                            htp.prn('stai per rimuovere: '||var1);
                            modGUI1.Collegamento('Conferma',
                            'RimozioneOpera?idSessione='||idSessione||'&operaID='||operaID,
                            'w3-button w3-block w3-green w3-section w3-padding');
                            htp.prn('<span onclick="document.getElementById(''ElimOpera'||operaID||''').style.display=''none''" class="w3-button w3-block w3-red w3-section w3-padding" title="Close Modal">Annulla</span>');
                        modGUI1.ChiudiDiv;
                    modGUI1.ChiudiForm;
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
end EliminazioneOpera;


--Procedura rimozione opera
procedure RimozioneOpera(
    idSessione NUMBER default 0,
    operaID NUMBER default 0
)is
esposizione NUMBER(5);
BEGIN
    SELECT COUNT(*) INTO esposizione FROM saleopere WHERE opera=operaID AND datauscita IS NULL;
    IF esposizione > 0
    THEN
        gruppo2.RedirectEsito(idSessione,'Eliminazione NON eseguita', 'Controlla i vincoli d''integrità.',null,null,null,'Torna alle opere','menuOpere',null);
    ELSE
        DELETE FROM OPERE WHERE idOpera = operaID;
        -- Ritorno al menu opere
        gruppo2.RedirectEsito(idSessione,'Eliminazione completata', null,null,null,null,'Torna alle opere','menuOpere',null);
    END IF;

end RimozioneOpera;

 
--procedura popup
procedure linguaELivello(
    idSessione NUMBER default 0,
    operaID NUMBER default 0
)is /*Form popup lingua e livello */
    begin
        modGUI1.ApriDiv('id="LinguaeLivelloOpera'||operaID||'" class="w3-modal"');
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
                modGUI1.ApriDiv('class="w3-center"');
                    htp.br;
                    htp.prn('<span onclick="document.getElementById(''LinguaeLivelloOpera'||operaID||''').style.display=''none''" class="w3-button w3-xlarge w3-red w3-display-topright" title="Close Modal">X</span>');
                htp.print('<h1>Seleziona la lingua</h1>');
                modGUI1.ChiudiDiv;
                    modGUI1.ApriForm('VisualizzaOpera','selezione lingue','w3-container');
                        HTP.FORMHIDDEN('idSessione',idSessione);
                        HTP.FORMHIDDEN('operaID',operaID);
                        modGUI1.ApriDiv('class="w3-section"');
                            htp.br; 
                            htp.print('<h5>');
                            modGUI1.InputRadioButton('Italiano ', 'lingue', 'Italian', 0, 0, 1);
                            modGUI1.InputRadioButton('English ', 'lingue', 'English', 0, 0, 1);
                            modGUI1.InputRadioButton('中国人 ', 'lingue', 'Chinese', 0, 0, 1);
                            htp.print('</h5>');
                            htp.br;
                            htp.print('<h1>Seleziona il livello</h1>');
                            MODGUI1.SELECTopen('livelli');
                                MODGUI1.SELECTOption('bambino','Bambino');
                                MODGUI1.SELECTOption('adulto','Adulto');
                                MODGUI1.SELECToption('esperto','Esperto');
                            MODGUI1.SELECTClose;
                            htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit">Seleziona</button>');
                        modGUI1.ChiudiDiv;
                    modGUI1.ChiudiForm;
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
end linguaELivello;

-- Procedura per l'inserimento di nuove Opere nella base di dati
PROCEDURE InserisciOpera(
    idSessione NUMBER DEFAULT NULL,
    titolo VARCHAR2 DEFAULT 'Sconosciuto',
    --titolo VARCHAR2 DEFAULT NULL,
    anno VARCHAR2 DEFAULT NULL,
    fineperiodo VARCHAR2 DEFAULT NULL,
    idmusei NUMBER DEFAULT NULL
) IS
placeholderTitolo VARCHAR2(255) := 'Titolo opera';
placeholderAnno VARCHAR2(255) := 'Anno realizzazione';
placeholderPeriodo VARCHAR2(255) := 'Periodo di realizzazione';
BEGIN
    modGUI1.ApriPagina('InserisciOpera',idSessione);--DA MODIFICARE campo PROVA
            if idSessione IS NULL then
            modGUI1.Header;
        else
            modGUI1.Header(idSessione);
        end if;
            htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            htp.prn('<h1 align="center">Inserimento Opera</h1>');--DA MODIFICARE
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
                modGUI1.ApriDiv('class="w3-section"');
                modGUI1.Collegamento('X','menuOpere?idSessione='||idSessione||'',' w3-btn w3-large w3-red w3-display-topright'); --Bottone per tornare indietro, cambiare COLLEGAMENTOPROVA
                --INIZIO SEZIONE DA MODIFICARE
                    modGUI1.ApriForm('ConfermaDatiOpera',NULL,'w3-container');
                        htp.FORMHIDDEN('idSessione',idSessione);
                        modGUI1.Label('Titolo*');
                        modGUI1.Inputtext('titolo', placeholderTitolo, 1, titolo);
                        htp.br;
                        modGUI1.Label('Anno*');
                        modGUI1.Inputtext('anno', placeholderAnno, 1, anno);
                        htp.br;
                        modGUI1.Label('Fine periodo');
                        modGUI1.Inputtext('fineperiodo', placeholderPeriodo, 0, fineperiodo);
                        htp.br;
                        modGUI1.Label('Museo*:');
                        MODGUI1.SELECTOpen('idmusei');
                        for museo in (SELECT idMuseo,nome FROM Musei)
                        loop
                        MODGUI1.SELECTOption(museo.idMuseo,museo.nome);
                        end loop;
                        MODGUI1.SELECTClose;
                        htp.br;
                        modGUI1.InputSubmit('Aggiungi');
                    modGUI1.ChiudiForm;
                --FINE SEZIONE DA MODIFICARE
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
END;


PROCEDURE ConfermaDatiOpera(
    idSessione NUMBER DEFAULT 0,
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
        modGUI1.ApriPagina('Conferma',idSessione);
        if idSessione IS NULL then
            modGUI1.Header;
        else
            modGUI1.Header(idSessione);
        end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
        htp.prn('<h1 align="center">CONFERMA DATI</h1>');--DA MODIFICARE
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px" ');
            modGUI1.ApriDiv('class="w3-section"');

            --INIZIO RIEPILOGO
                htp.br;
                modGUI1.Label('Titolo:');
                HTP.PRINT(titolo);--parametro passato
                htp.br;
                modGUI1.Label('Anno:');
                HTP.PRINT(anno);--parametro passato
                htp.br;
                modGUI1.Label('Periodo:');
                HTP.PRINT(fineperiodo);--parametro passato
                htp.br;
                modGUI1.Label('Nome museo:');
                SELECT nome into var1 FROM Musei WHERE idMuseo=idMusei;
                 HTP.PRINT(var1);
            --FINE RIEPILOGO
            modGUI1.ChiudiDiv;
            MODGUI1.ApriForm('InserisciDatiOpera');
            HTP.FORMHIDDEN('idSessione', idSessione);
            HTP.FORMHIDDEN('titolo', titolo);
            HTP.FORMHIDDEN('anno', anno);
            HTP.FORMHIDDEN('fineperiodo', fineperiodo);
            HTP.FORMHIDDEN('idmusei', idmusei);
            MODGUI1.InputSubmit('Conferma');
            MODGUI1.ChiudiForm;
            MODGUI1.ApriForm('InserisciOpera');
            HTP.FORMHIDDEN('idSessione', idSessione);
            HTP.FORMHIDDEN('titolo', titolo);
            HTP.FORMHIDDEN('anno', anno);
            HTP.FORMHIDDEN('fineperiodo', fineperiodo);
            HTP.FORMHIDDEN('idmusei', idmusei);
            MODGUI1.InputSubmit('Annulla');
            MODGUI1.ChiudiForm;
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
    END IF;
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line('Error: '||sqlerrm);
END;


PROCEDURE InserisciDatiOpera(
    idSessione NUMBER DEFAULT 0,
    titolo VARCHAR2 DEFAULT 'Sconosciuto',
    anno NUMBER DEFAULT NULL,
    fineperiodo NUMBER DEFAULT NULL,
    idmusei NUMBER DEFAULT NULL
)IS
    BEGIN
        INSERT INTO Opere VALUES
            (IdOperaSeq.NEXTVAL,titolo,anno,fineperiodo,idmusei,1,0);
        IF SQL%FOUND
        THEN
        -- faccio il commit dello statement precedente
        commit;
        gruppo2.RedirectEsito(idSessione,'Inserimento andato a buon fine', null,'Inserisci una nuova opera','inserisciOpera',null,'Torna alle opere','menuOpere',null);
		-- Ritorno al menu opere
        END IF;
        EXCEPTION WHEN OTHERS THEN
        gruppo2.RedirectEsito(idSessione,'Inserimento non riuscito', null,'Riprova','inserisciOpera',null,'Torna alle opere','menuOpere',null);
		
END InserisciDatiOpera;


PROCEDURE ModificaOpera(
    idSessione NUMBER DEFAULT 0,
    operaID NUMBER DEFAULT 0,
    titoloOpera VARCHAR2 DEFAULT 'Sconosciuto'
) IS
var NUMBER DEFAULT 0;
nomeMuseo VARCHAR2(30) DEFAULT NULL;
age NUMBER DEFAULT 0;
periodo NUMBER DEFAULT 0;
BEGIN
    modGUI1.ApriPagina('ModificaOpera',idSessione);
            if idSessione IS NULL then
            modGUI1.Header;
        else
            modGUI1.Header(idSessione);
        end if;
            htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            htp.prn('<h1 align="center">Modifica Opera</h1>');
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
                modGUI1.ApriDiv('class="w3-section"');
                modGUI1.Collegamento('X','menuOpere?idSessione='||idSessione||'',' w3-btn w3-large w3-red w3-display-topright'); --Bottone per tornare indietro, cambiare COLLEGAMENTOPROVA
                --INIZIO SEZIONE DA MODIFICARE
                    modGUI1.ApriForm('ConfermaUpdateOpera',NULL,'w3-container');
                        htp.FORMHIDDEN('idSessione',idSessione);
                        htp.FORMHIDDEN('operaID', operaID);
                        modGUI1.Label('Titolo*');
                        modGUI1.Inputtext('titolo', titoloOpera,1, titoloOpera);
                        htp.br;
                        SELECT anno,fineperiodo INTO age,periodo FROM OPERE WHERE idOpera=operaId;
                        modGUI1.Label('Anno*');
                        modGUI1.Inputtext('anno', 'Anno realizzazione',1,age);
                        htp.br;
                        modGUI1.Label('Fine periodo');
                        modGUI1.Inputtext('fineperiodo', 'Periodo di realizzazione',0,periodo);
                        htp.br;
                        modGUI1.Label('Museo*:');
                        SELECT MUSEO INTO var FROM OPERE WHERE idOpera = operaID;
                        SELECT NOME INTO nomeMuseo FROM MUSEI WHERE IDMUSEO = var;
                        MODGUI1.SELECTOpen('idmusei');
                        MODGUI1.SELECTOption(var, nomeMuseo, 1);
                        for museo in (SELECT idMuseo,nome FROM Musei)
                        loop
                        MODGUI1.SELECTOption(museo.idMuseo, museo.nome);
                        end loop;
                        MODGUI1.SELECTClose;
                        htp.br;
                        modGUI1.Collegamento('Aggiungi Autore',
                                    'AggiungiAutore?idSessione='||idSessione||'&operaID='||operaID,
                                    'w3-yellow w3-margin w3-button w3-small w3-round-xxlarge');
                        modGUI1.Collegamento('Rimuovi Autore',
                                    'RimuoviAutore?idSessione='||idSessione||'&operaID='||operaID,
                                    'w3-red w3-margin w3-button w3-small w3-round-xxlarge');
                        modGUI1.InputSubmit('Modifica');
                    modGUI1.ChiudiForm;
                --FINE SEZIONE DA MODIFICARE
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
END;

PROCEDURE ConfermaUpdateOpera(
    idSessione NUMBER DEFAULT 0,
    operaID NUMBER DEFAULT 0,
    titolo VARCHAR2 DEFAULT 'Sconosciuto',
    anno VARCHAR2 DEFAULT NULL,
    fineperiodo VARCHAR2 DEFAULT NULL,
    idmusei NUMBER DEFAULT 0
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
        modGUI1.ApriPagina('Conferma',idSessione);
        if idSessione IS NULL then
            modGUI1.Header;
        else
            modGUI1.Header(idSessione);
        end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
        htp.prn('<h1 align="center">CONFERMA DATI</h1>');--DA MODIFICARE
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px" ');
            modGUI1.ApriDiv('class="w3-section"');

            --INIZIO RIEPILOGO
                htp.br;
                modGUI1.Label('Titolo:');
                HTP.PRINT(titolo);--parametro passato
                htp.br;
                modGUI1.Label('Anno:');
                HTP.PRINT(anno);--parametro passato
                htp.br;
                modGUI1.Label('Periodo:');
                HTP.PRINT(fineperiodo);--parametro passato
                htp.br;
                modGUI1.Label('Nome museo:');
                SELECT nome into var1 FROM Musei WHERE idMuseo=idMusei;
                 HTP.PRINT(var1);
            --FINE RIEPILOGO
            modGUI1.ChiudiDiv;
            MODGUI1.ApriForm('UpdateOpera');
            HTP.FORMHIDDEN('idSessione', idSessione);
            htp.FORMHIDDEN('operaID', operaID);
            HTP.FORMHIDDEN('newTitolo', titolo);
            HTP.FORMHIDDEN('newAnno', anno);
            HTP.FORMHIDDEN('newFineperiodo', fineperiodo);
            HTP.FORMHIDDEN('newIDmusei', idmusei);
            MODGUI1.InputSubmit('Conferma');
            MODGUI1.ChiudiForm;
            MODGUI1.ApriForm('ModificaOpera');
            HTP.FORMHIDDEN('idSessione', idSessione);
            HTP.FORMHIDDEN('operaID', operaID);
            HTP.FORMHIDDEN('titoloOpera', titolo);
            MODGUI1.InputSubmit('Annulla');
            MODGUI1.ChiudiForm;
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
    END IF;
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line('Error: '||sqlerrm);
END;

PROCEDURE UpdateOpera(
	idSessione NUMBER DEFAULT 0,
	operaID NUMBER DEFAULT 0,
	newTitolo VARCHAR2 DEFAULT 'Sconosciuto',
	newAnno VARCHAR2 DEFAULT 'Sconosciuto',
	newFineperiodo NUMBER DEFAULT 0,
	newIDmusei NUMBER DEFAULT 0
) IS

BEGIN
    IF newFineperiodo>newAnno THEN
	UPDATE Opere SET
		titolo=newTitolo,
		anno=newAnno,
		fineperiodo=newFineperiodo,
		Museo=newIDmusei
	WHERE IdOpera=operaID;
    gruppo2.RedirectEsito(idSessione,'Update eseguito correttamente', null,null,null,null,'Torna alle opere','menuOpere',null);
    ELSE
    --EXCEPTION WHEN OTHERS THEN
    gruppo2.RedirectEsito(idSessione, 'Update fallito',
                'Errore: parametri non ammessi',
                'Torna all''update',
                'ModificaOpera', 
                '//operaID='||operaID||'//titoloOpera='||newTitolo,
                'Torna al menù','menuOpere');
    end if;
END;



procedure VisualizzaOpera (
    idSessione NUMBER default 0,
    operaID NUMBER default 0,
    lingue VARCHAR2 default 'sconosciuto',
    livelli VARCHAR2 DEFAULT 'Sconosciuto'
) is

var1 VARCHAR2 (40);
testo1 VARCHAR2 (100);
num NUMBER(10);
num1 NUMBER(10);
num2 NUMBER(10);
num3 NUMBER(10);
 
nomee VARCHAR2(50) DEFAULT 'sconosciuto';
cognomee VARCHAR2(50) DEFAULT 'sconosciuto';
CURSOR Cur IS SELECT * FROM autoriopere WHERE idopera = operaID;

varSala NUMBER(5) DEFAULT 0;
varMuseo NUMBER(5) DEFAULT 0;
varTipoSala VARCHAR2(100) DEFAULT 'Sconosciuto';
varNomeStanza VARCHAR2(100) DEFAULT 'Sconosciuto';
varNomeMuseo VARCHAR2(100) DEFAULT 'Sconosciuto';

BEGIN
    htp.prn('<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> ');
    if idSessione IS NULL then
        modGUI1.Header;
    else
        modGUI1.Header(idSessione);
    end if;
    htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
    modGUI1.ApriDiv('class="w3-center"');
    SELECT Titolo into var1 FROM OPERE WHERE idOpera=operaID;
    htp.prn('<h1><b>'||var1||'</b></h1>'); --TITOLO

    if hasRole(IdSessione, 'DBA') or hasRole(IdSessione, 'GO') then
    modGUI1.Collegamento('Inserisci','InserisciDescrizione?idSessione='||idSessione||'&language='||lingue||'&d_level='||livelli||'&operaID='||OperaID,'w3-btn w3-round-xxlarge w3-black');
    htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
    end if;

    if(lingue='Italian')then
    htp.prn('<button onclick="document.getElementById(''id104'').style.display=''block''" class="w3-btn w3-round-xxlarge w3-black">più info</button>');
    end if;
    if(lingue='English')then
    htp.prn('<button onclick="document.getElementById(''id104'').style.display=''block''" class="w3-btn w3-round-xxlarge w3-black">more info</button>');
    end if;
    if(lingue='Chinese')then
    htp.prn('<button onclick="document.getElementById(''id104'').style.display=''block''" class="w3-btn w3-round-xxlarge w3-black">更多信息</button>');
    end if;
modGUI1.ChiudiDiv;
gruppo2.spostamentiOpera(idSessione,operaID);
htp.br;
modGUI1.ApriDiv('class="w3-container" style="width:100%"');
if(lingue='Italian')
    then
    htp.prn('<h2><b>Livello: </b>'||livelli||'</h2>');
    end if;
    if(lingue='English')
    then
    htp.prn('<h2><b>Level: </b>'||livelli||'</h2>');
    end if;
    if(lingue='Chinese')
    then
    htp.prn('<h2><b>等级: </b>'||livelli||'</h2>');
    end if;
FOR des IN (
        SELECT * FROM Descrizioni 
        WHERE operaID=Opera AND lingue=lingua AND livello=livelli
)
LOOP
    modGUI1.ApriDiv('class="w3-row w3-container w3-border w3-round-small w3-padding-large w3-hover-light-grey" style="width:100%"');
        modGUI1.ApriDiv('class="w3-container w3-cell"');
        htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:500px; height:300px;">');
        modGUI1.ChiudiDiv;
        modGUI1.ApriDiv('class="w3-container w3-cell w3-border-right w3-cell-middle" style="width:1120px; height:300px"');
            htp.prn('<h5><b>'||var1||'</b></h5>');
            htp.prn('<p>'||SUBSTR(des.testo,0,100)||'</p>');
            htp.br;

            SELECT COUNT(*) INTO num FROM saleopere WHERE opera=operaID AND datauscita IS NULL;
            IF num = 0 THEN
            varNomeMuseo := 'NonEsposta';
            ELSE
            SELECT sala INTO varSala FROM saleopere WHERE opera=operaID AND datauscita IS NULL;

            SELECT museo, nome INTO varMuseo, varNomeStanza FROM stanze WHERE idstanza = varSala;

            SELECT TipoSala into varTipoSala FROM sale WHERE idstanza=varSala;

                IF(varTipoSala=1) THEN
                    varTipoSala := 'mostra';
                ELSE
                    varTipoSala :='museale';
                END IF;

            SELECT nome INTO varNomeMuseo FROM musei WHERE idmuseo=varMuseo;

            END IF;

            IF(varNomeMuseo='NonEsposta')
            THEN
                if(lingue='Italian')
                then
                htp.prn('<h5><b>Esposta: </b>❌</h5>');
                if hasRole(IdSessione, 'DBA') or hasRole(IdSessione, 'GO') then
                modGUI1.collegamento('sposta',
                    'SpostaOpera?idSessione='||idSessione||'&operaID='||operaID||'&salaID='||varSala,
                    'w3-green w3-margin w3-button w3-small w3-round-xxlarge');
                end if;
                htp.br;
                htp.prn('<b>Autore: </b>');
                
                    FOR auth in Cur
                    LOOP
                    SELECT autori.NOME, autori.cognome INTO nomee, cognomee FROM autori WHERE idautore = auth.idautore;
                    MODGUI1.Collegamento(nomee||' '||Cognomee,
                        'ModificaAutore?idSessione='||idSessione||'&authorID='||auth.IdAutore||'&operazione=0'
                        ||'&caller=visualizzaOpera&callerParams=//operaID='||operaID||'//lingue='||lingue||'//livelli='||livelli);
                    htp.prn(', ');
                    
                    END LOOP;
                    
                    if hasRole(IdSessione, 'DBA') or hasRole(IdSessione, 'GO') then
                    modGUI1.Collegamento('Aggiungi Autore',
                        'AggiungiAutore?idSessione='||idSessione||'&operaID='||operaID,
                        'w3-yellow w3-margin w3-button w3-small w3-round-xxlarge');
                    modGUI1.Collegamento('Rimuovi Autore',
                        'RimuoviAutore?idSessione='||idSessione||'&operaID='||operaID,
                        'w3-red w3-margin w3-button w3-small w3-round-xxlarge');
                    end if;
                end if;

                if(lingue='English')
                then
                htp.prn('<h5><b>Exposed: </b>❌</h5>');
                if hasRole(IdSessione, 'DBA') or hasRole(IdSessione, 'GO') then
                modGUI1.collegamento('sposta',
                    'SpostaOpera?idSessione='||idSessione||'&operaID='||operaID||'&salaID='||varSala,
                    'w3-green w3-margin w3-button w3-small w3-round-xxlarge');
                end if;
                htp.br;
                htp.prn('<b>Author: </b>');
                
                    FOR auth in Cur
                    LOOP
                    SELECT autori.NOME, autori.cognome INTO nomee, cognomee FROM autori WHERE idautore = auth.idautore;
                    MODGUI1.Collegamento(nomee||' '||Cognomee,
                        'ModificaAutore?idSessione='||idSessione||'&authorID='||auth.IdAutore||'&operazione=0'
                        ||'&caller=visualizzaOpera&callerParams=//operaID='||operaID||'//lingue='||lingue||'//livelli='||livelli);
                    htp.prn(', ');
                    
                    END LOOP;

                    if hasRole(IdSessione, 'DBA') or hasRole(IdSessione, 'GO') then
                    modGUI1.Collegamento('Aggiungi Autore',
                        'AggiungiAutore?idSessione='||idSessione||'&operaID='||operaID,
                        'w3-yellow w3-margin w3-button w3-small w3-round-xxlarge');
                    modGUI1.Collegamento('Rimuovi Autore',
                        'RimuoviAutore?idSessione='||idSessione||'&operaID='||operaID,
                        'w3-red w3-margin w3-button w3-small w3-round-xxlarge');
                    end if;
                end if;

                if(lingue='Chinese')
                then
                htp.prn('<h5><b>裸露: </b>❌</h5>');
                if hasRole(IdSessione, 'DBA') or hasRole(IdSessione, 'GO') then
                modGUI1.collegamento('sposta',
                    'SpostaOpera?idSessione='||idSessione||'&operaID='||operaID||'&salaID='||varSala,
                    'w3-green w3-margin w3-button w3-small w3-round-xxlarge');
                end if;
                htp.br;
                htp.prn('<b>作者: </b>');
                
                    FOR auth in Cur
                    LOOP
                    SELECT autori.NOME, autori.cognome INTO nomee, cognomee FROM autori WHERE idautore = auth.idautore;
                    MODGUI1.Collegamento(nomee||' '||Cognomee,
                        'ModificaAutore?idSessione='||idSessione||'&authorID='||auth.IdAutore||'&operazione=0'
                        ||'&caller=visualizzaOpera&callerParams=//operaID='||operaID||'//lingue='||lingue||'//livelli='||livelli);
                    htp.prn(', ');
                    END LOOP;

                    if hasRole(IdSessione, 'DBA') or hasRole(IdSessione, 'GO') then
                    modGUI1.Collegamento('Aggiungi Autore',
                        'AggiungiAutore?idSessione='||idSessione||'&operaID='||operaID,
                        'w3-yellow w3-margin w3-button w3-small w3-round-xxlarge');
                    modGUI1.Collegamento('Rimuovi Autore',
                        'RimuoviAutore?idSessione='||idSessione||'&operaID='||operaID,
                        'w3-red w3-margin w3-button w3-small w3-round-xxlarge');
                    end if;

                end if;

            ELSE

                if(lingue='Italian')
                then
                htp.prn('<h5><b>Esposta: </b>✅</h5>');
                htp.br;
                htp.prn('<b>Museo: </b>');
                MODGUI1.Collegamento(''||varNomeMuseo||'','visualizzaMuseo?idSessione='||idSessione||'&idMuseo='||varMuseo);
                htp.br;
                htp.prn('<b>Sala: </b>'||varNomeStanza||'<b> tipo di sala: </b>'||varTipoSala); 
                if hasRole(IdSessione, 'DBA') or hasRole(IdSessione, 'GO') then
                modGUI1.collegamento('sposta',
                    'SpostaOpera?idSessione='||idSessione||'&operaID='||operaID||'&salaID='||varSala,
                    'w3-green w3-margin w3-button w3-small w3-round-xxlarge');
                end if;
                htp.br;
                htp.prn('<b>Autore: </b>');
                
                    FOR auth in Cur
                    LOOP
                    SELECT autori.NOME, autori.cognome INTO nomee, cognomee FROM autori WHERE idautore = auth.idautore;
                    MODGUI1.Collegamento(nomee||' '||Cognomee,
                        'ModificaAutore?idSessione='||idSessione||'&authorID='||auth.IdAutore||'&operazione=0'
                        ||'&caller=visualizzaOpera&callerParams=//operaID='||operaID||'//lingue='||lingue||'//livelli='||livelli);
                    htp.prn(', ');
                    END LOOP;
                    
                    if hasRole(IdSessione, 'DBA') or hasRole(IdSessione, 'GO') then
                    modGUI1.Collegamento('Aggiungi Autore',
                        'AggiungiAutore?idSessione='||idSessione||'&operaID='||operaID,
                        'w3-yellow w3-margin w3-button w3-small w3-round-xxlarge');
                    modGUI1.Collegamento('Rimuovi Autore',
                        'RimuoviAutore?idSessione='||idSessione||'&operaID='||operaID,
                        'w3-red w3-margin w3-button w3-small w3-round-xxlarge');
                    end if;

                end if;

                if(lingue='English')
                then
                htp.prn('<h5><b>Exposed: </b>✅</h5>');
                htp.br;
                htp.prn('<b>Museum: </b>'); 
                MODGUI1.Collegamento(''||varNomeMuseo||'','visualizzaMuseo?idSessione='||idSessione||'&idMuseo='||varMuseo);
                htp.br;
                htp.prn('<b>Room: </b>'||varNomeStanza||'<b> type of room: </b>'||varTipoSala);--COLLEGAMENTO NOME STANZA
                if hasRole(IdSessione, 'DBA') or hasRole(IdSessione, 'GO') then
                modGUI1.collegamento('sposta',
                    'SpostaOpera?idSessione='||idSessione||'&operaID='||operaID||'&salaID='||varSala,
                    'w3-green w3-margin w3-button w3-small w3-round-xxlarge');
                end if;
                htp.br;
                htp.prn('<b>Author: </b>');
                
                    FOR auth in Cur
                    LOOP
                    SELECT autori.NOME, autori.cognome INTO nomee, cognomee FROM autori WHERE idautore = auth.idautore;
                    MODGUI1.Collegamento(nomee||' '||Cognomee,
                        'ModificaAutore?idSessione='||idSessione||'&authorID='||auth.IdAutore||'&operazione=0'
                        ||'&caller=visualizzaOpera&callerParams=//operaID='||operaID||'//lingue='||lingue||'//livelli='||livelli);
                    htp.prn(', ');
                    
                    END LOOP;
                    
                    if hasRole(IdSessione, 'DBA') or hasRole(IdSessione, 'GO') then
                    modGUI1.Collegamento('Aggiungi Autore',
                        'AggiungiAutore?idSessione='||idSessione||'&operaID='||operaID,
                        'w3-yellow w3-margin w3-button w3-small w3-round-xxlarge');
                    modGUI1.Collegamento('Rimuovi Autore',
                        'RimuoviAutore?idSessione='||idSessione||'&operaID='||operaID,
                        'w3-red w3-margin w3-button w3-small w3-round-xxlarge');
                    end if;

                end if;

                if(lingue='Chinese')
                then
                htp.prn('<h5><b>裸露: </b>✅</h5>');
                htp.br;
                htp.prn('<b>博物馆: </b>');
                MODGUI1.Collegamento(''||varNomeMuseo||'','visualizzaMuseo?idSessione='||idSessione||'&idMuseo='||varMuseo);
                htp.br;
                htp.prn('<b>房间: </b>'||varNomeStanza||'<b> 大厅类型: </b>'||varTipoSala); --COLLEGAMENTO NOME STANZA
                if hasRole(IdSessione, 'DBA') or hasRole(IdSessione, 'GO') then
                modGUI1.collegamento('sposta',
                    'SpostaOpera?idSessione='||idSessione||'&operaID='||operaID||'&salaID='||varSala,
                    'w3-green w3-margin w3-button w3-small w3-round-xxlarge');
                end if;
                htp.br;
                htp.prn('<b>作者: </b>');
                
                    FOR auth in Cur
                    LOOP
                    SELECT autori.NOME, autori.cognome INTO nomee, cognomee FROM autori WHERE idautore = auth.idautore;
                    MODGUI1.Collegamento(nomee||' '||Cognomee,
                        'ModificaAutore?idSessione='||idSessione||'&authorID='||auth.IdAutore||'&operazione=0'
                        ||'&caller=visualizzaOpera&callerParams=//operaID='||operaID||'//lingue='||lingue||'//livelli='||livelli);
                    htp.prn(', ');
                    END LOOP;

                    if hasRole(IdSessione, 'DBA') or hasRole(IdSessione, 'GO') then
                    modGUI1.Collegamento('Aggiungi Autore',
                        'AggiungiAutore?idSessione='||idSessione||'&operaID='||operaID,
                        'w3-yellow w3-margin w3-button w3-small w3-round-xxlarge');
                    modGUI1.Collegamento('Rimuovi Autore',
                        'RimuoviAutore?idSessione='||idSessione||'&operaID='||operaID,
                        'w3-red w3-margin w3-button w3-small w3-round-xxlarge');
                    end if;
                end if;


            END IF;

            modGUI1.ChiudiDiv;
            modGUI1.ApriDiv('class="w3-container w3-cell w3-cell-middle"');
            if hasRole(IdSessione, 'DBA') or hasRole(IdSessione, 'GO')
            then
                modGUI1.collegamento('Modifica',
                    'ModificaDescrizione?idSessione='||idSessione||'&idDescrizione='||des.idDesc,
                    'w3-margin w3-button w3-green');
                htp.br;
                htp.prn('<button onclick="document.getElementById(''ElimDescrizione'||des.idDesc||''').style.display=''block''" class="w3-margin w3-button w3-red w3-hover-white">Elimina</button>');
                gruppo2.EliminazioneDescrizione(idSessione,des.idDesc);
            end if;
        modGUI1.ChiudiDiv;
    modGUI1.chiudiDiv;
    htp.br;
    htp.br;
END LOOP;
        --FINE LOOP VISUALIZZAZIONE

end VisualizzaOpera;


PROCEDURE SpostaOpera(
        idSessione NUMBER DEFAULT 0,
        operaID NUMBER DEFAULT 0,
        salaID NUMBER DEFAULT 0
    ) IS 
    nomeStanza VARCHAR2(50) DEFAULT 'sconosciuto';
    BEGIN
        modGUI1.ApriPagina('SpostaOpera',idSessione);
                if idSessione IS NULL then
                modGUI1.Header;
            else
                modGUI1.Header(idSessione);
            end if;
                htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
                htp.prn('<h1 align="center">Sposta Opera</h1>');
                modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
                    modGUI1.ApriDiv('class="w3-section"');
                    modGUI1.Collegamento('X','menuOpere?idSessione='||idSessione||'',' w3-btn w3-large w3-red w3-display-topright');
                    --INIZIO SEZIONE DA MODIFICARE
                        modGUI1.ApriForm('SpostamentoOpera','Spostamento opera','w3-container');
                            htp.FORMHIDDEN('idSessione',idSessione);
                            htp.FORMHIDDEN('operaID',operaID);
                            htp.br;
                            
                            htp.prn('<b>Status opera: </b>');
                        
                            modGUI1.InputRadioButton('Esponibile ', 'esposizione',1, 0, 0, 1);
                            modGUI1.InputRadioButton('Non esponibile ', 'esposizione',0, 0, 0, 1);
                            
                            htp.br;
                            htp.br;
                            htp.br;
                            htp.prn('<b>Sala attuale: </b>');
                            if(salaID!=0) then 
                                SELECT Nome into nomeStanza FROM STANZE 
                                WHERE  salaID=idStanza;
                                htp.print(nomeStanza);
                            ELSE
                                htp.print('opera non esposta');
                            END IF;
                            htp.br;
                            htp.br;
                            modGUI1.Label('Nuova sala:');
                            MODGUI1.SELECTOpen('NuovaSalaID','selezioneEsposizione');
                            for var in (SELECT STANZE.IDSTANZA,nome FROM STANZE,sale
                                        WHERE STANZE.idStanza=SALE.idStanza)
                            loop
                                MODGUI1.SELECTOption(var.idStanza,var.Nome);
                            end loop;
                            MODGUI1.SELECTClose;
                            htp.br;
                            modGUI1.InputSubmit('Aggiungi');
                        modGUI1.ChiudiForm;
                    --FINE SEZIONE DA MODIFICARE
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
END;


procedure SpostamentoOpera(
    idSessione NUMBER DEFAULT 0,
    operaID NUMBER DEFAULT 0,
    Esposizione NUMBER DEFAULT 0,
    NuovaSalaID NUMBER DEFAULT 0
)IS
    BEGIN
    if (Esposizione=1)then
        UPDATE SALEOPERE SET datauscita = TO_DATE(TO_CHAR(SYSDATE, 'dd/mm/yyyy'), 'dd/mm/yyyy') WHERE datauscita IS NULL AND opera = operaID; 
        INSERT INTO SALEOPERE(IdMovimento, Sala, Opera, DataArrivo, DataUscita) VALUES (IdMovimentoSeq.nextVal, NuovaSalaID, operaID, TO_DATE(TO_CHAR(SYSDATE, 'dd/mm/yyyy'), 'dd/mm/yyyy'), null);
        UPDATE OPERE SET Esponibile = 1 WHERE idopera = operaID;
        gruppo2.RedirectEsito(idSessione,'Spostamento eseguito', null,null,null,null,'Torna alle opere','menuOpere',null);  
    else
        UPDATE OPERE SET Esponibile = 0 WHERE idopera = operaID;
        UPDATE SALEOPERE SET datauscita = TO_DATE(TO_CHAR(SYSDATE, 'dd/mm/yyyy'), 'dd/mm/yyyy') WHERE datauscita IS NULL AND opera = operaID; 
        gruppo2.RedirectEsito(idSessione,'Opera non più esposta',null,null,null,null,'Torna alle opere','menuOpere',null);  
    END IF;
END;

procedure AggiungiAutore(
    idSessione NUMBER DEFAULT 0,
    operaID NUMBER DEFAULT 0,
    lingue VARCHAR2 DEFAULT null
)IS
nomecompleto VARCHAR2(50);
    BEGIN
    modGUI1.ApriPagina('Aggiungi autore', idSessione);
    if idSessione IS NULL then
        modGUI1.Header;
    else
        modGUI1.Header(idSessione);
    end if;
    htp.br;htp.br;htp.br;htp.br;
    htp.prn('<h1 align="center">Seleziona l''autore da aggiungere</h1>');
    modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
        modGUI1.ApriDiv('class="w3-section"');
            -- Link di ritorno al menuAutori
            modGUI1.Collegamento('X',
                'menuOpere?idSessione='||idSessione,
                'w3-btn w3-large w3-red w3-display-topright');
            -- Form per mandare dati alla procedura di conferma
            htp.br;
            MODGUI1.apriDIV('class=w3-center');
                modGUI1.ApriForm('AggiuntaAutore');
                htp.FORMHIDDEN('idSessione',idSessione);
                htp.FORMHIDDEN('operaID',operaID);
                MODGUI1.SELECTOPEN('autoreID', 'autoreID');
                FOR aut IN (SELECT IdAutore,Nome,COGNOME FROM AUTORI)
                LOOP
                    nomecompleto := aut.Nome||' '||aut.cognome;
                    modGUI1.SELECTOPTION(aut.IdAutore, nomecompleto, 0);
                END LOOP;
                MODGUI1.SELECTClose;
                htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit">Aggiungi</button>');
                modGUI1.ChiudiForm;
            MODGUI1.chiudiDiv;
        MODGUI1.chiudiDiv;
    modGUI1.ChiudiDiv;
END AggiungiAutore;




procedure AggiuntaAutore(
    idSessione NUMBER DEFAULT 0,
    operaID NUMBER DEFAULT 0,
    autoreID NUMBER DEFAULT 0,
    lingue VARCHAR2 default NULL
)IS
controllo NUMBER(3);
    BEGIN
        SELECT count(*) into controllo 
            FROM AUTORIOPERE WHERE AUTORIOPERE.IdOpera=operaID 
            and AUTORIOPERE.IdAutore=autoreID;
        IF controllo<1 THEN
            INSERT INTO AUTORIOPERE VALUES
                (autoreID,operaID);
            IF SQL%FOUND THEN
            RedirectEsito(idSessione, 'Inserimento riuscito',
                'autore aggiunto all''opera',
                null,null,null,
                'Torna al menù','menuOpere');
            ELSE
                if lingue is not null THEN
                    RedirectEsito(idSessione, 'Inserimento fallito',
                    'Errore: Autore già presente',
                    'Torna all''opera','VisualizzaOpera', 
                    '//operaID='||operaID||'//lingue='||lingue,'Torna al menù','menuOpere');
                    ELSE
                    RedirectEsito(idSessione, 'Inserimento fallito',
                    'Errore: Autore già presente',
                    null,null, null,'Torna al menù','menuOpere');
                END IF;
            END IF;
        ELSE
            if lingue is not null THEN
                RedirectEsito(idSessione, 'Inserimento fallito',
                'Errore: Autore già presente',
                'Torna all''opera','VisualizzaOpera', 
                '//operaID='||operaID||'//lingue='||lingue,'Torna al menù','menuOpere');
                ELSE
                RedirectEsito(idSessione, 'Inserimento fallito',
                'Errore: Autore già presente',
                null,null, null,'Torna al menù','menuOpere');
            END IF;
        END IF;
END AggiuntaAutore;


procedure RimuoviAutore(
    idSessione NUMBER DEFAULT 0,
    operaID NUMBER DEFAULT 0,
    lingue VARCHAR2 DEFAULT null
)IS
nomecompleto VARCHAR2(50);
    BEGIN
    modGUI1.ApriPagina('Rimuovi Autore', idSessione);
    if idSessione IS NULL then
        modGUI1.Header;
    else
        modGUI1.Header(idSessione);
    end if;
    htp.br;htp.br;htp.br;htp.br;
    htp.prn('<h1 align="center">Seleziona l''autore da rimuovere</h1>');
    modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
        modGUI1.ApriDiv('class="w3-section"');
            -- Link di ritorno al menuAutori
            modGUI1.Collegamento('X',
                'menuOpere?idSessione='||idSessione,
                'w3-btn w3-large w3-red w3-display-topright');
            -- Form per mandare dati alla procedura di conferma
            htp.br;
            MODGUI1.apriDIV('class=w3-center');
                modGUI1.ApriForm('RimozioneAutore');
                htp.FORMHIDDEN('idSessione',idSessione);
                htp.FORMHIDDEN('operaID',operaID);
                MODGUI1.SELECTOPEN('autoreID', 'autoreID');
                FOR aut IN (SELECT AUTORIOPERE.IdAutore,Autori.Nome,Autori.COGNOME FROM AUTORI,AUTORIOPERE
                            WHERE idOpera=OperaID AND AUTORIOPERE.idAutore=AUTORI.idAutore)
                LOOP
                    nomecompleto := aut.Nome||' '||aut.cognome;
                    modGUI1.SELECTOPTION(aut.IdAutore, nomecompleto, 0);
                END LOOP;
                MODGUI1.SELECTClose;
                htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit">Rimuovi</button>');
                modGUI1.ChiudiForm;
            MODGUI1.chiudiDiv;
        MODGUI1.chiudiDiv;
    modGUI1.ChiudiDiv;
END RimuoviAutore;

procedure RimozioneAutore(
    idSessione NUMBER DEFAULT 0,
    operaID NUMBER DEFAULT 0,
    autoreID NUMBER DEFAULT 0
)IS
controllo NUMBER(3);
    BEGIN
    SELECT count(*) into controllo FROM AUTORIOPERE
    WHERE idOpera=OperaID;
    if controllo=1 THEN
                DELETE FROM AUTORIOPERE 
                WHERE AUTORIOPERE.IdOpera=operaID AND AUTORIOPERE.IdAutore=autoreID;
                IF SQL%FOUND THEN
                    RedirectEsito(idSessione, 'Rimozione riuscita',
                        'Autore Rimosso',
                        null,null,null,
                        'Torna al menù','menuOpere');
                ELSE
                    RedirectEsito(idSessione, 'Rimozione NON riuscita',
                        'Autore NON Rimosso',
                        null,null,null,
                        'Torna al menù','menuOpere');
                END IF;
    ELSE
            DELETE FROM AUTORIOPERE 
            WHERE AUTORIOPERE.IdOpera=operaID AND AUTORIOPERE.IdAutore=autoreID;
            IF SQL%FOUND THEN
                RedirectEsito(idSessione, 'Rimozione riuscita',
                    'Autore Rimosso',
                    'Torna alla rimozione','rimuoviAutore','rimuoviAutore//operaID='||operaID,
                    'Torna al menù','menuOpere');
            ELSE
                RedirectEsito(idSessione, 'Rimozione NON riuscita',
                    'Autore NON Rimosso',
                    'Torna alla rimozione','rimuoviAutore','rimuoviAutore//operaID='||operaID,
                    'Torna al menù','menuOpere');
            END IF;
    END IF;
END RimozioneAutore;



procedure SpostamentiOpera (
    idSessione NUMBER DEFAULT 0,
    operaID NUMBER DEFAULT 0
)is 
proprietario NUMBER(5) DEFAULT 0;
nomeMuseo VARCHAR2(50) DEFAULT 0;
ricevente NUMBER(5) DEFAULT 0;
var1 VARCHAR2(100) DEFAULT 'Sconosciuto';
k NUMBER default 1;
 
BEGIN
    SELECT museo INTO proprietario FROM opere WHERE idopera = operaID;
    DECLARE
        CURSOR cur is SELECT * FROM saleopere WHERE opera = operaID;
    BEGIN
        SELECT nome into var1 FROM MUSEI WHERE proprietario=idMuseo;
        modGUI1.ApriDiv('id="id104" class="w3-modal"');
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom"');
            modGUI1.ApriDiv;
                htp.br;
                    htp.prn('<h1 class="w3-center"><b>STORICO PRESTITI</b></h1>');
                htp.prn('<span onclick="document.getElementById(''id104'').style.display=''none''" class="w3-button w3-xlarge w3-red w3-display-topright" title="Close Modal">X</span>');
            modGUI1.ChiudiDiv;
            FOR sal in cur
            LOOP
                SELECT museo INTO ricevente FROM stanze WHERE idstanza = sal.sala;
                IF(ricevente <> proprietario) --controllo che lo spostamento non sia all'interno dello stesso museo
                    THEN
                        SELECT nome INTO nomeMuseo FROM musei WHERE idmuseo = ricevente;

                    htp.prn('<label><b>Prestito N.'||k||'</b></label>');
                    modGUI1.ApriDiv('class="w3-cell-row w3-border" style="witdh:100%"');
                        modGUI1.ApriDiv('class="w3-container w3-cell"');
                            htp.print('<b>DA:</b>'); --COLLEGAMENTO MUSEO
                            MODGUI1.Collegamento(''||var1||'','visualizzaMuseo?idSessione='||idSessione||'&idMuseo='||proprietario);
                            
                            htp.br;htp.br;
                            htp.print('<b>DAL: </b>'||sal.dataarrivo);
                        modGUI1.ChiudiDiv;
                        modGUI1.ApriDiv('class="w3-container w3-cell"');
                            htp.print('<b> A:</b>'); --COLLEGAMENTO MUSEO
                            MODGUI1.Collegamento(''||nomeMuseo||'','visualizzaMuseo?idSessione='||idSessione||'&idMuseo='||ricevente);
                           
                            htp.br;htp.br;
                            htp.print('<b> AL:</b>'||sal.datauscita);
                        modGUI1.ChiudiDiv;
                    modGUI1.ChiudiDiv;
                    htp.br;
                    k:=k+1;
                END IF;
            END LOOP;
        modGUI1.ChiudiDiv;
    modGUI1.ChiudiDiv;
    end;
end SpostamentiOpera;


procedure selezioneMuseo(
    idSessione NUMBER DEFAULT 0
)IS
    BEGIN
        modGUI1.ApriDiv('id="11" class="w3-modal"');
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
                modGUI1.ApriDiv('class="w3-center"');
                    htp.br;
                    htp.prn('<span onclick="document.getElementById(''11'').style.display=''none''" class="w3-button w3-xlarge w3-red w3-display-topright" title="Close Modal">X</span>');
                htp.print('<h1>Seleziona il museo</h1>');
                modGUI1.ChiudiDiv;
                    modGUI1.ApriForm('StatisticheOpere','seleziona museo','w3-container');
                        htp.FORMHIDDEN('idSessione',idSessione);
                        htp.print('<h4>');
                        htp.br;
                        htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                        modGUI1.InputRadioButton('TUTTI I MUSEI','museoID',0, 0, 0);
                        for mus IN (SELECT * FROM MUSEI)
                        LOOP
                            htp.br;
                            htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                            modGUI1.InputRadioButton(mus.Nome,'museoID',mus.idMuseo, 0, 0);
                        END LOOP;
                        htp.print('</h4>');
                            htp.br;
                            htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit">Seleziona</button>');
                        modGUI1.ChiudiDiv;
                    modGUI1.ChiudiForm;
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
END selezioneMuseo;


--Procedura home statistiche
Procedure StatisticheOpere(
    idSessione NUMBER DEFAULT 0,
    museoID NUMBER DEFAULT 0
)IS

avgYear INT DEFAULT 0;
k NUMBER DEFAULT 1;
var1 VARCHAR2(100) default'sconosciuto';
varOpera VARCHAR2(100) DEFAULT 'Sconosciuto';

p NUMBER default 0;
years NUMBER DEFAULT 0;
AnnoCorrente NUMBER:= TO_NUMBER(TO_CHAR(sysdate, 'YYYY'));

BEGIN   
    MODGUI1.ApriPagina('StatisticheOpere',idSessione);
        if idSessione IS NULL then
            modGUI1.Header;
        else
            modGUI1.Header(idSessione);
        end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
        modGUI1.ApriDiv('class="w3-center"');
            htp.prn('<h1><b>STATISTICHE DELLE OPERE</b></h1>'); --TITOLO
            IF(museoID=0)THEN
                    htp.prn('<h4><b>tutti i musei</b></h4>');
                    modGUI1.ChiudiDiv;
                    htp.br;
                    modGUI1.ApriDiv('class="w3-container" style="width:100%"');
                    k:=1;
                    htp.print('<h2><b>Opere più viste</b></h2>');
                    --INIZIO LOOP DELLA VISUALIZZAZIONE
                        FOR var in (SELECT * FROM   (SELECT opera,dataarrivo,datauscita FROM saleopere, stanze 
                                                    WHERE idstanza = saleopere.sala AND datauscita IS NOT NULL 
                                                    ORDER BY datauscita - dataarrivo DESC
                                    ) WHERE ROWNUM <= 3)
                        LOOP
                            SELECT opere.titolo INTO varOpera FROM opere WHERE idopera = var.opera;
                            modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                            gruppo2.coloreClassifica(k);
                                modGUI1.ApriDiv('class="w3-card-4"');
                                htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%">');
                                    modGUI1.ApriDiv('class="w3-container w3-center"');
                                    --INIZIO DESCRIZIONI
                                        htp.prn('<b>Titolo: </b>');
                                        htp.prn('<button onclick="document.getElementById(''LinguaeLivelloOpera'||var.Opera||''').style.display=''block''" class="w3-margin w3-btn w3-border">'|| varOpera ||'</button>');
                                        gruppo2.linguaELivello(idSessione,var.Opera);
                                        p:=var.datauscita-var.dataarrivo;
                                        htp.prn('<p><b>Esposta per </b>'||p||' giorni</p>');
                                    --FINE DESCRIZIONI
                                    modGUI1.ChiudiDiv;
                                modGUI1.ChiudiDiv;
                            modGUI1.ChiudiDiv;
                            k:=k+1;
                        END LOOP;
                    
                    htp.br;
                    htp.br;

                    k:=1;
                    --OPERE DA PIÙ TEMPO NON SPOSTATE
                    htp.print('<h2><b>Opere non spostate da più tempo: </b></h2>');
                    modGUI1.ApriDiv('class="w3-container" style="width:100%"');
                    --INIZIO LOOP DELLA VISUALIZZAZIONE
                        FOR var in (SELECT * FROM   (SELECT dataarrivo, opera, sala FROM saleopere, stanze 
                                                    WHERE saleopere.sala = stanze.idstanza AND datauscita IS NULL 
                                                    ORDER BY dataarrivo
                                                    ) 
                                    WHERE ROWNUM <= 3)         
                        LOOP
                            SELECT opere.titolo INTO varOpera FROM opere WHERE idopera = var.opera;
                            modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                                gruppo2.coloreClassifica(k);
                                modGUI1.ApriDiv('class="w3-card-4"');
                                htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%">');
                                        modGUI1.ApriDiv('class="w3-container w3-center" style="height:150px;"');
                                        --INIZIO DESCRIZIONI
                                            htp.prn('<b>Titolo: </b>');
                                            htp.prn('<button onclick="document.getElementById(''LinguaeLivelloOpera'||var.Opera||''').style.display=''block''" class="w3-margin w3-btn w3-border">'|| varOpera ||'</button>');
                                            gruppo2.linguaELivello(idSessione,var.Opera);
                                            htp.prn('<p><b>Esposta dal :</b>'||var.dataarrivo||'</p>');
                                        --FINE DESCRIZIONI
                                        modGUI1.ChiudiDiv;
                                modGUI1.ChiudiDiv;
                            modGUI1.ChiudiDiv;
                            k:=k+1;
                        END LOOP;
                    htp.br;
                    htp.br;

                    k:=1;
                    --OPERE PIÙ ANTICHE
                    SELECT AVG(anno) into avgYear FROM OPERE;

                    p:=annoCorrente-avgYear;
                    htp.print('<h2><b>Opere più antiche: </b></h2>');
                    htp.print('<h5><b>Età media opere:</b>'||p||' anni</h5>');
                    modGUI1.ApriDiv('class="w3-container" style="width:100%"');    
                    FOR var in  (SELECT * FROM (SELECT idOpera FROM OPERE
                                                    ORDER BY anno
                                    )WHERE ROWNUM <=3)
                    LOOP
                        SELECT opere.titolo,opere.anno INTO varOpera,years FROM opere WHERE idopera = var.idOpera;
                        modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                        gruppo2.coloreClassifica(k);
                            modGUI1.ApriDiv('class="w3-card-4"');
                            htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%">');
                                modGUI1.ApriDiv('class="w3-container w3-center"');
                                    --INIZIO DESCRIZIONI
                                    htp.prn('<b>Titolo: </b>');
                                    htp.prn('<button onclick="document.getElementById(''LinguaeLivelloOpera'||var.idOpera||''').style.display=''block''" class="w3-margin w3-btn w3-border">'|| varOpera ||'</button>');
                                    gruppo2.linguaELivello(idSessione,var.idOpera);
                                    htp.prn('<p><b>Anno realizzazione </b>'||years||' D.C</p>');
                                    p:=annoCorrente-years;
                                    htp.prn('<p><b>Anni </b>'||p||'</p>');
                                    --FINE DESCRIZIONI
                                modGUI1.ChiudiDiv;
                            modGUI1.ChiudiDiv;
                        modGUI1.ChiudiDiv;
                            k:=k+1;
                    END LOOP;
                    htp.br;
                    htp.br;

                    k:=1;

                    htp.print('<h2><b>Opere con più autori: </b></h2>');
                    modGUI1.ApriDiv('class="w3-container" style="width:100%"');    
                    FOR var in  (SELECT * FROM (SELECT Autoriopere.idOpera, count(*) AS numAutori FROM AUTORIOPERE, OPERE
                                        WHERE Autoriopere.idOpera=opere.idopera
                                        group by AUTORIOPERE.idOpera
                                        order by numAutori DESC
                        )WHERE ROWNUM <=3)
                    LOOP
                        SELECT opere.titolo INTO varOpera FROM opere WHERE idopera = var.idOpera;
                        modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                        gruppo2.coloreClassifica(k);
                            modGUI1.ApriDiv('class="w3-card-4"');
                            htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%">');
                                modGUI1.ApriDiv('class="w3-container w3-center"');
                                    --INIZIO DESCRIZIONI
                                    htp.prn('<b>Titolo: </b>');
                                    htp.prn('<button onclick="document.getElementById(''LinguaeLivelloOpera'||var.idOpera||''').style.display=''block''" class="w3-margin w3-btn w3-border">'|| varOpera ||'</button>');
                                    gruppo2.linguaELivello(idSessione,var.idOpera);
                                    htp.prn('<p><b>N. autori </b>'||var.numAutori||'</p>');
                                    --FINE DESCRIZIONI
                                modGUI1.ChiudiDiv;
                            modGUI1.ChiudiDiv;
                        modGUI1.ChiudiDiv;
                            k:=k+1;
                    END LOOP;

            ELSE
                    SELECT nome INTO var1 FROM MUSEI WHERE idMuseo=museoID;
                    --htp.prn('<h4><b>'||var1||'</b></h4>');
                    MODGUI1.Collegamento('<h4><b>'||var1||'</b></h4>','visualizzaMuseo?idSessione='||idSessione||'&idMuseo='||museoID);
                    modGUI1.ChiudiDiv;
                    htp.br;
                    modGUI1.ApriDiv('class="w3-container" style="width:100%"');

                    k:=1;
                    htp.print('<h2><b>Opere più viste</b></h2>');
                    --INIZIO LOOP DELLA VISUALIZZAZIONE
                        FOR var in (SELECT * FROM   (SELECT opera,dataarrivo,datauscita FROM saleopere, stanze 
                                                    WHERE idstanza = saleopere.sala AND stanze.museo = museoID AND datauscita IS NOT NULL 
                                                    ORDER BY datauscita - dataarrivo DESC
                                    ) WHERE ROWNUM <= 3)
                        LOOP
                            SELECT opere.titolo INTO varOpera FROM opere WHERE idopera = var.opera;
                            modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                            gruppo2.coloreClassifica(k);
                                modGUI1.ApriDiv('class="w3-card-4"');
                                htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%">');
                                    modGUI1.ApriDiv('class="w3-container w3-center"');
                                    --INIZIO DESCRIZIONI
                                        htp.prn('<b>Titolo: </b>');
                                        htp.prn('<button onclick="document.getElementById(''LinguaeLivelloOpera'||var.Opera||''').style.display=''block''" class="w3-margin w3-btn w3-border">'|| varOpera ||'</button>');
                                        gruppo2.linguaELivello(idSessione,var.Opera);
                                        p:=var.datauscita-var.dataarrivo;
                                        htp.prn('<p><b>Esposta per </b>'||p||' giorni</p>');
                                    --FINE DESCRIZIONI
                                    modGUI1.ChiudiDiv;
                                modGUI1.ChiudiDiv;
                            modGUI1.ChiudiDiv;
                            k:=k+1;
                        END LOOP;
                    
                    htp.br;
                    htp.br;

                    k:=1;
                    --OPERE DA PIÙ TEMPO NON SPOSTATE
                    htp.print('<h2><b>Opere non spostate da più tempo: </b></h2>');
                    modGUI1.ApriDiv('class="w3-container" style="width:100%"');
                    --INIZIO LOOP DELLA VISUALIZZAZIONE
                        FOR var in (SELECT * FROM   (SELECT dataarrivo, opera, sala FROM saleopere, stanze 
                                                    WHERE stanze.museo = museoID AND saleopere.sala = stanze.idstanza AND datauscita IS NULL 
                                                    ORDER BY dataarrivo
                                                    ) 
                                    WHERE ROWNUM <= 3)         
                        LOOP
                            SELECT opere.titolo INTO varOpera FROM opere WHERE idopera = var.opera;
                            modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                                gruppo2.coloreClassifica(k);
                                modGUI1.ApriDiv('class="w3-card-4"');
                                htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%">');
                                        modGUI1.ApriDiv('class="w3-container w3-center" style="height:150px;"');
                                        --INIZIO DESCRIZIONI
                                            htp.prn('<b>Titolo: </b>');
                                            htp.prn('<button onclick="document.getElementById(''LinguaeLivelloOpera'||var.Opera||''').style.display=''block''" class="w3-margin w3-btn w3-border">'|| varOpera ||'</button>');
                                            gruppo2.linguaELivello(idSessione,var.Opera);
                                            htp.prn('<p><b>Esposta dal :</b>'||var.dataarrivo||'</p>');
                                        --FINE DESCRIZIONI
                                        modGUI1.ChiudiDiv;
                                modGUI1.ChiudiDiv;
                            modGUI1.ChiudiDiv;
                            k:=k+1;
                        END LOOP;
                    htp.br;
                    htp.br;

                    k:=1;
                    --OPERE PIÙ ANTICHE
                    SELECT AVG(anno) into avgYear FROM OPERE
                    WHERE museo=museoID;

                    p:=annoCorrente-avgYear;
                    htp.print('<h2><b>Opere più antiche: </b></h2>');
                    htp.print('<h5><b>Età media opere:</b>'||p||' anni</h5>');
                    modGUI1.ApriDiv('class="w3-container" style="width:100%"');    
                    FOR var in  (SELECT * FROM (SELECT idOpera FROM OPERE
                                                    WHERE museo=museoID
                                                    ORDER BY anno
                                    )WHERE ROWNUM <=3)
                    LOOP
                        SELECT opere.titolo,opere.anno INTO varOpera,years FROM opere WHERE idopera = var.idOpera;
                        modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                        gruppo2.coloreClassifica(k);
                            modGUI1.ApriDiv('class="w3-card-4"');
                            htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%">');
                                modGUI1.ApriDiv('class="w3-container w3-center"');
                                    --INIZIO DESCRIZIONI
                                    htp.prn('<b>Titolo: </b>');
                                    htp.prn('<button onclick="document.getElementById(''LinguaeLivelloOpera'||var.idOpera||''').style.display=''block''" class="w3-margin w3-btn w3-border">'|| varOpera ||'</button>');
                                    gruppo2.linguaELivello(idSessione,var.idOpera);
                                    htp.prn('<p><b>Anno realizzazione </b>'||years||' D.C</p>');
                                    p:=annoCorrente-years;
                                    htp.prn('<p><b>Anni </b>'||p||'</p>');
                                    --FINE DESCRIZIONI
                                modGUI1.ChiudiDiv;
                            modGUI1.ChiudiDiv;
                        modGUI1.ChiudiDiv;
                            k:=k+1;
                    END LOOP;
                    htp.br;
                    htp.br;

                    k:=1;

                    htp.print('<h2><b>Opere con più autori: </b></h2>');
                    modGUI1.ApriDiv('class="w3-container" style="width:100%"');    
                    FOR var in  (SELECT * FROM (SELECT Autoriopere.idOpera, count(*) AS numAutori FROM AUTORIOPERE, OPERE
                                        WHERE Autoriopere.idOpera=opere.idopera AND opere.museo=museoID
                                        group by AUTORIOPERE.idOpera
                                        order by numAutori DESC
                        )WHERE ROWNUM <=3)
                    LOOP
                        SELECT opere.titolo INTO varOpera FROM opere WHERE idopera = var.idOpera;
                        modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                        gruppo2.coloreClassifica(k);
                            modGUI1.ApriDiv('class="w3-card-4"');
                            htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%">');
                                modGUI1.ApriDiv('class="w3-container w3-center"');
                                    --INIZIO DESCRIZIONI
                                    htp.prn('<b>Titolo: </b>');
                                    htp.prn('<button onclick="document.getElementById(''LinguaeLivelloOpera'||var.idOpera||''').style.display=''block''" class="w3-margin w3-btn w3-border">'|| varOpera ||'</button>');
                                    gruppo2.linguaELivello(idSessione,var.idOpera);
                                    htp.prn('<p><b>N. autori </b>'||var.numAutori||'</p>');
                                    --FINE DESCRIZIONI
                                modGUI1.ChiudiDiv;
                            modGUI1.ChiudiDiv;
                        modGUI1.ChiudiDiv;
                            k:=k+1;
                    END LOOP;

            END IF;
    modGUI1.chiudiDiv;
END;



procedure coloreClassifica(posizione NUMBER DEFAULT 0)IS
    BEGIN
        IF posizione=1 THEN
        htp.print('<h1 class="w3-text-yellow" align="right"><b>'||posizione||'#</b></h1>');
        END IF;
        IF posizione=2 THEN
        htp.print('<h1 class="w3-text-grey" align="right"><b>'||posizione||'#</b></h1>');
        END IF;
        IF posizione=3 THEN
        htp.print('<h1 class="w3-text-brown" align="right"><b>'||posizione||'#</b></h1>');
        END IF;
    END;
/*
 * OPERAZIONI SUGLI AUTORI
 * - Inserimento ✅
 * - Modifica ✅
 * - Visualizzazione ✅
 * - Cancellazione (rimozione) ✅
 * OPERAZIONI STATISTICHE E MONITORAGGIO
 * - Opere realizzate dall’Autore ✅
 * - Musei con Opere dell’Autore esposte ✅
 * - Collaborazioni effettuate ❌
 * - Opere dell’Autore presenti in un Museo scelto ✅
 * - Autori in vita le cui Opere sono esposte in un Museo scelto ✅
 */


--procedura per la visualizzazione del menu Autori
PROCEDURE menuAutori(idSessione NUMBER DEFAULT NULL) is
BEGIN
    modGUI1.ApriPagina('Autori', idSessione);
    -- se idSessione è null allora viene passato a modGUI1.Header, 
    -- che non prende quindi il valore di default 0
    if idSessione IS NULL then
        modGUI1.Header;
    else
        modGUI1.Header(idSessione);
    end if;
    htp.br;htp.br;htp.br;htp.br;
     modGUI1.ApriDiv('class="w3-center"');
        htp.prn('<h1>Autori</h1>'); --TITOLO
        if hasRole(IdSessione, 'DBA')
        then
            modGUI1.Collegamento('Inserisci','InserisciAutore?idSessione='||idSessione,'w3-btn w3-round-xxlarge w3-black');
            htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
        end if;
            htp.prn('<button onclick="document.getElementById(''11'').style.display=''block''" class="w3-btn w3-round-xxlarge w3-black">Statistiche</button>');
        modGUI1.ChiudiDiv;
            selezioneOpStatAut(idSessione);
    htp.br;
    modGUI1.ApriDiv('class="w3-row w3-container"');
    --Visualizzazione TUTTI GLI AUTORI *temporanea*
    -- TODO: filtraggio
    FOR autore IN (SELECT IdAutore,nome,cognome FROM Autori)
    LOOP
        modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
            modGUI1.ApriDiv('class="w3-card-4"');
                htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%;">');
                modGUI1.ApriDiv('class="w3-container w3-center"');
                    htp.prn('<p>'|| autore.Nome ||' '||autore.Cognome||'</p>');
                modGUI1.ChiudiDiv;
                -- Azioni di modifica e rimozione mostrate solo se autorizzatii
                modGUI1.Collegamento('Visualizza',
                    'ModificaAutore?idSessione='||idSessione||'&authorID='||autore.IdAutore||'&operazione=0',
                    'w3-black w3-margin w3-button');
                IF hasRole(IdSessione, 'DBA') THEN
                    -- parametro modifica messo a true: possibile fare editing dell'autore
                    modGUI1.Collegamento('Modifica',
                        'ModificaAutore?idSessione='||idSessione||'&authorID='||autore.IdAutore||'&operazione=1',
                        'w3-green w3-margin w3-button');
                    htp.prn('<button onclick="document.getElementById(''ElimAutore'||autore.IdAutore||''').style.display=''block''" class="w3-margin w3-button w3-red w3-hover-white">Rimuovi</button>');
                    gruppo2.EliminazioneAutore(idSessione,autore.IdAutore);
                END IF;
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
    END LOOP;
    modGUI1.chiudiDiv;
END menuAutori;

--Procedura popUp per la conferma
procedure EliminazioneAutore(
    idSessione NUMBER default 0,
    authorID NUMBER default 0
) IS
aName Autori.Nome%TYPE;
aSurname Autori.Nome%TYPE;
begin
    modGUI1.ApriDiv('id="ElimAutore'||authorID||'" class="w3-modal"');
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
            modGUI1.ApriDiv('class="w3-center"');
                htp.br;
                htp.prn('<span onclick="document.getElementById(''ElimAutore'||authorID||''').style.display=''none''" class="w3-button w3-xlarge w3-red w3-display-topright" title="Close Modal">X</span>');
            htp.print('<h1><b>Confermi?</b></h1>');
            modGUI1.ChiudiDiv;
                    modGUI1.ApriDiv('class="w3-section"');
                        htp.br;
                        SELECT Nome,Cognome INTO aName,aSurname FROM Autori WHERE IdAutore=authorID;
                        htp.prn('stai per rimuovere: '||aName||' '||aSurname);
                        modGUI1.Collegamento('Conferma',
                        'RimozioneAutore?idSessione='||idSessione||'&authorID='||authorID,
                        'w3-button w3-block w3-green w3-section w3-padding');
                        htp.prn('<span onclick="document.getElementById(''ElimAutore'||authorID||''').style.display=''none''" class="w3-button w3-block w3-red w3-section w3-padding" title="Close Modal">Annulla</span>');
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiForm;
        modGUI1.ChiudiDiv;
    modGUI1.ChiudiDiv;
end EliminazioneAutore;

--Procedura rimozione autore
procedure RimozioneAutore(
    idSessione NUMBER default 0,
    authorID NUMBER default 0
) IS
numOpereRealizzate NUMBER(5); 
BEGIN
    -- non è possibile rimuovere un autore che ha realizzato almeno un opera
    -- se non si rimuovono prima le opere in questione
    SELECT COUNT(*) INTO numOpereRealizzate FROM AutoriOpere WHERE IdAutore=authorID;
    IF numOpereRealizzate > 0
    THEN
        -- esito negativo: solo opzione per tornare al menu
        gruppo2.RedirectEsito(
            idSessione,
            'Rimozione fallita',
            'L''autore ha delle opere nella base di dati',
            null, null, null,
            'Torna al menu Autori',
            'menuAutori');
    ELSE
        -- esito positivo: solo opzione per tornare al menu
         gruppo2.RedirectEsito(
            idSessione,
            'Rimozione riuscita',
            null, null, null, null,
            'Torna al menu Autori',
            'menuAutori');
        DELETE FROM Autori WHERE IdAutore = authorID;
        commit;
    END IF;

end RimozioneAutore;

procedure selezioneOpStatAut(
    idSessione NUMBER DEFAULT 0 
)IS
    BEGIN
        modGUI1.ApriDiv('id="11" class="w3-modal"');
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
                modGUI1.ApriDiv('class="w3-center"');
                    htp.br;
                    htp.prn('<span onclick="document.getElementById(''11'').style.display=''none''" class="w3-button w3-xlarge w3-red w3-display-topright" title="Close Modal">X</span>');
                htp.print('<h1>Seleziona l''operazione</h1>');
                modGUI1.ChiudiDiv;
                    modGUI1.ApriForm('selezioneAutoreStatistica','seleziona statistica','w3-container');
                        htp.FORMHIDDEN('idSessione',idSessione);
                        htp.print('<h4>');
                        htp.br;
                        htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                        MODGUI1.InputRadioButton('Opere realizzate', 'operazione',0);
                        htp.br; htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                        MODGUI1.InputRadioButton('Musei con Opere esposte', 'operazione',1);
                        htp.br; htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                        MODGUI1.InputRadioButton('Collaborazioni effettuate', 'operazione',2);
                        htp.br; htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                        MODGUI1.InputRadioButton('Opere presenti in un Museo', 'operazione',3);
                        htp.br; htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                        MODGUI1.InputRadioButton('Autori in vita le cui Opere sono esposte in un Museo', 'operazione',4);
                        htp.br; htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                        htp.print('</h4>');
                        htp.br;
                        htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit">Seleziona</button>');
                        modGUI1.ChiudiDiv;
                    modGUI1.ChiudiForm;
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
END selezioneOpStatAut;

procedure selezioneAutoreStatistica(
    idSessione NUMBER DEFAULT 0,
    operazione NUMBER DEFAULT 0
)IS
nomecompleto VARCHAR2(50);
    BEGIN
    modGUI1.ApriPagina('Selezione statistica', idSessione);
    if idSessione IS NULL then
        modGUI1.Header;
    else
        modGUI1.Header(idSessione);
    end if;
    htp.br;htp.br;htp.br;htp.br;

    -- Salto selezione autore per statistica 4
    IF operazione = 4 THEN
        selezioneMuseoAutoreStatistica(idSessione, operazione, 0);
    ELSE

    htp.prn('<h1 align="center">Seleziona l''autore</h1>');
    modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
        modGUI1.ApriDiv('class="w3-section"');
            -- Link di ritorno al menuAutori
            modGUI1.Collegamento('X',
                'menuAutori?idSessione='||idSessione,
                'w3-btn w3-large w3-red w3-display-topright');
            -- Form per mandare dati alla procedura di conferma
            modGUI1.ApriDiv('class="w3-center"');
            if operazione < 3 THEN
                modGUI1.ApriForm('StatisticheAutori');
                htp.FORMHIDDEN('idSessione',idSessione);
                htp.FORMHIDDEN('operazione',operazione);
                MODGUI1.SELECTOPEN('authID', 'authID');
                FOR an_auth IN (SELECT IdAutore,Nome,COGNOME FROM AUTORI ORDER BY NOME ASC)
                LOOP
                    nomecompleto := an_auth.Nome||' '||an_auth.cognome;
                    modGUI1.SELECTOPTION(an_auth.IdAutore, nomecompleto, 0);
                END LOOP;
                MODGUI1.SELECTClose;
                htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit">Seleziona</button>');
                modGUI1.ChiudiForm;
            ELSIF operazione = 3 THEN
                modGUI1.ApriForm('selezioneMuseoAutoreStatistica');
                htp.FORMHIDDEN('idSessione',idSessione);
                htp.FORMHIDDEN('operazione',operazione);
                MODGUI1.SELECTOPEN('authID', 'authID');
                FOR an_auth IN (SELECT IdAutore,Nome,COGNOME FROM AUTORI ORDER BY NOME ASC)
                LOOP
                    nomecompleto := an_auth.Nome||' '||an_auth.cognome;
                    modGUI1.SELECTOPTION(an_auth.IdAutore, nomecompleto, 0);
                END LOOP;
                MODGUI1.SELECTClose;
                htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit">Seleziona</button>');
                modGUI1.ChiudiForm;
            END IF;
            MODGUI1.chiudiDiv;
        modGUI1.ChiudiDiv;
    modGUI1.ChiudiDiv;
    END IF;
END selezioneAutoreStatistica;

Procedure StatisticheAutori(
    idSessione NUMBER DEFAULT 0,
    operazione NUMBER DEFAULT 0,
    authID NUMBER DEFAULT 0
)IS
auth Autori%ROWTYPE;
BEGIN
SELECT * INTO auth FROM autori WHERE authID=IDAUTORE;
    MODGUI1.ApriPagina('StatisticheAutori',idSessione);
        if idSessione IS NULL then
            modGUI1.Header;
        else
            modGUI1.Header(idSessione);
        end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
        modGUI1.ApriDiv('class="w3-center"');
            htp.prn('<h1><b>STATISTICHE AUTORE</b></h1>'); --TITOLO
            htp.prn('<h4><b>'||auth.nome||' '||auth.cognome||'</b></h4>');
            modGUI1.Collegamento('Torna al menu','menuAutori?idSessione='||idSessione,'w3-black w3-margin w3-button');
        modGUI1.ChiudiDiv;
        htp.br;

        --OPERE REALIZZATE
        if operazione=0 THEN 
        modGUI1.ApriDiv('class="w3-container" style="width:100%"');
        htp.print('<h2><b>Opere realizzate da ');
        modGUI1.Collegamento(auth.Nome||' '||auth.Cognome, 
                            'ModificaAutore?idSessione='||idSessione||'&authorID='||auth.IdAutore
                            ||'&operazione=0&statistiche=//operazione='||operazione||'//authID='||authID,
                            'w3-black w3-margin w3-button');
        htp.print('</b></h2>');
            FOR op IN (SELECT opere.IDOPERA, titolo, anno
                FROM OPERE JOIN AUTORIOPERE on (OPERE.idopera = AUTORIOPERE.idopera)
                WHERE IDAUTORE=AUTH.idautore)
            LOOP
                modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                    modGUI1.ApriDiv('class="w3-card-4" style="height:600px;"');
                    htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%;">');
                            modGUI1.ApriDiv('class="w3-container w3-center"');
                                htp.prn('<p>'|| op.titolo ||'</p>');
                                htp.br;
                                htp.prn('<p>'|| op.anno ||'</p>');
                                htp.prn('<button onclick="document.getElementById(''LinguaeLivelloOpera'||op.IDOPERA||''').style.display=''block''" class="w3-margin w3-button w3-black w3-hover-white">Visualizza</button>');
                                gruppo2.linguaELivello(idSessione,op.IDOPERA);
                            modGUI1.ChiudiDiv;
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
            END LOOP;
        end IF;

        -- MUSEI CON OPERE ESPOSTE
        if operazione=1 THEN
        modGUI1.ApriDiv('class="w3-container" style="width:100%"');
        htp.print('<h2><b>Musei con opere di '||auth.Nome||' '||auth.Cognome||' esposte</b></h2>');
            FOR mus IN (SELECT DISTINCT *
                    FROM MUSEI WHERE
                    IDMUSEO IN (SELECT STANZE.MUSEO FROM stanze JOIN SALEOPERE on (stanze.IDSTANZA=SALEOPERE.SALA) WHERE
                    saleopere.DATAUSCITA is null and SALEOPERE.OPERA in
                    (SELECT DISTINCT opere.IDOPERA
                        FROM OPERE JOIN AUTORIOPERE on (OPERE.idopera = AUTORIOPERE.idopera)
                        WHERE IDAUTORE=AUTH.idautore)))
            LOOP
                modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                    modGUI1.ApriDiv('class="w3-card-4"');
                    htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%;">');
                            modGUI1.ApriDiv('class="w3-container w3-center"');
                                htp.prn('<p><b>'||mus.Nome||'</b></p>');
                                modGUI1.Collegamento('Visualizza', 
                                    'visualizzaMuseo?idSessione='||idSessione||'&museoID='||mus.IdMuseo,
                                    'w3-black w3-margin w3-button');
                            modGUI1.ChiudiDiv;
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
            END LOOP;
        end IF;

        --COLLABORAZIONI EFFETTUATE -------da testare
        if operazione=2 THEN
        modGUI1.ApriDiv('class="w3-container" style="width:100%"');
        htp.print('<h2><b>Opere create in collaborazione</b></h2>');
            FOR op IN (SELECT op1.IDOPERA, titolo, anno
                FROM OPERE op1 WHERE
                    op1.IDOPERA=(SELECT DISTINCT a1.idopera FROM AUTORIOPERE a1,AUTORIOPERE a2 WHERE
                        (a1.idopera=a2.idopera) AND (a1.idautore<>a2.idautore)))
            LOOP
                modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                    modGUI1.ApriDiv('class="w3-card-4" style="height:600px;"');
                    htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%;">');
                            modGUI1.ApriDiv('class="w3-container w3-center"');
                                htp.prn('<p>'|| op.titolo ||'</p>');
                                htp.br;
                                htp.prn('<p>'|| op.anno ||'</p>');
                                htp.prn('<button onclick="document.getElementById(''LinguaeLivelloOpera'||op.IDOPERA||''').style.display=''block''" class="w3-margin w3-button w3-black w3-hover-white">Visualizza</button>');
                                gruppo2.linguaELivello(idSessione,op.IDOPERA);
                            modGUI1.ChiudiDiv;
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
            END LOOP;
        end IF;

END;

procedure selezioneMuseoAutoreStatistica(
    idSessione NUMBER DEFAULT 0,
    operazione NUMBER DEFAULT 0,
    authID NUMBER DEFAULT 0
)IS
BEGIN
modGUI1.ApriPagina('Selezione statistica', idSessione);
    if idSessione IS NULL then
        modGUI1.Header;
    else
        modGUI1.Header(idSessione);
    end if;
    htp.br;htp.br;htp.br;htp.br;

    htp.prn('<h1 align="center">Seleziona il museo</h1>');
    modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
        modGUI1.ApriDiv('class="w3-section"');
            -- Link di ritorno al menuAutori
            modGUI1.Collegamento('X',
                'menuAutori?idSessione='||idSessione,
                'w3-btn w3-large w3-red w3-display-topright');
            -- Form per mandare dati alla procedura di conferma
            modGUI1.ApriDiv('class="w3-center"');
            modGUI1.ApriForm('StatisticheMuseoAutori');
            htp.FORMHIDDEN('idSessione',idSessione);
            htp.FORMHIDDEN('operazione',operazione);
            IF authID = 0 THEN
                htp.formhidden('authID', 0);
            ELSE
                htp.FORMHIDDEN('authID',authID);
            END IF;
            MODGUI1.SELECTOPEN('museoID', 'museoID');
            FOR an_mus IN (SELECT IDMUSEO,NOME FROM MUSEI ORDER BY NOME ASC)
            LOOP
                modGUI1.SELECTOPTION(an_mus.idmuseo, an_mus.Nome, 0);
            END LOOP;
            MODGUI1.SELECTClose;
            htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit">Seleziona</button>');
            modGUI1.ChiudiForm;
            MODGUI1.chiudiDiv;
        modGUI1.ChiudiDiv;
    modGUI1.ChiudiDiv;
END selezioneMuseoAutoreStatistica;


Procedure StatisticheMuseoAutori(
    idSessione NUMBER DEFAULT 0,
    operazione NUMBER DEFAULT 0,
    authID NUMBER DEFAULT 0,
    museoID NUMBER DEFAULT 0
)IS
auth Autori%ROWTYPE;
mus MUSEI%ROWTYPE;
IDOPER number(5);
eta NUMBER;
BEGIN
    -- Se statistica 3 seleziona autore specificato
    IF operazione = 3 THEN
        SELECT * INTO auth FROM autori WHERE authID=IDAUTORE;
    END IF;
    -- Seleziono il museo scelto
    SELECT * INTO mus FROM MUSEI WHERE museoID=IDMUSEO;

    -- Pagina statistiche autori
    MODGUI1.ApriPagina('Statistiche Autori',idSessione);
    if idSessione IS NULL then
        modGUI1.Header;
    else
        modGUI1.Header(idSessione);
    end if;
    htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
    modGUI1.ApriDiv('class="w3-center"');
        htp.prn('<h1><b>STATISTICHE AUTORE</b></h1>'); -- Titolo pagina (stat 3)
        IF operazione = 3 THEN
            htp.prn('<h2><b>'||auth.Nome||' '||auth.Cognome||'</b></h2>');
        ELSE -- Titolo pagina (stat 4)
            htp.prn('<h2><b>Autori in vita con opere esposte in '||mus.Nome||'</b></h2>');
        END IF;
        modGUI1.Collegamento(
            'Torna al menu',
            'menuAutori?idSessione='||idSessione,
            'w3-black w3-margin w3-button');
    modGUI1.ChiudiDiv;
    htp.br;

    modGUI1.ApriDiv('class="w3-container" style="width:100%"');
    -- Statistica 3: Opere dell'autore <auth> esposte nel museo <mus>
    IF operazione = 3 THEN
        htp.prn('<h4><b>Opere realizzate da');
        modGUI1.Collegamento(auth.Nome||' '||auth.Cognome, 
                'ModificaAutore?idSessione='||idSessione||'&authorID='||auth.IdAutore||'&operazione=0'
                ||'&caller=StatisticheMuseoAutori'
                ||'&callerParams=//operazione='||operazione||'//authID='||authID||'//museoID='||museoID);
        htp.prn('esposte in');
        modGUI1.Collegamento(mus.Nome,
                'visualizzaMuseo?idSessione='
                ||idSessione||'&museoID='||mus.IdMuseo);
    htp.prn('</b></h4>');
        FOR op IN (
            SELECT Opera AS IdOpera,Titolo,Anno -- se usate altri attributi nella pagina aggiungeteli qui
            FROM OPERE JOIN AUTORIOPERE ON OPERE.IdOpera = AUTORIOPERE.IdOpera
                JOIN SALEOPERE ON OPERE.IdOpera = SALEOPERE.Opera
            WHERE IDAUTORE=AUTH.idautore AND SALEOPERE.Sala IN 
                (SELECT STANZE.IdStanza FROM Stanze WHERE STANZE.Museo = museoID))
        LOOP
            modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                modGUI1.ApriDiv('class="w3-card-4" style="height:600px;"');
                htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%;">');
                    modGUI1.ApriDiv('class="w3-container w3-center"');
                        htp.prn('<p>'|| op.Titolo ||'</p>');
                        htp.br;
                        htp.prn('<p>'|| op.Anno ||'</p>');
                        htp.prn('<button onclick="document.getElementById(''LinguaeLivelloOpera'
                            ||TO_CHAR(op.IdOpera)||''').style.display=''block''" class="w3-margin w3-button w3-black w3-hover-white">Visualizza</button>');
                        gruppo2.linguaELivello(idSessione, op.IdOpera);
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
        END LOOP;
    -- statistica 4: Autori in vita le cui opere 
    ELSE
        htp.prn('<h4><b>Autori in vita con opere esposte in ');
        modGUI1.Collegamento(mus.Nome,
                    'visualizzaMuseo?idSessione='
                    ||idSessione||'&museoID='||mus.IdMuseo,
                    'w3-black w3-margin w3-button');
        htp.prn('</b></h4>');
        FOR an_author IN (
            SELECT DISTINCT A.IdAutore, A.Nome,A.Cognome,A.DataNascita,A.Nazionalita 
            FROM Autori A JOIN AutoriOpere AO ON A.IdAutore=AO.IdAutore
            WHERE A.DataMorte IS NULL 
            AND EXISTS
                (SELECT * FROM Opere O WHERE O.IdOpera = AO.IdOpera AND Museo = mus.IdMuseo))
        LOOP
            -- calcolo età autore in anni, approssimativa
            eta := (sysdate - an_author.DataNascita) / 365;
            modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                modGUI1.ApriDiv('class="w3-card-4"');
                htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%;">');
                    modGUI1.ApriDiv('class="w3-container w3-center"');
                        htp.prn('<p>'||an_author.Nome||' '||an_author.Cognome||'</p>');
                        htp.br;
                        htp.prn('Data nascita: ');
                        IF an_author.DataNascita IS NULL THEN
                            htp.prn('Sconosciuta');
                        ELSE
                        htp.prn(
                            TO_CHAR(an_author.DataNascita, 'DD/MM/YYYY')
                            ||' (et&agrave;: '||ROUND(eta, 0)||' anni)');
                        END IF;
                        htp.br;
                        modGUI1.Collegamento('Visualizza', 
                            'ModificaAutore?idSessione='||idSessione||'&authorID='||an_author.IdAutore||'&operazione=0'
                            ||'&caller=StatisticheMuseoAutori'
                            ||'&callerParams=//operazione='||operazione||'//authID='||authID||'//museoID='||museoID);
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
        END LOOP;
    END IF;
END statisticheMuseoAutori;


-- Procedura per l'inserimento di nuovi Autori nella base di dati
-- I parametri (a parte idSessione) sono usati per effettuare il riempimento automatico del form
PROCEDURE InserisciAutore(
    idSessione NUMBER DEFAULT NULL,
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

    modGUI1.ApriPagina('Inserimento Autore', idSessione);
    if idSessione IS NULL then
        modGUI1.Header;
    else
        modGUI1.Header(idSessione);
    end if;
    htp.br;htp.br;htp.br;htp.br;

    htp.prn('<h1 align="center">Inserimento Autore</h1>');
    modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
        modGUI1.ApriDiv('class="w3-section"');
            -- Link di ritorno al menuAutori
            modGUI1.Collegamento('X',
                'menuAutori?idSessione='||idSessione,
                'w3-btn w3-large w3-red w3-display-topright');
            -- Form per mandare dati alla procedura di conferma
            modGUI1.ApriForm('ConfermaDatiAutore');
            htp.FORMHIDDEN('idSessione',idSessione);
            htp.br;
            modGUI1.Label('Nome*');
            modGUI1.InputText('authName', placeholderNome, 1, authName);
            htp.br;
            modGUI1.Label('Cognome*');
            modGUI1.InputText('authSurname', placeholderCognome, 1, authSurname);
            htp.br;
            -- L'input di tipo data è attivo sse la checkbox non è selezionata
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
END;

-- Procedura per confermare i dati dell'inserimento di un Autore
PROCEDURE ConfermaDatiAutore(
    idSessione NUMBER DEFAULT 0,
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
    OR idSessione = 0
    OR authName IS NULL
    OR authSurname IS NULL
    OR (birth IS NOT NULL AND death IS NOT NULL AND death < birth)
    OR nation IS NULL
    THEN
        IF idSessione <> 1 THEN
            RedirectEsito(idSessione, 'Inserimento fallito',
                'Errore: Operazione non autorizzata (controlla di essere loggato)',
                'Torna all''inserimento','InserisciAutore', 
                '//authName='||authName||'//authSurname='||authSurname||'//dataNascita='||dataNascita||'//dataMorte='||dataMorte||'//nation='||nation,
                'Torna al menù','menuAutori');
            ELSIF numAutori > 0 THEN
                RedirectEsito(idSessione, 'Inserimento fallito',
                    'Errore: Autore già presente',
                    'Torna all''inserimento','InserisciAutore', 
                    '//authName='||authName||'//authSurname='||authSurname||'//dataNascita='||dataNascita||'//dataMorte='||dataMorte||'//nation='||nation,
                    'Torna al menù','menuAutori');

            ELSE
				-- I tre rami che seguono non possono essere raggiunti chiamando
				-- InserisciAutore, ma sono possibili chiamando direttamente ConfermaDatiAutore
                IF authName IS NULL THEN
                    RedirectEsito(idSessione, 'Inserimento fallito',
                        'Errore: Inserire Nome',
                        'Torna all''inserimento','InserisciAutore', 
                        '//authName='||authName||'//authSurname='||authSurname||'//dataNascita='||dataNascita||'//dataMorte='||dataMorte||'//nation='||nation,
                        'Torna al menù','menuAutori');
                ELSIF authSurname IS NULL THEN
                    RedirectEsito(idSessione, 'Inserimento fallito',
                        'Errore: Inserire Cognome',
                        'Torna all''inserimento','InserisciAutore', 
                        '//authName='||authName||'//authSurname='||authSurname||'//dataNascita='||dataNascita||'//dataMorte='||dataMorte||'//nation='||nation,
                        'Torna al menù','menuAutori');
                ELSIF nation IS NULL THEN
                    RedirectEsito(idSessione, 'Inserimento fallito',
                        'Errore: Inserire nazionalità',
                        'Torna all''inserimento','InserisciAutore', 
                        '//authName='||authName||'//authSurname='||authSurname||'//dataNascita='||dataNascita||'//dataMorte='||dataMorte||'//nation='||nation,
                        'Torna al menù','menuAutori');
                ELSIF to_date(dataNascita, 'YYYY-MM-DD') > to_date(dataMorte, 'YYYY-MM-DD') THEN
                    RedirectEsito(idSessione, 'Inserimento fallito',
                        'Errore: data di nascita postuma alla data di morte',
                        'Torna all''inserimento','InserisciAutore', 
                        '//authName='||authName||'//authSurname='||authSurname||'//dataNascita='||dataNascita||'//dataMorte='||dataMorte||'//nation='||nation,
                        'Torna al menù','menuAutori');
                END IF;
            END IF;
    ELSE
		-- Parametri OK: pulsante conferma per effettuare insert
        -- o pulsante Annulla per tornare alla procedura di inserimento
        modGUI1.ApriPagina('Conferma dati',idSessione);
        if idSessione IS NULL then
            modGUI1.Header;
        else
            modGUI1.Header(idSessione);
        end if;
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
            HTP.FORMHIDDEN('idSessione', idSessione);
            HTP.FORMHIDDEN('authName', authName);
            HTP.FORMHIDDEN('authSurname', authSurname);
            HTP.FORMHIDDEN('dataNascita', dataNascita);
            HTP.FORMHIDDEN('dataMorte', dataMorte);
            HTP.FORMHIDDEN('nation', nation);
            MODGUI1.InputSubmit('Conferma');
            MODGUI1.ChiudiForm;
            -- Form nascosto per ritorno ad InserisciAutore con form precompilato
            MODGUI1.ApriForm('InserisciAutore');
            HTP.FORMHIDDEN('idSessione', idSessione);
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
        genericErrorPage(idSessione, 'Errore','Errore sconosciuto','OK','menuAutori');
END;

-- Effettua l'inserimento di un nuovo Autore nella base di dati
-- Oppure effettua rollback se non consentito
PROCEDURE InserisciDatiAutore(
    idSessione NUMBER DEFAULT 0,
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
    (IdAutoreSeq.NEXTVAL, authName, UPPER(authSurname), birth, death, nation, 0);
    IF SQL%FOUND
    THEN
        -- faccio il commit dello statement precedente
        commit;
        RedirectEsito(idSessione, 'Inserimento riuscito', null,'Inserisci nuovo autore','InserisciAutore', null,'Torna al menù','menuAutori');
    ELSE
        RedirectEsito(idSessione, 'Inserimento fallito',
             'Errore',
             'Torna all''inserimento','InserisciAutore', 
             '//authName='||authName||'//authSurname='||authSurname||'//dataNascita='||dataNascita||'//dataMorte='||dataMorte||'//nation='||nation,
             'Torna al menù','menuAutori');
            ROLLBACK;
    END IF;
    EXCEPTION
    WHEN AutorePresente THEN
        RedirectEsito(idSessione, 'Inserimento fallito',
             'Errore: Autore già presente',
             'Torna all''inserimento','InserisciAutore', 
             '//authName='||authName||'//authSurname='||authSurname||'//dataNascita='||dataNascita||'//dataMorte='||dataMorte||'//nation='||nation,
             'Torna al menù','menuAutori');
            ROLLBACK;
END;

-- Procedura per visualizzare/modificare un Autore presente nella base di dati
-- (raggiungibile dal menuAutori)
-- Il parametro operazione assume uno tra i seguenti valori:
--  0: Visualizzazione
--  1: Modifica
PROCEDURE ModificaAutore(
	idSessione NUMBER DEFAULT 0,
	authorID NUMBER DEFAULT 0,
    operazione NUMBER DEFAULT 0,
    caller VARCHAR2 DEFAULT NULL,
    callerParams VARCHAR2 DEFAULT ''
) IS
this_autore Autori%ROWTYPE;
op_title VARCHAR2(25);
-- Gli eventuali parametri della procedura chiamante
params VARCHAR2(255);
BEGIN
    SELECT * INTO this_autore FROM Autori WHERE IdAutore = authorID;
    IF operazione = 0 THEN
        op_title := 'Visualizza'; 
    ELSIF operazione = 1 THEN
        op_title := 'Modifica';
    END IF;
    modGUI1.ApriPagina(op_title||' Autore', idSessione);
	if idSessione IS NULL then
        modGUI1.Header;
    else
        modGUI1.Header(idSessione);
    end if;
	htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;

	modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px" ');
		modGUI1.ApriDiv('class="w3-section"');
        modGUI1.Collegamento('X','menuAutori?idSessione='||idSessione||'',' w3-btn w3-large w3-red w3-display-topright');
        htp.br;
		htp.header(2, 'Dettagli Autore', 'center');
		-- caso modifica
		IF operazione = 1 THEN
            modGUI1.ApriForm('UpdateAutore');
                htp.formhidden('idSessione', idSessione);
                htp.formhidden('authID', this_autore.IdAutore);
                modGUI1.Label('Nome:');
				modGUI1.InputText('newName', this_autore.Nome, 1, this_autore.Nome);
                htp.br;
                modGUI1.Label('Cognome:');
				modGUI1.InputText('newSurname', this_autore.Cognome, 1, this_autore.Cognome);
                htp.br;
                modGUI1.Label('Data nascita:');
				modGUI1.InputDate('dataNascita', 'newBirth', 1, TO_CHAR(this_autore.DataNascita, 'YYYY-MM-DD'));
                htp.br;
                modGUI1.Label('Data morte:');
				modGUI1.InputDate('dataMorte', 'newDeath', 1, TO_CHAR(this_autore.DataMorte, 'YYYY-MM-DD'));
                htp.br;
                modGUI1.Label('Nazionalità:');
				modGUI1.InputText('newNation', this_autore.Nazionalita, 1, this_autore.Nazionalita);
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
			IF this_autore.DataNascita IS NOT NULL THEN
				htp.prn(TO_CHAR(this_autore.DataNascita, 'DD/MM/YYYY'));
			ELSE
				htp.prn('Sconosciuta');
			END IF;
			htp.br;
			modGUI1.Label('Data morte:');
			IF this_autore.DataMorte IS NOT NULL THEN
				htp.prn(TO_CHAR(this_autore.DataMorte, 'DD/MM/YYYY'));
			ELSE
				htp.prn('Sconosciuta');
			END IF;
			htp.br;
			modGUI1.Label('Nazionalità:');
			htp.prn(this_autore.Nazionalita);
			htp.br; htp.br;
		END IF;

        -- Link per ritorno a procedura statistica dalla quale è stato chiamato
        IF caller is not null THEN
        params := REPLACE(callerParams,'//','&');
        MODGUI1.collegamento('Annulla',
            caller||'?idSessione='||idSessione||params,
            'w3-button w3-block w3-black w3-section w3-padding');
        END IF; 
		modGUI1.ChiudiDiv;
	modGUI1.ChiudiDiv;
END ModificaAutore;

PROCEDURE UpdateAutore(
	idSessione NUMBER DEFAULT 0,
	authID NUMBER DEFAULT 0,
	newName VARCHAR2 DEFAULT 'Sconosciuto',
	newSurname VARCHAR2 DEFAULT 'Sconosciuto',
	newBirth VARCHAR2 DEFAULT NULL,
	newDeath VARCHAR2 DEFAULT NULL,
	newNation VARCHAR2 DEFAULT 'Sconosciuta'
) IS
Errore_data EXCEPTION;
BEGIN
    IF TO_DATE(newBirth, 'YYYY-MM-DD') > TO_DATE(newDeath, 'YYYY-MM-DD') THEN
		RAISE Errore_data;
	END IF;
	UPDATE Autori SET
		Nome=newName,
		Cognome=upper(newSurname),
		DataNascita=TO_DATE(newBirth, 'YYYY-MM-DD'),
		DataMorte=TO_DATE(newDeath, 'YYYY-MM-DD'),
		Nazionalita=newNation
	WHERE IdAutore=authID;

    commit;
    RedirectEsito(idSessione, 'Aggiornamento riuscito', null,null,null, null,'Torna al menù','menuAutori');

    EXCEPTION
		WHEN Errore_data THEN
            RedirectEsito(idSessione, 'Aggiornamento fallito',
             'Errore: data di nascita postuma alla data di morte',
             'Torna alla modifica','ModificaAutore', 
             '//authorID='||authID||'//operazione=1','Torna al menù','menuAutori');
            ROLLBACK;
END;


/*
 * OPERAZIONI SULLE DESCRIZIONI
 * - Inserimento ✅
 * - Modifica ✅
 * - Visualizzazione ✅
 * - Cancellazione (rimozione) ✅
 * OPERAZIONI STATISTICHE E MONITORAGGIO
 * - Livello descrizione più presente ✅
 * - Lingua più presente ✅
 */

-- Procedura per l'inserimento di nuove descrizioni di Opere nella base di dati
PROCEDURE InserisciDescrizione(
    idSessione NUMBER DEFAULT NULL,
    language VARCHAR2 DEFAULT NULL,
    d_level VARCHAR2 DEFAULT NULL,
    d_text VARCHAR2 DEFAULT NULL,
    operaID NUMBER DEFAULT NULL
) IS
def_lingua VARCHAR2(255) := 'Inserisci la lingua...';
def_descr VARCHAR2(255) := 'Inserisci la descrizione...';
bambino_SELECTed NUMBER(1) := 0;
adulto_SELECTed NUMBER(1) := 0;
esperto_SELECTed NUMBER(1) := 0;
BEGIN
    modGUI1.ApriPagina('Inserimento Descrizione', idSessione);

    if idSessione IS NULL then
        modGUI1.Header;
    else
        modGUI1.Header(idSessione);
    end if;
    htp.br;htp.br;htp.br;htp.br;
    htp.prn('<h1 align="center">Inserimento Descrizione</h1>');
    modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
        modGUI1.ApriDiv('class="w3-section"');
        modGUI1.Collegamento('X','menuOpere?idSessione='||idSessione||'',' w3-btn w3-large w3-red w3-display-topright');
        -- Form per mandare dati alla procedura di conferma
        modGUI1.ApriForm('ConfermaDatiDescrizione');
        htp.FORMHIDDEN('idSessione',idSessione);
        htp.br;
        MODGUI1.Label('Lingua*'); -- TODO: usare dropdown per avere nome standardizzato
        MODGUI1.InputText('language', def_lingua, 1, language);
        htp.br;
        -- Codice per autoselezione livello

        IF d_level = 'bambino' THEN
            bambino_SELECTed := 1;
        ELSIF d_level = 'adulto' THEN
            adulto_SELECTed := 1;
        ELSIF d_level = 'esperto' THEN
            esperto_SELECTed := 1;
        END IF;
        MODGUI1.Label('Livello*');
        modGUI1.InputRadioButton('Bambino', 'd_level', 'bambino', bambino_SELECTed, 0);
        modGUI1.InputRadioButton('Adulto', 'd_level', 'adulto', adulto_SELECTed, 0);
        modGUI1.InputRadioButton('Esperto', 'd_level', 'esperto', esperto_SELECTed, 0);
        htp.br;
        MODGUI1.Label('Testo descrizione*');
        HTP.BR;
        MODGUI1.InputTextArea('d_text', def_descr, 1, d_text); -- FIXME: autofill
        HTP.BR;
        MODGUI1.Label('Opera*');
        -- Menu a tendina per selezione dell'opera: viene scelto il titolo dall'utente
        -- ed inviato l'ID alla procedura chiamata (ConfermaDatiDescrizione)
        MODGUI1.SELECTOPEN('operaID', 'operaID');
        if operaId is not null THEN
            FOR an_opera IN (SELECT IdOpera,Titolo FROM Opere ORDER BY Titolo ASC)
            LOOP
                if an_opera.idopera<>operaId THEN
                modGUI1.SELECTOPTION(an_opera.IdOpera, an_opera.Titolo, 0);
                ELSE
                modGUI1.SELECTOPTION(an_opera.IdOpera, an_opera.Titolo, 1);
                END IF;
            END LOOP;
            else
                FOR an_opera IN (SELECT IdOpera,Titolo FROM Opere ORDER BY Titolo ASC)
                LOOP
                modGUI1.SELECTOPTION(an_opera.IdOpera, an_opera.Titolo, 0);
                end loop;
        end if;
        MODGUI1.SELECTClose;
        MODGUI1.InputSubmit('Inserisci');
        if operaId is not null and language is not null and d_level is not null THEN
        MODGUI1.collegamento('Annulla','VisualizzaOpera?idSessione='||idSessione||'&operaID='||operaID||'&lingue='||language||'&livelli='||d_level,'w3-button w3-block w3-black w3-section w3-padding');
        end if;
        MODGUI1.ChiudiForm;
    MODGUI1.ChiudiDiv;
    MODGUI1.ChiudiDiv;
END;

-- Conferma o annulla l'immissione di una nuova iscrizione per un'Opera
PROCEDURE ConfermaDatiDescrizione(
    idSessione NUMBER DEFAULT 0,
    language VARCHAR2 DEFAULT 'Sconosciuta',
    d_level VARCHAR2 DEFAULT 'Sconosciuto',
    d_text VARCHAR2 DEFAULT NULL,
    operaID NUMBER DEFAULT NULL
) IS
v_opera Opere%ROWTYPE;
BEGIN
    SELECT * INTO v_opera FROM Opere WHERE Opere.IdOpera = operaID;
    IF language IS NULL
        OR LOWER(d_level) NOT IN ('adulto', 'bambino', 'esperto')
        OR d_text IS NULL
        OR OperaID IS NULL
    THEN
        gruppo2.genericErrorPage(idSessione,
            'Errore',
            'Uno dei parametri immessi è nullo',
            'Correggi',
            'InserisciDescrizione?idSessione='||idSessione||'='||language||'='||d_level||'='||d_text||'='||operaID);
    ELSIF SQL%NOTFOUND THEN
        gruppo2.genericErrorPage(idSessione,
            'Errore',
            'L''Opera immessa è inesistente',
            'Correggi',
            'InserisciDescrizione?idSessione='||idSessione||'='||language||'='||d_level||'='||d_text||'='||operaID);
    ELSE
        -- Parametri OK, pulsante conferma o annulla
        modGUI1.ApriPagina('Conferma Dati Descrizione', idSessione);

        if idSessione IS NULL then
            modGUI1.Header;
        else
            modGUI1.Header(idSessione);
        end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
        htp.prn('<h1 align="center">Conferma Dati Descrizione</h1>');
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
            modGUI1.ApriDiv('class="w3-section"');
                modGUI1.Collegamento('X','menuOpere?idSessione='||idSessione||'',' w3-btn w3-large w3-red w3-display-topright');
                modGUI1.Label('Lingua:');
                HTP.PRINT(language);
                htp.br;
                modGUI1.Label('Livello:');
                HTP.PRINT(d_level);
                htp.br;
                modGUI1.Label('Testo descrizione:');
                HTP.PRINT(d_text);
                -- Form nascosto per conferma insert
                MODGUI1.ApriForm('InserisciDatiDescrizione');
                HTP.FORMHIDDEN('idSessione', idSessione);
                HTP.FORMHIDDEN('language', language);
                HTP.FORMHIDDEN('d_level', d_level);
                HTP.FORMHIDDEN('d_text', d_text);
                HTP.FORMHIDDEN('operaID', OperaID);
                MODGUI1.InputSubmit('Conferma');
                MODGUI1.ChiudiForm;
                -- Form nascosto per ritorno ad InserisciAutore con form precompilato
                MODGUI1.ApriForm('InserisciDescrizione');
                HTP.FORMHIDDEN('idSessione', idSessione);
                HTP.FORMHIDDEN('language', language);
                HTP.FORMHIDDEN('d_level', d_level);
                HTP.FORMHIDDEN('d_text', d_text);
                HTP.FORMHIDDEN('operaID', OperaID);
                MODGUI1.InputSubmit('Annulla');
            MODGUI1.ChiudiDiv;
    modGUI1.ChiudiDiv;
    END IF;
END;

-- Effettua l'inserimento di una nuova descrizione nella base di dati
PROCEDURE InserisciDatiDescrizione(
    idSessione NUMBER DEFAULT 0,
    language VARCHAR2 DEFAULT 'Sconosciuta',
    d_level VARCHAR2 DEFAULT 'Sconosciuto',
    d_text VARCHAR2 DEFAULT NULL,
    operaID NUMBER DEFAULT NULL
) IS
OperaInesistente EXCEPTION;  -- eccezione lanciata se l'opera operaID non esiste
Opera Opere%ROWTYPE;
BEGIN
    -- Controllo esistenza dell'opera riferita
    SELECT * INTO Opera FROM Opere WHERE IdOpera=operaID;
    IF true
    THEN
    -- faccio il commit dello statement precedente
    INSERT INTO DESCRIZIONI VALUES
    (IdDescSeq.NEXTVAL, language, LOWER(d_level), d_text, operaID);
        commit;
        RedirectEsito(idSessione, 'Inserimento riuscito', null,null,null,null, 'Torna all''opera','VisualizzaOpera','&operaID='||operaID||'&lingue='||language);
     ELSE
    -- opera non presente: eccezione
        RAISE OperaInesistente;
    END IF;

    EXCEPTION
        WHEN OperaInesistente THEN
            RedirectEsito(idSessione, 'Inserimento fallito',
             'Errore: Opera inesistente',
             'Torna all''opera','VisualizzaOpera', 
             '//operaID='||operaID||'//lingue='||language,'Torna al menù','menuOpere');
            ROLLBACK;
   END;

PROCEDURE modificaDescrizione(
        idSessione NUMBER DEFAULT 0,
        idDescrizione NUMBER DEFAULT NULL
) IS
DESCR descrizioni%ROWTYPE;
tit VARCHAR2(100);
bambino_SELECTed NUMBER(1) := 0;
adulto_SELECTed NUMBER(1) := 0;
esperto_SELECTed NUMBER(1) := 0;
italian_SELECTed NUMBER(1) := 0;
English_SELECTed NUMBER(1) := 0;
Chinese_SELECTed NUMBER(1) := 0;
BEGIN
SELECT * INTO DESCR FROM DESCRIZIONI WHERE IdDesc=idDescrizione;
SELECT titolo into tit FROM opere WHERE Descr.opera=IDOPERA;
modGUI1.ApriPagina('ModificaDescrizione',idSessione);
        modGUI1.Header(idSessione);
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
        htp.prn('<h1 align="center">Modifica Descrizione</h1>');
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
            modGUI1.ApriDiv('class="w3-section"');
            modGUI1.Collegamento('X','menuOpere?idSessione='||idSessione||'',' w3-btn w3-large w3-red w3-display-topright');
            --INIZIO SEZIONE DA MODIFICARE
                modGUI1.ApriForm('UpdateDescrizione',NULL,'w3-container');
                    htp.FORMHIDDEN('idSessione',idSessione);
                    htp.FORMHIDDEN('descrID', idDescrizione);
                    modGUI1.Label('Opera*');
                    MODGUI1.SELECTOPEN('newopera', 'newopera');
                    FOR op IN (SELECT * FROM OPERE ORDER BY TITOLO ASC)
                    LOOP
                        if op.idopera<>DESCR.opera THEN
                        modGUI1.SELECTOPTION(op.idopera, OP.titolo, 0);
                        ELSE
                        modGUI1.SELECTOPTION(op.idopera, OP.titolo, 1);
                        end if;
                    END LOOP;
                    MODGUI1.SELECTClose;
                    htp.br;
                    IF DESCR.lingua = 'Italian' THEN
                    italian_SELECTed := 1;
                    ELSIF DESCR.lingua = 'English' THEN
                    English_SELECTed := 1;
                    ELSIF DESCR.lingua = 'Chinese' THEN
                    Chinese_SELECTed := 1;
                    END IF;
                    modGUI1.Label('Lingua*');
                        modGUI1.InputRadioButton('Italiano ', 'newlingua', 'Italian', italian_SELECTed, 0);
                        modGUI1.InputRadioButton('English ', 'newlingua', 'English', English_SELECTed, 0);
                        modGUI1.InputRadioButton('中国人 ', 'newlingua', 'Chinese', Chinese_SELECTed, 0);
                    htp.br;
                    IF DESCR.livello = 'bambino' THEN
                    bambino_SELECTed := 1;
                    ELSIF DESCR.livello = 'adulto' THEN
                    adulto_SELECTed := 1;
                    ELSIF DESCR.livello = 'esperto' THEN
                    esperto_SELECTed := 1;
                    END IF;
                    modGUI1.Label('Livello*');
                    modGUI1.InputRadioButton('Bambino', 'newlivello', 'bambino', bambino_SELECTed, 0);
                    modGUI1.InputRadioButton('Adulto', 'newlivello', 'adulto', adulto_SELECTed, 0);
                    modGUI1.InputRadioButton('Esperto', 'newlivello', 'esperto', esperto_SELECTed, 0);
                    htp.br;
                    modGUI1.Label('Testo:');
                    htp.br; 
                    modGUI1.InputTextArea('newtesto', DESCR.testo, 1, DESCR.testo);
                    htp.br; htp.br;
                    modGUI1.InputSubmit('Modifica');
                    MODGUI1.collegamento('Annulla','VisualizzaOpera?idSessione='||idSessione||'&operaID='||descr.opera||'&lingue='||descr.lingua,'w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiForm;
            --FINE SEZIONE DA MODIFICARE
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
END;


PROCEDURE UpdateDescrizione(
	idSessione NUMBER DEFAULT 0,
	descrID NUMBER DEFAULT 0, 
    newopera number DEFAULT 0,
    newlingua varchar2 DEFAULT null,
    newlivello varchar2 DEFAULT null,
    newtesto CLOB DEFAULT null
) IS
Errore_data EXCEPTION;
BEGIN
IF descrid is null or newopera is null THEN
    RAISE Errore_data;
    end if;
	UPDATE DESCRIZIONI SET
		opera=newopera,
		LINGUA=newlingua,
		LIVELLO=newlivello,
		TESTO=newtesto
	WHERE IDDESC=descrID;

    commit;
    RedirectEsito(idSessione, 'Aggiornamento riuscito', null,null, null, null,'Torna all''opera','VisualizzaOpera','//operaID='||newopera||'//lingue='||newlingua);
    EXCEPTION
		WHEN Errore_data THEN
            RedirectEsito(idSessione, 'Aggiornamento fallito', null,null, null, null,'Torna all''opera','VisualizzaOpera','//operaID='||newopera||'//lingue='||newlingua);
            ROLLBACK;
END;

procedure EliminazioneDescrizione(
    idSessione NUMBER default 0,
    idDescrizione NUMBER default 0
) IS
dLingua DESCRIZIONI.Lingua%TYPE;
dLivello DESCRIZIONI.Livello%TYPE;
begin
    modGUI1.ApriDiv('id="ElimDescrizione'||idDescrizione||'" class="w3-modal"');
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
            modGUI1.ApriDiv('class="w3-center"');
                htp.br;
                htp.prn('<span onclick="document.getElementById(''ElimDescrizione'||idDescrizione||''').style.display=''none''" class="w3-button w3-xlarge w3-red w3-display-topright" title="Close Modal">X</span>');
            htp.print('<h1><b>Confermi?</b></h1>');
            modGUI1.ChiudiDiv;
                    modGUI1.ApriDiv('class="w3-section"');
                        htp.br;
                        SELECT Lingua,Livello INTO dLingua,dLivello FROM DESCRIZIONI WHERE IDDESC=idDescrizione;
                        htp.prn('stai per rimuovere: '||dLingua||' '||dLivello);
                        modGUI1.Collegamento('Conferma',
                        'RimozioneDescrizione?idSessione='||idSessione||'&idDescrizione='||idDescrizione,
                        'w3-button w3-block w3-green w3-section w3-padding');
                        htp.prn('<span onclick="document.getElementById(''ElimDescrizione'||idDescrizione||''').style.display=''none''" class="w3-button w3-block w3-red w3-section w3-padding" title="Close Modal">Annulla</span>');
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiForm;
        modGUI1.ChiudiDiv;
    modGUI1.ChiudiDiv;
end EliminazioneDescrizione;

--Procedura rimozione descrizione
procedure RimozioneDescrizione(
    idSessione NUMBER default 0,
    idDescrizione NUMBER default 0
) IS
opid number(5);
oplingua VARCHAR2(25);
BEGIN
    SELECT Opera, LINGUA into opid, oplingua
    FROM DESCRIZIONI WHERE IDDESC=idDescrizione;
    gruppo2.RedirectEsito(idSessione,'Rimozione riuscita', null,null,null, null,'Torna all''opera','VisualizzaOpera','//operaID='||opid||'//lingue='||oplingua);
        DELETE FROM DESCRIZIONI WHERE IDDESC = idDescrizione;
        commit;
end RimozioneDescrizione;

Procedure StatisticheDescrizioni(
    idSessione NUMBER DEFAULT 0,
    operazione NUMBER DEFAULT 0
)IS
cursor liv is (SELECT livello, count(LIVELLO) as cliv
                FROM DESCRIZIONI GROUP by LIVELLO
                HAVING COUNT(LIVELLO)=(
                    SELECT max(levcount)
                    FROM (
                        SELECT livello, count(LIVELLO) levcount
                        FROM DESCRIZIONI
                        GROUP by LIVELLO
                    )));
cursor lin is (SELECT LINGUA, count(lingua) as clin
                FROM DESCRIZIONI GROUP by lingua
                HAVING COUNT(lingua)=(
                    SELECT max(lencount)
                    FROM (
                        SELECT LINGUA, count(lingua) lencount
                        FROM DESCRIZIONI
                        GROUP by LINGUA
                    )));
BEGIN
    MODGUI1.ApriPagina('StatisticheDescrizioni',idSessione);
        modGUI1.Header(idSessione);
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
        htp.prn('<h1 align="center">Statistiche descrizioni</h1>');
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
            modGUI1.ApriDiv('class="w3-section"');
                modGUI1.Collegamento('X',
                    'menuOpere?idSessione='||idSessione,
                    'w3-btn w3-large w3-red w3-display-topright');
                -- Form per mandare dati alla procedura di conferma
                htp.br;
                htp.prn('<h3><b>Livello più presente:</b></h3>');
                for k in liv
                LOOP
                htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                htp.prn(k.livello||' : '||k.cliv||' descrizioni presenti');
                htp.br;
                end LOOP;
                htp.br;
                htp.prn('<h3><b>Lingua più presente:</b></h3>');
                for j in lin
                LOOP
                htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                htp.prn(j.lingua||' : '||j.clin||' descrizioni presenti');
                htp.br;
                end LOOP;
                htp.br;htp.br;
                MODGUI1.chiudiDiv;
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
END StatisticheDescrizioni;

END gruppo2;
