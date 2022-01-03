create or replace package operazioniGruppo4 as

gr2 CONSTANT VARCHAR2(25) := 'gruppo2.';
gr4 CONSTANT VARCHAR2(25) := 'operazioniGruppo4.';
packstanze  CONSTANT VARCHAR2(25) :='PackageStanze.';
menu_m CONSTANT VARCHAR2(25) := 'menumusei';
menu_ce CONSTANT VARCHAR2(25) := 'menucampiestivi';
menu_t CONSTANT VARCHAR2(25):='menutariffe';

/*OPERAZIONI CAMPIESTIVI*/
/*visualizza tutti i campi estivi*/
procedure menucampiestivi
(
   searchmuseo In MUSEI.IDMUSEO%TYPE default NULL
);
/*visualizza tutti i musei*/
procedure menumusei;
/*Visualizza le tariffe del campo estivo specificato*/
procedure menutariffe
(
   idCampo IN number default 0,
   ordine IN number default 0
);
/*form che permette di inserire un nuovo campo estivo*/
procedure inseriscicampiestivi
(
   newNome in CAMPIESTIVI.Nome%TYPE default null,
   newMuseo in Musei.Nome%TYPE,
   newDatainizio in VARCHAR2 default null,
   newDataConclusione in VARCHAR2 default null
);
/*conferma inserimento campo estivo*/
procedure confermacampiestivi
(
   newNome in CAMPIESTIVI.Nome%TYPE default null,
   newMuseo in Musei.Nome%TYPE, 
   newDatainizio in VARCHAR2 default null,
   newDataConclusione in VARCHAR2 default null
);
/*inserimento campo estivo*/
procedure controllacampiestivi
(
   newNome in CAMPIESTIVI.Nome%TYPE default null,
   newMuseo in Musei.Nome%TYPE,
   newDatainizio in VARCHAR2 default null,
   newDataConclusione in VARCHAR2 default null
);
/*form per la modifica del campo estivo specificato*/
procedure modificacampiestivi
(
   idcampo in CAMPIESTIVI.IDCAMPIESTIVI%TYPE default null, 
   newNome in CAMPIESTIVI.Nome%TYPE default null,
   newDatainizio in VARCHAR2 default null,
   newDataConclusione in VARCHAR2 default null
);
/*conferma della modifica*/
procedure confermamodificacampo
(
   idcampo in CAMPIESTIVI.IDCAMPIESTIVI%TYPE default null,
   newNome in CAMPIESTIVI.Nome%TYPE default null,
   newDatainizio in VARCHAR2 default null,
   newDataConclusione in VARCHAR2 default null
);
/*modifica del campo con i nuovi dati*/
procedure updatecampi
(
   idcampo in CAMPIESTIVI.IDCAMPIESTIVI%TYPE default null,
   newNome in CAMPIESTIVI.Nome%TYPE default null,
   newDatainizio in VARCHAR2 default null,
   newDataConclusione in VARCHAR2 default null
);
/*conferma di eliminazione*/
procedure eliminacampo
(
   idcampo in CAMPIESTIVI.IDCAMPIESTIVI%TYPE 
);
/*elimina il campo estivo settando ELIMINATO=1*/
procedure rimuovicampo
(
   idcampo in CAMPIESTIVI.IDCAMPIESTIVI%TYPE 
);
/*visualizza la scheda del singolo campo estivo*/
procedure visualizzacampiestivi
(
   campiestiviId IN  CAMPIESTIVI.IdCampiEstivi%TYPE
);
/*OPERAZIONI MUSEO*/

/*form che permette di inserire un nuovo museo*/
procedure inseriscimuseo
( 
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
);
/*procedura che chiede la conferma di inserimento del museo*/
procedure confermamusei
(
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
);
/*inserimento del nuovo museo*/
procedure controllamusei
(
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
);
/*visualizza la scheda del singolo museo*/
procedure visualizzamusei
(
   MuseoId IN MUSEI.IdMuseo%TYPE
);
/*form per la modifica del singolo museo specificato*/
procedure modificamusei 
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
);
/*conferma della modifica*/
procedure confermamodificamuseo
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
);
/*modifica del museo con i nuovi dati*/
procedure updatemusei
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
);
/*STATISTICHE MUSEO*/

/*procedura che manda in esecuzione l'operazione specificata*/
procedure controllastatistica
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   scelta in number
);
/*procedura che manda in esecuzione l'operazione specificata*/
procedure controllastatistica2
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   scelta in number,
   Data1 varchar2,
   Data2 varchar2
);
/*form per la scelta della statistica*/
procedure form1monitoraggio
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   NameMuseo IN MUSEI.NOME%TYPE
);
/*form per la scelta della statistica sui visitatori*/
procedure form2monitoraggio
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   NameMuseo IN MUSEI.NOME%TYPE,
   Data1 VARCHAR2,
   Data2 VARCHAR2
);
/*procedura che restituisce le sale presenti in un museo*/
procedure salepresenti
(
   MuseoId IN  Musei.IdMuseo%TYPE
);
/*procedura che restituisce le opere presenti in un museo*/
procedure operepresentimuseo
(
   MuseoId IN  Musei.IdMuseo%TYPE
);
/*procedura che restituisce le opere in prestito nel museo*/
procedure opereprestate
(
   MuseoId IN Musei.IdMuseo%TYPE
);
/*restituisce gli introti del museo*/
procedure introitimuseo
(
   MuseoId IN Musei.IdMuseo%TYPE
);
/*restituisce il numero dei visitatori del museo  in un certo periodo*/
procedure visitatoriunici
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   Data1 VARCHAR2,
   Data2 VARCHAR2
);
/*restituisce il numero di visitatoti medi in un certo periodo*/
procedure visitatorimedi 
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   Data1 VARCHAR2,
   Data2 VARCHAR2
);

/*---------statistiche CAMPI ESTIVI-----------*/

/*form per le statistiche sui campi estivi*/
procedure form1campiestivi
(
   CampoestivoId IN CAMPIESTIVI.IDCAMPIESTIVI%TYPE,
   NameCampoestivo IN CAMPIESTIVI.NOME%TYPE
);
/*procedura che manda in esecuzione l'operazione specificata*/
procedure controllastatisticacampo
(
   CampoestivoId IN CAMPIESTIVI.IDCAMPIESTIVI%TYPE,
   scelta in number
);
/*restituisce il numero degli utenti iscritti a quel campo estivo*/
procedure utentiiscritti
(
   CampoestivoId IN CAMPIESTIVI.IDCAMPIESTIVI%TYPE
);
/*restituisce le tariffe riferite al campo estivo specificato*/
procedure tariffecampi
(
   CampoestivoId IN CAMPIESTIVI.IDCAMPIESTIVI%TYPE
);
/*restitusice l'età media dei visitatori del campo estivo*/
procedure etamediatariffe
(
   CampoestivoId IN CAMPIESTIVI.IDCAMPIESTIVI%TYPE
);
/* restituisce gli introti del campo estivo fino ad ora*/
procedure introiticampi
(
   CampoestivoId in CAMPIESTIVI.IDCAMPIESTIVI%TYPE
);

/*------------PAGAMENTI CAMPI ESTIVI-----------------*/

/*form per l'inserimento di un nuovo pagamento riferito ad una certa tariffa*/
procedure InserisciPagamentoCampiEstivi(
    dataPagamento in varchar2 default NULL,
    tariffa in PAGAMENTICAMPIESTIVI.Tariffa%type default 0, 
    acquirente in PAGAMENTICAMPIESTIVI.Acquirente%type default 0 
);

/*procedura che chiede la conferma di inserimento del museo*/
procedure ConfermaPagamentoCampiEstivi(
    dataPagamento in varchar2 default NULL,
    tariffa in PAGAMENTICAMPIESTIVI.Tariffa%type default 0, 
    acquirente in PAGAMENTICAMPIESTIVI.Acquirente%type default 0
);

/*Procedura che inserisce il nuovo pagamento*/
procedure ControllaPagamentoCampiEstivi(
    dataPagamento in varchar2 default NULL,
    tariffa in PAGAMENTICAMPIESTIVI.Tariffa%type, 
    acquirente in PAGAMENTICAMPIESTIVI.Acquirente%type
);

/*Restituice tutti i pagamenti riferiti ad una certa tariffa*/
procedure PagamentoCampiEstivi
(
   tariffaid in PAGAMENTICAMPIESTIVI.Tariffa%type default 0
);

/*TARIFFE CAMPI ESTIVI*/

/*form per l'inserimento di una nuova tariffa riferita ad una certo campo estivo*/
procedure InserisciTariffeCampiEstivi
(
    prezzo in TARIFFECAMPIESTIVI.Prezzo%type default 0,
    etaMinima in TARIFFECAMPIESTIVI.Etaminima%type default 0,
    etaMassima in TARIFFECAMPIESTIVI.Etamassima%type default 0,
    campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type default 0
);

/*procedura che chiede la conferma di inserimento della tariffa*/
procedure ConfermaTariffeCampiEstivi
(
    prezzo in TARIFFECAMPIESTIVI.Prezzo%type default 0,
    etaMinima in TARIFFECAMPIESTIVI.Etaminima%type default 0,
    etaMassima in TARIFFECAMPIESTIVI.Etamassima%type default 0,
    campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type default 0
);

/*procedura che inserisce la  tariffa*/
procedure ControllaTariffeCampiEstivi
(
    prezzo in TARIFFECAMPIESTIVI.Prezzo%type default 0,
    etaMinima in TARIFFECAMPIESTIVI.Etaminima%type default 0,
    etaMassima in TARIFFECAMPIESTIVI.Etamassima%type default 0,
    campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type default 0
);

/*Procedura che mostra le informazioni relative ad una tariffa*/
procedure VisualizzaTariffeCampiEstivi
(
   Tariffa in TARIFFECAMPIESTIVI.IdTariffa%type
);

/*form per la modifica della tariffa specificata*/
procedure ModificaTariffeCampiEstivi
(
    up_idTariffa in TARIFFECAMPIESTIVI.IdTariffa%type
);

/*richiesta la conferma per l'eliminazione della tariffa*/
procedure eliminatariffa
(
   Tariffaid in TARIFFECAMPIESTIVI.IdTariffa%type
);

/*rimuove la tariffa settando ELIMINATO=1*/
procedure rimuovitariffa
(
   Tariffaid in TARIFFECAMPIESTIVI.IdTariffa%type
);

/*aggiorna le informazioni della tariffa*/
procedure AggiornaTariffeCampiEstivi
(
    up_idTariffa number default 0, 
    up_prezzo in TARIFFECAMPIESTIVI.Prezzo%type default 0,
    up_etaMinima in TARIFFECAMPIESTIVI.Etaminima%type default 0,
    up_etaMassima in TARIFFECAMPIESTIVI.Etamassima%type default 0,
    up_campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type default 0
);

/*form per richiedere lo storico dei pagamenti di un campo estivo per un certo periodo*/
procedure form1tariffe
(
   campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type,
   Data1 in varchar2,
   Data2 in VARCHAR2
);
/*tariffa più acquistata  per un certo campo estivo*/
procedure preferenzaTariffa
(
   campoid in TARIFFECAMPIESTIVI.CampoEstivo%type
);

/*storico pagamenti*/
procedure monitoratariffeAnno
(
   campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type,
   Data1 in varchar2,
   Data2 in varchar2
);
/*utenti coinvolti nel pagamento di una tariffa*/
procedure Utentipagamenti
(
   pagamentoid in PagamentiCampiEstivi.idpagamento%type
);

end operazioniGruppo4;