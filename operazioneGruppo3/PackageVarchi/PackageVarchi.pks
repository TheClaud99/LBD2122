create or replace PACKAGE packagevarchi AS
    PROCEDURE visualizzavarco (
        idvarcoselezionato in varchi.idvarchi%TYPE
    );

    PROCEDURE calcolarisultato (
        idvarco             in varchi.idvarchi%TYPE DEFAULT NULL,
        idstanzaselezionata in stanze.idstanza%TYPE DEFAULT NULL,
        datainizio          VARCHAR2 DEFAULT NULL,
        datafine            VARCHAR2 DEFAULT NULL,
        orainizio           VARCHAR2 DEFAULT NULL,
        orafine             VARCHAR2 DEFAULT NULL,
        operazione          NUMBER
    );

    PROCEDURE statistichevarchi (
        idvarco             in varchi.idvarchi%TYPE DEFAULT NULL,
        idstanzaselezionata in stanze.idstanza%TYPE DEFAULT NULL,
        datainizio          VARCHAR2 DEFAULT NULL,
        datafine            VARCHAR2 DEFAULT NULL,
        orainizio           VARCHAR2 DEFAULT NULL,
        orafine             VARCHAR2 DEFAULT NULL,
        operazione          NUMBER DEFAULT 0
    );

    PROCEDURE menuvarchi (
        Search in VARCHAR2 DEFAULT NULL
    );

    PROCEDURE jsonstanze (
        idmuseo IN musei.idmuseo%TYPE
    );

    PROCEDURE inseriscivarco (
        nome      in VARCHAR2,
        sensore   in NUMBER,
        idstanza1 in stanze.idstanza%TYPE,
        idstanza2 in stanze.idstanza%TYPE
    );

    PROCEDURE formvarco (
        modifica in NUMBER DEFAULT 0,
        idVarcoSelezionato in VARCHI.idvarchi%TYPE DEFAULT NULL,
        Nome in VARCHAR2 DEFAULT NULL,
        Sensore in NUMBER DEFAULT NULL,
        idStanza1 in STANZE.IdStanza%TYPE DEFAULT NULL,
        idStanza2 in STANZE.IdStanza%TYPE DEFAULT NULL,
        convalida in NUMBER DEFAULT NULL
    );

    PROCEDURE modificavarco (
        idvarco      in varchi.idvarchi%TYPE DEFAULT NULL,
        newnome      in VARCHAR2 DEFAULT NULL,
        newsensore   in NUMBER DEFAULT NULL,
        newidstanza1 in stanze.idstanza%TYPE DEFAULT NULL,
        newidstanza2 in stanze.idstanza%TYPE DEFAULT NULL
    );

    PROCEDURE confermacancellazione (
        idvarcoselezionato in varchi.idvarchi%TYPE
    );

    PROCEDURE cancellazionevarco (
        idvarcoselezionato in varchi.idvarchi%TYPE
    );

END packagevarchi;