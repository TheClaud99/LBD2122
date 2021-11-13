CREATE OR REPLACE PACKAGE gruppo1 AS

root constant VARCHAR2(125) := 'http://131.114.73.203:8080/apex/';
user constant VARCHAR2(25) := 'fgiannotti.gruppo1.';

procedure InserisciUtente(sessionID NUMBER DEFAULT 0);
PROCEDURE ConfermaDatiUtente(
	sessionID NUMBER DEFAULT 0,
	nome VARCHAR2 DEFAULT NULL,
	cognome VARCHAR2 DEFAULT NULL,
	dataNascita VARCHAR2 DEFAULT NULL,
	indirizzo VARCHAR2 DEFAULT NULL,
	email VARCHAR2 DEFAULT NULL,
    telefono VARCHAR2 DEFAULT NULL
);
PROCEDURE InserisciDatiUtente (
    sessionID NUMBER DEFAULT 0,
	nome VARCHAR2,
	cognome VARCHAR2,
	dataNascita VARCHAR2 DEFAULT NULL,
	indirizzo VARCHAR2 DEFAULT NULL,
	email VARCHAR2 DEFAULT NULL,
    telefono VARCHAR2 DEFAULT NULL
);

PROCEDURE VisualizzaDatiUtente (
    sessionID NUMBER DEFAULT 0,
	utenteID NUMBER
);

PROCEDURE ModificaDatiUtente (
    sessionID NUMBER DEFAULT 0,
	utenteID NUMBER DEFAULT NULL
);

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
PROCEDURE inserisciNewsLetter (
    sessionID NUMBER DEFAULT 0
);

PROCEDURE inserisci_newsletter (
    sessionID NUMBER DEFAULT 0
	nome varchar2(25) not null
);

END gruppo1;