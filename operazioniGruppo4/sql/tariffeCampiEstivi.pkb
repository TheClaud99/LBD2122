create or replace package body tariffeCampiEstiviOperazioni as

procedure InserisciTariffeCampiEstivi
(
    sessionID in number, 
    prezzo in TARIFFECAMPIESTIVI.Prezzo%type default 0,
    etaMinima in TARIFFECAMPIESTIVI.Etaminima%type default 0,
    etaMassima in TARIFFECAMPIESTIVI.Etamassima%type default 0,
    campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type default 0
) is
begin
    htp.htmlopen;
    modgui1.apripagina('Inserimento tariffa campo estivo');

    modgui1.header();
    htp.bodyopen;

    htp.header(1, 'Inserisci una nuova tariffa', 'centered');
    modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px; margin-top:110px"');

    modgui1.apriform('ConfermaTariffeCampiEstivi', 'invia', 'w3-container');
    htp.formhidden('sessionID', 0);

    modgui1.label('Prezzo');
    modgui1.inputtext('prezzo', 'prezzo', 0, prezzo);
    htp.br;

    modgui1.label('etaMinima');
    modgui1.inputtext('etaMinima', 'etaMinima', 0, etaMinima);
    htp.br;

    modgui1.label('etaMassima');
    modgui1.inputtext('etaMassima', 'etaMassima', 0, etaMassima);
    htp.br;

    modgui1.label('campoEstivo');
    modgui1.inputtext('campoEstivo', 'campoEstivo', 0, campoEstivo);
    htp.br;

    modgui1.inputsubmit('Invia');

    modgui1.chiudiform;
    modgui1.chiudidiv;

    htp.bodyclose;
    htp.htmlclose;

end;

procedure ConfermaTariffeCampiEstivi
(
    sessionID in number, 
    prezzo in TARIFFECAMPIESTIVI.Prezzo%type default 0,
    etaMinima in TARIFFECAMPIESTIVI.Etaminima%type default 0,
    etaMassima in TARIFFECAMPIESTIVI.Etamassima%type default 0,
    campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type default 0
) is
begin
    htp.htmlopen;
    modgu1.apripagina('Conferma Tariffa Campi Estivi');
    modgui1.header();
    htp.bodyopen();
    modui1.apridiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
    if (etaMinima < 0) or (etaMassima < etaMinima) then
        modgui1.label('Parametri inseriti in maniera errata');
        modgui1.apriform('InserisciTariffeCampiEstivi');
        htp.formhidden('sessionID', sessionID);
        htp.formhidden('prezzo', prezzo);
        htp.formhidden('etaMinima', etaMinima);
        htp.formhidden('etaMassima', etaMassima);
        htp.formhidden('campoEstivo', campoEstivo);
        modgui1.inputsubmit('indietro');
        modgui1.chiudiform;
    else
        htp.tableopen;

        htp.tablerowopen;
        htp.tabledata('Prezzo: ');
        htp.tabledata(prezzo);
        htp.tablerowclose;
        htp.tablerowopen;
        htp.tabledata('etaMinima: ');
        htp.tabledata(etaMinima);
        htp.tablerowclose;
        htp.tablerowopen;
        htp.tabledata('etaMassima: ');
        htp.tabledata(etaMassima);
        htp.tablerowclose;
        htp.tablerowopen;
        htp.tabledata('campoEstivo: ');
        htp.tabledata(campoEstivo);
        htp.tablerowclose;
    
        htp.tableclose;

        modgui1.apriform('ControllaTariffeCampiEstivi');
        htp.formhidden('sessionID', sessionID);
        htp.formhidden('prezzo', prezzo);
        htp.formhidden('etaMinima', etaMinima);
        htp.formhidden('etaMassima', etaMassima);
        htp.formhidden('campoEstivo', campoEstivo);
        modgui1.inputsubmit('Conferma');
        modgui1.chiudiform;

        modgui1.apriform('InserisciTariffeCampiEstivi');
        htp.formhidden('sessionID', sessionID);
        htp.formhidden('prezzo', prezzo);
        htp.formhidden('etaMinima', etaMinima);
        htp.formhidden('etaMassima', etaMassima);
        htp.formhidden('campoEstivo', campoEstivo);
        modgui1.inputsubmit('Annulla');
        modgui1.chiudiform;
    end if;

    modgu1.chiudidiv;
    htp.bodyclose();
    htp.htlclose();

end;

procedure ControllaTariffeCampiEstivi
(
    sessionID in number, 
    prezzo in TARIFFECAMPIESTIVI.Prezzo%type default 0,
    etaMinima in TARIFFECAMPIESTIVI.Etaminima%type default 0,
    etaMassima in TARIFFECAMPIESTIVI.Etamassima%type default 0,
    campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type default 0
) is 
    type errorsTable is table of varchar2(32);
    errors errorsTable;
    errorsCount integer := 0;
    campoEstivoExists integer := 0;

begin
    htp.htmlopen;
    mogui1.apripagina('Controlla Tariffe Campi Estivi');
    modgui1.header();
    htp.bodyopen();
    modgui1.apridiv('class="w3-modal-content w3-card-4" style="max-width:600px"');

    select count(*)
    into campoEstivoExists
    from CAMPIESTIVI
    where CAMPIESTIVI.IdCampiEstivi = campoEstivo;

    /*
    if campoEstivoExists > 0 then
        campoEstivoExists := 1;
    end if;
    */

    if campoEstivoExists = 0 then
        errors.extend;
        errorsCount := errorsCount + 1;
        errors(errorsCount) := "campoEstivo";
    end if;

    if errorsCount > 0 then
        htp.print('<H1 ALIGN=CENTER>');
        modgui1.label('TariffaCampoEstivo parametri errati');
        htp.print('</H1>');
        for i in 1 .. errorsCount loop
            htp.print('<H1 ALIGN=CENTER>');
            modgui1.label(errors(i));
            htp.print('</H1>');
        end loop;
        htp.print('<H1 ALIGN=CENTER>');
        modgui1.label('TariffaCampoEstivo non inserita');
        htp.print('</H1>');
    else 
        insert into TARIFFECAMPIESTIVI(IdTariffa, Prezzo, Etaminima, Etamassima, CampoEstivo, Eliminato)
            values (IdTariffaSeq.nextval, prezzo, etaMinima, etaMassima, campoEstivo, 0);
        htp.print('<H1 ALIGN=CENTER>');
        modgui1.LABEL('TariffaCampoEstivo inserita correttamente');
        htp.print('</H1>');
    end if;

end;

procedure VisualizzaTariffeCampiEstivi
(
    sessionID in number, 
    idTariffa in TARIFFECAMPIESTIVI.IdTariffa%type
) is 
    found integer := 0;
begin
    htp.htmlopen;
    modgui1.apripagina();
    modgui1.header();
    htp.bodyopen;
    modgui1.apridiv('class="w3-modal-content w3-card-4" style="max-width:600px"');

    select count(*)
    into found
    from TARIFFECAMPIESTIVI
    where TARIFFECAMPIESTIVI.IdTariffa = idTariffa;

    if found > 0 then
        htp.tableopen;
        for tariffa in (
            select Prezzo, Etaminima, Etamassima, CampoEstivo
            from TARIFFECAMPIESTIVI
            where TARIFFECAMPIESTIVI.IdTariffa = idTariffa;
        )
        loop
          htp.tablerowopen;
          htp.tabledata(tariffa.Prezzo);
          htp.tabledata(tariffa.Etaminima);
          htp.tabledata(tariffa.Etamassima);
          htp.tabledata(tariffa.CampoEstivo);
          htp.tablerowclose;
        end loop
        htp.tableclose;
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
    
end;

procedure CancellaTariffeCampiEstivi
(
    sessionID in number, 
    idTariffa in TARIFFECAMPIESTIVI.IdTariffa%type
) is
begin
    
end;

procedure MonitoraTariffeCampiEstivi_preferenzaTariffa
(
    sessionID in number
) is 
begin
    htp.htmlopen;
    mogui1.apripagina();
    modgui1.header();
    htp.bodyopen;
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
        );
    )
    loop
        htp.tablerowopen;
        htp.tabledata(pagamento.Tariffa);
        htp.tabledata(pagamento.conto);
        htp.tablerowclose;
    end loop;

    htp.tableclose;
    htp.bodyclose;
    htp.htmlclose;

end;

/* non so a cosa si riferisca anno in <Lista Tariffe relative ad un anno scelto>
procedure monitoraTariffeCampiEstivi_tariffeAnno
(
    ????
);
*/

procedure MonitoraTariffeCampiEstivi_tariffeCampo
(
    sessionID in number, 
    campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type
) is 
begin
    htp.htmlopen;
    mogui1.apripagina();
    modgui1.header();
    htp.bodyopen;
    modgui1.apridiv('class="w3-modal-content w3-card-4" style="max-width:600px"');

    htp.tableopen;
    for tariffa in (
        select distinct Tariffa, Prezzo, CampoEstivo
        from TARIFFECAMPIESTIVI join PAGAMENTICAMPIESTIVI 
        on TARIFFECAMPIESTIVI.IdTariffa = PAGAMENTICAMPIESTIVI.TARIFFA
        where CampoEstivo = campoEstivo
        order by Prezzo desc;
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