create or replace package PackageVisite as

procedure inserisciVisita(
        DataVisitaChar in VARCHAR2,
        OraVisita in VARCHAR2,
        DurataVisita in NUMBER,
        idUtenteSelezionato in UTENTI.IdUtente%TYPE,
        idTitoloSelezionato in TITOLIINGRESSO.IDTITOLOING%TYPE
    );

procedure formVisita(
        DataVisitaChar in VARCHAR2 DEFAULT NULL,
        OraVisita in VARCHAR2 DEFAULT NULL,
        DurataVisita in NUMBER DEFAULT NULL,
        idUtenteSelezionato in UTENTI.IdUtente%TYPE DEFAULT NULL,
        idTitoloSelezionato in TITOLIINGRESSO.IDTITOLOING%TYPE DEFAULT NULL,
        convalida in BOOLEAN DEFAULT null
    );

procedure visualizzaVisita(
        idVisitaSelezionata in visite.IdVisita%TYPE
    );

end PackageVisite;
