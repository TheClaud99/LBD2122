create or replace package PagamentiCampiEstiviPkg as

procedure InserisciPagamentoCampiEstivi(
    dataPagamento in varchar2 default NULL,
    tariffa in PAGAMENTICAMPIESTIVI.Tariffa%type default 0, 
    acquirente in PAGAMENTICAMPIESTIVI.Acquirente%type default 0 
);

procedure ConfermaPagamentoCampiEstivi(
    dataPagamento in varchar2 default NULL,
    tariffa in PAGAMENTICAMPIESTIVI.Tariffa%type default 0, 
    acquirente in PAGAMENTICAMPIESTIVI.Acquirente%type default 0
);

procedure ControllaPagamentoCampiEstivi(
    dataPagamento in PAGAMENTICAMPIESTIVI.DataPagamento%type, 
    tariffa in PAGAMENTICAMPIESTIVI.Tariffa%type, 
    acquirente in PAGAMENTICAMPIESTIVI.Acquirente%type
);

procedure VisualizzaPagamentoCampiEstivi(
    idPagamento in PAGAMENTICAMPIESTIVI.IdPagamento%type
);

procedure MonitoraggioPeriodoPagamentoCampiEstivi(
    dataInizio in PAGAMENTICAMPIESTIVI.DataPagamento%type default NULL,
    dataFine in PAGAMENTICAMPIESTIVI.DataPagamento%type default NULL
);

procedure MonitoraggioPagamentiTariffaPagamentoCampiEstivi(
    tariffa in PAGAMENTICAMPIESTIVI.Tariffa%type default 0
);

END;