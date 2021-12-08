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
        idtitoloselezionato  IN  titoliingresso.idtitoloing%TYPE,
        id_museo             IN  musei.idmuseo%TYPE DEFAULT NULL
    ) IS

        nomeutente      utenti.nome%TYPE;
        cognomeutente   utenti.cognome%TYPE;
        nome_tipologia  tipologieingresso.nome%TYPE;
        id_tipologia    tipologieingresso.nome%TYPE;
        nome_museo      musei.nome%TYPE;
    BEGIN
        htp.prn('<div class="w3-row">');
        htp.prn('<div class="w3-col s3 w3-center"><p>Data visita:</p></div>');
        htp.prn('<div class="w3-col s9 w3-center"><p>'
                || datavisitachar
                || '</p></div>');
        htp.prn('</div>');
        htp.prn('<div class="w3-row">');
        htp.prn('<div class="w3-col s3 w3-center"><p>Ora visita:</p></div>');
        htp.prn('<div class="w3-col s9 w3-center"><p>'
                || oravisita
                || '</p></div>');
        htp.prn('</div>');
        htp.prn('<div class="w3-row">');
        htp.prn('<div class="w3-col s3 w3-center"><p>Durata visita:</p></div>');
        htp.prn('<div class="w3-col s9 w3-center"><p>'
                || duratavisita
                || '</p></div>');
        htp.prn('</div>');
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

        htp.prn('<div class="w3-row">');
        htp.prn('<div class="w3-col s3 w3-center"><p>Utente:</p></div>');
        htp.prn('<div class="w3-col s9 w3-center"><p>'
                || nomeutente
                || ' '
                || cognomeutente
                || '</p></div>');

        htp.prn('</div>');
        SELECT
            nome,
            idtipologiaing
        INTO
            nome_tipologia,
            id_tipologia
        FROM
            titoliingresso
            JOIN tipologieingresso ON tipologieingresso.idtipologiaing = titoliingresso.tipologia
        WHERE
            idtitoloing = idtitoloselezionato;

        htp.prn('<div class="w3-row">');
        htp.prn('<div class="w3-col s3 w3-center"><p>Titolo / Tipologia ingresso:</p></div>');
        htp.prn('<div class="w3-col s9 w3-center"><p>');
        modgui1.collegamento(
                            idtitoloselezionato,
                            'packageAcquistaTitoli.visualizzatitoloing?varidtitoloing=' || idtitoloselezionato
        );
        htp.prn(' / ');
        modgui1.collegamento(
                            nome_tipologia,
                            'operazioniGruppo1.visualizzaTipologia?idTipologia=' || id_tipologia
        );
        htp.prn('</p></div>');
        htp.prn('</div>');
        IF id_museo IS NOT NULL THEN
            SELECT
                nome
            INTO nome_museo
            FROM
                musei
            WHERE
                idmuseo = id_museo;

            htp.prn('<div class="w3-row">');
            htp.prn('<div class="w3-col s3 w3-center"><p>Museo:</p></div>');
            htp.prn('<div class="w3-col s9 w3-center"><p>');
            modgui1.collegamento(
                                nome_museo,
                                'operazioniGruppo4.visualizzaMusei?idMuseo=' || id_museo
            );
            htp.prn('</p></div>');
            htp.prn('</div>');
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || sqlerrm);
    END;

    PROCEDURE select_utente (
        nome                 VARCHAR2 DEFAULT 'id_utente',
        id                   VARCHAR2 DEFAULT 'id_utente',
        idutenteselezionato  IN utenti.idutente%TYPE DEFAULT NULL
    ) IS
    BEGIN
        modgui1.selectopen(
                          nome,
                          id
        );
        modgui1.emptyselectoption(
                                 CASE
                                     WHEN idutenteselezionato IS NULL THEN
                                         1
                                     ELSE 0
                                 END
        );
        FOR utente IN (
            SELECT
                utenti.*
            FROM
                utentimuseo
                JOIN utenti ON utentimuseo.idutente = utenti.idutente
            ORDER BY
                nome
        ) LOOP
            IF utente.idutente = idutenteselezionato THEN
                modgui1.selectoption(
                                    utente.idutente,
                                    utente.nome
                                    || ' '
                                    || utente.cognome,
                                    1
                );

            ELSE
                modgui1.selectoption(
                                    utente.idutente,
                                    utente.nome
                                    || ' '
                                    || utente.cognome,
                                    0
                );
            END IF;
        END LOOP;

        modgui1.selectclose();
    END;

    PROCEDURE select_museo (
        nome      VARCHAR2 DEFAULT 'id_museo',
        id        VARCHAR2 DEFAULT 'id_museo',
        id_museo  IN utenti.idutente%TYPE DEFAULT NULL
    ) IS
    BEGIN
        modgui1.selectopen(
                          nome,
                          id
        );
        modgui1.emptyselectoption(
                                 CASE
                                     WHEN id_museo IS NULL THEN
                                         1
                                     ELSE 0
                                 END
        );
        FOR museo IN (
            SELECT
                *
            FROM
                musei
        ) LOOP
            IF museo.idmuseo = id_museo THEN
                modgui1.selectoption(
                                    museo.idmuseo,
                                    museo.nome,
                                    1
                );
            ELSE
                modgui1.selectoption(
                                    museo.idmuseo,
                                    museo.nome,
                                    0
                );
            END IF;
        END LOOP;

        modgui1.selectclose();
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
            htp.prn('<div class="w3-container">');
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

            htp.prn('</div>');
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


    PROCEDURE modal_filtri_visite (
        data_visita_from  IN  VARCHAR2 DEFAULT NULL,
        data_visita_to    IN  VARCHAR2 DEFAULT NULL,
        id_utente         IN  NUMBER DEFAULT NULL,
        id_museo          IN  NUMBER DEFAULT NULL,
        is_biglietto      IN  NUMBER DEFAULT NULL,
        is_abbonamento    IN  NUMBER DEFAULT NULL
    ) IS
    BEGIN
        modgui1.apridiv('id="modal_filtri" class="w3-modal"');
        modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
        modgui1.apridiv('class="w3-center"');
        htp.br;
        htp.prn('<span onclick="document.getElementById(''modal_filtri'').style.display=''none''" class="w3-button w3-xlarge w3-red w3-display-topright" title="Close Modal">X</span>');
        htp.print('<h1>Filtri</h1>');
        modgui1.chiudidiv;
        modgui1.apriform(
                        'packageVisite.visualizza_visite',
                        'seleziona statistica',
                        'w3-container w3-margin'
        );
        htp.prn('<div class="w3-row">');
        htp.prn('
        <div class="w3-col s6 w3-padding-small">
            <label for="data_visita_from">Da:</label>
            <input class="w3-input w3-border w3-round-xlarge" type="datetime-local" id="data_visita_from" name="data_visita_from" value="'
                || data_visita_from
                || '">
        </div>');
        htp.prn('
        <div class="w3-col s6 w3-padding-small">
            <label for="data_visita_to">A:</label>
            <input class="w3-input w3-border w3-round-xlarge" type="datetime-local" id="data_visita_to" name="data_visita_to" value="'
                || data_visita_to
                || '">
        </div>');
        htp.prn('</div>');
        htp.prn('<div class="w3-row">');
        htp.prn('<div class="w3-col s4 w3-center">');
        htp.prn('<div class="w3-margin">Utente: </div>');
        htp.prn('</div>');
        htp.prn('<div class="w3-col s8 w3-center">');
        select_utente(
                     'id_utente',
                     'id_utente',
                     id_utente
        );
        htp.prn('</div>');
        htp.prn('</div>');
        htp.prn('<div class="w3-row">');
        htp.prn('<div class="w3-col s4 w3-center">');
        htp.prn('<div class="w3-margin">Museo: </div>');
        htp.prn('</div>');
        htp.prn('<div class="w3-col s8 w3-center">');
        select_museo(
                    'id_museo',
                    'id_museo',
                    id_museo
        );
        htp.prn('</div>');
        htp.prn('</div>');
        htp.prn('<div class="w3-row">');
        htp.prn('<div class="w3-col s4 w3-center">');
        htp.prn('<div class="w3-margin">È un abbonamento: </div>');
        htp.prn('</div>');
        htp.prn('<div class="w3-col s8 w3-center">');
        modgui1.inputcheckbox(
                             '',
                             'is_abbonamento',
                             is_abbonamento,
                             0,
                             1
        );
        htp.prn('</div>');
        htp.prn('</div>');
        htp.prn('<div class="w3-row">');
        htp.prn('<div class="w3-col s4 w3-center">');
        htp.prn('<div class="w3-margin">È un biglietto: </div>');
        htp.prn('</div>');
        htp.prn('<div class="w3-col s8 w3-center">');
        modgui1.inputcheckbox(
                             '',
                             'is_biglietto',
                             is_biglietto,
                             0,
                             1
        );
        htp.prn('</div>');
        htp.prn('</div>');
        modgui1.inputreset;
        htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit">Applica</button>');
        modgui1.chiudidiv;
        modgui1.chiudiform;
        modgui1.chiudidiv;
        modgui1.chiudidiv;
    END;

    PROCEDURE modal_statistiche_visite (
        data_visita_from  IN  VARCHAR2 DEFAULT NULL,
        data_visita_to    IN  VARCHAR2 DEFAULT NULL,
        id_utente         IN  NUMBER DEFAULT NULL,
        id_museo          IN  NUMBER DEFAULT NULL,
        is_biglietto      IN  NUMBER DEFAULT NULL,
        is_abbonamento    IN  NUMBER DEFAULT NULL
    ) IS

        lv_where      VARCHAR2(255);
        v_base_query  VARCHAR2(2000) := 'with binds as (
          select :bind1 as data_visita_from,
          :bind2 as data_visita_to,
          :bind3 as id_utente,
          :bind4 as id_museo
            from dual)
        SELECT COUNT(view_visite.idvisita) FROM view_visite, binds b
        WHERE 1=1 ';
        counter       NUMBER(20);
    BEGIN
        IF data_visita_from IS NOT NULL THEN
            lv_where := lv_where || ' AND datavisita >= b.data_visita_from';
        END IF;
        IF data_visita_to IS NOT NULL THEN
            lv_where := lv_where || ' AND datavisita <= b.data_visita_to';
        END IF;
        IF id_utente IS NOT NULL THEN
            lv_where := lv_where || ' AND idutente = b.id_utente';
        END IF;
        IF id_museo IS NOT NULL THEN
            lv_where := lv_where || ' AND idmuseo = b.id_museo';
        END IF;
        IF is_biglietto = 1 THEN
            lv_where := lv_where || ' AND EXISTS(SELECT * FROM biglietti WHERE biglietti.IdTipologiaIng=view_visite.IdTipologiaIng)';
        END IF;
        IF is_abbonamento = 1 THEN
            lv_where := lv_where || ' AND EXISTS(SELECT * FROM abbonamenti WHERE abbonamenti.IdTipologiaIng=view_visite.IdTipologiaIng)';
        END IF;
        v_base_query := v_base_query || lv_where;
        EXECUTE IMMEDIATE v_base_query
        INTO counter USING data_visita_from, data_visita_to, id_utente, id_museo;

        modgui1.apridiv('id="modal_statistiche" class="w3-modal"');
        modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
        modgui1.apridiv('class="w3-center"');
        htp.prn('<span onclick="document.getElementById(''modal_statistiche'').style.display=''none''" class="w3-button w3-xlarge w3-red w3-display-topright" title="Close Modal">X</span>');
        htp.print('<h1>Seleziona l''operazione</h1>');
        modgui1.chiudidiv;
        htp.prn('<div class"w3-container w3-margin">');
        htp.prn('<div class="w3-row">');
        htp.prn('<div class="w3-col s4 w3-center">');
        htp.prn('<div class="w3-margin">Numero visite: </div>');
        htp.prn('</div>');
        htp.prn('<div class="w3-col s8 w3-center">');
        htp.prn('<div class="w3-margin">' || counter || '</div>');
        htp.prn('</div>');
        htp.prn('</div>');
        modgui1.chiudidiv;
        modgui1.chiudidiv;
        modgui1.chiudidiv;
    END;

    FUNCTION build_query (
        data_visita_from  IN  VARCHAR2 DEFAULT NULL,
        data_visita_to    IN  VARCHAR2 DEFAULT NULL,
        id_utente         IN  NUMBER DEFAULT NULL,
        id_museo          IN  NUMBER DEFAULT NULL,
        is_biglietto      IN  NUMBER DEFAULT NULL,
        is_abbonamento    IN  NUMBER DEFAULT NULL
    ) RETURN VARCHAR2 IS
        lv_where      VARCHAR2(255);
        v_base_query  VARCHAR2(2000) := 'with binds as (
          select :bind1 as data_visita_from,
          :bind2 as data_visita_to,
          :bind3 as id_utente,
          :bind4 as id_museo
            from dual)
       SELECT view_visite.* FROM view_visite, binds b
       WHERE 1=1 ';
    BEGIN
        IF data_visita_from IS NOT NULL THEN
            lv_where := lv_where || ' AND datavisita >= b.data_visita_from';
        END IF;
        IF data_visita_to IS NOT NULL THEN
            lv_where := lv_where || ' AND datavisita <= b.data_visita_to';
        END IF;
        IF id_utente IS NOT NULL THEN
            lv_where := lv_where || ' AND idutente = b.id_utente';
        END IF;
        IF id_museo IS NOT NULL THEN
            lv_where := lv_where || ' AND idmuseo = b.id_museo';
        END IF;
        IF is_biglietto = 1 THEN
            lv_where := lv_where || ' AND EXISTS(SELECT * FROM biglietti WHERE biglietti.IdTipologiaIng=view_visite.IdTipologiaIng)';
        END IF;
        IF is_abbonamento = 1 THEN
            lv_where := lv_where || ' AND EXISTS(SELECT * FROM abbonamenti WHERE abbonamenti.IdTipologiaIng=view_visite.IdTipologiaIng)';
        END IF;
        v_base_query := v_base_query
                        || lv_where
                        || ' ORDER BY IdVisita DESC';
        RETURN v_base_query;
    END;

    PROCEDURE visualizza_visite (
        data_visita_from  IN  VARCHAR2 DEFAULT NULL,
        data_visita_to    IN  VARCHAR2 DEFAULT NULL,
        id_utente         IN  NUMBER DEFAULT NULL,
        id_museo          IN  NUMBER DEFAULT NULL,
        is_biglietto      IN  NUMBER DEFAULT NULL,
        is_abbonamento    IN  NUMBER DEFAULT NULL
    ) IS

        id_sessione      NUMBER(10) := NULL;
        lv_sql           VARCHAR2(2000);
        v_visite_cursor  SYS_REFCURSOR;
        visita           view_visite%rowtype;
    BEGIN
        lv_sql := build_query(
                             data_visita_from,
                             data_visita_to,
                             id_utente,
                             id_museo,
                             is_biglietto,
                             is_abbonamento
                  );
        OPEN v_visite_cursor FOR lv_sql
            USING to_date(
                         data_visita_from,
                         'YYYY-MM-DD"T"HH24:MI'
                  ), to_date(
                            data_visita_to,
                            'YYYY-MM-DD"T"HH24:MI'
                     ), id_utente, id_museo;

        id_sessione := modgui1.get_id_sessione;
        modgui1.apripagina(
                          'Visite',
                          id_sessione
        );
        modgui1.header(id_sessione);
        modgui1.apridiv('style="margin-top: 110px"');
        modgui1.apridiv('class="w3-center"');
        htp.prn('<h1>Visite</h1>');
        IF hasrole(
                  id_sessione,
                  'AB'
           ) OR hasrole(
                       id_sessione,
                       'SU'
                ) OR hasrole(
                            id_sessione,
                            'DBA'
                     ) THEN
            modgui1.collegamento(
                                'Aggiungi',
                                'PackageVisite.pagina_inserisci_visita',
                                'w3-btn w3-round-xxlarge w3-black w3-margin'
            ); /*bottone che rimanda alla procedura inserimento solo se la sessione è 1*/

            htp.prn('<button onclick="document.getElementById(''modal_statistiche'').style.display=''block''" class="w3-btn w3-round-xxlarge w3-black w3-margin">Statistiche</button>');
            htp.prn('<button onclick="document.getElementById(''modal_filtri'').style.display=''block''" class="w3-btn w3-round-xxlarge w3-black w3-margin">Filtri</button>');
        END IF;

        modgui1.chiudidiv;
        htp.br;
        modgui1.apridiv('class="w3-row w3-container"');
        -- INIZIO LOOP DELLA VISUALIZZAZIONE
        LOOP
            FETCH v_visite_cursor INTO visita;
            EXIT WHEN v_visite_cursor%notfound;
            modgui1.apridiv('class="w3-col l4 w3-padding-large w3-center"');
            modgui1.apridiv('class="w3-card-4"');
            htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%">');
            modgui1.apridiv('class="w3-container w3-center"');
            htp.header(
                      2,
                      'Visita ' || visita.idvisita
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
                               visita.titoloingresso,
                               visita.idmuseo
            );

            htp.prn('<div class="w3-row">');
            modgui1.collegamento(
                                'Visualizza',
                                'packagevisite.visualizzavisita?idvisitaselezionata='
                                || visita.idvisita
                                || '&titolo=Visita+numero+'
                                || visita.idvisita
                                || '&action=packageVisite.visualizza_visite&button_text=Trona+alla+home',
                                'w3-button w3-margin w3-black'
            );

            IF hasrole(
                      id_sessione,
                      'AB'
               ) OR hasrole(
                           id_sessione,
                           'SU'
                    ) OR hasrole(
                                id_sessione,
                                'DBA'
                         ) THEN
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

            htp.prn('</div>');
            modgui1.chiudidiv;
            modgui1.chiudidiv;
            modgui1.chiudidiv;
        END LOOP;

        CLOSE v_visite_cursor;
        modgui1.chiudidiv();
        modgui1.chiudidiv();
        modal_statistiche_visite(
                           data_visita_from,
                           data_visita_to,
                           id_utente,
                           id_museo,
                           is_biglietto,
                           is_abbonamento
        );
        modal_filtri_visite(
                           data_visita_from,
                           data_visita_to,
                           id_utente,
                           id_museo,
                           is_biglietto,
                           is_abbonamento
        );
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
                        'PackageVisite.visualizza_visite',
                        'Torna ad home'
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
        modgui1.collegamento(
                            'X',
                            'packageVisite.visualizza_visite',
                            ' w3-btn w3-large w3-red w3-display-topright'
        );
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
        select_utente(
                     'idUtenteSelezionato',
                     'utente-selezionato',
                     idutenteselezionato
        );
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
        htp.prn('<div class="w3-container">');
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
