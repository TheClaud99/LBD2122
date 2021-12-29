create or replace package operazioniGruppo4 as

gr2 CONSTANT VARCHAR2(25) := 'gruppo2.';
gr4 CONSTANT VARCHAR2(25) := 'operazioniGruppo4.';
menu_m CONSTANT VARCHAR2(25) := 'menumusei';
menu_ce CONSTANT VARCHAR2(25) := 'menucampiestivi';

/*OPERAZIONI CAMPIESTIVI*/
procedure menucampiestivi;
procedure menumusei;
procedure menutariffe
(
   idCampo IN number default 0
);
procedure inseriscicampiestivi
(
   newNome in CAMPIESTIVI.Nome%TYPE default null,
   newMuseo in Musei.Nome%TYPE,
   newDatainizio in VARCHAR2 default null,
   newDataConclusione in VARCHAR2 default null
);
procedure confermacampiestivi
(
   newNome in CAMPIESTIVI.Nome%TYPE default null,
   newMuseo in Musei.Nome%TYPE, 
   newDatainizio in VARCHAR2 default null,
   newDataConclusione in VARCHAR2 default null
);
procedure controllacampiestivi
(
   newNome in CAMPIESTIVI.Nome%TYPE default null,
   newMuseo in Musei.Nome%TYPE,
   newDatainizio in VARCHAR2 default null,
   newDataConclusione in VARCHAR2 default null
);
procedure modificacampiestivi
(
   idcampo in CAMPIESTIVI.IDCAMPIESTIVI%TYPE default null, 
   newNome in CAMPIESTIVI.Nome%TYPE default null,
   newDatainizio in VARCHAR2 default null,
   newDataConclusione in VARCHAR2 default null
);
procedure confermamodificacampo
(
   idcampo in CAMPIESTIVI.IDCAMPIESTIVI%TYPE default null,
   newNome in CAMPIESTIVI.Nome%TYPE default null,
   newDatainizio in VARCHAR2 default null,
   newDataConclusione in VARCHAR2 default null
);
procedure updatecampi
(
   idcampo in CAMPIESTIVI.IDCAMPIESTIVI%TYPE default null,
   newNome in CAMPIESTIVI.Nome%TYPE default null,
   newDatainizio in VARCHAR2 default null,
   newDataConclusione in VARCHAR2 default null
);
procedure eliminacampo
(
   idcampo in CAMPIESTIVI.IDCAMPIESTIVI%TYPE 
);
procedure rimuovicampo
(
   idcampo in CAMPIESTIVI.IDCAMPIESTIVI%TYPE 
);
procedure visualizzacampiestivi
(
   campiestiviId IN  CAMPIESTIVI.IdCampiEstivi%TYPE
);
/*OPERAZIONI MUSEO*/
procedure inseriscimuseo
( 
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
);
procedure confermamusei
(
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
);
procedure controllamusei
(
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
);
procedure visualizzamusei
(
   MuseoId IN MUSEI.IdMuseo%TYPE
);
procedure modificamusei 
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
);
procedure confermamodificamuseo
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
);
procedure updatemusei
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
);
/*STATISTICHE MUSEO*/
procedure controllastatistica
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   scelta in number
);
procedure controllastatistica2
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   scelta in number,
   Data1 varchar2,
   Data2 varchar2
);
procedure form1monitoraggio
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   NameMuseo IN MUSEI.NOME%TYPE
);
procedure form2monitoraggio
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   NameMuseo IN MUSEI.NOME%TYPE,
   Data1 VARCHAR2,
   Data2 VARCHAR2
);


procedure salepresenti
(
   MuseoId IN  Musei.IdMuseo%TYPE
);
procedure operepresentimuseo
(
   MuseoId IN  Musei.IdMuseo%TYPE
);
procedure opereprestate
(
   MuseoId IN Musei.IdMuseo%TYPE
);
procedure introitimuseo
(
   MuseoId IN Musei.IdMuseo%TYPE
);
procedure visitatoriunici
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   Data1 VARCHAR2,
   Data2 VARCHAR2
);
procedure visitatorimedi 
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   Data1 VARCHAR2,
   Data2 VARCHAR2
);

/*---------statistiche CAMPI ESTIVI-----------*/
procedure form1campiestivi
(
   CampoestivoId IN CAMPIESTIVI.IDCAMPIESTIVI%TYPE,
   NameCampoestivo IN CAMPIESTIVI.NOME%TYPE
);
procedure controllastatisticacampo
(
   CampoestivoId IN CAMPIESTIVI.IDCAMPIESTIVI%TYPE,
   scelta in number
);
procedure utentiiscritti
(
   CampoestivoId IN CAMPIESTIVI.IDCAMPIESTIVI%TYPE
);
procedure tariffecampi
(
   CampoestivoId IN CAMPIESTIVI.IDCAMPIESTIVI%TYPE
);
procedure etamediatariffe
(
   CampoestivoId IN CAMPIESTIVI.IDCAMPIESTIVI%TYPE
);
procedure introiticampi
(
   CampoestivoId in CAMPIESTIVI.IDCAMPIESTIVI%TYPE
);

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

procedure CancellaPagamentoCampiEstivi(
    idPagamento in PAGAMENTICAMPIESTIVI.IdPagamento%type
);

procedure MonitoraggioPeriodoPagamentoCampiEstivi(
    dataInizio in PAGAMENTICAMPIESTIVI.DataPagamento%type default NULL,
    dataFine in PAGAMENTICAMPIESTIVI.DataPagamento%type default NULL
);

procedure PagamentoCampiEstivi(
    idtariffa in PAGAMENTICAMPIESTIVI.Tariffa%type default 0
);
/*tariffe campi estivi*/
procedure InserisciTariffeCampiEstivi
(
    prezzo in TARIFFECAMPIESTIVI.Prezzo%type default 0,
    etaMinima in TARIFFECAMPIESTIVI.Etaminima%type default 0,
    etaMassima in TARIFFECAMPIESTIVI.Etamassima%type default 0,
    campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type default 0
);

procedure ConfermaTariffeCampiEstivi
(
    prezzo in TARIFFECAMPIESTIVI.Prezzo%type default 0,
    etaMinima in TARIFFECAMPIESTIVI.Etaminima%type default 0,
    etaMassima in TARIFFECAMPIESTIVI.Etamassima%type default 0,
    campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type default 0
);

procedure ControllaTariffeCampiEstivi
(
    prezzo in TARIFFECAMPIESTIVI.Prezzo%type default 0,
    etaMinima in TARIFFECAMPIESTIVI.Etaminima%type default 0,
    etaMassima in TARIFFECAMPIESTIVI.Etamassima%type default 0,
    campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type default 0
);

procedure VisualizzaTariffeCampiEstivi
(
    Tariffa in TARIFFECAMPIESTIVI.IdTariffa%type
);
procedure form1tariffe
(
   campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type,
   Data1 in varchar2,
   Data2 in VARCHAR2
);
procedure preferenzaTariffa
(
   campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type
);

procedure monitoratariffeAnno
(
   campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type,
   Data1 in varchar2,
   Data2 in varchar2
);

procedure MonitoraTariffeCampiEstivi_tariffeCampo
(
    campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type
);
procedure Utentipagamenti
(
   pagamentoid in PagamentiCampiEstivi.idpagamento%type
);

end operazioniGruppo4;