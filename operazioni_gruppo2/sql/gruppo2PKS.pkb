CREATE OR REPLACE PACKAGE gruppo2 AS

/* OPERAZIONI SULLE OPERE */
PROCEDURE coloreClassifica(posizione NUMBER DEFAULT 0);
PROCEDURE SpostamentiOpera (
    idSessione NUMBER DEFAULT 0,
    operaID NUMBER DEFAULT 0
);
PROCEDURE SpostaOpera(
        idSessione NUMBER DEFAULT 0,
        operaID NUMBER DEFAULT 0,
        salaID NUMBER DEFAULT 0
);
PROCEDURE SpostamentoOpera(
    idSessione NUMBER DEFAULT 0,
    operaID NUMBER DEFAULT 0,
    Esposizione NUMBER DEFAULT 0,
    NuovaSalaID NUMBER DEFAULT 0
);
PROCEDURE menuOpere (idSessione NUMBER DEFAULT NULL);
PROCEDURE selezioneMuseo(idSessione NUMBER DEFAULT 0);
PROCEDURE StatisticheOpere(
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
PROCEDURE AggiungiAutore(
    idSessione NUMBER DEFAULT 0,
    operaID NUMBER DEFAULT 0,
    lingue VARCHAR2 DEFAULT null
);
PROCEDURE AggiuntaAutore(
    idSessione NUMBER DEFAULT 0,
    operaID NUMBER DEFAULT 0,
    autoreID NUMBER DEFAULT 0,
    lingue VARCHAR2 default NULL
);

-- Rimuove un Autore dall'Opera indicata (pagina conferma)
PROCEDURE RimuoviAutoreOpera(
    idSessione NUMBER DEFAULT 0,
    operaID NUMBER DEFAULT 0,
    lingue VARCHAR2 DEFAULT null
);
-- Rimuove un Autore dall'Opera indicata
PROCEDURE RimozioneAutoreOpera(
    idSessione NUMBER DEFAULT 0,
    operaID NUMBER DEFAULT 0,
    autoreID NUMBER DEFAULT 0
);

PROCEDURE EliminazioneOpera(
    idSessione NUMBER default 0,
    operaID NUMBER default 0
);
PROCEDURE RimozioneOpera(
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
PROCEDURE VisualizzaOpera (
    idSessione NUMBER default 0,
    operaID NUMBER default 0,
    lingue VARCHAR2 default 'sconosciuto',
    livelli VARCHAR2 DEFAULT 'Sconosciuto'
);
PROCEDURE linguaELivello(
    idSessione NUMBER default 0,
    operaID NUMBER default 0
);
/* OPERAZIONI SUGLI AUTORI */
PROCEDURE menuAutori(idSessione NUMBER DEFAULT NULL);
PROCEDURE menuAutoriEliminati(idSessione NUMBER DEFAULT NULL);

PROCEDURE selezioneOpStatAut(idSessione NUMBER DEFAULT 0);

PROCEDURE selezioneAutoreStatistica(
    idSessione NUMBER DEFAULT 0,
    operazione NUMBER DEFAULT 0
);

PROCEDURE StatisticheAutori(
    idSessione NUMBER DEFAULT 0,
    operazione NUMBER DEFAULT 0,
    authID NUMBER DEFAULT 0
);

PROCEDURE selezioneMuseoAutoreStatistica(
    idSessione NUMBER DEFAULT 0,
    operazione NUMBER DEFAULT 0,
    authID NUMBER DEFAULT 0
);

PROCEDURE StatisticheMuseoAutori(
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
PROCEDURE ModificaAutore(
	idSessione NUMBER DEFAULT 0,
	authorID NUMBER DEFAULT 0,
    operazione NUMBER DEFAULT 0,
    caller VARCHAR2 DEFAULT NULL,
    callerParams VARCHAR2 DEFAULT ''
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

PROCEDURE EliminazioneAutore(
    idSessione NUMBER default 0,
    authorID NUMBER default 0
);

-- Setta l'attributo 'Eliminato' dell'autore a 1 => l'autore scompare dal menuAutori
-- e va in menuAutoriEliminati (ma non rimossi) 
procedure SetAutoreEliminato(
    idSessione NUMBER default 0,
    authorID NUMBER default 0
);

PROCEDURE RimozioneAutore(
    idSessione NUMBER default 0,
    authorID NUMBER default 0
);

PROCEDURE DeleteAutore(
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

PROCEDURE EliminazioneDescrizione(
    idSessione NUMBER default 0,
    idDescrizione NUMBER default 0
);

PROCEDURE RimozioneDescrizione(
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

PROCEDURE StatisticheDescrizioni(
    idSessione NUMBER DEFAULT 0,
    operazione NUMBER DEFAULT 0
);
END gruppo2;