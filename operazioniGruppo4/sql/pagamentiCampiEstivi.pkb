procedure InserisciPagamentoCampiEstivi(
    sessionID number default 0,
    dataPagamento in varchar2 default NULL,
    tariffa in PAGAMENTICAMPIESTIVI.Tariffa%type default 0, 
    acquirente in PAGAMENTICAMPIESTIVI.Aquirente%type default 0 
) is
begin
    htp.htmlOpen;
    MODGUI1.ApriPagina('Inserimento pagamento campo estivo', 0);
    
    modgui1.Header();
    htp.bodyOpen;

    htp.header(1, 'Inserisci un nuovo pagamento', 'centered'); /* opzionale */
    modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px; margin-top:110px"');
    
    modgui1.ApriForm('ConfermaPagamentoCampiEstivi', 'invia', 'w3-container');
    htp.FORMHIDDEN('sessionID', 0);

    modgui1.label('Data Pagamento');
    modgui1.InputDate('dataPagamento', 'dataPagamento', 1, dataPagamento);
    htp.br;

    modgui1.label('Tariffa');
    modgui1.InputText('tariffa', 'tariffa', 0, tariffa);
    htp.br;

    modgui1.label('Acquirente');
    modgui1.InputText('acquirente', 'acquirente', 0, acquirente);
    htp.br;

    modgui1.inputsubmit('Invia');

    modgui1.ChiudiForm;
    modgui1.ChiudiDiv;
    htp.bodyClose;
    htp.htmlClose;

end;

procedure ConfermaPagamentoCampiEstivi(
    sessionID number default 0,
    dataPagamento in varchar2 default NULL,
    tariffa in PAGAMENTICAMPIESTIVI.Tariffa%type default 0, 
    acquirente in PAGAMENTICAMPIESTIVI.Aquirente%type default 0
) is 
    dataPagamento_date Date:= TO_DATE(dataPagamento default NULL on conversion error, 'YYYY-MM-DD');
    newIdPagamento PAGAMENTICAMPIESTIVI.IdPagamento%type;
begin
    htp.htmlOpen;
    modgui1.APRIPAGINA('Conferma Pagamento Campi Estivi');
    modgui1.HEADER();
    htp.bodyopen();
    modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
  
end;

procedure ControllaPagamentoCampiEstivi(
    sessionID number default 0, 
    dataPagamento in PAGAMENTICAMPIESTIVI.DataPagamento%type, 
    tariffa in PAGAMENTICAMPIESTIVI.Tariffa%type, 
    acquirente in PAGAMENTICAMPIESTIVI.Acquirente%type
) is 
declare
    type errorsTable is table of varchar2(32);
    errors errorsTable;
    errorsCount integer := 0;
    
begin
    htp.htmlopen;
    modgui1.ApriPagina('Controlla Pagamento Campi Estivi');
    modgui1.Header();
    htp.bodyopen();
    modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
    
    if dataPagamento = NULL then
        errors.extend;
        errorsCount := errorsCount + 1;
        errors(errorsCount) := "dataPagamento"
    elsif tariffa = NULL then
        errors.extend;
        errorsCount := errorsCount + 1;
        errors(errorsCount) := "tariffa"
    elsif Aquirente = NULL then
        errors.extend;
        errorsCount := errorsCount + 1;
        errors(errorsCount) := "acquirente"
    end if;

    if errorsCount > 0 then
        htp.print('<H1 ALIGN=CENTER>');
        modgui1.LABEL('PagamentoCampoEstivo parametri errati');
        htp.print('</H1>');
        for i in 1 .. errorsCount loop
            htp.print('<H1 ALIGN=CENTER>');
            modgui1.LABEL(errors(i));
            htp.print('</H1>');
        end loop;
        htp.print('<H1 ALIGN=CENTER>');
        modgui1.LABEL('PagamentoCampoEstivo non inserito');
        htp.print('</H1>');
    else
        insert into PAGAMENTICAMPIESTIVI(IdPagamento, DataPagamento, Tariffa, Acquirente)
            values (IdPagamentoSeq.nextval, dataPagamento, tariffa, acquirente);
        htp.print('<H1 ALIGN=CENTER>');
        modgui1.LABEL('PagamentoCampoEstivo inserito correttamente');
        htp.print('</H1>');
    end if;
      
end;

procedure VisualizzaPagamentoCampiEstivi(
    sessionID number default 0,
    idPagamento in PAGAMENTICAMPIESTIVI.IdPagamento%type
) is
    found NUMBER(10) := 0;
begin

    htp.htmlopen;
    modgui1.ApriPagina();
    modgui1.Header();
    htp.bodyopen;
    modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');

    select count(*) 
    into found
    from PAGAMENTICAMPIESTIVI
    where PAGAMENTICAMPIESTIVI.IdPagamento = idPagamento;

    if found > 0 then
        htp.tableopen;
        for pagamento in (
            select DataPagamento, Tariffa, Acquirente 
            from PAGAMENTICAMPIESTIVI
            where PAGAMENTICAMPIESTIVI.IdPagamento = idPagamento;
        )
        loop
          htp.tablerowopen;
          htp.tabledata(pagamento.DataPagamento);
          htp.tabledata(pagamento.Tariffa);
          htp.tabledata(pagamento.Acquirente);
          htp.tablerowclose;
        end loop
        htp.tableclose;
    else
        modgui1.ApriPagina('Pagamento non trovato', sessionID);
        htp.prn('Pagamento non trovato');
    end if;

    htp.bodyclose;
    htp.htmlclose;
  
end;

procedure CancellaPagamentoCampiEstivi(
    sessionID number default 0,
    idPagamento in PAGAMENTICAMPIESTIVI.IdPagamento%type
) is 
begin
  
end;

procedure MonitoraggioPeriodoPagamentoCampiEstivi(
    sessionID number default 0,
    dataInizio in PAGAMENTICAMPIESTIVI.DataPagamento%type default NULL,
    dataFine in PAGAMENTICAMPIESTIVI.DataPagamento%type default NULL
) is 
begin
    htp.htmlopen;
    modgui1.ApriPagina();
    modgui1.Header();
    htp.bodyopen;
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
    end loop
    htp.tableclose;
    
    htp.bodyclose;
    htp.htmlclose;
  
end;

procedure MonitoraggioPagamentiTariffaPagamentoCampiEstivi(
    sessionID number default 0,
    tariffa in PAGAMENTICAMPIESTIVI.Tariffa%type default 0
) is 
    pagamentiTariffa number;
begin
    htp.htmlopen;
    modgui1.ApriPagina();
    modgui1.Header();
    htp.bodyopen;
    modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
  
    select count(IdPagamento) into pagamentiTariffa
    from PAGAMENTICAMPIESTIVI
    where  PAGAMENTICAMPIESTIVI.Tariffa = tariffa;

    htp.prn(pagamentiTariffa);
    
    htp.bodyclose;
    htp.htmlclose;
  
end;