SET DEFINE OFF;

CREATE OR REPLACE PACKAGE BODY packagevisite AS

    /*
    * OPERAZIONI SULLE VISITE
    * - Inserimento ✅
    * - Modifica ✅
    * - Visualizzazione ✅
    * - Cancellazione (rimozione) ✅
    * - Monitoraggio e statistiche
    * OPERAZIONI STATISTICHE E MONITORAGGIO
    * - Numero visitatori unici in un arco temporale scelto �?�
    * - Numero medio visitatori in un arco temporale scelto �?�
    * - Numero Visite effettuate con Abbonamenti in un arco temporale scelto �?�
    * - Numero Visite effettuate con Biglietti in un arco temporale scelto �?�
    * - Durata media di una visita in un arco temporale scelto �?�
    */

    PROCEDURE tabella_dati_visita (
        datavisitachar       IN  VARCHAR2,
        oravisita            IN  VARCHAR2,
        duratavisita         IN  NUMBER,
        idutenteselezionato  IN  utenti.idutente%TYPE,
        idtitoloselezionato  IN  titoliingresso.idtitoloing%TYPE
    ) IS

        nomeutente      utenti.nome%TYPE;
        cognomeutente   utenti.cognome%TYPE;
        nome_tipologia  tipologieingresso.nome%TYPE;
    BEGIN
        modgui1.apridiv('style="margin-left: 2%; margin-right: 2%;"');
        htp.header(
                  2,
                  'Dati visita'
        );
        htp.tableopen;
        htp.tablerowopen;
        htp.tabledata('Data visita: ');
        htp.tabledata(datavisitachar);
        htp.tablerowclose;
        htp.tablerowopen;
        htp.tabledata('Ora visita: ');
        htp.tabledata(oravisita);
        htp.tablerowclose;
        htp.tablerowopen;
        htp.tabledata('Durata visita: ');
        htp.tabledata(duratavisita);
        htp.tablerowclose;
        htp.tablerowopen;
        htp.tabledata('Utente: ');
        SELECT
            nome,
            cognome
        INTO
            nomeutente,
            cognomeutente
        FROM
            utenti
        WHERE
            idutente = idutenteselezionato;

        htp.tabledata(nomeutente
                      || ' '
                      || cognomeutente);
        htp.tablerowclose;
        htp.tablerowopen;
        htp.tabledata('Tipologia ingresso: ');
        SELECT
            nome
        INTO nome_tipologia
        FROM
            titoliingresso
            JOIN tipologieingresso ON tipologieingresso.idtipologiaing = titoliingresso.tipologia
        WHERE
            idtitoloing = idtitoloselezionato;

        htp.tabledata(nome_tipologia);
        htp.tablerowclose;
        htp.tableclose;
        modgui1.chiudidiv;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || sqlerrm);
    END;

    PROCEDURE visualizzavisita (
        idvisitaselezionata  IN  visite.idvisita%TYPE,
        titolo               IN  VARCHAR2 DEFAULT NULL,
        action               IN  VARCHAR2 DEFAULT NULL,
        button_text          IN  VARCHAR2 DEFAULT NULL
    ) IS
        visita visite%rowtype;
    BEGIN
        modgui1.apripagina(
                          'Visualizza visita',
                          modgui1.get_id_sessione
        );
        modgui1.header(modgui1.get_id_sessione);
        modgui1.apridiv('style="margin-top: 110px"');
        BEGIN
            SELECT
                *
            INTO visita
            FROM
                visite
            WHERE
                idvisita = idvisitaselezionata;

            IF titolo IS NOT NULL THEN
                htp.header(
                          2,
                          titolo,
                          'center'
                );
            END IF;

            modgui1.apridivcard();
            modgui1.collegamento(
                                'X',
                                'packageVisite.visualizza_visite',
                                ' w3-btn w3-large w3-red w3-display-topright'
            );
            tabella_dati_visita(
                               to_char(
                                      visita.datavisita,
                                      'YYYY/MM/DD'
                               ),
                               to_char(
                                      visita.datavisita,
                                      'HH24:MI'
                               ),
                               visita.duratavisita,
                               visita.visitatore,
                               visita.titoloingresso
            );

            IF action IS NOT NULL THEN
                modgui1.apriform(
                                action,
                                'formVisualizza'
                );
                modgui1.inputsubmit(
                                   CASE
                                       WHEN button_text IS NULL THEN
                                           'Conferma'
                                       ELSE button_text
                                   END
                );
                modgui1.chiudiform;
            END IF;

            modgui1.chiudidiv();
        EXCEPTION
            WHEN no_data_found THEN
                htp.header(
                          2,
                          'Visita non trovata',
                          'center'
                );
        END;

        modgui1.chiudidiv();
        htp.prn('</body>
        </html>');
    END;

    PROCEDURE visualizza_visite IS
        id_sessione NUMBER(10) := NULL;
    BEGIN
        id_sessione := modgui1.get_id_sessione;
        modgui1.apripagina(
                          'Visite',
                          id_sessione
        );
        modgui1.header(id_sessione);
        modgui1.apridiv('style="margin-top: 110px"');
        modgui1.apridiv('class="w3-center"');
        htp.prn('<h1>Visite</h1>');
        IF ( id_sessione = 1 ) THEN
            modgui1.collegamento(
                                'Aggiungi',
                                'PackageVisite.pagina_inserisci_visita',
                                'w3-btn w3-round-xxlarge w3-black'
            ); /*bottone che rimanda alla procedura inserimento solo se la sessione è 1*/
        END IF;

        modgui1.chiudidiv;
        htp.br;
        modgui1.apridiv('class="w3-row w3-container"');
        --INIZIO LOOP DELLA VISUALIZZAZIONE
        FOR visita IN (
            SELECT
                *
            FROM
                visite
        ) LOOP
            modgui1.apridiv('class="w3-col l4 w3-padding-large w3-center"');
            modgui1.apridiv('class="w3-card-4"');
            htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%">');
            modgui1.apridiv('class="w3-container w3-center"');
            tabella_dati_visita(
                               to_char(
                                      visita.datavisita,
                                      'YYYY/MM/DD'
                               ),
                               to_char(
                                      visita.datavisita,
                                      'HH24:MI'
                               ),
                               visita.duratavisita,
                               visita.visitatore,
                               visita.titoloingresso
            );

            modgui1.chiudidiv;
            modgui1.collegamento(
                                'Visualizza',
                                'packagevisite.visualizzavisita?idvisitaselezionata='
                                || visita.idvisita
                                || '&titolo=Visita+numero+'
                                || visita.idvisita
                                || '&action=packageVisite.visualizza_visite&button_text=Trona+alla+home',
                                'w3-button w3-margin w3-black'
            );

            IF ( hasrole(
                        id_sessione,
                        'AB'
                 ) OR hasrole(
                             id_sessione,
                             'SU'
                      ) OR hasrole(
                                  id_sessione,
                                  'DBA'
                           ) ) THEN
                modgui1.collegamento(
                                    'Modifica',
                                    'packagevisite.pagina_modifica_visita?carica_default=1&idvisitaselezionata=' || visita.idvisita,
                                    'w3-button w3-margin w3-green'
                );
                modgui1.collegamento(
                                    'Rimuovi',
                                    'packagevisite.pagina_rimuovi_visita?idvisitaselezionata=' || visita.idvisita,
                                    'w3-button w3-margin w3-red'
                );
            END IF;

            modgui1.chiudidiv;
            modgui1.chiudidiv;
        END LOOP;

        modgui1.chiudidiv();
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
            datavisita,
            duratavisita,
            visitatore,
            titoloingresso
        ) VALUES (
            idvisitacreata,
            to_date(
                oravisita
                || ' '
                || datavisitachar, 'HH24:MI YYYY/MM/DD'
            ),
            duratavisita,
            idutenteselezionato,
            idtitoloselezionato
        );

        visualizzavisita(
                        idvisitacreata,
                        'Visita creata',
                        'PackageVisite.visualizza_visite'
        );
    END;

    PROCEDURE modifica_visita (
        idvisitaselezionata  IN  visite.idvisita%TYPE,
        datavisitachar       IN  VARCHAR2,
        oravisita            IN  VARCHAR2,
        var_duratavisita     IN  NUMBER,
        idutenteselezionato  IN  utenti.idutente%TYPE,
        idtitoloselezionato  IN  titoliingresso.idtitoloing%TYPE
    ) IS
    BEGIN
        UPDATE visite
        SET
            datavisita = to_date(
                oravisita
                || ' '
                || datavisitachar, 'HH24:MI YYYY/MM/DD'
            ),
            duratavisita = var_duratavisita,
            visitatore = idutenteselezionato,
            titoloingresso = idtitoloselezionato
        WHERE
            idvisita = idvisitaselezionata;

        visualizzavisita(
                        idvisitaselezionata,
                        'Visita aggiornata',
                        'PackageVisite.visualizza_visite',
                        'Torna ad home'
        );
    END;

    PROCEDURE rimuovi_visita (
        idvisitaselezionata IN visite.idvisita%TYPE
    ) IS
    BEGIN
        DELETE FROM visite
        WHERE
            idvisita = idvisitaselezionata;

        modgui1.apripagina(
                          'Elimina visita',
                          modgui1.get_id_sessione
        );
        modgui1.header(modgui1.get_id_sessione);
        modgui1.apridiv('style="margin-top: 110px"');
        htp.header(
                  2,
                  'Visita eliminata',
                  'center'
        );
        htp.prn('<a href="'
                || costanti.server
                || costanti.radice
                || 'PackageVisite.visualizza_visite" style="display: block; margin: 0 auto; max-width: 200px;" class="w3-btn w3-round-xxlarge w3-black">Torna alla home</a>');

        modgui1.chiudidiv;
        htp.bodyclose;
        htp.htmlclose;
    END;

    PROCEDURE formvisita (
        datavisitachar       IN  VARCHAR2 DEFAULT NULL,
        oravisita            IN  VARCHAR2 DEFAULT NULL,
        duratavisita         IN  NUMBER DEFAULT NULL,
        idutenteselezionato  IN  utenti.idutente%TYPE DEFAULT NULL,
        idtitoloselezionato  IN  titoliingresso.idtitoloing%TYPE DEFAULT NULL,
        action               IN  VARCHAR2 DEFAULT ''
    ) IS

        nomeutente     utenti.nome%TYPE;
        cognomeutente  utenti.cognome%TYPE;
        varidutente    utenti.idutente%TYPE;
        tipologia      tipologieingresso%rowtype;
    BEGIN
        modgui1.apridivcard();
        modgui1.apriform(
                        action,
                        'formCreaVisita',
                        'w3-container'
        );
        modgui1.apridiv('class="w3-section"');
        modgui1.label('Inserisci data della visita:');
        modgui1.inputdate(
                         'DataVisitaChar',
                         'DataVisitaChar',
                         1,
                         datavisitachar
        );
        htp.br;
        modgui1.label('Ora della visita');
        modgui1.inputtime(
                         'OraVisita',
                         'OraVisita',
                         1,
                         oravisita
        );
        htp.br;
        modgui1.label('Durata della visita (h)');
        modgui1.inputnumber(
                           'DurataVisita',
                           'DurataVisita',
                           1,
                           duratavisita
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
                                    nomeutente
                                    || ' '
                                    || cognomeutente,
                                    1
                );
            ELSE
                modgui1.selectoption(
                                    varidutente,
                                    nomeutente
                                    || ' '
                                    || cognomeutente,
                                    0
                );
            END IF;

        END LOOP;

        modgui1.emptyselectoption(
                                 CASE
                                     WHEN idutenteselezionato IS NULL THEN
                                         1
                                     ELSE 0
                                 END
        );
        modgui1.selectclose();
        htp.br;
        modgui1.label('Titolo di ingresso');
        modgui1.selectopen(
                          'idTitoloSelezionato',
                          'titolo-selezionato'
        );
        FOR titolo IN (
            SELECT
                idtitoloing,
                tipologia
            FROM
                titoliingresso
            WHERE
                acquirente = idutenteselezionato
        ) LOOP
            SELECT
                *
            INTO tipologia
            FROM
                tipologieingresso
            WHERE
                idtipologiaing = titolo.tipologia;

            IF titolo.idtitoloing = idtitoloselezionato THEN
                modgui1.selectoption(
                                    titolo.idtitoloing,
                                    tipologia.nome,
                                    1
                );
            ELSE
                modgui1.selectoption(
                                    titolo.idtitoloing,
                                    tipologia.nome,
                                    0
                );
            END IF;

        END LOOP;

        modgui1.selectclose();
        htp.br;
        htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit" name="convalida" value="1">Invia</button>');
        modgui1.chiudidiv;
        modgui1.chiudiform;
        modgui1.chiudidiv;
        htp.prn('<script>
            document.getElementById("utente-selezionato").onchange = function inviaFormCreaVisite() {
                document.formCreaVisita.submit();
            }
        </script>');
    END;

    PROCEDURE conferma_dati_visita (
        datavisitachar       IN  VARCHAR2 DEFAULT NULL,
        oravisita            IN  VARCHAR2 DEFAULT NULL,
        duratavisita         IN  NUMBER DEFAULT NULL,
        idutenteselezionato  IN  utenti.idutente%TYPE DEFAULT NULL,
        idtitoloselezionato  IN  titoliingresso.idtitoloing%TYPE DEFAULT NULL
    ) IS
    BEGIN
        modgui1.apridivcard();
        tabella_dati_visita(
                           datavisitachar,
                           oravisita,
                           duratavisita,
                           idutenteselezionato,
                           idtitoloselezionato
        );
        modgui1.apriform('packagevisite.InserisciVisita');
        htp.formhidden(
                      'datavisitachar',
                      datavisitachar
        );
        htp.formhidden(
                      'oravisita',
                      oravisita
        );
        htp.formhidden(
                      'duratavisita',
                      duratavisita
        );
        htp.formhidden(
                      'idutenteselezionato',
                      idutenteselezionato
        );
        htp.formhidden(
                      'idtitoloselezionato',
                      idtitoloselezionato
        );
        modgui1.inputsubmit('Conferma');
        htp.prn('<input id="button_annulla" type="submit" class="w3-button w3-block w3-black w3-section w3-padding" value="Annulla">');
        modgui1.chiudiform;
        modgui1.chiudidiv();
        htp.prn('<script>
            let button_annulla = document.getElementById("button_annulla");
            button_annulla.onclick = function goBack() {
                let form = button_annulla.form;
                form.action = "'
                || costanti.server
                || costanti.radice
                || 'packagevisite.pagina_inserisci_visita";
                form.submit();
            }
        </script>');

    END;

    PROCEDURE pagina_modifica_visita (
        idvisitaselezionata  IN  visite.idvisita%TYPE,
        datavisitachar       IN  VARCHAR2 DEFAULT NULL,
        oravisita            IN  VARCHAR2 DEFAULT NULL,
        duratavisita         IN  NUMBER DEFAULT NULL,
        idutenteselezionato  IN  utenti.idutente%TYPE DEFAULT NULL,
        idtitoloselezionato  IN  titoliingresso.idtitoloing%TYPE DEFAULT NULL,
        carica_default       IN  NUMBER DEFAULT 0,
        convalida            IN  NUMBER DEFAULT NULL
    ) IS
        visita visite%rowtype;
    BEGIN
        modgui1.apripagina(
                          'Modifica visita',
                          modgui1.get_id_sessione
        );
        modgui1.header(modgui1.get_id_sessione);
        modgui1.apridiv('style="margin-top: 110px"');
        htp.prn('<h1>Modifica visita</h1>');
        IF convalida IS NULL THEN
            IF carica_default = 1 THEN
                SELECT
                    *
                INTO visita
                FROM
                    visite
                WHERE
                    idvisita = idvisitaselezionata;

                formvisita(
                          to_char(
                                 visita.datavisita,
                                 'YYYY/MM/DD'
                          ),
                          to_char(
                                 visita.datavisita,
                                 'HH24:MI'
                          ),
                          visita.duratavisita,
                          visita.visitatore,
                          visita.titoloingresso,
                          'PackageVisite.pagina_modifica_visita'
                );

            ELSE
                formvisita(
                          datavisitachar,
                          oravisita,
                          duratavisita,
                          idutenteselezionato,
                          idtitoloselezionato,
                          'PackageVisite.pagina_modifica_visita'
                );
            END IF;
        ELSE
            modifica_visita(
                           idvisitaselezionata,
                           datavisitachar,
                           oravisita,
                           duratavisita,
                           idutenteselezionato,
                           idtitoloselezionato
            );
        END IF;

        modgui1.chiudidiv();
        htp.prn('<script>
            window.addEventListener("load", function() {
                let form = document.formCreaVisita;
                form.insertAdjacentHTML("afterbegin", ''<input type="hidden" name="idvisitaselezionata" value="'
                || idvisitaselezionata
                || '">'');
            });
        </script>');
        htp.prn('</body>
        </html>');
    END;

    PROCEDURE pagina_rimuovi_visita (
        idvisitaselezionata IN visite.idvisita%TYPE
    ) IS
    BEGIN
        visualizzavisita(
                        idvisitaselezionata,
                        'Elimina visita',
                        'PackageVisite.rimuovi_visita'
        );
        htp.prn('<script>
            window.addEventListener("load", function() {
                let form = document.formVisualizza;
                form.insertAdjacentHTML("afterbegin", ''<input type="hidden" name="idvisitaselezionata" value="'
                || idvisitaselezionata
                || '">'');
            });
        </script>');
    END;

    PROCEDURE pagina_inserisci_visita (
        datavisitachar       IN  VARCHAR2 DEFAULT NULL,
        oravisita            IN  VARCHAR2 DEFAULT NULL,
        duratavisita         IN  NUMBER DEFAULT NULL,
        idutenteselezionato  IN  utenti.idutente%TYPE DEFAULT NULL,
        idtitoloselezionato  IN  titoliingresso.idtitoloing%TYPE DEFAULT NULL,
        convalida            IN  NUMBER DEFAULT NULL
    ) IS
    BEGIN
        modgui1.apripagina(
                          'Inserisci nuova visita',
                          modgui1.get_id_sessione
        );
        modgui1.header(modgui1.get_id_sessione);
        modgui1.apridiv('style="margin-top: 110px"');
        htp.prn('<h1>Inserimento visita</h1>');
        IF convalida IS NULL THEN
            formvisita(
                      datavisitachar,
                      oravisita,
                      duratavisita,
                      idutenteselezionato,
                      idtitoloselezionato,
                      'PackageVisite.pagina_inserisci_visita'
            );
        ELSE
            htp.prn('<h1>Conferma dati visita</h1>');
            conferma_dati_visita(
                                datavisitachar,
                                oravisita,
                                duratavisita,
                                idutenteselezionato,
                                idtitoloselezionato
            );
        END IF;

        modgui1.chiudidiv();
        htp.prn('</body>
        </html>');
    END;

END packagevisite;
