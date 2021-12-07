SET DEFINE OFF;
CREATE OR REPLACE PACKAGE BODY packageAcquistaTitoli AS

/*
 *  OPERAZIONI SUI TITOLI DI INGRESSO
 * - Modifica ❌
 * - Cancellazione 
 * - Visualizzazione 
 * - Acquisto abbonamento museale 
 * - Acquisto biglietto 
 * OPERAZIONI STATISTICHE E MONITORAGGIO
 * - Numero Titoli d’Ingresso emessi in un arco temporale scelto ❌
 * - Numero Titoli d’Ingresso emessi da un Museo in un arco temporale scelto ❌
 * - Abbonamenti in scadenza nel mese corrente ❌
 */

 --VISUALIZZAZIONE
 procedure TitoliHome(
	 idsessione number default 0
 )
 	is
		--IdSessione NUMBER(5) := modgui1.get_id_sessione();
    begin

        htp.prn('<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> ');
        modGUI1.Header(idSessione);
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
        modGUI1.ApriDiv('class="w3-center"');
            htp.prn('<h1>Titoli d''ingresso </h1>'); --TITOLO

            modGUI1.Collegamento('Acquista biglietto','packageAcquistaTitoli.pagina_acquista_biglietto', 'w3-btn w3-round-xxlarge w3-black');
			modGUI1.Collegamento('Acquista abbonamento','packageAcquistaTitoli.pagina_acquista_abbonamento','w3-btn w3-round-xxlarge w3-black'); /*bottone che rimanda alla procedura inserimento solo se la sessione è 1*/
 
        modGUI1.ChiudiDiv;
        htp.br;
        modGUI1.ApriDiv('class="w3-row w3-container"');
        --INIZIO LOOP DELLA VISUALIZZAZIONE
            FOR k IN (select titoliingresso.idtitoloing as idtitolo, tipologieingresso.nome as nometipologia,
							 utenti.nome as nomeutente, utenti.cognome as cognomeutente
						from titoliingresso 
						join TIPOLOGIEINGRESSO on TITOLIINGRESSO.TIPOLOGIA=TIPOLOGIEINGRESSO.IDTIPOLOGIAING
						join utenti on titoliingresso.ACQUIRENTE=utenti.IDUTENTE
						join tipologieingressomusei on tipologieingresso.IDTIPOLOGIAING= tipologieingressomusei.IDTIPOLOGIAING
						join musei on tipologieingressomusei.IDMUSEO= musei.IDMUSEO
						order by IDTITOLOING
			)
			LOOP
                modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                    modGUI1.ApriDiv('class="w3-card-4"');
                            modGUI1.ApriDiv('class="w3-container w3-center"');
                            --INIZIO DESCRIZIONI
                                htp.prn('<p>Titolo d''ingresso <b>'||k.idtitolo||'</b> </p>');
								htp.prn('<p>'||k.nomeutente || ' ' || k.cognomeutente||' </p>');
                                htp.prn('<p>'|| k.nometipologia ||'</p>');
                            --FINE DESCRIZIONI
                            modGUI1.ChiudiDiv;
                            
            				MODGUI1.Collegamento(
								'Visualizza',
								'packageAcquistaTitoli.visualizzatitoloing?varidtitoloing='||k.idtitolo,
								'w3-button w3-margin w3-black');
							--utente autorizzato
            				IF ( idsessione = 1 ) THEN
               				 modgui1.collegamento(
								'Modifica titolare',
								'packageAcquistaTitoli.pagina_modifica_titolo?&varidtitoloing='||k.idtitolo,
								'w3-button w3-margin w3-green');
               				 modgui1.collegamento(
                                'Rimuovi',
                                'packageAcquistaTitoli.cancellazionetitolo?&varidtitoloing='||k.idtitolo,
                                'w3-button w3-margin w3-red'
                			);
							END IF;
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
            END LOOP;
        --FINE LOOP
        modGUI1.chiudiDiv;
end;

PROCEDURE visualizzatitoloing(
	varidtitoloing number
)is
	IdSessione NUMBER(5) := modgui1.get_id_sessione();

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
begin
	select Emissione, Scadenza, TITOLIINGRESSO.Acquirente, IdMuseo, Musei.Nome, utenti.nome, utenti.cognome, TIPOLOGIEINGRESSO.NOME, TIPOLOGIEINGRESSO.IDTIPOLOGIAING
	into emiss, scad, varidutente, varidmuseo, nomemuseo, nomeutente, cognomeutente, nometipologia, varidtipologia
	from TITOLIINGRESSO join utenti on utenti.idutente=TITOLIINGRESSO.ACQUIRENTE
	join musei on TITOLIINGRESSO.Museo= musei.idmuseo
    join TIPOLOGIEINGRESSO on TITOLIINGRESSO.TIPOLOGIA=TIPOLOGIEINGRESSO.IDTIPOLOGIAING
	where TITOLIINGRESSO.idtitoloing= varidtitoloing;
	
	MODGUI1.APRIPAGINA('Visualizza titolo d''ingresso');
		modgui1.header(idSessione);
		modgui1.apridiv('style="margin-top: 110px"');

		MODGUI1.ApriDivcard();
		select count(*) into temp from Biglietti where idtipologiaing=varidtipologia;
		if(temp>0)
		then
		HTP.header(2, 'Biglietto', 'center');
		ELSE
		HTP.header(2, 'Abbonamento', 'center');
		end if;

		HTP.TableOpen;
		HTP.TableRowOpen;
		HTP.TableData('Titolare: ');
		HTP.TableData(nomeutente || ' ' || cognomeutente);
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
		HTP.TableData(to_char(emiss, 'DD-MON-YYYY HH24:MI'));
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Data Scadenza: ');
		HTP.TableData(to_char(scad, 'DD-MON-YYYY HH24:MI'));
		HTP.TableRowClose;
		HTP.TableClose;
		modGUI1.Collegamento('X',
                'packageAcquistaTitoli.titolihome',
                'w3-btn w3-large w3-red w3-display-topright');
		if(IdSessione=1)
		then
			modGUI1.Collegamento('Cancella titolo d''ingresso',
                'packageAcquistaTitoli.cancellazionetitolo',
                'w3-button w3-block w3-red w3-section w3-padding');
		end if;
		modgui1.chiudidiv();
		htp.bodyclose();
	htp.HtmlClose();
END;





PROCEDURE pagina_modifica_titolo(
	varidtitoloing varchar
)
IS
	IdSessione NUMBER(5) := modgui1.get_id_sessione();
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
	modgui1.header(idSessione);
	modgui1.apridiv('style="margin-top: 110px"');
	htp.prn('<h1 align="center"> Modifica titolare </h1>');

	modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
	modgui1.apriform('packageAcquistaTitoli.pagina_modifica_titolo', 'confermamodificatitolo', 'w3-container');
	modgui1.apridiv('class="w3-section"');

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

	htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit">Modifica</button>');
	modgui1.collegamento(
                        'Torna alla visualizzazione di tutti i titoli d''ingresso',
                        'packageAcquistaTitoli.titolihome',
                        'w3-button w3-block w3-red w3-section w3-padding'
                		);
	modgui1.ChiudiDiv();
	modgui1.chiudiform();
	modgui1.chiudidiv();
	
END;
/*
procedure confermamodificatitolo(
	idutenteselezionato utenti.idutente%type,

)

*/




PROCEDURE acquistatitolo(
	dataEmissionechar IN VARCHAR2,
	oraemissionechar in varchar2,
	idmuseoselezionato IN VARCHAR2,
	idtipologiaselezionata tipologieingresso.IDTIPOLOGIAING%type,
	idutenteselezionato IN VARCHAR2
) IS
	IdSessione NUMBER(5) := modgui1.get_id_sessione();

	varidtitoloing VARCHAR(5);
	emiss DATE;
	scadenza varchar2(20);
	scad date;
	tipologia varchar2(100);
	temp1 number(2); --flag che ci dice se abbiamo a che fare con un biglietto o un abbonamento
	temp2 varchar(20); --contiene la data di scadenza in formato varchar
	temp3 number(1); --flag che ci dice se l'utente e' gia presente nella tabella UTENTIMUSEO
	durataabbonamento tipologieingresso.durata%type; --contiene la durata dell'abbonamento
	datetime date; --contiene concatenati data e ora nel formato inseribile nel db
	temp4 int;
	durataabbnumb number(3);
BEGIN
	
	varidtitoloing := idtitoloingseq.nextval;
	
	datetime:=to_date(
                oraemissionechar 
                || ' '
                || dataemissionechar, 'HH24:MI YYYY/MM/DD'
            );

	select durata into durataabbonamento from TIPOLOGIEINGRESSO where IDTIPOLOGIAING=idtipologiaselezionata;
	htp.prn('<p>'||durataabbonamento||'</p>');
	
	select count(*) into temp1 from Biglietti where idtipologiaselezionata= biglietti.IDTIPOLOGIAING;
	if(temp1>0)
	then
		scad:= to_date('23:59 ' ||dataemissionechar, 'HH24:MI YYYY/MM/DD');
	ELSE
		scad:= to_date('23:59 ' ||dataemissionechar, 'HH24:MI YYYY/MM/DD');
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
		datetime,
		scad,
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

	--visualizzatitoloing(varidtitoloing); 
END;

--ACQUISTO ABBONAMENTO
PROCEDURE formacquistaabbonamento(
	dataEmissionechar IN VARCHAR2,
	oraemissionechar IN VARCHAR2,
	idmuseoselezionato IN VARCHAR2 default null,
	idtipologiaselezionata IN VARCHAR2 default null,
	idutenteselezionato IN VARCHAR2 default null
)IS
	IdSessione NUMBER(5) := modgui1.get_id_sessione();

	nomeutente utenti.nome%TYPE;
	cognomeutente utenti.cognome%TYPE;
	varidutente utenti.Idutente%TYPE;
	nometipologia tipologieingresso.nome%TYPE;
	varidmuseo musei.idmuseo%TYPE;
	nomeMuseo musei.Nome%TYPE;
	varidtipologia tipologieingresso.idtipologiaing%TYPE;
	nometiping VARCHAR(25);
BEGIN
	modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
	modgui1.apriform('packageAcquistaTitoli.pagina_acquista_abbonamento', 'formacquistaabbonamento', 'w3-container');
	modgui1.apridiv('class="w3-section"');

	modgui1.label('Utente*: ');
	modgui1.selectopen('idutenteselezionato', 'utente-selezionato');
	for utente in (select idutente from utenti)
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

	modgui1.label('Museo*: ');
	modgui1.selectopen('idmuseoselezionato', 'museo-selezionato');
	for museo in (select idmuseo, nome from musei )
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
		where IdMuseo=idmuseoselezionato
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
	IdSessione NUMBER(5) := modgui1.get_id_sessione();
BEGIN
	modgui1.apripagina('Pagina acquisto abbonamento');
	modgui1.header(idSessione);
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
procedure formacquistabiglietto(
	dataEmissionechar IN VARCHAR2,
	oraemissionechar in varchar2,
	idmuseoselezionato IN VARCHAR2 default null,
	idtipologiaselezionata IN VARCHAR2 default null,
	idutenteselezionato IN VARCHAR2 default null
)IS
	IdSessione NUMBER(5) := modgui1.get_id_sessione();

	nomeutente utenti.nome%TYPE;
	cognomeutente utenti.cognome%TYPE;
	varidutente utenti.Idutente%TYPE;
	nometipologia tipologieingresso.nome%TYPE;
	varidmuseo musei.idmuseo%TYPE;
	nomeMuseo musei.Nome%TYPE;
	varidtipologia tipologieingresso.idtipologiaing%TYPE;
	nometiping VARCHAR(25);
begin
	modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
	modgui1.apriform('packageAcquistaTitoli.pagina_acquista_biglietto', 'formacquistabiglietto', 'w3-container');
	modgui1.apridiv('class="w3-section"');

	modgui1.label('Utente*: ');
	modgui1.selectopen('idutenteselezionato', 'utente-selezionato');
	for utente in (select idutente from utenti)
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

	modgui1.label('Museo*: ');
	modgui1.selectopen('idmuseoselezionato', 'museo-selezionato');
	for museo in (select idmuseo, nome from musei )
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
		where IdMuseo=idmuseoselezionato
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
	IdSessione NUMBER(5) := modgui1.get_id_sessione();

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

	IF dataEmissionechar is null
    or idmuseoselezionato is null
    or idtipologiaselezionata is null
    or idutenteselezionato is null
	or (dataemissionechar is not null and to_date(dataEmissionechar, 'YYYY/MM/DD')>sysdate)
	
    THEN
    modgui1.apripagina('Pagina errore', 0);
    htp.BodyOpen;
	modgui1.header(idsessione);
    modgui1.apridiv();
    htp.print('Uno dei parametri immessi non valido');
    modgui1.chiudidiv;
    htp.BodyClose;
    htp.HtmlClose;
    ELSE
		MODGUI1.APRIPAGINA('Pagina Conferma');
		HTP.BodyOpen;
		modgui1.header(Idsessione);
		htp.prn('<h2 align="center"> Conferma immissione dati </h2>');
		if flag >0
		then
		MODGUI1.ApriDivcard();
		HTP.header(3, 'Nuovo Biglietto', 'center');
		else
		MODGUI1.ApriDivcard();
		HTP.header(3, 'Nuovo Abbonamento', 'center');
		end if;

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
	IdSessione NUMBER(5) := modgui1.get_id_sessione();
begin
	modgui1.apripagina('Pagina acquisto biglietto');
	modgui1.header(idSessione);
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
procedure statTitoliPerArcoTemp(
	datainizio VARCHAR2 default null,
	datafine VARCHAR2 default null
)IS
	IdSessione NUMBER(5) := modgui1.get_id_sessione();

	iniziop date:= to_date(datainizio, 'YYYY-MM-DD');
	finep date:= to_date(datafine, 'YYYY-MM-DD');
	statistica NUMBER(10) default 0;
BEGIN
	if datainizio is null or datafine is NULL or iniziop > finep
	then 
		modgui1.apripagina('Pagina errore');
		modgui1.header(idSessione);
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
--CANCELLAZIONE
procedure cancellazionetitolo(
	varidtitoloing varchar2
)
IS
	IdSessione NUMBER(5) := modgui1.get_id_sessione();

	temp number(1);
	temp2 number(1);
BEGIN

	select count(*)  into temp from TITOLIINGRESSO where IDTITOLOING=varidtitoloing;
	if temp>0
	then
		DELETE FROM TITOLIINGRESSO
		WHERE IDTITOLOING=varidtitoloing;
		select count(*) into temp2 from TITOLIINGRESSO where IDTITOLOING=varidtitoloing;
		if temp2<1
		then
			modgui1.apripagina('Pagina esito cancellazione');
			htp.bodyopen;
			modgui1.header();
			modgui1.apridiv('style="margin-top: 110px"');
			htp.header(1, 'Cancellazione titolo d''ingresso');
			modgui1.apridivcard();
			htp.prn('<h1> Successo! </h1>');
			htp.br();
			htp.print('Titolo d''ingresso eliminato correttamente.');
    		modgui1.chiudidiv;
			modgui1.chiudidiv;
    		htp.BodyClose;
    		htp.HtmlClose;
		else
			modgui1.apripagina('Pagina errore');
			htp.bodyopen;
			modgui1.header();
			modgui1.apridiv('style="margin-top: 110px"');
			htp.header(1, 'Cancellazione titolo d''ingresso');
			modgui1.apridivcard();
			htp.prn('<h1> Errore </h1>');
			htp.br();
			htp.print('Titolo d''ingresso non eliminato correttamente.');
    		modgui1.chiudidiv;
			modgui1.chiudidiv;
    		htp.BodyClose;
    		htp.HtmlClose;
		end if;
	ELSE
		modgui1.apripagina('Pagina errore');
		htp.bodyopen;
		modgui1.header();
		modgui1.apridiv('style="margin-top: 110px"');
		htp.header(1, 'Cancellazione titolo d''ingresso');
		modgui1.apridivcard();
		htp.prn('<h1> Errore </h1>');
		htp.br();
		htp.print('Titolo d''ingresso non presente.');
    	modgui1.chiudidiv;
		modgui1.chiudidiv;
    	htp.BodyClose;
    	htp.HtmlClose;
	end if;
		
END;

END packageAcquistaTitoli;
