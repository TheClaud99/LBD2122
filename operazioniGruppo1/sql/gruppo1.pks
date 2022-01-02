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

PROCEDURE ListaUtenti(
	pcognome VARCHAR2 DEFAULT NULL
);

procedure etaMediaUtenti;

procedure sommaTitoli(
	dataInizioFun VARCHAR2 DEFAULT NULL,
	dataFineFun VARCHAR2 DEFAULT NULL,
	utenteID NUMBER DEFAULT 0,
	museoID NUMBER DEFAULT 0
);

procedure mediaCostoTitoli(
	dataInizioFun VARCHAR2 DEFAULT NULL,
	dataFineFun VARCHAR2 DEFAULT NULL,
	utenteID NUMBER DEFAULT 0,
	museoID NUMBER DEFAULT 0
);

procedure NumeroVisiteMusei(
	dataInizioFun VARCHAR2 DEFAULT NULL,
	dataFineFun VARCHAR2 DEFAULT NULL,
	utenteID NUMBER DEFAULT 0,
	museoID NUMBER DEFAULT 0
);

procedure NumeroMedioTitoli(
	dataInizioFun VARCHAR2 DEFAULT NULL,
	dataFineFun VARCHAR2 DEFAULT NULL,
	museoID NUMBER DEFAULT 0
);

procedure StatisticheUtenti;



END gruppo1;
