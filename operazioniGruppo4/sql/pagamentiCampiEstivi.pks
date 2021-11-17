create or replace package PagamentiCampiEstivi as

procedure InserisciPagamentoCampiEstivi(
    sessionID number default 0,
    dataPagamento in varchar2 default NULL,
    tariffa in PAGAMENTICAMPIESTIVI.Tariffa%type default 0, 
    acquirente in PAGAMENTICAMPIESTIVI.Aquirente%type default 0 
);

procedure ConfermaPagamentoCampiEstivi(
    sessionID number default 0,
    dataPagamento in varchar2 default NULL,
    tariffa in PAGAMENTICAMPIESTIVI.Tariffa%type default 0, 
    acquirente in PAGAMENTICAMPIESTIVI.Aquirente%type default 0
);

procedure ControllaPagamentoCampiEstivi(
    sessionID number default 0, 
    dataPagamento in PAGAMENTICAMPIESTIVI.DataPagamento%type, 
    tariffa in PAGAMENTICAMPIESTIVI.Tariffa%type, 
    acquirente in PAGAMENTICAMPIESTIVI.Acquirente%type
);

procedure VisualizzaPagamentoCampiEstivi(
    sessionID number default 0,
    idPagamento in PAGAMENTICAMPIESTIVI.IdPagamento%type
);

procedure CancellaPagamentoCampiEstivi(
    sessionID number default 0,
    idPagamento in PAGAMENTICAMPIESTIVI.IdPagamento%type
);

procedure MonitoraggioPeriodoPagamentoCampiEstivi(
    sessionID number default 0,
    dataInizio in PAGAMENTICAMPIESTIVI.DataPagamento%type default NULL,
    dataFine in PAGAMENTICAMPIESTIVI.DataPagamento%type default NULL
);

procedure MonitoraggioPagamentiTariffaPagamentoCampiEstivi(
    sessionID number default 0,
    tariffa in PAGAMENTICAMPIESTIVI.Tariffa%type default 0
);