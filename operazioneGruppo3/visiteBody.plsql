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
        modgui1.apridivcard();
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
            idvisiteseq.NEXTVAL,
            to_date(
                oravisita
                || ' '
                || datavisitachar, 'HH24:MI YYYY/MM/DD'
            ),
            duratavisita,
            idutenteselezionato,
            idtitoloselezionato
        );

        -- visualizzavisita(idvisitacreata);
    END;

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
	-- se utente non autorizzato: messaggio errore
        modgui1.apridiv('style="margin-left: 2%; margin-right: 2%;"');
        htp.header(
                  2,
                  'Nuovo utente'
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

    PROCEDURE formvisita (
        datavisitachar       IN  VARCHAR2 DEFAULT NULL,
        oravisita            IN  VARCHAR2 DEFAULT NULL,
        duratavisita         IN  NUMBER DEFAULT NULL,
        idutenteselezionato  IN  utenti.idutente%TYPE DEFAULT NULL,
        idtitoloselezionato  IN  titoliingresso.idtitoloing%TYPE DEFAULT NULL
    ) IS

        nomeutente      utenti.nome%TYPE;
        cognomeutente   utenti.cognome%TYPE;
        varidutente     utenti.idutente%TYPE;
        nome_tipologia  tipologieingresso.durata%TYPE;
    BEGIN
        modgui1.apridivcard();
        modgui1.apriform(
                        'PackageVisite.pagina_inserisci_visita',
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
                nome
            INTO nome_tipologia
            FROM
                tipologieingresso
            WHERE
                idtipologiaing = titolo.tipologia;

            IF titolo.idtitoloing = idtitoloselezionato THEN
                modgui1.selectoption(
                                    titolo.idtitoloing,
                                    nome_tipologia,
                                    1
                );
            ELSE
                modgui1.selectoption(
                                    titolo.idtitoloing,
                                    nome_tipologia,
                                    0
                );
            END IF;

        END LOOP;

        htp.prn('</select>');
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
        modgui1.chiudiform;
        modgui1.collegamento(
                            'Annulla',
                            'packagevisite.pagina_inserisci_visita',
                            'w3-btn'
        );
        modgui1.chiudidiv();
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
        modgui1.apripagina();
        modgui1.header();
        modgui1.apridiv('style="margin-top: 110px"');
        htp.prn('<h1>Inserimento visita</h1>');
        IF convalida IS NULL THEN
            formvisita(
                      datavisitachar,
                      oravisita,
                      duratavisita,
                      idutenteselezionato,
                      idtitoloselezionato
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
