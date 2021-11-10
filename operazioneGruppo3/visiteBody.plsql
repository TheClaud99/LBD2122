CREATE OR REPLACE PACKAGE BODY PackageVisite as

    /*
    * OPERAZIONI SULLE VISITE
    * - Inserimento ✅
    * - Modifica ❌
    * - Visualizzazione ❌
    * - Cancellazione (rimozione) ❌
    * - Monitoraggio e statistiche
    * OPERAZIONI STATISTICHE E MONITORAGGIO
    * - Numero visitatori unici in un arco temporale scelto ❌
    * - Numero medio visitatori in un arco temporale scelto ❌
    * - Numero Visite effettuate con Abbonamenti in un arco temporale scelto ❌
    * - Numero Visite effettuate con Biglietti in un arco temporale scelto ❌
    * - Durata media di una visita in un arco temporale scelto ❌
    */

    procedure visualizzaVisita(
        idVisitaSelezionata in visite.IdVisita%TYPE
    )
    is

    begin
        modGUI1.ApriPagina();
        modGUI1.Header();
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');

        modGUI1.ChiudiDiv();

        htp.prn('</body>
        </html>');
    end;

    procedure inserisciVisita(
        DataVisitaChar in VARCHAR2,
        OraVisita in VARCHAR2,
        DurataVisita in NUMBER,
        idUtenteSelezionato in UTENTI.IdUtente%TYPE,
        idTitoloSelezionato in TITOLIINGRESSO.IDTITOLOING%TYPE
    ) 
    is
        idVisitaCreata VISITE.IdVisita%TYPE;
    begin
        idVisitaCreata := IdVisiteSeq.nextval;
        INSERT INTO VISITE(IdVisita, OraVisita, DataVisita, DurataVisita, Visitatore, TitoloIngresso) 
        VALUES(idVisitaCreata, to_date(OraVisita, 'HH24:MI:SS'), to_date(DataVisitaChar, 'DD/MM/YYYY'), DurataVisita, idUtenteSelezionato, idTitoloSelezionato);
        visualizzaVisita(idVisitaCreata);
    end;

    procedure formVisita (
        DataVisitaChar in VARCHAR2 DEFAULT NULL,
        OraVisita in VARCHAR2 DEFAULT NULL,
        DurataVisita in NUMBER DEFAULT NULL,
        idUtenteSelezionato in UTENTI.IdUtente%TYPE DEFAULT NULL,
        idTitoloSelezionato in TITOLIINGRESSO.IDTITOLOING%TYPE DEFAULT NULL,
        convalida in BOOLEAN DEFAULT null
    )
    is
        NomeUtente UTENTI.Nome%TYPE;
        CognomeUtente UTENTI.Cognome%TYPE;
        varIdUtente UTENTI.IdUtente%TYPE;
    begin
        modGUI1.ApriPagina();
        modGUI1.Header();
        modGUI1.ApriDiv('style="margin-top: 110px"');
            htp.prn('<h1>Inserimento visita</h1>');

            IF convalida IS NULL THEN
                modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
                    modGUI1.ApriForm('PackageVisite.formVisita', 'formCreaVisita','w3-container');
                        modGUI1.ApriDiv('class="w3-section"');
                            modGUI1.Label('Inserisci data della visita:');
                            modGUI1.InputDate('DataVisitaChar', 'DataVisitaChar');
                            htp.br;

                            modGUI1.Label('Ora della visita');
                            modGUI1.InputTime('OraVisita', 'OraVisita');
                            htp.br;

                            modGUI1.Label('Durata della visita (h)');
                            modGUI1.InputNumber('DurataVisita', 'DurataVisita');
                            htp.br;

                            modGUI1.Label('Utente');
                            modGUI1.SelectOpen('idUtenteSelezionato', 'utente-selezionato');
                                for utente in (select IdUtente from UTENTIMUSEO)
                                loop 
                                    select IdUtente, Nome, Cognome into varIdUtente, NomeUtente, CognomeUtente
                                    from UTENTI
                                    where IdUtente = utente.IdUtente;
                                    IF utente.IdUtente = idUtenteSelezionato
                                    THEN
                                        modGUI1.SelectOption(varIdUtente, ''|| NomeUtente ||' '|| CognomeUtente ||'', 1);
                                    ELSE
                                        modGUI1.SelectOption(varIdUtente, ''|| NomeUtente ||' '|| CognomeUtente ||'', 0);
                                    END IF;
                                end loop;
                            modGUI1.SelectClose();
                            htp.br;

                            modGUI1.Label('Titolo di ingresso');
                            htp.prn('<select name="idTitoloSelezionato">');
                                for titolo in (select IdTitoloing  from TITOLIINGRESSO where Acquirente = idUtenteSelezionato)
                                loop 
                                    -- todo Non andrebbe aggiunto un nome alla tipologia di ingresso? 
                                    -- select Nome into NomeTiologiaIngresso
                                    -- from TIPOLOGIEINGRESSO
                                    -- where IdTipologiaIng = titolo.Tipologia;
                                    IF titolo.IdTitoloing = idTitoloSelezionato
                                    THEN
                                        modGUI1.SelectOption(titolo.IdTitoloing, TO_CHAR(titolo.IdTitoloing), 1);
                                    ELSE
                                        modGUI1.SelectOption(titolo.IdTitoloing, TO_CHAR(titolo.IdTitoloing), 0);
                                    END IF;
                                end loop;
                            htp.prn('</select>');
                            htp.br;

                            htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit" name="convalida" value="true">Invia</button>');
                        modGUI1.ChiudiDiv;
                    modGUI1.ChiudiForm;
                modGUI1.ChiudiDiv;
            ELSE
                inserisciVisita(DataVisitaChar, OraVisita, DurataVisita, idUtenteSelezionato, idTitoloSelezionato);
                htp.prn('<h1>Visita inserita</h1>');
            END IF;
        modGUI1.ChiudiDiv();
        htp.prn('<script>
            function inviaFormCreaVisite() {
                document.formCreaVisita.submit();
            }
        </script>');
        htp.prn('</body>
        </html>');
    end;

    procedure homepage is
    begin
        modGUI1.ApriPagina();
        modGUI1.Header();
        modGUI1.ApriDiv('style="margin-top: 110px"');
            htp.prn('<h1>Inserimento visita</h1>');
            -- operazioniGruppo3.formVisita();
        modGUI1.ChiudiDiv();

        htp.prn('<script>
            function inviaFormCreaVisite() {
                document.formCreaVisita.submit();
            }
        </script>');

        htp.prn('</body>
        </html>');
    end;

end PackageVisite;