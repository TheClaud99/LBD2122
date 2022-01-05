CREATE OR REPLACE PACKAGE gruppo1 AS

PROCEDURE ListaTipologieIng;

PROCEDURE InserisciTipologiaIng;

PROCEDURE ConfermaTipologiaIng(
	nome VARCHAR2 DEFAULT NULL,
	costoTotale NUMBER DEFAULT NULL,
	limiteSale NUMBER DEFAULT NULL,
	limiteTempo NUMBER DEFAULT NULL,
    durata VARCHAR2 DEFAULT NULL,
	tipo VARCHAR2 DEFAULT NULL,
	numPersone NUMBER DEFAULT NULL 
);

PROCEDURE InserisciDatiTipologieIng (
	nome VARCHAR2 DEFAULT NULL,
	costoTotale NUMBER DEFAULT NULL,
	limiteSale NUMBER DEFAULT NULL,
	limiteTempo NUMBER DEFAULT NULL,
    durata VARCHAR2 DEFAULT NULL,
	tipo VARCHAR2 DEFAULT NULL,
	numPersone NUMBER DEFAULT NULL 
);


PROCEDURE VisualizzaDatiTitoloIng(
	tipologiaIngID NUMBER 
);

PROCEDURE ModificaDatiTitoloIng(
	tipologiaIngID NUMBER
);

PROCEDURE ConfermaModificaTipologiaIng(
	IdTipologiaIng NUMBER DEFAULT NULL,
	nomeNew VARCHAR2 DEFAULT NULL,
	costoTotaleNew NUMBER DEFAULT NULL,
	limiteSaleNew NUMBER DEFAULT NULL,
	limiteTempoNew NUMBER DEFAULT NULL,
    durataNew VARCHAR2 DEFAULT NULL,
	tipo VARCHAR2 DEFAULT NULL,
	numPersoneNew NUMBER DEFAULT NULL,
	ripristinaEliminato VARCHAR2 DEFAULT NULL
);

PROCEDURE ModificaDatiTipologieIng (
	IdTipologia NUMBER DEFAULT NULL,
	nomeNew VARCHAR2 DEFAULT NULL,
	costoTotaleNew NUMBER DEFAULT NULL,
	limiteSaleNew NUMBER DEFAULT NULL,
	limiteTempoNew NUMBER DEFAULT NULL,
    durataNew VARCHAR2 DEFAULT NULL,
	tipo VARCHAR2 DEFAULT NULL,
	numPersoneNew NUMBER DEFAULT NULL,
	ripristinaEliminato VARCHAR2 DEFAULT NULL 
);

procedure CancellazioneTipologiaIng(
	tipologiaIngID NUMBER
);

PROCEDURE VisualizzaTipologieIngOrdine;

PROCEDURE VisualizzaTipologieEliminate;

procedure TipologiaPiuScelta(
	dataInizioFun VARCHAR2 DEFAULT NULL,
	dataFineFun VARCHAR2 DEFAULT NULL
);

procedure StatisticheTipologieIng;


END gruppo1;