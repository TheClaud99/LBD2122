CREATE OR REPLACE PACKAGE packagevisite AS
    PROCEDURE inseriscivisita (
        datavisitachar       IN  VARCHAR2,
        oravisita            IN  VARCHAR2,
        duratavisita         IN  NUMBER,
        idutenteselezionato  IN  utenti.idutente%TYPE,
        idtitoloselezionato  IN  titoliingresso.idtitoloing%TYPE
    );

    PROCEDURE formvisita (
        datavisitachar       IN  VARCHAR2 DEFAULT NULL,
        oravisita            IN  VARCHAR2 DEFAULT NULL,
        duratavisita         IN  NUMBER DEFAULT NULL,
        idutenteselezionato  IN  utenti.idutente%TYPE DEFAULT NULL,
        idtitoloselezionato  IN  titoliingresso.idtitoloing%TYPE DEFAULT NULL,
        action               IN  VARCHAR2 DEFAULT ''
    );

    PROCEDURE pagina_modifica_visita (
        idvisitaselezionata  IN  visite.idvisita%TYPE,
        datavisitachar       IN  VARCHAR2 DEFAULT NULL,
        oravisita            IN  VARCHAR2 DEFAULT NULL,
        duratavisita         IN  NUMBER DEFAULT NULL,
        idutenteselezionato  IN  utenti.idutente%TYPE DEFAULT NULL,
        idtitoloselezionato  IN  titoliingresso.idtitoloing%TYPE DEFAULT NULL,
        carica_default       IN  NUMBER DEFAULT 0,
        convalida            IN  NUMBER DEFAULT NULL
    );

    PROCEDURE pagina_inserisci_visita (
        datavisitachar       IN  VARCHAR2 DEFAULT NULL,
        oravisita            IN  VARCHAR2 DEFAULT NULL,
        duratavisita         IN  NUMBER DEFAULT NULL,
        idutenteselezionato  IN  utenti.idutente%TYPE DEFAULT NULL,
        idtitoloselezionato  IN  titoliingresso.idtitoloing%TYPE DEFAULT NULL,
        convalida            IN  NUMBER DEFAULT NULL
    );

    PROCEDURE pagina_rimuovi_visita (
        idvisitaselezionata  IN  visite.idvisita%TYPE
    );

    PROCEDURE rimuovi_visita (
        idvisitaselezionata  IN  visite.idvisita%TYPE
    );

    PROCEDURE visualizzavisita (
        idvisitaselezionata  IN  visite.idvisita%TYPE,
        titolo               IN  VARCHAR2 DEFAULT NULL,
        action               IN  VARCHAR2 DEFAULT NULL
    );

    PROCEDURE visualizza_visite (
        idsessione INT DEFAULT 0
    );

END packagevisite;
