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
-- backToMenu: il nome del pulsante per tornare al menu (obbligatorio)
-- backToMenuURL: URL del menu a cui andare (obbligatorio)

procedure EsitoOperazione(
    idSessione NUMBER DEFAULT NULL,
    pageTitle VARCHAR2 DEFAULT NULL,
    msg VARCHAR2 DEFAULT NULL,
    nuovaOp VARCHAR2 DEFAULT NULL,
    nuovaOpURL VARCHAR DEFAULT NULL,
    backToMenu VARCHAR2 DEFAULT NULL,
    backToMenuURL VARCHAR2 DEFAULT NULL,
    parametri VARCHAR2 DEFAULT ''
    ) is
    begin
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
                    MODGUI1.collegamento(nuovaOp, nuovaOpURL||'?idSessione='||idSessione||'','w3-button w3-block w3-black w3-section w3-padding');
                end if;
                MODGUI1.collegamento(backToMenu, backToMenuURL||'?idSessione='||idSessione||parametri,'w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
end EsitoOperazione;

/*
 * OPERAZIONI SULLE OPERE
 * - Inserimento ✅
 * - Modifica ✅
 * - Visualizzazione ✅
 * - Cancellazione (rimozione) ✅
 * - Spostamento ❌
 * - Aggiunta Autore ❌
 * OPERAZIONI STATISTICHE E MONITORAGGIO
 * - Storico prestiti dell’Opera ✅
 * - Storico spostamenti relativi ad un Museo ❌
 * - Opera non spostata da più tempo ❌
 * - Autori dell’Opera ✅
 * - Tipo Sala in cui si trova l’Opera ✅
 * - Descrizioni dell’Opera ✅
 * - Lista Opere ordinate per numero di Autori in ordine decrescente ❌
 */

procedure menuOpere (idSessione NUMBER DEFAULT NULL) is
    begin
        htp.prn('<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> ');
        modGUI1.ApriPagina('Opere',idSessione);
        if idSessione IS NULL then
            modGUI1.Header;
        else
            modGUI1.Header(idSessione);
        end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;
        modGUI1.ApriDiv('class="w3-center"');
        htp.prn('<h1>Opere</h1>'); --TITOLO
        if (idSessione=1)
        then
            modGUI1.Collegamento('Inserisci','InserisciOpera?idSessione='||idSessione||'','w3-btn w3-round-xxlarge w3-black');
            htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
        end if;
            htp.prn('<button onclick="document.getElementById(''11'').style.display=''block''" class="w3-btn w3-round-xxlarge w3-black">Statistiche</button>');
        modGUI1.ChiudiDiv;
            gruppo2.selezioneMuseo(idSessione);
        htp.br;
        modGUI1.ApriDiv('class="w3-row w3-container"');
    --Visualizzazione TUTTE LE OPERE *temporanea*
            FOR opera IN (Select * from Opere)
            LOOP
                modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                    modGUI1.ApriDiv('class="w3-card-4" style="height:600px;"');
                    htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%;">');
                            modGUI1.ApriDiv('class="w3-container w3-center"');
                                htp.prn('<p>'|| opera.titolo ||'</p>');
                                htp.br;
                                htp.prn('<p>'|| opera.anno ||'</p>');
                            modGUI1.ChiudiDiv;
                        htp.prn('<button onclick="document.getElementById(''LinguaOpera'||opera.idOpera||''').style.display=''block''" class="w3-margin w3-button w3-black w3-hover-white">Visualizza</button>');
                        gruppo2.lingua(idSessione,opera.idOpera);

                        if idSessione = 1 then 
                        -- parametro modifica messo a true: possibile fare editing dell'autore

                        --bottone modifica
                        modGUI1.Collegamento('Modifica',
                            'ModificaOpera?idSessione='||idSessione||'='||opera.IdOpera||'='||opera.titolo,
                            'w3-green w3-margin w3-button');
                        --bottone elimina
                        htp.prn('<button onclick="document.getElementById(''ElimOpera'||opera.idOpera||''').style.display=''block''" class="w3-margin w3-button w3-red w3-hover-white">Elimina</button>');
                        gruppo2.EliminazioneOpera(idSessione,opera.idOpera);
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
                            select titolo INTO var1 FROM OPERE WHERE idOpera=operaId;
                            htp.prn('stai per rimuovere: '||var1);
                            modGUI1.Collegamento('Conferma',
                            'RimozioneOpera?idSessione='||idSessione||'0='||operaID,
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
        gruppo2.EsitoNegativoOpere(idSessione);
    ELSE
        DELETE FROM OPERE WHERE idOpera = operaID;
        -- Ritorno al menu opere
        gruppo2.EsitoPositivoOpere(idSessione);
    END IF;

end RimozioneOpera;


--procedura popup
procedure lingua(
    idSessione NUMBER default 0,
    operaID NUMBER default 0
)is /*Form popup lingua */
    begin
        modGUI1.ApriDiv('id="LinguaOpera'||operaID||'" class="w3-modal"');
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
                modGUI1.ApriDiv('class="w3-center"');
                    htp.br;
                    htp.prn('<span onclick="document.getElementById(''LinguaOpera'||operaID||''').style.display=''none''" class="w3-button w3-xlarge w3-red w3-display-topright" title="Close Modal">X</span>');
                htp.print('<h1>Seleziona la lingua</h1>');
                modGUI1.ChiudiDiv;
                    modGUI1.ApriForm('VisualizzaOpera','selezione lingue','w3-container');
                        HTP.FORMHIDDEN('idSessione',idSessione);
                        HTP.FORMHIDDEN('operaID',operaID);
                        modGUI1.ApriDiv('class="w3-section"');
                            htp.br;
                            htp.print('<h5>');
                            modGUI1.InputRadioButton('Italiano ', 'lingue', 'Italian', 0, 0);
                            modGUI1.InputRadioButton('English ', 'lingue', 'English', 0, 0);
                            modGUI1.InputRadioButton('中国人 ', 'lingue', 'Chinese', 0, 0);
                            htp.print('</h5>');
                            htp.br;
                            htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit">Seleziona</button>');
                        modGUI1.ChiudiDiv;
                    modGUI1.ChiudiForm;
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
end lingua;

--Procedura per feedback
procedure EsitoPositivoOpere(
    idSessione NUMBER DEFAULT NULL
    ) is /*feedbackPositivo*/
    begin
        modGUI1.ApriPagina('EsitoPositivoOpere',idSessione);
        if idSessione IS NULL then
            modGUI1.Header;
        else
            modGUI1.Header(idSessione);
        end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:450px"');
                modGUI1.ApriDiv('class="w3-center"');
                htp.print('<h1>Operazione eseguita correttamente </h1>');
                MODGUI1.collegamento('Inserisci nuova opera','inserisciOpera?idSessione='||idSessione||'','w3-button w3-block w3-black w3-section w3-padding');
                MODGUI1.collegamento('Torna al menu','menuOpere?idSessione='||idSessione||'','w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
end EsitoPositivoOpere;

--Procedura per feedback
procedure EsitoNegativoOpere(
    idSessione NUMBER DEFAULT NULL
    ) is /*feedbackPositivo*/
    begin
        modGUI1.ApriPagina('EsitoPositivoOpere',idSessione);
        if idSessione IS NULL then
            modGUI1.Header;
        else
            modGUI1.Header(idSessione);
        end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:450px"');
                modGUI1.ApriDiv('class="w3-center"');
                htp.print('<h1>Operazione NON eseguita</h1>');
                MODGUI1.collegamento('Torna al menu','menuOpere?idSessione='||idSessione||'','w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
end EsitoNegativoOpere;

--Home per le statistiche
procedure StatisticheOpere(
    idSessione NUMBER DEFAULT NULL
    ) is /*feedbackPositivo*/
    begin
        modGUI1.ApriPagina('EsitoPositivoOpere',idSessione);
        if idSessione IS NULL then
            modGUI1.Header;
        else
            modGUI1.Header(idSessione);
        end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
        modGUI1.ApriDiv('class="w3-center"');
        htp.prn('<h1>Statistiche opere</h1>'); --TITOLO
        modGUI1.ChiudiDiv;
end;

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
                        MODGUI1.SelectOpen('idmusei');
                        for museo in (SELECT idMuseo,nome FROM Musei)
                        loop
                        MODGUI1.SelectOption(museo.idMuseo,museo.nome);
                        end loop;
                        MODGUI1.SelectClose;
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
            (IdOperaSeq.NEXTVAL,titolo,anno,fineperiodo,idmusei);
        IF SQL%FOUND
        THEN
        -- faccio il commit dello statement precedente
        commit;
        gruppo2.EsitoPositivoOpere(idSessione);
		-- Ritorno al menu opere
        END IF;
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
                        MODGUI1.SelectOpen('idmusei');
                        MODGUI1.SelectOption(var, nomeMuseo, 1);
                        for museo in (SELECT idMuseo,nome FROM Musei)
                        loop
                        MODGUI1.SelectOption(museo.idMuseo, museo.nome);
                        end loop;
                        MODGUI1.SelectClose;
                        htp.br;
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
	UPDATE Opere SET
		titolo=newTitolo,
		anno=newAnno,
		fineperiodo=newFineperiodo,
		Museo=newIDmusei
	WHERE IdOpera=operaID;
    gruppo2.EsitoPositivoOpere(idSessione);
END;



procedure VisualizzaOpera (
    idSessione NUMBER default 0,
    operaID NUMBER default 0,
    lingue VARCHAR2 default 'sconosciuto'
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

    begin
        htp.prn('<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> ');
        if idSessione IS NULL then
            modGUI1.Header;
        else
            modGUI1.Header(idSessione);
        end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
        modGUI1.ApriDiv('class="w3-center"');
        Select Titolo into var1 FROM OPERE WHERE idOpera=operaID;
            htp.prn('<h1><b>'||var1||'</b></h1>'); --TITOLO
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
            gruppo2.spostamentiOpera(operaID);

        htp.br;
        modGUI1.ApriDiv('class="w3-container" style="width:100%"');
        FOR des IN (
                SELECT * FROM Descrizioni WHERE operaID=Opera AND lingue=lingua Order by livello
        )
        LOOP
            if(lingue='Italian')
            then
            htp.prn('<h2><b>Livello: </b>'||des.livello||'</h2>');
            end if;
            if(lingue='English')
            then
            htp.prn('<h2><b>Level: </b>'||des.livello||'</h2>');
            end if;
            if(lingue='Chinese')
            then
            htp.prn('<h2><b>等级: </b>'||des.livello||'</h2>');
            end if;
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
                                varTipoSala := 'mostra.';
                            ELSE
                                varTipoSala :='museale.';
                            END IF;

                        SELECT nome INTO varNomeMuseo FROM musei WHERE idmuseo=varMuseo;

                        END IF;

                        IF(varNomeMuseo='NonEsposta')
                        THEN
                            if(lingue='Italian')
                            then
                            htp.prn('<h5><b>Esposta: </b>❌</h5>');
                            htp.br;
                            htp.prn('<b>Autore: </b>');
                                FOR auth in Cur
                                LOOP
                                SELECT autori.NOME, autori.cognome INTO nomee, cognomee FROM autori WHERE idautore = auth.idautore;
                                htp.prn(''||nomee||' ');
                                htp.prn(''||cognomee||'');
                                htp.prn(',');
                                END LOOP;

                            end if;

                            if(lingue='English')
                            then
                            htp.prn('<h5><b>Exposed: </b>❌</h5>');
                            htp.br;
                            htp.prn('<b>Author: </b>');
                                FOR auth in Cur
                                LOOP
                                SELECT autori.NOME, autori.cognome INTO nomee, cognomee FROM autori WHERE idautore = auth.idautore;
                                htp.prn(''||nomee||' ');
                                htp.prn(''||cognomee||'');
                                htp.prn(',');
                                END LOOP;
                            end if;

                            if(lingue='Chinese')
                            then
                            htp.prn('<h5><b>裸露: </b>❌</h5>');
                            htp.br;
                            htp.prn('<b>作者: </b>');
                                FOR auth in Cur
                                LOOP
                                SELECT autori.NOME, autori.cognome INTO nomee, cognomee FROM autori WHERE idautore = auth.idautore;
                                htp.prn(''||nomee||' ');
                                htp.prn(''||cognomee||'');
                                htp.prn(',');
                                END LOOP;
                            end if;

                        ELSE

                            if(lingue='Italian')
                            then
                            htp.prn('<h5><b>Esposta: ✅</b></h5>');
                            htp.br;
                            htp.prn('<b>Museo: </b>'||varNomeMuseo||'.');
                            htp.br;
                            htp.prn('<b>Sala: </b>'||varNomeStanza||'<b> tipo di sala: </b>'||varTipoSala);
                            htp.br;
                            htp.prn('<b>Autore: </b>');
                                FOR auth in Cur
                                LOOP
                                SELECT autori.NOME, autori.cognome INTO nomee, cognomee FROM autori WHERE idautore = auth.idautore;
                                htp.prn(''||nomee||' ');
                                htp.prn(''||cognomee||'');
                                htp.prn(',');
                                END LOOP;
                            end if;

                            if(lingue='English')
                            then
                            htp.prn('<h5><b>Exposed: </b>✅</h5>');
                            htp.br;
                            htp.prn('<b>Museum: </b>'||varNomeMuseo||'.');
                            htp.br;
                            htp.prn('<b>Room: </b>'||varNomeStanza||'<b> type of room: </b>'||varTipoSala);
                            htp.br;
                            htp.prn('<b>Author: </b>');
                                FOR auth in Cur
                                LOOP
                                SELECT autori.NOME, autori.cognome INTO nomee, cognomee FROM autori WHERE idautore = auth.idautore;
                                htp.prn(''||nomee||' ');
                                htp.prn(''||cognomee||'');
                                htp.prn(',');
                                END LOOP;
                            end if;

                            if(lingue='Chinese')
                            then
                            htp.prn('<h5><b>裸露: </b>✅</h5>');
                            htp.br;
                            htp.prn('<b>博物馆: </b>'||varNomeMuseo||'.');
                            htp.br;
                            htp.prn('<b>房间: </b>'||varNomeStanza||'<b> 大厅类型: </b>'||varTipoSala);
                            htp.br;
                            htp.prn('<b>作者: </b>');
                                FOR auth in Cur
                                LOOP
                                SELECT autori.NOME, autori.cognome INTO nomee, cognomee FROM autori WHERE idautore = auth.idautore;
                                htp.prn(''||nomee||' ');
                                htp.prn(''||cognomee||'');
                                htp.prn(',');
                                END LOOP;
                            end if;

                        END IF;

                    modGUI1.ChiudiDiv;
                    modGUI1.ApriDiv('class="w3-container w3-cell w3-cell-middle"');
                        if (idSessione=1)
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


procedure SpostamentiOpera (
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
        SELECT nome into var1 FROM MUSEI where proprietario=idMuseo;
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
                            htp.print('<b>DA:</b>'||var1);
                            htp.br;htp.br;
                            htp.print('<b>DAL: </b>'||sal.dataarrivo);
                        modGUI1.ChiudiDiv;
                        modGUI1.ApriDiv('class="w3-container w3-cell"');
                            htp.print('<b> A:</b>'||nomeMuseo);
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
var1 VARCHAR2(100) default'sconosciuto';
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
            ELSE
                SELECT nome INTO var1 FROM MUSEI WHERE idMuseo=museoID;
                htp.prn('<h4><b>'||var1||'</b></h4>');
            END IF;
        modGUI1.ChiudiDiv;
        htp.br;


        --OPERE DA PIÙ VISTE
        modGUI1.ApriDiv('class="w3-container" style="width:100%"');
        htp.print('<h2><b>Opere più viste</b></h2>');
        --INIZIO LOOP DELLA VISUALIZZAZIONE
            FOR k IN 1..3 LOOP
                modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                    modGUI1.ApriDiv('class="w3-card-4"');
                    htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%">');
                            modGUI1.ApriDiv('class="w3-container w3-center"');
                            --INIZIO DESCRIZIONI
                                htp.prn('<p>Museo '|| k ||'</p>');
                                htp.prn('<p>testo di prova</p>');
                            --FINE DESCRIZIONI
                            modGUI1.ChiudiDiv;
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
            END LOOP;


        --OPERE DA PIÙ TEMPO NON SPOSTATE
        htp.print('<h2><b>Opere da più tempo esposte</b></h2>');
        modGUI1.ApriDiv('class="w3-container" style="width:100%"');
        --INIZIO LOOP DELLA VISUALIZZAZIONE
            FOR k IN 1..3 LOOP
                modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                    modGUI1.ApriDiv('class="w3-card-4"');
                    htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%">');
                            modGUI1.ApriDiv('class="w3-container w3-center"');
                            --INIZIO DESCRIZIONI
                                htp.prn('<p>Museo '|| k ||'</p>');
                                htp.prn('<p>testo di prova</p>');
                            --FINE DESCRIZIONI
                            modGUI1.ChiudiDiv;
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
            END LOOP;

        --OPERE PIÙ TEMPO ESPOSTE
        htp.print('<h2><b>Opere esposte per più</b></h2>');
        modGUI1.ApriDiv('class="w3-container" style="width:100%"');

            FOR k IN 1..3 LOOP
                modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                    modGUI1.ApriDiv('class="w3-card-4"');
                    htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%">');
                            modGUI1.ApriDiv('class="w3-container w3-center"');
                            --INIZIO DESCRIZIONI
                                htp.prn('<p>Museo '|| k ||'</p>');
                                htp.prn('<p>testo di prova</p>');
                            --FINE DESCRIZIONI
                            modGUI1.ChiudiDiv;
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
            END LOOP;
        modGUI1.chiudiDiv;
END;

/*
 * OPERAZIONI SUGLI AUTORI
 * - Inserimento ✅
 * - Modifica ✅
 * - Visualizzazione ✅
 * - Cancellazione (rimozione) ❌
 * OPERAZIONI STATISTICHE E MONITORAGGIO
 * - Opere realizzate dall’Autore ✅
 * - Musei con Opere dell’Autore esposte ✅
 * - Collaborazioni effettuate ❌
 * - Opere dell’Autore presenti in un Museo scelto ✅
 * - Autori in vita le cui Opere sono esposte in un Museo scelto ❌
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
                        select Nome,Cognome INTO aName,aSurname FROM Autori WHERE IdAutore=authorID;
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
        gruppo2.EsitoOperazione(
            idSessione,
            'Rimozione fallita',
            'L''autore ha delle opere nella base di dati',
            null, null,
            'Torna al menu Autori',
            'menuAutori');
    ELSE
        -- esito positivo: solo opzione per tornare al menu
         gruppo2.EsitoOperazione(
            idSessione,
            'Rimozione riuscita',
            null,
            null, null,
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
                MODGUI1.SelectClose;
                htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit">Seleziona</button>');
                modGUI1.ChiudiForm;
            ELSE
                modGUI1.ApriForm('selezioneMuseoAutoreStatistica');
                htp.FORMHIDDEN('idSessione',idSessione);
                htp.FORMHIDDEN('operazione',operazione);
                MODGUI1.SELECTOPEN('authID', 'authID');
                FOR an_auth IN (SELECT IdAutore,Nome,COGNOME FROM AUTORI ORDER BY NOME ASC)
                LOOP
                    nomecompleto := an_auth.Nome||' '||an_auth.cognome;
                    modGUI1.SELECTOPTION(an_auth.IdAutore, nomecompleto, 0);
                END LOOP;
                MODGUI1.SelectClose;
                htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit">Seleziona</button>');
                modGUI1.ChiudiForm;
            END IF;
            MODGUI1.chiudiDiv;
        modGUI1.ChiudiDiv;
    modGUI1.ChiudiDiv;
END selezioneAutoreStatistica;

Procedure StatisticheAutori(
    idSessione NUMBER DEFAULT 0,
    operazione NUMBER DEFAULT 0,
    authID NUMBER DEFAULT 0
)IS
auth Autori%ROWTYPE;
IDOPER number(5);
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
        htp.print('<h2><b>Opere realizzate</b></h2>');
            FOR op IN (Select *
                from OPERE JOIN AUTORIOPERE on (OPERE.idopera = AUTORIOPERE.idopera)
                WHERE IDAUTORE=AUTH.idautore)
            LOOP
                --SELECT idopera into IDOPER
                --from opere where OPERE.titolo=op.titolo;
                modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                    modGUI1.ApriDiv('class="w3-card-4" style="height:600px;"');
                    htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%;">');
                            modGUI1.ApriDiv('class="w3-container w3-center"');
                                htp.prn('<p>'|| op.titolo ||'</p>');
                                htp.br;
                                htp.prn('<p>'|| op.anno ||'</p>');
                                --htp.prn('<button onclick="document.getElementById(''LinguaOpera'||IDOPER||''').style.display=''block''" class="w3-margin w3-button w3-black w3-hover-white">Visualizza</button>');
                                --gruppo2.lingua(idSessione,idoper);
                            modGUI1.ChiudiDiv;
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
            END LOOP;
        end IF;

        --MUSEI CON OPERE ESPOSTE
        if operazione=1 THEN
        modGUI1.ApriDiv('class="w3-container" style="width:100%"');
        htp.print('<h2><b>Musei con opere esposte</b></h2>');
            FOR mus IN (Select DISTINCT *
                    from MUSEI where
                    IDMUSEO IN (select STANZE.MUSEO from stanze JOIN SALEOPERE on (stanze.IDSTANZA=SALEOPERE.SALA) where
                    saleopere.DATAUSCITA is null and SALEOPERE.OPERA in
                    (Select DISTINCT opere.IDOPERA
                        from OPERE JOIN AUTORIOPERE on (OPERE.idopera = AUTORIOPERE.idopera)
                        WHERE IDAUTORE=AUTH.idautore)))
            LOOP
                modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                    modGUI1.ApriDiv('class="w3-card-4" style="height:600px;"');
                    htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%;">');
                            modGUI1.ApriDiv('class="w3-container w3-center"');
                                htp.prn('<p>Museo '|| mus.Nome ||'</p>');
                                htp.prn('<p>testo di prova</p>');
                            modGUI1.ChiudiDiv;
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
            END LOOP;
        end IF;

        --COLLABORAZIONI EFFETTUATE -------da testare
        if operazione=2 THEN
        modGUI1.ApriDiv('class="w3-container" style="width:100%"');
        htp.print('<h2><b>Opere create in collaborazione</b></h2>');
            FOR op IN (select * FROM OPERE op1 where
                    op1.IDOPERA=(select DISTINCT a1.idopera from AUTORIOPERE a1,AUTORIOPERE a2 WHERE
                        (a1.idopera=a2.idopera) AND (a1.idautore<>a2.idautore)))
            LOOP
                modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                    modGUI1.ApriDiv('class="w3-card-4" style="height:600px;"');
                    htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%;">');
                            modGUI1.ApriDiv('class="w3-container w3-center"');
                                htp.prn('<p>'|| op.titolo ||'</p>');
                                htp.br;
                                htp.prn('<p>'|| op.anno ||'</p>');
                                htp.prn('<button onclick="document.getElementById(''LinguaOpera'||op.idopera||''').style.display=''block''" class="w3-margin w3-button w3-black w3-hover-white">Visualizza</button>');
                                gruppo2.lingua(idSessione,op.idopera);
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
            htp.FORMHIDDEN('authID',authID);
            MODGUI1.SELECTOPEN('museoID', 'museoID');
            FOR an_mus IN (SELECT IDMUSEO,NOME FROM MUSEI ORDER BY NOME ASC)
            LOOP
                modGUI1.SELECTOPTION(an_mus.idmuseo, an_mus.Nome, 0);
            END LOOP;
            MODGUI1.SelectClose;
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
BEGIN
SELECT * INTO auth FROM autori WHERE authID=IDAUTORE;
SELECT * INTO mus FROM MUSEI WHERE museoID=IDMUSEO;
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

        --OPERE ESPOSTE NEL MUSEO SCELTO
        if operazione=3 THEN
        modGUI1.ApriDiv('class="w3-container" style="width:100%"');
        htp.print('<h2><b>Opere realizzate esposte in '||mus.nome||'</b></h2>');
            FOR op IN (Select *
            from OPERE JOIN AUTORIOPERE on (OPERE.idopera = AUTORIOPERE.idopera)
                JOIN SALEOPERE ON (OPERE.IDOPERA=SALEOPERE.OPERA)
            WHERE IDAUTORE=AUTH.idautore AND SALEOPERE.SALA IN (
                    select STANZE.IDSTANZA from stanze WHERE STANZE.MUSEO=museoID
            ))
            LOOP
            SELECT idopera into IDOPER
            from opere where OPERE.titolo=op.titolo;
                modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                    modGUI1.ApriDiv('class="w3-card-4" style="height:600px;"');
                    htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%;">');
                            modGUI1.ApriDiv('class="w3-container w3-center"');
                                htp.prn('<p>'|| op.titolo ||'</p>');
                                htp.br;
                                htp.prn('<p>'|| op.anno ||'</p>');
                                htp.prn('<button onclick="document.getElementById(''LinguaOpera'||IDOPER||''').style.display=''block''" class="w3-margin w3-button w3-black w3-hover-white">Visualizza</button>');
                                gruppo2.lingua(idSessione,IDOPER);
                            modGUI1.ChiudiDiv;
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
            END LOOP;
        end IF;

END;


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
        -- uno dei parametri con vincoli ha valori non validi
        MODGUI1.APRIPAGINA('Errore', idSessione);
        HTP.BodyOpen;
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:1000px" ');
            modGUI1.label(' Errore: ');
            IF idSessione <> 1 THEN
                htp.prn('Operazione non autorizzata (controlla di essere loggato)');
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
			-- Un unico bottone OK per rimandare alla procedura di inserimento con autofill
            MODGUI1.ApriForm('InserisciAutore');
            HTP.FORMHIDDEN('idSessione', idSessione);
            HTP.FORMHIDDEN('authName', authName);
            HTP.FORMHIDDEN('authSurname', authSurname);
            HTP.FORMHIDDEN('dataNascita', dataNascita);
            HTP.FORMHIDDEN('dataMorte', dataMorte);
            HTP.FORMHIDDEN('nation', nation);
            MODGUI1.InputSubmit('OK');
        MODGUI1.ChiudiDiv;
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
        dbms_output.put_line('Error: '||sqlerrm);
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
    (IdAutoreSeq.NEXTVAL, authName, UPPER(authSurname), birth, death, nation);
    IF SQL%FOUND
    THEN
        -- faccio il commit dello statement precedente
        commit;
		-- Ritorno al menu Autori senza mostrare alcuna pagina web
        gruppo2.EsitoPositivoAutori(idSessione);
    ELSE
        rollback;
        MODGUI1.ApriPagina('Errore', idSessione);
        modGUI1.ApriDiv;
		    modGUI1.Label('Errore: ');
		    htp.prn('Fallito inserimento autore');
		modGUI1.ChiudiDiv;
    END IF;
    EXCEPTION
    WHEN AutorePresente THEN
        MODGUI1.ApriPagina('Errore', idSessione);
        MODGUI1.ApriDiv;
            HTP.PRN('Autore già presente');
            MODGUI1.collegamento('Inserisci nuovo autore', 'InserisciAutore');
            MODGUI1.collegamento('Torna al menu autori', 'menuAutori');
        MODGUI1.ChiudiDiv;
END;

-- Procedura per visualizzare/modificare un Autore presente nella base di dati
-- (raggiungibile dal menuAutori)
-- Il parametro operazione assume uno tra i seguenti valori:
--  0: Visualizzazione
--  1: Modifica
--  2: Rimozione
PROCEDURE ModificaAutore(
	idSessione NUMBER DEFAULT 0,
	authorID NUMBER DEFAULT 0,
    operazione NUMBER DEFAULT 0
) IS
this_autore Autori%ROWTYPE;
op_title VARCHAR2(25);
BEGIN
    SELECT * INTO this_autore FROM Autori where IdAutore = authorID;
    IF operazione = 0 THEN
        op_title := 'Visualizza';
    ELSIF operazione = 1 THEN
        op_title := 'Modifica';
	ELSE
		op_title := 'Rimuovi';
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
		-- caso modifica o rimozione
		IF operazione != 0 THEN
            -- form con action diverse a seconda dell'operazione
			IF operazione = 1 THEN
                modGUI1.ApriForm('UpdateAutore');
            ELSE
                modGUI1.ApriForm('RemoveAutore');
            END IF;
            htp.formhidden('idSessione', idSessione);
            htp.formhidden('authID', this_autore.IdAutore);
            IF operazione = 1 THEN
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
            END IF;
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
    gruppo2.EsitoPositivoUpdateAutori(idSessione);

    EXCEPTION
		WHEN Errore_data THEN
			gruppo2.EsitoNegativoUpdateAutori(idSessione, authID);
            ROLLBACK;
END;

procedure EsitoPositivoAutori(
    idSessione NUMBER DEFAULT NULL
    ) is /*feedbackPositivo*/
    begin
        modGUI1.ApriPagina('EsitoPositivoAutori',idSessione);
        if idSessione IS NULL then
            modGUI1.Header;
        else
            modGUI1.Header(idSessione);
        end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:450px"');
                modGUI1.ApriDiv('class="w3-center"');
                htp.print('<h1>Autore inserito correttamente </h1>');
                MODGUI1.collegamento('Inserisci nuovo autore','inserisciAutore?idSessione='||idSessione||'','w3-button w3-block w3-black w3-section w3-padding');
                MODGUI1.collegamento('Torna al menu','menuAutori?idSessione='||idSessione||'','w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
end EsitoPositivoAutori;

procedure EsitoPositivoUpdateAutori(
    idSessione NUMBER DEFAULT NULL
    ) is /*feedbackPositivo*/
    begin
        modGUI1.ApriPagina('EsitoPositivoUpdateAutori',idSessione);
        if idSessione IS NULL then
            modGUI1.Header;
        else
            modGUI1.Header(idSessione);
        end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:450px"');
                modGUI1.ApriDiv('class="w3-center"');
                htp.print('<h1>Aggiornamento eseguito correttamente </h1>');
                MODGUI1.collegamento('Torna al menu','menuAutori?idSessione='||idSessione||'','w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
end EsitoPositivoUpdateAutori;

procedure EsitoNegativoUpdateAutori(
    idSessione NUMBER DEFAULT 0,
    authorID VARCHAR2 DEFAULT 'Sconosciuto'
) is /*feedbackNegativo*/
    begin
        modGUI1.ApriPagina('EsitoNegativoUpdateAutori',idSessione);
        if idSessione IS NULL then
            modGUI1.Header;
        else
            modGUI1.Header(idSessione);
        end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:450px"');
                modGUI1.ApriDiv('class="w3-center"');
                htp.print('<h1>Errore: data di nascita postuma alla data di morte</h1>');
                MODGUI1.ApriForm('ModificaAutore');
                HTP.FORMHIDDEN('idSessione', idSessione);
                HTP.FORMHIDDEN('authorID', authorID);
                HTP.FORMHIDDEN('operazione', 1);
                MODGUI1.InputSubmit('Torna indietro');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
end EsitoNegativoUpdateAutori;

/*
 * OPERAZIONI SULLE DESCRIZIONI
 * - Inserimento ❌
 * - Modifica ✅
 * - Visualizzazione ❌
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
bambino_selected NUMBER(1) := 0;
adulto_selected NUMBER(1) := 0;
esperto_selected NUMBER(1) := 0;
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
        modGUI1.Collegamento('X','TODO?idSessione='||idSessione,' w3-btn w3-large w3-red w3-display-topright');
        -- Form per mandare dati alla procedura di conferma
        modGUI1.ApriForm('ConfermaDatiDescrizione');
        htp.FORMHIDDEN('idSessione',idSessione);
        htp.br;
        MODGUI1.Label('Lingua*'); -- TODO: usare dropdown per avere nome standardizzato
        MODGUI1.InputText('language', def_lingua, 1, language);
        htp.br;
        -- Codice per autoselezione livello

        IF d_level = 'bambino' THEN
            bambino_selected := 1;
        ELSIF d_level = 'adulto' THEN
            adulto_selected := 1;
        ELSIF d_level = 'esperto' THEN
            esperto_selected := 1;
        END IF;
        MODGUI1.Label('Livello*');
        modGUI1.InputRadioButton('Bambino', 'd_level', 'bambino', bambino_selected, 0);
        modGUI1.InputRadioButton('Adulto', 'd_level', 'adulto', adulto_selected, 0);
        modGUI1.InputRadioButton('Esperto', 'd_level', 'esperto', esperto_selected, 0);
        htp.br;
        MODGUI1.Label('Testo descrizione*');
        HTP.BR;
        MODGUI1.InputTextArea('d_text', def_descr, 1); -- FIXME: autofill
        HTP.BR;
        MODGUI1.Label('Opera*');
        -- Menu a tendina per selezione dell'opera: viene scelto il titolo dall'utente
        -- ed inviato l'ID alla procedura chiamata (ConfermaDatiDescrizione)
        MODGUI1.SELECTOPEN('operaID', 'operaID');
        FOR an_opera IN (SELECT IdOpera,Titolo FROM Opere ORDER BY Titolo ASC)
        LOOP
            modGUI1.SELECTOPTION(an_opera.IdOpera, an_opera.Titolo, 0);
        END LOOP;
        MODGUI1.SelectClose;
        MODGUI1.InputSubmit('Inserisci');
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
    --SELECT * INTO Opera FROM Opere WHERE IdOpera=operaID;
    IF true
    THEN
    -- faccio il commit dello statement precedente
        commit;

        modGUI1.ApriPagina('Descrizione inserita',idSessione);
        if idSessione IS NULL then
            modGUI1.Header;
        else
            modGUI1.Header(idSessione);
        end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;

        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:450px"');
            modGUI1.ApriDiv('class="w3-center"');
            htp.print('<h1>Descrizione inserita correttamente</h1>');
            MODGUI1.collegamento(
                'Inserisci una nuova descrizione',
                'InserisciDescrizione?idSessione='||idSessione||'',
                'w3-button w3-block w3-black w3-section w3-padding');
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
     ELSE
    -- opera non presente: eccezione
        RAISE OperaInesistente;
    END IF;

    EXCEPTION
        WHEN OperaInesistente THEN
        -- TODO: msg errore opera non esiste
    DBMS_OUTPUT.PUT_LINE('Errore');
   END;

PROCEDURE modificaDescrizione(
        idSessione NUMBER DEFAULT 0,
        idDescrizione NUMBER DEFAULT NULL
) IS
DESCR descrizioni%ROWTYPE;
tit VARCHAR2(100);
bambino_selected NUMBER(1) := 0;
adulto_selected NUMBER(1) := 0;
esperto_selected NUMBER(1) := 0;
italian_selected NUMBER(1) := 0;
English_selected NUMBER(1) := 0;
Chinese_selected NUMBER(1) := 0;
BEGIN
select * INTO DESCR FROM DESCRIZIONI WHERE IdDesc=idDescrizione;
select titolo into tit from opere where Descr.opera=IDOPERA;
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
                    MODGUI1.SelectClose;
                    htp.br;
                    IF DESCR.lingua = 'Italian' THEN
                    italian_selected := 1;
                    ELSIF DESCR.lingua = 'English' THEN
                    English_selected := 1;
                    ELSIF DESCR.lingua = 'Chinese' THEN
                    Chinese_selected := 1;
                    END IF;
                    modGUI1.Label('Lingua*');
                        modGUI1.InputRadioButton('Italiano ', 'newlingua', 'Italian', italian_selected, 0);
                        modGUI1.InputRadioButton('English ', 'newlingua', 'English', English_selected, 0);
                        modGUI1.InputRadioButton('中国人 ', 'newlingua', 'Chinese', Chinese_selected, 0);
                    htp.br;
                    IF DESCR.livello = 'bambino' THEN
                    bambino_selected := 1;
                    ELSIF DESCR.livello = 'adulto' THEN
                    adulto_selected := 1;
                    ELSIF DESCR.livello = 'esperto' THEN
                    esperto_selected := 1;
                    END IF;
                    modGUI1.Label('Livello*');
                    modGUI1.InputRadioButton('Bambino', 'newlivello', 'bambino', bambino_selected, 0);
                    modGUI1.InputRadioButton('Adulto', 'newlivello', 'adulto', adulto_selected, 0);
                    modGUI1.InputRadioButton('Esperto', 'newlivello', 'esperto', esperto_selected, 0);
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
    gruppo2.EsitoPositivoUpdateDescrizioni(idSessione, newopera, newlingua);

    EXCEPTION
		WHEN Errore_data THEN
			gruppo2.EsitoPositivoUpdateDescrizioni(idSessione, newopera, newlingua);
            ROLLBACK;
END;

procedure EsitoPositivoUpdateDescrizioni(
    idSessione NUMBER DEFAULT NULL, 
    opera number DEFAULT 0,
    lingua varchar2 DEFAULT null
    ) is /*feedbackPositivo*/
    begin
        modGUI1.ApriPagina('EsitoPositivoUpdateDescrizioni',idSessione);
        if idSessione IS NULL then
            modGUI1.Header;
        else
            modGUI1.Header(idSessione);
        end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:450px"');
                modGUI1.ApriDiv('class="w3-center"');
                htp.print('<h1>Aggiornamento eseguito correttamente </h1>');
                MODGUI1.collegamento('Torna all''opera','VisualizzaOpera?idSessione='||idSessione||'&operaID='||opera||'&lingue='||lingua,'w3-button w3-block w3-black w3-section w3-padding');
                MODGUI1.collegamento('Torna al menu','menuOpere?idSessione='||idSessione||'','w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
end EsitoPositivoUpdateDescrizioni;

procedure EsitoNegativoUpdateDescrizioni(
    idSessione NUMBER DEFAULT NULL, 
    opera number DEFAULT 0,
    lingua varchar2 DEFAULT null
    ) is /*feedbackNegativo*/
    begin
        modGUI1.ApriPagina('EsitoNegativoUpdateDescrizioni',idSessione);
        if idSessione IS NULL then
            modGUI1.Header;
        else
            modGUI1.Header(idSessione);
        end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:450px"');
                modGUI1.ApriDiv('class="w3-center"');
                htp.print('<h1>Aggiornamento non eseguito</h1>');
                MODGUI1.collegamento('Torna all''opera','VisualizzaOpera?idSessione='||idSessione||'&operaID='||opera||'&lingue='||lingua,'w3-button w3-block w3-black w3-section w3-padding');
                MODGUI1.collegamento('Torna al menu','menuOpere?idSessione='||idSessione||'','w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
end EsitoNegativoUpdateDescrizioni;

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
                        select Lingua,Livello INTO dLingua,dLivello FROM DESCRIZIONI WHERE IDDESC=idDescrizione;
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
    select Opera, LINGUA into opid, oplingua
    from DESCRIZIONI where IDDESC=idDescrizione;
    gruppo2.EsitoOperazione(idSessione,'Rimozione riuscita', null,null, null,'Torna all''opera','VisualizzaOpera','&operaID='||opid||'&lingue='||oplingua);
        DELETE FROM DESCRIZIONI WHERE IDDESC = idDescrizione;
        commit;
end RimozioneDescrizione;

Procedure StatisticheDescrizioni(
    idSessione NUMBER DEFAULT 0,
    operazione NUMBER DEFAULT 0
)IS
cursor liv is (select livello, count(LIVELLO) as cliv
                from DESCRIZIONI GROUP by LIVELLO
                HAVING COUNT(LIVELLO)=(
                    SELECT max(levcount)
                    from (
                        SELECT livello, count(LIVELLO) levcount
                        from DESCRIZIONI
                        GROUP by LIVELLO
                    )));
cursor lin is (select LINGUA, count(lingua) as clin
                from DESCRIZIONI GROUP by lingua
                HAVING COUNT(lingua)=(
                    SELECT max(lencount)
                    from (
                        SELECT LINGUA, count(lingua) lencount
                        from DESCRIZIONI
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
