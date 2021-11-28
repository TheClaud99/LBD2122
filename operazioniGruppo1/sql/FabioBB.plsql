
CREATE OR REPLACE PACKAGE BODY testFB AS

	PROCEDURE visualizzaNewsletters
	IS
		id_sessione NUMBER(10) := NULL;
		sessionIdExecption EXCEPTION;
	BEGIN

		id_sessione := modgui1.get_id_sessione;
		if id_sessione = 0
		THEN
			RAISE sessionIdExecption;
		end if;

		MODGUI1.ApriPagina('Newsletter', id_sessione);
		modgui1.header(id_sessione);
		modgui1.apridiv('style="margin-top: 110px"');
        modgui1.apridiv('class="w3-center"');
        htp.prn('<h1>Newsletter</h1>');

		--TODO-hasperms()..

		/*if hasRole(id_sessione, 'DBA')
			OR hasRole(id_sessione, 'AB')
			OR hasRole(id_sessione, 'GM')
			OR hasRole(id_sessione, 'GCE')
			OR hasRole(id_sessione, 'GO')
		*/

		if hasRole(id_sessione, 'DBA')
		THEN
			modgui1.collegamento(
                                'Aggiungi',
                                'testFB.inserisciNewsLetter',
                                'w3-btn w3-round-xxlarge w3-green'
            );
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
			---TODO stampare meglio le newsletter.
            modgui1.apridiv('class="w3-col l4 w3-padding-large w3-center"');
            modgui1.apridiv('class="w3-card-4"');
            htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%">');
            modgui1.apridiv('class="w3-container w3-center"');
			htp.prn(to_char(newsletter.IDNEWS));
			htp.br;
			htp.prn(to_char(newsletter.NOME));
			htp.br;
			htp.prn(to_char(newsletter.ELIMINATO));
			htp.br;
			modgui1.chiudidiv;
			--todo has perms
			/*
            IF ( id_sessione = 1 ) THEN
                modgui1.collegamento(
                                    'Modifica',
                                    'packagevisite.pagina_modifica_visita?carica_default=1--idvisitaselezionata=' || visita.idvisita,
                                    'w3-button w3-margin w3-green'
                );
                modgui1.collegamento(
                                    'Rimuovi',
                                    'packagevisite.pagina_rimuovi_visita?idvisitaselezionata=' || visita.idvisita,
                                    'w3-button w3-margin w3-red'
                );
            END IF;*/
			if hasRole(id_sessione, 'DBA')
			THEN
				modgui1.collegamento(
									'Elimina',
									'PackageVisite.....',
									'w3-btn w3-round-xxlarge w3-red'
				);
				modgui1.collegamento(
									'Statistiche',
									'testFB.statisticheNewsLetter?newsletterID=' || TO_CHAR(newsletter.IDNEWS),
									'w3-btn w3-round-xxlarge w3-black'
				);
			END IF;

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
		MODGUI1.Header(id_sessione);
		HTP.BodyOpen;

		MODGUI1.ApriDiv;
		MODGUI1.LABEL('idSessione non settato o corretto');
		MODGUI1.collegamento('visualizza newsletter', 'visualizzaNewsletter');
		MODGUI1.ChiudiDiv;

		HTP.BodyClose;
		HTP.HtmlClose;


	END;

	PROCEDURE statisticheNewsLetter (
		newsletterID NUMBER DEFAULT -1
	) IS
		id_sessione NUMBER(10) := NULL;
		temp NUMBER(10) := 0;
		nomeNew VARCHAR2(100) := '';
		numeroVisitatori NUMBER(10) := 0;
		etaMediaIscritti NUMBER(10) := 0;


		--utente
		U_NOME UTENTI.NOME%TYPE :='';
		U_COGNOME UTENTI.COGNOME%TYPE :='';
		U_NASCITA UTENTI.DATANASCITA%TYPE :='';
		U_EMAIL UTENTI.EMAIL%TYPE :='';
		U_INDIRIZZO UTENTI.INDIRIZZO%TYPE :='';
		U_RECAPITO UTENTI.RECAPITOTELEFONICO%TYPE :='';

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
		SELECT count(*) into numeroVisitatori from UTENTI where IdUtente IN (select VISITATORE from VISITE) AND IDUTENTE IN (SELECT IDUTENTE FROM NEWSLETTERUTENTI WHERE IDNEWS = newsletterID);

		SELECT avg(age) into etaMediaIscritti FROM (SELECT MONTHS_BETWEEN(sysdate, UTENTI.DATANASCITA) / 12 age FROM UTENTI WHERE UTENTI.IDUTENTE IN (SELECT NEWSLETTERUTENTI.IDUTENTE FROM NEWSLETTERUTENTI WHERE NEWSLETTERUTENTI.IDNEWS = newsletterID));


		MODGUI1.ApriPagina('Statistiche',id_sessione);
		modgui1.header(id_sessione);
		modgui1.apridiv('style="margin-top: 110px;text-align:center;"');
		htp.prn(CONCAT('<h1> statistiche per newsletter </h1>', nomeNew));
		htp.br();
		modgui1.Label('Numero visitatori: ');
		modgui1.Label(TO_CHAR(numeroVisitatori));
		htp.br();
		modgui1.Label('Età media iscritti: ');
		modgui1.Label(TO_CHAR(etaMediaIscritti));
		htp.br();

		--hdaidhiaodh
		modgui1.Label('Titoli di ingresso degli iscritti alla newsletter:');
		--per ogni utente che è iscitto alla newsletter
		--mostrare TUTTI i titoli di ingresso che ha acquistato

		SELECT MAX(numb) INTO temp FROM (SELECT count(*) numb FROM TITOLIINGRESSO GROUP BY TITOLIINGRESSO.ACQUIRENTE);

		htp.prn('<table style="width:100%" border="2">');
		htp.prn('<tr>');
			htp.prn('<th> utente </th>');
			for k in 0..temp
			LOOP
				htp.prn(CONCAT(CONCAT('<th> acquisto ', k + 1), '</th>'));
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
			--primo printare i dati dell'utente.
			SELECT UTENTI.NOME, UTENTI.COGNOME, UTENTI.DATANASCITA, UTENTI.INDIRIZZO, UTENTI.EMAIL, UTENTI.RECAPITOTELEFONICO
				INTO U_NOME, U_COGNOME, U_NASCITA, U_INDIRIZZO, U_EMAIL, U_RECAPITO
				FROM UTENTI
				WHERE UTENTI.IDUTENTE = id_utente.IDUTENTE;

			htp.prn(TO_CHAR(U_NOME));
			htp.prn(TO_CHAR(U_COGNOME));
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
			htp.prn(CONCAT('ID: ', TO_CHAR(titolo.IDTITOLOING)));
			htp.br;
			htp.prn(CONCAT('EMISSIONE: ', TO_CHAR(titolo.EMISSIONE, 'YYYY-MM-DD HH24:MI')));
			htp.br;
			htp.prn(CONCAT('SCADENZA: ', TO_CHAR(titolo.SCADENZA, 'YYYY-MM-DD')));
			htp.br;
			htp.prn(CONCAT('TIPOLOGIA: ', TO_CHAR(titolo.TIPOLOGIA)));
			htp.br;

			htp.prn('</td>');
			END LOOP;

			htp.prn('</tr>');

		END LOOP;
		htp.prn('</table>');
		----dshaheoh
		MODGUI1.chiudiDiv;
		htp.bodyclose;
		htp.htmlclose;

		EXCEPTION
		when newsletterInesistente THEN
			MODGUI1.ApriPagina('Errore newsletter', id_sessione);
			MODGUI1.Header(id_sessione);
			HTP.BodyOpen;

			MODGUI1.ApriDiv;
			MODGUI1.LABEL('newsletter inesistente');
			MODGUI1.collegamento('visualizza newsletter', 'visualizzaNewsletter');
			MODGUI1.ChiudiDiv;

			HTP.BodyClose;
			HTP.HtmlClose;
		WHEN sessionIdExecption THEN
			MODGUI1.ApriPagina('Errore SessionID', id_sessione);
			MODGUI1.Header(id_sessione);
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
	MODGUI1.Header(id_sessione);
	modgui1.apridiv('style="margin-top: 110px"');
	modgui1.ApriDivCard;
	HTP.header(1,'Inserisci una nuova newsletter', 'center');

	MODGUI1.ApriForm('testfb.inserisci_newsletter');

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
	MODGUI1.Header(id_sessione);
	modgui1.apridiv('style="margin-top: 110px"');
	modgui1.ApriDivCard;
	if checked = 0 then
		HTP.header(1,'Conferma Newsletter', 'center');
		MODGUI1.ApriForm('testfb.inserisci_newsletter');
		HTP.FORMHIDDEN('checked',1);
		HTP.FORMHIDDEN('nome',nome);
	END IF;

	if checked = 1 THEN
		HTP.header(1,'Newsletter inserita', 'center');
		MODGUI1.ApriForm('testfb.visualizzaNewsletters');
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

END testFB;