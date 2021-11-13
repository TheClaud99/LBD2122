CREATE OR REPLACE PACKAGE gruppo2 AS

root constant VARCHAR2(125) := 'http://131.114.73.203:8080/apex/';
user constant VARCHAR2(25) := 'nvetrini.gruppo2.';

/* OPERAZIONI SULLE OPERE */
procedure menuOpere (sessionID NUMBER DEFAULT NULL);
PROCEDURE InserisciOpera(
    sessionID NUMBER DEFAULT NULL
);
PROCEDURE ConfermaDatiOpera(
    sessionID NUMBER DEFAULT 0,
    titolo VARCHAR2 DEFAULT 'Sconosciuto',
    anno VARCHAR2 DEFAULT NULL,
    idmusei NUMBER DEFAULT NULL
);
PROCEDURE InserisciDatiOpera(
    sessionID NUMBER DEFAULT 0,
    titolo VARCHAR2 DEFAULT 'Sconosciuto',
    anno VARCHAR2 DEFAULT NULL,
    idmusei NUMBER DEFAULT NULL
);

PROCEDURE ModificaOpera(
    sessionID NUMBER DEFAULT NULL,
    operaID NUMBER DEFAULT 0,
    titoloOpera VARCHAR2 DEFAULT 'Sconosciuto'
);
 
PROCEDURE ConfermaUpdateOpera(
    sessionID NUMBER DEFAULT 0,
    operaID NUMBER DEFAULT 0,
    titolo VARCHAR2 DEFAULT 'Sconosciuto',
    anno VARCHAR2 DEFAULT NULL,
    fineperiodo VARCHAR2 DEFAULT NULL,
    idmusei NUMBER DEFAULT 0
);
 
 
 
PROCEDURE UpdateOpera(
    sessionID NUMBER DEFAULT 0,
    operaID NUMBER DEFAULT 0,
    newTitolo VARCHAR2 DEFAULT 'Sconosciuto',
    newAnno VARCHAR2 DEFAULT 'Sconosciuto',
    newFineperiodo NUMBER DEFAULT 0,
    newIDmusei NUMBER DEFAULT 0
);


/* OPERAZIONI SUGLI AUTORI */
PROCEDURE menuAutori(sessionID NUMBER DEFAULT NULL);

PROCEDURE InserisciAutore(
    sessionID NUMBER DEFAULT NULL,
    authName VARCHAR2 DEFAULT NULL,
    authSurname VARCHAR2 DEFAULT NULL,
    dataNascita VARCHAR2 DEFAULT NULL,
    dataMorte VARCHAR2 DEFAULT NULL,
    nation VARCHAR2 DEFAULT NULL
);

PROCEDURE ConfermaDatiAutore(
    sessionID NUMBER DEFAULT 0,
    authName VARCHAR2 DEFAULT 'Sconosciuto',
    authSurname VARCHAR2 DEFAULT 'Sconosciuto',
    dataNascita varchar2 DEFAULT NULL,
    dataMorte varchar2 DEFAULT NULL,
    nation VARCHAR2 DEFAULT 'Sconosciuta'
);

PROCEDURE InserisciDatiAutore(
    sessionID NUMBER DEFAULT 0,
    authName VARCHAR2 DEFAULT 'Sconosciuto',
    authSurname VARCHAR2 DEFAULT 'Sconosciuto',
    dataNascita varchar2 DEFAULT NULL,
    dataMorte varchar2 DEFAULT NULL,
    nation VARCHAR2 DEFAULT 'Sconosciuta'
);

-- Il parametro operazione assume uno tra i seguenti valori:
--  0: Visualizzazione
--  1: Modifica
--  2: Rimozione
PROCEDURE ModificaAutore(
    sessionID NUMBER DEFAULT 0,
    authorID NUMBER DEFAULT 0,
    operazione NUMBER DEFAULT 0
);


PROCEDURE UpdateAutore(
	sessionID NUMBER DEFAULT 0,
	authID NUMBER DEFAULT 0,
	newName VARCHAR2 DEFAULT 'Sconosciuto',
	newSurname VARCHAR2 DEFAULT 'Sconosciuto',
	newBirth VARCHAR2 DEFAULT NULL,
	newDeath VARCHAR2 DEFAULT NULL,
	newNation VARCHAR2 DEFAULT 'Sconosciuta'
);

/* OPERAZIONI SULLE DESCRIZIONI  */
PROCEDURE InserisciDescrizione(
    sessionID NUMBER DEFAULT NULL,
    lingua VARCHAR2 DEFAULT NULL,
    livello VARCHAR2 DEFAULT NULL,
    testodescr VARCHAR2 DEFAULT NULL,
    operaID NUMBER DEFAULT NULL
);

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
