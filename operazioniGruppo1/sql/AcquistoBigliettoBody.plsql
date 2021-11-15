CREATE OR REPLACE PACKAGE BODY packageAcquistaTitoli AS

PROCEDURE visualizzatitoliing(
	varidtitoloing in number
)is
	nomeutente varchar2(50);
	cognomeutente varchar2(50);
	varidutente number(5);
	varidmuseo number(5);
	nomemuseo varchar(50);
	emiss date;
	scad date;
    nometipologia varchar(30);
begin
	select Emissione, Scadenza, TITOLIINGRESSO.Acquirente, IdMuseo, Musei.Nome, utenti.nome, utenti.cognome, TIPOLOGIEINGRESSO.NOME
	into emiss, scad, varidutente, varidmuseo, nomemuseo, nomeutente, cognomeutente, nometipologia
	from TITOLIINGRESSO join utenti on utenti.idutente=TITOLIINGRESSO.ACQUIRENTE
	join musei on TITOLIINGRESSO.Museo= musei.idmuseo
    join TIPOLOGIEINGRESSO on TITOLIINGRESSO.TIPOLOGIA=TIPOLOGIEINGRESSO.IDTIPOLOGIAING
	where TITOLIINGRESSO.idtitoloing= varidtitoloing;
	
	MODGUI1.APRIPAGINA('Visualizza titolo di ingresso');
		modgui1.header();
		modgui1.apridiv('style="margin-top: 110px"');

		MODGUI1.ApriDivcard();
		HTP.header(2, 'Titolo ingresso');

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
		HTP.TableData(emiss);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Data Scadenza: ');
		HTP.TableData(scad);
		HTP.TableRowClose;
		HTP.TableClose;
		
		modgui1.chiudidiv();
		htp.bodyclose();
	htp.HtmlClose();
END;

PROCEDURE acquistatitolo(
	dataEmissionechar IN VARCHAR2,
	dataScadenzachar IN VARCHAR2,
	idmuseoselezionato IN VARCHAR2,
	idtipologiaselezionata IN VARCHAR2,
	idutenteselezionato IN VARCHAR2
) IS
	varidtitoloing VARCHAR(5);
	emiss DATE := TO_DATE(dataEmissionechar default null on conversion error, 'YYYY-MM-DD');
	scad DATE := TO_DATE(dataScadenzachar default null on conversion error, 'YYYY-MM-DD');
BEGIN
	varidtitoloing := idtitoloingseq.nextval;

	INSERT INTO TITOLIINGRESSO(
		idtitoloing,
		Emissione,
		Scadenza,
		Acquirente,
		Tipologia,
		Museo
	) VALUES (
		varidtitoloing,
		emiss,
		scad,
		idutenteselezionato,
		idtipologiaselezionata,
		idmuseoselezionato
	);
	
	visualizzatitoliing(varidtitoloing);
END;

PROCEDURE formacquistaabbonamento(
	dataEmissionechar IN VARCHAR2,
	dataScadenzachar IN VARCHAR2,
	idmuseoselezionato IN VARCHAR2 default null,
	idtipologiaselezionata IN VARCHAR2 default null,
	idutenteselezionato IN VARCHAR2 default null
)IS
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

	modgui1.Label('Data emissione abbonamento*: ');
	modgui1.inputdate('DataEmissioneChar', 'DataEmissioneChar', 1, dataEmissionechar);
	HTP.br;

	modgui1.label('Data scadenza abbonamento*: ');
	modgui1.inputdate('DataScadenzaChar', 'DataScadenzaChar', 1, dataScadenzachar);
	htp.br;

	modgui1.label('Utente*: ');
	modgui1.selectopen('idutenteselezionato', 'utente-selezionato');
	for utente in (select idutente from utentimuseo)
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
		select TIPOLOGIEINGRESSO.IDTIPOLOGIAING, NOME
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

	htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit" name="convalida" value="1">Acquista</button>');
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
	dataScadenzachar VARCHAR2 DEFAULT NULL,
	idmuseoselezionato VARCHAR2 DEFAULT NULL,
	idtipologiaselezionata VARCHAR2 DEFAULT NULL,
	idutenteselezionato VARCHAR2 DEFAULT NULL,
	convalida IN NUMBER DEFAULT NULL
) IS
BEGIN
	modgui1.apripagina('Pagina acquisto abbonamento');
	modgui1.header();
	modgui1.apridiv('style="margin-top: 110px"');
	htp.prn('<h1> Acquisto abbonamento </h1>');

	if convalida IS NULL
	then
		formacquistaabbonamento(dataEmissionechar, dataScadenzachar,
					idmuseoselezionato, idtipologiaselezionata, idutenteselezionato);
	else
		confermaacquistoabbonamento(dataEmissionechar, dataScadenzachar,
							idmuseoselezionato, idtipologiaselezionata, idutenteselezionato);
	end if;

	modgui1.chiudidiv(); 
	HTP.BodyClose;
	HTP.HtmlClose;
END;

PROCEDURE confermaacquistoabbonamento(
	dataEmissionechar VARCHAR2 DEFAULT NULL,
	dataScadenzachar VARCHAR2 DEFAULT NULL,
	idmuseoselezionato VARCHAR2 DEFAULT NULL,
	idtipologiaselezionata VARCHAR2 DEFAULT NULL,
	idutenteselezionato VARCHAR2 DEFAULT NULL
)IS
	nomeutente  VARCHAR(100);
	cognomeutente VARCHAR(100);
	nomemuseo VARCHAR(100);
	nometipologia VARCHAR(100);
begin

	SELECT nome into nomeutente from utenti where idutente = idutenteselezionato;
	select cognome into cognomeutente from utenti where idutente=idutenteselezionato;
	select nome into nomemuseo from musei where idmuseo=idmuseoselezionato;
	select nome into nometipologia from tipologieingresso where idtipologiaing=idtipologiaselezionata;

    IF dataEmissionechar is null
    or dataScadenzachar is null
    or idmuseoselezionato is null
    or idtipologiaselezionata is null
    or idutenteselezionato is null
    or (dataEmissionechar is not null and to_date(dataEmissionechar, 'YYYY-MM-DD')>sysdate)
    or (dataScadenzachar is not null and to_date(dataScadenzachar, 'YYYY-MM-DD')<sysdate)
    or (to_date(dataEmissionechar, 'YYYY-MM-DD')>to_date(dataScadenzachar, 'YYYY-MM-DD'))
    THEN
    modgui1.apripagina('Pagina errore', 0);
    htp.BodyOpen;
    modgui1.apridiv();
    htp.print('Uno dei parametri immessi non valido');
    modgui1.chiudidiv;
    htp.BodyClose;
    htp.HtmlClose;
    ELSE
		MODGUI1.APRIPAGINA('Pagina di conferma');
		HTP.BodyOpen;
		HTP.header(1, 'Conferma immissione dati');

		MODGUI1.ApriDivcard();
		HTP.header(2, 'Nuovo Abbonamento');

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
		HTP.TableData(dataEmissionechar);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Data Scadenza: ');
		HTP.TableData(dataScadenzachar);
		HTP.TableRowClose;
		HTP.TableClose;
    end if;
		modgui1.apriform('packageAcquistaTitoli.acquistatitolo');
		htp.formhidden('dataemissionechar', dataemissionechar);
		htp.formhidden('datascadenzachar', datascadenzachar);
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
				||'packageAcquistaTitoli.pagina_acquista_abbonamento";
				form.submit();
				}
			</script>');
END;

procedure formacquistabiglietto(
	dataEmissionechar IN VARCHAR2,
	idmuseoselezionato IN VARCHAR2 default null,
	idtipologiaselezionata IN VARCHAR2 default null,
	idutenteselezionato IN VARCHAR2 default null
)IS
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

	modgui1.Label('Data emissione biglietto*: ');
	modgui1.inputdate('DataEmissioneChar', 'DataEmissioneChar', 1, dataEmissionechar);
	HTP.br;

	modgui1.label('Utente*: ');
	modgui1.selectopen('idutenteselezionato', 'utente-selezionato');
	for utente in (select idutente from utentimuseo)
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
		into varidtipologia, nometiping
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

	htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit" name="convalida" value="1">Acquista</button>');
	modgui1.ChiudiDiv();
	modgui1.chiudiform();
	modgui1.chiudidiv();
	htp.prn('<script>
				document.getElementById("museo-selezionato").onchange= function inviaformacquistaabbonamento(){
					document.formacquistabiglietto.submit();
					}
	</script>');
END;



PROCEDURE confermaacquistobiglietto(
	dataEmissionechar VARCHAR2 DEFAULT NULL,
	idmuseoselezionato VARCHAR2 DEFAULT NULL,
	idtipologiaselezionata VARCHAR2 DEFAULT NULL,
	idutenteselezionato VARCHAR2 DEFAULT NULL
)IS
	nomeutente  VARCHAR(100);
	cognomeutente VARCHAR(100);
	nomemuseo VARCHAR(100);
	nometipologia VARCHAR(100);
BEGIN
	SELECT nome into nomeutente from utenti where idutente = idutenteselezionato;
	select cognome into cognomeutente from utenti where idutente=idutenteselezionato;
	select nome into nomemuseo from musei where idmuseo=idmuseoselezionato;
	select nome into nometipologia from tipologieingresso where idtipologiaing=idtipologiaselezionata;

	IF dataEmissionechar is null
    or idmuseoselezionato is null
    or idtipologiaselezionata is null
    or idutenteselezionato is null
    THEN
    modgui1.apripagina('Pagina errore', 0);
    htp.BodyOpen;
    modgui1.apridiv();
    htp.print('Uno dei parametri immessi non valido');
    modgui1.chiudidiv;
    htp.BodyClose;
    htp.HtmlClose;
    ELSE
		MODGUI1.APRIPAGINA('Pagina Conferma', 0);
		HTP.BodyOpen;
		HTP.header(1, 'Conferma immissione dati');

		MODGUI1.ApriDivcard();
		HTP.header(2, 'Nuovo Biglietto');

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
		HTP.TableData(dataEmissionechar);
		HTP.TableRowClose;
		HTP.TableClose;
    end if;
		modgui1.apriform('packageAcquistaTitoli.acquistatitolo');
		htp.formhidden('dataemissionechar', dataemissionechar);
		htp.formhidden('datascadenzachar', dataemissionechar);
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
	dataScadenzachar VARCHAR2 DEFAULT NULL,
	idmuseoselezionato VARCHAR2 DEFAULT NULL,
	idtipologiaselezionata VARCHAR2 DEFAULT NULL,
	idutenteselezionato VARCHAR2 DEFAULT NULL,
	convalida IN NUMBER DEFAULT NULL
)IS
begin
	modgui1.apripagina('Pagina acquisto biglietto');
	modgui1.header();
	modgui1.apridiv('style="margin-top: 110px"');
	htp.prn('<h1> Acquisto biglietto </h1>');

	if convalida IS NULL
	then
		formacquistabiglietto(dataEmissionechar,idmuseoselezionato,
								idtipologiaselezionata, idutenteselezionato);
	else
		confermaacquistobiglietto(dataEmissionechar, idmuseoselezionato,
									idtipologiaselezionata, idutenteselezionato);
	end if;

	modgui1.chiudidiv(); 
	HTP.BodyClose;
	HTP.HtmlClose;
end;

procedure cancellazionetitoloing(
	idtitoloingselezionato varchar2
)
IS
	temp number(1);
	temp2 number(1);
BEGIN

	select count(*)  into temp from TITOLIINGRESSO where IDTITOLOING=idtitoloingselezionato;
	if temp>0
	then
		DELETE FROM TITOLIINGRESSO
		WHERE IDTITOLOING=idtitoloingselezionato;
		select count(*) into temp2 from TITOLIINGRESSO where IDTITOLOING=idtitoloingselezionato;
		if temp2<1
		then
			modgui1.apripagina('Pagina conferma cancellazione');
			modgui1.header();
			modgui1.apridiv('style="margin-top: 110px"');
			htp.prn('<h1> Successo! </h1>');
			htp.br();
			htp.print('Titolo di ingresso eliminato correttamente.');
    		modgui1.chiudidiv;
    		htp.BodyClose;
    		htp.HtmlClose;
		else
			modgui1.apripagina('Pagina errore');
			modgui1.header();
			modgui1.apridiv('style="margin-top: 110px"');
			htp.prn('<h1> Errore </h1>');
			htp.br();
			htp.print('Titolo di ingresso non eliminato correttamente.');
    		modgui1.chiudidiv;
    		htp.BodyClose;
    		htp.HtmlClose;
		end if;
	ELSE
		modgui1.apripagina('Pagina errore');
		modgui1.header();
		modgui1.apridiv('style="margin-top: 110px"');
		htp.prn('<h1> Errore </h1>');
		htp.br();
		htp.print('Titolo di ingresso non presente.');
    	modgui1.chiudidiv;
    	htp.BodyClose;
    	htp.HtmlClose;
	end if;
		
END;

END packageAcquistaTitoli;
