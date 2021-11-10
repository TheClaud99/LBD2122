CREATE OR REPLACE PACKAGE BODY packagevisite AS

    /*
    * OPERAZIONI SULLE VISITE
    * - Inserimento ✅
    * - Modifica �?�
    * - Visualizzazione �?�
    * - Cancellazione (rimozione) �?�
    * - Monitoraggio e statistiche
    * OPERAZIONI STATISTICHE E MONITORAGGIO
    * - Numero visitatori unici in un arco temporale scelto �?�
    * - Numero medio visitatori in un arco temporale scelto �?�
    * - Numero Visite effettuate con Abbonamenti in un arco temporale scelto �?�
    * - Numero Visite effettuate con Biglietti in un arco temporale scelto �?�
    * - Durata media di una visita in un arco temporale scelto �?�
    */

    PROCEDURE visualizzavisita (
        idvisitaselezionata IN visite.idvisita%TYPE
    ) IS
    BEGIN
        modgui1.apripagina();
        modgui1.header();
        modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
        modgui1.chiudidiv();
        htp.prn('</body>
        </html>');
    END;

    PROCEDURE inseriscivisita (
        datavisitachar       IN  VARCHAR2,
        oravisita            IN  VARCHAR2,
        duratavisita         IN  NUMBER,
        idutenteselezionato  IN  utenti.idutente%TYPE,
        idtitoloselezionato  IN  titoliingresso.idtitoloing%TYPE
    ) IS
        idvisitacreata visite.idvisita%TYPE;
    BEGIN
        idvisitacreata := idvisiteseq.nextval;
        INSERT INTO visite (
            idvisita,
            oravisita,
            datavisita,
            duratavisita,
            visitatore,
            titoloingresso
        ) VALUES (
            idvisitacreata,
            to_date(
                oravisita, 'HH24:MI:SS'
            ),
            to_date(
                datavisitachar, 'DD/MM/YYYY'
            ),
            duratavisita,
            idutenteselezionato,
            idtitoloselezionato
        );

        visualizzavisita(idvisitacreata);
    END;

    PROCEDURE formvisita (
        datavisitachar       IN  VARCHAR2 DEFAULT NULL,
        oravisita            IN  VARCHAR2 DEFAULT NULL,
        duratavisita         IN  NUMBER DEFAULT NULL,
        idutenteselezionato  IN  utenti.idutente%TYPE DEFAULT NULL,
        idtitoloselezionato  IN  titoliingresso.idtitoloing%TYPE DEFAULT NULL,
        convalida            IN  BOOLEAN DEFAULT NULL
    ) IS

        nomeutente     utenti.nome%TYPE;
        cognomeutente  utenti.cognome%TYPE;
        varidutente    utenti.idutente%TYPE;
    BEGIN
        modgui1.apripagina();
        modgui1.header();
        modgui1.apridiv('style="margin-top: 110px"');
        htp.prn('<h1>Inserimento visita</h1>');
        IF convalida IS NULL THEN
            modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
            modgui1.apriform(
                            'PackageVisite.formVisita',
                            'formCreaVisita',
                            'w3-container'
            );
            modgui1.apridiv('class="w3-section"');
            modgui1.label('Inserisci data della visita:');
            modgui1.inputdate(
                             'DataVisitaChar',
                             'DataVisitaChar'
            );
            htp.br;
            modgui1.label('Ora della visita');
            modgui1.inputtime(
                             'OraVisita',
                             'OraVisita'
            );
            htp.br;
            modgui1.label('Durata della visita (h)');
            modgui1.inputnumber(
                               'DurataVisita',
                               'DurataVisita'
            );
            htp.br;
            modgui1.label('Utente');
            modgui1.selectopen(
                              'idUtenteSelezionato',
                              'utente-selezionato'
            );
            FOR utente IN (
                SELECT
                    idutente
                FROM
                    utentimuseo
            ) LOOP
                SELECT
                    idutente,
                    nome,
                    cognome
                INTO
                    varidutente,
                    nomeutente,
                    cognomeutente
                FROM
                    utenti
                WHERE
                    idutente = utente.idutente;

                IF utente.idutente = idutenteselezionato THEN
                    modgui1.selectoption(
                                        varidutente,
                                        ''
                                        || nomeutente
                                        || ' '
                                        || cognomeutente
                                        || '',
                                        1
                    );

                ELSE
                    modgui1.selectoption(
                                        varidutente,
                                        ''
                                        || nomeutente
                                        || ' '
                                        || cognomeutente
                                        || '',
                                        0
                    );
                END IF;

            END LOOP;

            modgui1.selectclose();
            htp.br;
            modgui1.label('Titolo di ingresso');
            htp.prn('<select name="idTitoloSelezionato">');
            FOR titolo IN (
                SELECT
                    idtitoloing
                FROM
                    titoliingresso
                WHERE
                    acquirente = idutenteselezionato
            ) LOOP 
                                    -- todo Non andrebbe aggiunto un nome alla tipologia di ingresso? 
                                    -- select Nome into NomeTiologiaIngresso
                                    -- from TIPOLOGIEINGRESSO
                                    -- where IdTipologiaIng = titolo.Tipologia;
                IF titolo.idtitoloing = idtitoloselezionato THEN
                    modgui1.selectoption(
                                        titolo.idtitoloing,
                                        to_char(titolo.idtitoloing),
                                        1
                    );
                ELSE
                    modgui1.selectoption(
                                        titolo.idtitoloing,
                                        to_char(titolo.idtitoloing),
                                        0
                    );
                END IF;
            END LOOP;

            htp.prn('</select>');
            htp.br;
            htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit" name="convalida" value="true">Invia</button>');
            modgui1.chiudidiv;
            modgui1.chiudiform;
            modgui1.chiudidiv;
        ELSE
            inseriscivisita(
                           datavisitachar,
                           oravisita,
                           duratavisita,
                           idutenteselezionato,
                           idtitoloselezionato
            );
            htp.prn('<h1>Visita inserita</h1>');
        END IF;

        modgui1.chiudidiv();
        htp.prn('<script>
            document.getElementById("utente-selezionato").onchange = function inviaFormCreaVisite() {
                document.formCreaVisita.submit();
            }
        </script>');
        htp.prn('</body>
        </html>');
    END;

    PROCEDURE homepage IS
    BEGIN
        modgui1.apripagina();
        modgui1.header();
        modgui1.apridiv('style="margin-top: 110px"');
        htp.prn('<h1>Inserimento visita</h1>');
            -- operazioniGruppo3.formVisita();
        modgui1.chiudidiv();
        htp.prn('<script>
            function inviaFormCreaVisite() {
                document.formCreaVisita.submit();
            }
        </script>');
        htp.prn('</body>
        </html>');
    END;

END packagevisite;
