CREATE OR REPLACE PACKAGE BODY gruppo2 AS
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
 * - Autori dell’Opera ✅
 * - Tipo Sala in cui si trova l’Opera ✅
 * - Descrizioni dell’Opera ✅
 * - Lista Opere ordinate per numero di Autori in ordine decrescente ✅
 * - Opere non spostata da più tempo (le tre più vecchie) ✅
 * - Opere esposte per più tempo (le tre più vecchie)✅
 * - Età media delle opere ✅ 
 * - Ordinamento per anno di realizzazione (le tre più vecchie) ✅ 
 */ 
 
procedure menuOpere( 
    orderBy varchar2 default 'Titolo',
    nameFilter varchar2 default '',
    MuseoFilter int default 0,
    AutoriFilter int default 0,
    AnnoFilterInizio int default 0,
    AnnoFilterFine int default 3000
    )IS 
    var1 varchar2 (40) := orderby;
    idSessione NUMBER(5) := modgui1.get_id_sessione();
    Inizio NUMBER(5) := AnnoFIlterInizio;
    Fine NUMBER (5) := AnnoFIlterFine;
    Temp NUMBER (5);
    BEGIN

        htp.prn('<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> ');
        modGUI1.ApriPagina('Opere',idSessione);
        modGUI1.Header;

        htp.br;htp.br;htp.br;htp.br;htp.br;
        modGUI1.ApriDiv('class="w3-center"');
        htp.prn('<h1>Opere</h1>');
        if hasRole(idSessione, 'DBA') or hasRole(idSessione, 'GO')
        then
            modGUI1.Collegamento('Inserisci opera',gruppo2.gr2||'InserisciOpera','w3-btn w3-round-xxlarge w3-black');
            htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
            modGUI1.Collegamento('Inserisci descrizione',gruppo2.gr2||'InserisciDescrizione','w3-btn w3-round-xxlarge w3-black');
            htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
            modGUI1.Collegamento('Opere Eliminate',gruppo2.gr2||'menuOpereEliminate','w3-btn w3-round-xxlarge w3-black');

            htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
            htp.prn('<button onclick="document.getElementById(''11'').style.display=''block''"'
                ||' class="w3-btn w3-round-xxlarge w3-black">Statistiche Opere</button>');
            htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
        end if;
 
        IF hasRole(idSessione, 'DBA') or hasRole(idSessione, 'GO') or hasRole(idSessione, 'SU') THEN
            modGUI1.Collegamento('Statistiche Descrizioni',
                gruppo2.gr2||'statisticheDescrizioni',
                'w3-btn w3-round-xxlarge w3-black');
                htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
            htp.prn('<button onclick="document.getElementById(''filtraOpere'').style.display=''block''"'
            ||' class="w3-btn w3-round-xxlarge w3-black">Filtra</button>');
            modGUI1.ApriDiv('class="w3-right"');
            modGUI1.Collegamento('Rimuovi filtri',gruppo2.gr2||'menuOpere','w3-btn w3-round-xxlarge w3-red');
            htp.print('&nbsp;&nbsp;');
            modGUI1.ChiudiDiv;
        END IF;
        modGUI1.ChiudiDiv;
        --Fuori dal div per evitare centraggio bottoni nel popup
        gruppo2.filtraOpere;
        gruppo2.selezioneMuseo;
        
        IF AnnoFilterFine < AnnoFilterInizio THEN
            Temp:=Inizio;
            Inizio:=Fine;
            Fine:=Temp;
        END IF;

        --Visualizzazione TUTTE LE OPERE *temporanea*

        modGUI1.ApriDiv('class="w3-row w3-container"');
        FOR opera IN ( 
            SELECT DISTINCT Opere.* FROM Opere, AutoriOpere  
            WHERE   Eliminato = 0 
                    AND museo = 
                        (case when museoFilter=0 then museo else museoFilter end)
                    AND AutoriOpere.idAutore=
                        (case when autoriFilter=0 then AutoriOpere.idAutore else autoriFilter end)

                    AND UPPER(Titolo) LIKE '%'||UPPER(nameFilter)||'%'

                    AND Opere.Anno BETWEEN Inizio AND Fine

            ORDER BY
            case when orderby= 'Titolo' then Titolo end asc,
            case when orderby= 'Anno' then Anno end asc
            )
        LOOP
            modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                modGUI1.ApriDiv('class="w3-card-4" style="height:600px;"');
                htp.prn('<img src="https://www.stateofmind.it/wp-content/uploads/2018/01/La-malattia-rappresentata-nelle-opere-darte-e-in-letteratura-680x382.jpg" alt="Alps" style="width:100%;">');
                        modGUI1.ApriDiv('class="w3-container w3-center"');
                            htp.prn('<p><b>Titolo: </b>' || SUBSTR(opera.titolo,0,60)||'<br>'|| SUBSTR(opera.titolo,61,100)  ||'</p>');
                            htp.br;
                            htp.prn('<p><b>Anno: </b>'|| opera.anno ||'</p>');
                        modGUI1.ChiudiDiv;
                    htp.prn('<button onclick="document.getElementById(''LinguaeLivelloOpera'||opera.idOpera||''').style.display=''block''" class="w3-margin w3-button w3-black w3-hover-white">Visualizza</button>');
                    gruppo2.linguaELivello(opera.idOpera);

                    if hasRole(idSessione, 'DBA') or hasRole(idSessione, 'GO') then
                    --bottone modifica
                    modGUI1.Collegamento('Modifica',
                        gruppo2.gr2||'ModificaOpera?&operaID='||opera.IdOpera||'&titoloOpera='||opera.titolo,
                        'w3-green w3-margin w3-button');
                    --bottone elimina
                    htp.prn('<button onclick="document.getElementById(''ElimOpera'||opera.idOpera||''').style.display=''block''" class="w3-margin w3-button w3-red w3-hover-white">Elimina</button>');
                    gruppo2.EliminazioneOpera(opera.idOpera);
                    htp.br;
                end if;
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
        END LOOP;

        modGUI1.chiudiDiv;
end menuOpere;


procedure menuOpereEliminate is
idSessione NUMBER(5) := modgui1.get_id_sessione();
BEGIN
    htp.prn('<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> ');
    modGUI1.ApriPagina('Opere', idSessione);
    modGUI1.Header;

    htp.br;htp.br;htp.br;htp.br;htp.br;
    modGUI1.ApriDiv('class="w3-center"');
    htp.prn('<h1>Opere Eliminate</h1>');
    modGUI1.Collegamento('Torna al menù Opere',gruppo2.gr2||'menuOpere','w3-btn w3-round-xxlarge w3-black');
    htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
    modGUI1.ChiudiDiv;
        gruppo2.selezioneMuseo;
    htp.br;
    modGUI1.ApriDiv('class="w3-row w3-container"');
--Visualizzazione TUTTE LE OPERE *temporanea*
        FOR opera IN (SELECT * FROM Opere WHERE Eliminato = 1 ORDER BY Titolo)
        LOOP
            modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                modGUI1.ApriDiv('class="w3-card-4" style="height:600px;"');
                htp.prn('<img src="https://www.stateofmind.it/wp-content/uploads/2018/01/La-malattia-rappresentata-nelle-opere-darte-e-in-letteratura-680x382.jpg" alt="Alps" style="width:100%;">');
                        modGUI1.ApriDiv('class="w3-container w3-center"');
                            htp.prn('<p><b>Titolo: </b>' || SUBSTR(opera.titolo,0,60)||'<br>'|| SUBSTR(opera.titolo,61,100)  ||'</p>');
                            htp.br;
                            htp.prn('<p><b>Anno: </b>'|| opera.anno ||'</p>');
                        modGUI1.ChiudiDiv;
                    htp.prn('<button onclick="document.getElementById(''LinguaeLivelloOpera'||opera.idOpera||''').style.display=''block''" class="w3-margin w3-button w3-black w3-hover-white">Visualizza</button>');
                    gruppo2.linguaELivello(opera.idOpera);
                    htp.print('&nbsp;');
                    if hasRole(idSessione, 'DBA') or hasRole(idSessione, 'SU') then
                    --bottone elimina
                    modGUI1.Collegamento('Ripristina',gruppo2.gr2||'ripristinaOpera?operaID='||opera.idOpera,'w3-btn w3-green');
                    htp.print('&nbsp;');
                    htp.prn('<button onclick="document.getElementById(''ElimOperaDef'||opera.idOpera||''').style.display=''block''" class="w3-margin w3-button w3-red w3-hover-white">Elimina</button>');
                    gruppo2.EliminazioneDefinitivaOpera(opera.idOpera);
                    htp.br;
                end if;
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
        END LOOP;
    modGUI1.chiudiDiv;
end menuOpereEliminate;

procedure ripristinaOpera(
    operaID NUMBER DEFAULT 0
) IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
op Opere%ROWTYPE;
BEGIN
    SELECT * INTO op from opere where idOpera=operaID;
    UPDATE opere SET eliminato=0 WHERE idOpera=operaID; 
    modGUI1.RedirectEsito('Ripristino riuscito', 
            'L''opera '||op.titolo||' è stato ripristinata', 
            'Torna al menu opere eliminate', gruppo2.gr2||'menuOpereEliminate', null,
            'Torna al menu opere', gruppo2.gr2||'MenuOpere', null);
END;

--Procedura popUp per la conferma
procedure EliminazioneDefinitivaOpera(
    operaID NUMBER default 0
)is /*Form popup lingua */
var1 VARCHAR2(100);
idSessione NUMBER(5) := modgui1.get_id_sessione();
BEGIN
    modGUI1.ApriDiv('id="ElimOperaDef'||operaID||'" class="w3-modal"');
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
            modGUI1.ApriDiv('class="w3-center"');
                htp.br;
                htp.prn('<span onclick="document.getElementById(''ElimOperaDef'||operaID||''').style.display=''none''" class="w3-button w3-xlarge w3-red w3-display-topright" title="Close Modal">X</span>');
            htp.print('<h1><b>Confermi?</b></h1>');
            modGUI1.ChiudiDiv;
                    modGUI1.ApriDiv('class="w3-section"');
                        htp.br;
                        SELECT titolo INTO var1 FROM OPERE WHERE idOpera=operaId;
                        htp.prn('stai per rimuovere: '||var1);
                        modGUI1.Collegamento('Conferma',
                        gruppo2.gr2||'RimozioneDefinitivaOpera?operaID='||operaID,
                        'w3-button w3-block w3-green w3-section w3-padding');
                        htp.prn('<span onclick="document.getElementById(''ElimOperaDef'||operaID||''').style.display=''none''" class="w3-button w3-block w3-red w3-section w3-padding" title="Close Modal">Annulla</span>');
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiForm;
        modGUI1.ChiudiDiv;
    modGUI1.ChiudiDiv;
end EliminazioneDefinitivaOpera;

procedure RimozioneDefinitivaOpera(
    operaID NUMBER default 0
)is
idSessione NUMBER(5) := modgui1.get_id_sessione();
esposizione NUMBER(5);
BEGIN
    SELECT COUNT(*) INTO esposizione FROM saleopere WHERE opera=operaID AND datauscita IS NULL;
    IF esposizione > 0
    THEN
        MODGUI1.RedirectEsito('Eliminazione NON eseguita', 'Controlla i vincoli d''integrità.',
            null,null,null,
            'Torna alle opere',gruppo2.gr2||'menuOpereEliminate',null);
    ELSE
        DELETE FROM saleopere WHERE opera = operaID;
        DELETE FROM autoriopere WHERE idopera = operaID;
        DELETE FROM descrizioni WHERE opera = operaID;
        DELETE FROM OPERE WHERE idOpera = operaID;
        -- Ritorno al menu opere
        MODGUI1.RedirectEsito('Eliminazione riuscita', null,
            'Torna al menu opere eliminate', gruppo2.gr2||'menuOpereEliminate', null,
            'Torna al menu opere', gruppo2.gr2||'MenuOpere', null);
    END IF;
end RimozioneDefinitivaOpera;

--Procedura popUp per la conferma
procedure EliminazioneOpera(
    operaID NUMBER default 0
)is /*Form popup lingua */
idSessione NUMBER(5) := modgui1.get_id_sessione();
var1 VARCHAR2(100);
    BEGIN
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
                            gruppo2.gr2||'RimozioneOpera?operaID='||operaID,
                            'w3-button w3-block w3-green w3-section w3-padding');
                            htp.prn('<span onclick="document.getElementById(''ElimOpera'||operaID||''').style.display=''none''" class="w3-button w3-block w3-red w3-section w3-padding" title="Close Modal">Annulla</span>');
                        modGUI1.ChiudiDiv;
                    modGUI1.ChiudiForm;
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
end EliminazioneOpera;

--Procedura rimozione opera
procedure RimozioneOpera(
    operaID NUMBER default 0
)is
idSessione NUMBER(5) := modgui1.get_id_sessione();
esposizione NUMBER(5);
BEGIN
    SELECT COUNT(*) INTO esposizione FROM saleopere WHERE opera=operaID AND datauscita IS NULL;
    IF esposizione > 0
    THEN
        MODGUI1.RedirectEsito('Eliminazione NON eseguita', 'Controlla i vincoli d''integrità.',
            null,null,null,
            'Torna alle opere',gruppo2.gr2||'menuOpere',null);
    ELSE
        UPDATE opere SET Eliminato = 1 WHERE idopera = operaID;
        -- Ritorno al menu opere
        MODGUI1.RedirectEsito('Eliminazione completata', null,
            'Vai al menù opere eliminate',gruppo2.gr2||'menuOpereEliminate',null,
            'Torna alle opere',gruppo2.gr2||'menuOpere',null);
    END IF;
end RimozioneOpera;

--procedura popup
procedure linguaELivello(
    operaID NUMBER default 0
)is /*Form popup lingua e livello */
idSessione NUMBER(5) := modgui1.get_id_sessione();
BEGIN
    modGUI1.ApriDiv('id="LinguaeLivelloOpera'||operaID||'" class="w3-modal"');
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
            modGUI1.ApriDiv('class="w3-center"');
                htp.br;
                htp.prn('<span onclick="document.getElementById(''LinguaeLivelloOpera'||operaID||''').style.display=''none''" class="w3-button w3-xlarge w3-red w3-display-topright" title="Close Modal">X</span>');
            htp.print('<h1>Seleziona la lingua</h1>');
            modGUI1.ChiudiDiv;
                modGUI1.ApriForm(gruppo2.gr2||'VisualizzaOpera','selezione lingue','w3-container');
                    -- aggiunto attributo id="hiddenOperaID" per script in statisticheAutori()
                    -- Nicola --
                    HTP.FORMHIDDEN('operaID',operaID, 'id="hiddenOperaID"');
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
    titolo VARCHAR2 DEFAULT 'Sconosciuto',
    anno VARCHAR2 DEFAULT NULL,
    fineperiodo VARCHAR2 DEFAULT NULL,
    idmusei NUMBER DEFAULT NULL
) IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
placeholderTitolo VARCHAR2(255) := 'Titolo opera';
placeholderAnno VARCHAR2(255) := 'Anno realizzazione';
placeholderPeriodo VARCHAR2(255) := 'Periodo di realizzazione';
BEGIN
    modGUI1.ApriPagina('InserisciOpera',idSessione);
    modGUI1.Header;
    htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;

    htp.prn('<h1 align="center">Inserimento Opera</h1>');
    modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
        modGUI1.ApriDiv('class="w3-section"');
        modGUI1.Collegamento('X',gruppo2.gr2||'menuOpere',' w3-btn w3-large w3-red w3-display-topright'); --Bottone per tornare indietro, cambiare COLLEGAMENTOPROVA
            modGUI1.ApriForm(gruppo2.gr2||'ConfermaDatiOpera',NULL,'w3-container');
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
    titolo VARCHAR2 DEFAULT 'Sconosciuto',
    anno VARCHAR2 DEFAULT NULL,
    fineperiodo VARCHAR2 DEFAULT NULL,
    idmusei NUMBER DEFAULT NULL
) IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
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
        modGUI1.Header;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
        htp.prn('<h1 align="center">CONFERMA DATI</h1>');
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
            -- Form conferma
            MODGUI1.ApriForm(gruppo2.gr2||'InserisciDatiOpera');
            HTP.FORMHIDDEN('titolo', titolo);
            HTP.FORMHIDDEN('anno', anno);
            HTP.FORMHIDDEN('fineperiodo', fineperiodo);
            HTP.FORMHIDDEN('idmusei', idmusei);
            MODGUI1.InputSubmit('Conferma');
            MODGUI1.ChiudiForm;
            -- Form annullamento (per autofill di InserisciOpera)
            MODGUI1.ApriForm(gruppo2.gr2||'InserisciOpera');
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
        MODGUI1.RedirectEsito('Errore sconosciuto', null,
        'Riprova',gruppo2.gr2||'inserisciOpera',null,
        'Torna alle opere',gruppo2.gr2||'menuOpere',null);
END;


PROCEDURE InserisciDatiOpera(
    titolo VARCHAR2 DEFAULT 'Sconosciuto',
    anno VARCHAR2 DEFAULT 'Sconosciuto',
    fineperiodo VARCHAR2 DEFAULT 'Sconosciuto',
    idmusei NUMBER DEFAULT NULL
)IS
varAnno NUMBER(5);
varFinePeriodo NUMBER(5);
idSessione NUMBER(5) := modgui1.get_id_sessione();
BEGIN
    varAnno := TO_NUMBER(anno);
    varFinePeriodo := TO_NUMBER(fineperiodo);
    INSERT INTO Opere VALUES (IdOperaSeq.NEXTVAL,titolo,anno,fineperiodo,idmusei, 1,0);
    IF SQL%FOUND THEN
    -- faccio il commit dello statement precedente
    commit;
    MODGUI1.RedirectEsito('Inserimento andato a buon fine', null,
        'Inserisci una nuova opera',gruppo2.gr2||'inserisciOpera',null,
        'Torna alle opere',gruppo2.gr2||'menuOpere',null);
    -- Ritorno al menu opere
    END IF;
    EXCEPTION WHEN OTHERS THEN
    MODGUI1.RedirectEsito('Inserimento non riuscito', null,
        'Riprova',gruppo2.gr2||'inserisciOpera',null,
        'Torna alle opere',gruppo2.gr2||'menuOpere',null);
END InserisciDatiOpera;


PROCEDURE ModificaOpera(
    operaID NUMBER DEFAULT 0,
    titoloOpera VARCHAR2 DEFAULT 'Sconosciuto'
) IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
var NUMBER DEFAULT 0;
nomeMuseo VARCHAR2(30) DEFAULT NULL;
age NUMBER DEFAULT 0;
periodo NUMBER DEFAULT 0;
lingue VARCHAR2(30) DEFAULT null;
livelli VARCHAR2(30) DEFAULT null;
BEGIN
    modGUI1.ApriPagina('ModificaOpera',idSessione);
        modGUI1.Header;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;

        htp.prn('<h1 align="center">Modifica Opera</h1>');
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
            modGUI1.ApriDiv('class="w3-section"');
            modGUI1.Collegamento('X',gruppo2.gr2||'menuOpere',' w3-btn w3-large w3-red w3-display-topright'); --Bottone per tornare indietro, cambiare COLLEGAMENTOPROVA
            --INIZIO SEZIONE DA MODIFICARE
                modGUI1.ApriForm(gruppo2.gr2||'ConfermaUpdateOpera',NULL,'w3-container');
                    htp.FORMHIDDEN('operaID', operaID);
                    modGUI1.Label('Titolo*');
                    modGUI1.Inputtext('titolo', titoloOpera, 1, titoloOpera);
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
                                gruppo2.gr2||'AggiungiAutore?operaID='||operaID||'&lingue='||lingue||'&livelli='||livelli,
                                'w3-yellow w3-margin w3-button w3-small w3-round-xxlarge');
                    modGUI1.Collegamento('Rimuovi Autore',
                                gruppo2.gr2||'RimuoviAutoreOpera?operaID='||operaID||'&lingue='||lingue||'&livelli='||livelli,
                                'w3-red w3-margin w3-button w3-small w3-round-xxlarge');
                    modGUI1.InputSubmit('Modifica');
                modGUI1.ChiudiForm;
            --FINE SEZIONE DA MODIFICARE
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
END;

PROCEDURE ConfermaUpdateOpera(
    operaID NUMBER DEFAULT 0,
    titolo VARCHAR2 DEFAULT 'Sconosciuto',
    anno VARCHAR2 DEFAULT NULL,
    fineperiodo VARCHAR2 DEFAULT NULL,
    idmusei NUMBER DEFAULT 0
) IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
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
        modGUI1.Header;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;

        htp.prn('<h1 align="center">CONFERMA DATI</h1>');
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
            MODGUI1.ApriForm(gruppo2.gr2||'UpdateOpera');
            htp.FORMHIDDEN('operaID', operaID);
            HTP.FORMHIDDEN('newTitolo', titolo);
            HTP.FORMHIDDEN('newAnno', anno);
            HTP.FORMHIDDEN('newFineperiodo', fineperiodo);
            HTP.FORMHIDDEN('newIDmusei', idmusei);
            MODGUI1.InputSubmit('Conferma');
            MODGUI1.ChiudiForm;
            MODGUI1.ApriForm(gruppo2.gr2||'ModificaOpera');
            HTP.FORMHIDDEN('operaID', operaID);
            HTP.FORMHIDDEN('titoloOpera', titolo);
            MODGUI1.InputSubmit('Annulla');
            MODGUI1.ChiudiForm;
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
    END IF;
    EXCEPTION WHEN OTHERS THEN
        -- TODO: fix here
        dbms_output.put_line('Error: '||sqlerrm); 
END;

PROCEDURE UpdateOpera(
	operaID NUMBER DEFAULT 0,
	newTitolo VARCHAR2 DEFAULT 'Sconosciuto',
	newAnno VARCHAR2 DEFAULT 'Sconosciuto',
	newFineperiodo VARCHAR2 DEFAULT 'Sconosciuto',
	newIDmusei NUMBER DEFAULT 0
) IS
varNewAnno NUMBER(5);
varNewFinePeriodo NUMBER(5);
idSessione NUMBER(5) := modgui1.get_id_sessione();
BEGIN
    varNewAnno := TO_NUMBER(newAnno);
    varNewFinePeriodo := TO_NUMBER(newFineperiodo);
    IF (NewFineperiodo is NULL) or (varNewFinePeriodo > varNewAnno) THEN 
	UPDATE Opere SET
		titolo=newTitolo,
		anno=varNewAnno,
		fineperiodo=varNewFinePeriodo,
		Museo=newIDmusei
	WHERE IdOpera=operaID;
    MODGUI1.RedirectEsito('Update eseguito correttamente', null,  
        null, null, null,
        'Torna alle opere',gruppo2.gr2||'menuOpere',null);
    ELSE
    MODGUI1.RedirectEsito('Update fallito',
                'Errore: parametri non ammessi',
                'Torna all''update',
                gruppo2.gr2||'ModificaOpera?', 
                'operaID='||operaID||'//titoloOpera='||newTitolo,
                'Torna al menù',gruppo2.gr2||'menuOpere');
    END IF;
    EXCEPTION WHEN OTHERS THEN
        MODGUI1.RedirectEsito('Update fallito',
                'Errore: parametri non ammessi',
                'Torna all''update',
                gruppo2.gr2||'ModificaOpera?', 
                'operaID='||operaID||'//titoloOpera='||newTitolo,
                'Torna al menù',gruppo2.gr2||'menuOpere'); 
END;

procedure VisualizzaOpera (
    operaID NUMBER default 0,
    lingue VARCHAR2 default 'sconosciuto',
    livelli VARCHAR2 DEFAULT 'Sconosciuto'
) is
idSessione NUMBER(5) := modgui1.get_id_sessione();
var1 VARCHAR2 (100);
testo1 VARCHAR2 (100);
num NUMBER(10);
num1 NUMBER(10);
num2 NUMBER(10);
num3 NUMBER(10);
 
nomee VARCHAR2(50) DEFAULT 'sconosciuto';
cognomee VARCHAR2(50) DEFAULT 'sconosciuto';
CURSOR Cur IS SELECT * FROM autoriopere WHERE idopera = operaID;

varSala NUMBER(5) DEFAULT 0;
varEliminato NUMBER(2) DEFAULT 0;
varMuseo NUMBER(5) DEFAULT 0;
varTipoSala VARCHAR2(100) DEFAULT 'Sconosciuto';
varNomeStanza VARCHAR2(100) DEFAULT 'Sconosciuto';
varNomeMuseo VARCHAR2(100) DEFAULT 'Sconosciuto';

BEGIN
    htp.prn('<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> ');
    SELECT Titolo, Eliminato into var1, varEliminato FROM OPERE WHERE idOpera=operaID;
    
    modGUI1.apriPagina(var1);
    modGUI1.Header;
    htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;

    modGUI1.ApriDiv('class="w3-center"');
    htp.prn('<h1><b>'||var1||'</b></h1>'); --TITOLO
    if (hasRole(idSessione, 'DBA') or hasRole(idSessione, 'GO')) and varEliminato = 0 then
    modGUI1.Collegamento('Inserisci',
        gruppo2.gr2||'InserisciDescrizione?language='||lingue||'&d_level='||livelli||'&operaID='||OperaID,
        'w3-btn w3-round-xxlarge w3-black');
    htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
    end if;
    if varEliminato = 0 then
        if(lingue='Italian')then
            if  varEliminato = 0 then
                modGUI1.Collegamento('Torna al menù',
                    gruppo2.gr2||'menuOpere', 
                    'w3-btn w3-round-xxlarge w3-black');
                htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
            else 
                modGUI1.Collegamento('Torna al menù',
                    gruppo2.gr2||'menuOpereEliminate',
                    'w3-btn w3-round-xxlarge w3-black');
                htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
            end if;
            htp.prn('<button onclick="document.getElementById(''id104'').style.display=''block''" class="w3-btn w3-round-xxlarge w3-black">Più info</button>');
        end if;
        if(lingue='English')then
            if  varEliminato = 0 then
                modGUI1.Collegamento('Back to menù',
                    gruppo2.gr2||'menuOpere',
                    'w3-btn w3-round-xxlarge w3-black');
                htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
            else 
                modGUI1.Collegamento('Back to menù',
                    gruppo2.gr2||'menuOpereEliminate',
                    'w3-btn w3-round-xxlarge w3-black');
                htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
            end if;
            htp.prn('<button onclick="document.getElementById(''id104'').style.display=''block''" class="w3-btn w3-round-xxlarge w3-black">More info</button>');
        end if;
        if(lingue='Chinese')then
            if  varEliminato = 0 then
                modGUI1.Collegamento('回到菜单',
                    gruppo2.gr2||'menuOpere',
                    'w3-btn w3-round-xxlarge w3-black');
                htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
            else 
                modGUI1.Collegamento('回到菜单',
                    gruppo2.gr2||'menuOpereEliminate',
                    'w3-btn w3-round-xxlarge w3-black');
                htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
            end if;
            htp.prn('<button onclick="document.getElementById(''id104'').style.display=''block''" class="w3-btn w3-round-xxlarge w3-black">更多信息</button>');
        end if;
    end if;
modGUI1.ChiudiDiv;
gruppo2.spostamentiOpera(operaID);
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
        htp.prn('<img src="https://www.stateofmind.it/wp-content/uploads/2018/01/La-malattia-rappresentata-nelle-opere-darte-e-in-letteratura-680x382.jpg" alt="Alps" style="width:500px; height:300px;">');
        modGUI1.ChiudiDiv;
        modGUI1.ApriDiv('class="w3-container w3-cell w3-border-right w3-cell-middle" style="width:1120px; height:300px"');
            htp.prn('<h5><b>'||var1||'</b></h5>');
            htp.prn('<p>'||SUBSTR(des.testo,0,80)||'</p>');
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
                if (hasRole(idSessione, 'DBA') or hasRole(idSessione, 'GO')) and varEliminato = 0 then
                modGUI1.collegamento('sposta',
                    gruppo2.gr2||'SpostaOpera?operaID='||operaID||'&salaID='||varSala||'&lingue='||lingue||'&livelli='||livelli,
                    'w3-green w3-margin w3-button w3-small w3-round-xxlarge');
                end if;
                htp.br;
                htp.prn('<b>Autore: </b>');
                
                    FOR auth in Cur
                    LOOP
                    SELECT autori.NOME, autori.cognome INTO nomee, cognomee FROM autori WHERE idautore = auth.idautore;
                    MODGUI1.Collegamento(nomee||' '||Cognomee,
                        gruppo2.gr2||'ModificaAutore?authorID='||auth.IdAutore||'&operazione=0'
                        ||'&caller=visualizzaOpera&callerParams=//operaID='||operaID||'//lingue='||lingue||'//livelli='||livelli);
                    htp.prn(', ');
                    
                    END LOOP;
                    
                    if (hasRole(idSessione, 'DBA') or hasRole(idSessione, 'GO')) and varEliminato = 0 then
                    modGUI1.Collegamento('Aggiungi Autore',
                        gruppo2.gr2||'AggiungiAutore?operaID='||operaID||'&lingue='||lingue||'&livelli='||livelli,
                        'w3-yellow w3-margin w3-button w3-small w3-round-xxlarge');
                    modGUI1.Collegamento('Rimuovi Autore',
                        gruppo2.gr2||'RimuoviAutoreOpera?operaID='||operaID||'&lingue='||lingue||'&livelli='||livelli,
                        'w3-red w3-margin w3-button w3-small w3-round-xxlarge');
                    end if;
                end if;

                if(lingue='English')
                then
                htp.prn('<h5><b>Exposed: </b>❌</h5>');
                if (hasRole(idSessione, 'DBA') or hasRole(idSessione, 'GO')) and varEliminato = 0 then
                modGUI1.collegamento('sposta',
                    gruppo2.gr2||'SpostaOpera?operaID='||operaID||'&salaID='||varSala||'&lingue='||lingue||'&livelli='||livelli,
                    'w3-green w3-margin w3-button w3-small w3-round-xxlarge');
                end if;
                htp.br;
                htp.prn('<b>Author: </b>');
                
                    FOR auth in Cur
                    LOOP
                    SELECT autori.NOME, autori.cognome INTO nomee, cognomee FROM autori WHERE idautore = auth.idautore;
                    MODGUI1.Collegamento(nomee||' '||Cognomee,
                        gruppo2.gr2||'ModificaAutore?authorID='||auth.IdAutore||'&operazione=0'
                        ||'&caller=visualizzaOpera&callerParams=//operaID='||operaID||'//lingue='||lingue||'//livelli='||livelli);
                    htp.prn(', ');
                    
                    END LOOP;

                    if (hasRole(idSessione, 'DBA') or hasRole(idSessione, 'GO')) and varEliminato = 0 then
                    modGUI1.Collegamento('Aggiungi Autore',
                        gruppo2.gr2||'AggiungiAutore?operaID='||operaID||'&lingue='||lingue||'&livelli='||livelli,
                        'w3-yellow w3-margin w3-button w3-small w3-round-xxlarge');
                    modGUI1.Collegamento('Rimuovi Autore',
                        gruppo2.gr2||'RimuoviAutoreOpera?operaID='||operaID||'&lingue='||lingue||'&livelli='||livelli,
                        'w3-red w3-margin w3-button w3-small w3-round-xxlarge');
                    end if;
                end if;

                if(lingue='Chinese')
                then
                htp.prn('<h5><b>裸露: </b>❌</h5>');
                if (hasRole(idSessione, 'DBA') or hasRole(idSessione, 'GO')) and varEliminato = 0 then
                modGUI1.collegamento('sposta',
                    gruppo2.gr2||'SpostaOpera?operaID='||operaID||'&salaID='||varSala||'&lingue='||lingue||'&livelli='||livelli,
                    'w3-green w3-margin w3-button w3-small w3-round-xxlarge');
                end if;
                htp.br;
                htp.prn('<b>作者: </b>');
                
                    FOR auth in Cur
                    LOOP
                    SELECT autori.NOME, autori.cognome INTO nomee, cognomee FROM autori WHERE idautore = auth.idautore;
                    MODGUI1.Collegamento(nomee||' '||Cognomee,
                        gruppo2.gr2||'ModificaAutore?authorID='||auth.IdAutore||'&operazione=0'
                        ||'&caller=visualizzaOpera&callerParams=//operaID='||operaID||'//lingue='||lingue||'//livelli='||livelli);
                    htp.prn(', ');
                    END LOOP;

                    if (hasRole(idSessione, 'DBA') or hasRole(idSessione, 'GO')) and varEliminato = 0 then
                    modGUI1.Collegamento('Aggiungi Autore',
                        gruppo2.gr2||'AggiungiAutore?operaID='||operaID||'&lingue='||lingue||'&livelli='||livelli,
                        'w3-yellow w3-margin w3-button w3-small w3-round-xxlarge');
                    modGUI1.Collegamento('Rimuovi Autore',
                        gruppo2.gr2||'RimuoviAutoreOpera?operaID='||operaID||'&lingue='||lingue||'&livelli='||livelli,
                        'w3-red w3-margin w3-button w3-small w3-round-xxlarge');
                    end if;

                end if;

            ELSE

                if(lingue='Italian')
                then
                htp.prn('<h5><b>Esposta: </b>✅</h5>');
                htp.br;
                htp.prn('<b>Museo: </b>');
                MODGUI1.Collegamento(''||varNomeMuseo||'',gruppo2.gr4||'visualizzamusei?MuseoID='||varMuseo);  
                htp.br;
                htp.prn('<b> Sala: </b>'); 
                MODGUI1.Collegamento(''||varNomeStanza||'',gruppo2.gr3||'visualizzaSala?varIdSala='||varSala);  
                htp.prn('<b> tipo di sala: </b>'||varTipoSala); 
                if (hasRole(idSessione, 'DBA') or hasRole(idSessione, 'GO')) and varEliminato = 0 then
                modGUI1.collegamento('sposta',
                    gruppo2.gr2||'SpostaOpera?operaID='||operaID||'&salaID='||varSala||'&lingue='||lingue||'&livelli='||livelli,
                    'w3-green w3-margin w3-button w3-small w3-round-xxlarge');
                end if;
                htp.br;
                htp.prn('<b>Autore: </b>');
                
                    FOR auth in Cur
                    LOOP
                    SELECT autori.NOME, autori.cognome INTO nomee, cognomee FROM autori WHERE idautore = auth.idautore;
                    MODGUI1.Collegamento(nomee||' '||Cognomee,
                        gruppo2.gr2||'ModificaAutore?authorID='||auth.IdAutore||'&operazione=0'
                        ||'&caller=visualizzaOpera&callerParams=//operaID='||operaID||'//lingue='||lingue||'//livelli='||livelli);
                    htp.prn(', ');
                    END LOOP;
                    
                    if (hasRole(idSessione, 'DBA') or hasRole(idSessione, 'GO')) and varEliminato = 0 then
                    modGUI1.Collegamento('Aggiungi Autore',
                        gruppo2.gr2||'AggiungiAutore?operaID='||operaID||'&lingue='||lingue||'&livelli='||livelli,
                        'w3-yellow w3-margin w3-button w3-small w3-round-xxlarge');
                    modGUI1.Collegamento('Rimuovi Autore',
                        gruppo2.gr2||'RimuoviAutoreOpera?operaID='||operaID||'&lingue='||lingue||'&livelli='||livelli,
                        'w3-red w3-margin w3-button w3-small w3-round-xxlarge');
                    end if;

                end if;

                if(lingue='English')
                then
                htp.prn('<h5><b>Exposed: </b>✅</h5>');
                htp.br;
                htp.prn('<b>Museum: </b>');
                MODGUI1.Collegamento(''||varNomeMuseo||'',gruppo2.gr4||'visualizzamusei?MuseoID='||varMuseo);  
                htp.br;
                htp.prn('<b> Room: </b>'); 
                MODGUI1.Collegamento(''||varNomeStanza||'',gruppo2.gr3||'visualizzaSala?varIdSala='||varSala);  
                htp.prn('<b> type of room: </b>'||varTipoSala); 
                if (hasRole(idSessione, 'DBA') or hasRole(idSessione, 'GO')) and varEliminato = 0 then
                modGUI1.collegamento('sposta',
                    gruppo2.gr2||'SpostaOpera?operaID='||operaID||'&salaID='||varSala||'&lingue='||lingue||'&livelli='||livelli,
                    'w3-green w3-margin w3-button w3-small w3-round-xxlarge');
                end if;
                htp.br;
                htp.prn('<b>Author: </b>');
                
                    FOR auth in Cur
                    LOOP
                    SELECT autori.NOME, autori.cognome INTO nomee, cognomee FROM autori WHERE idautore = auth.idautore;
                    MODGUI1.Collegamento(nomee||' '||Cognomee,
                        gruppo2.gr2||'ModificaAutore?authorID='||auth.IdAutore||'&operazione=0'
                        ||'&caller=visualizzaOpera&callerParams=//operaID='||operaID||'//lingue='||lingue||'//livelli='||livelli);
                    htp.prn(', ');
                    
                    END LOOP;
                    
                    if (hasRole(idSessione, 'DBA') or hasRole(idSessione, 'GO')) and varEliminato = 0 then
                    modGUI1.Collegamento('Aggiungi Autore',
                        gruppo2.gr2||'AggiungiAutore?operaID='||operaID||'&lingue='||lingue||'&livelli='||livelli,
                        'w3-yellow w3-margin w3-button w3-small w3-round-xxlarge');
                    modGUI1.Collegamento('Rimuovi Autore',
                        gruppo2.gr2||'RimuoviAutoreOpera?operaID='||operaID||'&lingue='||lingue||'&livelli='||livelli,
                        'w3-red w3-margin w3-button w3-small w3-round-xxlarge');
                    end if;

                end if;

                if(lingue='Chinese')
                then
                htp.prn('<h5><b>裸露: </b>✅</h5>');
                htp.br;
                htp.prn('<b>博物馆: </b>');
                MODGUI1.Collegamento(''||varNomeMuseo||'',gruppo2.gr4||'visualizzamusei?MuseoID='||varMuseo);  
                htp.br;
                htp.prn('<b> 房间: </b>'); 
                MODGUI1.Collegamento(''||varNomeStanza||'',gruppo2.gr3||'visualizzaSala?varIdSala='||varSala);  
                htp.prn('<b> 大厅类型: </b>'||varTipoSala); 
                if (hasRole(idSessione, 'DBA') or hasRole(idSessione, 'GO')) and varEliminato = 0 then
                modGUI1.collegamento('sposta',
                    gruppo2.gr2||'SpostaOpera?operaID='||operaID||'&salaID='||varSala||'&lingue='||lingue||'&livelli='||livelli,
                    'w3-green w3-margin w3-button w3-small w3-round-xxlarge');
                end if;
                htp.br;
                htp.prn('<b>作者: </b>');
                
                    FOR auth in Cur
                    LOOP
                    SELECT autori.NOME, autori.cognome INTO nomee, cognomee FROM autori WHERE idautore = auth.idautore;
                    MODGUI1.Collegamento(nomee||' '||Cognomee,
                        gruppo2.gr2||'ModificaAutore?authorID='||auth.IdAutore||'&operazione=0'
                        ||'&caller=visualizzaOpera&callerParams=//operaID='||operaID||'//lingue='||lingue||'//livelli='||livelli);
                    htp.prn(', ');
                    END LOOP;

                    if (hasRole(idSessione, 'DBA') or hasRole(idSessione, 'GO')) and varEliminato = 0 then
                    modGUI1.Collegamento('Aggiungi Autore',
                        gruppo2.gr2||'AggiungiAutore?operaID='||operaID||'&lingue='||lingue||'&livelli='||livelli,
                        'w3-yellow w3-margin w3-button w3-small w3-round-xxlarge');
                    modGUI1.Collegamento('Rimuovi Autore',
                        gruppo2.gr2||'RimuoviAutoreOpera?operaID='||operaID||'&lingue='||lingue||'&livelli='||livelli,
                        'w3-red w3-margin w3-button w3-small w3-round-xxlarge');
                    end if;
                end if;
            END IF;

            modGUI1.ChiudiDiv;
            modGUI1.ApriDiv('class="w3-container w3-cell w3-cell-middle"');
            if (hasRole(idSessione, 'DBA') or hasRole(idSessione, 'GO')) and varEliminato = 0
            then
                modGUI1.collegamento('Modifica',
                    gruppo2.gr2||'ModificaDescrizione?idDescrizione='||des.idDesc,
                    'w3-margin w3-button w3-green');
                htp.br;
                htp.prn('<button onclick="document.getElementById(''ElimDescrizione'||des.idDesc||''').style.display=''block''" class="w3-margin w3-button w3-red w3-hover-white">Elimina</button>');
                gruppo2.EliminazioneDescrizione(des.idDesc);
            end if;
        modGUI1.ChiudiDiv;
    modGUI1.chiudiDiv;
    htp.br;
    htp.br;
END LOOP;
        --FINE LOOP VISUALIZZAZIONE

end VisualizzaOpera;


PROCEDURE SpostaOpera(
    operaID NUMBER DEFAULT 0,
    salaID NUMBER DEFAULT 0,
    lingue VARCHAR2 default NULL,
    livelli VARCHAR2 DEFAULT 'Sconosciuto'
    ) IS
    idSessione NUMBER(5) := modgui1.get_id_sessione();
    nomeStanza VARCHAR2(50) DEFAULT 'sconosciuto';
    Esponibile_SELECTed NUMBER(1) := 0;
    NEsponibile_SELECTed NUMBER(1) := 0;
    BEGIN
    SELECT ESPONIBILE into Esponibile_SELECTed from OPERE where IDOPERA=operaId;
    if Esponibile_SELECTed = 0 THEN
        NEsponibile_SELECTed := 1;
    end if;
        modGUI1.ApriPagina('SpostaOpera',idSessione);
        modGUI1.Header;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;

        htp.prn('<h1 align="center">Sposta Opera</h1>');
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
            modGUI1.ApriDiv('class="w3-section"');
            modGUI1.Collegamento('X',gruppo2.gr2||'menuOpere',' w3-btn w3-large w3-red w3-display-topright');
                modGUI1.ApriForm(gruppo2.gr2||'SpostamentoOpera','Spostamento opera','w3-container');
                    htp.FORMHIDDEN('operaID',operaID);
                    htp.FORMHIDDEN('lingue',lingue);
                    htp.FORMHIDDEN('livelli',livelli);
                    htp.br;
                    htp.prn('<b>Status opera: </b>');
                    modGUI1.InputRadioButton('Esponibile ', 'esposizione',1, Esponibile_SELECTed, 0, 1);
                    modGUI1.InputRadioButton('Non esponibile ', 'esposizione',0, NEsponibile_SELECTed, 0, 1);
                    
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
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
END;


procedure SpostamentoOpera(
    operaID NUMBER DEFAULT 0,
    Esposizione NUMBER DEFAULT 0,
    NuovaSalaID NUMBER DEFAULT 0,
    lingue VARCHAR2 default NULL,
    livelli VARCHAR2 DEFAULT 'Sconosciuto'
)IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
    BEGIN
    if (Esposizione=1)then
        UPDATE SALEOPERE SET datauscita = TO_DATE(TO_CHAR(SYSDATE, 'dd/mm/yyyy'), 'dd/mm/yyyy') WHERE datauscita IS NULL AND opera = operaID; 
        INSERT INTO SALEOPERE(IdMovimento, Sala, Opera, DataArrivo, DataUscita) VALUES (IdMovimentoSeq.nextVal, NuovaSalaID, operaID, TO_DATE(TO_CHAR(SYSDATE, 'dd/mm/yyyy'), 'dd/mm/yyyy'), null);
        UPDATE OPERE SET Esponibile = 1 WHERE idopera = operaID;
        MODGUI1.RedirectEsito('Spostamento eseguito', null,
            --null,null,null,
            'Torna all''opera',gruppo2.gr2||'VisualizzaOpera?', 'operaID='||operaID||'//lingue='||lingue||'//livelli='||livelli,
            'Torna alle opere',gruppo2.gr2||'menuOpere',null);  
    else
        UPDATE OPERE SET Esponibile = 0 WHERE idopera = operaID;
        UPDATE SALEOPERE SET datauscita = TO_DATE(TO_CHAR(SYSDATE, 'dd/mm/yyyy'), 'dd/mm/yyyy') WHERE datauscita IS NULL AND opera = operaID; 
        MODGUI1.RedirectEsito('Opera non più esposta',null,
            'Torna all''opera',gruppo2.gr2||'VisualizzaOpera?', 'operaID='||operaID||'//lingue='||lingue||'//livelli='||livelli,
            'Torna alle opere',gruppo2.gr2||'menuOpere',null);  
    END IF;
END;

procedure AggiungiAutore(
    operaID NUMBER DEFAULT 0,
    lingue VARCHAR2 DEFAULT null,
    livelli VARCHAR2 DEFAULT NULL
)IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
nomecompleto VARCHAR2(50);
    BEGIN
    modGUI1.ApriPagina('Aggiungi autore', idSessione);
    modGUI1.Header;
    htp.br;htp.br;htp.br;htp.br;

    htp.prn('<h1 align="center">Seleziona l''autore da aggiungere</h1>');
    modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
        modGUI1.ApriDiv('class="w3-section"');
            -- Link di ritorno al menuAutori
            modGUI1.Collegamento('X',
                gruppo2.gr2||'menuOpere',
                'w3-btn w3-large w3-red w3-display-topright');
            -- Form per mandare dati alla procedura di conferma
            htp.br;
            MODGUI1.apriDIV('class=w3-center');
                modGUI1.ApriForm(gruppo2.gr2||'AggiuntaAutore');
                htp.FORMHIDDEN('operaID',operaID);
                htp.FORMHIDDEN('lingue',lingue);
                htp.FORMHIDDEN('livelli',livelli);
                MODGUI1.SELECTOPEN('autoreID', 'autoreID');
                FOR aut IN (SELECT IdAutore,Nome,COGNOME FROM AUTORI ORDER BY COGNOME)
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
    operaID NUMBER DEFAULT 0,
    autoreID NUMBER DEFAULT 0,
    lingue VARCHAR2 default NULL,
    livelli VARCHAR2 DEFAULT NULL
)IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
controllo NUMBER(3);
    BEGIN
        SELECT count(*) into controllo 
            FROM AUTORIOPERE WHERE AUTORIOPERE.IdOpera=operaID 
            and AUTORIOPERE.IdAutore=autoreID;
        IF controllo<1 THEN
            INSERT INTO AUTORIOPERE VALUES
                (autoreID,operaID);
            IF SQL%FOUND THEN
                COMMIT;
                if lingue is not null THEN
                    MODGUI1.RedirectEsito('Inserimento riuscito',
                    'Autore inserito correttamente',
                    'Torna all''opera',gruppo2.gr2||'VisualizzaOpera?', 'operaID='||operaID||'//lingue='||lingue||'//livelli='||livelli,
                    'Torna al menù',gruppo2.gr2||'menuOpere');
                    ELSE
                    MODGUI1.RedirectEsito('Inserimento riuscito',
                    'Autore inserito correttamente',null,null,null,
                    'Torna al menù',gruppo2.gr2||'menuOpere');
                END IF;
            ELSE
                if lingue is not null THEN
                    MODGUI1.RedirectEsito('Inserimento fallito','Errore inserimento',
                    'Torna all''opera',gruppo2.gr2||'VisualizzaOpera?', 'operaID='||operaID||'//lingue='||lingue||'//livelli='||livelli,
                    'Torna al menù',gruppo2.gr2||'menuOpere');
                    ELSE
                    MODGUI1.RedirectEsito('Inserimento fallito',
                    'Errore inserimento',null,null,null,
                    'Torna al menù',gruppo2.gr2||'menuOpere');
                END IF;
            END IF;
        ELSE
            if lingue is not null THEN
                MODGUI1.RedirectEsito('Inserimento fallito',
                'Errore: Autore già presente',
                'Torna all''opera',gruppo2.gr2||'VisualizzaOpera?', 'operaID='||operaID||'//lingue='||lingue||'//livelli='||livelli,
                'Torna al menù',gruppo2.gr2||'menuOpere');
                ELSE
                MODGUI1.RedirectEsito('Inserimento fallito',
                'Errore: Autore già presente',null,null,null,
                'Torna al menù',gruppo2.gr2||'menuOpere');
            END IF;
        END IF;
END AggiuntaAutore;


procedure RimuoviAutoreOpera(
    operaID NUMBER DEFAULT 0,
    lingue VARCHAR2 DEFAULT null, 
    livelli VARCHAR2 DEFAULT null
)IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
nomecompleto VARCHAR2(50);
    BEGIN
    modGUI1.ApriPagina('Rimuovi Autore', idSessione);
    modGUI1.Header;
    htp.br;htp.br;htp.br;htp.br;

    htp.prn('<h1 align="center">Seleziona l''autore da rimuovere</h1>');
    modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
        modGUI1.ApriDiv('class="w3-section"');
            -- Link di ritorno al menuAutori
            modGUI1.Collegamento('X',
                gruppo2.gr2||'menuOpere',
                'w3-btn w3-large w3-red w3-display-topright');
            -- Form per mandare dati alla procedura di conferma
            htp.br;
            MODGUI1.apriDIV('class=w3-center');
                modGUI1.ApriForm(gruppo2.gr2||'RimozioneAutoreOpera');
                htp.FORMHIDDEN('operaID',operaID);
                htp.FORMHIDDEN('lingue',lingue);
                htp.FORMHIDDEN('livelli',livelli);
                MODGUI1.SELECTOPEN('autoreID', 'autoreID');
                FOR aut IN (SELECT AUTORIOPERE.IdAutore,Autori.Nome,Autori.COGNOME FROM AUTORI,AUTORIOPERE
                            WHERE idOpera=OperaID AND AUTORIOPERE.idAutore=AUTORI.idAutore ORDER BY AUTORI.COGNOME)
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
END RimuoviAutoreOpera;

procedure RimozioneAutoreOpera(
    operaID NUMBER DEFAULT 0,
    autoreID NUMBER DEFAULT 0,
    lingue VARCHAR2 DEFAULT null,
    livelli VARCHAR2 DEFAULT null
)IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
controllo NUMBER(3);
    BEGIN
    SELECT count(*) into controllo FROM AUTORIOPERE
    WHERE idOpera=OperaID;

    DELETE FROM AUTORIOPERE 
        WHERE AUTORIOPERE.IdOpera=operaID AND AUTORIOPERE.IdAutore=autoreID;

    IF SQL%FOUND THEN
        COMMIT;
        if lingue is not null THEN
            MODGUI1.RedirectEsito('Rimozione riuscita',
                'Autore rimosso correttamente',
                'Torna all''opera',gruppo2.gr2||'VisualizzaOpera?', 'operaID='||operaID||'//lingue='||lingue||'//livelli='||livelli,
                'Torna al menù',gruppo2.gr2||'menuOpere');
                ELSE
                    MODGUI1.RedirectEsito('Rimozione riuscita',
                    'Autore inserito correttamente',null,null,null,
                    'Torna al menù',gruppo2.gr2||'menuOpere');
            END IF;
        ELSE
            if lingue is not null THEN
                MODGUI1.RedirectEsito('Rimozione fallita','Errore rimozione',
                'Torna all''opera',gruppo2.gr2||'VisualizzaOpera?', 'operaID='||operaID||'//lingue='||lingue||'//livelli='||livelli,
                'Torna al menù',gruppo2.gr2||'menuOpere');
                ELSE
                    MODGUI1.RedirectEsito('Rimozione fallita','Errore rimozione',
                    null,null,null,
                    'Torna al menù',gruppo2.gr2||'menuOpere');
            END IF;
        END IF;

END RimozioneAutoreOpera;

procedure SpostamentiOpera (
    operaID NUMBER DEFAULT 0
)is
idSessione NUMBER(5) := modgui1.get_id_sessione(); 
proprietario NUMBER(5) DEFAULT 0;
nomeMuseo VARCHAR2(50) DEFAULT 0;
ricevente NUMBER(5) DEFAULT 0;
var1 VARCHAR2(100) DEFAULT 'Sconosciuto';
k NUMBER default 1;
 
BEGIN
    SELECT museo INTO proprietario FROM opere WHERE idopera = operaID;
    DECLARE
        CURSOR cur is SELECT * FROM saleopere WHERE opera = operaID ORDER BY dataarrivo;
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
                    modGUI1.ApriDiv('class="w3-cell-row w3-border" style="width:100%"');
                        modGUI1.ApriDiv('class="w3-container w3-cell" style="width:50%" ');
                            htp.print('<b>DA:</b>'); --COLLEGAMENTO MUSEO
                            MODGUI1.Collegamento(var1,gruppo2.gr4||'visualizzausei?MuseoID='||proprietario);
                            
                            htp.br;htp.br;
                            htp.print('<b>DAL: </b>'||sal.dataarrivo);
                        modGUI1.ChiudiDiv;
                        modGUI1.ApriDiv('class="w3-container w3-cell"');
                            htp.print('<b> A:</b>'); --COLLEGAMENTO MUSEO
                            MODGUI1.Collegamento(nomeMuseo,gruppo2.gr4||'visualizzamusei?MuseoID='||ricevente);
                           
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


procedure selezioneMuseo IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
    BEGIN
        modGUI1.ApriDiv('id="11" class="w3-modal"');
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
                modGUI1.ApriDiv('class="w3-center"');
                    htp.br;
                    htp.prn('<span onclick="document.getElementById(''11'').style.display=''none''" class="w3-button w3-xlarge w3-red w3-display-topright" title="Close Modal">X</span>');
                    htp.print('<h1>Seleziona il museo</h1>');
                modGUI1.ChiudiDiv;
                modGUI1.ApriForm(gruppo2.gr2||'StatisticheOpere','seleziona museo','w3-container');
                    htp.print('<h4>');
                    htp.br;
                    htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                    modGUI1.InputRadioButton('TUTTI I MUSEI','museoID',0);
                    for mus IN (SELECT * FROM MUSEI)
                    LOOP
                        htp.br;
                        htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                        modGUI1.InputRadioButton(mus.Nome,'museoID',mus.idMuseo);
                    END LOOP;
                    htp.print('</h4>');
                    htp.br;
                    htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit">Seleziona</button>');
                modGUI1.ChiudiForm;
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
END selezioneMuseo;


--Procedura home statistiche
Procedure StatisticheOpere(
    museoID NUMBER DEFAULT 0
)IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
avgYear INT DEFAULT 0;
k NUMBER DEFAULT 1;
var1 VARCHAR2(100) default'sconosciuto';
varOpera VARCHAR2(100) DEFAULT 'Sconosciuto';

p NUMBER default 0;
years NUMBER DEFAULT 0;
AnnoCorrente NUMBER:= TO_NUMBER(TO_CHAR(sysdate, 'YYYY'));

BEGIN   
    MODGUI1.ApriPagina('StatisticheOpere',idSessione);
    modGUI1.Header;
    htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;

    modGUI1.ApriDiv('class="w3-center"');
        htp.prn('<h1><b>STATISTICHE DELLE OPERE</b></h1>'); --TITOLO
        IF(museoID=0)THEN
                htp.prn('<h4><b>tutti i musei</b></h4>');
                modGUI1.Collegamento('Torna al menù Opere',
                    gruppo2.gr2||'menuOpere',
                    'w3-btn w3-round-xxlarge w3-black');
                modGUI1.ChiudiDiv;
                htp.br;
                modGUI1.ApriDiv('class="w3-container" style="width:100%"');
                k:=1;
                htp.print('<h2><b>Opere esposte per più tempo</b></h2>');
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
                            htp.prn('<img src="https://www.stateofmind.it/wp-content/uploads/2018/01/La-malattia-rappresentata-nelle-opere-darte-e-in-letteratura-680x382.jpg" alt="Alps" style="width:100%">');
                                modGUI1.ApriDiv('class="w3-container w3-center"');
                                --INIZIO DESCRIZIONI
                                    htp.prn('<b>Titolo: </b>');
                                    htp.prn('<button onclick="document.getElementById(''LinguaeLivelloOpera'||var.Opera||''').style.display=''block''" class="w3-margin w3-btn w3-border">'|| SUBSTR(varOpera,0,35)||'<br>'|| SUBSTR(varOpera,36,70)  ||'</button>');
                                    gruppo2.linguaELivello(var.Opera);
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
                modGUI1.apriDIV('class=w3-container');
                htp.print('<h2><b>Opere non spostate da più tempo: </b></h2>');
                modGUI1.chiudiDIV;
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
                            htp.prn('<img src="https://www.stateofmind.it/wp-content/uploads/2018/01/La-malattia-rappresentata-nelle-opere-darte-e-in-letteratura-680x382.jpg" alt="Alps" style="width:100%">');
                                    modGUI1.ApriDiv('class="w3-container w3-center" style="height:150px;"');
                                    --INIZIO DESCRIZIONI
                                        htp.prn('<b>Titolo: </b>');
                                        htp.prn('<button onclick="document.getElementById(''LinguaeLivelloOpera'||var.Opera||''').style.display=''block''" class="w3-margin w3-btn w3-border">'|| SUBSTR(varOpera,0,35)||'<br>'|| SUBSTR(varOpera,36,70)  ||'</button>');
                                        gruppo2.linguaELivello(var.Opera);
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
                modGUI1.apriDIV('class=w3-container');
                htp.print('<h2><b>Opere più antiche: </b></h2>');
                htp.print('<h5><b>Età media opere:</b>'||p||' anni</h5>');
                modGUI1.chiudiDIV;
                modGUI1.ApriDiv('class="w3-container" style="width:100%"');    
                FOR var in  (SELECT * FROM (SELECT idOpera FROM OPERE ORDER BY anno)WHERE ROWNUM <=3)
                LOOP
                    SELECT opere.titolo,opere.anno INTO varOpera,years FROM opere WHERE idopera = var.idOpera;
                    modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                    gruppo2.coloreClassifica(k);
                        modGUI1.ApriDiv('class="w3-card-4"');
                        htp.prn('<img src="https://www.stateofmind.it/wp-content/uploads/2018/01/La-malattia-rappresentata-nelle-opere-darte-e-in-letteratura-680x382.jpg" alt="Alps" style="width:100%">');
                            modGUI1.ApriDiv('class="w3-container w3-center"');
                                --INIZIO DESCRIZIONI
                                htp.prn('<b>Titolo: </b>');
                                htp.prn('<button onclick="document.getElementById(''LinguaeLivelloOpera'||var.idOpera||''').style.display=''block''" class="w3-margin w3-btn w3-border">'|| SUBSTR(varOpera,0,35)||'<br>'|| SUBSTR(varOpera,36,70)  ||'</button>');
                                gruppo2.linguaELivello(var.idOpera);
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
                modGUI1.apriDIV('class=w3-container');
                htp.print('<h2><b>Opere con più autori: </b></h2>');
                modGUI1.chiudiDIV;
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
                        htp.prn('<img src="https://www.stateofmind.it/wp-content/uploads/2018/01/La-malattia-rappresentata-nelle-opere-darte-e-in-letteratura-680x382.jpg" alt="Alps" style="width:100%">');
                            modGUI1.ApriDiv('class="w3-container w3-center"');
                                --INIZIO DESCRIZIONI
                                htp.prn('<b>Titolo: </b>');
                                htp.prn('<button onclick="document.getElementById(''LinguaeLivelloOpera'||var.idOpera||''').style.display=''block''" class="w3-margin w3-btn w3-border">'|| SUBSTR(varOpera,0,35)||'<br>'|| SUBSTR(varOpera,36,70)  ||'</button>');
                                gruppo2.linguaELivello(var.idOpera);
                                htp.prn('<p><b>N. autori </b>'||var.numAutori||'</p>');
                                --FINE DESCRIZIONI
                            modGUI1.ChiudiDiv;
                        modGUI1.ChiudiDiv;
                    modGUI1.ChiudiDiv;
                        k:=k+1;
                END LOOP;
                 modGUI1.ChiudiDiv;
        ELSE
                SELECT nome INTO var1 FROM MUSEI WHERE idMuseo=museoID;
                MODGUI1.Collegamento('<h4><b>'||var1||'</b></h4>',
                    gruppo2.gr4||'visualizzamusei?MuseoID='||museoID,
                    'w3-btn w3-round-xxlarge w3-white w3-border w3-hover-yellow');
                htp.br;
                htp.br;
                modGUI1.Collegamento('Torna al menù Opere',
                    gruppo2.gr2||'menuOpere',
                    'w3-btn w3-round-xxlarge w3-black');
                modGUI1.ChiudiDiv;
                htp.br;
                modGUI1.ApriDiv('class="w3-container" style="width:100%"');

                k:=1;
                htp.print('<h2><b>Opere esposte per più tempo</b></h2>');
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
                            htp.prn('<img src="https://www.stateofmind.it/wp-content/uploads/2018/01/La-malattia-rappresentata-nelle-opere-darte-e-in-letteratura-680x382.jpg" alt="Alps" style="width:100%">');
                                modGUI1.ApriDiv('class="w3-container w3-center"');
                                --INIZIO DESCRIZIONI
                                    htp.prn('<b>Titolo: </b>');
                                    htp.prn('<button onclick="document.getElementById(''LinguaeLivelloOpera'||var.Opera||''').style.display=''block''" class="w3-margin w3-btn w3-border">'|| SUBSTR(varOpera,0,35)||'<br>'|| SUBSTR(varOpera,36,70)  ||'</button>');
                                    gruppo2.linguaELivello(var.Opera);
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
                htp.br;

                k:=1;
                --OPERE DA PIÙ TEMPO NON SPOSTATE
                modGUI1.apriDIV('class=w3-container');
                htp.print('<h2><b>Opere non spostate da più tempo: </b></h2>');
                modGUI1.chiudiDIV;
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
                            htp.prn('<img src="https://www.stateofmind.it/wp-content/uploads/2018/01/La-malattia-rappresentata-nelle-opere-darte-e-in-letteratura-680x382.jpg" alt="Alps" style="width:100%">');
                                    modGUI1.ApriDiv('class="w3-container w3-center" style="height:150px;"');
                                    --INIZIO DESCRIZIONI
                                        htp.prn('<b>Titolo: </b>');
                                        htp.prn('<button onclick="document.getElementById(''LinguaeLivelloOpera'||var.Opera||''').style.display=''block''" class="w3-margin w3-btn w3-border">'|| SUBSTR(varOpera,0,35)||'<br>'|| SUBSTR(varOpera,36,70)  ||'</button>');
                                        gruppo2.linguaELivello(var.Opera);
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
                modGUI1.apriDIV('class=w3-container');
                htp.print('<h2><b>Opere più antiche: </b></h2>');
                htp.print('<h5><b>Età media opere:</b>'||p||' anni</h5>');
                modGUI1.chiudiDIV;
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
                        htp.prn('<img src="https://www.stateofmind.it/wp-content/uploads/2018/01/La-malattia-rappresentata-nelle-opere-darte-e-in-letteratura-680x382.jpg" alt="Alps" style="width:100%">');
                            modGUI1.ApriDiv('class="w3-container w3-center"');
                                --INIZIO DESCRIZIONI
                                htp.prn('<b>Titolo: </b>');
                                htp.prn('<button onclick="document.getElementById(''LinguaeLivelloOpera'||var.idOpera||''').style.display=''block''" class="w3-margin w3-btn w3-border">'|| SUBSTR(varOpera,0,35)||'<br>'|| SUBSTR(varOpera,36,70)  ||'</button>');
                                gruppo2.linguaELivello(var.idOpera);
                                htp.prn('<p><b>Anno realizzazione </b>'||years||' D.C.</p>');
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

                modGUI1.apriDIV('class=w3-container');
                htp.print('<h2><b>Opere con più autori: </b></h2>');
                modGUI1.chiudiDIV;
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
                        htp.prn('<img src="https://www.stateofmind.it/wp-content/uploads/2018/01/La-malattia-rappresentata-nelle-opere-darte-e-in-letteratura-680x382.jpg" alt="Alps" style="width:100%">');
                            modGUI1.ApriDiv('class="w3-container w3-center"');
                                --INIZIO DESCRIZIONI
                                htp.prn('<b>Titolo: </b>');
                                htp.prn('<button onclick="document.getElementById(''LinguaeLivelloOpera'||var.idOpera||''').style.display=''block''" class="w3-margin w3-btn w3-border">'|| SUBSTR(varOpera,0,35)||'<br>'|| SUBSTR(varOpera,36,70)  ||'</button>');
                                gruppo2.linguaELivello(var.idOpera);
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


PROCEDURE filtraOpere IS
BEGIN
    modGUI1.ApriDiv('id="filtraOpere" class="w3-modal"');
        modGUI1.ApriDiv('class="w3-modal-content w3-cell-row w3-animate-zoom" style="max-width:700px"');
            modGUI1.ApriDiv('class="w3-center"');
                htp.prn('<span onclick="document.getElementById(''filtraOpere'').style.display=''none''" '
                    ||'class="w3-button w3-xlarge w3-red w3-display-topright" title="Close Modal">X</span>');
            modGUI1.ChiudiDiv;
            modGUI1.apriForm(gruppo2.gr2||'menuOpere');
            -- Ordinamento opere
            modGUI1.ApriDiv('class="w3-container w3-cell w3-left" style="width:50%" ');
                htp.br;
                modGUI1.label('Ordina per: ');
                htp.br;htp.br;htp.br;    
                modGUI1.label('Nome contiene: ');
                htp.br;htp.br;htp.br;
                modGUI1.label('Filtra per museo proprietario: ');
                htp.br;htp.br;htp.br;
                modGUI1.label('Filtra per autore: ');
                htp.br;htp.br;
                modGUI1.label('Dal: ');
                modGUI1.inputNumber(NULL,'AnnoFilterInizio',1,0);
            --TODO anno decrescente
            modGUI1.SelectClose;
            modGUI1.ChiudiDiv;
            modGUI1.ApriDiv('class="w3-container w3-cell" style="width:50%" ');
                modGUI1.selectOpen('orderBy');
                modGUI1.selectoption('Titolo','Titolo',0);
                modGUI1.selectoption('Anno','Anno (crescente)',0);
                modGUI1.SelectClose;
                htp.br;
                modGUI1.inputtext('nameFilter', 'Filtra per nome...', 0);
                htp.br;
                modGUI1.selectOpen('museoFilter');
                modGUI1.selectOption(0,'-- select an option -- ',0);
                FOR varMuseo IN (SELECT DISTINCT idMuseo,nome FROM Musei)
                LOOP
                    modGUI1.SelectOption(varMuseo.idMuseo, varMuseo.nome, 0);
                END LOOP;
                modGUI1.SelectClose;
                htp.br;
                modGUI1.selectOpen('AutoriFilter');
                modGUI1.selectOption(0,'-- select an option -- ',0);
                FOR varAutore IN (SELECT DISTINCT idAutore,nome,cognome FROM Autori)
                LOOP
                    modGUI1.SelectOption(varAutore.idAutore, varAutore.nome||' '|| varAutore.cognome, 0);
                END LOOP;
                modGUI1.SelectClose;
                htp.br;
                modGUI1.label('Al: ');
                modGUI1.inputNumber(NULL,'AnnoFilterFine',1,2022);
            modGUI1.ChiudiDiv;
            modGUI1.inputSubmit('Applica');
            htp.prn('<span onclick="document.getElementById(''filtraOpere'').style.display=''none''" '
                    ||'class="w3-button w3-block w3-black w3-section w3-padding" title="Close Modal">Annulla</span>');
            modGUI1.ChiudiForm;

        modGUI1.ChiudiDiv;
    modGUI1.ChiudiDiv; 
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
 * - Collaborazioni effettuate ✅
 * - Opere dell’Autore presenti in un Museo scelto ✅
 * - Autori in vita le cui Opere sono esposte in un Museo scelto ✅
 */

PROCEDURE filtraAutori(
    caller VARCHAR2 DEFAULT 'menuAutori'
)
 IS
BEGIN
    modGUI1.ApriDiv('id="filtraAuth" class="w3-modal"');
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
            modGUI1.ApriDiv('class="w3-center"');
                htp.prn('<span onclick="document.getElementById(''filtraAuth'').style.display=''none''" '
                    ||'class="w3-button w3-xlarge w3-red w3-display-topright" title="Close Modal">X</span>');
            modGUI1.ChiudiDiv;

            modGUI1.apriForm(gruppo2.gr2||caller);
            -- Ordinamento autori
            modGUI1.label('Ordina per: ');
            modGUI1.selectOpen('orderBy');
            modGUI1.selectoption('Cognome','Cognome',0);
            modGUI1.selectoption('Nome','Nome',0);
            modGUI1.selectoption('DataNascita','Data nascita (crescente)',0);
            modGUI1.selectoption('DataMorte','Data morte (crescente)',0);
            modGUI1.SelectClose;
            htp.br;
            modGUI1.label('Nome contiene: ');
            modGUI1.inputtext('nameFilter', 'Filtra per nome...', 0);
            htp.br;
            modGUI1.label('Cognome contiene: ');
            modGUI1.inputtext('surnameFilter', 'Filtra per cognome...', 0);
            htp.br;
            modGUI1.label('Nazionalit&agrave;: ');
            modGUI1.selectOpen('nationFilter');
            modGUI1.emptyselectoption(1);
            FOR nation IN (SELECT DISTINCT Nazionalita FROM Autori ORDER BY nazionalita ASC)
            LOOP
                modGUI1.SelectOption(nation.Nazionalita, nation.Nazionalita, 0);
            END LOOP;
            modGUI1.SelectClose;

            modGUI1.inputSubmit('Applica');
            htp.prn('<span onclick="document.getElementById(''filtraAuth'').style.display=''none''" '
                    ||'class="w3-button w3-block w3-black w3-section w3-padding" title="Close Modal">Annulla</span>');
            modGUI1.ChiudiForm;

        modGUI1.ChiudiDiv;
    modGUI1.ChiudiDiv;
END;

--procedura per la visualizzazione del menu Autori
PROCEDURE menuAutori(
    orderBy varchar2 default 'Cognome',
    nameFilter varchar2 default '',
    surnameFilter varchar2 default '',
    nationFilter varchar2 default ''
) is
idSessione NUMBER(5) := modgui1.get_id_sessione();
TYPE cursoreAutori_T IS REF CURSOR;
listaAutori_cursor cursoreAutori_T;
variable_select varchar2(512) := 
    'SELECT *
    FROM Autori
    WHERE Eliminato=0 
        AND UPPER(Nome) LIKE ''%''||UPPER(:1)||''%''
        AND UPPER(cognome) LIKE ''%''||UPPER(:2)||''%''
        AND UPPER(nazionalita) LIKE ''%''||UPPER(:3)||''%''
    ORDER BY ';
autore Autori%ROWTYPE;
BEGIN
    modGUI1.ApriPagina('Autori', idSessione);
    -- se idSessione è null allora viene passato a modGUI1.Header, 
    -- che non prende quindi il valore di default 0
    modGUI1.Header;
    htp.br;htp.br;htp.br;htp.br;
    modGUI1.ApriDiv('class="w3-center"');
        htp.prn('<h1>Autori</h1>'); --TITOLO
        -- Filtro visualizzazione
        htp.prn('<button onclick="document.getElementById(''filtraAuth'').style.display=''block''"'
            ||' class="w3-btn w3-round-xxlarge w3-black">Filtra</button>');
        htp.br;htp.br;
        -- Altri bottoni con privilegi
        if hasRole(idSessione, 'DBA') or hasRole(idSessione, 'SU') or hasRole(idSessione, 'GO')
        then
            modGUI1.Collegamento('Inserisci',
                gruppo2.gr2||'InserisciAutore?caller=menuAutori&callerParams=//orderBy='
                    ||orderBy||'//nameFilter='||nameFilter||'//surnameFilter='||surnameFilter||'//nationFilter='||nationFilter,
                'w3-btn w3-round-xxlarge w3-black');
            htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
            modGUI1.Collegamento('Menu Autori Eliminati', 
                gruppo2.gr2||'menuAutoriEliminati', 
                'w3-button w3-black w3-round-xxlarge');
            htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
        end if;
        IF hasRole(idSessione, 'DBA') OR hasRole(idSessione, 'SU') THEN
            htp.prn('<button onclick="document.getElementById(''11'').style.display=''block''" class="w3-btn w3-round-xxlarge w3-black">Statistiche</button>');
        END IF;


    modGUI1.ChiudiDiv;
    
    gruppo2.selezioneOpStatAut;
    filtraAutori('menuAutori');

    htp.br;
    modGUI1.ApriDiv('class="w3-row w3-container"');
    -- Banner ordinamento corrente
    modGUI1.ApriDiv('class="w3-padding-large w3-center"');
    htp.prn('<h4>'||orderBy||' &#8645;</h4>');
    modGUI1.ChiudiDiv;
    --Visualizzazione TUTTI GLI AUTORI *temporanea*
    -- Filtro: autori non eliminati
    OPEN listaAutori_cursor FOR variable_select||orderBy USING nameFilter, surnameFilter, nationFilter;
    LOOP
    FETCH listaAutori_cursor INTO autore;
        EXIT WHEN listaAutori_cursor%NOTFOUND;
        modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
            modGUI1.ApriDiv('class="w3-card-4"');
                htp.prn('<img src="http://www.visitoslo.com/contentassets/3932b41a7b684b40a28d3195191265fe/edvard-munch-nasjonalbiblioteket.jpg" alt="Alps" style="width:100%;">');
                modGUI1.ApriDiv('class="w3-container w3-center"');
                    htp.prn('<p>'|| autore.Nome ||' '||autore.Cognome||'</p>');
                    htp.prn('<p>(');
                    IF autore.DataNascita IS NULL THEN
                        htp.prn('Sconosciuta');
                    ELSE
                        htp.prn(TO_CHAR(autore.dataNascita, 'DD-MM-YYYY'));
                    END IF;
                    htp.prn('&nbsp;-&nbsp;');
                    IF autore.DataMorte IS NULL THEN
                        htp.prn('Sconosciuta');
                    ELSE
                        htp.prn(TO_CHAR(autore.dataMorte, 'DD-MM-YYYY'));
                    END IF;
                    htp.prn(')</p>');
                modGUI1.ChiudiDiv;
                if not (HASROLE(idSessione, 'GM') or HASROLE(idSessione, 'GCE')) THEN
                modGUI1.Collegamento('Visualizza',
                    gruppo2.gr2||'ModificaAutore?authorID='||autore.IdAutore||'&operazione=0&caller=menuAutori&callerParams=//orderBy='
                    ||orderBy||'//nameFilter='||nameFilter||'//surnameFilter='||surnameFilter||'//nationFilter='||nationFilter,
                    'w3-black w3-margin w3-button');
                END IF;
                IF hasRole(idSessione, 'DBA')  or hasRole(idSessione, 'GO') THEN
                    -- parametro modifica messo a true: possibile fare editing dell'autore
                    modGUI1.Collegamento('Modifica',
                        gruppo2.gr2||'ModificaAutore?authorID='||autore.IdAutore||'&operazione=1&caller=menuAutori&callerParams=//orderBy='
                        ||orderBy||'//nameFilter='||nameFilter||'//surnameFilter='||surnameFilter||'//nationFilter='||nationFilter,
                        'w3-green w3-margin w3-button');
                    -- Setta ad eliminato un autore
                    htp.prn('<button onclick="document.getElementById(''ElimAutore'||autore.IdAutore
                        ||''').style.display=''block''" class="w3-margin w3-button w3-red w3-hover-white">Elimina</button>');
                    gruppo2.EliminazioneAutore(autore.IdAutore);
                END IF;
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
    END LOOP;
    modGUI1.chiudiDiv;
END menuAutori;

PROCEDURE menuAutoriEliminati(
    orderBy varchar2 default 'Cognome',
    nameFilter varchar2 default '',
    surnameFilter varchar2 default '',
    nationFilter varchar2 default ''
) is
idSessione NUMBER(5) := modgui1.get_id_sessione();
TYPE cursoreAutori_T IS REF CURSOR;
listaAutori_cursor cursoreAutori_T;
variable_select varchar2(512) := 
    'SELECT *
    FROM Autori
    WHERE Eliminato=1 
        AND UPPER(Nome) LIKE ''%''||UPPER(:1)||''%''
        AND UPPER(cognome) LIKE ''%''||UPPER(:2)||''%''
        AND UPPER(nazionalita) LIKE ''%''||UPPER(:3)||''%''
    ORDER BY ';
autore Autori%ROWTYPE;
BEGIN
    modGUI1.ApriPagina('Autori Eliminati', idSessione);
    modGUI1.Header;
    htp.br;htp.br;htp.br;htp.br;

    modGUI1.ApriDiv('class="w3-center"');
        htp.prn('<h1>Autori eliminati</h1>');
        -- Filtro visualizzazione
        htp.prn('<button onclick="document.getElementById(''filtraAuth'').style.display=''block''"'
            ||' class="w3-btn w3-round-xxlarge w3-black">Filtra</button>');
        htp.br;htp.br;
        if hasRole(idSessione, 'DBA') or hasRole(idSessione, 'SU') or hasRole(idSessione, 'GO')
        then
            modGUI1.Collegamento('Torna al menu autori', 
                gruppo2.gr2||'menuAutori', 
                'w3-button w3-black w3-round-xxlarge');
            htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
        end if;
    modGUI1.ChiudiDiv;

    filtraAutori('menuAutoriEliminati');

    htp.br;
    modGUI1.ApriDiv('class="w3-row w3-container"');
    -- Banner ordinamento corrente
    modGUI1.ApriDiv('class="w3-padding-large w3-center"');
    htp.prn('<h4>'||orderBy||' &#8645;</h4>');
    modGUI1.ChiudiDiv;
    --Visualizzazione TUTTI GLI AUTORI *temporanea*
    -- Filtro: mostrati soltanto autori eliminati (al DBA e SU)
    OPEN listaAutori_cursor FOR variable_select||orderBy USING nameFilter, surnameFilter, nationFilter;
    LOOP
    FETCH listaAutori_cursor INTO autore;
        EXIT WHEN listaAutori_cursor%NOTFOUND;
        modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
            modGUI1.ApriDiv('class="w3-card-4"');
                htp.prn('<img src="http://www.visitoslo.com/contentassets/3932b41a7b684b40a28d3195191265fe/edvard-munch-nasjonalbiblioteket.jpg" alt="Alps" style="width:100%;">');
                modGUI1.ApriDiv('class="w3-container w3-center"');
                    htp.prn('<p>'|| autore.Nome ||' '||autore.Cognome||'</p>');
                    htp.prn('<p>(');
                    IF autore.DataNascita IS NULL THEN
                        htp.prn('Sconosciuta');
                    ELSE
                        htp.prn(TO_CHAR(autore.dataNascita, 'DD-MM-YYYY'));
                    END IF;
                    htp.prn('&nbsp;-&nbsp;');
                    IF autore.DataMorte IS NULL THEN
                        htp.prn('Sconosciuta');
                    ELSE
                        htp.prn(TO_CHAR(autore.dataMorte, 'DD-MM-YYYY'));
                    END IF;
                    htp.prn(')</p>');
                modGUI1.ChiudiDiv;
                -- Azioni di modifica e rimozione mostrate solo se autorizzatii
                modGUI1.Collegamento('Visualizza',
                    gruppo2.gr2||'ModificaAutore?authorID='||autore.IdAutore||'&operazione=0'
                    ||'&caller=menuAutoriEliminati',
                    'w3-black w3-margin w3-button');
                if hasRole(idSessione, 'DBA') or hasRole(idSessione, 'SU') then
                    modGUI1.Collegamento('Ripristina',
                        gruppo2.gr2||'ripristinaAutore?authID='||autore.IdAutore,
                        'w3-btn w3-green');
                    htp.print('&nbsp;');
                    htp.prn('<button onclick="document.getElementById(''RimozioneAutore'||autore.IdAutore||''').style.display=''block''" class="w3-margin w3-button w3-red w3-hover-white">Rimuovi</button>');
                    gruppo2.RimozioneAutore(autore.IdAutore);
                END IF;
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
    END LOOP;
    modGUI1.chiudiDiv;
END menuAutoriELiminati;

procedure ripristinaAutore(
    authID NUMBER DEFAULT 0
)IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
auth Autori%ROWTYPE;
BEGIN
    SELECT * INTO auth from Autori where IdAutore=authID;
    UPDATE AUTORI SET eliminato=0 WHERE IDAUTORE=authID;
    modGUI1.RedirectEsito('Ripristino riuscito', 
            'L''autore '||auth.Nome||' '||auth.Cognome||' è stato ripristinato', 
            'Torna al menu autori eliminati', gruppo2.gr2||'menuAutoriELiminati', null,
            'Torna al menu autori', gruppo2.gr2||'menuAutori', null);
END;


--Procedura popUp per la conferma
procedure EliminazioneAutore(
    authorID NUMBER default 0
) IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
aName Autori.Nome%TYPE;
aSurname Autori.Nome%TYPE;
BEGIN
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
                        htp.prn('stai per eliminare: '||aName||' '||aSurname);
                        modGUI1.Collegamento('Conferma',
                        gruppo2.gr2||'SetAutoreEliminato?authorID='||authorID,
                        'w3-button w3-block w3-green w3-section w3-padding');
                        htp.prn('<span onclick="document.getElementById(''ElimAutore'||authorID||''').style.display=''none''" class="w3-button w3-block w3-red w3-section w3-padding" title="Close Modal">Annulla</span>');
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiForm;
        modGUI1.ChiudiDiv;
    modGUI1.ChiudiDiv;
end EliminazioneAutore;

-- Procedura per settare autore a eliminato
procedure SetAutoreEliminato(
    authorID NUMBER default 0
) IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
auth Autori%ROWTYPE;
BEGIN
    SELECT * INTO auth from Autori where IdAutore=authorID;
    IF auth.Eliminato = 1 THEN
        modGUI1.RedirectEsito('Eliminazione fallita', 
            'L''autore '||auth.Nome||' '||auth.Cognome||' è già stato eliminato', 
            null, null, null,
            'Torna al menu autori', gruppo2.gr2||'menuAutori', null);
            rollback;
    ELSE
        UPDATE Autori SET Eliminato=1 WHERE IdAutore = authorID;
        modGUI1.RedirectEsito('Eliminazione riuscita', 
            'L''autore '||auth.Nome||' '||auth.Cognome||' è stato eliminato', 
            'Vai al menu autori eliminati', gruppo2.gr2||'menuAutoriEliminati', null,
            'Torna al menu autori', gruppo2.gr2||'menuAutori', null);
        commit;
    END IF;
END SetAutoreEliminato;

--Procedura rimozione autore
procedure RimozioneAutore(
    authorID NUMBER default 0
) IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
auth Autori%ROWTYPE;
BEGIN
    modGUI1.ApriDiv('id="RimozioneAutore'||authorID||'" class="w3-modal"');
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
            modGUI1.ApriDiv('class="w3-center"');
                htp.br;
                htp.prn('<span onclick="document.getElementById(''RimozioneAutore'||authorID||''').style.display=''none''" class="w3-button w3-xlarge w3-red w3-display-topright" title="Close Modal">X</span>');
            htp.print('<h1><b>Confermi?</b></h1>');
            modGUI1.ChiudiDiv;
                    modGUI1.ApriDiv('class="w3-section"');
                        htp.br;
                        SELECT * INTO auth FROM Autori WHERE IdAutore=authorID;
                        htp.prn('stai per rimuovere: '||auth.Nome||' '||auth.Cognome);
                        modGUI1.Collegamento('Conferma',
                        gruppo2.gr2||'DeleteAutore?authorID='||authorID,
                        'w3-button w3-block w3-green w3-section w3-padding');
                        htp.prn('<span onclick="document.getElementById(''RimozioneAutore'||authorID||''').style.display=''none''" class="w3-button w3-block w3-red w3-section w3-padding" title="Close Modal">Annulla</span>');
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiForm;
        modGUI1.ChiudiDiv;
    modGUI1.ChiudiDiv;
end RimozioneAutore;

PROCEDURE DeleteAutore(
    authorID NUMBER DEFAULT 0
) IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
auth autori%ROWTYPE;
numOpereRealizzate NUMBER(5); 
BEGIN
    -- non è possibile rimuovere un autore che ha realizzato almeno un opera
    -- se non si rimuovono prima le opere in questione
    SELECT * into auth FROM AUTORI WHERE IDAUTORE=authorID;
    SELECT COUNT(*) INTO numOpereRealizzate FROM AutoriOpere WHERE IdAutore=authorID;
    IF numOpereRealizzate > 0
    THEN
        -- esito negativo: solo opzione per tornare al menu
        modGUI1.RedirectEsito('Rimozione fallita',
            'L''autore '||auth.Nome||' '||auth.Cognome||' ha delle opere nella base di dati',
            null, null, null,
            'Torna al menu Autori',
            gruppo2.gr2||'menuAutori');
    ELSE
        DELETE FROM Autori WHERE IdAutore=authorID;
        -- esito positivo: solo opzione per tornare al menu
            modGUI1.RedirectEsito('Rimozione riuscita', 
            'L''autore '||auth.Nome||' '||auth.Cognome||' è stato rimosso', 
            'Torna al menu autori eliminati', gruppo2.gr2||'menuAutoriELiminati', null,
            'Torna al menu autori', gruppo2.gr2||'menuAutori', null);
        -- Setto autore ad eliminato
        commit;
    END IF;
END;

procedure selezioneOpStatAut IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
    BEGIN
        modGUI1.ApriDiv('id="11" class="w3-modal"');
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
                modGUI1.ApriDiv('class="w3-center"');
                    htp.br;
                    htp.prn('<span onclick="document.getElementById(''11'').style.display=''none''" class="w3-button w3-xlarge w3-red w3-display-topright" title="Close Modal">X</span>');
                htp.print('<h1>Seleziona l''operazione</h1>');
                modGUI1.ChiudiDiv;
                    modGUI1.ApriForm(gruppo2.gr2||'selezioneAutoreStatistica','seleziona statistica','w3-container');
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
                        MODGUI1.InputRadioButton('Autori pi&ugrave; prolifici', 'operazione', 5);
                        htp.print('</h4>');
                        htp.br;
                        htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit">Seleziona</button>');
                        modGUI1.ChiudiDiv;
                    modGUI1.ChiudiForm;
            modGUI1.ChiudiDiv;
    modGUI1.ChiudiDiv;
END selezioneOpStatAut;

procedure selezioneAutoreStatistica(
    operazione NUMBER DEFAULT 0
)IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
nomecompleto VARCHAR2(50);
    BEGIN
    modGUI1.ApriPagina('Selezione statistica', idSessione);
    modGUI1.Header;
    htp.br;htp.br;htp.br;htp.br;

    -- Salto selezione autore per statistica 4
    IF operazione = 4 THEN
        gruppo2.selezioneMuseoAutoreStatistica(operazione, 0);
    -- Salto alla statistica 5 (classifica autori più prolifici)
    ELSIF operazione = 5 THEN
        gruppo2.classificaAutori;

    ELSE
    htp.prn('<h1 align="center">Seleziona l''autore</h1>');
    modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:700px"');
        modGUI1.ApriDiv('class="w3-section"');
            -- Link di ritorno al menuAutori
            modGUI1.Collegamento('X',
                gruppo2.gr2||'menuAutori',
                'w3-btn w3-large w3-red w3-display-topright');
            -- Form per mandare dati alla procedura di conferma
            modGUI1.ApriDiv('class="w3-center"');
            if operazione < 3 THEN
                modGUI1.ApriForm(gruppo2.gr2||'StatisticheAutori');
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
                modGUI1.ApriForm(gruppo2.gr2||'StatisticheMuseoAutori');
                htp.FORMHIDDEN('operazione',operazione);
                MODGUI1.SELECTOPEN('authID', 'authID');
                FOR an_auth IN (SELECT IdAutore,Nome,COGNOME FROM AUTORI ORDER BY NOME ASC)
                LOOP
                    nomecompleto := an_auth.Nome||' '||an_auth.cognome;
                    modGUI1.SELECTOPTION(an_auth.IdAutore, nomecompleto, 0);
                END LOOP;
                MODGUI1.SELECTClose;
                htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                MODGUI1.SELECTOPEN('museoID', 'museoID');
                FOR an_mus IN (SELECT IDMUSEO,NOME FROM MUSEI ORDER BY NOME ASC)
                LOOP
                    modGUI1.SELECTOPTION(an_mus.idmuseo, an_mus.Nome, 0);
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

FUNCTION listaCollaborazioni(
	authorID Autori.IdAutore%TYPE)
RETURN collaborazioniCollection
IS
i PLS_INTEGER := 0;
collabs collaborazioniCollection;
a_collab collabRecord;
BEGIN
	-- Inizializzo a collezione vuota
	collabs := emptyCollab;
	-- Ottengo tutte le collaborazioni di authorID e le metto nella collezione
	-- Ordinate per l'id del collaboratore
	FOR rec IN (
		SELECT OP.IdOpera Opera,
			OP.Titolo Titolo,
			A2.IdAutore IdCollab,
			A2.Nome NomeCollab, 
			A2.Cognome CognomeCollab
    	FROM AutoriOpere AO JOIN AutoriOpere AO2 ON AO.IdOpera = AO2.IdOpera
			JOIN Opere OP ON AO.IdOpera = OP.IdOpera
			JOIN Autori A2 ON AO2.IdAutore = A2.IdAutore
    	WHERE AO.IdAutore = authorID AND A2.IdAutore <> AO.IdAutore
		ORDER BY A2.IdAutore)
	LOOP
		a_collab := rec;
		collabs(i) := a_collab;
		i := i + 1;
	END LOOP;
	return collabs;
END listaCollaborazioni;

Procedure StatisticheAutori(
    operazione NUMBER DEFAULT 0,
    authID NUMBER DEFAULT 0
)IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
auth Autori%ROWTYPE;
prevMuseo Musei.idmuseo%TYPE;
museoProprietario Musei%ROWTYPE;

CURSOR lista_musei (author NUMBER) IS 
    SELECT OE.Museo,OE.Nome,count(*) NumOpere
    FROM OpereEsposte OE JOIN AutoriOpere AO ON OE.Opera = AO.IdOpera 
        JOIN Opere OP ON AO.IdOpera = OP.IdOpera
    WHERE AO.IdAutore = author
    GROUP BY OE.Museo,OE.Nome;
CURSOR lista_opere (author NUMBER, museum NUMBER) IS 
    SELECT OP.Titolo, OP.IdOpera 
    FROM OpereEsposte OE JOIN AutoriOpere AO ON OE.Opera = AO.IdOpera 
        JOIN Opere OP ON AO.IdOpera = OP.IdOpera
    WHERE AO.IdAutore = author AND OE.Museo = museum
    ORDER BY OP.titolo;

i PLS_INTEGER := 0;
tot_collab NUMBER(10);
all_collabs collaborazioniCollection := emptyCollab;
collab gruppo2.collabRecord;
prevCollab gruppo2.collabRecord;
BEGIN
SELECT * INTO auth FROM autori WHERE authID=IDAUTORE;
    MODGUI1.ApriPagina('StatisticheAutori',idSessione);
        modGUI1.Header;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
        modGUI1.ApriDiv('class="w3-center"');
            htp.prn('<h1><b>STATISTICHE AUTORE</b></h1>'); --TITOLO
            htp.prn('<h4><b>'||auth.nome||' '||auth.cognome||'</b></h4>');
            modGUI1.Collegamento('Torna al menu',
                gruppo2.gr2||'menuAutori','w3-black w3-margin w3-button');
        modGUI1.ChiudiDiv;
        htp.br;

        --OPERE REALIZZATE (raggruppate per museo di appartenenza)
        if operazione=0 THEN 
        modGUI1.ApriDiv('class="w3-container" style="width:100%"');
        htp.print('<h2><b>Opere realizzate da ');
        modGUI1.Collegamento(auth.Nome||' '||auth.Cognome, 
            gruppo2.gr2||'ModificaAutore?authorID='||auth.IdAutore||'&operazione=0'
            ||'&caller=statisticheAutori'||'&callerParams=//operazione='||operazione||'//authID='||authID);
        htp.print('</b></h2>');

            prevMuseo := -1;
            FOR op IN (SELECT IdOpera, Titolo, Anno, Museo
                FROM OPERE JOIN AUTORIOPERE using (IdOpera)
                WHERE IDAUTORE=AUTH.idautore
                ORDER BY Museo, Titolo)
            LOOP
                IF prevMuseo != op.Museo THEN
                    modGUI1.ApriDiv('class="w3-row"');
                    SELECT * INTO MuseoProprietario FROM Musei WHERE IdMuseo = op.Museo;
                    htp.prn('<b><h4>Opere di proprietà di ');
                    modGUI1.Collegamento(MuseoProprietario.Nome, 
                                gruppo2.gr4||'visualizzaMusei?MuseoID='||MuseoProprietario.IdMuseo);
                    htp.prn('</b></h4>');
                    modGUI1.ChiudiDiv;
                    prevMuseo := op.Museo;
                END IF;
                modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                    modGUI1.ApriDiv('class="w3-card-4" style="height:600px;"');
                    htp.prn('<img src="https://www.stateofmind.it/wp-content/uploads/2018/01/La-malattia-rappresentata-nelle-opere-darte-e-in-letteratura-680x382.jpg" alt="Alps" style="width:100%;">');
                            modGUI1.ApriDiv('class="w3-container w3-center"');
                                htp.prn('<p> Titolo: '|| op.titolo ||'</p>');
                                htp.br;
                                htp.prn('<p>Anno di realizzazione: '|| op.anno ||'</p>');
                                htp.br;
                                htp.prn('<button onclick="document.getElementById(''LinguaeLivelloOpera'||op.IDOPERA||''').style.display=''block''" class="w3-margin w3-button w3-black w3-hover-white">Visualizza</button>');
                                gruppo2.linguaELivello(op.IDOPERA);
                            modGUI1.ChiudiDiv;
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
            END LOOP;
        end IF;

        -- MUSEI CON OPERE ESPOSTE
        IF operazione=1 THEN
        modGUI1.ApriDiv('class="w3-container" style="width:100%"');
        htp.print('<h2><b>Musei con opere di ');
        modGUI1.Collegamento(auth.Nome||' '||auth.Cognome, 
            gruppo2.gr2||'ModificaAutore?authorID='||auth.IdAutore||'&operazione=0'
            ||'&caller=statisticheAutori'||'&callerParams=//operazione='||operazione||'//authID='||authID);
        htp.print(' esposte</b></h2>');

        -- Passando ai cursori i parametri appropriati viene mostrato ogni museo
        -- nel quale sono esposte opere dell'autore ed un form per visualizzarle (con select)
        FOR mus IN lista_musei(auth.IdAutore)
        LOOP
            modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                modGUI1.ApriDiv('class="w3-card-4"');
                htp.prn('<img src="https://upload.wikimedia.org/wikipedia/commons/6/68/Museo_del_Prado_2016_%2825185969599%29.jpg" alt="Alps" style="width:100%;">');
                        modGUI1.ApriDiv('class="w3-container w3-center"');
                            -- Nome del museo + numero di opere dell'autore esposte in quel museo
                            htp.prn('<p><b>'||mus.Nome||' ('||mus.NumOpere||' opere presenti)</b></p>');
                            modGUI1.Collegamento('Visualizza Museo', 
                                gruppo2.gr4||'visualizzaMusei?MuseoID='||mus.Museo,
                                'w3-black w3-margin w3-button');
                        -- Form per selezione opera da visualizzare (titolo + lingua + livello)
                        modGUI1.ApriForm(gruppo2.gr2||'visualizzaOpera');
                            modGUI1.label('Titolo: ');
                            htp.br;
                            modGUI1.SelectOpen('operaID', 'operaID');
                            FOR opera IN lista_opere(auth.IdAutore, mus.Museo)
                            LOOP
                                modGUi1.SelectOption(opera.IdOpera, opera.Titolo);
                            END LOOP;
                            modGUI1.SelectClose;
                            --
                            -- Bottone submit + script per fill
                            -- Quando viene premuto il bottone "Visualizza Opera" viene inserito
                            -- nel popup lingue e livelli l'ID dell'opera e deselezionate le scelte
                            -- precedenti (i due for nello script)
                            htp.prn('<button onclick=setOperaPopup() '
                            ||'class="w3-margin w3-button w3-black w3-hover-white">Visualizza Opera</button>');

                            htp.script('function setOperaPopup() {
                                var selectedWork = document.getElementById(''operaID'').value;
                                var levelButtons = document.getElementsByName(''livelli'');
                                for(i=0; i < levelButtons.length; i++) {
                                    levelButtons[i].checked = false;
                                }
                                var langButtons = document.getElementsByName(''lingue'');
                                for(i=0; i < langButtons.length; i++) {
                                    langButtons[i].checked = false;
                                }
                                document.getElementById(''hiddenOperaID'').value = selectedWork;
                                document.getElementById(''LinguaeLivelloOpera0'').style.display = ''block'';
                            }');

                        -- Popup senza parametri: va di default a idOpera=0 (usato nello script sopra)
                        -- e poi viene cambiato dinamicamente
                        gruppo2.linguaelivello;
                        
                        modGUI1.ChiudiForm;
                        modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
        END LOOP;

        END IF;

        --COLLABORAZIONI EFFETTUATE
        if operazione=2 THEN
            -- Ottengo tutte le collaborazioni effettuate dall'autore authID
            all_collabs := listaCollaborazioni(authID);
            i := all_collabs.FIRST;
            prevCollab := NULL;

            modGUI1.ApriDiv('class="w3-container" style="width:100%"');
            htp.print('<h2><b>Opere create in collaborazione da ');
            modGUI1.Collegamento(auth.Nome||' '||auth.Cognome, 
            gruppo2.gr2||'ModificaAutore?authorID='||auth.IdAutore||'&operazione=0'
            ||'&caller=statisticheAutori'||'&callerParams=//operazione='||operazione||'//authID='||authID);
            htp.prn(': '||all_collabs.COUNT||'</b></h2>');

            WHILE i IS NOT NULL LOOP
                collab := all_collabs(i);
                i := all_collabs.NEXT(i);

                IF (prevCollab.collabNome IS NULL OR prevCollab.collabNome != collab.collabNome) THEN
                    modGUI1.ApriDiv('class="w3-row"');
                    htp.prn('<h4><b>Opere in collaborazione con ');
                    modGUI1.Collegamento(collab.collabNome||' '||collab.collabCognome, 
                    gruppo2.gr2||'ModificaAutore?authorID='||collab.collabID||'&operazione=0'
                    ||'&caller=statisticheAutori'||'&callerParams=//operazione='||operazione||'//authID='||authID);
                    htp.prn('</b></h4>');
                    modGUI1.ChiudiDiv;
                END IF;
                modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');

                    modGUI1.ApriDiv('class="w3-card-4" style="height:600px;"');
                    htp.prn('<img src="https://www.stateofmind.it/wp-content/uploads/2018/01/La-malattia-rappresentata-nelle-opere-darte-e-in-letteratura-680x382.jpg" alt="Alps" style="width:100%;">');
                            modGUI1.ApriDiv('class="w3-container w3-center"');
                                htp.prn('<p>'|| collab.titolo ||'</p>');
                                htp.br;
                                --htp.prn('<p>'|| op.anno ||'</p>');
                                htp.prn('<button onclick="document.getElementById(''LinguaeLivelloOpera'||collab.opera||''').style.display=''block''" class="w3-margin w3-button w3-black w3-hover-white">Visualizza</button>');
                                gruppo2.linguaELivello(collab.opera);
                            modGUI1.ChiudiDiv;
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
                prevCollab := collab;
            END LOOP;
        end IF;
    EXCEPTION
        WHEN OTHERS THEN
            modGUI1.esitooperazione(pagetitle  => 'Errore procedura',
                                    msg  => '<p>'||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - '||sqlerrm||'</p>',
                                    nuovaop  => null,
                                    nuovaopurl  => null,
                                    parametrinuovaop  => null,
                                    backtomenu  => 'Ritorna al menu autori',
                                    backtomenuurl  => gruppo2.gr2||'menuAutori',
                                    parametribacktomenu  => null);
END;

procedure selezioneMuseoAutoreStatistica(
    operazione NUMBER DEFAULT 0, 
    authID NUMBER DEFAULT 0
)IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
BEGIN
modGUI1.ApriPagina('Selezione statistica', idSessione);
    modGUI1.Header;
    htp.br;htp.br;htp.br;htp.br;

    htp.prn('<h1 align="center">Seleziona il museo</h1>');
    modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
        modGUI1.ApriDiv('class="w3-section"');
            -- Link di ritorno al menuAutori
            modGUI1.Collegamento('X',
                gruppo2.gr2||'menuAutori',
                'w3-btn w3-large w3-red w3-display-topright');
            -- Form per mandare dati alla procedura di conferma
            modGUI1.ApriDiv('class="w3-center"');
            modGUI1.ApriForm(gruppo2.gr2||'StatisticheMuseoAutori');
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
    operazione NUMBER DEFAULT 0,
    authID NUMBER DEFAULT 0,
    museoID NUMBER DEFAULT 0
)IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
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
    modGUI1.Header;
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
            gruppo2.gr2||'menuAutori',
            'w3-white w3-margin w3-button w3-border');
    modGUI1.ChiudiDiv;
    htp.br;

    modGUI1.ApriDiv('class="w3-container" style="width:100%"');
    -- Statistica 3: Opere dell'autore <auth> esposte nel museo <mus>
    IF operazione = 3 THEN
        htp.prn('<h4><b>Opere realizzate da ');
        modGUI1.Collegamento(auth.Nome||' '||auth.Cognome, 
                gruppo2.gr2||'ModificaAutore?authorID='||auth.IdAutore||'&operazione=0'
                ||'&caller=StatisticheMuseoAutori'
                ||'&callerParams=//operazione='||operazione||'//authID='||authID||'//museoID='||museoID);
        htp.prn(' esposte in ');
        modGUI1.Collegamento(mus.Nome,
                gruppo2.gr4||'visualizzaMusei?MuseoID='||mus.IdMuseo);
    htp.prn('</b></h4>');
        FOR op IN (
            SELECT Opera AS IdOpera,Titolo,Anno -- se usate altri attributi nella pagina aggiungeteli qui
            FROM OPERE JOIN AUTORIOPERE ON OPERE.IdOpera = AUTORIOPERE.IdOpera
                JOIN SALEOPERE ON OPERE.IdOpera = SALEOPERE.Opera
            WHERE IDAUTORE=AUTH.idautore AND SaleOpere.datauscita IS NULL AND SALEOPERE.Sala IN 
                (SELECT STANZE.IdStanza FROM Stanze WHERE STANZE.Museo = museoID))
        LOOP
            modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                modGUI1.ApriDiv('class="w3-card-4" style="height:600px;"');
                htp.prn('<img src="https://www.stateofmind.it/wp-content/uploads/2018/01/La-malattia-rappresentata-nelle-opere-darte-e-in-letteratura-680x382.jpg" alt="Alps" style="width:100%;">');
                    modGUI1.ApriDiv('class="w3-container w3-center"');
                        htp.prn('<p>'|| op.Titolo ||'</p>');
                        htp.br;
                        htp.prn('<p>'|| op.Anno ||'</p>');
                        htp.prn('<button onclick="document.getElementById(''LinguaeLivelloOpera'
                            ||TO_CHAR(op.IdOpera)||''').style.display=''block''" class="w3-margin w3-button w3-black w3-hover-white">Visualizza</button>');
                        gruppo2.linguaELivello( op.IdOpera);
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
        END LOOP;
    -- statistica 4: Autori in vita le cui opere 
    ELSE
        htp.prn('<h4><b>Autori in vita con opere esposte in ');
        modGUI1.Collegamento(mus.Nome,
                    gruppo2.gr4||'visualizzaMusei?MuseoID='||mus.IdMuseo);
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
                htp.prn('<img src="http://www.visitoslo.com/contentassets/3932b41a7b684b40a28d3195191265fe/edvard-munch-nasjonalbiblioteket.jpg" alt="Alps" style="width:100%;">');
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
                            gruppo2.gr2||'ModificaAutore?authorID='||an_author.IdAutore||'&operazione=0'
                            ||'&caller=StatisticheMuseoAutori'
                            ||'&callerParams=//operazione='||operazione||'//authID='||authID||'//museoID='||museoID,
                            'w3-white w3-margin w3-button w3-border');
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
        END LOOP;
    END IF;
END statisticheMuseoAutori;


-- Procedura per l'inserimento di nuovi Autori nella base di dati
-- I parametri sono usati per effettuare il riempimento automatico del form e il possibile ritorno al menù
PROCEDURE InserisciAutore(
    authName VARCHAR2 DEFAULT NULL,
    authSurname VARCHAR2 DEFAULT NULL,
    dataNascita VARCHAR2 DEFAULT NULL, 
    dataMorte VARCHAR2 DEFAULT NULL,
    nation VARCHAR2 DEFAULT NULL,
    caller VARCHAR2 DEFAULT NULL,
    callerParams VARCHAR2 DEFAULT ''
) IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
placeholderNome VARCHAR2(255) := 'Inserisci il nome...';
placeholderCognome VARCHAR2(255) := 'Inserisci il cognome...';
placeholderNazionalita VARCHAR2(255) := 'Inserisci nazionalità...';
params VARCHAR2(255);
BEGIN
    -- script disabilita campo data
    htp.script('function disable_date(name) {
        var in_date = (document.getElementById(name));
        in_date.disabled = !(in_date.disabled);
        }', 'Javascript');
    
    -- Pagina di inserimento nuovo autore
    modGUI1.ApriPagina('Inserimento Autore', idSessione);
    modGUI1.Header;
    htp.br;htp.br;htp.br;htp.br;

    htp.prn('<h1 align="center">Inserimento Autore</h1>');
    modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
        modGUI1.ApriDiv('class="w3-section"');
            -- Link di ritorno al menuAutori
            modGUI1.Collegamento('X',
                gruppo2.gr2||'menuAutori',
                'w3-btn w3-large w3-red w3-display-topright');
            -- Form per mandare dati alla procedura di conferma
            modGUI1.ApriForm(gruppo2.gr2||'ConfermaDatiAutore');
            HTP.FORMHIDDEN('caller', caller);
            HTP.FORMHIDDEN('callerParams', callerParams);
            htp.br;
            modGUI1.Label('Nome*');
            modGUI1.InputText('authName', placeholderNome, 1, authName);
            htp.br;
            modGUI1.Label('Cognome*');
            modGUI1.InputText('authSurname', placeholderCognome, 1, authSurname);
            htp.br;
            -- Gli input di tipo data sono attivi sse la checkbox non è selezionata
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

            IF caller is not null THEN
            params := REPLACE(callerParams,'//','&');
                MODGUI1.collegamento('Annulla',
                gruppo2.gr2||caller||'?'||params,
                'w3-button w3-block w3-black w3-section w3-padding');
            END IF;
                
        modGUI1.ChiudiDiv;
    modGUI1.ChiudiDiv;
END;

-- Procedura per confermare i dati dell'inserimento di un Autore
PROCEDURE ConfermaDatiAutore(
    authName VARCHAR2 DEFAULT 'Sconosciuto',
    authSurname VARCHAR2 DEFAULT 'Sconosciuto',
    dataNascita VARCHAR2 DEFAULT NULL,
    dataMorte VARCHAR2 DEFAULT NULL,
    nation VARCHAR2 DEFAULT 'Sconosciuta',
    caller VARCHAR2 DEFAULT NULL,
    callerParams VARCHAR2 DEFAULT ''
) IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
numAutori NUMBER := 0;
birth DATE := to_date(dataNascita, 'YYYY-MM-DD');
death DATE := to_date(dataMorte, 'YYYY-MM-DD');
params VARCHAR2(255);
BEGIN
    -- Controllo autorizzazione
    IF NOT(hasRole(idSessione, 'GO') OR hasRole(idSessione, 'SU') OR hasRole(idSessione, 'DBA')) THEN
        modGUI1.RedirectEsito('Inserimento fallito',
            'Errore: Operazione non autorizzata (controlla di essere loggato)',
            'Torna all''inserimento',gruppo2.gr2||'InserisciAutore', 
            '//authName='||authName||'//authSurname='||authSurname||'//dataNascita='||dataNascita||
            '//dataMorte='||dataMorte||'//nation='||nation,
            'Torna al menù',gruppo2.gr2||'menuAutori');
    END IF;
    -- controllo parametri
    SELECT count(*) INTO numAutori FROM Autori A
    WHERE A.Nome = authName
        AND A.Cognome = authSurname
        AND (A.DataNascita = birth OR (A.DataNascita IS NULL AND birth IS NULL))
        AND (A.DataMorte = death OR (A.DataMorte IS NULL AND death IS NULL))
        AND A.Nazionalita = nation;
    IF numAutori > 0
    THEN
        modGUI1.RedirectEsito('Inserimento fallito',
            'Errore: Autore già presente',
            'Torna all''inserimento',gruppo2.gr2||'InserisciAutore?', 
            'authName='||authName||'//authSurname='||authSurname||'//dataNascita='||dataNascita||'//dataMorte='||dataMorte||'//nation='||nation,
            'Torna al menù',gruppo2.gr2||'menuAutori');
    -- I tre rami che seguono non possono essere raggiunti chiamando
    -- InserisciAutore, ma sono possibili chiamando direttamente ConfermaDatiAutore
    ELSIF authName IS NULL THEN
        modGUI1.RedirectEsito('Inserimento fallito',
            'Errore: Inserire Nome',
            'Torna all''inserimento',gruppo2.gr2||'InserisciAutore?', 
            'authName='||authName||'//authSurname='||authSurname||'//dataNascita='||dataNascita||'//dataMorte='||dataMorte||'//nation='||nation,
            'Torna al menù',gruppo2.gr2||'menuAutori');
    ELSIF authSurname IS NULL THEN
        modGUI1.RedirectEsito('Inserimento fallito',
            'Errore: Inserire Cognome',
            'Torna all''inserimento',gruppo2.gr2||'InserisciAutore?', 
            'authName='||authName||'//authSurname='||authSurname||'//dataNascita='||dataNascita||'//dataMorte='||dataMorte||'//nation='||nation,
            'Torna al menù',gruppo2.gr2||'menuAutori');
    ELSIF nation IS NULL THEN
        modGUI1.RedirectEsito('Inserimento fallito',
            'Errore: Inserire nazionalità',
            'Torna all''inserimento',gruppo2.gr2||'InserisciAutore?', 
            'authName='||authName||'//authSurname='||authSurname||'//dataNascita='||dataNascita||'//dataMorte='||dataMorte||'//nation='||nation,
            'Torna al menù',gruppo2.gr2||'menuAutori');
    ELSIF birth IS NOT NULL AND death IS NOT NULL AND death < birth THEN
        modGUI1.RedirectEsito('Inserimento fallito',
            'Errore: data di nascita postuma alla data di morte',
            'Torna all''inserimento',gruppo2.gr2||'InserisciAutore?', 
            'authName='||authName||'//authSurname='||authSurname||'//dataNascita='||dataNascita||'//dataMorte='||dataMorte||'//nation='||nation,
            'Torna al menù',gruppo2.gr2||'menuAutori');
    ELSE
		-- Parametri OK: pulsante conferma per effettuare insert
        -- o pulsante Annulla per tornare alla procedura di inserimento
        modGUI1.ApriPagina('Conferma dati',idSessione);
        modGUI1.Header;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px" ');
            -- Div per visualizzazione dati immessi
            modGUI1.ApriDiv('class="w3-section"');
            htp.br; modGUI1.Label('Nome:'); HTP.PRINT(authName);
            htp.br; modGUI1.Label('Cognome:'); HTP.PRINT(authSurname);
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
            htp.br; modGUI1.Label('Nazionalita:'); HTP.PRINT(nation);
            htp.br;
            modGUI1.ChiudiDiv;
            -- Form nascosto per conferma insert
            MODGUI1.ApriForm(gruppo2.gr2||'InserisciDatiAutore');
            HTP.FORMHIDDEN('authName', authName);
            HTP.FORMHIDDEN('authSurname', authSurname);
            HTP.FORMHIDDEN('dataNascita', dataNascita);
            HTP.FORMHIDDEN('dataMorte', dataMorte);
            HTP.FORMHIDDEN('nation', nation);
            MODGUI1.InputSubmit('Conferma');
            MODGUI1.ChiudiForm;
            -- Form nascosto per ritorno ad InserisciAutore con form precompilato
            MODGUI1.ApriForm(gruppo2.gr2||'InserisciAutore');
            params := REPLACE(callerParams,'%2F%2F','//');
            params := REPLACE(params,'%3D','=');
            HTP.FORMHIDDEN('authName', authName);
            HTP.FORMHIDDEN('authSurname', authSurname);
            HTP.FORMHIDDEN('dataNascita', dataNascita);
            HTP.FORMHIDDEN('dataMorte', dataMorte);
            HTP.FORMHIDDEN('nation', nation);
            HTP.FORMHIDDEN('caller', caller);
            HTP.FORMHIDDEN('callerParams', params);
            MODGUI1.InputSubmit('Annulla');
            MODGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
    END IF;
	-- Solo per testing
    EXCEPTION WHEN OTHERS THEN
        modGUI1.RedirectEsito('Errore', 'Errore sconosciuto', 'OK',gruppo2.gr2||'menuAutori');
END;

-- Effettua l'inserimento di un nuovo Autore nella base di dati
-- Oppure effettua rollback se non consentito
PROCEDURE InserisciDatiAutore(
    authName VARCHAR2 DEFAULT 'Sconosciuto',
    authSurname VARCHAR2 DEFAULT 'Sconosciuto',
    dataNascita VARCHAR2 DEFAULT NULL,
    dataMorte VARCHAR2 DEFAULT NULL,
    nation VARCHAR2 DEFAULT 'Sconosciuta'
) IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
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
        modGUI1.RedirectEsito('Inserimento riuscito', null,
            'Inserisci nuovo autore',gruppo2.gr2||'InserisciAutore', null,
            'Torna al menù',gruppo2.gr2||'menuAutori');
    ELSE
        modGUI1.RedirectEsito('Inserimento fallito',
             'Errore',
             'Torna all''inserimento',gruppo2.gr2||'InserisciAutore?', 
             'authName='||authName||'//authSurname='||authSurname||'//dataNascita='||dataNascita||'//dataMorte='||dataMorte||'//nation='||nation,
             'Torna al menù',gruppo2.gr2||'menuAutori');
            ROLLBACK;
    END IF;
    EXCEPTION
    WHEN AutorePresente THEN
        modGUI1.RedirectEsito('Inserimento fallito',
             'Errore: Autore già presente',
             'Torna all''inserimento',gruppo2.gr2||'InserisciAutore?', 
             'authName='||authName||'//authSurname='||authSurname||'//dataNascita='||dataNascita||'//dataMorte='||dataMorte||'//nation='||nation,
             'Torna al menù',gruppo2.gr2||'menuAutori');
            ROLLBACK;
END;

-- Procedura per visualizzare/modificare un Autore presente nella base di dati
-- (raggiungibile dal menuAutori)
-- Il parametro operazione assume uno tra i seguenti valori:
--  0: Visualizzazione
--  1: Modifica
PROCEDURE ModificaAutore(
 authorID NUMBER DEFAULT 0,
    operazione NUMBER DEFAULT 0,
    caller VARCHAR2 DEFAULT NULL,
    callerParams VARCHAR2 DEFAULT ''
) IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
this_autore Autori%ROWTYPE;
op_title VARCHAR2(25);
eta NUMBER(20);
-- Gli eventuali parametri della procedura chiamante
paramsMenu VARCHAR2(255);
menuRitorno VARCHAR2(255);
BEGIN
    SELECT * INTO this_autore FROM Autori WHERE IdAutore = authorID;
    IF operazione = 0 THEN
        op_title := 'Visualizza'; 
    ELSIF operazione = 1 THEN
        op_title := 'Modifica';
    END IF;
    modGUI1.ApriPagina(op_title||' Autore', idSessione);
    modGUI1.Header;
    htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;

    modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px" ');
        modGUI1.ApriDiv('class="w3-section"');
            IF caller = 'visualizzaOpera' THEN
                menuRitorno := 'menuOpere';
            ELSIF caller = 'menuAutoriEliminati' THEN
                menuRitorno := 'menuAutoriEliminati';
            ELSE
                menuRitorno := 'menuAutori';
            END IF;
            modGUI1.Collegamento('X',gruppo2.gr2||menuRitorno,' w3-btn w3-large w3-red w3-display-topright');
         htp.br;
    htp.header(2, 'Dettagli Autore', 'center');

    -- caso modifica
    IF operazione = 1 THEN
        modGUI1.ApriForm(gruppo2.gr2||'UpdateAutore');
            HTP.FORMHIDDEN('caller', caller);
            htp.formhidden('authID', this_autore.IdAutore);
            modGUI1.Label('Nome:');
            modGUI1.InputText('newName', this_autore.Nome, 1, this_autore.Nome);
            htp.br;
            modGUI1.Label('Cognome:');
            modGUI1.InputText('newSurname', this_autore.Cognome, 1, this_autore.Cognome);
            htp.br;
            modGUI1.Label('Data nascita:');
            modGUI1.InputDate('dataNascita', 'newBirth', 0, TO_CHAR(this_autore.DataNascita, 'YYYY-MM-DD'));
            htp.br;
            modGUI1.Label('Data morte:');
            modGUI1.InputDate('dataMorte', 'newDeath', 0, TO_CHAR(this_autore.DataMorte, 'YYYY-MM-DD'));
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
    -- Label età
    modGUI1.Label('Et&agrave;:');
    IF this_autore.DataNascita IS NOT NULL AND this_autore.DataMorte IS NOT NULL THEN
        eta := (this_autore.dataMorte - this_autore.DataNascita) / 365;
        htp.print(TO_CHAR(eta)||' anni');
    ELSE
        htp.print('Sconosciuta');
    END IF;
    htp.br;
    modGUI1.Label('Nazionalità:');
    htp.prn(this_autore.Nazionalita);
    htp.br; htp.br;
  END IF;
    IF operazione = 0 THEN
        modGUI1.ApriDiv('class="w3-center"');
        modGUI1.ApriForm(gruppo2.gr2||'StatisticheAutori');
            htp.br;
            modGUI1.SelectOpen('operazione', 'operazione');
            modGUi1.SelectOption(0, 'Opere realizzate');
            modGUi1.SelectOption(1, 'Musei con opere esposte');
            modGUi1.SelectOption(2, 'Collaborazioni effettuate');
            modGUI1.SelectClose;
        HTP.FORMHIDDEN('authID', this_autore.IdAutore);
        htp.prn('<button class="w3-margin w3-button w3-black w3-hover-white">Seleziona</button>');
        modGUI1.ChiudiDiv;
    END IF;
    -- Link per ritorno a procedura statistica dalla quale è stato chiamato
    IF caller is not null THEN
        IF callerParams IS NULL THEN
            MODGUI1.collegamento('Annulla',
            gruppo2.gr2||caller,
            'w3-button w3-block w3-black w3-section w3-padding');
        ELSE
            paramsMenu := REPLACE(callerParams,'//','&');
            MODGUI1.collegamento('Annulla',
            gruppo2.gr2||caller||'?'||paramsMenu,
            'w3-button w3-block w3-black w3-section w3-padding');
        END IF;
    END IF; 
  modGUI1.ChiudiDiv;
 modGUI1.ChiudiDiv;
END ModificaAutore;

PROCEDURE UpdateAutore( 
	authID NUMBER DEFAULT 0,
	newName VARCHAR2 DEFAULT 'Sconosciuto',
	newSurname VARCHAR2 DEFAULT 'Sconosciuto',
	newBirth VARCHAR2 DEFAULT NULL,
	newDeath VARCHAR2 DEFAULT NULL,
	newNation VARCHAR2 DEFAULT 'Sconosciuta',
    caller VARCHAR2 DEFAULT NULL,
    callerParams VARCHAR2 DEFAULT ''
) IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
Errore_data EXCEPTION;
params VARCHAR2(255);
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
    params := REPLACE(callerParams,'%2F%2F', '//');
    params := REPLACE(params, '%3D', '=');
    modGUI1.RedirectEsito('Aggiornamento riuscito', null,null,null, null,
        'Torna al menù',gruppo2.gr2||'menuAutori?', params);

    EXCEPTION
		WHEN Errore_data THEN
        params := REPLACE(callerParams,'%2F%2F', '//');
        params := REPLACE(params, '%3D', '=');
        params := REPLACE(params,'//', '§§');
            modGUI1.RedirectEsito('Aggiornamento fallito',
             'Errore: data di nascita postuma alla data di morte',
             'Torna alla modifica',gruppo2.gr2||'ModificaAutore?', 
             'authorID='||authID||'//operazione=1//caller='||caller||'//callerParams='||params,
             'Torna al menù',gruppo2.gr2||'menuAutori?', callerParams);
            ROLLBACK;
        WHEN OTHERS THEN
            params := REPLACE(callerParams,'%2F%2F', '//');
            params := REPLACE(params, '%3D', '=');
            params := REPLACE(params,'//', '§§');
            modGUI1.RedirectEsito('Aggiornamento fallito',
             'Errore: controlla i parametri immessi',
             'Torna alla modifica',gruppo2.gr2||'ModificaAutore?', 
             'authorID='||authID||'//operazione=1//caller='||caller||'//callerParams='||params,
             'Torna al menù',gruppo2.gr2||'menuAutori?', callerParams);
END;

PROCEDURE classificaAutori AS    
posizione int;
autore Autori%ROWTYPE;

CURSOR contaOpere_cursor IS 
    select IdAutore,count(*) opere
    from AutoriOpere 
    group by IdAutore
    order by count(*) desc;
autoreNumOpere contaOpere_cursor%ROWTYPE;
idSessione Sessioni.loginid%TYPE := modGUI1.get_id_sessione();
BEGIN
    MODGUI1.ApriPagina('Classifica Autori',idSessione);
    modGUI1.Header;
    htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;

    modGUI1.ApriDiv('class="w3-center"');
        htp.prn('<h1><b>Autori pi&ugrave; prolifici</b></h1>');
        modGUI1.Collegamento('Torna al menu',
                gruppo2.gr2||'menuAutori','w3-black w3-margin w3-button');
        htp.br;htp.br;

        OPEN contaOpere_cursor;
        posizione := 1;
        LOOP
            EXIT WHEN contaOpere_cursor%NOTFOUND OR posizione > 3;
            FETCH contaOpere_cursor INTO autoreNumOpere;

            SELECT * INTO autore FROM Autori WHERE IdAutore = autoreNumOpere.IdAutore;

            modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                coloreClassifica(posizione);
                    modGUI1.ApriDiv('class="w3-card-4"');
                    htp.prn('<img src="http://www.visitoslo.com/contentassets/3932b41a7b684b40a28d3195191265fe/edvard-munch-nasjonalbiblioteket.jpg" alt="Alps" style="width:100%">');
                        modGUI1.ApriDiv('class="w3-container w3-center"');
                        MODGUI1.collegamento('<h4><b>'||autore.Nome||' '||autore.Cognome,
                            gruppo2.gr2||'ModificaAutore?authorID='||autore.IdAutore||'&operazione=0&caller=selezioneAutoreStatistica&callerParams=operazione=5');
                        htp.prn(' ha realizzato '||autoreNumOpere.opere||' opere</b></h4>');
                        modGUI1.ChiudiDiv;
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;

            posizione := posizione + 1;
        END LOOP;
        CLOSE contaOpere_cursor;
    modGUI1.ChiudiDiv;
END classificaAutori;

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
    language VARCHAR2 DEFAULT NULL,
    d_level VARCHAR2 DEFAULT NULL,
    d_text VARCHAR2 DEFAULT NULL,
    operaID NUMBER DEFAULT NULL
) IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
--def_lingua VARCHAR2(255) := 'Inserisci la lingua...';
def_descr VARCHAR2(255) := 'Inserisci la descrizione...';
bambino_SELECTed NUMBER(1) := 0;
adulto_SELECTed NUMBER(1) := 0;
esperto_SELECTed NUMBER(1) := 0;
italian_SELECTed NUMBER(1) := 0;
English_SELECTed NUMBER(1) := 0;
Chinese_SELECTed NUMBER(1) := 0;
BEGIN
    modGUI1.ApriPagina('Inserimento Descrizione', idSessione);
    modGUI1.Header;
    htp.br;htp.br;htp.br;htp.br;
    htp.prn('<h1 align="center">Inserimento Descrizione</h1>');
    modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
        modGUI1.ApriDiv('class="w3-section"');
        modGUI1.Collegamento('X',gruppo2.gr2||'menuOpere?',' w3-btn w3-large w3-red w3-display-topright');
        -- Form per mandare dati alla procedura di conferma
        modGUI1.ApriForm(gruppo2.gr2||'ConfermaDatiDescrizione');
        htp.br;
        IF language = 'Italian' THEN
            italian_SELECTed := 1;
        ELSIF language = 'English' THEN
            English_SELECTed := 1;
        ELSIF language = 'Chinese' THEN
            Chinese_SELECTed := 1;
        END IF;
        modGUI1.Label('Lingua*');
            modGUI1.InputRadioButton('Italiano ', 'language', 'Italian', italian_SELECTed, 0);
            modGUI1.InputRadioButton('English ', 'language', 'English', English_SELECTed, 0);
            modGUI1.InputRadioButton('中国人 ', 'language', 'Chinese', Chinese_SELECTed, 0);
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
        MODGUI1.collegamento('Annulla',
            gruppo2.gr2||'VisualizzaOpera?operaID='||operaID||'&lingue='||language||'&livelli='||d_level,
            'w3-button w3-block w3-black w3-section w3-padding');
        end if;
        MODGUI1.ChiudiForm;
    MODGUI1.ChiudiDiv;
    MODGUI1.ChiudiDiv;
END;

-- Conferma o annulla l'immissione di una nuova iscrizione per un'Opera
PROCEDURE ConfermaDatiDescrizione(
    language VARCHAR2 DEFAULT 'Sconosciuta',
    d_level VARCHAR2 DEFAULT 'Sconosciuto',
    d_text VARCHAR2 DEFAULT NULL,
    operaID NUMBER DEFAULT NULL
) IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
v_opera Opere%ROWTYPE;
BEGIN 
    SELECT * INTO v_opera FROM Opere WHERE Opere.IdOpera = operaID;
    IF language IS NULL
        OR LOWER(d_level) NOT IN ('adulto', 'bambino', 'esperto')
        OR d_text IS NULL
        OR OperaID IS NULL
    THEN
        modGUI1.RedirectEsito('Errore',
            'Uno dei parametri immessi non è corretto',
            'Correggi',
            gruppo2.gr2||'InserisciDescrizione',
            '//language='||language||'//d_level='||d_level||'//d_text='||d_text||'//operaID='||operaID);
    ELSIF SQL%NOTFOUND THEN
        modGUI1.RedirectEsito('Errore',
            'Opera inesistente',
            'Correggi',
            gruppo2.gr2||'InserisciDescrizione',
            '//language='||language||'//d_level='||d_level||'//d_text='||d_text||'//operaID='||operaID);
    ELSE
        -- Parametri OK, pulsante conferma o annulla
        modGUI1.ApriPagina('Conferma Dati Descrizione', idSessione);
        modGUI1.Header;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
        htp.prn('<h1 align="center">Conferma Dati Descrizione</h1>');
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
            modGUI1.ApriDiv('class="w3-section"');
                modGUI1.Collegamento('X',
                    gruppo2.gr2||'menuOpere?',
                    'w3-btn w3-large w3-red w3-display-topright');
                modGUI1.Label('Lingua:');
                HTP.PRINT(language);
                htp.br;
                modGUI1.Label('Livello:');
                HTP.PRINT(d_level);
                htp.br;
                modGUI1.Label('Testo descrizione:');
                HTP.PRINT(d_text);
                -- Form nascosto per conferma insert
                MODGUI1.ApriForm(gruppo2.gr2||'InserisciDatiDescrizione');
                HTP.FORMHIDDEN('language', language);
                HTP.FORMHIDDEN('d_level', d_level);
                HTP.FORMHIDDEN('d_text', d_text);
                HTP.FORMHIDDEN('operaID', OperaID);
                MODGUI1.InputSubmit('Conferma');
                MODGUI1.ChiudiForm;
                -- Form nascosto per ritorno ad InserisciAutore con form precompilato
                MODGUI1.ApriForm(gruppo2.gr2||'InserisciDescrizione');
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
    language VARCHAR2 DEFAULT 'Sconosciuta',
    d_level VARCHAR2 DEFAULT 'Sconosciuto',
    d_text VARCHAR2 DEFAULT NULL,
    operaID NUMBER DEFAULT NULL
) IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
OperaInesistente EXCEPTION;  -- eccezione lanciata se l'opera operaID non esiste
Opera Opere%ROWTYPE;
BEGIN
    -- Controllo esistenza dell'opera riferita
    SELECT * INTO Opera FROM Opere WHERE IdOpera=operaID;
    IF SQL%FOUND THEN
    -- faccio il commit dello statement precedente
    INSERT INTO DESCRIZIONI VALUES
    (IdDescSeq.NEXTVAL, language, LOWER(d_level), d_text, operaID);
        commit;
        modGUI1.RedirectEsito('Inserimento riuscito', 
            'Inserimento riuscito', 
            'Torna all''opera',
            gruppo2.gr2||'VisualizzaOpera?',
            'operaID='||operaID||'//lingue='||language||'//livelli='||d_level,
            'Torna al menu Opere',
            gruppo2.gr2||'menuOpere');
     ELSE
    -- opera non presente: eccezione
        RAISE OperaInesistente;
    END IF;

    EXCEPTION
        WHEN OperaInesistente THEN
            modGUI1.RedirectEsito('Inserimento fallito', 
                'Inserimento fallito', 
                'Correggi',
                gruppo2.gr2||'InserisciDescrizione',
                '//language='||language||'//d_level='||d_level||'//d_text='||d_text||'//operaID='||operaID,
                'Torna al menu Opere',
                gruppo2.gr2||'menuOpere');
            ROLLBACK;
   END;

PROCEDURE modificaDescrizione(
        idDescrizione NUMBER DEFAULT NULL
) IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
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
        modGUI1.Header;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
        htp.prn('<h1 align="center">Modifica Descrizione</h1>');
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
            modGUI1.ApriDiv('class="w3-section"');
            modGUI1.Collegamento('X',gruppo2.gr2||'menuOpere?',' w3-btn w3-large w3-red w3-display-topright');
            --INIZIO SEZIONE DA MODIFICARE
                modGUI1.ApriForm(gruppo2.gr2||'UpdateDescrizione',NULL,'w3-container');
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
                    MODGUI1.collegamento('Annulla',
                        gruppo2.gr2||'VisualizzaOpera?operaID='||descr.opera||'&lingue='||descr.lingua||'&livelli='||descr.livello,
                        'w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiForm;
            --FINE SEZIONE DA MODIFICARE
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
END;


PROCEDURE UpdateDescrizione(
	descrID NUMBER DEFAULT 0, 
    newopera number DEFAULT 0,
    newlingua varchar2 DEFAULT null,
    newlivello varchar2 DEFAULT null,
    newtesto CLOB DEFAULT null
) IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
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
    modGUI1.RedirectEsito('Aggiornamento riuscito', null,null, null, null,
         'Torna all''opera',gruppo2.gr2||'VisualizzaOpera?','operaID='||newopera||'//lingue='||newlingua||'//livelli='||newlivello);
    EXCEPTION
		WHEN Errore_data THEN
            modGUI1.RedirectEsito('Aggiornamento fallito', null,null, null, null,
                 'Torna all''opera',gruppo2.gr2||'VisualizzaOpera?','operaID='||newopera||'//lingue='||newlingua||'//livelli='||newlivello);
            ROLLBACK;
END;

procedure EliminazioneDescrizione(
    idDescrizione NUMBER default 0
) IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
dLingua DESCRIZIONI.Lingua%TYPE;
dLivello DESCRIZIONI.Livello%TYPE;
BEGIN
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
                        gruppo2.gr2||'RimozioneDescrizione?idDescrizione='||idDescrizione,
                        'w3-button w3-block w3-green w3-section w3-padding');
                        htp.prn('<span onclick="document.getElementById(''ElimDescrizione'||idDescrizione||''').style.display=''none''" class="w3-button w3-block w3-red w3-section w3-padding" title="Close Modal">Annulla</span>');
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiForm;
        modGUI1.ChiudiDiv;
    modGUI1.ChiudiDiv;
end EliminazioneDescrizione;

--Procedura rimozione descrizione
procedure RimozioneDescrizione(
    idDescrizione NUMBER default 0
) IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
opid number(5);
oplingua VARCHAR2(25);
oplivello VARCHAR2(25);
BEGIN
    SELECT Opera, LINGUA,livello into opid, oplingua, oplivello
    FROM DESCRIZIONI WHERE IDDESC=idDescrizione;
    modGUI1.RedirectEsito('Rimozione riuscita', null,null,null, null,
        'Torna all''opera',gruppo2.gr2||'VisualizzaOpera?','operaID='||opid||'//lingue='||oplingua||'//livelli='||oplivello);
        DELETE FROM DESCRIZIONI WHERE IDDESC = idDescrizione;
        commit;
end RimozioneDescrizione;

Procedure StatisticheDescrizioni(
    operazione NUMBER DEFAULT 0
)IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
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
        modGUI1.Header;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
        htp.prn('<h1 align="center">Statistiche descrizioni</h1>');
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
            modGUI1.ApriDiv('class="w3-container"');
                modGUI1.Collegamento('X',gruppo2.gr2||'menuOpere?',' w3-btn w3-large w3-red w3-display-topright');
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
