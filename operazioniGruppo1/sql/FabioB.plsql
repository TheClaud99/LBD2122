CREATE OR REPLACE PACKAGE testFB AS

root constant VARCHAR2(125) := 'http://131.114.73.203:8080/apex/';
user constant VARCHAR2(25) := 'fbocci.';

PROCEDURE visualizzaNewsletters;

PROCEDURE statisticheNewsLetter (
	newsletterID NUMBER DEFAULT -1
);

PROCEDURE inserisciNewsLetter;


PROCEDURE inserisci_newsletter (
	nome varchar2 DEFAULT 'sconosciuto',
	checked number default 0
);

END testFB;
