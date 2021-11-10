CREATE OR REPLACE PACKAGE gruppo1 AS

root constant VARCHAR2(125) := 'http://131.114.73.203:8080/apex/';
user constant VARCHAR2(25) := 'nvetrini.gruppo1.';

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
/*
PROCEDURE AcquistoBiglietto(
    sessionID NUMBER DEFAULT 0
);

PROCEDURE ConfermaAcquistoBiglietto(
	sessionID NUMBER DEFAULT 0,
	dataEmiss VARCHAR2 DEFAULT NULL,
	dataScad VARCHAR2 DEFAULT NULL,
	nomeUtente UTENTI.Nome%TYPE DEFAULT NULL,
	cognomeUtente UTENTI.Cognome%TYPE DEFAULT NULL,
	varIdUtente UTENTI.IdUtente%TYPE DEFAULT NULL,
	varIdMuseo MUSEI.IdMuseo%TYPE DEFAULT NULL,
	NomeMuseo MUSEI.Nome%TYPE DEFAULT NULL
);

PROCEDURE InserisciDatiBigliettoAcquistato (
    sessionID NUMBER DEFAULT 0,
	dataEmiss VARCHAR2 DEFAULT NULL,
	dataScad VARCHAR2 DEFAULT NULL,
	nomeUtente UTENTI.Nome%TYPE DEFAULT NULL,
	cognomeUtente UTENTI.Cognome%TYPE DEFAULT NULL,
	varIdUtente UTENTI.IdUtente%TYPE DEFAULT NULL,
	varIdMuseo MUSEI.IdMuseo%TYPE DEFAULT NULL,
	NomeMuseo MUSEI.Nome%TYPE DEFAULT NULL
);
*/

END gruppo1;