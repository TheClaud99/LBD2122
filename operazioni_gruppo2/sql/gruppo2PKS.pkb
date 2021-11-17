CREATE OR REPLACE PACKAGE gruppo2 AS

/* OPERAZIONI SULLE OPERE */
procedure EsitoPositivoOpere(sessionID NUMBER DEFAULT NULL);
procedure EsitoNegativoOpere(sessionID NUMBER DEFAULT NULL);
procedure StatisticheOpere(sessionID NUMBER DEFAULT NULL);
procedure SpostamentiOpera (operaID NUMBER DEFAULT 0);
procedure menuOpere (sessionID NUMBER DEFAULT NULL);
procedure selezioneMuseo(sessionID NUMBER DEFAULT 0);
Procedure StatisticheOpere(
    sessionID NUMBER DEFAULT 0,
    museoID NUMBER DEFAULT 0
);
PROCEDURE InserisciOpera(
    sessionID NUMBER DEFAULT NULL,
    titolo VARCHAR2 DEFAULT 'Sconosciuto',
    anno VARCHAR2 DEFAULT NULL,
    fineperiodo VARCHAR2 DEFAULT NULL,
    idmusei NUMBER DEFAULT NULL
);

procedure EliminazioneOpera(
    sessionID NUMBER default 0,
    operaID NUMBER default 0
);
procedure RimozioneOpera(
    sessionID NUMBER default 0,
    operaID NUMBER default 0
);
PROCEDURE ConfermaDatiOpera(
    sessionID NUMBER DEFAULT 0,
    titolo VARCHAR2 DEFAULT 'Sconosciuto',
    anno VARCHAR2 DEFAULT NULL,
    fineperiodo VARCHAR2 DEFAULT NULL,
    idmusei NUMBER DEFAULT NULL
);

PROCEDURE ConfermaUpdateOpera(
    sessionID NUMBER DEFAULT 0,
    operaID NUMBER DEFAULT 0,
    titolo VARCHAR2 DEFAULT 'Sconosciuto',
    anno VARCHAR2 DEFAULT NULL,
    fineperiodo VARCHAR2 DEFAULT NULL,
    idmusei NUMBER DEFAULT 0
);

PROCEDURE ModificaOpera(
    sessionID NUMBER DEFAULT 0,
    operaID NUMBER DEFAULT 0,
    titoloOpera VARCHAR2 DEFAULT 'Sconosciuto'
);

PROCEDURE UpdateOpera(
	sessionID NUMBER DEFAULT 0,
	operaID NUMBER DEFAULT 0,
	newTitolo VARCHAR2 DEFAULT 'Sconosciuto',
	newAnno VARCHAR2 DEFAULT 'Sconosciuto',
	newFineperiodo NUMBER DEFAULT 0,
	newIDmusei NUMBER DEFAULT 0
);

PROCEDURE InserisciDatiOpera(
    sessionID NUMBER DEFAULT 0,
    titolo VARCHAR2 DEFAULT 'Sconosciuto',
    anno NUMBER DEFAULT NULL,
    fineperiodo NUMBER DEFAULT NULL,
    idmusei NUMBER DEFAULT NULL
);
procedure VisualizzaOpera (
    sessionID NUMBER default 0,
    operaID NUMBER default 0,
    lingue VARCHAR2 default 'sconosciuto'
);
procedure lingua(
    sessionID NUMBER default 0,
    operaID NUMBER default 0
);
/* OPERAZIONI SUGLI AUTORI */
PROCEDURE menuAutori(sessionID NUMBER DEFAULT NULL);

procedure selezioneOpStatAut(sessionID NUMBER DEFAULT 0);

procedure selezioneAutoreStatistica(
    sessionID NUMBER DEFAULT 0,
    operazione NUMBER DEFAULT 0
);

Procedure StatisticheAutori(
    sessionID NUMBER DEFAULT 0,
    operazione NUMBER DEFAULT 0,
    authID NUMBER DEFAULT 0
);

procedure selezioneMuseoAutoreStatistica(
    sessionID NUMBER DEFAULT 0,
    operazione NUMBER DEFAULT 0,
    authID NUMBER DEFAULT 0
);

Procedure StatisticheMuseoAutori(
    sessionID NUMBER DEFAULT 0,
    operazione NUMBER DEFAULT 0,
    authID NUMBER DEFAULT 0,
    museoID NUMBER DEFAULT 0
);

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

procedure EsitoPositivoAutori(sessionID NUMBER DEFAULT NULL);

procedure EsitoPositivoUpdateAutori(sessionID NUMBER DEFAULT NULL);

procedure EsitoNegativoUpdateAutori(
    sessionID NUMBER DEFAULT 0,
    authorID VARCHAR2 DEFAULT 'Sconosciuto'
);

/* OPERAZIONI SULLE DESCRIZIONI  */

PROCEDURE InserisciDescrizione(
    sessionID NUMBER DEFAULT NULL,
    language VARCHAR2 DEFAULT NULL,
    d_level VARCHAR2 DEFAULT NULL,
    d_text VARCHAR2 DEFAULT NULL,
    operaID NUMBER DEFAULT NULL
);

PROCEDURE ConfermaDatiDescrizione(
    sessionID NUMBER DEFAULT 0,
    language VARCHAR2 DEFAULT 'Sconosciuta',
    d_level VARCHAR2 DEFAULT 'Sconosciuto',
    d_text VARCHAR2 DEFAULT NULL,
    operaID NUMBER DEFAULT NULL
);

PROCEDURE InserisciDatiDescrizione(
    sessionID NUMBER DEFAULT 0,
    language VARCHAR2 DEFAULT 'Sconosciuta',
    d_level VARCHAR2 DEFAULT 'Sconosciuto',
    d_text VARCHAR2 DEFAULT NULL,
    operaID NUMBER DEFAULT NULL
);

PROCEDURE modificaDescrizione(
    sessionID NUMBER DEFAULT 0,
    idDescrizione NUMBER DEFAULT NULL
);

PROCEDURE UpdateDescrizione(
	sessionID NUMBER DEFAULT 0,
	descrID NUMBER DEFAULT 0,
    newopera number DEFAULT 0,
    newlingua varchar2 DEFAULT null,
    newlivello varchar2 DEFAULT null,
    newtesto CLOB DEFAULT null
);

procedure EsitoPositivoUpdateDescrizioni(
    sessionID NUMBER DEFAULT NULL, 
    opera number DEFAULT 0,
    lingua varchar2 DEFAULT null
);

procedure EsitoNegativoUpdateDescrizioni(
    sessionID NUMBER DEFAULT NULL, 
    opera number DEFAULT 0,
    lingua varchar2 DEFAULT null
);
END gruppo2;
