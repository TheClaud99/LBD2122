CREATE OR REPLACE PACKAGE packageAcquistaTitoli AS

PROCEDURE select_museo (
    nome      VARCHAR2 DEFAULT 'id_museo',
    id        VARCHAR2 DEFAULT 'id_museo',
    id_museo  IN utenti.idutente%TYPE DEFAULT NULL
);

PROCEDURE select_utente (
    nome                 VARCHAR2 DEFAULT 'id_utente',
    id                   VARCHAR2 DEFAULT 'id_utente',
    idutenteselezionato  IN utenti.idutente%TYPE DEFAULT NULL
);

PROCEDURE select_tipologia (
        nome      VARCHAR2 DEFAULT 'id_tipologia',
        id        VARCHAR2 DEFAULT 'id_tipologia',
        id_tipologia  IN utenti.idutente%TYPE DEFAULT NULL
);

PROCEDURE modal_filtri_titoli (
        datefrom  IN  VARCHAR2 DEFAULT NULL,
        dateto    IN  VARCHAR2 DEFAULT NULL,
        id_utente         IN  NUMBER DEFAULT NULL,
        id_museo          IN  NUMBER DEFAULT NULL,
		id_tipologia	  IN  NUMBER DEFAULT NULL,
        is_biglietto      IN  NUMBER DEFAULT NULL,
        is_abbonamento    IN  NUMBER DEFAULT NULL,
        order_by          IN  VARCHAR2 DEFAULT 'IDTITOLO',
        sort_method       IN  VARCHAR2 DEFAULT 'ASC'
);

FUNCTION build_query (
        datefrom  IN  VARCHAR2 DEFAULT NULL,
        dateto    IN  VARCHAR2 DEFAULT NULL,
        id_utente         IN  NUMBER DEFAULT NULL,
        id_museo          IN  NUMBER DEFAULT NULL,
		id_tipologia	  IN  NUMBER DEFAULT NULL,
        is_biglietto      IN  NUMBER DEFAULT NULL,
        is_abbonamento    IN  NUMBER DEFAULT NULL,
        order_by          IN  VARCHAR2 DEFAULT 'IDTITOLO',
        sort_method       IN  VARCHAR2 DEFAULT 'ASC',
		idclientelogged IN utentilogin.IDCLIENTE%type DEFAULT NULL
) RETURN VARCHAR2;

function n_risultati(
	    datefrom  IN  VARCHAR2 DEFAULT NULL,
        dateto    IN  VARCHAR2 DEFAULT NULL,
        id_utente         IN  NUMBER DEFAULT NULL,
        id_museo          IN  NUMBER DEFAULT NULL,
		id_tipologia	  IN  NUMBER DEFAULT NULL,
        is_biglietto      IN  NUMBER DEFAULT NULL,
        is_abbonamento    IN  NUMBER DEFAULT NULL,
		idclientelogged IN utentilogin.IDCLIENTE%type DEFAULT NULL
    )RETURN number;

PROCEDURE TitoliHome(
	datefrom varchar2 default null,
	dateto varchar2 default null,
	id_utente number default null,
	id_museo number default null,
	id_tipologia number default null,
	is_abbonamento number default null,
	is_biglietto number default null,
	order_by varchar2 default 'IDTITOLO',
	sort_method varchar2 default 'ASC'
);

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

procedure modificatitolo(
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