CREATE OR REPLACE PACKAGE gruppo2 AS

root constant VARCHAR2(125) := 'http://131.114.73.203:8080/apex/';
user constant VARCHAR2(25) := 'nvetrini.gruppo2.';

/* OPERAZIONI SULLE OPERE */
/* TODO */

/* OPERAZIONI SUGLI AUTORI */
PROCEDURE InserisciAutore(sessionID NUMBER DEFAULT NULL);

PROCEDURE ConfermaDatiAutore(
	sessionID NUMBER DEFAULT 0,
	nome VARCHAR2 DEFAULT 'Sconosciuto',
	cognome VARCHAR2 DEFAULT 'Sconosciuto',
	dataNascita varchar2 DEFAULT NULL,
	dataMorte varchar2 DEFAULT NULL,
	nazionalita VARCHAR2 DEFAULT 'Sconosciuta'
);

PROCEDURE InserisciDatiAutore(
	sessionID NUMBER DEFAULT 0,
	nome VARCHAR2 DEFAULT 'Sconosciuto',
	cognome VARCHAR2 DEFAULT 'Sconosciuto',
	dataNascita varchar2 DEFAULT NULL,
	dataMorte varchar2 DEFAULT NULL,
	nazionalita VARCHAR2 DEFAULT 'Sconosciuta'
);
/* OPERAZIONI SULLE DESCRIZIONI */
PROCEDURE InserisciDescrizione(sessionID NUMBER DEFAULT NULL);

PROCEDURE ConfermaDatiDescrizione(
	sessionID NUMBER DEFAULT 0,
	lingua VARCHAR2 DEFAULT 'Sconosciuta',
	livello VARCHAR2 DEFAULT 'Sconosciuto',
	testodescr VARCHAR2 DEFAULT NULL,
	operaID NUMBER DEFAULT NULL
);

PROCEDURE InserisciDatiDescrizione(
	sessionID NUMBER DEFAULT 0,
	lingua VARCHAR2 DEFAULT 'Sconosciuta',
	livello VARCHAR2 DEFAULT 'Sconosciuto',
	testodescr VARCHAR2 DEFAULT NULL,
	operaID NUMBER DEFAULT NULL
);

END gruppo2;