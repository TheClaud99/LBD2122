CREATE OR REPLACE PACKAGE gruppo2 AS

gr2 CONSTANT VARCHAR2(25) := 'gruppo2.';
gr4 CONSTANT VARCHAR2(25) := 'operazionigruppo4.';
gr3 CONSTANT VARCHAR2(25) := 'gruppo3.';

-- Index by table con campi (IdOpera, titolo, IdAutore, Nome Autore, Cognome Autore)
-- indicizzata da IdAutore dell'autore che ha collaborato all'opera
TYPE collabRecord IS RECORD (
    Opera Opere.IdOpera%TYPE, 
    Titolo Opere.Titolo%TYPE,
    collabID Autori.IdAutore%TYPE,
    collabNome Autori.Nome%TYPE,
    collabCognome Autori.Cognome%TYPE);
TYPE collaborazioniCollection IS TABLE OF collabRecord
INDEX BY PLS_INTEGER;
emptyCollab collaborazioniCollection;

FUNCTION listaCollaborazioni(authorID Autori.IdAutore%TYPE)
RETURN collaborazioniCollection;

/* OPERAZIONI SULLE OPERE */
PROCEDURE coloreClassifica(posizione NUMBER DEFAULT 0);
PROCEDURE SpostamentiOpera (

    operaID NUMBER DEFAULT 0
);
procedure EliminazioneDefinitivaOpera(

    operaID NUMBER default 0
);

procedure RimozioneDefinitivaOpera(

    operaID NUMBER default 0
);

PROCEDURE SpostaOpera(

    operaID NUMBER DEFAULT 0,
    salaID NUMBER DEFAULT 0,
    lingue VARCHAR2 default NULL,
    livelli VARCHAR2 DEFAULT 'Sconosciuto'
);
PROCEDURE SpostamentoOpera(

    operaID NUMBER DEFAULT 0,
    Esposizione NUMBER DEFAULT 0,
    NuovaSalaID NUMBER DEFAULT 0,
    lingue VARCHAR2 default NULL,
    livelli VARCHAR2 DEFAULT 'Sconosciuto'
);
PROCEDURE menuOpere ;
procedure menuOpereEliminate ;
PROCEDURE selezioneMuseo;
PROCEDURE StatisticheOpere(

    museoID NUMBER DEFAULT 0
);
PROCEDURE InserisciOpera(
    titolo VARCHAR2 DEFAULT 'Sconosciuto',
    anno VARCHAR2 DEFAULT NULL,
    fineperiodo VARCHAR2 DEFAULT NULL,
    idmusei NUMBER DEFAULT NULL
);
PROCEDURE AggiungiAutore(

    operaID NUMBER DEFAULT 0,
    lingue VARCHAR2 DEFAULT null,
    livelli VARCHAR2 DEFAULT NULL
);
PROCEDURE AggiuntaAutore(

    operaID NUMBER DEFAULT 0,
    autoreID NUMBER DEFAULT 0,
    lingue VARCHAR2 default NULL,
    livelli VARCHAR2 DEFAULT NULL
);

-- Rimuove un Autore dall'Opera indicata (pagina conferma)
PROCEDURE RimuoviAutoreOpera(

    operaID NUMBER DEFAULT 0,
    lingue VARCHAR2 DEFAULT null,
    livelli VARCHAR2 DEFAULT null
);
-- Rimuove un Autore dall'Opera indicata
PROCEDURE RimozioneAutoreOpera(

    operaID NUMBER DEFAULT 0,
    autoreID NUMBER DEFAULT 0,
    lingue VARCHAR2 DEFAULT null,
    livelli VARCHAR2 DEFAULT null
);

PROCEDURE EliminazioneOpera(

    operaID NUMBER default 0
);
PROCEDURE RimozioneOpera(

    operaID NUMBER default 0
);
procedure ripristinaOpera(

    operaID NUMBER DEFAULT 0
);
PROCEDURE ConfermaDatiOpera(

    titolo VARCHAR2 DEFAULT 'Sconosciuto',
    anno VARCHAR2 DEFAULT NULL,
    fineperiodo VARCHAR2 DEFAULT NULL,
    idmusei NUMBER DEFAULT NULL
);

PROCEDURE ConfermaUpdateOpera(

    operaID NUMBER DEFAULT 0,
    titolo VARCHAR2 DEFAULT 'Sconosciuto',
    anno VARCHAR2 DEFAULT NULL,
    fineperiodo VARCHAR2 DEFAULT NULL,
    idmusei NUMBER DEFAULT 0
);

PROCEDURE ModificaOpera(

    operaID NUMBER DEFAULT 0,
    titoloOpera VARCHAR2 DEFAULT 'Sconosciuto'
);

PROCEDURE UpdateOpera(

	operaID NUMBER DEFAULT 0,
	newTitolo VARCHAR2 DEFAULT 'Sconosciuto',
	newAnno VARCHAR2 DEFAULT 'Sconosciuto',
	newFineperiodo VARCHAR2 DEFAULT 'Sconosciuto',
	newIDmusei NUMBER DEFAULT 0
);

PROCEDURE InserisciDatiOpera(

    titolo VARCHAR2 DEFAULT 'Sconosciuto',
    anno VARCHAR2 DEFAULT 'Sconosciuto',
    fineperiodo VARCHAR2 DEFAULT 'Sconosciuto',
    idmusei NUMBER DEFAULT NULL
);
PROCEDURE VisualizzaOpera (

    operaID NUMBER default 0,
    lingue VARCHAR2 default 'sconosciuto',
    livelli VARCHAR2 DEFAULT 'Sconosciuto'
);
PROCEDURE linguaELivello(

    operaID NUMBER default 0
);
/* OPERAZIONI SUGLI AUTORI */
PROCEDURE menuAutori;
PROCEDURE menuAutoriEliminati;

PROCEDURE selezioneOpStatAut;

PROCEDURE selezioneAutoreStatistica(

    operazione NUMBER DEFAULT 0
);

PROCEDURE StatisticheAutori(

    operazione NUMBER DEFAULT 0,
    authID NUMBER DEFAULT 0
);

PROCEDURE selezioneMuseoAutoreStatistica(

    operazione NUMBER DEFAULT 0,
    authID NUMBER DEFAULT 0
);

PROCEDURE StatisticheMuseoAutori(

    operazione NUMBER DEFAULT 0,
    authID NUMBER DEFAULT 0,
    museoID NUMBER DEFAULT 0
);

PROCEDURE InserisciAutore(
    authName VARCHAR2 DEFAULT NULL,
    authSurname VARCHAR2 DEFAULT NULL,
    dataNascita VARCHAR2 DEFAULT NULL,
    dataMorte VARCHAR2 DEFAULT NULL,
    nation VARCHAR2 DEFAULT NULL
);

PROCEDURE ConfermaDatiAutore(

    authName VARCHAR2 DEFAULT 'Sconosciuto',
    authSurname VARCHAR2 DEFAULT 'Sconosciuto',
    dataNascita varchar2 DEFAULT NULL,
    dataMorte varchar2 DEFAULT NULL,
    nation VARCHAR2 DEFAULT 'Sconosciuta'
);

PROCEDURE InserisciDatiAutore(
    authName VARCHAR2 DEFAULT 'Sconosciuto',
    authSurname VARCHAR2 DEFAULT 'Sconosciuto',
    dataNascita varchar2 DEFAULT NULL,
    dataMorte varchar2 DEFAULT NULL,
    nation VARCHAR2 DEFAULT 'Sconosciuta'
);

-- Il parametro operazione assume uno tra i seguenti valori:
--  0: Visualizzazione
--  1: Modifica
PROCEDURE ModificaAutore(

	authorID NUMBER DEFAULT 0,
    operazione NUMBER DEFAULT 0,
    caller VARCHAR2 DEFAULT NULL,
    callerParams VARCHAR2 DEFAULT ''
);

PROCEDURE UpdateAutore(

	authID NUMBER DEFAULT 0,
	newName VARCHAR2 DEFAULT 'Sconosciuto',
	newSurname VARCHAR2 DEFAULT 'Sconosciuto',
	newBirth VARCHAR2 DEFAULT NULL,
	newDeath VARCHAR2 DEFAULT NULL,
	newNation VARCHAR2 DEFAULT 'Sconosciuta'
);

procedure ripristinaAutore(

    authID NUMBER DEFAULT 0
);

PROCEDURE EliminazioneAutore(

    authorID NUMBER default 0
);

-- Setta l'attributo 'Eliminato' dell'autore a 1 => l'autore scompare dal menuAutori
-- e va in menuAutoriEliminati (ma non rimossi)
procedure SetAutoreEliminato(

    authorID NUMBER default 0
);

PROCEDURE RimozioneAutore(

    authorID NUMBER default 0
);

PROCEDURE DeleteAutore(
    authorID NUMBER default 0
);

/* OPERAZIONI SULLE DESCRIZIONI  */

PROCEDURE InserisciDescrizione(
    language VARCHAR2 DEFAULT NULL,
    d_level VARCHAR2 DEFAULT NULL,
    d_text VARCHAR2 DEFAULT NULL,
    operaID NUMBER DEFAULT NULL
);

PROCEDURE ConfermaDatiDescrizione(

    language VARCHAR2 DEFAULT 'Sconosciuta',
    d_level VARCHAR2 DEFAULT 'Sconosciuto',
    d_text VARCHAR2 DEFAULT NULL,
    operaID NUMBER DEFAULT NULL
);

PROCEDURE InserisciDatiDescrizione(

    language VARCHAR2 DEFAULT 'Sconosciuta',
    d_level VARCHAR2 DEFAULT 'Sconosciuto',
    d_text VARCHAR2 DEFAULT NULL,
    operaID NUMBER DEFAULT NULL
);

PROCEDURE modificaDescrizione(

    idDescrizione NUMBER DEFAULT NULL
);

PROCEDURE EliminazioneDescrizione(

    idDescrizione NUMBER default 0
);

PROCEDURE RimozioneDescrizione(

    idDescrizione NUMBER default 0
);

PROCEDURE UpdateDescrizione(

	descrID NUMBER DEFAULT 0,
    newopera number DEFAULT 0,
    newlingua varchar2 DEFAULT null,
    newlivello varchar2 DEFAULT null,
    newtesto CLOB DEFAULT null
);

PROCEDURE StatisticheDescrizioni(

    operazione NUMBER DEFAULT 0
);
END gruppo2;
