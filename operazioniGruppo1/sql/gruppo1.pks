CREATE OR REPLACE PACKAGE gruppo1 AS

root constant VARCHAR2(125) := 'http://131.114.73.203:8080/apex/';
user constant VARCHAR2(25) := 'fgiannotti.gruppo1.';

procedure InserisciUtente(
	nome VARCHAR2 DEFAULT NULL,
	cognome VARCHAR2 DEFAULT NULL,
	dataNascita VARCHAR2 DEFAULT NULL,
	indirizzo VARCHAR2 DEFAULT NULL,
	email VARCHAR2 DEFAULT NULL,
    telefono VARCHAR2 DEFAULT NULL,
	utenteMuseo VARCHAR2 DEFAULT NULL,
	utenteDonatore VARCHAR2 DEFAULT NULL,
	utenteCampiEstivi VARCHAR2 DEFAULT NULL,
	utenteAssistenza VARCHAR2 DEFAULT NULL,
	utenteTutore NUMBER DEFAULT 0
);

PROCEDURE ConfermaDatiUtente(
	nome VARCHAR2 DEFAULT NULL,
	cognome VARCHAR2 DEFAULT NULL,
	dataNascita VARCHAR2 DEFAULT NULL,
	indirizzo VARCHAR2 DEFAULT NULL,
	email VARCHAR2 DEFAULT NULL,
    telefono VARCHAR2 DEFAULT NULL,
	utenteMuseo VARCHAR2 DEFAULT NULL,
	utenteDonatore VARCHAR2 DEFAULT NULL,
	utenteCampiEstivi VARCHAR2 DEFAULT NULL,
	utenteAssistenza VARCHAR2 DEFAULT NULL,
	utenteTutore NUMBER DEFAULT 0
);

PROCEDURE InserisciDatiUtente (
	nome VARCHAR2 DEFAULT NULL,
	cognome VARCHAR2 DEFAULT NULL,
	dataNascita VARCHAR2 DEFAULT NULL,
	indirizzo VARCHAR2 DEFAULT NULL,
	utenteEmail VARCHAR2 DEFAULT NULL,
    telefono VARCHAR2 DEFAULT NULL,
	utenteMuseo VARCHAR2 DEFAULT NULL,
	utenteDonatore VARCHAR2 DEFAULT NULL,
	utenteCampiEstivi VARCHAR2 DEFAULT NULL,
	utenteAssistenza VARCHAR2 DEFAULT NULL,
	utenteTutore NUMBER DEFAULT 0
);

procedure EsitoPositivoUtenti;

procedure EsitoNegativoUtenti;

PROCEDURE VisualizzaUtente (
	utenteID NUMBER
);

PROCEDURE ModificaUtente (
	utenteID NUMBER DEFAULT NULL
);

PROCEDURE ModificaDatiUtente (
	utenteID NUMBER,
	nomeNew VARCHAR2 DEFAULT NULL,
	cognomeNew VARCHAR2 DEFAULT NULL,
	dataNascitaNew VARCHAR2 DEFAULT NULL,
	indirizzoNew VARCHAR2 DEFAULT NULL,
	utenteEmailNew VARCHAR2 DEFAULT NULL,
    telefonoNew VARCHAR2 DEFAULT NULL,
	utenteMuseoNew VARCHAR2 DEFAULT NULL,
	utenteDonatoreNew VARCHAR2 DEFAULT NULL,
	utenteCampiEstiviNew VARCHAR2 DEFAULT NULL,
	utenteAssistenzaNew VARCHAR2 DEFAULT NULL,
	utenteTutoreNew NUMBER DEFAULT 0
);

PROCEDURE EliminaUtente(
	utenteID NUMBER
);

PROCEDURE ListaUtenti;

procedure etaMediaUtenti;

procedure sommaTitoli(
	dataInizioFun VARCHAR2 DEFAULT NULL,
	dataFineFun VARCHAR2 DEFAULT NULL,
	utenteID NUMBER DEFAULT 0
);

procedure mediaCostoTitoli(
	dataInizioFun VARCHAR2 DEFAULT NULL,
	dataFineFun VARCHAR2 DEFAULT NULL,
	utenteID NUMBER DEFAULT 0
);

procedure NumeroVisiteMusei(
	dataInizioFun VARCHAR2 DEFAULT NULL,
	dataFineFun VARCHAR2 DEFAULT NULL,
	utenteID NUMBER DEFAULT 0
);

procedure NumeroMedioTitoli(
	dataInizioFun VARCHAR2 DEFAULT NULL,
	dataFineFun VARCHAR2 DEFAULT NULL
);

procedure StatisticheUtenti;

PROCEDURE acquistabiglietto(
	dataEmissionechar IN VARCHAR2,
	dataScadenzachar IN VARCHAR2,
	idmuseoselezionato IN VARCHAR2,
	idtipologiaselezionata IN VARCHAR2,
	idutenteselezionato IN VARCHAR2
);

PROCEDURE formacquistabiglietto(
	dataEmissionechar IN VARCHAR2,
	dataScadenzachar IN VARCHAR2,
	idmuseoselezionato IN VARCHAR2 default null,
	idtipologiaselezionata IN VARCHAR2 default null,
	idutenteselezionato IN VARCHAR2 default null
);

PROCEDURE pagina_acquista_biglietto(
	dataEmissionechar VARCHAR2 DEFAULT NULL,
	dataScadenzachar VARCHAR2 DEFAULT NULL,
	idmuseoselezionato VARCHAR2 DEFAULT NULL,
	idtipologiaselezionata VARCHAR2 DEFAULT NULL,
	idutenteselezionato VARCHAR2 DEFAULT NULL,
	convalida IN NUMBER DEFAULT NULL
);
--TODO DA TESTARE
/*
PROCEDURE inserisciNewsLetter (
    idSessione NUMBER DEFAULT 0
);

PROCEDURE inserisci_newsletter (
    idSessione NUMBER DEFAULT 0,
	nome varchar2(25) not null
);
*/

PROCEDURE statisticheNewsLetter (
	newsletterID NUMBER DEFAULT -1
);

END gruppo1;
