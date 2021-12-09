create or replace package body tariffeCampiEstiviOperazioni as

procedure InserisciTariffeCampiEstivi
(
    prezzo in TARIFFECAMPIESTIVI.Prezzo%type default 0,
    etaMinima in TARIFFECAMPIESTIVI.Etaminima%type default 0,
    etaMassima in TARIFFECAMPIESTIVI.Etamassima%type default 0,
    campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type default 0
) is
    idSessione number(5) := modgui1.get_id_sessione();
begin
    modgui1.apripagina('Inserimento tariffa campo estivo');
    if idSessione is null then
        modgui1.header;
    else
        modgui1.header(idSessione);
    end if;
    htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;

    htp.prn('<h1 align="center">Inserimento Tariffa Campo Estivo</h1>');
    modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px; margin-top:110px"');
        modgui1.apridiv('class="w3-section"');
        modgui1.collegamento('X',operazioniGruppo4.gr4||operazioniGruppo4.menu_ce,' w3-btn w3-large w3-red w3-display-topright');
            modgui1.ApriForm(operazioniGruppo4.gr4||'ConfermaTariffeCampiEstivi', null, 'w3-container');
                modgui1.label('Prezzo');
                modgui1.inputtext('prezzo', 'prezzo', 0, prezzo);
                htp.br;
                modgui1.label('Eta minima');
                modgui1.inputtext('etaMinima', 'etaMinima', 0, etaMinima);
                htp.br;
                modgui1.label('Eta massima');
                modgui1.inputtext('etaMassima', 'etaMassima', 0, etaMassima);
                htp.br;
                modgui1.label('Campo Estivo');
                modgui1.selectopen('idCampoEstivo');
                for campoEstivo in
                    (select IdCampiEstivi, nome from campiestivi)
                loop
                    modgui1.selectoption(campoEstivo.IdCampiEstivi, campoEstivo.nome);
                end loop;
                modgui1.selectclose;
                htp.br;
                
                modgui1.inputsubmit('Aggiungi');
            modgui1.chiudiform;
        modgui1.chiudidiv;
    modgui1.chiudidiv;
    htp.bodyclose;
    htp.htmlclose;

end InserisciTariffeCampiEstivi;

procedure ConfermaTariffeCampiEstivi
(
    prezzo in TARIFFECAMPIESTIVI.Prezzo%type default 0,
    etaMinima in TARIFFECAMPIESTIVI.Etaminima%type default 0,
    etaMassima in TARIFFECAMPIESTIVI.Etamassima%type default 0,
    campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type default 0
) is
    idSessione number(5) := modgui1.get_id_sessione();
    campoFound number default null;
    campoEstivo_niceName varchar2(20) default null;
begin

    select count(*) into campoFound
    from CAMPIESTIVI
    where CAMPIESTIVI.IDCAMPIESTIVI = campoEstivo;

    if etaminima > Etamassima
    or prezzo < 0
    or etaminima < 0
    or campoFound is null
    or campoFound = 0
    then
        modgui1.apripagina('Pagina errore', 0);
        htp.bodyopen;
        modgui1.apridiv;
        htp.print('Uno dei parametri immessi non valido');
        modgui1.chiudidiv;
        htp.bodyclose;
        htp.htmlclose;
    else
        select NOME into campoEstivo_niceName
        from CAMPIESTIVI
        where CAMPIESTIVI.IDCAMPIESTIVI = campoEstivo;

        modgui1.apripagina('Conferma', idSessione);
        if idSessione is null then
            modgui1.header;
        else
            modgui1.header(idSessione);
        end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
        htp.prn('<h1 align="center">CONFERMA DATI</h1>');--DA MODIFICARE
        modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px" ');
            modgui1.apridiv('class="w3-section"');
                htp.br;
                modgui1.label('Prezzo:');
                htp.print(prezzo);
                htp.br;
                modgui1.label('Eta minima:');
                htp.print(etaMinima);
                htp.br;
                modgui1.label('Eta massima:');
                htp.print(etaMassima);
                htp.br;
                modgui1.label('Campo Estivo:');
                htp.print(campoEstivo_niceName);
                htp.br;
            modgui1.chiudidiv;
            modgui1.apriform(operazioniGruppo4.gr4||'ControllaTariffeCampiEstivi');
            htp.formhidden('prezzo', prezzo);
            htp.formhidden('etaMinima', etaMinima);
            htp.formhidden('etaMassima', etaMassima);
            htp.formhidden('campoEstivo', campoEstivo);
            modgui1.inputsubmit('Conferma');
            modgui1.chiudiform;
            modgui1.apriform(operazioniGruppo4.gr4||'InserisciTariffeCampiEstivi');
            htp.formhidden('prezzo', prezzo);
            htp.formhidden('etaMinima', etaMinima);
            htp.formhidden('etaMassima', etaMassima);
            htp.formhidden('campoEstivo', campoEstivo);
            modgui1.inputsubmit('Annulla');
            modgui1.chiudiform;
        modgui1.chiudidiv;
    end if;
    exception when others then
        dbms_output.put_line('Error: '||sqlerrm);
end ConfermaTariffeCampiEstivi;


procedure ControllaTariffeCampiEstivi
(
    prezzo in TARIFFECAMPIESTIVI.Prezzo%type default 0,
    etaMinima in TARIFFECAMPIESTIVI.Etaminima%type default 0,
    etaMassima in TARIFFECAMPIESTIVI.Etamassima%type default 0,
    campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type default 0
) is 
    idSessione number(5) := modgui1.get_id_sessione();
    type errorsTable is table of varchar2(32);
    errors errorsTable;
    errorsCount integer := 0;
    campoEstivoExists integer := 0;

begin
    insert into TARIFFECAMPIESTIVI(IdTariffa, Prezzo, Etaminima, Etamassima, CampoEstivo, Eliminato)
        values (IdTariffaSeq.nextval, prezzo, etaMinima, etaMassima, campoEstivo, 0);
    if sql%found then
        commit;
        modgui1.redirectesito('Inserimento andato a buon fine', null,
        'Inserisci una nuova tariffa',operazioniGruppo4.gr4||'InserisciTariffeCampiEstivi', null,
        'Torna ai campi estivi',operazioniGruppo4.gr4||operazioniGruppo4.menu_ce, null);
    end if;
    exception when others then
        modgui1.redirectesito('Inserimento non riuscito', null,
        'Riprova',operazioniGruppo4.gr4||'InserisciTariffeCampiEstivi',null,
        'Torna ai campi estivi',operazioniGruppo4.gr4||operazioniGruppo4.menu_ce,null);
end ControllaTariffeCampiEstivi;

procedure VisualizzaTariffeCampiEstivi
(
    idTariffa in TARIFFECAMPIESTIVI.IdTariffa%type
) is 
    idSessione number(5) := modgui1.get_id_sessione();
    found integer := 0;
begin
    htp.prn('<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> ');
    if idSessione is null then
        modgui1.header;
    else
        modgui1.header(idSessione);
    end if;
    htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
    modgui1.apridiv('class="w3-center"');

    select count(*)
    into found
    from TARIFFECAMPIESTIVI
    where TARIFFECAMPIESTIVI.IdTariffa = idTariffa;

    htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
    if found > 0 then
        modgui1.apridiv('class="w3-center"');
            htp.tableopen(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"');
            htp.tablerowopen;
            htp.TableData('Prezzo',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
            htp.TableData('Eta minima',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
            htp.TableData('Eta massima',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
            htp.TableData('Campo Estivo',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
            htp.tablerowclose;
            for tariffa in (
                select TARIFFECAMPIESTIVI.Prezzo, TARIFFECAMPIESTIVI.Etaminima, 
                    TARIFFECAMPIESTIVI.Etamassima, CAMPIESTIVI.NOME
                from TARIFFECAMPIESTIVI join CAMPIESTIVI 
                    on TARIFFECAMPIESTIVI.CAMPOESTIVO = CAMPIESTIVI.IDCAMPIESTIVI
                where TARIFFECAMPIESTIVI.IdTariffa = idTariffa
            )
            loop
            htp.tablerowopen;
            htp.tabledata(tariffa.Prezzo,'center');
            htp.tabledata(tariffa.Etaminima,'center');
            htp.tabledata(tariffa.Etamassima,'center');
            htp.tabledata(tariffa.NOME,'center');
            htp.tablerowclose;
            end loop;
            htp.tableclose;
        modgui1.chiudidiv;
    else
        modgui1.apripagina('Tariffa non trovata', sessionID);
        htp.prn('Tariffa non trovata');
    end if;

    htp.bodyclose;
    htp.htmlclose;
    
end;

procedure ModificaTariffeCampiEstivi
(
    sessionID in number, 
    idTariffa in TARIFFECAMPIESTIVI.IdTariffa%type, 
    prezzo in TARIFFECAMPIESTIVI.Prezzo%type default 0,
    etaMinima in TARIFFECAMPIESTIVI.Etaminima%type default 0,
    etaMassima in TARIFFECAMPIESTIVI.Etamassima%type default 0,
    campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type default 0
) is 
begin
    htp.htmlopen;
    htp.htmlclose;
end;

procedure CancellaTariffeCampiEstivi
(
    sessionID in number, 
    idTariffa in TARIFFECAMPIESTIVI.IdTariffa%type
) is
begin
    htp.htmlopen;
    htp.htmlclose;
end;

procedure MonitoraTariffeCampiEstivi_preferenzaTariffa
(
    sessionID in number
) is 
begin
    htp.htmlopen;
    modgui1.apripagina();
    modgui1.header();
    htp.bodyopen;
    htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
    modgui1.apridiv('class="w3-modal-content w3-card-4" style="max-width:600px"');

    htp.tableopen;
    for tariffa in (
        select Tariffa, count(*) as conto
        from PAGAMENTICAMPIESTIVI
        group by Tariffa
        having count(*) = (
            select max(subconto) from (
                select count(*) as subconto
                from PAGAMENTICAMPIESTIVI
                group by Tariffa
            )
        )
    )
    loop
        htp.tablerowopen;
        htp.tabledata(tariffa.Tariffa);
        htp.tabledata(tariffa.conto);
        htp.tablerowclose;
    end loop;

    modgui1.chiudidiv;
    htp.tableclose;
    htp.bodyclose;
    htp.htmlclose;

end;

procedure monitoraTariffeCampiEstivi_tariffeAnno
(
    sessionID in number,
    anno in number
) is
begin
    htp.htmlopen;
    modgui1.apripagina();
    modgui1.header();
    htp.bodyopen;
    modgui1.apridiv('class="w3-modal-content w3-card-4" style="max-width:600px"');

    htp.tableopen;
    for tariffa in (
        select TARIFFA, DATAPAGAMENTO
        from PAGAMENTICAMPIESTIVI
        where extract(year from DATAPAGAMENTO)= anno
    )
    loop
        htp.tablerowopen;
        htp.tabledata(tariffa.Tariffa);
        htp.tabledata(tariffa.DataPagamento);
        htp.tablerowclose;
    end loop;

    htp.tableclose;
    htp.bodyclose;
    htp.htmlclose;
end;

procedure MonitoraTariffeCampiEstivi_tariffeCampo
(
    sessionID in number, 
    campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type
) is 
begin
    htp.htmlopen;
    modgui1.apripagina();
    modgui1.header();
    htp.bodyopen;
    modgui1.apridiv('class="w3-modal-content w3-card-4" style="max-width:600px"');

    htp.tableopen;
    for tariffa in (
        select distinct Tariffa, Prezzo, CampoEstivo
        from TARIFFECAMPIESTIVI join PAGAMENTICAMPIESTIVI 
        on TARIFFECAMPIESTIVI.IdTariffa = PAGAMENTICAMPIESTIVI.TARIFFA
        where CampoEstivo = campoEstivo
        order by Prezzo desc
    )
    loop
        htp.tablerowopen;
        htp.tabledata(tariffa.Tariffa);
        htp.tabledata(tariffa.Prezzo);
        htp.tabledata(tariffa.CampoEstivo);
        htp.tablerowclose;
    end loop;

    htp.tableclose;
    htp.bodyclose;
    htp.htmlclose;
end;

end tariffeCampiEstiviOperazioni;