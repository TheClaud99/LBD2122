DROP TABLE VISITEVARCHI;
DROP TABLE VISITE;
DROP TABLE VARCHI;
DROP TABLE ABBONAMENTI;
DROP TABLE BIGLIETTI;
DROP TABLE TITOLIINGRESSO;
DROP TABLE TIPOLOGIEINGRESSOMUSEI;
DROP TABLE TIPOLOGIEINGRESSO;
DROP TABLE NEWSLETTERUTENTI;
DROP TABLE NEWSLETTER;
DROP TABLE TUTORI;
DROP TABLE UTENTIPAGAMENTI;
DROP TABLE PAGAMENTICAMPIESTIVI;
DROP TABLE UTENTIMUSEO;
DROP TABLE UTENTICAMPIESTIVI;
DROP TABLE UTENTI;
DROP TABLE TARIFFECAMPIESTIVI;
DROP TABLE CAMPIESTIVI;
DROP TABLE DESCRIZIONI;
DROP TABLE AUTORIOPERE;
DROP TABLE AUTORI;
DROP TABLE SALEOPERE;
DROP TABLE AMBIENTIDISERVIZIO;
DROP TABLE SALE;
DROP TABLE STANZE;
DROP TABLE OPERE;
DROP TABLE MUSEI;



/*DROP SEQUENCE*/
DROP SEQUENCE IdMuseoSeq;
DROP SEQUENCE IdOperaSeq;
DROP SEQUENCE IdStanzaSeq;
DROP SEQUENCE IdMovimentoSeq;
DROP SEQUENCE IdAutoreSeq;
DROP SEQUENCE IdDescSeq;
DROP SEQUENCE IdCampiEstiviSeq;
DROP SEQUENCE IdTariffaSeq;
DROP SEQUENCE IdUtenteSeq;
DROP SEQUENCE IdPagamentoSeq;
DROP SEQUENCE IdNewsSeq;
DROP SEQUENCE IdTipologiaingSeq;
DROP SEQUENCE IdTitoloingSeq;
DROP SEQUENCE IdVarchiSeq;
DROP SEQUENCE IdVisiteSeq;

Create Table MUSEI
(
   IdMuseo number(5) primary key,
   Nome varchar2(40) not null,
   Indirizzo varchar2(40) not null
);

Create Table OPERE
(
   IdOpera number(5) primary key,
   Titolo varchar2(15) not null,
   Anno date not null,
   FinePeriodo date not null,/*aggiunto*/
   Museo number(5) not null REFERENCES MUSEI(IdMuseo)
);

Create Table STANZE
(
   IdStanza number(5) primary key,
   Nome varchar2(20) not null,
   Dimensione number(6,0) not null,
   Museo number(5) not null REFERENCES MUSEI(IdMuseo)
);

Create Table SALE
(
   IdStanza number(5) primary key REFERENCES STANZE(IdStanza),
   TipoSala number(1) not null check(TipoSala IN(0,1)),
   NumOpere number(6,0) not null

);

Create Table AMBIENTIDISERVIZIO
(
   IdStanza number(5) primary key REFERENCES STANZE(IdStanza),
   TipoAmbiente varchar2(25) not null

);

Create Table SALEOPERE
(
   IdMovimento number(5) primary key,
   Sala number(5) not null REFERENCES SALE(IdStanza),
   Opera number(5) not null REFERENCES OPERE(IdOpera),
   DataArrivo date not null,
   DataUscita date 
);

Create Table AUTORI
(
   IdAutore number(5) primary key,
   Nome varchar2(25) not null,
   Cognome varchar2(25) not null,
   Datanascita DATE,
   Datamorte DATE,
   Nazionalità varchar2(25) not null
);

Create Table AUTORIOPERE
(
   IdAutore number(5) not null REFERENCES AUTORI(IdAutore),
   IdOpera  number(5) not null REFERENCES OPERE(IdOpera),
   Primary key(IdAutore,IdOpera)
);

Create Table DESCRIZIONI
(
   IdDesc number(5) primary key,
   Lingua varchar2(25) not null,
   Livello varchar2(25) not null check(Livello in('bambino','adulto','esperto')), /*aggiunto*/
   Testo CLOB not null,
   Opera  number(5)  not null REFERENCES Opere(IdOpera)
);

Create Table CAMPIESTIVI
(
   IdCampiEstivi number(5) primary key,
   Stato varchar2(25) not null check(Stato in('increazione','sospeso','incorso','terminato')),/*aggiunto*/
   Nome varchar2(25) not null,
   DataInizio DATE not null,
   DataConclusione DATE not null,
   Museo number(5)  not null REFERENCES MUSEI(IdMuseo)
);

Create Table TARIFFECAMPIESTIVI
(
   IdTariffa number(5) primary key,
   Prezzo number(5,2) not null,
   -- al posto di fascia di età
   Etaminima number(3) not null,
   Etamassima number(3) not null,
   CampoEstivo number(5) not null REFERENCES CAMPIESTIVI(IdCampiEstivi)
);

Create Table UTENTI
(
   IdUtente number(5) primary key,
   Nome varchar2(25) not null,
   Cognome varchar2(25) not null,
   DataNascita DATE not null,
   Indirizzo varchar2(50) not null,
   Email varchar2(50) not null,
   RecapitoTelefonico varchar2(18)
);

Create Table UTENTIMUSEO
(
   IdUtente number(5) primary key REFERENCES UTENTI(IdUtente),
   Donatore number(1) not null check(Donatore IN(0,1))
);

Create Table UTENTICAMPIESTIVI
(
   IdUtente number(5) primary key REFERENCES UTENTI(IdUtente),
   -- FasciaEta varchar2(25) not null
   Etaminima number(3) not null, /*cambio di nome*/
   Etamassima number(3) not null /*cambio di nome*/
);

Create Table PAGAMENTICAMPIESTIVI
(
   IdPagamento number(5) primary key,
   DataPagamento DATE not null,
   Tariffa  number(5) not null REFERENCES TARIFFECAMPIESTIVI(IdTariffa),
   Acquirente  number(5) not null REFERENCES UTENTICAMPIESTIVI(IdUtente)

);

Create Table UTENTIPAGAMENTI
(
   IdUtente number(5) not null REFERENCES UTENTI(IdUtente),
   IdPagamento number(5)  not null REFERENCES PAGAMENTICAMPIESTIVI(IdPagamento),
   Primary key(IdUtente,IdPagamento)
);

Create Table TUTORI
(
   IdTutore number(5) not null REFERENCES UTENTI(IdUtente),
   IdTutelato number(5) not null REFERENCES UTENTI(IdUtente),
   Primary key(IdTutore,IdTutelato)
);

Create Table NEWSLETTER
(
   IdNews  number(5) primary key,
   Nome varchar2(25) not null
);

Create Table NEWSLETTERUTENTI
(
   IdNews number(5) not null REFERENCES NEWSLETTER(IdNews),
   IdUtente number(5) not null REFERENCES  UTENTI(IdUtente),
   Primary key(IdNews,IdUtente)
);

Create Table TIPOLOGIEINGRESSO
(
   IdTipologiaIng number(5) primary key,
   Costototale number(5,2) not null,
   LimiteSala number(3),	/*da modellare*/
   LimiteTempo number(3),	/*LimiteTempo e LimiteSale non entrambe null nello stesso record*/
   Durata VARCHAR2(25) not null /*aggiunto*/
);

Create Table TITOLIINGRESSO
(
   IdTitoloing number(5) primary key,
   DataEmissione DATE not null,
   OraEmissione DATE not null,
   DataScadenza DATE not null,
   Acquirente number(5) not null REFERENCES UTENTI(IdUtente), /*cambio nome da visitatore ad acquirente */
   Tipologia number(5) not null REFERENCES TIPOLOGIEINGRESSO(IdTipologiaIng),
   Museo number(5) not null REFERENCES Musei(IdMuseo)
);
/*Aggiunta tabella per il collegamento molti a molti tra tipologieingresso e musei*/
Create Table TIPOLOGIEINGRESSOMUSEI
(
   IdTipologiaIng number(5) not null REFERENCES TIPOLOGIEINGRESSO(IDTIPOLOGIAING),
   IdMuseo number(5) not null REFERENCES MUSEI(IDMUSEO),
   Primary key(IdTipologiaIng,IdMuseo)
);
Create Table BIGLIETTI
(  
  IdTipologiaIng number(5) primary key REFERENCES TIPOLOGIEINGRESSO(IdTipologiaIng),
  Nome varchar(25) not null
);

Create Table ABBONAMENTI
(
   IdTipologiaIng number(5) primary key REFERENCES TIPOLOGIEINGRESSO(IdTipologiaIng),
   Multiplo number(1) not null check(Multiplo IN(0,1))
);

Create Table VARCHI
(
   IdVarchi number(5) primary key,
   Nome varchar2(25) not null,
   Sensore number(7) not null,
   Stanza1 number(5) not null REFERENCES STANZE(IdStanza),
   Stanza2 number(5) not null REFERENCES STANZE(IdStanza)

);

Create Table VISITE
(
   IdVisita number(5) primary key,   
   OraVisita timestamp not null,
   DataVisita DATE not null,
   DurataVisita number(6) not null,
   Visitatore number(5) not null REFERENCES UTENTIMUSEO(IdUtente),
   TitoloIngresso number(5) not null REFERENCES TITOLIINGRESSO(IdTitoloIng) 
);

Create Table VISITEVARCHI
(
   IdVisita number(5) not null REFERENCES VISITE(IdVisita),
   IdVarco number(5) not null REFERENCES VARCHI(IdVarchi),
   OraAttraversamentoVarco  timestamp not null,
   Primary key(IdVisita,IdVarco)
);

/*--------*/
/*SEQUENCE*/
/*--------*/


/*MUSEI*/
create sequence IdMuseoSeq
start with 1
increment by 1
maxvalue 99999
cycle;

/*OPERE*/
create sequence IdOperaSeq
start with 1
increment by 1
maxvalue 99999
cycle;

/*STANZE*/
create sequence IdStanzaSeq
start with 1
increment by 1
maxvalue 99999
cycle;

/*SALEOPERE*/
create sequence IdMovimentoSeq
start with 1
increment by 1
maxvalue 99999
cycle;

/*AUTORI*/
create sequence IdAutoreSeq
start with 1
increment by 1
maxvalue 99999
cycle;

/*DESCRIZIONI*/
create sequence IdDescSeq
start with 1
increment by 1
maxvalue 99999
cycle;

/*CAMPIESTIVI*/
create sequence IdCampiEstiviSeq
start with 1
increment by 1
maxvalue 99999
cycle;

/*TARIFFECAMPIESTIVI*/
create sequence IdTariffaSeq
start with 1
increment by 1
maxvalue 99999
cycle;

/*UTENTI*/
create sequence IdUtenteSeq
start with 1
increment by 1
maxvalue 99999
cycle;


/*PAGAMENTICAMPIESTIVI*/
create sequence IdPagamentoSeq
start with 1
increment by 1
maxvalue 99999
cycle;


/*NEWSLETTER*/
create sequence IdNewsSeq
start with 1
increment by 1
maxvalue 99999
cycle;

/*TIPOLOGIEINGRESSO*/
create sequence IdTipologiaingSeq
start with 1
increment by 1
maxvalue 99999
cycle;

/*TITOLIINGRESSO*/
create sequence IdTitoloingSeq
start with 1
increment by 1
maxvalue 99999
cycle;


/*VARCHI*/
create sequence IdVarchiSeq
start with 1
increment by 1
maxvalue 99999
cycle;

/*VISITE*/
create sequence IdVisiteSeq
start with 1
increment by 1
maxvalue 99999
cycle;

