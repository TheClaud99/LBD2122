SET DEFINE OFF;
CREATE OR REPLACE PACKAGE BODY PackageStanze as

---SALE--------------------------------------------------
    
    PROCEDURE visualizzaSale (
        Sort IN int default 0,
        Deleted IN int default 0,
        Search IN VARCHAR2 default NULL
    ) is 
    museosel musei.nome%TYPE;
    idSessione NUMBER(5) := modGUI1.get_id_sessione();
    BEGIN
        modGUI1.ApriPagina('Sale');
        modGUI1.Header;
        htp.br;htp.br;htp.br;htp.br;
        modGUI1.ApriDiv('class="w3-center"');
            htp.prn('<h1>Sale</h1>'); --TITOLO
            IF (hasRole(idSessione, 'DBA') OR hasRole(idSessione, 'SU')) THEN
                modGUI1.Collegamento('Aggiungi','packagestanze.formSala','w3-btn w3-round-xxlarge w3-black w3-margin-right'); /*bottone che rimanda alla procedura inserimento solo se la sessione è 1*/
                IF (Deleted!=1)THEN
                    modGUI1.Collegamento('Cestino','packagestanze.visualizzaSale?Deleted=1','w3-btn w3-round-xxlarge w3-red w3-margin-right');
                END IF;
            END IF;
            
            IF (Sort!=0 OR Deleted!=0 OR Search!=NULL) THEN 
                MODGUI1.Collegamento('Indietro','Packagestanze.visualizzaSale','w3-btn w3-green w3-round-xxlarge w3-margin-right');
            END IF;
        
        modGUI1.ChiudiDiv;

        --FORM RICERCA-----------------------
        modGUI1.ApriDiv('class="w3-container w3-left w3-margin-left"');
            modGUI1.ApriForm('PackageStanze.visualizzaSale',NULL,'" style="display:inline;');
                modGUI1.INPUTTEXT('Search','Ricerca...',0,NULL,1000);
                htp.prn('<input type="submit" value="🔎︎" class="w3-round-xxlarge" style="margin-left:2px;height:35px;display:inline;">');
                htp.FORMHIDDEN('Deleted',Deleted);
            modGUI1.ChiudiForm;
        modGUI1.ChiudiDiv;

        --FORM ORINDAMENTO-------------------
        modGUI1.APRITABELLA('w3-margin-right w3-right"');
            modGUI1.APRIRIGATABELLA;
                modgui1.APRIELEMENTOTABELLA;
                    modGUI1.LABEL('Ordina per:');
                modgui1.chiudiElementoTabella;
                modgui1.APRIELEMENTOTABELLA;
                    modGUI1.ApriForm('PackageStanze.visualizzaSale',NULL,'" style="display:inline;');
                        HTP.FORMHIDDEN('Deleted',Deleted);
                        HTP.FORMHIDDEN('Search',Search);
                        modGUI1.SELECTOPEN('Sort');
                            modGUI1.SELECTOPTION(1,'Nome');
                            modGUI1.SELECTOPTION(2,'Museo');
                            modGUI1.SELECTOPTION(3,'Dimensione');
                            modGUI1.SELECTOPTION(4,'Numero Opere');
                        modGUI1.SELECTCLOSE;
                modgui1.chiudiElementoTabella;
                modgui1.APRIELEMENTOTABELLA;
                        htp.prn('<input type="submit" class="w3-button w3-round w3-black" value="VAI" style="display:inline;">');
                    modGUI1.ChiudiForm;
                modgui1.chiudiElementoTabella;
            modgui1.chiudiRigaTabella;
        modGUI1.chiudiTabella;
        ----------------------------------
        htp.br;
        modGUI1.ApriDiv('class="w3-row w3-container"');
        --INIZIO LOOP DELLA VISUALIZZAZIONE
                FOR sala IN 
                    (SELECT
                        idstanza,
                        tiposala,
                        numopere,
                        nome,
                        dimensione,
                        museo,
                        STANZE.eliminato
                    FROM SALE INNER JOIN STANZE USING (idstanza) 
                    --VISUALIZZAZIONE ELIMINATI
                    WHERE STANZE.Eliminato = 
                    CASE 
                        WHEN Deleted=1 THEN 1
                        ELSE 0
                    END

                    AND upper(STANZE.nome) LIKE '%'||upper(Search)||'%'
                    --ORDINAMENTI
                    ORDER BY 
                        (CASE WHEN Sort<>1 AND Sort<>2 AND Sort<>3 AND Sort<>4 then idstanza end),
                        (CASE WHEN Sort=1 then nome end),
                        (CASE WHEN Sort=2 then museo end),
                        (CASE WHEN Sort=3 then dimensione end),
                        (CASE WHEN Sort=4 then numopere end)
                    ) 
                LOOP
            IF (sala.eliminato!=1) THEN    
                htp.prn('<a style="text-decoration:none;" href='||COSTANTI.server || costanti.radice ||'packagestanze.visualizzaSala?varIdSala='||sala.Idstanza||'>');
            END IF;
                modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center w3-hover-light-grey"');
                    modGUI1.ApriDiv('class="w3-card-4"');
                    htp.prn('<img src="https://www.23bassi.com/wp-content/uploads/2019/03/vuota-web.jpg" alt="Alps" style="width:100%">');
                            modGUI1.ApriDiv('class="w3-container w3-center"');
                            --INIZIO DESCRIZIONI
                                SELECT nome INTO museosel FROM MUSEI WHERE (musei.idmuseo=sala.museo);
                                htp.prn('<p><b>Museo: </b>'|| museosel ||'</p>');
                                htp.prn('<h2><b>'|| sala.nome||'</b></h2>');
                                IF (sala.tiposala=0)
                                THEN
                                    htp.prn('<h4>Sala ordinaria</h4>');
                                ELSE
                                    htp.prn('<h4>Sala speciale</h4>');
                                END IF;
                                htp.prn('<p>Dim: '||sala.dimensione || 'mq / ');
                                htp.prn('Max opere: '|| sala.numopere||'</p>');

                            --FINE DESCRIZIONI
                            modGUI1.ChiudiDiv;
                            
                            IF (hasRole(idSessione, 'DBA') OR hasRole(idSessione, 'SU') OR hasRole(idSessione, 'GM') ) THEN --Bottoni visualizzati in base alla sessione 
                                modGUI1.Collegamento('Modifica','packagestanze.formSala?modifica=1&varIdStanza='||sala.idstanza||'&varSalaMuseo='||sala.museo||'&varSalaNome='||sala.nome||'&varSalaDimensione='||sala.dimensione||'&varSalaTipo='||sala.tiposala||'&varSalaOpere='||sala.numopere,'w3-button w3-green w3-margin');
                            END IF;
                                IF (sala.eliminato=0)THEN
                                    IF (hasRole(idSessione, 'DBA') OR hasRole(idSessione, 'SU') ) THEN
                                        modGUI1.Collegamento('Rimuovi','packagestanze.rimuoviSala?varIdStanza='||sala.idstanza,'w3-button w3-red w3-margin');
                                    END IF;
                                ELSE
                                    IF (hasRole(idSessione, 'DBA') OR hasRole(idSessione, 'SU') ) THEN
                                       modGUI1.Collegamento('Ripristina','packagestanze.ripristinaSala?varIdStanza='||sala.idstanza,'w3-button w3-yellow w3-margin');
                                    END IF;
                                END IF;

                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
            IF (sala.eliminato!=1) THEN    
                htp.prn('</a>');
            END IF;
            END LOOP;
        --FINE LOOP--------------------
        modGUI1.chiudiDiv;  
    END;

    PROCEDURE formSala (
        modifica IN NUMBER default 0,
        varIdStanza IN NUMBER default NULL,
        varSalaMuseo IN NUMBER default NULL,
        varSalaNome VARCHAR2 default NULL,
        varSalaDimensione NUMBER default NULL,
        varSalaTipo NUMBER default NULL,
        varSalaOpere NUMBER default NULL
        ) is
        NomeMuseo MUSEI.Nome%TYPE;
        varIdMuseo MUSEI.IdMuseo%TYPE;
    BEGIN
        modGUI1.ApriPagina('Form Sala');
        modGUI1.Header;
        
        modGUI1.ApriDiv('style="margin-top: 110px"');
            htp.prn('<h1 class="w3-center">Inserimento sala</h1>');
                modGUI1.ApriDivCard;
                    if (modifica=0)
                    then
                        modGUI1.ApriForm('packagestanze.inseriscisala',NULL,'w3-container');
                    else
                        modGUI1.ApriForm('packagestanze.modificasala',NULL,'w3-container');
                    end if;

                            ----CAMPI STANZA----
                            modGUI1.Label('Museo:');
                            modGUI1.SelectOpen('selectMusei');
                                for museo in (select IdMuseo from MUSEI)
                                loop
                                    select IdMuseo, Nome into varIdMuseo, NomeMuseo
                                    from MUSEI
                                    where IdMuseo = museo.IdMuseo;
                                    if (museo.idmuseo=VarSalaMuseo)
                                    then
                                        modGUI1.SelectOption(varIdMuseo,NomeMuseo,1);
                                    else
                                        modGUI1.SelectOption(varIdMuseo,NomeMuseo);
                                    END if;
                                END loop;
                            modGUI1.SelectClose;
                            htp.br;
                            modGUI1.Label('Nome sala:');
                            modGUI1.InputText('nomeSala',NULL,NULL,varSalaNome);
                            htp.br;
                            modGUI1.Label('Dimensione sala:');
                            modGUI1.InputNumber('idDimSala" min="1" max="99999','dimSala',NULL,varSalaDimensione);
                            htp.br;
                            ----CAMPI SALA----
                            modGUI1.Label('Tipo sala:');
                            if(varSalaTipo=0)
                                then
                                    modGUI1.InputRadioButton('Sala ordinaria ','tipoSalaform','0',1);
                                    modGUI1.InputRadioButton('Sala speciale','tipoSalaform','1');
                                else
                                    modGUI1.InputRadioButton('Sala ordinaria ','tipoSalaform','0');
                                    modGUI1.InputRadioButton('Sala speciale ','tipoSalaform','1',1);
                            END if;
                            htp.br;
                            modGUI1.Label('Numero Opere: ');
                            modGUI1.InputNumber('idnOpere" min="1" max="99999','nOpereform',NULL,varSalaOpere);
                            htp.br;
                            modGUI1.Collegamento('Annulla','PackageStanze.visualizzaSale','w3-red w3-button w3-margin w3-left');
                            modGUI1.InputReset;
                            if (modifica=0)
                            then
                                modGUI1.InputSubmit('Aggiungi');
                            else
                                htp.FORMHIDDEN('varIdStanza',varIdStanza);
                                modGUI1.InputSubmit('Modifica');
                            END if;

                    modGUI1.ChiudiForm;
                modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv();
    END;

    PROCEDURE visualizzaSala(
        varIdSala in NUMBER,
        DataInizio in VARCHAR2 DEFAULT '1990-01-01',
        DataFine in VARCHAR2 DEFAULT '2030-12-31'
        )is
        varNome VARCHAR2(20);
        varDimensione NUMBER;
        varMuseo MUSEI.IDMUSEO%TYPE;
        varTiposala NUMBER;
        varNumopere NUMBER;
        varIdMuseo MUSEI.IDMUSEO%TYPE;
        varNomeMuseo MUSEI.NOME%TYPE;
        varCountOpere NUMBER;
        varNumVisite NUMBER;
        varVisitatoriUnici NUMBER;
    contatoreClassifica NUMBER(1) := 1;
    idSessione NUMBER(5) := modGUI1.get_id_sessione();
    BEGIN
        SELECT nome,dimensione,museo,tiposala,numopere INTO varNome,varDimensione,varMuseo,varTiposala,varNumopere 
            FROM Stanze NATURAL JOIN Sale 
        WHERE idstanza=varIdSala;

        modGUI1.APRIPAGINA('Sala '||varIdSala);
        modGUI1.HEADER;
        htp.br;htp.br;htp.br;htp.br;htp.br;
        MODGUI1.Collegamento('<i class="fa fa-caret-left"></i> Torna alle sale','PackageStanze.visualizzaSale','w3-button w3-round-xlarge w3-margin-left w3-black w3-left');
        SELECT idmuseo,nome INTO varIdMuseo,varNomeMuseo 
            FROM MUSEI 
        WHERE (MUSEI.IDMUSEO=varMuseo);

        modGUI1.ApriDiv('class="w3-light-grey w3-container" style="margin:auto;width:60%;"');
            htp.prn('<img src="https://www.23bassi.com/wp-content/uploads/2019/03/vuota-web.jpg" alt="Alps" class="w3-third w3-margin">');
            MODGUI1.ApriDiv('class="twothird w3-margin w3-center"');
                htp.prn('<p><b>Museo: </b>');
                modGUI1.COLLEGAMENTO(varNomeMuseo,'operazioniGruppo4.visualizzaMusei?museoId='||varIdMuseo);--LINK ESTERNO
                htp.prn('</p>');
                htp.prn('<h2><b>'|| varNome ||'</b></h2>');
                IF (varTipoSala=0)
                THEN
                    htp.prn('<h4>Sala ordinaria</h4>');
                ELSE
                    htp.prn('<h4>Sala speciale</h4>');
                END IF;
                htp.prn('<p>Dim: '|| varDimensione || 'mq</p>');
                htp.prn('<p>Max opere: '|| varNumopere ||'</p>');  
            MODGUI1.ChiudiDiv;
            MODGUI1.ApriDiv('class="w3-container"');
            IF (hasRole(idSessione, 'DBA') OR hasRole(idSessione, 'SU') OR hasRole(idSessione, 'GM')) THEN
            --STATISTICHE------------------------------
                htp.prn('<h3>Statistiche</h3>');
                --VISITE IN SALA
                SELECT COUNT(*) INTO varNumVisite 
                    FROM VISITE INNER JOIN VISITEVARCHI USING (idvisita) 
                    INNER JOIN VARCHI ON (VISITEVARCHI.idvarco=VARCHI.idvarchi)
                WHERE 
                    (stanza1=varIdSala AND direzioneinversa=1) OR (stanza2=varIdSala AND direzioneinversa=0);

                htp.prn('Visite in sala: <b>'||varNumVisite||'</b>');
                
                --VISITATORI UNICI IN SALA IN PERIODO DI TEMPO SPECIFICATO
                SELECT COUNT (DISTINCT visitatore) into varVisitatoriUnici 
                    FROM VISITE INNER JOIN VISITEVARCHI USING (idvisita)
                    INNER JOIN VARCHI ON (VISITEVARCHI.idvarco=VARCHI.idvarchi)
                WHERE 
                    (stanza1=varIdSala AND direzioneinversa=1) OR (stanza2=varIdSala AND direzioneinversa=0)
                AND 
                    DATAVISITA BETWEEN to_date(DataInizio,'YYYY-MM-DD') AND to_date(DataFine,'YYYY-MM-DD');
                
                MODGUI1.ApriDiv;
                    htp.prn('Visitatori unici dal ');
                    MODGUI1.ApriForm('PackageStanze.visualizzaSala',NULL, '" style="display:inline;');
                        HTP.FORMHIDDEN('varIdSala',varIdSala);
                        MODGUI1.INPUTDATE('DataInizio','DataInizio',NULL,DataInizio);
                        HTP.prn(' al ');
                        MODGUI1.INPUTDATE('DataFine','DataFine',NULL,DataFine);
                        htp.prn(': <details style="display:inline;">');
                        htp.prn('<summary><b>'||varVisitatoriUnici||'  </b></summary>');
                        modGUI1.APRITABELLA('w3-margin-right w3-right"');
                        FOR visunici IN (
                            SELECT DISTINCT idvisita,visitatore,utenti.nome,cognome,datavisita 
                                FROM UTENTI INNER JOIN VISITE ON (idutente=visitatore) 
                                INNER JOIN VISITEVARCHI USING (idvisita) 
                                INNER JOIN VARCHI ON (VISITEVARCHI.idvarco=VARCHI.idvarchi)
                            WHERE 
                                (stanza1=varIdSala AND direzioneinversa=1) OR (stanza2=varIdSala AND direzioneinversa=0)
                            AND 
                                DATAVISITA BETWEEN to_date(DataInizio,'YYYY-MM-DD') AND to_date(DataFine,'YYYY-MM-DD')
                            ORDER BY 
                                DATAVISITA desc
                        )LOOP
                            modGUI1.APRIRIGATABELLA;
                                modgui1.APRIELEMENTOTABELLA;
                                    modGUI1.Collegamento(visunici.nome||' '||visunici.cognome,'packageUtenti.VisualizzaUtente?utenteID='||visunici.visitatore);--LINK ESTERNO
                                modgui1.chiudiElementoTabella;
                                modgui1.APRIELEMENTOTABELLA;
                                    modGUI1.Collegamento(to_char(visunici.datavisita,'DD-MM-YY'),'packagevisite.visualizzavisita?idvisitaselezionata='||visunici.idvisita||'&action=packageVisite.visualizza_visite&button_text=Vai+alle+visite');--LINK ESTERNO
                                modgui1.chiudiElementoTabella;
                            modgui1.chiudiRigaTabella;
                        END LOOP;
                        
                        modGUI1.chiudiTabella;
                        htp.prn('</details>    ');
                        
                        
                        htp.prn('<input type="submit" value="Modifica data" class="w3-round-xxlarge" style="display:inline;">');
                    MODGUI1.ChiudiForm;
                MODGUI1.ChiudiDiv; 
                --TOP 5 VISITATORI
                htp.prn('Top 5 visitatori: ');
                modGUI1.APRITABELLA('" style="display:inline;');
                    FOR varUtente IN ( 
                        SELECT DISTINCT idutente, utenti.nome, utenti.cognome, COUNT(idvisita) as numvisite 
                            FROM UTENTI INNER JOIN VISITE ON (idutente=visitatore)
                            INNER JOIN VISITEVARCHI USING (idvisita)
                            INNER JOIN VARCHI ON (idvarchi=idvarco)
                        WHERE (stanza1=varIdSala AND direzioneinversa=1) OR (stanza2=varIdSala AND direzioneinversa=0)
                        GROUP BY idutente, utenti.nome, utenti.cognome
                        ORDER BY numvisite, utenti.cognome
                        FETCH first 5 rows only
                    )LOOP   
                        modGUI1.APRIRIGATABELLA;
                            modgui1.APRIELEMENTOTABELLA;
                                htp.prn('<b>'||contatoreClassifica||'.</b>');
                                contatoreClassifica := contatoreClassifica + 1;
                            modgui1.chiudiElementoTabella;
                            modgui1.APRIELEMENTOTABELLA;
                                modGUI1.Collegamento(varUtente.nome||' '||varUtente.cognome,'packageUtenti.VisualizzaUtente?utenteID='||varUtente.idutente);--LINK ESTERNO
                            modgui1.chiudiElementoTabella;
                        modgui1.chiudiRigaTabella;
                    END LOOP;
                modGUI1.chiudiTabella;                
            END IF;
            --OPERE------------------------------------
            SELECT COUNT(*) INTO varCountOpere FROM OPERE INNER JOIN SALEOPERE ON SALEOPERE.opera=OPERE.idopera WHERE SALEOPERE.SALA=varIdSala;--Opere presenti nella Sala
            htp.prn('<h3>Opere: '||varCountOpere||'</h3>');
                MODGUI1.APRITABELLA('w3-table-all');
                    MODGUI1.APRIRIGATABELLA;
                        MODGUI1.APRIELEMENTOTABELLA;
                            htp.prn('<p><b>Titolo</b></p>');
                        MODGUI1.CHIUDIELEMENTOTABELLA;
                        MODGUI1.APRIELEMENTOTABELLA;
                            htp.prn('<p><b>Anno</b></p>');
                        MODGUI1.CHIUDIELEMENTOTABELLA;
                        MODGUI1.APRIELEMENTOTABELLA;
                        MODGUI1.CHIUDIELEMENTOTABELLA;
                    MODGUI1.CHIUDIRIGATABELLA;
                    FOR varOpere IN (SELECT * FROM OPERE INNER JOIN SALEOPERE ON SALEOPERE.opera=OPERE.idopera WHERE SALEOPERE.SALA=varIdSala ORDER BY OPERE.titolo) LOOP
                    MODGUI1.APRIRIGATABELLA('w3-hover-grey');
                        MODGUI1.APRIELEMENTOTABELLA;
                            htp.prn('<p>'||varOpere.Titolo||'</p>');
                        MODGUI1.CHIUDIELEMENTOTABELLA;
                        MODGUI1.APRIELEMENTOTABELLA;
                            htp.prn('<p>'||varOpere.Anno||'</p>');
                        MODGUI1.CHIUDIELEMENTOTABELLA;
                        MODGUI1.APRIELEMENTOTABELLA;
                            modGUI1.ApriDiv('class="w3-center"');
                                htp.prn('<button onclick="document.getElementById(''LinguaeLivelloOpera'|| varOpere.idOpera||''').style.display=''block''" class="w3-button w3-black">Visualizza</button>');
                                gruppo2.linguaELivello(varOpere.idOpera);
                            modGUI1.ChiudiDiv;
                            --LINK ESTERNO
                        MODGUI1.CHIUDIELEMENTOTABELLA;
                    MODGUI1.CHIUDIRIGATABELLA;
                    END LOOP;
                MODGUI1.CHIUDITABELLA;
            MODGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
    END;
    
    PROCEDURE inserisciSala (
        selectMusei IN musei.idmuseo%TYPE,
        nomeSala       IN  VARCHAR2,
        dimSala            IN  NUMBER,
        tipoSalaform         IN  NUMBER,
        nOpereform           IN NUMBER
    ) IS
        idstanzacreata sale.idstanza%TYPE;
    
    BEGIN    	
        idstanzacreata := idstanzaseq.nextval;
        INSERT INTO STANZE (
            idstanza,
            nome,
            dimensione,
            museo,
            eliminato
        ) VALUES (
            idstanzacreata,
            nomeSala,
            dimSala,
            selectMusei,
            0
        );
        INSERT INTO SALE (
            idstanza,
            tiposala,
            numopere,
            eliminato    
        ) VALUES (
            idstanzacreata,
            tipoSalaForm,
            nOpereform,
            0
        );
        MODGUI1.REDIRECTESITO('Inserimento effettuato',
                              'L''inserimento è stato effettuato correttamente',
                              'Torna a visualizzare le sale',
                              'PackageStanze.visualizzaSale',
                              NULL);
        EXCEPTION WHEN OTHERS THEN
        MODGUI1.REDIRECTESITO('ERRORE: Inserimento non riuscito',
                              'L''inserimento non è andato a buon fine',
                              'Torna a visualizzare le sale',
                              'PackageStanze.visualizzaSale',
                              NULL);

    END;

    PROCEDURE modificaSala (
        varIdStanza IN NUMBER,
        selectMusei IN musei.idmuseo%TYPE,
        nomeSala       IN  VARCHAR2,
        dimSala            IN  NUMBER,
        tipoSalaform         IN  NUMBER,
        nOpereform           IN NUMBER
    ) IS
    BEGIN
        
        UPDATE STANZE
        SET
        nome=nomeSala,
        dimensione=dimSala,
        museo=selectMusei
        WHERE idstanza=varIdStanza;

        UPDATE SALE
        SET
        tiposala=tipoSalaform,
        numopere=nOpereform
        WHERE
        idstanza=varIdStanza;
        MODGUI1.REDIRECTESITO('Modifica effettuata',
                              'La modifica è stata effettuata correttamente',
                              'Torna a visualizzare le sale',
                              'PackageStanze.visualizzaSale',
                              NULL);
        EXCEPTION WHEN OTHERS THEN
        MODGUI1.REDIRECTESITO('ERRORE: Modifica non riuscita',
                              'La modifica non è andata a buon fine',
                              'Torna a visualizzare le sale',
                              'PackageStanze.visualizzaSale',
                              NULL);
    END;

    PROCEDURE rimuoviSala (
        varIdStanza IN NUMBER
    ) IS
    BEGIN
        
        UPDATE STANZE
        SET
        eliminato=1
        WHERE idstanza=varIdStanza;

        MODGUI1.REDIRECTESITO('Eliminazione effettuata',
                              'L''eliminazione è stata effettuata correttamente',
                              'Torna a visualizzare le sale',
                              'PackageStanze.visualizzaSale',
                              NULL);
        EXCEPTION WHEN OTHERS THEN
        MODGUI1.REDIRECTESITO('ERRORE: Eliminazione non riuscita',
                              'L'' eliminazione non è andata a buon fine',
                              'Torna a visualizzare le sale',
                              'PackageStanze.visualizzaSale',
                              NULL);
    END;

    PROCEDURE ripristinaSala (
        varIdStanza IN NUMBER
    ) IS
    BEGIN
        
        UPDATE STANZE
        SET
        eliminato=0
        WHERE idstanza=varIdStanza;

        MODGUI1.REDIRECTESITO('Ripristino effettuato',
                              'Il ripristino è stato effettuato correttamente',
                              'Torna a visualizzare le sale',
                              'PackageStanze.visualizzaSale',
                              NULL);
        EXCEPTION WHEN OTHERS THEN
        MODGUI1.REDIRECTESITO('ERRORE: Ripristino non riuscito',
                              'Il ripristino non è andato a buon fine',
                              'Torna a visualizzare le sale',
                              'PackageStanze.visualizzaSale',
                              NULL);
    END;

    ---AMBIENTI DI SERVIZIO---
    
    PROCEDURE visualizzaAmbientiServizio(
        Sort IN int default 0,
        Deleted IN int default 0,
        Search IN VARCHAR2 default NULL
    ) is 
    idmuseosel musei.idmuseo%TYPE;
    museosel musei.nome%TYPE;
    idSessione NUMBER(5) := modGUI1.get_id_sessione();
    BEGIN
        modGUI1.ApriPagina('Ambienti di servizio');
        modGUI1.Header;
        htp.br;htp.br;htp.br;htp.br;
        modGUI1.ApriDiv('class="w3-center"');
        htp.prn('<h1>Ambienti di servizio</h1>'); --TITOLO
            IF (hasRole(idSessione, 'DBA') OR hasRole(idSessione, 'SU') ) THEN
                modGUI1.Collegamento('Aggiungi','packagestanze.formAmbienteServizio','w3-btn w3-round-xxlarge w3-black w3-margin-right'); /*bottone che rimanda alla procedura inserimento solo se la sessione è 1*/
                IF (Deleted!=1)THEN
                    modGUI1.Collegamento('Cestino','packagestanze.visualizzaAmbientiServizio?Deleted=1','w3-btn w3-round-xxlarge w3-red w3-margin-right');
                END IF;
            END IF;
            
            IF (Sort!=0 OR Deleted!=0 OR Search!=NULL) THEN 
                MODGUI1.Collegamento('Indietro','Packagestanze.visualizzaAmbientiServizio','w3-btn w3-green w3-round-xxlarge w3-margin-right');
            END IF;
            
        modGUI1.ChiudiDiv;

        --FORM RICERCA-----------------------
        modGUI1.ApriDiv('class="w3-container w3-left w3-margin-left"');
            modGUI1.ApriForm('PackageStanze.visualizzaAmbientiServizio',NULL,'" style="display:inline;');
                modGUI1.INPUTTEXT('Search','Ricerca...',0,NULL,1000);
                htp.prn('<input type="submit" value="🔎︎" class="w3-round-xxlarge" style="margin-left:2px;height:35px;display:inline;">');
                htp.FORMHIDDEN('Deleted',Deleted);
            modGUI1.ChiudiForm;
        modGUI1.ChiudiDiv;

        --FORM ORINDAMENTO-------------------
        modGUI1.APRITABELLA('w3-margin-right w3-right"');
            modGUI1.APRIRIGATABELLA;
                modgui1.APRIELEMENTOTABELLA;
                    modGUI1.LABEL('Ordina per:');
                modgui1.chiudiElementoTabella;
                modgui1.APRIELEMENTOTABELLA;
                    modGUI1.ApriForm('PackageStanze.visualizzaAmbientiServizio',NULL,'" style="display:inline;');
                        HTP.FORMHIDDEN('Deleted',Deleted);
                        HTP.FORMHIDDEN('Search',Search);
                        modGUI1.SELECTOPEN('Sort');
                            modGUI1.SELECTOPTION(1,'Nome');
                            modGUI1.SELECTOPTION(2,'Museo');
                            modGUI1.SELECTOPTION(3,'Dimensione');
                            modGUI1.SELECTOPTION(4,'Tipo');
                        modGUI1.SELECTCLOSE;
                modgui1.chiudiElementoTabella;
                modgui1.APRIELEMENTOTABELLA;
                        htp.prn('<input type="submit" class="w3-button w3-round w3-black" value="VAI" style="display:inline;">');
                    modGUI1.ChiudiForm;
                modgui1.chiudiElementoTabella;
            modgui1.chiudiRigaTabella;
        modGUI1.chiudiTabella;
        ----------------------------------
        modGUI1.ApriDiv('class="w3-row w3-container"');
        --INIZIO LOOP DELLA VISUALIZZAZIONE
            FOR AmbS IN (SELECT idstanza,
                                tipoambiente,
                                nome,
                                dimensione,
                                museo,
                                STANZE.eliminato
                FROM AMBIENTIDISERVIZIO INNER JOIN STANZE USING (idstanza)
                --VISUALIZZAZIONE ELIMINATI
                WHERE STANZE.Eliminato =
                    CASE
                        WHEN Deleted=1 THEN 1
                        ELSE 0
                    END
                AND upper(STANZE.nome) LIKE '%'||upper(Search)||'%'
                --ORDINAMENTI
                ORDER BY 
                        (CASE WHEN Sort<>1 AND Sort<>2 AND Sort<>3 AND Sort<>4 then idstanza end),
                        (CASE WHEN Sort=1 then nome end),
                        (CASE WHEN Sort=2 then museo end),
                        (CASE WHEN Sort=3 then dimensione end),
                        (CASE WHEN Sort=4 then tipoambiente end)
            )LOOP
                modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                    modGUI1.ApriDiv('class="w3-card-4"');
                    htp.prn('<img src="https://www.scattidigusto.it/wp-content/uploads/2014/05/Da-Giacomo_Arengario-960x639.jpg" alt="Alps" style="width:100%">');
                            modGUI1.ApriDiv('class="w3-container w3-center"');
                            --INIZIO DESCRIZIONI
                                SELECT idmuseo,nome INTO idmuseosel,museosel FROM MUSEI WHERE (musei.idmuseo=AmbS.museo);
                                htp.prn('<p><b>Museo: </b>');
                                modGUI1.Collegamento(museosel,'operazioniGruppo4.visualizzaMusei?museoId='||idmuseosel);--LINK ESTERNO
                                htp.prn('</p>');
                                htp.prn('<h2><b>'|| AmbS.nome||'</b></h2>');
                                htp.prn('<h4>'|| AmbS.tipoambiente||'</h4>');
                                htp.prn('<p>Dim: '||AmbS.dimensione || 'mq</p>');

                            --FINE DESCRIZIONI
                            modGUI1.ChiudiDiv;
                            
                            IF (hasRole(idSessione, 'DBA') OR hasRole(idSessione, 'SU') OR hasRole(idSessione, 'GM')) THEN --Bottoni visualizzati in base alla sessione 
                                modGUI1.Collegamento('Modifica','packagestanze.formAmbienteServizio?modifica=1&varIdStanza='||AmbS.idstanza||'&varASMuseo='||AmbS.museo||'&varASNome='||AmbS.nome||'&varASDimensione='||AmbS.dimensione||'&varASTipo='||AmbS.tipoambiente,'w3-button w3-green w3-margin');
                            END IF;
                            
                            IF (AmbS.eliminato=0) THEN
                                IF (hasRole(idSessione, 'DBA') OR hasRole(idSessione, 'SU') ) THEN
                                    modGUI1.Collegamento('Rimuovi','packagestanze.rimuoviAmbienteServizio?varIdStanza='||AmbS.idstanza,'w3-button w3-red w3-margin');
                                END IF;
                            ELSE
                                IF (hasRole(idSessione, 'DBA') OR hasRole(idSessione, 'SU') ) THEN
                                    modGUI1.Collegamento('Ripristina','packagestanze.ripristinaAmbienteServizio?varIdStanza='||AmbS.idstanza,'w3-button w3-yellow w3-margin');
                                END IF;
                            END IF;

                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
            END LOOP;
        --FINE LOOP
        modGUI1.chiudiDiv;  
    END;
    
    

    PROCEDURE formAmbienteServizio (
        modifica IN NUMBER default 0,
        varIdStanza IN NUMBER default NULL,
        varASMuseo IN NUMBER default NULL,
        varASNome VARCHAR2 default NULL,
        varASDimensione NUMBER default NULL,
        varASTipo VARCHAR2 default NULL
    ) is
        NomeMuseo MUSEI.Nome%TYPE;
        varIdMuseo MUSEI.IdMuseo%TYPE;
    BEGIN
        modGUI1.ApriPagina();
        modGUI1.Header();
        modGUI1.ApriDiv('style="margin-top: 110px"');
            htp.prn('<h1 class="w3-center">Inserimento ambiente di servizio</h1>');
                modGUI1.ApriDivCard;
                    if (modifica=0)
                    then
                        modGUI1.ApriForm('packagestanze.inserisciambienteservizio',NULL,'w3-container');
                    else 
                        modGUI1.ApriForm('packagestanze.modificaambienteservizio',NULL,'w3-container');
                    end if;
                            ----CAMPI STANZA----
                            modGUI1.Label('Museo:');
                            modGUI1.SelectOpen('selectMusei');
                                for museo in (select IdMuseo from MUSEI)
                                loop
                                    select IdMuseo, Nome into varIdMuseo, NomeMuseo
                                    from MUSEI
                                    where IdMuseo = museo.IdMuseo;                                    
                                    if (museo.idmuseo=VarASMuseo)
                                    then
                                        modGUI1.SelectOption(varIdMuseo,NomeMuseo,1);
                                    else
                                        modGUI1.SelectOption(varIdMuseo,NomeMuseo);
                                    END if;
                                END loop;
                            modGUI1.SelectClose;
                            htp.br;
                            modGUI1.Label('Nome ambiente di servizio:');
                            modGUI1.InputText('nomeAmbS',NULL,NULL,varASNome);
                            htp.br;
                            modGUI1.Label('Dimensione ambiente:');
                            modGUI1.InputNumber('idDimAmbS" min="1" max="99999','dimAmbS',NULL,varASDimensione);
                            htp.br;
                            ----CAMPI AMBIENTE SERVIZIO----
                            modGUI1.Label('Tipo Ambiente:');
                            modGUI1.InputText('tipoAmbS',NULL,NULL,varASTipo);
                            htp.br;
                            modGUI1.Collegamento('Annulla','PackageStanze.VisualizzaAmbientiServizio','w3-button w3-left w3-red w3-margin');
                            modGUI1.InputReset;
                            if (modifica=0)
                            then
                                modGUI1.InputSubmit('Aggiungi');
                            else
                                htp.FORMHIDDEN('varIdStanza',varIdStanza);
                                modGUI1.InputSubmit('Modifica');
                            END if;

                    modGUI1.ChiudiForm;
                modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv();
    END;

    PROCEDURE inserisciAmbienteServizio (
        selectMusei IN musei.idmuseo%TYPE,
        nomeAmbS       IN  VARCHAR2,
        dimAmbS            IN  NUMBER,
        tipoAmbS   IN VARCHAR2
    ) IS
        idstanzacreata sale.idstanza%TYPE;
    
    BEGIN
    	
        idstanzacreata := idstanzaseq.nextval;


        INSERT INTO STANZE (
            idstanza,
            nome,
            dimensione,
            museo,
            eliminato
        ) VALUES (
            idstanzacreata,
            nomeAmbS,
            dimAmbS,
            selectMusei,
            0
        );
        INSERT INTO AMBIENTIDISERVIZIO (
            idstanza,
            tipoambiente,
            eliminato    
        ) VALUES (
            idstanzacreata,
            tipoAmbS,
            0
        );
        
        MODGUI1.REDIRECTESITO('Inserimento effettuato',
                              'L''inserimento è stata effettuata correttamente',
                              'Torna a visualizzare gli ambienti di servizio',
                              'PackageStanze.visualizzaAmbientiServizio',
                              NULL);
        EXCEPTION WHEN OTHERS THEN
        MODGUI1.REDIRECTESITO('ERRORE: Inserimento non riuscito',
                              'L'' inserimento non è andato a buon fine',
                              'Torna a visualizzare gli ambienti di servizio',
                              'PackageStanze.visualizzaAmbientiServizio',
                              NULL);
    END;

    PROCEDURE modificaAmbienteServizio (
        varIdStanza IN NUMBER,
        selectmusei IN musei.idmuseo%TYPE,
        nomeAmbS       IN  VARCHAR2,
        dimAmbS            IN  NUMBER,
        tipoAmbS        IN  VARCHAR2
    ) IS
    BEGIN
        
        UPDATE STANZE
        SET
        nome=nomeAmbS,
        dimensione=DimAmbS,
        museo=selectmusei
        WHERE idstanza=varIdStanza;

        UPDATE AMBIENTIDISERVIZIO
        SET
        tipoambiente=tipoAmbS
        WHERE
        idstanza=varIdStanza;
        MODGUI1.REDIRECTESITO('Modifica effettuata',
                              'La modifica è stata effettuata correttamente',
                              'Torna a visualizzare gli ambienti di servizio',
                              'PackageStanze.visualizzaAmbientiServizio',
                              NULL);
        EXCEPTION WHEN OTHERS THEN
        MODGUI1.REDIRECTESITO('ERRORE: Modifica non riuscita',
                              'La modifica non è andata a buon fine',
                              'Torna a visualizzare gli ambienti di servizio',
                              'PackageStanze.visualizzaAmbientiServizio',
                              NULL);
    END;

    PROCEDURE rimuoviAmbienteServizio (
        varIdStanza IN NUMBER
    ) IS
    BEGIN
        
        UPDATE STANZE
        SET
        eliminato=1
        WHERE idstanza=varIdStanza;

        MODGUI1.REDIRECTESITO('Eliminazione effettuata',
                              'L''eliminazione è stata effettuata correttamente',
                              'Torna a visualizzare gli ambienti di servizio',
                              'PackageStanze.visualizzaAmbientiServizio',
                              NULL);
        EXCEPTION WHEN OTHERS THEN
        MODGUI1.REDIRECTESITO('ERRORE: Eliminazione non riuscita',
                              'L'' eliminazione non è andata a buon fine',
                              'Torna a visualizzare gli ambienti di servizio',
                              'PackageStanze.visualizzaAmbientiServizio',
                              NULL);
    END;

    PROCEDURE ripristinaAmbienteServizio (
        varIdStanza IN NUMBER
    ) IS
    BEGIN
        
        UPDATE STANZE
        SET
        eliminato=0
        WHERE idstanza=varIdStanza;

        MODGUI1.REDIRECTESITO('Ripristino effettuato',
                              'Il ripristino è stato effettuato correttamente',
                              'Torna a visualizzare gli ambienti di servizio',
                              'PackageStanze.visualizzaAmbientiServizio',
                              NULL);
        EXCEPTION WHEN OTHERS THEN
        MODGUI1.REDIRECTESITO('ERRORE: Ripristino non riuscito',
                              'Il ripristino non è andato a buon fine',
                              'Torna a visualizzare gli ambienti di servizio',
                              'PackageStanze.visualizzaAmbientiServizio',
                              NULL);
    END;
END PackageStanze;