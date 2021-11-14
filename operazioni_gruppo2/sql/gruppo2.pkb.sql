CREATE OR REPLACE PACKAGE BODY "FNICOLO".gruppo2 AS
 
/*
 * OPERAZIONI SULLE OPERE
 * - Inserimento ✅
 * - Modifica ✅  
 * - Visualizzazione ✅
 * - Cancellazione (rimozione) ✅  
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

procedure menuOpere (sessionID NUMBER DEFAULT NULL) is
    begin
        htp.prn('<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> ');
        modGUI1.ApriPagina('Opere',sessionID);
        modGUI1.Header(sessionID);
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
        modGUI1.ApriDiv('class="w3-center"');
        htp.prn('<h1>Opere</h1>'); --TITOLO
        if (sessionID=1)
        then
            modGUI1.Collegamento('Aggiungi','InserisciOpera?sessionID='||sessionID||'','w3-btn w3-round-xxlarge w3-black'); 
        end if;
        modGUI1.ChiudiDiv;
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
                        gruppo2.lingua(sessionID,opera.idOpera);

                        if sessionID = 1 then
                        -- parametro modifica messo a true: possibile fare editing dell'autore
                        
                        --bottone modifica
                        modGUI1.Collegamento('Modifica',
                            'ModificaOpera?sessionID='||sessionID||'&operaID='||opera.IdOpera||'&titoloOpera='||opera.titolo,
                            'w3-green w3-margin w3-button');
                        --bottone elimina
                        htp.prn('<button onclick="document.getElementById(''ElimOpera'||opera.idOpera||''').style.display=''block''" class="w3-margin w3-button w3-red w3-hover-white">Elimina</button>');
                        gruppo2.EliminazioneOpera(sessionID,opera.idOpera);
                    end if;
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
            END LOOP;
            
        modGUI1.chiudiDiv;
end menuOpere; 

--Procedura popUp per la conferma
procedure EliminazioneOpera(
    sessionID NUMBER default 0,
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
                            'RimozioneOpera?sessionID='||sessionID||'&operaID='||operaID,
                            'w3-button w3-block w3-green w3-section w3-padding');
                            htp.prn('<span onclick="document.getElementById(''ElimOpera'||operaID||''').style.display=''none''" class="w3-button w3-block w3-red w3-section w3-padding" title="Close Modal">Annulla</span>');
                        modGUI1.ChiudiDiv;
                    modGUI1.ChiudiForm;
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
end EliminazioneOpera;


--Procedura rimozione opera
procedure RimozioneOpera(
    sessionID NUMBER default 0,
    operaID NUMBER default 0   
)is
esposizione NUMBER(5);
BEGIN
    SELECT COUNT(*) INTO esposizione FROM saleopere WHERE opera=operaID AND datauscita IS NULL;
    IF esposizione > 0
    THEN
        gruppo2.EsitoNegativoOpere(sessionID);
    ELSE
        DELETE FROM OPERE WHERE idOpera = operaID;
        -- Ritorno al menu opere
        gruppo2.EsitoPositivoOpere(sessionID);
    END IF;

end RimozioneOpera;


--procedura popup  
procedure lingua(
    sessionID NUMBER default 0,
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
                        HTP.FORMHIDDEN('sessionID',sessionID);
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
    sessionID NUMBER DEFAULT NULL
    ) is /*feedbackPositivo*/
    begin
        modGUI1.ApriPagina('EsitoPositivoOpere',sessionID);
        modGUI1.Header(sessionID);
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:450px"');
                modGUI1.ApriDiv('class="w3-center"');
                htp.print('<h1>Operazione eseguita correttamente </h1>');
                MODGUI1.collegamento('Torna al menu','menuOpere?sessionID='||sessionID||'','w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
end EsitoPositivoOpere;

--Procedura per feedback 
procedure EsitoNegativoOpere(
    sessionID NUMBER DEFAULT NULL
    ) is /*feedbackPositivo*/
    begin
        modGUI1.ApriPagina('EsitoPositivoOpere',sessionID);
        modGUI1.Header(sessionID);
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:450px"');
                modGUI1.ApriDiv('class="w3-center"');
                htp.print('<h1>Operazione NON eseguita</h1>');
                MODGUI1.collegamento('Torna al menu','menuOpere?sessionID='||sessionID||'','w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
end EsitoNegativoOpere;

-- Procedura per l'inserimento di nuove Opere nella base di dati
PROCEDURE InserisciOpera(
    sessionID NUMBER DEFAULT NULL,
    titolo VARCHAR2 DEFAULT 'Sconosciuto',
    anno VARCHAR2 DEFAULT NULL,
    fineperiodo VARCHAR2 DEFAULT NULL,
    idmusei NUMBER DEFAULT NULL
) IS
BEGIN
    modGUI1.ApriPagina('InserisciOpera',sessionID);--DA MODIFICARE campo PROVA
            modGUI1.Header(sessionID);
            htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            htp.prn('<h1 align="center">Opera</h1>');--DA MODIFICARE
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
                modGUI1.ApriDiv('class="w3-section"');
                modGUI1.Collegamento('X','menuOpere?sessionID='||sessionID||'',' w3-btn w3-large w3-red w3-display-topright'); --Bottone per tornare indietro, cambiare COLLEGAMENTOPROVA
                --INIZIO SEZIONE DA MODIFICARE
                    modGUI1.ApriForm('ConfermaDatiOpera',NULL,'w3-container');
                        htp.FORMHIDDEN('sessionID',sessionID);
                        modGUI1.Label('Titolo*');
                        modGUI1.Inputtext('titolo', 'Titolo opera',1);
                        htp.br;
                        modGUI1.Label('Anno*');
                        modGUI1.Inputtext('anno', 'Anno realizzazione',1);
                        htp.br;
                        modGUI1.Label('Fine periodo');
                        modGUI1.Inputtext('fineperiodo', 'Periodo di realizzazione',0);
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
        modGUI1.ApriPagina('Conferma',sessionID);
        modGUI1.Header(sessionID);
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
            HTP.FORMHIDDEN('sessionID', sessionID);
            HTP.FORMHIDDEN('titolo', titolo);
            HTP.FORMHIDDEN('anno', anno);
            HTP.FORMHIDDEN('fineperiodo', fineperiodo);
            HTP.FORMHIDDEN('idmusei', idmusei);
            MODGUI1.InputSubmit('Conferma');
            MODGUI1.ChiudiForm;
            MODGUI1.ApriForm('InserisciOpera');
            HTP.FORMHIDDEN('sessionID', sessionID);
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
    sessionID NUMBER DEFAULT 0,
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
        gruppo2.EsitoPositivoOpere(sessionID);
		-- Ritorno al menu opere
        END IF;
END InserisciDatiOpera;


PROCEDURE ModificaOpera(
    sessionID NUMBER DEFAULT NULL,
    operaID NUMBER DEFAULT 0,
    titoloOpera VARCHAR2 DEFAULT 'Sconosciuto'
) IS
var NUMBER DEFAULT 0;
nomeMuseo VARCHAR2(30) DEFAULT NULL;
age NUMBER DEFAULT 0;
periodo NUMBER DEFAULT 0;
BEGIN
    modGUI1.ApriPagina('ModificaOpera',sessionID);--DA MODIFICARE campo PROVA
            modGUI1.Header(sessionID);
            htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            htp.prn('<h1 align="center">Modifica Opera</h1>');--DA MODIFICARE
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
                modGUI1.ApriDiv('class="w3-section"');
                modGUI1.Collegamento('X','menuOpere?sessionID='||sessionID||'',' w3-btn w3-large w3-red w3-display-topright'); --Bottone per tornare indietro, cambiare COLLEGAMENTOPROVA
                --INIZIO SEZIONE DA MODIFICARE
                    modGUI1.ApriForm('ConfermaUpdateOpera',NULL,'w3-container');
                        htp.FORMHIDDEN('sessionID',sessionID);
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
    sessionID NUMBER DEFAULT 0,
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
        modGUI1.ApriPagina('Conferma',sessionID);
        modGUI1.Header(sessionID);
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
            HTP.FORMHIDDEN('sessionID', sessionID);
            htp.FORMHIDDEN('operaID', operaID);
            HTP.FORMHIDDEN('newTitolo', titolo);
            HTP.FORMHIDDEN('newAnno', anno);
            HTP.FORMHIDDEN('newFineperiodo', fineperiodo);
            HTP.FORMHIDDEN('newIDmusei', idmusei);
            MODGUI1.InputSubmit('Conferma');
            MODGUI1.ChiudiForm;
            MODGUI1.ApriForm('ModificaOpera'); 
            HTP.FORMHIDDEN('sessionID', sessionID);
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
	sessionID NUMBER DEFAULT 0,
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
    gruppo2.EsitoPositivoOpere(sessionID);
END;



procedure VisualizzaOpera (
    sessionID NUMBER default 0,
    operaID NUMBER default 0,
    lingue VARCHAR2 default 'sconosciuto'
    ) is
    var1 VARCHAR2 (40);
    testo1 VARCHAR2 (100);
    num NUMBER(10);
    num1 NUMBER(10);
    num2 NUMBER(10);
    num3 NUMBER(10);


    varSala NUMBER(5) DEFAULT 0;
    varMuseo NUMBER(5) DEFAULT 0;
    varNomeStanza VARCHAR2(100) DEFAULT 'Sconosciuto';
    varNomeMuseo VARCHAR2(100) DEFAULT 'Sconosciuto';


    begin
        htp.prn('<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> ');
        modGUI1.Header(sessionID);
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
        modGUI1.ApriDiv('class="w3-center"');
        Select Titolo into var1 FROM OPERE WHERE idOpera=operaID;
            htp.prn('<h1><b>'||var1||'</b></h1>'); --TITOLO
        modGUI1.ChiudiDiv;
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

                        SELECT nome INTO varNomeMuseo FROM musei WHERE idmuseo=varMuseo;

                        END IF;

                        IF(varNomeMuseo='NonEsposta')
                        THEN
                            if(lingue='Italian')
                            then
                            htp.prn('<h5><b>Esposta: </b>❌</h5>');
                            end if;

                            if(lingue='English')
                            then
                            htp.prn('<h5><b>Exposed: </b>❌</h5>');
                            end if;

                            if(lingue='Chinese')
                            then
                            htp.prn('<h5><b>裸露: </b>❌</h5>');
                            end if;

                        ELSE
                            if(lingue='Italian')
                            then
                            htp.prn('<h5><b>Esposta: ✅</b></h5>'); 
                            htp.prn('<b>Museo: </b>'||varNomeMuseo);
                            htp.br;
                            htp.prn('<b>Sala: </b>'||varNomeStanza);
                            end if;
                            if(lingue='English')
                            then
                            htp.prn('<h5><b>Exposed: </b>✅</h5>');
                            htp.prn('<b>Museum: </b>'||varNomeMuseo);
                            htp.br;
                            htp.prn('<b>Room: </b>'||varNomeStanza);
                            end if;
                            if(lingue='Chinese')
                            then
                            htp.prn('<h5><b>裸露: </b>✅</h5>');
                            htp.prn('<b>博物馆: </b>'||varNomeMuseo);
                            htp.br;
                            htp.prn('<b>房间: </b>'||varNomeStanza);
                            end if;
                        END IF;
                       
                 
                    modGUI1.ChiudiDiv;
                    modGUI1.ApriDiv('class="w3-container w3-cell w3-cell-middle"');
                        if (sessionID=1)
                        then
                            modGUI1.Bottone('w3-green','Modifica');
                            htp.br;
                        end if;
                    modGUI1.ChiudiDiv;
            modGUI1.chiudiDiv;
            htp.br;
            htp.br;
        END LOOP;
        --FINE LOOP VISUALIZZAZIONE

end VisualizzaOpera;

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
PROCEDURE menuAutori(sessionID NUMBER DEFAULT NULL) is
BEGIN
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
                IF sessionID=1 THEN
                    -- parametro modifica messo a true: possibile fare editing dell'autore
                    modGUI1.Collegamento('Modifica',
                        'ModificaAutore?sessionID='||sessionID||'&authorID='||autore.IdAutore||'&operazione=1', 
                        'w3-green w3-margin w3-button');
                    -- TODO: sostituire con rimozione
                    modGUI1.Collegamento('Rimuovi', 
                        'ModificaAutore?sessionID='||sessionID||'&authorID='||autore.IdAutore||'&operazione=0', 
                        'w3-red w3-margin w3-button');
                END IF;
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
    END LOOP;
    modGUI1.chiudiDiv;
END menuAutori;

-- Procedura per l'inserimento di nuovi Autori nella base di dati
-- I parametri (a parte sessionID) sono usati per effettuare il riempimento automatico del form
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

    htp.prn('<h1 align="center">Inserimento Autore</h1>');
    modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
        modGUI1.ApriDiv('class="w3-section"');
            -- Link di ritorno al menuAutori
            modGUI1.Collegamento('X',
                'menuAutori?sessionID='||sessionID,
                'w3-btn w3-large w3-red w3-display-topright');
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
            HTP.FORMHIDDEN('sessionID', sessionID);
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
-- Oppure effettua rollback se non consentito
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
		-- Ritorno al menu Autori senza mostrare alcuna pagina web
        gruppo2.EsitoPositivoAutori(sessionID);
    ELSE
        rollback;
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
	sessionID NUMBER DEFAULT 0,
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
    modGUI1.ApriPagina(op_title||' Autore', sessionID);
	modGUI1.Header(sessionID);
	htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;

	modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px" ');
		modGUI1.ApriDiv('class="w3-section"');
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
            htp.formhidden('sessionID', sessionID);
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
    IF TO_DATE(newBirth, 'YYYY-MM-DD') > TO_DATE(newDeath, 'YYYY-MM-DD') THEN
		RAISE Errore_data;
	END IF;
	UPDATE Autori SET 
		Nome=newName, 
		Cognome=newSurname, 
		DataNascita=TO_DATE(newBirth, 'YYYY-MM-DD'), 
		DataMorte=TO_DATE(newDeath, 'YYYY-MM-DD'), 
		Nazionalita=newNation
	WHERE IdAutore=authID;
    
    commit;
    gruppo2.EsitoPositivoAutori(sessionID);

    EXCEPTION 
		WHEN Errore_data THEN
			DBMS_OUTPUT.PUT_LINE('Error');
            ROLLBACK;
END;
  
procedure EsitoPositivoAutori(
    sessionID NUMBER DEFAULT NULL
    ) is /*feedbackPositivo*/
    begin
        modGUI1.ApriPagina('EsitoPositivoAutori',sessionID);
        modGUI1.Header(sessionID);
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:450px"');
                modGUI1.ApriDiv('class="w3-center"');
                htp.print('<h1>Inserito correttamente </h1>');
                MODGUI1.collegamento('Torna al menu','menuAutori?sessionID='||sessionID||'','w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
end EsitoPositivoAutori;
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
