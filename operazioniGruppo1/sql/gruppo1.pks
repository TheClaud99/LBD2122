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

END gruppo1;