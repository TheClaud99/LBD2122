CREATE OR REPLACE PACKAGE packageAcquistaTitoli AS

 procedure TitoliHome;

PROCEDURE visualizzatitoloing(
	varidtitoloing titoliingresso.IDTITOLOING%type
);

PROCEDURE acquistatitolo(
	dataEmissionechar IN VARCHAR2,
	oraemissionechar in varchar2,
	idmuseoselezionato IN VARCHAR2,
	idtipologiaselezionata tipologieingresso.IDTIPOLOGIAING%type,
	idutenteselezionato IN VARCHAR2
);

PROCEDURE pagina_modifica_titolo(
	varidtitoloing titoliingresso.IDTITOLOING%type
);

procedure confermamodificatitolo(
	varidtitoloing TITOLIINGRESSO.IDTITOLOING%type,
	idutenteselezionato utenti.idutente%type
);

PROCEDURE formacquistaabbonamento(
	dataEmissionechar IN VARCHAR2,
	oraemissionechar IN VARCHAR2,
	idmuseoselezionato IN VARCHAR2 default null,
	idtipologiaselezionata IN VARCHAR2 default null,
	idutenteselezionato IN VARCHAR2 default null
);

PROCEDURE pagina_acquista_abbonamento(
	dataEmissionechar VARCHAR2 DEFAULT NULL,
	oraemissionechar VARCHAR2 DEFAULT NULL,
	idmuseoselezionato VARCHAR2 DEFAULT NULL,
	idtipologiaselezionata VARCHAR2 DEFAULT NULL,
	idutenteselezionato VARCHAR2 DEFAULT NULL,
	convalida IN NUMBER DEFAULT NULL
);

procedure formacquistabiglietto(
	dataEmissionechar IN VARCHAR2,
	oraemissionechar in varchar2,
	idmuseoselezionato IN VARCHAR2 default null,
	idtipologiaselezionata IN VARCHAR2 default null,
	idutenteselezionato IN VARCHAR2 default null
);

PROCEDURE pagina_acquista_biglietto(
	dataEmissionechar VARCHAR2 DEFAULT NULL,
	oraemissionechar VARCHAR2 DEFAULT NULL,
	idmuseoselezionato VARCHAR2 DEFAULT NULL,
	idtipologiaselezionata VARCHAR2 DEFAULT NULL,
	idutenteselezionato VARCHAR2 DEFAULT NULL,
	convalida IN NUMBER DEFAULT NULL
);

PROCEDURE confermaacquisto(
	dataEmissionechar VARCHAR2 DEFAULT NULL,
	oraemissionechar varchar2 default null,
	idmuseoselezionato VARCHAR2 DEFAULT NULL,
	idtipologiaselezionata VARCHAR2 DEFAULT NULL,
	idutenteselezionato VARCHAR2 DEFAULT NULL
);

PROCEDURE abbonamenti_in_scadenza;

END packageAcquistaTitoli;