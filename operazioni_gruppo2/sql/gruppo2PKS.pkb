CREATE OR REPLACE PACKAGE gruppo2 AS


PROCEDURE genericErrorPage(
    idSessione NUMBER DEFAULT 0,
    pageTitle VARCHAR2 DEFAULT 'Errore',
    msg VARCHAR2 DEFAULT 'Errore sconosciuto',
    redirectText VARCHAR2 DEFAULT 'OK',
    redirect VARCHAR2 DEFAULT NULL
);

procedure RedirectEsito (
    idSessione NUMBER DEFAULT NULL,
    pageTitle VARCHAR2 DEFAULT NULL,
    msg VARCHAR2 DEFAULT NULL,
    nuovaOp VARCHAR2 DEFAULT NULL,
    nuovaOpURL VARCHAR2 DEFAULT NULL,
    parametrinuovaOp VARCHAR2 DEFAULT '',
    backToMenu VARCHAR2 DEFAULT NULL,
    backToMenuURL VARCHAR2 DEFAULT NULL,
    parametribackToMenu VARCHAR2 DEFAULT ''
    );

procedure EsitoOperazione(
    idSessione NUMBER DEFAULT NULL,
    pageTitle VARCHAR2 DEFAULT NULL,
    msg VARCHAR2 DEFAULT NULL,
    nuovaOp VARCHAR2 DEFAULT NULL,
    nuovaOpURL VARCHAR2 DEFAULT NULL,
    parametrinuovaOp VARCHAR2 DEFAULT '',
    backToMenu VARCHAR2 DEFAULT NULL,
    backToMenuURL VARCHAR2 DEFAULT NULL,
    parametribackToMenu VARCHAR2 DEFAULT ''
    );

/* OPERAZIONI SULLE OPERE */
procedure coloreClassifica(posizione NUMBER DEFAULT 0);
procedure EsitoPositivoOpere(idSessione NUMBER DEFAULT NULL);
procedure EsitoNegativoOpere(idSessione NUMBER DEFAULT NULL);

procedure SpostamentiOpera (operaID NUMBER DEFAULT 0);
procedure menuOpere (idSessione NUMBER DEFAULT NULL);
procedure selezioneMuseo(idSessione NUMBER DEFAULT 0);
Procedure StatisticheOpere(
    idSessione NUMBER DEFAULT 0,
    museoID NUMBER DEFAULT 0
);
PROCEDURE InserisciOpera(
    idSessione NUMBER DEFAULT NULL,
    titolo VARCHAR2 DEFAULT 'Sconosciuto',
    anno VARCHAR2 DEFAULT NULL,
    fineperiodo VARCHAR2 DEFAULT NULL,
    idmusei NUMBER DEFAULT NULL
);
procedure AggiungiAutore(
    idSessione NUMBER DEFAULT 0,
    operaID NUMBER DEFAULT 0
);
procedure AggiuntaAutore(
    idSessione NUMBER DEFAULT 0,
    operaID NUMBER DEFAULT 0,
    autoreID NUMBER DEFAULT 0
);
procedure EliminazioneOpera(
    idSessione NUMBER default 0,
    operaID NUMBER default 0
);
procedure RimozioneOpera(
    idSessione NUMBER default 0,
    operaID NUMBER default 0
);
PROCEDURE ConfermaDatiOpera(
    idSessione NUMBER DEFAULT 0,
    titolo VARCHAR2 DEFAULT 'Sconosciuto',
    anno VARCHAR2 DEFAULT NULL,
    fineperiodo VARCHAR2 DEFAULT NULL,
    idmusei NUMBER DEFAULT NULL
);

PROCEDURE ConfermaUpdateOpera(
    idSessione NUMBER DEFAULT 0,
    operaID NUMBER DEFAULT 0,
    titolo VARCHAR2 DEFAULT 'Sconosciuto',
    anno VARCHAR2 DEFAULT NULL,
    fineperiodo VARCHAR2 DEFAULT NULL,
    idmusei NUMBER DEFAULT 0
);

PROCEDURE ModificaOpera(
    idSessione NUMBER DEFAULT 0,
    operaID NUMBER DEFAULT 0,
    titoloOpera VARCHAR2 DEFAULT 'Sconosciuto'
);

PROCEDURE UpdateOpera(
	idSessione NUMBER DEFAULT 0,
	operaID NUMBER DEFAULT 0,
	newTitolo VARCHAR2 DEFAULT 'Sconosciuto',
	newAnno VARCHAR2 DEFAULT 'Sconosciuto',
	newFineperiodo NUMBER DEFAULT 0,
	newIDmusei NUMBER DEFAULT 0
);

PROCEDURE InserisciDatiOpera(
    idSessione NUMBER DEFAULT 0,
    titolo VARCHAR2 DEFAULT 'Sconosciuto',
    anno NUMBER DEFAULT NULL,
    fineperiodo NUMBER DEFAULT NULL,
    idmusei NUMBER DEFAULT NULL
);
procedure VisualizzaOpera (
    idSessione NUMBER default 0,
    operaID NUMBER default 0,
    lingue VARCHAR2 default 'sconosciuto',
    livelli VARCHAR2 DEFAULT 'Sconosciuto'
);
procedure linguaELivello(
    idSessione NUMBER default 0,
    operaID NUMBER default 0
);
/* OPERAZIONI SUGLI AUTORI */
PROCEDURE menuAutori(idSessione NUMBER DEFAULT NULL);

procedure selezioneOpStatAut(idSessione NUMBER DEFAULT 0);

procedure selezioneAutoreStatistica(
    idSessione NUMBER DEFAULT 0,
    operazione NUMBER DEFAULT 0
);

Procedure StatisticheAutori(
    idSessione NUMBER DEFAULT 0,
    operazione NUMBER DEFAULT 0,
    authID NUMBER DEFAULT 0
);

procedure selezioneMuseoAutoreStatistica(
    idSessione NUMBER DEFAULT 0,
    operazione NUMBER DEFAULT 0,
    authID NUMBER DEFAULT 0
);

Procedure StatisticheMuseoAutori(
    idSessione NUMBER DEFAULT 0,
    operazione NUMBER DEFAULT 0,
    authID NUMBER DEFAULT 0,
    museoID NUMBER DEFAULT 0
);

PROCEDURE InserisciAutore(
    idSessione NUMBER DEFAULT NULL,
    authName VARCHAR2 DEFAULT NULL,
    authSurname VARCHAR2 DEFAULT NULL,
    dataNascita VARCHAR2 DEFAULT NULL,
    dataMorte VARCHAR2 DEFAULT NULL,
    nation VARCHAR2 DEFAULT NULL
);

PROCEDURE ConfermaDatiAutore(
    idSessione NUMBER DEFAULT 0,
    authName VARCHAR2 DEFAULT 'Sconosciuto',
    authSurname VARCHAR2 DEFAULT 'Sconosciuto',
    dataNascita varchar2 DEFAULT NULL,
    dataMorte varchar2 DEFAULT NULL,
    nation VARCHAR2 DEFAULT 'Sconosciuta'
);

PROCEDURE InserisciDatiAutore(
    idSessione NUMBER DEFAULT 0,
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
    idSessione NUMBER DEFAULT 0,
    authorID NUMBER DEFAULT 0,
    operazione NUMBER DEFAULT 0
);

PROCEDURE UpdateAutore(
	idSessione NUMBER DEFAULT 0,
	authID NUMBER DEFAULT 0,
	newName VARCHAR2 DEFAULT 'Sconosciuto',
	newSurname VARCHAR2 DEFAULT 'Sconosciuto',
	newBirth VARCHAR2 DEFAULT NULL,
	newDeath VARCHAR2 DEFAULT NULL,
	newNation VARCHAR2 DEFAULT 'Sconosciuta'
);

procedure EliminazioneAutore(
    idSessione NUMBER default 0,
    authorID NUMBER default 0
);
procedure RimozioneAutore(
    idSessione NUMBER default 0,
    authorID NUMBER default 0
);

/* OPERAZIONI SULLE DESCRIZIONI  */

PROCEDURE InserisciDescrizione(
    idSessione NUMBER DEFAULT NULL,
    language VARCHAR2 DEFAULT NULL,
    d_level VARCHAR2 DEFAULT NULL,
    d_text VARCHAR2 DEFAULT NULL,
    operaID NUMBER DEFAULT NULL
);

PROCEDURE ConfermaDatiDescrizione(
    idSessione NUMBER DEFAULT 0,
    language VARCHAR2 DEFAULT 'Sconosciuta',
    d_level VARCHAR2 DEFAULT 'Sconosciuto',
    d_text VARCHAR2 DEFAULT NULL,
    operaID NUMBER DEFAULT NULL
);

PROCEDURE InserisciDatiDescrizione(
    idSessione NUMBER DEFAULT 0,
    language VARCHAR2 DEFAULT 'Sconosciuta',
    d_level VARCHAR2 DEFAULT 'Sconosciuto',
    d_text VARCHAR2 DEFAULT NULL,
    operaID NUMBER DEFAULT NULL
);

PROCEDURE modificaDescrizione(
    idSessione NUMBER DEFAULT 0,
    idDescrizione NUMBER DEFAULT NULL
);

procedure EliminazioneDescrizione(
    idSessione NUMBER default 0,
    idDescrizione NUMBER default 0
);

procedure RimozioneDescrizione(
    idSessione NUMBER default 0,
    idDescrizione NUMBER default 0
);

PROCEDURE UpdateDescrizione(
	idSessione NUMBER DEFAULT 0,
	descrID NUMBER DEFAULT 0,
    newopera number DEFAULT 0,
    newlingua varchar2 DEFAULT null,
    newlivello varchar2 DEFAULT null,
    newtesto CLOB DEFAULT null
);

Procedure StatisticheDescrizioni(
    idSessione NUMBER DEFAULT 0,
    operazione NUMBER DEFAULT 0
);
END gruppo2;
