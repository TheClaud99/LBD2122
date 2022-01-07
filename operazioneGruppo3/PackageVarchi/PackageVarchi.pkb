create or replace PACKAGE BODY         PackageVarchi as

procedure tabellaDatiVarco (
    Nome      in VARCHAR2,
    Sensore   in NUMBER,
    idStanza1Selezionata in STANZE.IdStanza%TYPE,
    idStanza2Selezionata in STANZE.IdStanza%TYPE)
is
    v_Museo MUSEI%ROWTYPE;
    idMuseoSelezionato MUSEI.IdMuseo%TYPE;
    b_Stanza1 NUMBER;
    v_Stanza1 STANZE.Nome%TYPE;
    b_Stanza2 NUMBER;
    v_Stanza2 STANZE.Nome%TYPE;
begin
    modgui1.apridiv('style="margin-left: 2%; margin-right: 2%;"');
    htp.header(2, Nome);
    htp.tableopen;
    htp.tablerowopen;
            htp.tabledata('Nome Varco: ');
            htp.tabledata(Nome);
        htp.tablerowclose;
        htp.tablerowopen;
            htp.tabledata('Sensore n: ');
            htp.tabledata(Sensore);
        htp.tablerowclose;
        htp.tablerowopen;
            htp.tabledata('Museo: ');
            SELECT MUSEI.* INTO v_Museo
            FROM STANZE, MUSEI
            WHERE idStanza = idStanza1Selezionata and STANZE.Museo=MUSEI.idMuseo;
            modgui1.apriElementoTabella('Museo', v_Museo.idMuseo);
            modgui1.Collegamento(v_Museo.Nome, 'operazioniGruppo4.visualizzaMusei?museoId=' || v_Museo.idMuseo);
            modgui1.chiudiElementoTabella;
        htp.tablerowclose;
        htp.tablerowopen;
            htp.tabledata('Stanza1: ');
            SELECT Nome INTO v_Stanza1
            FROM STANZE
            WHERE idStanza = idStanza1Selezionata;

            SELECT COUNT(*) into b_Stanza1
            FROM STANZE, SALE
            WHERE stanze.idstanza = sale.idstanza and sale.idstanza = idStanza1Selezionata;
            
            modgui1.apriElementoTabella('Stanza1', idStanza1Selezionata);
            if (b_Stanza1 > 0) then
                modgui1.Collegamento(v_Stanza1, 'packageStanze.visualizzaSala?varIdSala=' || idStanza1Selezionata);
            else
                modgui1.ElementoTabella(v_Stanza1);
            end if;
            modgui1.chiudiElementoTabella;
        htp.tablerowclose;
        htp.tablerowopen;
            htp.tabledata('Stanza2: ');
            SELECT Nome INTO v_Stanza2
            FROM STANZE
            WHERE idStanza = idStanza2Selezionata;
            
            SELECT COUNT(*) into b_Stanza2
            FROM STANZE, SALE
            WHERE stanze.idstanza = sale.idstanza and sale.idstanza = idStanza2Selezionata;
            
            modgui1.apriElementoTabella('Stanza2', idStanza2Selezionata);
            if (b_Stanza2 > 0) then
                modgui1.Collegamento(v_Stanza2, 'packageStanze.visualizzaSala?varIdSala=' || idStanza2Selezionata);
            else
                modgui1.ElementoTabella(v_Stanza2);
            end if;
            modgui1.chiudiElementoTabella;
        htp.tablerowclose;
    htp.tableclose;
    modgui1.chiudidiv;
EXCEPTION WHEN OTHERS THEN
    dbms_output.put_line('Error: ' || sqlerrm);
end;

procedure visualizzaVarco(
    idVarcoSelezionato   in VARCHI.idvarchi%TYPE
)
is
    varco VARCHI%rowtype;
begin
    select * into varco
    from VARCHI
    where idvarchi = idVarcoSelezionato;

    modGUI1.apripagina();
    modGUI1.header();
    modGUI1.apridiv('style="margin-top: 110px"');
    modGUI1.apridivcard();
    modGUI1.collegamento('X',
                         'PackageVarchi.menuVarchi',
                         'w3-btn w3-large w3-red w3-display-topright');
    
    tabellaDatiVarco(varco.nome, varco.sensore, varco.stanza1, varco.stanza2);
    modGUI1.chiudidiv();
    modGUI1.chiudidiv();
    
EXCEPTION WHEN no_data_found THEN
    modGUI1.apripagina();
    modGUI1.header();
    modGUI1.apridiv('class="w3-center" style="margin-top: 110px"');
	htp.prn('<h1>Nessun Varco trovato con id ' || idVarcoSelezionato || ' </h1>'); 
    modgui1.collegamento('Torna a menuVarchi',
                         'PackageVarchi.menuVarchi',
                         'w3-btn w3-margin w3-round-xxlarge w3-black');
    modGUI1.chiudidiv();
    htp.prn('</body></html>');
end;

procedure calcolaRisultato (
    idVarco in VARCHI.idVarchi%TYPE DEFAULT NULL,
    idStanzaSelezionata in STANZE.IdStanza%TYPE DEFAULT NULL,
    dataInizio VARCHAR2 DEFAULT NULL,
    dataFine VARCHAR2 DEFAULT NULL,	
    oraInizio VARCHAR2  DEFAULT NULL,	
    oraFine VARCHAR2 DEFAULT NULL,
    operazione NUMBER)
is
    idSessione NUMBER(5) := modgui1.get_id_sessione;
    quanti Number;
    v_dataInizio DATE default null;
    v_dataFine DATE default null;	
    v_oraInizio VARCHAR2(6) DEFAULT NULL;	
    v_oraFine VARCHAR2(6) DEFAULT NULL;
begin
    /* first we convert the varchar stuff into dates or timestamps */
    v_dataInizio := to_date(dataInizio, 'YYYY-MM-DD');
    v_dataFine := to_date(dataFine, 'YYYY-MM-DD');
    v_oraInizio := to_char(to_date(replace(oraInizio, ':'), 'HH24MI'), 'HH24MISS');
    v_oraFine := to_char(to_date(replace(oraFine, ':'), 'HH24MI'), 'HH24MISS');
    
    modgui1.apripagina('Statistiche');
    modgui1.header();
    modgui1.apridiv('style="margin-top: 110px"');

    IF (operazione = 0) THEN /* numero visite passate dal varco in una certa data */
    select count(*) into quanti
		from Visite, Attraversamento, Varchi
        where attraversamento.idVisita = visite.idVisita AND varchi.idVarchi = attraversamento.idVarco 
              AND DataVisita >= v_dataInizio
              and DataVisita <= v_dataFine;
    modGUI1.ApriDiv('class="w3-center"');
        htp.prn('<h1><b>STATISTICHE VARCHI</b></h1>'); --TITOLO
        htp.prn('<h4><b>Numero di visite passate dal varco è '||quanti||'</b></h4>');
        modgui1.collegamento('Torna a menuVarchi',
                             'PackageVarchi.menuVarchi',
                             'w3-btn w3-margin w3-round-xxlarge w3-black');
        htp.br;
        htp.br;
        modGUI1.Collegamento('Indietro',
                             'packagevarchi.StatisticheVarchi?operazione=' || operazione,
                             'w3-button w3-round-xxlarge w3-black');
    modGUI1.ChiudiDiv;
    htp.br;
    END IF;
  IF (operazione = 1) THEN -- media visite dal varco per fascia oraria
    /* abbiamo bisogno della media della quantita' di varcature dentro la fascia oraria */
    
    select AVG(tot)
    into quanti
    from (
        select COUNT(*) as tot
        from Attraversamento vv JOIN Visite v ON (v.idVisita=vv.idVisita)
        where vv.idVarco = idVarco
            AND TO_CHAR(vv.attraversamentovarco, 'HH24MISS') > v_oraInizio
            AND TO_CHAR(vv.attraversamentovarco, 'HH24MISS') < v_oraFine
        group by to_char(vv.attraversamentovarco, 'YYYYMMDD')
        );
    modGUI1.ApriDiv('class="w3-center"');
    htp.prn('<h1><b>STATISTICHE VARCHI</b></h1>');
    htp.prn('<h4><b>In media ci sono state '||trunc(quanti,2)||' visite dalle ore '
            ||oraInizio||' alle ore '||oraFine||'</b></h4>');
    modGUI1.Collegamento('Torna a menuVarchi',
                         'packagevarchi.menuVarchi',
                         'w3-btn w3-margin w3-round-xxlarge w3-black');
    htp.br;
    htp.br;
    modGUI1.Collegamento('Indietro',
                         'packagevarchi.StatisticheVarchi?operazione=' || operazione,
                         'w3-button w3-round-xxlarge w3-black');
    modGUI1.ChiudiDiv;
    htp.br; 
    END IF;
    IF (operazione = 2) THEN /* numero varchi in una stanza, mostrando il nome */
        select count(*) into quanti
        from VARCHI 
        where varchi.Stanza1 = idStanzaSelezionata;
        
        modGUI1.ApriDiv('class="w3-center"');
        htp.prn('<h1><b>STATISTICHE VARCHI</b></h1>'); --TITOLO
        htp.prn('<h4><b>Numero di varchi nella stanza è '||quanti||'</b></h4>');
        
        for varco in (select idvarchi, nome from varchi where varchi.Stanza1 = idStanzaSelezionata)
        loop
            modGUI1.Collegamento(varco.nome, 'PackageVarchi.visualizzavarco?idvarcoselezionato=' || varco.idvarchi);
            htp.br;
        end loop;
        modgui1.collegamento('Torna a menuVarchi',
                             'PackageVarchi.menuVarchi',
                             'w3-btn w3-margin w3-round-xxlarge w3-black');
        htp.br;
        htp.br;
        modGUI1.Collegamento('Indietro',
                             'packagevarchi.StatisticheVarchi?operazione=' || operazione,
                             'w3-button w3-round-xxlarge w3-black');
        modGUI1.ChiudiDiv;
    htp.br;
    END IF;
    
    modGUI1.ChiudiDiv;
end;

procedure StatisticheVarchi(
    idVarco in VARCHI.idVarchi%TYPE DEFAULT NULL,
    idStanzaSelezionata in STANZE.IdStanza%TYPE DEFAULT NULL,
    dataInizio VARCHAR2 DEFAULT NULL,
    dataFine VARCHAR2 DEFAULT NULL,	
    oraInizio VARCHAR2 DEFAULT NULL,	
    oraFine VARCHAR2 DEFAULT NULL,
    operazione NUMBER DEFAULT 0)
is
    idsessione NUMBER(5) := modgui1.get_id_sessione;
begin
	IF (operazione = 0) THEN
        modgui1.apripagina();
        modgui1.header();
        modgui1.apridiv('class="w3-center" style="margin-top: 110px"');
		htp.prn('<h1><b>Seleziona Data Inizio, Data Fine e Varco: </b></h1>'); --TITOLO
    	modgui1.ApriForm('packagevarchi.calcolaRisultato');
            htp.formhidden('operazione', operazione);
            MODGUI1.Label('Data inizio');
            MODGUI1.InputDate('dataInizio', 'dataInizio', 1, dataInizio);
            htp.br;
            MODGUI1.Label('Data fine');
            MODGUI1.InputDate('dataFine', 'dataFine', 1, dataFine);
            htp.br;
            modGUI1.Label('Seleziona Varco:');
            modGUI1.SelectOpen('idVarco', 'varco-selezionato');
                    for varco in (select IdVarchi, Nome from VARCHI)
                    loop
                            modGUI1.SelectOption(varco.IdVarchi, varco.Nome, 0);
                    end loop;
            modGUI1.SelectClose;
            htp.br;
            modGUI1.Bottone('w3-margin w3-round-xxlarge w3-black" type="submit" ', 'Avanti');
            modGUI1.Collegamento('Indietro',
                                 'packagevarchi.menuVarchi',
                                 'w3-button w3-round-xxlarge w3-black');
    modgui1.ChiudiForm();
    modGUI1.ChiudiDiv;
  	END IF;     

    IF (operazione = 1) THEN	
        modgui1.apripagina();
        modgui1.header();
        modgui1.apridiv('class="w3-center" style="margin-top: 110px"');
		htp.prn('<h1><b>Seleziona Ora Inizio, Ora Fine e Varco: </b></h1>'); --TITOLO
        modgui1.ApriForm('packagevarchi.calcolaRisultato');
            htp.formhidden('operazione', operazione);
            MODGUI1.Label('Ora inizio');
            MODGUI1.InputTime('oraInizio', 'oraInizio', 1, oraInizio);
            htp.br;
            MODGUI1.Label('Ora fine');
            MODGUI1.InputTime('oraFine', 'oraFine', 1, oraFine);
            htp.br;
            modGUI1.Label('Seleziona Varco:');
            modGUI1.SelectOpen('idVarco', 'varco-selezionato');
                    for varco in (select IdVarchi, Nome from VARCHI)
                    loop
                            modGUI1.SelectOption(varco.IdVarchi, varco.Nome, 0);
                    end loop;
            modGUI1.SelectClose;
            htp.br;
            modGUI1.Bottone('w3-margin w3-round-xxlarge w3-black" type="submit" ', 'Avanti');
            modGUI1.Collegamento('Indietro',
                                 'packagevarchi.menuVarchi',
                                 'w3-button w3-round-xxlarge w3-black');
        modgui1.ChiudiForm();
        modGUI1.ChiudiDiv;        
		END IF;

    IF (operazione = 2) THEN		
        
        modgui1.apripagina();
        modgui1.header();
        modgui1.apridiv('class="w3-center" style="margin-top: 110px"');

        modgui1.ApriForm('packagevarchi.calcolaRisultato');
            htp.formhidden('operazione', operazione);
            htp.prn('<h1><b>Seleziona Stanza</b></h1>'); --TITOLO
                modGUI1.SelectOpen('idStanzaSelezionata', 'stanza-selezionata');
                    for stanza in (select IdStanza, Nome from STANZE)
                    loop
                            modGUI1.SelectOption(stanza.IdStanza, stanza.Nome, 0);
                    end loop;
                modGUI1.SelectClose;
                htp.br;
                modGUI1.Bottone('w3-margin w3-round-xxlarge w3-black" type="submit" ', 'Avanti');
                modGUI1.Collegamento('Indietro',
                                     'packagevarchi.menuVarchi',
                                     'w3-button w3-round-xxlarge w3-black');
        modgui1.ChiudiForm();
        modGUI1.ChiudiDiv;
    	END IF;
 	htp.BodyClose;
	htp.HtmlClose;
end;

procedure selezionaStats(
    idSessione NUMBER DEFAULT 0)
is
begin
        modGUI1.ApriDiv('id="11" class="w3-modal"');
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
                modGUI1.ApriDiv('class="w3-center"');
                    htp.br;
                    htp.prn('<span onclick="document.getElementById(''11'').style.display=''none''" class="w3-button w3-large w3-red w3-display-topright" title="Close Modal">X</span>');
                    htp.print('<h1>Seleziona la statistica d''interesse</h1>');
                modGUI1.ChiudiDiv;
                    modGUI1.ApriForm('packageVarchi.StatisticheVarchi','seleziona statistica','w3-container');
                        htp.print('<h4>');
                        htp.br;
                        htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                        MODGUI1.InputRadioButton('Numero visite passate dal varco in una certa data', 'operazione',0);
                        htp.br;
                        htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                        MODGUI1.InputRadioButton('Media visite passate dal varco per fascia oraria', 'operazione',1);
                        htp.br;
                        htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
                        MODGUI1.InputRadioButton('Numero varchi in una stanza, mostrandone il nome', 'operazione',2);
                        htp.print('</h4>');
                        htp.br;
                        htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit">Seleziona</button>');
                        modGUI1.ChiudiDiv;
                    modGUI1.ChiudiForm;
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
end;

procedure menuVarchi (
    Search in VARCHAR2 DEFAULT NULL
)
is
    idsessione NUMBER(5) := modgui1.get_id_sessione;
    v_museoSessione Musei.idMuseo%TYPE;
begin

    -- GM can visulize, modify and request statistics 
    if(hasRole(idsessione, 'GM')) then
        modgui1.apripagina('Varchi');
        modgui1.header();
        modgui1.apridiv('style="margin-top: 95px"');
        modgui1.apridiv('class="w3-center"'); 
        htp.prn('<h1>Varchi</h1>');
        
        modgui1.collegamento('Inserisci nuovo',
                             'PackageVarchi.formVarco',
                             'w3-btn w3-round-xxlarge w3-black'); 
        
        --statistics
        htp.prn('<button onclick="document.getElementById(''11'').style.display=''block''" class="w3-btn w3-round-xxlarge w3-black w3-margin">Statistiche</button>');
        modGUI1.ChiudiDiv;
        selezionaStats();
        
        --ricerca
        modGUI1.ApriDiv('class="w3-container"');
            modGUI1.ApriForm('packageVarchi.menuVarchi',NULL,'" style="display:inline;');
                modGUI1.ApriDiv('class="w3-center"');
                    modGUI1.INPUTTEXT('Search','Ricerca per nome...',0,NULL,1000);
                    htp.prn('<input type="submit" value="🔎︎" class="w3-round-xxlarge" style="margin-left:2px;height:35px;display:inline;">'); 
                modGUI1.ChiudiDiv();
            modGUI1.ChiudiForm;
        modGUI1.ChiudiDiv;
        
        modGUI1.ApriDiv('class="w3-row w3-container"');
        --loop di visualizzazione
            for varco in (select *
                          from VARCHI
                          where upper(VARCHI.nome) like '%' || upper(Search) ||'%'
                         )
            loop
                modgui1.apridiv('class="w3-col l4 w3-padding-large w3-center"');
                        modgui1.apridiv('class="w3-card-4"');
                            htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%">');
                            modgui1.apridiv('class="w3-container w3-center"');
                                tabellaDatiVarco(varco.nome, varco.sensore, varco.stanza1, varco.stanza2);
                            modgui1.chiudidiv;
            
                            modgui1.collegamento('Visualizza', 
                                                 'packagevarchi.visualizzaVarco?idVarcoSelezionato=' || varco.idvarchi, 
                                                 'w3-button w3-black');
                            modgui1.Collegamento('Modifica',
                                                 'packagevarchi.formVarco?modifica=1&Nome=' || varco.nome || '&Sensore=' || varco.sensore || '&idStanza1=' || varco.stanza1 || '&idStanza2=' || varco.Stanza2 || '&idVarcoSelezionato=' || varco.idVarchi, 
                                                 'w3-button w3-green');
                        modgui1.chiudidiv;
                modgui1.chiudidiv;
        end loop;
        modGUI1.chiudiDiv;
        
    -- SU DBA can visulize, modify, request statistics, insert and remove
    elsif(hasRole(idsessione, 'DBA')) then
        modgui1.apripagina('Varchi');
        modgui1.header();
        modgui1.apridiv('style="margin-top: 95px"');
        modgui1.apridiv('class="w3-center"');
        htp.prn('<h1>Varchi</h1>');
        
        modgui1.collegamento('Inserisci nuovo',
                             'PackageVarchi.formVarco',
                             'w3-btn w3-round-xxlarge w3-black'); 
        --statistics
        htp.prn('<button onclick="document.getElementById(''11'').style.display=''block''" class="w3-btn w3-round-xxlarge w3-black w3-margin">Statistiche</button>');
        modGUI1.ChiudiDiv;
        selezionaStats();
            
        --ricerca
        modGUI1.ApriDiv('class="w3-container"');
            modGUI1.ApriForm('packageVarchi.menuVarchi',NULL,'" style="display:inline;');
                modGUI1.ApriDiv('class="w3-center"');
                    modGUI1.INPUTTEXT('Search','Ricerca per nome...',0,NULL,1000);
                    htp.prn('<input type="submit" value="🔎︎" class="w3-round-xxlarge" style="margin-left:2px;height:35px;display:inline;">'); 
                modGUI1.ChiudiDiv();
            modGUI1.ChiudiForm;
        modGUI1.ChiudiDiv;
        
        modGUI1.ApriDiv('class="w3-row w3-container"');
        --loop di visualizzazione
            for varco in (select *
                          from VARCHI
                          where upper(VARCHI.nome) like '%' || upper(Search) ||'%'
                         )
            loop
                modgui1.apridiv('class="w3-col l4 w3-padding-large w3-center"');
                        modgui1.apridiv('class="w3-card-4"');
                            htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%">');
                            modgui1.apridiv('class="w3-container w3-center"');
                                tabellaDatiVarco(varco.nome, varco.sensore, varco.stanza1, varco.stanza2);
                            modgui1.chiudidiv;
                            modgui1.collegamento('Visualizza', 
                                                 'packagevarchi.visualizzaVarco?idVarcoSelezionato=' || varco.idvarchi, 
                                                 'w3-button w3-black');
                            modgui1.Collegamento('Modifica',
                                                 'packagevarchi.formVarco?modifica=1&Nome=' || varco.nome || '&Sensore=' || varco.sensore || '&idStanza1=' || varco.stanza1 || '&idStanza2=' || varco.Stanza2 || '&idVarcoSelezionato=' || varco.idVarchi, 
                                                 'w3-button w3-green');
                            modgui1.collegamento('Rimuovi',
                                                 'packagevarchi.confermaCancellazione?idVarcoSelezionato=' || varco.idvarchi,
                                                 'w3-button w3-red');
                        modgui1.chiudidiv;
                    modgui1.chiudidiv;
            end loop;
        modGUI1.chiudiDiv;
        
    elsif(hasRole(idsessione, 'U') or hasRole(idsessione, 'AB') or hasRole(idsessione, 'GO') or hasRole(idsessione, 'GO') or hasRole(idsessione, 'GCE')) then
        modgui1.apripagina('Varchi');
        modgui1.header();
        modgui1.apridiv('style="margin-top: 95px"');
        modgui1.apridiv('class="w3-center"'); 
        htp.prn('<h1>Varchi</h1>');
        htp.prn('<h2>Utente non autorizzato a visualizzare.</h2>');
    
    else
        modgui1.apripagina('Varchi');
        modgui1.header();
        modgui1.apridiv('style="margin-top: 95px"');
        modgui1.apridiv('class="w3-center"');
        htp.prn('<h1>Varchi</h1>');
        htp.prn('<h2>Esegui login per visualizzare.</h2>');
    end if;

    modgui1.chiudidiv();
    modgui1.chiudidiv();
    htp.prn('</body></html>');
end;

procedure jsonStanze(
    idMuseo in MUSEI.IdMuseo%TYPE)
is
begin
    owa_util.mime_header ('application/json', true);
    -- ideally we would like to simply return $current from an expression like this:
    -- select JSON_ARRAY(IdStanza, Nome) st into current from STANZE where STANZE.Museo=idMuseo AND STANZE.Eliminato=0;
    -- but generating json is fun and oracle is not
    htp.prn('[');
    for st in (select IdStanza, Nome from stanze where STANZE.Museo=idMuseo AND STANZE.Eliminato=0)
    loop
        htp.prn('{');
        htp.prn('"IdStanza": "'); htp.prn(st.IdStanza); htp.prn('",');
        htp.prn('"Nome": "'); htp.prn(st.Nome);
        htp.prn('"},'); -- we trim this , at the end by removing it on the js side
    end loop;
    htp.prn('{"IdStanza": null,');
    htp.prn('"Nome": null}'); -- also ensures we always return something and not a badly formatted json
    htp.prn(']');
end;

procedure inserisciVarco(
    Nome in VARCHAR2,
    Sensore in NUMBER,
    idStanza1 in STANZE.IdStanza%TYPE,
    idStanza2 in STANZE.IdStanza%TYPE)
is
    idsessione NUMBER(5) := modgui1.get_id_sessione;
    idMuseoCreato1 MUSEI.IdMuseo%TYPE;
    idMuseoCreato2 MUSEI.IdMuseo%TYPE;
    idVarcoCreato VARCHI.IdVarchi%TYPE;
    V_quanti NUMBER;
    V_sensore NUMBER;
    diffMuseum EXCEPTION;
    sameSensor EXCEPTION;
    sameStanza EXCEPTION;
begin
    
    -- checks: stanze must be different (table integrity)
    if(idStanza1=idStanza2)
    then
        raise sameStanza;
    end if;

    -- checks: stanze must be of the same museum
    select Museo
        into idMuseoCreato1
        from Stanze
        where Stanze.IDSTANZA=idStanza1;
    select Museo
        into idMuseoCreato2
        from Stanze
        where Stanze.IDSTANZA=idStanza2;
    IF (idMuseoCreato1 != idMuseoCreato2)
    THEN
        raise diffMuseum;
    END IF;

    -- checks: no other varco with same sensor in same museum
    V_sensore := sensore;
    select COUNT(*) into V_quanti
        from Varchi, Stanze
        where Varchi.Stanza1 = Stanze.IdStanza
        AND Varchi.Sensore = V_Sensore AND Stanze.Museo=idMuseoCreato1;
    IF (V_quanti!=0)
    THEN
        raise sameSensor;
    END IF;

    idVarcoCreato := IdVarchiSeq.nextval;
    INSERT INTO VARCHI (IdVarchi, Nome, Sensore, Stanza1, Stanza2, Eliminato)
    VALUES (idVarcoCreato, Nome, Sensore, idStanza1, idStanza2, 0);

    -- to display:
    modGUI1.ApriDiv('style="margin-top: 110px"');
    htp.prn('<h1>Varco inserito correttamente</h1>');
    modGUI1.ChiudiDiv;
    visualizzaVarco(idVarcoCreato);
    
    modgui1.apridiv('class="w3-center" style="margin-top: 20px"');
    modgui1.collegamento('Inserisci un altro varco',
                         'PackageVarchi.formVarco',
                         'w3-btn w3-margin w3-round-xxlarge w3-black');
    modgui1.collegamento('Vai a menuVarchi',
                         'PackageVarchi.menuVarchi',
                         'w3-btn w3-margin w3-round-xxlarge w3-black');
    modgui1.chiudidiv;
EXCEPTION
    when diffMuseum then
        modgui1.apripagina('Errore Inserimento');
        modgui1.header();
        modGUI1.ApriDiv('class="w3-center" style="margin-top: 100px"');
        htp.prn('<h1>Varco non inserito</h1>');
        htp.prn('<h2>Stanze di musei diversi.</h2>');
        modgui1.collegamento('Torna a inserimento',
                             'PackageVarchi.formVarco?Nome=' || Nome || '&Sensore=' || Sensore || '&idStanza1=' || idStanza1 || '&idStanza2=' || idStanza2,
                             'w3-btn w3-margin w3-round-xxlarge w3-black');
        modgui1.collegamento('Torna a menuVarchi',
                             'PackageVarchi.menuVarchi',
                             'w3-btn w3-margin w3-round-xxlarge w3-black');
        modGUI1.ChiudiDiv;
    when sameSensor then
        modgui1.apripagina('Errore Inserimento');
        modgui1.header();
        modGUI1.ApriDiv('class="w3-center" style="margin-top: 100px"');
        htp.prn('<h1>Varco non inserito</h1>');
        htp.prn('<h2>Varchi con stesso sensore nello stesso museo.</h2>');
        modgui1.collegamento('Torna a inserimento',
                             'PackageVarchi.formVarco?Nome=' || Nome || '&Sensore=' || Sensore || '&idStanza1=' || idStanza1 || '&idStanza2=' || idStanza2,
                             'w3-btn w3-margin w3-round-xxlarge w3-black');
        modgui1.collegamento('Vai a menuVarchi',
                             'PackageVarchi.menuVarchi',
                             'w3-btn w3-margin w3-round-xxlarge w3-black');
        modGUI1.ChiudiDiv;
    when sameStanza then
        modgui1.apripagina('Errore Inserimento');
        modgui1.header();
        modGUI1.ApriDiv('class="w3-center" style="margin-top: 100px"');
        htp.prn('<h1>Varco non inserito</h1>');
        htp.prn('<h2>Stessa stanza selezionata.</h2>');
        modgui1.collegamento('Torna a inserimento',
                             'PackageVarchi.formVarco?Nome=' || Nome || '&Sensore=' || Sensore || '&idStanza1=' || idStanza1 || '&idStanza2=' || idStanza2,
                             'w3-btn w3-margin w3-round-xxlarge w3-black');
        modgui1.collegamento('Vai a menuVarchi',
                             'PackageVarchi.menuVarchi',
                             'w3-btn w3-margin w3-round-xxlarge w3-black');
        modGUI1.ChiudiDiv;
    when others then
        modgui1.apripagina('Errore Inserimento');
        modgui1.header();
        modGUI1.ApriDiv('class="w3-center" style="margin-top: 100px"');
        htp.prn('<h1>Varco non inserito</h1>');
        htp.prn('<h2>Campo non valido.</h2>');
        modgui1.collegamento('Torna a inserimento',
                             'PackageVarchi.formVarco?Nome=' || Nome || '&Sensore=' || Sensore || '&idStanza1=' || idStanza1 || '&idStanza2=' || idStanza2,
                             'w3-btn w3-margin w3-round-xxlarge w3-black');
        modgui1.collegamento('Vai a menuVarchi',
                             'PackageVarchi.menuVarchi',
                             'w3-btn w3-margin w3-round-xxlarge w3-black');
        modGUI1.ChiudiDiv;
end;

procedure formVarco (
    modifica in NUMBER DEFAULT 0,
    idVarcoSelezionato in VARCHI.idvarchi%TYPE DEFAULT NULL,
    Nome in VARCHAR2 DEFAULT NULL,
    Sensore in NUMBER DEFAULT NULL,
    idStanza1 in STANZE.IdStanza%TYPE DEFAULT NULL,
    idStanza2 in STANZE.IdStanza%TYPE DEFAULT NULL,
    convalida in NUMBER DEFAULT NULL)
is 
    idsessione NUMBER(5) := modgui1.get_id_sessione;
    v_museo MUSEI.IdMuseo%TYPE default 0;
begin
    modGUI1.ApriPagina();
    modGUI1.Header();
    modGUI1.ApriDiv('style="margin-top: 110px"');
        IF modifica = 0 THEN
            htp.prn('<h1>Inserimento varco</h1>');
        ELSE htp.prn('<h1>Modifica varco</h1>');
        END IF;
        IF convalida IS NULL THEN
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
                IF modifica = 0 THEN
                modGUI1.ApriForm('PackageVarchi.formVarco?modifica=' || modifica, 'formCreaVarco','w3-container');
                ELSE modGUI1.ApriForm('PackageVarchi.formVarco?modifica=' || modifica || '&idVarcoSelezionato=' || idVarcoSelezionato);
                END IF;
                    modGUI1.ApriDiv('class="w3-section"');
                        htp.formhidden('modifica', modifica);
                        htp.formhidden('idVarcoSelezionato', idVarcoSelezionato);
                        modGUI1.Label('Nome del varco:');
                        modGUI1.InputText('Nome', 'Nome', 1, Nome);
                        htp.br;
                        
                        modGUI1.Label('Sensore varco:');
                        modGUI1.InputNumber('Sensore', 'Sensore', 1, sensore);
                        htp.br;
                        
                        modGUI1.Label('Museo:');
                        if idStanza1 IS NOT NULL then
                            select Museo into v_museo
                            from STANZE
                            where STANZE.idStanza = idStanza1;
                        end if;
                        -- we need a select that doesnt get sent with the form
                        -- modGUI1.SelectOpen('idSelectMuseo', 'museo-selezionato');
                        -- (no name)
                        htp.prn('<select id="idSelectMuseo" class="w3-select w3-border w3-margin-top w3-margin-bottom w3-round-xlarge" style="max-width:250px;" onChange="museumChangeFun(this);">');
                            for museo in (select idMuseo, Nome from MUSEI)
                            loop
                                if v_museo = museo.idMuseo then
                                    modGUI1.SelectOption(museo.IdMuseo, museo.Nome, 1);
                                else
                                modGUI1.SelectOption(museo.IdMuseo, museo.Nome, 0);
                                end if;
                            end loop;
                        modGUI1.SelectClose;
                        htp.br;

                        modGUI1.Label('Stanza 1:');
                        htp.prn('<select id="stanza-selezionata1" class="w3-select w3-border w3-margin-top w3-margin-bottom w3-round-xlarge" style="max-width:250px;" name="idStanza1" onChange="stanza1ChangeFun(this);">');
                        modGUI1.SelectClose;
                        htp.br;
                        
                        modGUI1.Label('Stanza 2:');
                        modGUI1.SelectOpen('idStanza2', 'stanza-selezionata2');
                        modGUI1.SelectClose;

                        htp.prn('<script>
                            var queryDict = {}
                            location.search.substr(1).split("&").forEach(function(item) {queryDict[item.split("=")[0]] = item.split("=")[1]})
                        </script>');

                        htp.prn('<script>
                            var museumChangeFun = async function (sel) {
                            const response = await fetch("' || costanti.server || costanti.radice || 'packagevarchi.jsonStanze?idMuseo=" + sel.options[sel.selectedIndex].value);
                            
                            var locitems = await response.json();
                        
                            locitems = locitems.filter((x) => x.IdStanza != null && x.Nome != null);
                            // now we have items so we push them to global
                            window.items = locitems
                        
                            var selectStanza1 = document.getElementById("stanza-selezionata1");
                            var selectStanza2 = document.getElementById("stanza-selezionata2");
                        
                            selectStanza1.innerHTML = "";
                            selectStanza2.innerHTML = "";
                        
                            for (var i=0; i<items.length; i++){
                                var item = items[i];
                                var element = document.createElement("option");
                                element.innerText = item.Nome;
                                element.value = item.IdStanza;
                                if(queryDict["idStanza1"]==item.IdStanza) {
                                    element.selected = "selected"
                                }
                                selectStanza1.append(element);
                            }
                            
                            stanza1ChangeFun(selectStanza1);
                        }
                        window.onload = museumChangeFun(document.getElementById("idSelectMuseo"));
                        </script>');
                        
                        htp.prn('<script>
                        var stanza1ChangeFun = async function (sel) {
                            if (window.items == null) {
                                await museumChangeFun(document.getElementById("idSelectMuseo"));
                            }
                            if (window.items.length == 0) {
                                throw "IdMuseo sbagliato";
                            }
                        
                            var selectStanza2 = document.getElementById("stanza-selezionata2");
                        
                            selectStanza2.innerHTML = "";
                        
                            for (var i=0; i<window.items.length; i++){
                            var item = window.items[i];
                            // we assume Ids are unique
                            if(item.IdStanza != sel.options[sel.selectedIndex].value) {
                                var element = document.createElement("option");
                                element.innerText = item.Nome;
                                element.value = item.IdStanza;
                                    if(queryDict["idStanza2"]==item.IdStanza) {
                                        element.selected = "selected"
                                    }
                                selectStanza2.append(element);
                            }
                        }
                        };
                        </script>');

                        htp.br;
                        modGUI1.InputReset;
                        IF modifica = 0 THEN
                            htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit" name="convalida" value="1">Inserisci</button>');
                            modgui1.collegamento('Annulla Inserimento',
                                                  'PackageVarchi.menuVarchi',
                                                  'w3-button w3-block w3-black w3-section w3-padding');
                        ELSE htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit" name="convalida" value="1">Modifica</button>');
                             modgui1.collegamento('Annulla Modifica',
                                                  'PackageVarchi.menuVarchi',
                                                  'w3-button w3-block w3-black w3-section w3-padding');
                        END IF;
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiForm;
            modGUI1.ChiudiDiv;
        ELSE
            IF modifica = 0 THEN
               htp.prn('<h1>Conferma dati varco </h1>'); 
            ELSE htp.prn('<h1>Conferma Modifiche </h1>'); 
            END IF;

            modGUI1.apridivcard();
            tabellaDatiVarco (Nome, Sensore, idStanza1, idStanza2);
            IF modifica = 0 THEN 
            modgui1.collegamento('Conferma',
                                 'PackageVarchi.inserisciVarco?Nome=' || Nome || '&Sensore=' || Sensore || '&idStanza1=' || idStanza1 || '&idStanza2=' || idStanza2,
                                 'w3-button w3-block w3-black w3-section w3-padding');
            modgui1.collegamento('Annulla',
            	                 'PackageVarchi.formVarco?Nome=' || Nome || '&Sensore=' || Sensore || '&idStanza1=' || idStanza1 || '&idStanza2=' || idStanza2,
                    	         'w3-button w3-block w3-black w3-section w3-padding');
            ELSE 
                modgui1.collegamento('Conferma',
                                     'PackageVarchi.modificaVarco?IdVarco=' || idVarcoSelezionato || '&NewNome=' || Nome || '&NewSensore=' || Sensore || '&NewidStanza1=' || idStanza1 || '&NewidStanza2=' || idStanza2,
                                     'w3-button w3-block w3-black w3-section w3-padding');
                modgui1.collegamento('Annulla',
                	                 'PackageVarchi.formVarco?modifica=1&idVarcoSelezionato=' || idVarcoSelezionato || '&Nome=' || Nome || '&Sensore=' || Sensore,
                        	         'w3-button w3-block w3-black w3-section w3-padding');
            
            END IF;
            modgui1.chiudidiv;
        END IF;
    modGUI1.ChiudiDiv();
    IF modifica = 0 THEN
    htp.prn('<script>function inviaFormCreaVarchi() {
            document.formCreaVarco.submit();
           }</script>');
    END IF;
    htp.prn('</body></html>');
end;

procedure modificaVarco(
    IdVarco in varchi.IdVarchi%TYPE,
    NewNome in VARCHAR2,
    NewSensore in NUMBER,
    NewidStanza1 in STANZE.IdStanza%TYPE,
    NewidStanza2 in STANZE.IdStanza%TYPE) 
is
    idsessione NUMBER(5) := modgui1.get_id_sessione;
    idMuseoSelezionato MUSEI.IdMuseo%TYPE;
    idMuseoSelezionato2 MUSEI.IdMuseo%TYPE;
    quanti NUMBER;
    v_sensore NUMBER;
    noVarco EXCEPTION;
    sameSensor EXCEPTION;
    sameStanza EXCEPTION;
    diffMuseum EXCEPTION;
begin
    select COUNT(*)
    into quanti
    from varchi v
    where v.idvarchi = IdVarco;
    if (quanti=0) then
        raise noVarco;
    end if;

    if(NewidStanza1=NewidStanza2)
    then
        raise sameStanza;
    end if;
    
    select Museo
    into idMuseoSelezionato
    from Stanze s
    where s.idStanza=NewidStanza1;
    
    -- checks: stanze must be of the same museum
    select Museo
        into idMuseoSelezionato2
        from Stanze
        where Stanze.IDSTANZA=NewidStanza2;
    IF (idMuseoSelezionato != idMuseoSelezionato2)
    THEN
        raise diffMuseum;
    END IF;
    
    v_sensore := NewSensore;
    select COUNT(*) into quanti
    from Varchi, Stanze
    where Varchi.Stanza1 = Stanze.IdStanza
          AND Varchi.Sensore = v_sensore AND Stanze.Museo=idMuseoSelezionato;
    if (quanti!=0)then
        raise sameSensor;
    end if; 
            
    UPDATE VARCHI 
    SET Nome = NewNome,
        Sensore = NewSensore,
        Stanza1 = NewidStanza1,
        Stanza2 = NewidStanza2
    WHERE idvarchi = IdVarco;
    visualizzaVarco(IdVarco);
    modgui1.apripagina();
    modgui1.header();
    modgui1.apridiv('class="w3-center" style="margin-top: 50px"');
        htp.prn('<h1>Modifica varco effettuata correttamente</h1>');
        modgui1.collegamento('Torna a menuVarchi',
                             'PackageVarchi.menuVarchi?',
                             'w3-btn w3-margin w3-round-xxlarge w3-black');
    modGUI1.ChiudiDiv;
    
EXCEPTION
    when noVarco then
        modgui1.apripagina();
        modgui1.header();
        modGUI1.ApriDiv('class="w3-center" style="margin-top: 100px"');
        htp.prn('<h1>Varco non modificato</h1>');
        htp.prn('<h2>Varco non esistente.</h2>');
        modgui1.collegamento('Torna a menuVarchi',
                             'PackageVarchi.menuVarchi',
                             'w3-btn w3-margin w3-round-xxlarge w3-black');
        modGUI1.ChiudiDiv;
    when sameSensor then
        modgui1.apripagina();
        modgui1.header();
        modGUI1.ApriDiv('class="w3-center" style="margin-top: 100px"');
        htp.prn('<h1>Varco non modificato</h1>');
        htp.prn('<h2>Varchi con stesso sensore nello stesso museo.</h2>');
        modgui1.collegamento('Torna a Modifica',
                             'PackageVarchi.formVarco?modifica=1&idVarcoSelezionato=' || IdVarco || '&Nome=' || NewNome || '&Sensore=' || NewSensore || '&idStanza1=' || NewidStanza1 || '&idStanza2=' || NewidStanza2,
                             'w3-btn w3-margin w3-round-xxlarge w3-black');
        modGUI1.ChiudiDiv;
    when sameStanza then
        modgui1.apripagina();
        modgui1.header();
        modGUI1.ApriDiv('style="margin-top: 100px"');
        htp.prn('<h1>Varco non modificato</h1>');
        htp.prn('<h2>Stessa stanza selezionata.</h2>');
        modgui1.collegamento('Torna a Modifica',
                             'PackageVarchi.formVarco?modifica=1&idVarcoSelezionato=' || IdVarco || '&Nome=' || NewNome || '&Sensore=' || NewSensore || '&idStanza1=' || NewidStanza1 || '&idStanza2=' || NewidStanza2,
                             'w3-btn w3-margin w3-round-xxlarge w3-black');
        modGUI1.ChiudiDiv;
    when diffMuseum then
        modgui1.apripagina();
        modgui1.header();
        modGUI1.ApriDiv('style="margin-top: 100px"');
        htp.prn('<h1>Varco non modificato</h1>');
        htp.prn('<h2>Stanze in musei diversi.</h2>');
        modgui1.collegamento('Torna a Modifica',
                             'PackageVarchi.formVarco?modifica=1&idVarcoSelezionato=' || IdVarco || '&Nome=' || NewNome || '&Sensore=' || NewSensore || '&idStanza1=' || NewidStanza1 || '&idStanza2=' || NewidStanza2,
                             'w3-btn w3-margin w3-round-xxlarge w3-black');
        modGUI1.ChiudiDiv;
    when others then
        modgui1.apripagina();
        modgui1.header();
        modGUI1.ApriDiv('style="margin-top: 100px"');
        htp.prn('<h1>Varco non modificato</h1>');
        htp.prn('<h2>Campo non valido.</h2>');
        modgui1.collegamento('Torna a Modifica',
                            'PackageVarchi.formVarco?modifica=1&idVarcoSelezionato=' || IdVarco || '&Nome=' || NewNome || '&Sensore=' || NewSensore || '&idStanza1=' || NewidStanza1 || '&idStanza2=' || NewidStanza2,
                            'w3-btn w3-margin w3-round-xxlarge w3-black');
        modGUI1.ChiudiDiv;
    htp.bodyclose;
    htp.htmlclose;      
end;
    
procedure confermaCancellazione (
    idVarcoSelezionato   in  VARCHI.idvarchi%TYPE)
is
    idsessione NUMBER(5) := modgui1.get_id_sessione;
    varco VARCHI%rowtype;
begin
    select * into varco
    from VARCHI v
    where v.idvarchi = idVarcoSelezionato;

    modGUI1.apripagina();
    modGUI1.header();
    modGUI1.apridiv('class="w3-center" style="margin-top: 110px"');
	htp.prn('<h1>Conferma rimozione varco </h1>'); 
        modGUI1.apridivcard();
        tabellaDatiVarco (varco.nome, varco.sensore, varco.Stanza1, varco.Stanza2);
        modgui1.collegamento('Conferma',
                             'PackageVarchi.cancellazioneVarco?idVarcoSelezionato=' || idVarcoSelezionato,
                             'w3-button w3-block w3-black w3-section w3-padding');
        modgui1.collegamento('Annulla',
                             'PackageVarchi.menuVarchi',
                             'w3-button w3-block w3-black w3-section w3-padding');
        modgui1.chiudidiv;
     
    modGUI1.chiudidiv();
    
EXCEPTION WHEN no_data_found THEN
    modGUI1.apripagina();
    modGUI1.header();
    modGUI1.apridiv('class="w3-center" style="margin-top: 110px"');
	htp.prn('<h1>Nessun Varco trovato con id ' || idVarcoSelezionato || ' </h1>'); 
    modgui1.collegamento('Torna a menuVarchi',
                     'PackageVarchi.menuVarchi',
                     'w3-btn w3-margin w3-round-xxlarge w3-black');
    modGUI1.chiudidiv();
    htp.prn('</body></html>');
end;
   
procedure cancellazioneVarco (
    idVarcoSelezionato   in  VARCHI.idvarchi%TYPE)
is
    idsessione NUMBER(5) := modgui1.get_id_sessione;
begin
    DELETE from VARCHI where idvarchi = idVarcoSelezionato;
    modgui1.apripagina();
    modgui1.header();
    modgui1.apridiv('class="w3-center" style="margin-top: 110px"');
    htp.header(1, 'Varco eliminato correttamente', 'center');
    modgui1.collegamento('Torna a menuVarchi',
                         'PackageVarchi.menuVarchi',
                         'w3-btn w3-margin w3-round-xxlarge w3-black');
    modgui1.chiudidiv;
    htp.bodyclose;
    htp.htmlclose;
end;

end PackageVarchi;