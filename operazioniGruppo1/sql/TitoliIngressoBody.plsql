SET DEFINE OFF;
CREATE OR REPLACE PACKAGE BODY packageAcquistaTitoli AS

/*
 *  OPERAZIONI SUI TITOLI DI INGRESSO
 * - Modifica titolare OK
 * - Visualizzazione OK
 * - Acquisto abbonamento museale  OK
 * - Acquisto biglietto OK
 * OPERAZIONI STATISTICHE E MONITORAGGIO
 * - Numero Titoli d’Ingresso emessi in un arco temporale scelto ❌ TODO WITH FILTER
 * - Numero Titoli d’Ingresso emessi da un Museo in un arco temporale scelto ❌ TODO WITH FILTER
 * - Abbonamenti in scadenza nel mese corrente ❌
 */

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

PROCEDURE select_tipologia (
        nome      VARCHAR2 DEFAULT 'id_tipologia',
        id        VARCHAR2 DEFAULT 'id_tipologia',
        id_tipologia  IN utenti.idutente%TYPE DEFAULT NULL
    ) IS
    BEGIN
        modgui1.selectopen(
                          nome,
                          id
        );
        modgui1.emptyselectoption(
                                 CASE
                                     WHEN id_tipologia IS NULL THEN
                                         1
                                     ELSE 0
                                 END
        );
        FOR tipologia IN (
            SELECT
                *
            FROM
                TIPOLOGIEINGRESSO
        ) LOOP
            IF tipologia.idtipologiaing = id_tipologia THEN
                modgui1.selectoption(
                                    tipologia.idtipologiaing,
                                    tipologia.nome,
                                    1
                );
            ELSE
                modgui1.selectoption(
                                    tipologia.idtipologiaing,
                                    tipologia.nome,
                                    0
                );
            END IF;
        END LOOP;

        modgui1.selectclose();
    END;

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
                        'packageacquistatitoli.titolihome',
                        'seleziona filtri',
                        'w3-container w3-margin'
        );
        htp.prn('<div class="w3-row">');
        htp.prn('
        <div class="w3-col s6 w3-padding-small">
            <label for="datefrom">Da:</label>
            <input class="w3-input w3-border w3-round-xlarge" type="datetime-local" id="datefrom" name="datefrom" value="'
                || datefrom
                || '">
        </div>');
        htp.prn('
        <div class="w3-col s6 w3-padding-small">
            <label for="dateto">A:</label>
            <input class="w3-input w3-border w3-round-xlarge" type="datetime-local" id="dateto" name="dateto" value="'
                || dateto
                || '">
        </div>');
        htp.prn('</div>');
        htp.prn('<div class="w3-row">');
        htp.prn('<div class="w3-col s4 w3-center">');
        htp.prn('<div class="w3-margin">Utente: </div>');
        htp.prn('</div>');
        htp.prn('<div class="w3-col s8 w3-center">');
        select_utente('id_utente', 'id_utente', id_utente);
        htp.prn('</div>');
        htp.prn('</div>');
        htp.prn('<div class="w3-row">');
        htp.prn('<div class="w3-col s4 w3-center">');
        htp.prn('<div class="w3-margin">Museo: </div>');
        htp.prn('</div>');
        htp.prn('<div class="w3-col s8 w3-center">');
        select_museo('id_museo','id_museo', id_museo);
        htp.prn('</div>');
        htp.prn('</div>');
		htp.prn('<div class="w3-row">');
        htp.prn('<div class="w3-col s4 w3-center">');
        htp.prn('<div class="w3-margin">Tipologia d''ingresso: </div>');
        htp.prn('</div>');
        htp.prn('<div class="w3-col s8 w3-center">');
        select_tipologia('id_tipologia','id_tipologia', id_tipologia);
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
        htp.prn('<div class="w3-row">');
        htp.prn('<div class="w3-col w3-padding s4 w3-center">');
        htp.prn('<div class="w3-margin">Ordina per: </div>');
        htp.prn('</div>');
        htp.prn('<div class="w3-col w3-padding s5 w3-center">');
        modgui1.selectopen(
                          'order_by',
                          'order_by'
        );
        modgui1.selectoption(
                            'IdUtente',
                            'Titolare',
                            CASE
                                WHEN order_by = 'Titolare' THEN
                                    1
                                ELSE 0
                            END
        );

        modgui1.selectoption(
                            'idtipologia',
                            'Tipologia d''ingresso',
                            CASE
                                WHEN order_by = 'Tipologia d''ingresso' THEN
                                    1
                                ELSE 0
                            END
        );

        modgui1.selectoption(
                            'dataemissione',
                            'Data emissione',
                            CASE
                                WHEN order_by = 'Data emissione' THEN
                                    1
                                ELSE 0
                            END
        );

        modgui1.selectoption(
                            'museo',
                            'Museo',
                            CASE
                                WHEN order_by = 'Museo' THEN
                                    1
                                ELSE 0
                            END
        );

        modgui1.selectclose();
        htp.prn('</div>');
        htp.prn('<div class="w3-col w3-padding s3 w3-center">');
        modgui1.selectopen(
                          'sort_method',
                          'sort_method'
        );
        modgui1.selectoption(
                            'ASC',
                            'Crescente',
                            CASE
                                WHEN sort_method = 'ASC' THEN
                                    1
                                ELSE 0
                            END
        );

        modgui1.selectoption(
                            'DESC',
                            'Decrescente',
                            CASE
                                WHEN sort_method = 'DESC' THEN
                                    1
                                ELSE 0
                            END
        );

        modgui1.selectclose();
        htp.prn('</div>');
        htp.prn('</div>');
        modgui1.inputreset;
        htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit">Applica</button>');
        modgui1.chiudidiv;
        modgui1.chiudiform;
        modgui1.chiudidiv;
        modgui1.chiudidiv;
    END;

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
    ) RETURN VARCHAR2 IS
        lv_where      VARCHAR2(500);
        v_base_query  VARCHAR2(2000) := 'with binds as (
          select :bind1 as datefrom,
          :bind2 as dateto,
          :bind3 as id_utente,
          :bind4 as id_museo,
		  :bind5 as id_tipologia,
		  :bind6 as idclientelogged
            from dual)
       select view_titoli.* from view_titoli,
				binds b
       WHERE 1=1 ';
    BEGIN
        IF datefrom IS NOT NULL THEN
            lv_where := lv_where || ' AND dataemissione >= b.datefrom';
        END IF;
        IF dateto IS NOT NULL THEN
            lv_where := lv_where || ' AND dataemissione <= b.dateto';
        END IF;
		IF idclientelogged is not null then 
			lv_where := lv_where || ' AND idutente = b.idclientelogged';
		end if;
		IF id_tipologia IS NOT NULL THEN
			lv_where := lv_where || ' AND idtipologia = b.id_tipologia';
		END IF;
        IF id_utente IS NOT NULL THEN
            lv_where := lv_where || ' AND idutente = b.id_utente';
        END IF;
        IF id_museo IS NOT NULL THEN
            lv_where := lv_where || ' AND museo = b.id_museo';
        END IF;
        IF is_biglietto = 1 THEN
            lv_where := lv_where || ' AND EXISTS(SELECT * FROM biglietti WHERE biglietti.IdTipologiaIng=view_titoli.idtipologia)';
        END IF;
        IF is_abbonamento = 1 THEN
            lv_where := lv_where || ' AND EXISTS(SELECT * FROM abbonamenti WHERE abbonamenti.IdTipologiaIng=view_titoli.idtipologia)';
        END IF;
        v_base_query := v_base_query
                        || lv_where
                        || ' ORDER BY '
                        || order_by
                        || ' '
                        || sort_method;

        RETURN v_base_query;
    END;

function n_risultati(
	    datefrom  IN  VARCHAR2 DEFAULT NULL,
        dateto    IN  VARCHAR2 DEFAULT NULL,
        id_utente         IN  NUMBER DEFAULT NULL,
        id_museo          IN  NUMBER DEFAULT NULL,
		id_tipologia	  IN  NUMBER DEFAULT NULL,
        is_biglietto      IN  NUMBER DEFAULT NULL,
        is_abbonamento    IN  NUMBER DEFAULT NULL,
		idclientelogged IN utentilogin.IDCLIENTE%type DEFAULT NULL
    )RETURN number IS
        lv_where      VARCHAR2(500);
        v_base_query  VARCHAR2(2000) := 'with binds as (
          select :bind1 as datefrom,
          :bind2 as dateto,
          :bind3 as id_utente,
          :bind4 as id_museo,
		  :bind5 as id_tipologia,
		  :bind6 as idclientelogged
            from dual)
       SELECT COUNT(view_titoli.idtitolo) FROM view_titoli, binds b
        WHERE 1=1 ';
		counter number(20);
    BEGIN
        IF datefrom IS NOT NULL THEN
            lv_where := lv_where || ' AND dataemissione >= b.datefrom';
        END IF;
        IF dateto IS NOT NULL THEN
            lv_where := lv_where || ' AND dataemissione <= b.dateto';
        END IF;
		IF idclientelogged is not null then 
			lv_where := lv_where || ' AND idutente = b.idclientelogged';
		end if;
		IF id_tipologia IS NOT NULL THEN
			lv_where := lv_where || ' AND idtipologia = b.id_tipologia';
		END IF;
        IF id_utente IS NOT NULL THEN
            lv_where := lv_where || ' AND idutente = b.id_utente';
        END IF;
        IF id_museo IS NOT NULL THEN
            lv_where := lv_where || ' AND museo = b.id_museo';
        END IF;
        IF is_biglietto = 1 THEN
            lv_where := lv_where || ' AND EXISTS(SELECT * FROM biglietti WHERE biglietti.IdTipologiaIng=view_titoli.idtipologia)';
        END IF;
        IF is_abbonamento = 1 THEN
            lv_where := lv_where || ' AND EXISTS(SELECT * FROM abbonamenti WHERE abbonamenti.IdTipologiaIng=view_titoli.idtipologia)';
        END IF;
		v_base_query := v_base_query || lv_where;
		EXECUTE IMMEDIATE v_base_query
        INTO
            counter
            USING to_date(
                         datefrom,
                         'YYYY-MM-DD"T"HH24:MI'
                  ), to_date(
                            dateto,
                            'YYYY-MM-DD"T"HH24:MI'
                     ), id_utente, id_museo, id_tipologia, idclientelogged;
        RETURN counter;
end;

 --PAGINA INIZIALE TITOLI D'INGRESSO
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
 )
 	is
		idSessione NUMBER(5) := modgui1.get_id_sessione();
		idclientelogged utentilogin.IDCLIENTE%type := NULL;
		temp number(1) := 0; --indica se il titolo sia un biglietto oppure un abbonamento
		num_risultati number(20) := null;

		lv_sql varchar2(3000);
		v_titoli_cursor SYS_REFCURSOR;
		titolo view_titoli%rowtype;
    BEGIN

		
		MODGUI1.APRIPAGINA('Titoli d''ingresso');
        modGUI1.Header();
        modgui1.apridiv('style="margin-top: 110px"');
		if(idsessione = 0) THEN
			htp.prn('<h1 align=center>Nessun utente loggato.</h1>');
		else
		SELECT IDCLIENTE INTO idclientelogged FROM UTENTILOGIN WHERE UTENTILOGIN.IDUTENTELOGIN = idSessione;
		lv_sql := build_query(
							datefrom,
							dateto,
							id_utente,
							id_museo,
							id_tipologia,
							is_biglietto,
							is_abbonamento,
							order_by,
							sort_method,
							idclientelogged
		);
		
		OPEN v_titoli_cursor FOR lv_sql
            USING to_date(
                         datefrom,
                         'YYYY-MM-DD"T"HH24:MI'
                  ), to_date(
                            dateto,
                            'YYYY-MM-DD"T"HH24:MI'
                     ), id_utente, id_museo, id_tipologia, idclientelogged;
		
		num_risultati := n_risultati(datefrom, dateto, id_utente, id_museo, id_tipologia, is_biglietto, is_abbonamento, idclientelogged);

        modGUI1.ApriDiv('class="w3-center"');

            htp.prn('<h1>Titoli d''ingresso </h1>'); --TITOLO

            modGUI1.Collegamento('Acquista biglietto','packageAcquistaTitoli.pagina_acquista_biglietto', 'w3-btn w3-round-xxlarge w3-black w3-margin');
			modGUI1.Collegamento('Acquista abbonamento','packageAcquistaTitoli.pagina_acquista_abbonamento','w3-btn w3-round-xxlarge w3-black w3-margin');
			IF (hasrole(idSessione,'GM')
								OR hasrole(idSessione,'DBA'))
			THEN
				modGUI1.Collegamento('Abbonamenti in scadenza questo mese','packageAcquistaTitoli.abbonamenti_in_scadenza','w3-btn w3-round-xxlarge w3-black w3-margin');
				htp.br;
				htp.prn('<button onclick="document.getElementById(''modal_filtri'').style.display=''block''" class="w3-btn w3-round-xxlarge w3-black w3-margin">Filtri</button>');
			end if;
			htp.prn('<p align=right style="margin-right:30px; font-size:20px; margin-block-start:-35px; margin-block-end:15px"> Numero risultati: <b>'||num_risultati|| '</b></p>');
		modgui1.chiudidiv;
		
		LOOP
            FETCH v_titoli_cursor INTO titolo;
            EXIT WHEN v_titoli_cursor%notfound;
			
			modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                    modGUI1.ApriDiv('class="w3-card-4"');
                            modGUI1.ApriDiv('class="w3-container w3-center"');
							
                            --INIZIO DESCRIZIONI
								select count(*) into temp
								from titoliingresso join tipologieingresso on TITOLIINGRESSO.TIPOLOGIA=TIPOLOGIEINGRESSO.IDTIPOLOGIAING
								join abbonamenti on abbonamenti.idtipologiaing=tipologieingresso.IDTIPOLOGIAING
								where titoliingresso.IDTITOLOING=titolo.idtitolo;
								if (temp>0) then
								htp.header(
                      						3,
                      						'Abbonamento'
            					);
								ELSE
								htp.header(
                      						3,
                      						'Biglietto'
            					);
								end if;
								htp.prn('<div class="w3-row">');
        						htp.prn('<div class="w3-col s3 w3-center"><p>Titolo d''ingresso:</p></div>');
								htp.prn('<div class="w3-col s9 w3-center"><b>'
                				|| titolo.idtitolo
                				|| '</b></div>');
        						htp.prn('</div>');

								htp.prn('<div class="w3-row">');
        						htp.prn('<div class="w3-col s3 w3-center"><p>Titolare:</p></div>');
								htp.prn('<div class="w3-col s9 w3-center"><p>'
                				||titolo.nomeutente || ' ' || titolo.cognomeutente|| '</p></div>');
        						htp.prn('</div>');

								htp.prn('<div class="w3-row">');
        						htp.prn('<div class="w3-col s3 w3-center"><p>Tipologia:</p></div>');
								htp.prn('<div class="w3-col s9 w3-center"><p>'
                				|| titolo.nometipologia || '</p></div>');
        						htp.prn('</div>');

								htp.prn('<div class="w3-row">');
        						htp.prn('<div class="w3-col s3 w3-center"><p>Museo:</p></div>');
								htp.prn('<div class="w3-col s9 w3-center"><p>'
                				|| titolo.nomemuseo || '</p></div>');
        						htp.prn('</div>');

								htp.prn('<div class="w3-row">');
        						htp.prn('<div class="w3-col s3 w3-center"><p>Data d''emissione:</p></div>');
								htp.prn('<div class="w3-col s9 w3-center"><p>'
                				|| to_char(titolo.dataemissione, 'DD/MON/YYYY HH24:MI')
                				|| '</p></div>');
        						htp.prn('</div>');

								htp.prn('<div class="w3-row">');
        						htp.prn('<div class="w3-col s3 w3-center"><p>Data di scadenza:</p></div>');
								htp.prn('<div class="w3-col s9 w3-center"><p>'
                				|| to_char(titolo.datascadenza, 'DD/MON/YYYY HH24:MI')
                				|| '</p></div>');
        						htp.prn('</div>');
                            --FINE DESCRIZIONI
                            modGUI1.ChiudiDiv;
                            
							htp.prn('<div class="w3-row">');
            				MODGUI1.Collegamento(
								'Visualizza',
								'packageAcquistaTitoli.visualizzatitoloing?varidtitoloing='||titolo.idtitolo,
								'w3-button w3-margin w3-black');
							
							--utente autorizzato
            				IF hasrole(idSessione,'AB')
								OR hasrole(idSessione,'GM')
								OR hasrole(idSessione,'DBA')
							THEN
               				 modgui1.collegamento(
								'Modifica titolare',
								'packageAcquistaTitoli.pagina_modifica_titolo?varidtitoloing='||titolo.idtitolo,
								'w3-button w3-margin w3-green');
							END IF;
							htp.prn('</div>');
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
				
            END LOOP;
		
		CLOSE v_titoli_cursor;
        modgui1.chiudidiv();
        modgui1.chiudidiv();
    
		modal_filtri_titoli(
                           datefrom,
                           dateto,
                           id_utente,
                           id_museo,
						   id_tipologia,
                           is_biglietto,
                           is_abbonamento,
                           order_by,
                           sort_method
        );
        modGUI1.chiudiDiv;
	end if;
	htp.bodyclose;
	htp.htmlclose;
	
end;

--VISUALIZZAZIONE
PROCEDURE visualizzatitoloing(
	varidtitoloing titoliingresso.IDTITOLOING%type
)is
	idSessione NUMBER(5) := modgui1.get_id_sessione();

	nomeutente utenti.nome%type;
	cognomeutente utenti.COGNOME%type;
	varidutente utenti.IDUTENTE%type;
	varidmuseo musei.IDMUSEO%type;
	nomemuseo musei.nome%type;
	emiss TITOLIINGRESSO.emissione%type;
	scad TITOLIINGRESSO.SCADENZA%type;
    nometipologia TIPOLOGIEINGRESSO.NOME%type;
	varidtipologia TIPOLOGIEINGRESSO.IDTIPOLOGIAING%type;
	temp number(3);
BEGIN
	select Emissione, Scadenza, TITOLIINGRESSO.Acquirente, IdMuseo, Musei.Nome, utenti.nome, utenti.cognome, TIPOLOGIEINGRESSO.NOME, TIPOLOGIEINGRESSO.IDTIPOLOGIAING
	into emiss, scad, varidutente, varidmuseo, nomemuseo, nomeutente, cognomeutente, nometipologia, varidtipologia
	from TITOLIINGRESSO join utenti on utenti.idutente=TITOLIINGRESSO.ACQUIRENTE
	join musei on TITOLIINGRESSO.Museo= musei.idmuseo
    join TIPOLOGIEINGRESSO on TITOLIINGRESSO.TIPOLOGIA=TIPOLOGIEINGRESSO.IDTIPOLOGIAING
	where TITOLIINGRESSO.idtitoloing= varidtitoloing;
	
	MODGUI1.APRIPAGINA('Visualizza titolo d''ingresso');
		modgui1.header();
		modgui1.apridiv('style="margin-top: 110px"');

		MODGUI1.ApriDivcard();
		select count(*) into temp from Biglietti where idtipologiaing=varidtipologia;
		if(temp>0)
		then
		HTP.header(2, 'Biglietto', 'center');
		ELSE
		HTP.header(2, 'Abbonamento', 'center');
		end if;

		--nome utente
		htp.prn('<div class="w3-row">');
        htp.prn('<div class="w3-col s3 w3-center"><p>Titolare:</p></div>');
        htp.prn('<div class="w3-col s9 w3-center"><p>');
        modgui1.collegamento(
                            nomeutente
                            || ' '
                            || cognomeutente,
                            'packageUtenti.VisualizzaUtente?utenteID=' || varidutente
        );
        htp.prn('</p></div>');
        htp.prn('</div>');
		--titolo d'ingresso
		htp.prn('<div class="w3-row">');
        htp.prn('<div class="w3-col s3 w3-center"><p>Numero titolo d''ingresso:</p></div>');
        htp.prn('<div class="w3-col s9 w3-center"><p>'
                || varidtitoloing
                || '</p></div>');
        htp.prn('</div>');
		--data emissione
		htp.prn('<div class="w3-row">');
        htp.prn('<div class="w3-col s3 w3-center"><p>Data di emissione:</p></div>');
        htp.prn('<div class="w3-col s9 w3-center"><p>'
                || to_char(emiss, 'DD/MON/YYYY HH24:MI')
                || '</p></div>');
        htp.prn('</div>');
		--data scadenza
		htp.prn('<div class="w3-row">');
        htp.prn('<div class="w3-col s3 w3-center"><p>Data di scadenza:</p></div>');
        htp.prn('<div class="w3-col s9 w3-center"><p>'
                || to_char(scad, 'DD/MON/YYYY HH24:MI')
                || '</p></div>');
        htp.prn('</div>');
		--museo
		htp.prn('<div class="w3-row">');
        htp.prn('<div class="w3-col s3 w3-center"><p>Museo:</p></div>');
        htp.prn('<div class="w3-col s9 w3-center"><p>');
        modgui1.collegamento(
                                nomemuseo,
                                'operazioniGruppo4.visualizzaMusei?museoID=' || varidmuseo
            );
        htp.prn('</p></div>');
        htp.prn('</div>');
		--tipologia d'ingresso
		htp.prn('<div class="w3-row">');
        htp.prn('<div class="w3-col s3 w3-center"><p>Tipologia d''ingresso:</p></div>');
        htp.prn('<div class="w3-col s9 w3-center"><p>');
        modgui1.collegamento(
                                nometipologia,
                                'gruppo1.VisualizzaDatiTitoloIng?tipologiaIngID=' || varidtipologia
            );
        htp.prn('</p></div>');
        htp.prn('</div>');
		modGUI1.Collegamento('X',
                'packageAcquistaTitoli.titolihome',
                'w3-btn w3-large w3-red w3-display-topright');
		if(idSessione=1)
		then
			modGUI1.Collegamento('Modifica titolare',
				'packageacquistatitoli.pagina_modifica_titolo?varidtitoloing='||varidtitoloing,
				'w3-button w3-block w3-black w3-section');
		end if;
		modgui1.chiudidiv();
		htp.bodyclose();
	htp.HtmlClose();
END;


PROCEDURE pagina_modifica_titolo(
	varidtitoloing titoliingresso.IDTITOLOING%type
)
IS
	idSessione NUMBER(5) := modgui1.get_id_sessione();
	varidutenteold utenti.idutente%type;
	varidutentenew utenti.idutente%type;
	nomeutente utenti.nome%type;
	cognomeutente utenti.cognome%type;
	idutenteselezionato utenti.idutente%type;
	nomeutenteold utenti.nome%type;
	cognomeutenteold utenti.cognome%type;
	dataemissione titoliingresso.emissione%type;
	datascadenza titoliingresso.scadenza%type;
	nomemuseo musei.nome%type;
	nometipologia TIPOLOGIEINGRESSO.nome%type;
BEGIN
	select utenti.idutente, utenti.nome, utenti.cognome, titoliingresso.emissione, titoliingresso.scadenza, musei.nome, TIPOLOGIEINGRESSO.nome
	into varidutenteold, nomeutenteold, cognomeutenteold, dataemissione, datascadenza, nomemuseo, nometipologia
	from TITOLIINGRESSO
	join utenti on utenti.idutente=titoliingresso.acquirente
	join musei on titoliingresso.museo=musei.idmuseo
	join TIPOLOGIEINGRESSO on tipologieingresso.IDTIPOLOGIAING=titoliingresso.TIPOLOGIA
	where TITOLIINGRESSO.IDTITOLOING=varidtitoloing;
	modgui1.apripagina('Pagina modifica');
	modgui1.header();
	modgui1.apridiv('style="margin-top: 110px"');
	htp.prn('<h1 align="center"> Modifica titolare </h1>');

	modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
	modGUI1.ApriForm('packageacquistatitoli.confermamodificatitolo',NULL,'w3-container');
	modgui1.apridiv('class="w3-section"');
	
		htp.formhidden('varidtitoloing', varidtitoloing);

	modgui1.label('Utente*: ');
	modgui1.selectopen('idutenteselezionato', 'utente-selezionato');
	MODGUI1.SelectOption(varidutenteold, ''|| nomeutenteold ||' '||cognomeutenteold||'', 1);
	for utente in (select idutente from utenti  where idutente != varidutenteold)
	loop
		select idutente, nome, cognome
		into varidutentenew, nomeutente, cognomeutente
		from utenti
		where idutente=utente.idutente;
		MODGUI1.SelectOption(varidutentenew, ''|| nomeutente ||' '||cognomeutente||'', 0);
	end loop;
	modgui1.selectclose();
	htp.br;

		HTP.TableOpen;
		HTP.TableRowOpen;
		HTP.TableData('Museo: ');
		HTP.TableData(nomemuseo);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Tipologia di ingresso: ');
		HTP.TableData(nometipologia);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Data Emissione: ');
		HTP.TableData(to_char(dataemissione, 'DD-MON-YYYY HH24:MI'));
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Data Scadenza: ');
		HTP.TableData(to_char(datascadenza, 'DD-MON-YYYY HH24:MI'));
		HTP.TableRowClose;
		HTP.TableClose;

	modgui1.inputsubmit('Modifica');
	modgui1.collegamento(
                        'Torna alla visualizzazione di tutti i titoli d''ingresso',
                        'packageAcquistaTitoli.titolihome',
                        'w3-button w3-block w3-red w3-section w3-padding'
                		);
	modgui1.ChiudiDiv();
	modgui1.chiudiform();
	HTP.BodyClose;
	HTP.HtmlClose;	

END;


PROCEDURE confermamodificatitolo(
	varidtitoloing TITOLIINGRESSO.IDTITOLOING%type,
	idutenteselezionato utenti.idutente%type
)
	IS
		idSessione NUMBER(5) := modgui1.get_id_sessione();

		nomeutente utenti.nome%type;
		cognomeutente utenti.cognome%type;
		varidutenteold utenti.idutente%type;
		nomeutenteold utenti.nome%type;
		cognomeutenteold utenti.cognome%type;
		dataemissione titoliingresso.emissione%type;
		datascadenza titoliingresso.scadenza%type;
		nomemuseo musei.nome%type;
		nometipologia TIPOLOGIEINGRESSO.nome%type;
		
	BEGIN

		select nome, cognome into nomeutente, cognomeutente
		from utenti where utenti.IDUTENTE=idutenteselezionato;

		select utenti.idutente, utenti.nome, utenti.cognome, titoliingresso.emissione, titoliingresso.scadenza, musei.nome, TIPOLOGIEINGRESSO.nome
		into varidutenteold, nomeutenteold, cognomeutenteold, dataemissione, datascadenza, nomemuseo, nometipologia
		from TITOLIINGRESSO
		join utenti on utenti.idutente=titoliingresso.acquirente
		join musei on titoliingresso.museo=musei.idmuseo
		join TIPOLOGIEINGRESSO on tipologieingresso.IDTIPOLOGIAING=titoliingresso.TIPOLOGIA
		where TITOLIINGRESSO.IDTITOLOING=varidtitoloing;
	
	if (idutenteselezionato = varidutenteold)
	THEN
		modGUI1.RedirectEsito('Errore', 
            'Non e'' stato selezionato un nuovo utente come titolare', 
            'Riprova', 'packageacquistatitoli.pagina_modifica_titolo?varidtitoloing=', varidtitoloing,
            'Torna al menu titoli d''ingresso', 'packageacquistatitoli.titolihome', null);
	end if;
	IF (idutenteselezionato is null) THEN
		modGUI1.RedirectEsito('Errore', 
            'Non e'' stato selezionato nessun utente', 
            'Riprova', 'packageacquistatitoli.pagina_modifica_titolo?varidtitoloing=', varidtitoloing,
            'Torna al menu titoli d''ingresso', 'packageacquistatitoli.titolihome', null);
	ELSE
		MODGUI1.APRIPAGINA('Pagina Conferma');
		HTP.BodyOpen;
		modgui1.header();
		modgui1.apridiv('style="margin-top: 110px"');
		htp.prn('<h2 align="center"> Conferma immissione dati </h2>');
		modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');

		HTP.TableOpen;
		HTP.TableRowOpen;
		HTP.TableData('<b>Nuovo titolare: </b>');
		HTP.TableData('<b>' ||nomeutente||' '||cognomeutente|| '</b>');
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Vecchio titolare: ');
		HTP.TableData(nomeutenteold||' '||cognomeutenteold);
		HTP.TableRowClose;	
		HTP.TableRowClose;		
		HTP.TableData('Museo: ');
		HTP.TableData(nomemuseo);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Tipologia di ingresso: ');
		HTP.TableData(nometipologia);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Data Emissione: ');
		HTP.TableData(to_char(dataemissione, 'DD-MON-YYYY HH24:MI'));
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Data Scadenza: ');
		HTP.TableData(to_char(datascadenza, 'DD-MON-YYYY HH24:MI'));
		HTP.TableRowClose;
		HTP.TableClose;

		modgui1.APRIFORM('packageacquistatitoli.modificatitolo');
		htp.formhidden('varidtitoloing', varidtitoloing);
		htp.formhidden('idutenteselezionato', idutenteselezionato);
		modgui1.InputSubmit('Conferma');
		modgui1.collegamento(
                        'Annulla',
                        'packageAcquistaTitoli.pagina_modifica_titolo?varidtitoloing='||varidtitoloing||'',
                        'w3-button w3-block w3-red w3-section w3-padding'
                		);
						
		modgui1.chiudidiv();
		modgui1.chiudidiv();
		HTP.BodyClose;
		HTP.HtmlClose;	
	end if;

END;

procedure modificatitolo(
	varidtitoloing TITOLIINGRESSO.IDTITOLOING%type,
	idutenteselezionato utenti.idutente%type
)is
BEGIN

	update TITOLIINGRESSO
	set titoliingresso.acquirente=idutenteselezionato
	where titoliingresso.idtitoloing=varidtitoloing;

	visualizzatitoloing(varidtitoloing);
END;

PROCEDURE acquistatitolo(
	dataEmissionechar IN VARCHAR2,
	oraemissionechar in varchar2,
	idmuseoselezionato IN VARCHAR2,
	idtipologiaselezionata tipologieingresso.IDTIPOLOGIAING%type,
	idutenteselezionato IN VARCHAR2
) IS
	idSessione NUMBER(5) := modgui1.get_id_sessione();

	varidtitoloing titoliingresso.IDTITOLOING%type;
	dataScadenza date; --contiene data di scadenza in formato inseribile nel db
	temp1 number(2); --flag che ci dice se abbiamo a che fare con un biglietto o un abbonamento
	temp2 date; 
	temp3 number(1); --flag che ci dice se l'utente e' gia presente nella tabella UTENTIMUSEO
	temp4 number(1):= null; --flag che ci dice se abbiamo effettivamente eseguito l'inserimento
	durataabbonamento tipologieingresso.durata%type; --contiene la durata dell'abbonamento
	dataEmissione date; --contiene concatenati data e ora nel formato inseribile nel db
	scadenzaabb varchar2(10);
	emissdate date; --contiene data emissione in formato data

BEGIN
	modgui1.apridiv('style="margin-top: 110px"');
	varidtitoloing := idtitoloingseq.nextval;
	
	dataEmissione:=to_date(
                oraemissionechar 
                || ' '
                || dataemissionechar, 'HH24:MI YYYY/MM/DD'
            );
	
	select durata into durataabbonamento from TIPOLOGIEINGRESSO where IDTIPOLOGIAING=idtipologiaselezionata;
	
	
	select count(*) into temp1 from Biglietti where idtipologiaselezionata= biglietti.IDTIPOLOGIAING;
	
	if(temp1>0)
	then --biglietto
		dataScadenza:= to_date('23:59 ' ||dataemissionechar, 'HH24:MI YYYY/MM/DD');
	ELSE --abbonamento
		emissdate:=to_date(dataemissionechar,'YYYY/MM/DD');
		temp2:=emissdate+durataabbonamento;
		scadenzaabb:=to_char(temp2, 'YYYY/MM/DD');
		dataScadenza:= to_date('23:59 ' ||scadenzaabb, 'HH24:MI YYYY/MM/DD');
	end if;
	
	INSERT INTO TITOLIINGRESSO(
		idtitoloing,
		Emissione,
		Scadenza,
		Acquirente,
		Tipologia,
		Museo
	) VALUES (
		varidtitoloing,
		dataEmissione,
		dataScadenza,
		idutenteselezionato,
		idtipologiaselezionata,
		idmuseoselezionato
	);
	
	--inserisce negli utenti museo l'utente se non era gia presente
	select count(*) into temp3 from utentimuseo where utentimuseo.IDUTENTE=idutenteselezionato;
	if (temp3<1)
	then
		insert into utentimuseo (idutente, donatore)
		values (idutenteselezionato, 0);
	end if;

	select count(*) into temp4 from titoliingresso where TITOLIINGRESSO.idtitoloing=varidtitoloing;

	if(temp4 is null) then
		IF(temp1>0)
		then
			modGUI1.RedirectEsito('Errore', 
            	'Titolo d''ingresso non inserito correttamente.', 
            	'Riprova', 'packageacquistatitoli.pagina_acquista_biglietto?','dataemissionechar='||dataemissionechar||'//oraemissionechar='||oraemissionechar||'//idmuseoselezionato='||idmuseoselezionato||'//idutenteselezionato='||idutenteselezionato||'//idtipologiaselezionata='||idtipologiaselezionata,
            	'Torna al menu titoli d''ingresso', 'packageacquistatitoli.titolihome', null);
		ELSE
			modGUI1.RedirectEsito('Errore', 
            	'Titolo d''ingresso non inserito correttamente.', 
            	'Riprova', 'packageacquistatitoli.pagina_acquista_abbonamento?','dataemissionechar='||dataemissionechar||'//oraemissionechar='||oraemissionechar||'//idmuseoselezionato='||idmuseoselezionato||'//idutenteselezionato='||idutenteselezionato||'//idtipologiaselezionata='||idtipologiaselezionata,
            	'Torna al menu titoli d''ingresso', 'packageacquistatitoli.titolihome', null);
		end if;
	ELSE
		visualizzatitoloing(varidtitoloing);
	end if;
END;

--ACQUISTO ABBONAMENTO
PROCEDURE formacquistaabbonamento(
	dataEmissionechar IN VARCHAR2,
	oraemissionechar IN VARCHAR2,
	idmuseoselezionato IN VARCHAR2 default null,
	idtipologiaselezionata IN VARCHAR2 default null,
	idutenteselezionato IN VARCHAR2 default null
)IS
	idSessione NUMBER(5) := modgui1.get_id_sessione();

	nomeutente utenti.nome%TYPE;
	cognomeutente utenti.cognome%TYPE;
	varidutente utenti.Idutente%TYPE;
	nometipologia tipologieingresso.nome%TYPE;
	varidmuseo musei.idmuseo%TYPE;
	nomeMuseo musei.Nome%TYPE;
	varidtipologia tipologieingresso.idtipologiaing%TYPE;
	nometiping VARCHAR(25);

	idclientelogged utenti.idutente%type;
BEGIN

	modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
	modgui1.apriform('packageAcquistaTitoli.pagina_acquista_abbonamento', 'formacquistaabbonamento', 'w3-container');
	modgui1.apridiv('class="w3-section"');

	IF hasrole(idSessione,'AB')
		OR hasrole(idSessione,'GM')
		OR hasrole(idSessione,'DBA')
	THEN
	modgui1.label('Utente*: ');
	modgui1.selectopen('idutenteselezionato', 'utente-selezionato');
	for utente in (select idutente from utenti where utenti.ELIMINATO != 1)
	loop
		select idutente, nome, cognome
		into varidutente, nomeutente, cognomeutente
		from utenti
		where idutente=utente.idutente;
		if utente.idutente = idutenteselezionato
		then
			MODGUI1.SelectOption(varidutente, ''|| nomeutente ||' '||cognomeutente||'', 1);
		else
			MODGUI1.SelectOption(varidutente, ''|| nomeutente ||' '||cognomeutente||'', 0);
		end if;
	end loop;
	modgui1.selectclose();
	htp.br;
	ELSE
	SELECT IDCLIENTE INTO idclientelogged FROM UTENTILOGIN WHERE UTENTILOGIN.IDUTENTELOGIN = idSessione;
	htp.formhidden('idutenteselezionato', idclientelogged);
	END IF;

	modgui1.label('Museo*: ');
	modgui1.selectopen('idmuseoselezionato', 'museo-selezionato');
	for museo in (select idmuseo, nome from musei where musei.ELIMINATO != 1)
	loop
		if museo.idmuseo=idmuseoselezionato
		then modgui1.SelectOption(museo.idmuseo, museo.nome, 1);
		else modgui1.SelectOption(museo.idmuseo, museo.nome, 0);
		end if;
	end loop;
	modgui1.SelectClose();
	htp.br;

	modgui1.label('Tipologia di abbonamento*: ');
	modgui1.selectopen('idtipologiaselezionata', 'tipologia-selezionata');
	for tipologia in (
		select TIPOLOGIEINGRESSO.IDTIPOLOGIAING, TIPOLOGIEINGRESSO.NOME
		into varidtipologia, nometiping
		from TIPOLOGIEINGRESSOMUSEI JOIN TIPOLOGIEINGRESSO
        ON TIPOLOGIEINGRESSO.IDTIPOLOGIAING=TIPOLOGIEINGRESSOMUSEI.IDTIPOLOGIAING
		join abbonamenti
		on abbonamenti.IDTIPOLOGIAING = tipologieingresso.idtipologiaing
		where IdMuseo=idmuseoselezionato and TIPOLOGIEINGRESSO.ELIMINATO != 1
	)
	LOOP
		if idtipologiaselezionata= tipologia.idtipologiaing
		then
			modgui1.SelectOption(tipologia.idtipologiaing, tipologia.nome, 1);
		else
			modgui1.SelectOption(tipologia.idtipologiaing, tipologia.nome, 0);
		end if;
	end loop;
	htp.br;
	modgui1.selectclose();

	htp.br;
	modgui1.Label('Data emissione abbonamento*: ');
	modgui1.inputdate('DataEmissioneChar', 'DataEmissioneChar', 1, dataEmissionechar);
	modgui1.inputtime('oraemissionechar','oraemissionechar', oraemissionechar);
	HTP.br;

	htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit" name="convalida" value="1">Acquista</button>');
	modgui1.collegamento(
                        'Torna alla visualizzazione di tutti i titoli d''ingresso',
                        'packageAcquistaTitoli.titolihome',
                        'w3-button w3-block w3-red w3-section w3-padding'
                		);
	modgui1.ChiudiDiv();
	modgui1.chiudiform();
	modgui1.chiudidiv();
	htp.prn('<script>
				document.getElementById("museo-selezionato").onchange= function inviaformacquistaabbonamento(){
					document.formacquistaabbonamento.submit();
					}
	</script>');
END;

PROCEDURE pagina_acquista_abbonamento(
	dataEmissionechar VARCHAR2 DEFAULT NULL,
	oraemissionechar VARCHAR2 DEFAULT NULL,
	idmuseoselezionato VARCHAR2 DEFAULT NULL,
	idtipologiaselezionata VARCHAR2 DEFAULT NULL,
	idutenteselezionato VARCHAR2 DEFAULT NULL,
	convalida IN NUMBER DEFAULT NULL
) IS
	idSessione NUMBER(5) := modgui1.get_id_sessione();
BEGIN
	modgui1.apripagina('Pagina acquisto abbonamento');
	modgui1.header();
	modgui1.apridiv('style="margin-top: 110px"');
	htp.prn('<h1 align="center"> Acquisto abbonamento </h1>');

	if convalida IS NULL
	then
		formacquistaabbonamento(dataEmissionechar, oraemissionechar,
					idmuseoselezionato, idtipologiaselezionata, idutenteselezionato);
	else
		confermaacquisto(dataEmissionechar, oraemissionechar,
							idmuseoselezionato, idtipologiaselezionata, idutenteselezionato);
	end if;

	modgui1.chiudidiv(); 
	HTP.BodyClose;
	HTP.HtmlClose;
END;


--ACQUISTO BIGLIETTO
PROCEDURE formacquistabiglietto(
	dataEmissionechar IN VARCHAR2,
	oraemissionechar in varchar2,
	idmuseoselezionato IN VARCHAR2 default null,
	idtipologiaselezionata IN VARCHAR2 default null,
	idutenteselezionato IN VARCHAR2 default null
)IS
	idSessione NUMBER(5) := modgui1.get_id_sessione();

	nomeutente utenti.nome%TYPE;
	cognomeutente utenti.cognome%TYPE;
	varidutente utenti.Idutente%TYPE;
	nometipologia tipologieingresso.nome%TYPE;
	varidmuseo musei.idmuseo%TYPE;
	nomeMuseo musei.Nome%TYPE;
	varidtipologia tipologieingresso.idtipologiaing%TYPE;
	nometiping VARCHAR(25);

	idclientelogged utenti.idutente%type;
BEGIN

	modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
	modgui1.apriform('packageAcquistaTitoli.pagina_acquista_biglietto', 'formacquistabiglietto', 'w3-container');
	modgui1.apridiv('class="w3-section"');

	IF hasrole(idSessione,'AB')
		OR hasrole(idSessione,'GM')
		OR hasrole(idSessione,'DBA')
	THEN
	modgui1.label('Utente*: ');
	modgui1.selectopen('idutenteselezionato', 'utente-selezionato');
	for utente in (select idutente from utenti where eliminato != 1)
	loop
		select idutente, nome, cognome
		into varidutente, nomeutente, cognomeutente
		from utenti
		where idutente=utente.idutente;
		if utente.idutente = idutenteselezionato
		then
			MODGUI1.SelectOption(varidutente, ''|| nomeutente ||' '||cognomeutente||'', 1);
		else
			MODGUI1.SelectOption(varidutente, ''|| nomeutente ||' '||cognomeutente||'', 0);
		end if;
	end loop;
	modgui1.selectclose();
	htp.br;
	ELSE
	SELECT IDCLIENTE INTO idclientelogged FROM UTENTILOGIN WHERE UTENTILOGIN.IDUTENTELOGIN = idSessione;
	htp.formhidden('idutenteselezionato', idclientelogged);
	END IF;

	modgui1.label('Museo*: ');
	modgui1.selectopen('idmuseoselezionato', 'museo-selezionato');
	for museo in (select idmuseo, nome from musei where eliminato != 1 )
	loop
		if museo.idmuseo=idmuseoselezionato
		then modgui1.SelectOption(museo.idmuseo, museo.nome, 1);
		else modgui1.SelectOption(museo.idmuseo, museo.nome, 0);
		end if;
	end loop;
	modgui1.SelectClose();
	htp.br;

	modgui1.label('Tipologia di biglietto*: ');
	modgui1.selectopen('idtipologiaselezionata', 'tipologia-selezionata');
	for tipologia in (
		select TIPOLOGIEINGRESSO.IDTIPOLOGIAING, NOME
		from TIPOLOGIEINGRESSOMUSEI JOIN TIPOLOGIEINGRESSO
        ON TIPOLOGIEINGRESSO.IDTIPOLOGIAING=TIPOLOGIEINGRESSOMUSEI.IDTIPOLOGIAING
		join biglietti
		on biglietti.IDTIPOLOGIAING = tipologieingresso.idtipologiaing
		where IdMuseo=idmuseoselezionato and TIPOLOGIEINGRESSO.ELIMINATO != 1
	)
	LOOP
		if idtipologiaselezionata= tipologia.idtipologiaing
		then
			modgui1.SelectOption(tipologia.idtipologiaing, tipologia.nome, 1);
		else
			modgui1.SelectOption(tipologia.idtipologiaing, tipologia.nome, 0);
		end if;
	end loop;
	htp.br;
	modgui1.selectclose();
	htp.br;

	modgui1.Label('Data emissione biglietto*: ');
	modgui1.inputdate('DataEmissioneChar', 'DataEmissioneChar', 1, dataEmissionechar);
	modgui1.inputtime('oraemissionechar', 'oraemissionechar', 1, oraemissionechar);
	HTP.br;

	htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit" name="convalida" value="1">Acquista</button>');
	modgui1.collegamento(
                        'Torna alla visualizzazione di tutti i titoli d''ingresso',
                        'packageAcquistaTitoli.titolihome',
                        'w3-button w3-block w3-red w3-section w3-padding'
                		);
	modgui1.ChiudiDiv();
	modgui1.chiudiform();
	modgui1.chiudidiv();
	htp.prn('<script>
				document.getElementById("museo-selezionato").onchange= function inviaformacquistaabbonamento(){
					document.formacquistabiglietto.submit();
					}
	</script>');
END;

PROCEDURE confermaacquisto(
	dataEmissionechar VARCHAR2 DEFAULT NULL,
	oraemissionechar varchar2 default null,
	idmuseoselezionato VARCHAR2 DEFAULT NULL,
	idtipologiaselezionata VARCHAR2 DEFAULT NULL,
	idutenteselezionato VARCHAR2 DEFAULT NULL
)IS
	idSessione NUMBER(5) := modgui1.get_id_sessione();

	nomeutente  VARCHAR(100);
	cognomeutente VARCHAR(100);
	nomemuseo VARCHAR(100);
	nometipologia VARCHAR(100);
	flag number(1);
BEGIN
	select count(*) into flag from biglietti where idtipologiaselezionata=biglietti.idtipologiaing;
	SELECT nome into nomeutente from utenti where idutente = idutenteselezionato;
	select cognome into cognomeutente from utenti where idutente=idutenteselezionato;
	select nome into nomemuseo from musei where idmuseo=idmuseoselezionato;
	select nome into nometipologia from tipologieingresso where idtipologiaing=idtipologiaselezionata;

	if (flag>0)
	then
		IF (dataEmissionechar is null) THEN
		modGUI1.RedirectEsito('Errore', 
            'Data di emissione non selezionata', 
            'Riprova', 'packageacquistatitoli.pagina_acquista_biglietto?','dataemissionechar='||dataemissionechar||'//oraemissionechar='||oraemissionechar||'//idmuseoselezionato='||idmuseoselezionato||'//idutenteselezionato='||idutenteselezionato||'//idtipologiaselezionata='||idtipologiaselezionata,
            'Torna al menu titoli d''ingresso', 'packageacquistatitoli.titolihome', null);
    	ELSIF idmuseoselezionato is null THEN
		modGUI1.RedirectEsito('Errore', 
            'Nessun museo selezionato', 
            'Riprova', 'packageacquistatitoli.pagina_acquista_biglietto?','dataemissionechar='||dataemissionechar||'//oraemissionechar='||oraemissionechar||'//idmuseoselezionato='||idmuseoselezionato||'//idutenteselezionato='||idutenteselezionato||'//idtipologiaselezionata='||idtipologiaselezionata,
            'Torna al menu titoli d''ingresso', 'packageacquistatitoli.titolihome', null);
   		ELSIF idtipologiaselezionata is null THEN
		modGUI1.RedirectEsito('Errore', 
            'Nessuna tipologia d''ingresso selezionata', 
            'Riprova', 'packageacquistatitoli.pagina_acquista_biglietto?','dataemissionechar='||dataemissionechar||'//oraemissionechar='||oraemissionechar||'//idmuseoselezionato='||idmuseoselezionato||'//idutenteselezionato='||idutenteselezionato||'//idtipologiaselezionata='||idtipologiaselezionata,
            'Torna al menu titoli d''ingresso', 'packageacquistatitoli.titolihome', null);
   		ELSIF idutenteselezionato is null THEN
		modGUI1.RedirectEsito('Errore', 
            'Nessun utente selezionato', 
            'Riprova', 'packageacquistatitoli.pagina_acquista_biglietto?','dataemissionechar='||dataemissionechar||'//oraemissionechar='||oraemissionechar||'//idmuseoselezionato='||idmuseoselezionato||'//idutenteselezionato='||idutenteselezionato||'//idtipologiaselezionata='||idtipologiaselezionata,
            'Torna al menu titoli d''ingresso', 'packageacquistatitoli.titolihome', null);
		ELSIF (dataemissionechar is not null and to_date(dataEmissionechar, 'YYYY/MM/DD')>sysdate) THEN
		modGUI1.RedirectEsito('Errore', 
            'Data di emissione selezionata maggiore della data corrente', 
            'Riprova', 'packageacquistatitoli.pagina_acquista_biglietto?','dataemissionechar='||dataemissionechar||'//oraemissionechar='||oraemissionechar||'//idmuseoselezionato='||idmuseoselezionato||'//idutenteselezionato='||idutenteselezionato||'//idtipologiaselezionata='||idtipologiaselezionata,
            'Torna al menu titoli d''ingresso', 'packageacquistatitoli.titolihome', null);
    	ELSE
		MODGUI1.APRIPAGINA('Pagina Conferma');
		HTP.BodyOpen;
		modgui1.header();
		htp.prn('<h2 align="center"> Conferma immissione dati </h2>');
		MODGUI1.ApriDivcard();
		HTP.header(3, 'Nuovo Biglietto', 'center');

		HTP.TableOpen;
		HTP.TableRowOpen;
		HTP.TableData('Nome: ');
		HTP.TableData(nomeutente);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		htp.tabledata('Cognome: ');
		htp.tabledata(cognomeutente);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Museo: ');
		HTP.TableData(nomemuseo);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Tipologia di ingresso: ');
		HTP.TableData(nometipologia);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Data Emissione: ');
		HTP.TableData(dataEmissioneChar || ' ' || oraemissionechar);
		HTP.TableRowClose;
		HTP.TableClose;
		end if;

	ELSE
		IF (dataEmissionechar is null) THEN
		modGUI1.RedirectEsito('Errore', 
            'Data di emissione non selezionata', 
            'Riprova', 'packageacquistatitoli.pagina_acquista_abbonamento?','dataemissionechar='||dataemissionechar||'//oraemissionechar='||oraemissionechar||'//idmuseoselezionato='||idmuseoselezionato||'//idutenteselezionato='||idutenteselezionato||'//idtipologiaselezionata='||idtipologiaselezionata,
            'Torna al menu titoli d''ingresso', 'packageacquistatitoli.titolihome', null);
    	ELSIF idmuseoselezionato is null THEN
		modGUI1.RedirectEsito('Errore', 
            'Nessun museo selezionato', 
            'Riprova', 'packageacquistatitoli.pagina_acquista_abbonamento?','dataemissionechar='||dataemissionechar||'//oraemissionechar='||oraemissionechar||'//idmuseoselezionato='||idmuseoselezionato||'//idutenteselezionato='||idutenteselezionato||'//idtipologiaselezionata='||idtipologiaselezionata,
            'Torna al menu titoli d''ingresso', 'packageacquistatitoli.titolihome', null);
   		ELSIF idtipologiaselezionata is null THEN
		modGUI1.RedirectEsito('Errore', 
            'Nessuna tipologia d''ingresso selezionata', 
            'Riprova', 'packageacquistatitoli.pagina_acquista_abbonamento?','dataemissionechar='||dataemissionechar||'//oraemissionechar='||oraemissionechar||'//idmuseoselezionato='||idmuseoselezionato||'//idutenteselezionato='||idutenteselezionato||'//idtipologiaselezionata='||idtipologiaselezionata,
            'Torna al menu titoli d''ingresso', 'packageacquistatitoli.titolihome', null);
   		ELSIF idutenteselezionato is null THEN
		modGUI1.RedirectEsito('Errore', 
            'Nessun utente selezionato', 
            'Riprova', 'packageacquistatitoli.pagina_acquista_abbonamento?','dataemissionechar='||dataemissionechar||'//oraemissionechar='||oraemissionechar||'//idmuseoselezionato='||idmuseoselezionato||'//idutenteselezionato='||idutenteselezionato||'//idtipologiaselezionata='||idtipologiaselezionata,
            'Torna al menu titoli d''ingresso', 'packageacquistatitoli.titolihome', null);
		ELSIF (dataemissionechar is not null and to_date(dataEmissionechar, 'YYYY/MM/DD')>sysdate) THEN
		modGUI1.RedirectEsito('Errore', 
            'Data di emissione selezionata maggiore della data corrente', 
            'Riprova', 'packageacquistatitoli.pagina_acquista_abbonamento?','dataemissionechar='||dataemissionechar||'//oraemissionechar='||oraemissionechar||'//idmuseoselezionato='||idmuseoselezionato||'//idutenteselezionato='||idutenteselezionato||'//idtipologiaselezionata='||idtipologiaselezionata,
            'Torna al menu titoli d''ingresso', 'packageacquistatitoli.titolihome', null);
    	ELSE
		MODGUI1.APRIPAGINA('Pagina Conferma');
		HTP.BodyOpen;
		modgui1.header();
		htp.prn('<h2 align="center"> Conferma immissione dati </h2>');
		MODGUI1.ApriDivcard();
		HTP.header(3, 'Nuovo Abbonamento', 'center');

		HTP.TableOpen;
		HTP.TableRowOpen;
		HTP.TableData('Nome: ');
		HTP.TableData(nomeutente);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		htp.tabledata('Cognome: ');
		htp.tabledata(cognomeutente);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Museo: ');
		HTP.TableData(nomemuseo);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Tipologia di ingresso: ');
		HTP.TableData(nometipologia);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Data Emissione: ');
		HTP.TableData(dataEmissioneChar || ' ' || oraemissionechar);
		HTP.TableRowClose;
		HTP.TableClose;
		end if;

    end if;
		modgui1.apriform('packageAcquistaTitoli.acquistatitolo');
		htp.formhidden('dataemissionechar', dataemissionechar);
		htp.formhidden('oraemissionechar', oraemissionechar);
		htp.formhidden('idmuseoselezionato', idmuseoselezionato);
		htp.formhidden('idtipologiaselezionata', idtipologiaselezionata);
		htp.formhidden('idutenteselezionato', idutenteselezionato);
		modgui1.InputSubmit('Conferma');
		htp.prn('<input id="button_annulla" type="submit" class="w3-button w3-block w3-black w3-section w3-padding" value="Annulla">');
		modgui1.chiudiform;
		modgui1.chiudidiv();
		htp.prn('<script>
			let button_annulla=document.getElementById("button_annulla");
			button_annulla.onclick=function goBack(){
				let form=button_annulla.form;
				form.action="'
				||costanti.server
				||costanti.radice
				||'packageAcquistaTitoli.pagina_acquista_biglietto";
				form.submit();
				}
			</script>');
END;

PROCEDURE pagina_acquista_biglietto(
	dataEmissionechar VARCHAR2 DEFAULT NULL,
	oraemissionechar VARCHAR2 DEFAULT NULL,
	idmuseoselezionato VARCHAR2 DEFAULT NULL,
	idtipologiaselezionata VARCHAR2 DEFAULT NULL,
	idutenteselezionato VARCHAR2 DEFAULT NULL,
	convalida IN NUMBER DEFAULT NULL
)IS
	idSessione NUMBER(5) := modgui1.get_id_sessione();
BEGIN
	modgui1.apripagina('Pagina acquisto biglietto');
	modgui1.header();
	modgui1.apridiv('style="margin-top: 110px"');
	htp.prn('<h1 align="center"> Acquisto biglietto </h1>');

	if convalida IS NULL
	then
		formacquistabiglietto(dataEmissionechar, oraemissionechar, idmuseoselezionato, 
								idtipologiaselezionata, idutenteselezionato);
	else
		confermaacquisto(dataEmissionechar, oraemissionechar, idmuseoselezionato,
								idtipologiaselezionata, idutenteselezionato);
	end if;

	modgui1.chiudidiv(); 
	HTP.BodyClose;
	HTP.HtmlClose;
end;


-- Numero Titoli d’Ingresso emessi in un arco temporale scelto
PROCEDURE statTitoliPerArcoTemp(
	datainizio VARCHAR2 default null,
	datafine VARCHAR2 default null
)IS
	idSessione NUMBER(5) := modgui1.get_id_sessione();

	iniziop date:= to_date(datainizio, 'YYYY-MM-DD');
	finep date:= to_date(datafine, 'YYYY-MM-DD');
	statistica NUMBER(10) default 0;
BEGIN
	if datainizio is null or datafine is NULL or iniziop > finep
	then 
		modgui1.apripagina('Pagina errore');
		modgui1.header();
		modgui1.apridiv('style="margin-top: 110px"');
		htp.prn('<h1> Errore </h1>');
		htp.br();
		htp.print('Arco temporale non valido.');
    	modgui1.chiudidiv;
    	htp.BodyClose;
    	htp.HtmlClose;
	ELSE
		modgui1.apripagina('Visualizzazione Statistica');
		modgui1.header();
		modgui1.apridiv('style="margin-top: 110px"');
		modgui1.apridivcard();
		htp.prn('<h1> Statistica titoli ingresso </h1>');

		SELECT count(*)
		into statistica
		from TITOLIINGRESSO
		where iniziop <= titoliingresso.Emissione and titoliingresso.Emissione <= finep;

		HTP.TableOpen;
		HTP.TableRowOpen;
		HTP.TableData('Data inizio periodo: ');
		HTP.TableData(datainizio);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		htp.tabledata('Data fine periodo: ');
		htp.tabledata(finep);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Numero di titoli venduti durante l`arco temporale scelto: ');
		HTP.TableData(statistica);
		HTP.TableRowClose;
		htp.TableClose;

		htp.BodyClose;
		htp.HtmlClose;
	end if;

END; 

PROCEDURE abbonamenti_in_scadenza
IS
	idSessione NUMBER(5) := modgui1.get_id_sessione();
	quant number(10):= null;
	meseattuale varchar2(4):= to_char(sysdate, 'MM');
	giornoattuale varchar2(4):= to_char(sysdate, 'DD');
	annoattuale varchar2(4):= to_char(sysdate, 'YYYY');
BEGIN

	select count(*) into quant
					from titoliingresso 
					inner join TIPOLOGIEINGRESSO on TITOLIINGRESSO.TIPOLOGIA=TIPOLOGIEINGRESSO.IDTIPOLOGIAING
					inner join abbonamenti on TIPOLOGIEINGRESSO.IDTIPOLOGIAING=ABBONAMENTI.IDTIPOLOGIAING
					where to_char(TITOLIINGRESSO.scadenza,'MM')=meseattuale AND to_char(TITOLIINGRESSO.scadenza,'DD')>=giornoattuale and to_char(TITOLIINGRESSO.scadenza,'YYYY')=annoattuale;

	modgui1.apripagina('Visualizzazione Statistica');
	modgui1.header();
	modgui1.apridiv('style="margin-top: 110px"');
	htp.prn('<h1 align="center">Abbonamenti in scadenza questo mese</h1>');

	htp.prn('<p p align="center"> Sono presenti <b> '||quant|| '</b> abbonamenti in scadenza entro la fine del mese </p>');
	modGUI1.ApriDiv('class="w3-center"');
    modGUI1.ApriDiv('class="w3-row w3-container"');

	FOR k IN (select distinct titoliingresso.idtitoloing as idtitolo, musei.nome as nomemuseo, tipologieingresso.nome as nometipologia,
							 utenti.nome as nomeutente, utenti.cognome as cognomeutente, musei.IDMUSEO as idmuseo, TITOLIINGRESSO.EMISSIONE as emiss, SCADENZA as scad
						from titoliingresso 
						join TIPOLOGIEINGRESSO on TITOLIINGRESSO.TIPOLOGIA=TIPOLOGIEINGRESSO.IDTIPOLOGIAING
						join utenti on titoliingresso.ACQUIRENTE=utenti.IDUTENTE
						join tipologieingressomusei on tipologieingresso.IDTIPOLOGIAING= tipologieingressomusei.IDTIPOLOGIAING
						join musei on TITOLIINGRESSo.MUSEO= musei.IDMUSEO
						join abbonamenti on TIPOLOGIEINGRESSO.IDTIPOLOGIAING=ABBONAMENTI.IDTIPOLOGIAING
						where to_char(TITOLIINGRESSO.scadenza,'MM')=meseattuale AND to_char(TITOLIINGRESSO.scadenza,'DD')>=giornoattuale and to_char(TITOLIINGRESSO.scadenza,'YYYY')=annoattuale
						order by IDTITOLOING
		)
	LOOP
                modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                    modGUI1.ApriDiv('class="w3-card-4"');
                            modGUI1.ApriDiv('class="w3-container w3-center"');
                            --INIZIO DESCRIZIONI
                                htp.prn('<p>Titolo d''ingresso: <b>'||k.idtitolo||'</b> </p>');
								htp.prn('<p>Titolare: '||k.nomeutente || ' ' || k.cognomeutente||' </p>');
								htp.prn('<p>Museo: '|| k.nomemuseo ||'</p>');
                                htp.prn('<p>'|| k.nometipologia ||'</p>');
								htp.prn('<p>Scadenza: '||to_char(k.scad, 'DD/MON/YYYY')||' </p>');
		
                            --FINE DESCRIZIONI
                            modGUI1.ChiudiDiv;
                            
            				MODGUI1.Collegamento(
								'Visualizza',
								'packageAcquistaTitoli.visualizzatitoloing?varidtitoloing='||k.idtitolo,
								'w3-button w3-margin w3-black');
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
    END LOOP;
	modGUI1.ChiudiDiv;
	modGUI1.ChiudiDiv;
	modGUI1.ApriDiv('class="w3-center"');
	MODGUI1.Collegamento(
								'Torna alla visualizzazione dei titoli d''ingresso',
								'packageAcquistaTitoli.titiolihome',
								'w3-button w3-margin w3-black');
	modGUI1.ChiudiDiv;
	htp.BodyClose;
	htp.HtmlClose;
	



END;


END packageAcquistaTitoli;
