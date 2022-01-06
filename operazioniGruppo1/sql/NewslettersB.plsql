SET DEFINE OFF;

CREATE OR REPLACE PACKAGE BODY Newsletters AS

	PROCEDURE visualizzaNewsletters
	IS
		id_sessione NUMBER(10) := NULL;
		id_client NUMBER(10) := NULL;
		sessionIdExecption EXCEPTION;

		temp NUMBER(10) := NULL;
	BEGIN

		id_sessione := modgui1.get_id_sessione;
		if id_sessione = 0
		THEN
			RAISE sessionIdExecption;
		end if;

		MODGUI1.ApriPagina('Newsletter');
		modgui1.header();
		modgui1.apridiv('style="margin-top: 110px"');
        modgui1.apridiv('class="w3-center"');
        htp.prn('<h1>Newsletter</h1>');

		SELECT IDCLIENTE INTO id_client FROM UTENTILOGIN WHERE UTENTILOGIN.IDUTENTELOGIN = id_sessione;

		if hasRole(id_sessione, 'DBA')
		THEN
			modgui1.collegamento(
                                'Aggiungi',
                                'Newsletters.inserisciNewsLetter',
                                'w3-btn w3-round-xxlarge w3-green');
		END IF;
        modgui1.chiudidiv;
        htp.br;
        modgui1.apridiv('class="w3-row w3-container"');
        --INIZIO LOOP DELLA VISUALIZZAZIONE
        FOR newsletter IN (
            SELECT
                *
            FROM
                NEWSLETTER
			WHERE NEWSLETTER.ELIMINATO = 0
        ) LOOP
            modgui1.apridiv('class="w3-col l4 w3-padding-large w3-center"');
            modgui1.apridiv('class="w3-card-4"');
            htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%">');
            modgui1.apridiv('class="w3-container w3-center"');
			htp.prn(to_char(newsletter.IDNEWS));
			htp.br;
			htp.prn(to_char(newsletter.NOME));
			htp.br;
			htp.br;


			if id_client IS NOT NULL
			THEN
				--questa querry non potrà mai fallire.
				SELECT COUNT(*) INTO temp FROM NEWSLETTERUTENTI WHERE NEWSLETTERUTENTI.IDNEWS = newsletter.IDNEWS AND NEWSLETTERUTENTI.IDUTENTE = id_client;

				if temp = 0
				THEN
					--utente selezionato non è iscritto alla newsletter
					modgui1.collegamento(
										'Iscriviti',
										'Newsletters.iscrivitiNewsletter?newsletterid=' || TO_CHAR(newsletter.IDNEWS) || '&clientid=' || TO_CHAR(id_client),
										'w3-btn w3-round-xxlarge w3-green'
					);
				end if;

				if temp > 0
				THEN
					--utente selezionato non è iscritto alla newsletter
					modgui1.collegamento(
										'Disiscriviti',
										'Newsletters.disiscrivitiNewsletter?newsletterid=' || TO_CHAR(newsletter.IDNEWS) || '&clientid=' || TO_CHAR(id_client),
										'w3-btn w3-round-xxlarge w3-red'
					);
				end if;
			END IF;

			if hasRole(id_sessione, 'DBA')
			THEN
				modgui1.collegamento(
									'Elimina',
									'Newsletters.confermaRimozioneNewsletter?newsletterID=' || TO_CHAR(newsletter.IDNEWS),
									'w3-btn w3-round-xxlarge w3-red'
				);
				modgui1.collegamento(
									'Statistiche',
									'Newsletters.statisticheNewsLetter?newsletterID=' || TO_CHAR(newsletter.IDNEWS),
									'w3-btn w3-round-xxlarge w3-black'
				);
			END IF;
			htp.br;
			htp.br;
			modgui1.chiudidiv;
            modgui1.chiudidiv;
            modgui1.chiudidiv;
        END LOOP;

        modgui1.chiudidiv();
        modgui1.chiudidiv();
        htp.prn('</body>
        </html>');
		EXCEPTION
		WHEN sessionIdExecption THEN
		MODGUI1.ApriPagina('Errore SessionID', id_sessione);
		MODGUI1.Header();
		HTP.BodyOpen;

		modgui1.apridiv('style="margin-top: 110px"');
		MODGUI1.LABEL('idSessione non settato o corretto');
		MODGUI1.collegamento('visualizza newsletter', 'visualizzaNewsletter');
		MODGUI1.ChiudiDiv;

		HTP.BodyClose;
		HTP.HtmlClose;


	END;

	PROCEDURE iscrivitiNewsletter (
		newsletterid NUMBER DEFAULT -1,
		clientid NUMBER DEFAULT -1
	) IS
		id_sessione NUMBER(10) := NULL;
		newslettername VARCHAR2(50) := NULL;
		dataErrorException EXCEPTION;
	BEGIN

		if newsletterid = -1 OR clientid = -1
		THEN
			raise dataErrorException;
		end if;

		SELECT NEWSLETTER.NOME INTO newslettername FROM NEWSLETTER WHERE NEWSLETTER.IDNEWS = newsletterid;


		id_sessione := modgui1.get_id_sessione;

		MODGUI1.ApriPagina('Iscrizione newsletter', id_sessione);
		HTP.BodyOpen;
		MODGUI1.Header();
		modgui1.apridiv('style="margin-top: 110px"');
		modgui1.ApriDivCard;
		modgui1.apridiv('class="w3-container w3-center"');
		modgui1.collegamento(
                            'X',
                            'Newsletters.visualizzaNewsletters',
                            ' w3-btn w3-large w3-red w3-display-topright'
        );
		HTP.header(1,'Sei stato inserito nella newsletter', 'center');
		htp.br;
		HTP.prn('<h1> ' || newslettername || '</h1>');
		htp.br;
		htp.br;
		modgui1.collegamento(
					'Visualizza Newsletter',
					'Newsletters.visualizzaNewsletters',
					'w3-btn w3-round-xxlarge w3-black'
		);

		INSERT INTO NEWSLETTERUTENTI VALUES (newsletterid,clientid);
		modgui1.ChiudiDiv;
		modgui1.ChiudiDiv;
		modgui1.ChiudiDiv;
	END;

	PROCEDURE disiscrivitiNewsletter (
		newsletterid NUMBER DEFAULT -1,
		clientid NUMBER DEFAULT -1
	) IS
		id_sessione NUMBER(10) := NULL;
		newslettername VARCHAR2(50) := NULL;
		dataErrorException EXCEPTION;
	BEGIN
		if newsletterid = -1 OR clientid = -1
		THEN
			raise dataErrorException;
		end if;

		SELECT NEWSLETTER.NOME INTO newslettername FROM NEWSLETTER WHERE NEWSLETTER.IDNEWS = newsletterid;


		id_sessione := modgui1.get_id_sessione;

		MODGUI1.ApriPagina('Disiscrizione newsletter', id_sessione);
		HTP.BodyOpen;
		MODGUI1.Header();
		modgui1.apridiv('style="margin-top: 110px"');
		modgui1.ApriDivCard;
		modgui1.apridiv('class="w3-container w3-center"');
		modgui1.collegamento(
                            'X',
                            'Newsletters.visualizzaNewsletters',
                            ' w3-btn w3-large w3-red w3-display-topright'
        );
		HTP.header(1,'Sei stato rimosso dalla newsletter', 'center');
		htp.br;
		HTP.prn('<h1> ' || newslettername || '</h1>');
		htp.br;
		htp.br;
		modgui1.collegamento(
					'Visualizza Newsletter',
					'Newsletters.visualizzaNewsletters',
					'w3-btn w3-round-xxlarge w3-black'
		);

		DELETE FROM NEWSLETTERUTENTI WHERE NEWSLETTERUTENTI.IDNEWS = newsletterid AND NEWSLETTERUTENTI.IDUTENTE = clientid;
		modgui1.ChiudiDiv;
		modgui1.ChiudiDiv;
		modgui1.ChiudiDiv;
	END;

	PROCEDURE statisticheNewsLetter (
		newsletterID NUMBER DEFAULT -1
	) IS
		id_sessione NUMBER(10) := NULL;
		temp NUMBER(10) := 0;
		nomeNew VARCHAR2(100) := '';
		numeroVisitatori NUMBER(10) := 0;
		etaMediaIscritti NUMBER(10) := 0;

		newsletterInesistente EXCEPTION;
		sessionIdExecption EXCEPTION;
	BEGIN

		id_sessione := modgui1.get_id_sessione;
		if id_sessione = 0
		THEN
			RAISE sessionIdExecption;
		end if;

		if newsletterID = -1
		THEN
			RAISE newsletterInesistente;
		end if;

		SELECT count(*) into temp FROM NEWSLETTER where NEWSLETTER.IDNEWS = newsletterID;

		if temp = 0
		THEN
			RAISE newsletterInesistente;
		end if;

		SELECT NOME into nomeNew FROM NEWSLETTER WHERE NEWSLETTER.IDNEWS = newsletterID;
		SELECT count(*) into numeroVisitatori from UTENTI where IdUtente IN (select VISITATORE from VISITE) AND IDUTENTE IN (SELECT IDUTENTE FROM NEWSLETTERUTENTI WHERE IDNEWS = newsletterID) AND UTENTI.ELIMINATO = 0;

		SELECT avg(age) into etaMediaIscritti FROM (SELECT MONTHS_BETWEEN(sysdate, UTENTI.DATANASCITA) / 12 age FROM UTENTI WHERE UTENTI.IDUTENTE IN (SELECT NEWSLETTERUTENTI.IDUTENTE FROM NEWSLETTERUTENTI WHERE NEWSLETTERUTENTI.IDNEWS = newsletterID) AND UTENTI.ELIMINATO = 0);

		SELECT avg(count) into temp  from ( SELECT NEWSLETTERUTENTI.IDUTENTE, count(*) as count
											FROM NEWSLETTERUTENTI
											WHERE NEWSLETTERUTENTI.IDNEWS = newsletterID
														AND NEWSLETTERUTENTI.IDUTENTE IN (	SELECT TITOLIINGRESSO.ACQUIRENTE
																							FROM TITOLIINGRESSO)
											GROUP BY NEWSLETTERUTENTI.IDUTENTE);

		MODGUI1.ApriPagina('Statistiche',id_sessione);
		modgui1.header();
		modgui1.apridiv('style="margin-top: 110px;text-align:center;"');
		modgui1.apridivcard;
		modgui1.collegamento(
                            'X',
                            'Newsletters.visualizzaNewsletters',
                            ' w3-btn w3-large w3-red w3-display-topright'
        );
		htp.prn(CONCAT('<h1> statistiche per newsletter </h1>', nomeNew));
		htp.br();
		modgui1.Label('Numero visitatori: ');
		htp.prn('<span onclick="document.getElementById(''modal_filtri'').style.display=''block''"  title="Close Modal" style="text-decoration: underline;">' || TO_CHAR(numeroVisitatori) || '</span>');
		htp.br();
		modgui1.Label('Età media iscritti: ');
		modgui1.Label(TO_CHAR(etaMediaIscritti));
		htp.br();
		modgui1.Label('Media acquisti da iscritti: ');
		modgui1.Label(TO_CHAR(temp));
		htp.br();


		--modal per vedere gli utenti
		modgui1.apridiv('id="modal_filtri" class="w3-modal"');
			modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
			modgui1.apridiv('class="w3-center"');
			htp.br;
			htp.prn('<span onclick="document.getElementById(''modal_filtri'').style.display=''none''" class="w3-button w3-small w3-red w3-display-topright" title="Close Modal">X</span>');

			htp.br;
			htp.prn('<table style="width:100%" border="2">');
			htp.prn('<tr>');
				htp.prn('<th> id utente </th>');
				htp.prn('<th> nome </th>');
				htp.prn('<th> cognome </th>');
				htp.prn('<th> data nascita </th>');
				htp.prn('<th> indirizzo </th>');
				htp.prn('<th> email </th>');
			htp.prn('</tr>');

			for utente in ( SELECT * from UTENTI where IdUtente IN (select VISITATORE from VISITE) AND IDUTENTE IN (SELECT IDUTENTE FROM NEWSLETTERUTENTI WHERE IDNEWS = newsletterID) AND UTENTI.ELIMINATO = 0)
			LOOP
				htp.prn('<tr>');
				htp.prn('<td>' );
				modgui1.COLLEGAMENTO(TO_CHAR(utente.IDUTENTE), 'packageUtenti.VisualizzaUtente?utenteID=' || TO_CHAR(utente.IDUTENTE));
				htp.prn('</td>');
				htp.prn('<td>' || TO_CHAR(utente.NOME) || '</td>');
				htp.prn('<td>' || TO_CHAR(utente.COGNOME) || '</td>');
				htp.prn('<td>' || TO_CHAR(utente.DATANASCITA, 'YYYY-MM-DD') || '</td>');
				htp.prn('<td>' || TO_CHAR(utente.INDIRIZZO) || '</td>');
				htp.prn('<td>' || TO_CHAR(utente.EMAIL) || '</td>');
				htp.prn('</tr>');
			END LOOP;
			htp.prn('</table>');
			MODGUI1.chiudiDiv;
			MODGUI1.chiudiDiv;
		modgui1.chiudiDiv;
		--modal chiuso.

		SELECT max(count)
		INTO temp
		FROM NEWSLETTERUTENTI
		JOIN (	SELECT TITOLIINGRESSO.ACQUIRENTE as acquirente, count(*) as count
				FROM TITOLIINGRESSO
				GROUP BY TITOLIINGRESSO.ACQUIRENTE) ON NEWSLETTERUTENTI.IDUTENTE = acquirente
		WHERE NEWSLETTERUTENTI.IDNEWS = newsletterID;
		modgui1.Label('Numero massimo di acquisti da iscritti: ');
		modgui1.Label(TO_CHAR(temp));
		htp.br();

		SELECT COUNT(*)
		INTO temp
		FROM (	SELECT NEWSLETTERUTENTI.IDUTENTE
				FROM NEWSLETTERUTENTI
				JOIN (SELECT TITOLIINGRESSO.ACQUIRENTE as acquirente, count(*) as count
					FROM TITOLIINGRESSO
					GROUP BY TITOLIINGRESSO.ACQUIRENTE)
					ON NEWSLETTERUTENTI.IDUTENTE = acquirente
				WHERE NEWSLETTERUTENTI.IDNEWS = newsletterID
					AND count = (SELECT max(count1)
								FROM (	SELECT TITOLIINGRESSO.ACQUIRENTE as acquirente, count(*) as count1
										FROM TITOLIINGRESSO
										GROUP BY TITOLIINGRESSO.ACQUIRENTE)));
		modgui1.Label('iscritti con numero massimo di acquisti: ');
		htp.prn('<span onclick="document.getElementById(''modal_filtri2'').style.display=''block''"  title="Close Modal" style="text-decoration: underline;">' || TO_CHAR(temp) || '</span>');
		htp.br();

		--modal per vedere gli utenti
		modgui1.apridiv('id="modal_filtri2" class="w3-modal"');
			modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
			modgui1.apridiv('class="w3-center"');
			htp.br;
			htp.prn('<span onclick="document.getElementById(''modal_filtri2'').style.display=''none''" class="w3-button w3-small w3-red w3-display-topright" title="Close Modal">X</span>');

			htp.br;
			htp.prn('<table style="width:100%" border="2">');
			htp.prn('<tr>');
				htp.prn('<th> id utente </th>');
				htp.prn('<th> nome </th>');
				htp.prn('<th> cognome </th>');
				htp.prn('<th> data nascita </th>');
				htp.prn('<th> indirizzo </th>');
				htp.prn('<th> email </th>');
			htp.prn('</tr>');

			for utente in ( SELECT * from UTENTI where IdUtente IN ( 	SELECT NEWSLETTERUTENTI.IDUTENTE
																		FROM NEWSLETTERUTENTI
																		JOIN (SELECT TITOLIINGRESSO.ACQUIRENTE as acquirente, count(*) as count
																			FROM TITOLIINGRESSO
																			GROUP BY TITOLIINGRESSO.ACQUIRENTE)
																			ON NEWSLETTERUTENTI.IDUTENTE = acquirente
																		WHERE NEWSLETTERUTENTI.IDNEWS = newsletterID
																			AND count = (SELECT max(count1)
																						FROM (	SELECT TITOLIINGRESSO.ACQUIRENTE as acquirente, count(*) as count1
																								FROM TITOLIINGRESSO
																								GROUP BY TITOLIINGRESSO.ACQUIRENTE)))
													AND UTENTI.ELIMINATO = 0)
			LOOP
				htp.prn('<tr>');
				htp.prn('<td>' );
				modgui1.COLLEGAMENTO(TO_CHAR(utente.IDUTENTE), 'packageUtenti.VisualizzaUtente?utenteID=' || TO_CHAR(utente.IDUTENTE));
				htp.prn('</td>');
				htp.prn('<td>' || TO_CHAR(utente.NOME) || '</td>');
				htp.prn('<td>' || TO_CHAR(utente.COGNOME) || '</td>');
				htp.prn('<td>' || TO_CHAR(utente.DATANASCITA, 'YYYY-MM-DD') || '</td>');
				htp.prn('<td>' || TO_CHAR(utente.INDIRIZZO) || '</td>');
				htp.prn('<td>' || TO_CHAR(utente.EMAIL) || '</td>');
				htp.prn('</tr>');
			END LOOP;
			htp.prn('</table>');
			MODGUI1.chiudiDiv;
			MODGUI1.chiudiDiv;
		modgui1.chiudiDiv;
		--modal chiuso.

		htp.br;
		MODGUI1.COLLEGAMENTO('Visualizza titoli ingresso per iscritti',
							'Newsletters.titoliIngIscritti?newsletterID=' || TO_CHAR(newsletterID),
							'w3-btn w3-round-xxlarge w3-green');
		htp.br;


		MODGUI1.chiudiDiv;
		MODGUI1.chiudiDiv;
		htp.bodyclose;
		htp.htmlclose;

		EXCEPTION
		when newsletterInesistente THEN
			MODGUI1.ApriPagina('Errore newsletter', id_sessione);
			MODGUI1.Header();
			HTP.BodyOpen;

			MODGUI1.ApriDiv;
			MODGUI1.LABEL('newsletter inesistente');
			MODGUI1.collegamento('visualizza newsletter', 'visualizzaNewsletter');
			MODGUI1.ChiudiDiv;

			HTP.BodyClose;
			HTP.HtmlClose;
		WHEN sessionIdExecption THEN
			MODGUI1.ApriPagina('Errore SessionID', id_sessione);
			MODGUI1.Header();
			HTP.BodyOpen;

			MODGUI1.ApriDiv;
			MODGUI1.LABEL('idSessione non settato o corretto');
			MODGUI1.collegamento('visualizza newsletter', 'visualizzaNewsletter');
			MODGUI1.ChiudiDiv;

			HTP.BodyClose;
			HTP.HtmlClose;
	END;


	PROCEDURE titoliIngIscritti (
		newsletterID NUMBER DEFAULT -1
	) IS
			id_sessione NUMBER(10) := NULL;
			temp NUMBER(10) := NULL;
			sessionIdExecption EXCEPTION;


			--utente
			U_NOME UTENTI.NOME%TYPE :='';
			U_COGNOME UTENTI.COGNOME%TYPE :='';
			U_NASCITA UTENTI.DATANASCITA%TYPE :='';
			U_EMAIL UTENTI.EMAIL%TYPE :='';
			U_INDIRIZZO UTENTI.INDIRIZZO%TYPE :='';
			U_RECAPITO UTENTI.RECAPITOTELEFONICO%TYPE :='';
		BEGIN
			id_sessione := modgui1.get_id_sessione;
			if id_sessione = 0
			THEN
				RAISE sessionIdExecption;
			end if;

			MODGUI1.ApriPagina('Titoli Ingresso iscritti', id_sessione);

			HTP.BodyOpen;
			MODGUI1.Header();

			modgui1.apridiv('style="margin-top: 110px;text-align:center;"');
			MODGUI1.COLLEGAMENTO('Torna a statistiche',
							'Newsletters.statisticheNewsLetter?newsletterID=' || TO_CHAR(newsletterID),
							'w3-btn w3-round-xxlarge w3-green');
			htp.br;
			modgui1.Label('Titoli di ingresso degli iscritti alla newsletter:');
			--per ogni utente che è iscitto alla newsletter
			--mostrare TUTTI i titoli di ingresso che ha acquistato

			SELECT MAX(numb) INTO temp FROM (SELECT count(*) numb FROM TITOLIINGRESSO GROUP BY TITOLIINGRESSO.ACQUIRENTE);

			htp.prn('<table style="width:100%" border="2">');
			htp.prn('<tr>');
				htp.prn('<th> utente </th>');
				for k in 0..temp
				LOOP
					htp.prn('<th> acquisto ' || TO_CHAR(k + 1) || '</th>');
				END LOOP;
				htp.prn('</tr>');
				for id_utente in (	SELECT NEWSLETTERUTENTI.IDUTENTE
									FROM NEWSLETTERUTENTI
									WHERE NEWSLETTERUTENTI.IDNEWS = newsletterID
											AND NEWSLETTERUTENTI.IDUTENTE IN (	SELECT TITOLIINGRESSO.ACQUIRENTE
																				FROM TITOLIINGRESSO))
				LOOP
					--id_utente.IDUTENTE tiene id dell'utente
					htp.prn('<tr>');
					htp.prn('<td>');
					SELECT UTENTI.NOME, UTENTI.COGNOME, UTENTI.DATANASCITA, UTENTI.INDIRIZZO, UTENTI.EMAIL, UTENTI.RECAPITOTELEFONICO
						INTO U_NOME, U_COGNOME, U_NASCITA, U_INDIRIZZO, U_EMAIL, U_RECAPITO
						FROM UTENTI
						WHERE UTENTI.IDUTENTE = id_utente.IDUTENTE;

					MODGUI1.COLLEGAMENTO(TO_CHAR(U_NOME) || ' ' ||TO_CHAR(U_COGNOME),
										'packageUtenti.VisualizzaUtente?utenteID=' || TO_CHAR(id_utente.IDUTENTE));
					htp.br;
					htp.prn(TO_CHAR(U_NASCITA, 'YYYY-MM-DD'));
					htp.br;
					htp.prn(TO_CHAR(U_INDIRIZZO));
					htp.br;
					htp.prn(TO_CHAR(U_EMAIL));
					htp.br;
					htp.prn(TO_CHAR(U_RECAPITO));
					htp.prn('</td>');

					FOR titolo IN (
						SELECT *
						FROM TITOLIINGRESSO
						WHERE TITOLIINGRESSO.ACQUIRENTE = id_utente.IDUTENTE
					)
					LOOP
					htp.prn('<td>');
					htp.prn('ID:');
					modgui1.COLLEGAMENTO(TO_CHAR(titolo.IDTITOLOING), 'packageAcquistaTitoli.visualizzatitoloing?varidtitoloing=' || TO_CHAR(titolo.IDTITOLOING));
					htp.br;
					htp.prn(CONCAT('EMISSIONE: ', TO_CHAR(titolo.EMISSIONE, 'YYYY-MM-DD HH24:MI')));
					htp.br;
					htp.prn(CONCAT('SCADENZA: ', TO_CHAR(titolo.SCADENZA, 'YYYY-MM-DD')));
					htp.br;
					--TODO collegamento con tipologia
					htp.prn(CONCAT('TIPOLOGIA: ', TO_CHAR(titolo.TIPOLOGIA)));
					htp.br;

					htp.prn('</td>');
					END LOOP;

					htp.prn('</tr>');

				END LOOP;
				htp.prn('</table>');

				modgui1.chiudidiv;
				htp.bodyclose;
				htp.htmlclose;
				EXCEPTION
				WHEN sessionIdExecption THEN
				MODGUI1.ApriPagina('Errore SessionID', id_sessione);
				MODGUI1.Header();
				HTP.BodyOpen;

				MODGUI1.ApriDiv;
				MODGUI1.LABEL('idSessione non settato o corretto');
				MODGUI1.collegamento('visualizza newsletter', 'visualizzaNewsletter');
				MODGUI1.ChiudiDiv;

				HTP.BodyClose;
				HTP.HtmlClose;

			END;

	PROCEDURE inserisciNewsLetter
		IS
			id_sessione NUMBER(10) := NULL;
			sessionIdExecption EXCEPTION;
		BEGIN

		id_sessione := modgui1.get_id_sessione;
		if id_sessione = 0
		THEN
			RAISE sessionIdExecption;
		end if;
		MODGUI1.ApriPagina('Inserimento newsletter', id_sessione);

		HTP.BodyOpen;
		MODGUI1.Header();
		modgui1.apridiv('style="margin-top: 110px"');
		modgui1.ApriDivCard;
		modgui1.collegamento(
                            'X',
                            'Newsletters.visualizzaNewsletters',
                            ' w3-btn w3-large w3-red w3-display-topright'
        );
		HTP.header(1,'Inserisci una nuova newsletter', 'center');

		MODGUI1.ApriForm('Newsletters.inserisci_newsletter');

		MODGUI1.Label('Nome*');
		MODGUI1.InputText('nome', 'Nome newsletter', 1);
		HTP.BR;
		MODGUI1.InputSubmit('Inserisci');

		MODGUI1.ChiudiDiv;
		MODGUI1.ChiudiForm;
		MODGUI1.ChiudiDiv;

		HTP.BodyClose;
		HTP.HtmlClose;

	END;

	PROCEDURE inserisci_newsletter (
		nome varchar2 DEFAULT 'sconosciuto',
		checked number DEFAULT 0
	) IS
		id_sessione NUMBER(10) := NULL;
		sessionIdExecption EXCEPTION;
	BEGIN

	id_sessione := modgui1.get_id_sessione;
	if id_sessione = 0
	THEN
		RAISE sessionIdExecption;
	end if;

	MODGUI1.ApriPagina('Inserimento newsletter', id_sessione);
	HTP.BodyOpen;
	MODGUI1.Header();
	modgui1.apridiv('style="margin-top: 110px"');
	modgui1.ApriDivCard;
	modgui1.collegamento(
                            'X',
                            'Newsletters.visualizzaNewsletters',
                            ' w3-btn w3-large w3-red w3-display-topright'
        );
	if checked = 0 then
		HTP.header(1,'Conferma Newsletter', 'center');
		MODGUI1.ApriForm('Newsletters.inserisci_newsletter');
		HTP.FORMHIDDEN('checked',1);
		HTP.FORMHIDDEN('nome',nome);
	END IF;

	if checked = 1 THEN
		HTP.header(1,'Newsletter inserita', 'center');
		MODGUI1.ApriForm('Newsletters.visualizzaNewsletters');
	END IF;

	MODGUI1.Label('Nome');
	MODGUI1.label(nome);

	if checked = 0 THEN
		MODGUI1.InputSubmit('Continuare?');
	END IF;

	if checked = 1 THEN
		MODGUI1.InputSubmit('torna a visualizza');
	END IF;

	MODGUI1.ChiudiDiv;
	---copiare dal mano riga 527 VisiteBody


	MODGUI1.ChiudiForm;

	if checked = 1 then
		insert into NEWSLETTER
		values (IdNewsSeq.NEXTVAL, nome, 0);
	END IF;

	MODGUI1.ChiudiDiv;

	END;

	PROCEDURE rimuoviNewsletter (
		newsletterID NUMBER DEFAULT -1
	) IS
		id_sessione NUMBER(10) := NULL;
		newsletterName VARCHAR2(50) := NULL;
	BEGIN
		id_sessione := MODGUI1.GET_ID_SESSIONE;

		SELECT NOME INTO newsletterName FROM NEWSLETTER WHERE NEWSLETTER.IDNEWS = newsletterID;

		MODGUI1.ApriPagina('Rimozione newsletter', id_sessione);
		HTP.BodyOpen;
		MODGUI1.Header();
		modgui1.apridiv('style="margin-top: 110px"');
		modgui1.apridiv('class="w3-container w3-center"');
		modgui1.ApriDivCard;
		modgui1.collegamento(
                            'X',
                            'Newsletters.visualizzaNewsletters',
                            ' w3-btn w3-large w3-red w3-display-topright'
        );
		HTP.header(1,'Newsletter rimossa', 'center');
		htp.br;
		modgui1.LABEL('Nome: ' || newsletterName);
		htp.br;
		MODGUI1.COLLEGAMENTO('Torna a visualizza',
							 'Newsletters.visualizzaNewsletters',
							 'w3-btn w3-round-xxlarge w3-black');

		UPDATE NEWSLETTER SET NEWSLETTER.ELIMINATO = 1 WHERE NEWSLETTER.IDNEWS = newsletterID;
		MODGUI1.ChiudiDiv;
		MODGUI1.ChiudiDiv;
		MODGUI1.ChiudiDiv;



	END;


	PROCEDURE confermaRimozioneNewsletter (
		newsletterID NUMBER DEFAULT -1
	) IS
		id_sessione NUMBER(10) := NULL;
		newsletterName VARCHAR2(50) := NULL;
	BEGIN
		id_sessione := MODGUI1.GET_ID_SESSIONE;

		SELECT NOME INTO newsletterName FROM NEWSLETTER WHERE NEWSLETTER.IDNEWS = newsletterID;

		MODGUI1.ApriPagina('Rimozione newsletter', id_sessione);
		HTP.BodyOpen;
		MODGUI1.Header();
		modgui1.apridiv('style="margin-top: 110px"');
		modgui1.apridiv('class="w3-container w3-center"');
		modgui1.ApriDivCard;
		modgui1.collegamento(
                            'X',
                            'Newsletters.visualizzaNewsletters',
                            ' w3-btn w3-large w3-red w3-display-topright'
        );
		HTP.header(1,'Rimuovere newsletter?', 'center');
		htp.br;
		modgui1.LABEL('Nome: ' || newsletterName);
		htp.br;
		MODGUI1.COLLEGAMENTO('Annulla',
							 'Newsletters.visualizzaNewsletters',
							 'w3-btn w3-round-xxlarge w3-red');
		MODGUI1.COLLEGAMENTO('Conferma',
							 'Newsletters.rimuoviNewsletter?newsletterID=' || TO_CHAR(newsletterID),
							 'w3-btn w3-round-xxlarge w3-green');
		MODGUI1.ChiudiDiv;
		MODGUI1.ChiudiDiv;
		MODGUI1.ChiudiDiv;

	END;

END Newsletters;

