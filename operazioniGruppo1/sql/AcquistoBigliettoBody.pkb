CREATE OR REPLACE PACKAGE BODY packageAcquistaBiglietto AS
/*

grant execute on MODGUI1 to anonymous;
grant execute on costanti to anonymous;
grant execute on PACKAGEACQUISTABIGLIETTO to anonymous;
grant execute on GRUPPO1 to anonymous;

*/

PROCEDURE acquistabiglietto(
	dataEmissionechar IN VARCHAR2,
	dataScadenzachar IN VARCHAR2,
	idmuseoselezionato IN VARCHAR2,
	idtipologiaselezionata IN VARCHAR2,
	idutenteselezionato IN VARCHAR2
) IS
	idbigliettocreato VARCHAR(5);
	emiss DATE := TO_DATE(dataEmissionechar default null on conversion error, 'YYYY-MM-DD');
	scad DATE := TO_DATE(dataScadenzachar default null on conversion error, 'YYYY-MM-DD');
BEGIN
	idbigliettocreato := idtitoloingseq.nextval;

	INSERT INTO TITOLIINGRESSO(
		idtitoloing,
		Emissione,
		Scadenza,
		Acquirente,
		Tipologia,
		Museo
	) VALUES (
		idvisiteseq.nextval,
		emiss,
		scad,
		idutenteselezionato,
		idtipologiaselezionata,
		idmuseoselezionato
	);
	
	--visualizzabiglietto(idbigliettocreato);
END;

PROCEDURE formacquistabiglietto(
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
	modgui1.apriform('package.pagina_acquista_biglietto', 'formCreaBiglietto', 'w3-container');
	modgui1.apridiv('class="w3-section"');

	modgui1.Label('Data emissione biglietto*: ');
	modgui1.inputdate('DataEmissioneChar', 'DataEmissioneChar', 1, dataEmissionechar);
	HTP.br;

	modgui1.label('Data scadenza biglietto*: ');
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
	for museo in (select idmuseo from musei)
	loop
		select idmuseo, Nome
		into varidmuseo, nomeMuseo
		from musei;
		if museo.idmuseo=idmuseoselezionato
		then modgui1.SelectOption(varidmuseo, nomeMuseo, 1);
		else modgui1.SelectOption(varidmuseo, nomeMuseo, 0);
		end if;
	end loop;
	modgui1.SelectClose();
	
	modgui1.label('Tipologia di biglietto*: ');
	modgui1.selectopen('idtipologiaselezionata', 'tipologia-selezionata');
	for tipologia in (select idtipologiaing from TIPOLOGIEINGRESSO)
	LOOP
		select TIPOLOGIEINGRESSO.IDTIPOLOGIAING, tipologieingresso.NOME
		into varidtipologia, nometiping
		from TIPOLOGIEINGRESSOMUSEI JOIN TIPOLOGIEINGRESSO
        ON TIPOLOGIEINGRESSO.IDTIPOLOGIAING=TIPOLOGIEINGRESSOMUSEI.IDTIPOLOGIAING   
		where IdMuseo=idmuseoselezionato 
			and TIPOLOGIEINGRESSOMUSEI.IdTipologiaIng=TIPOLOGIEINGRESSO.IdTipologiaIng;
		if idtipologiaselezionata= tipologia.idtipologiaing
		then
			modgui1.SelectOption(varidtipologia, nometipologia, 1);
		else
			modgui1.SelectOption(varidtipologia, nometipologia, 0);
		end if;
	end loop;
	modgui1.selectclose();

	htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit" name="convalida" value="1">Acquista</button>');
	modgui1.ChiudiDiv();
	modgui1.chiudiform();
	modgui1.chiudidiv();
	htp.prn('<script> 
				document.getElementById("museo-selezionato".onchange= function inviaFormAcquistaBiglietto{
					document.formAcquistaBiglietto.submit();
					}
	</script>');
END;

PROCEDURE pagina_acquista_biglietto(
	dataEmissionechar IN VARCHAR2,
	dataScadenzachar IN VARCHAR2,
	idmuseoselezionato IN VARCHAR2,
	idtipologiaselezionata IN VARCHAR2,
	idutenteselezionato IN VARCHAR2,
	convalida IN NUMBER DEFAULT NULL
) IS 
BEGIN 
	modgui1.apripagina();
	modgui1.header();
	modgui1.apridiv('style="margin-top: 110px"');
	htp.prn('<h1> Acquisto biglietto </h1>');
	if convalida is null
	then 
		formacquistabiglietto(dataEmissionechar, dataScadenzachar,
					idmuseoselezionato, idtipologiaselezionata, idutenteselezionato);
	else 
		htp.prn('<h1> Biglietto acquistato </h1>');
		acquistabiglietto(dataEmissionechar, dataScadenzachar,
							idmuseoselezionato, idtipologiaselezionata, idutenteselezionato);
	end if;
	modgui1.chiudidiv();
	htp.prn('<script> function inviaFormAcquistaBiglietto(){
		document.formAcquistaBiglietto.submit();
		}
	</script>');
	htp.prn('
	</body>
	</html>');
END;

END packageAcquistaBiglietto;
