CREATE OR REPLACE PACKAGE Newsletters AS

	root constant VARCHAR2(125) := 'http://131.114.73.203:8080/apex/';
	user constant VARCHAR2(25) := 'fbocci.';

	PROCEDURE visualizzaNewsletters;


	PROCEDURE iscrivitiNewsletter (
		newsletterid NUMBER DEFAULT -1,
		clientid NUMBER DEFAULT -1
	);

	PROCEDURE disiscrivitiNewsletter (
		newsletterid NUMBER DEFAULT -1,
		clientid NUMBER DEFAULT -1
	);

	PROCEDURE statisticheNewsLetter (
		newsletterID NUMBER DEFAULT -1
	);

	PROCEDURE titoliIngIscritti (
		newsletterID NUMBER DEFAULT -1
	);

	PROCEDURE inserisciNewsLetter;


	PROCEDURE inserisci_newsletter (
		nome varchar2 DEFAULT 'sconosciuto',
		checked number default 0
	);

	PROCEDURE rimuoviNewsletter (
		newsletterID NUMBER DEFAULT -1
	);

	PROCEDURE confermaRimozioneNewsletter (
		newsletterID NUMBER DEFAULT -1
	);

END Newsletters;
