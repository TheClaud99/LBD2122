procedure InserisciPagamentoCampiEstivi(
    dataPagamento in varchar2 default NULL,
    tariffa in PAGAMENTICAMPIESTIVI.Tariffa%type default 0, 
    acquirente in PAGAMENTICAMPIESTIVI.Aquirente%type default 0 
) is
idSessione number(5) := modgui1.get_id_sessione();
begin
    MODGUI1.ApriPagina('Inserimento pagamento campo estivo', 0);
    if idSessione is null then
        modgui1.header;
    else
        modgui1.header(idSessione);
    end if;
    htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;

    htp.prn('<h1 align="center">Inserimento Pagamento Campo Estivo</h1>');
    modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px; margin-top:110px"');
        modgui1.apridiv('class="w3-section"');
        modgui1.collegamento('X',operazioniGruppo4.gr4||operazioniGruppo4.menu_ce,' w3-btn w3-large w3-red w3-display-topright');
            modgui1.ApriForm(operazioniGruppo4.gr4||'ConfermaPagamentoCampiEstivi', null, 'w3-container');
                modgui1.label('Data Pagamento');
                modgui1.InputDate('dataPagamento', 'dataPagamento', 1, dataPagamento);
                htp.br;

                modgui1.label('Tariffa');
                modgui1.selectopen('idtariffa');
                for tariffa in 
                    (select idtariffa from tariffecampiestivi)
                loop
                    modgui1.selectoption(tariffa.idtariffa, tariffa.idtariffa);
                end loop;
                modgui1.selectclose;
                htp.br;

                modgui1.label('Acquirente');
                modgui1.InputText('acquirente', 'acquirente', 0, acquirente);
                htp.br;
 
                modgui1.inputsubmit('Aggiungi');
            modgui1.ChiudiForm;
        modgui1.ChiudiDiv;
    modgui1.ChiudiDiv;
    htp.bodyClose;
    htp.htmlClose;

end InserisciPagamentoCampiEstivi;

procedure ConfermaPagamentoCampiEstivi(
    dataPagamento in varchar2 default NULL,
    tariffa in PAGAMENTICAMPIESTIVI.Tariffa%type default 0, 
    acquirente in PAGAMENTICAMPIESTIVI.Aquirente%type default 0
) is 
    idSessione number(5) := modgui1.get_id_sessione();
    dataPagamento_date Date; := TO_DATE(dataPagamento default NULL on conversion error, 'YYYY-MM-DD');
    newIdPagamento PAGAMENTICAMPIESTIVI.IdPagamento%type;
begin
    if tariffa = 0
    or dataPagamento is null
    or acquirente = 0
    then
        modgui1.apripagina('Pagina errore', 0);
        htp.bodyopen;
        modgui1.apridiv;
        htp.print('Uno dei parametri immessi non valido');
        modgui1.chiudidiv;
        htp.bodyclose;
        htp.htmlclose;
    else
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
                modgui1.label('Data pagamento:');
                htp.print(dataPagamento);
                htp.br;
                modgui1.label('Tariffa:');
                htp.print(tariffa);
                htp.br;
                modgui1.label('Acquirente:');
                htp.print(acquirente);
                htp.br;
            modgui1.chiudidiv;

            mogui1.apriform(operazioniGruppo4.gr4||'ControllaPagamentoCampiEstivi');
            htp.formhidden('dataPagamento', dataPagamento);
            htp.formhidden('tariffa', tariffa);
            htp.formhidden('acquirente', acquirente);
            modgui1.inputsubmit('Conferma');
            modgui1.chiudiform;
            modgui1.apriform(operazioniGruppo4.gr4||'InserisciPagamentoCampiEstivi');
            htp.formhidden('dataPagamento', dataPagamento);
            htp.formhidden('tariffa', tariffa);
            htp.formhidden('acquirente', acquirente);
            modgui1.inputsubmit('Annulla');
            modgui1.chiudiform;
        modgui1.chiudidiv;
    end if;
    exception when others then
        dbms_output.put_line('Error: '||sqlerrm);
end ConfermaPagamentoCampiEstivi;
        
procedure ControllaPagamentoCampiEstivi(
    dataPagamento in PAGAMENTICAMPIESTIVI.DataPagamento%type, 
    tariffa in PAGAMENTICAMPIESTIVI.Tariffa%type, 
    acquirente in PAGAMENTICAMPIESTIVI.Acquirente%type
) is 
    idSessione number(5) := modgui1.get_id_sessione();
    dataPagamento_date date := TO_DATE(dataPagamento, 'YYYY-MM-DD');
    type errorsTable is table of varchar2(32);
    errors errorsTable;
    errorsCount integer := 0;
begin
    insert into PAGAMENTICAMPIESTIVI(IdPagamento, DataPagamento, Tariffa, Acquirente)
        values (IdPagamentoSeq.nextval, dataPagamento_date, tariffa, acquirente);
    if sql%found then
        commit;
        modgui1.redirectesito('Inserimento andato a buon fine', null,
        'Inserisci un nuovo pagamento',operazioniGruppo4.gr4||'InserisciPagamentoCampiEstivi', null,
        'Torna ai campi estivi',operazioniGruppo4.gr4||operazioniGruppo4.menu_ce, null);
    end if;
    exception when others then
        modgui1.redirectesito('Inserimento non riuscito', null,
        'Riprova',operazioniGruppo4.gr4||'InserisciPagamentoCampiEstivi',null,
        'Torna ai campi estivi',operazioniGruppo4.gr4||operazioniGruppo4.menu_ce,null);
end ControllaPagamentoCampiEstivi;

procedure VisualizzaPagamentoCampiEstivi(
    idPagamento in PAGAMENTICAMPIESTIVI.IdPagamento%type
) is
    idSessione number(5) := modgui1.get_id_sessione();
    found NUMBER(10) := 0;
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
    from PAGAMENTICAMPIESTIVI
    where PAGAMENTICAMPIESTIVI.IdPagamento = idPagamento 
        and PAGAMENTICAMPIESTIVI.eliminato = 0;

    htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
    if found > 0 then
        modgui1.apridiv('class="w3-center"');
            htp.tableopen;
            for pagamento in (
                select DataPagamento, Tariffa, Acquirente 
                from PAGAMENTICAMPIESTIVI
                where PAGAMENTICAMPIESTIVI.IdPagamento = idPagamento and e;
            )
            loop
            htp.tablerowopen;
            htp.tabledata(pagamento.DataPagamento);
            htp.tabledata(pagamento.Tariffa);
            htp.tabledata(pagamento.Acquirente);
            htp.tablerowclose;
            end loop
            htp.tableclose;
        modgui1.chiudidiv;
    else
        modgui1.ApriPagina('Pagamento non trovato');
        htp.prn('Pagamento non trovato');
    end if;

    htp.bodyclose;
    htp.htmlclose;
  
end;

procedure CancellaPagamentoCampiEstivi(
    idPagamento in PAGAMENTICAMPIESTIVI.IdPagamento%type
) is 
begin
  
end;

procedure MonitoraggioPeriodoPagamentoCampiEstivi(
    dataInizio in PAGAMENTICAMPIESTIVI.DataPagamento%type default NULL,
    dataFine in PAGAMENTICAMPIESTIVI.DataPagamento%type default NULL
) is 
begin
    htp.htmlopen;
    modgui1.ApriPagina();
    modgui1.Header();
    htp.bodyopen;
    htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
    modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');

    htp.tableopen;
    for pagamento in (
        select IdPagamento, DataPagamento, Tariffa, Acquirente 
        from PAGAMENTICAMPIESTIVI
        where PAGAMENTICAMPIESTIVI.DataPagamento <= dataFine and PAGAMENTICAMPIESTIVI.DataPagamento >= dataInizio;
    )
    loop
        htp.tablerowopen;
        htp.tabledata(pagamento.IdPagamento);
        htp.tabledata(pagamento.DataPagamento);
        htp.tabledata(pagamento.Tariffa);
        htp.tabledata(pagamento.Acquirente);
        htp.tablerowclose;
    end loop;

    modgui1.chiudidiv;
    htp.tableclose;
    htp.bodyclose;
    htp.htmlclose;
  
end;

procedure MonitoraggioPagamentiTariffaPagamentoCampiEstivi(
    tariffa in PAGAMENTICAMPIESTIVI.Tariffa%type default 0
) is 
    pagamentiTariffa number;
begin
    htp.htmlopen;
    modgui1.ApriPagina();
    modgui1.Header();
    htp.bodyopen;
    htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
    modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
  
    select count(IdPagamento) into pagamentiTariffa
    from PAGAMENTICAMPIESTIVI
    where  PAGAMENTICAMPIESTIVI.Tariffa = tariffa;

    htp.prn(pagamentiTariffa);
    modgui1.chiudidiv;
    
    htp.bodyclose;
    htp.htmlclose;
  
end;