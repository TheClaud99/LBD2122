set define off;
CREATE OR REPLACE PACKAGE BODY gruppo1 AS

/*
 *  OPERAZIONI SULLE TIPOLOGIE DI INGRESSO
 * - Inserimento ✅ 
 * - Modifica ✅
 * - Visualizzazione ✅ 
 * - Cancellazione (rimozione) ✅
 * OPERAZIONI STATISTICHE E MONITORAGGIO
 * - Tipologia più scelta in un arco temporale scelto ✅
 * - Lista Tipologie in ordine di prezzo crescente ✅
*/

--Procedura che implementa la home
PROCEDURE ListaTipologieIng
is

idSessione NUMBER(5) := modgui1.get_id_sessione();
begin
	modGUI1.ApriPagina('Lista tipologie ing',idSessione);
    modGUI1.Header;
		modGUI1.ApriDiv('class="w3-center" style="margin-top:110px;"');
        htp.prn('<h1>Menù tipologie di ingresso</h1>');

		if hasRole(idSessione, 'DBA') or hasRole(idSessione, 'AB') or hasRole(idSessione, 'GM') or hasRole(idSessione, 'GCE') then
            modGUI1.Collegamento('Inserisci','gruppo1.InserisciTipologiaIng','w3-btn w3-round-xxlarge w3-black');
            htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
            modGUI1.Collegamento('Statistiche','gruppo1.StatisticheTipologieIng','w3-btn w3-round-xxlarge w3-black');
		end if;

        modGUI1.ChiudiDiv;
        htp.br;
        modGUI1.ApriDiv('class="w3-row w3-container"');
   		for tipologia in (select * from TIPOLOGIEINGRESSO where ELIMINATO = 0)  loop
                modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                    modGUI1.ApriDiv('class="w3-card-4" style="height:200px;"');
						modGUI1.ApriDiv('class="w3-container w3-center"');
							htp.prn('<p>'|| tipologia.nome ||'</p>');
							htp.br;
						modGUI1.ChiudiDiv;
						modGUI1.Collegamento('Visualizza',
                            'gruppo1.VisualizzaDatiTitoloIng?tipologiaIngID='||tipologia.idTipologiaIng,
                            'w3-btn w3-round-xxlarge w3-black');
						htp.print('&nbsp;');	
                    if hasRole(idSessione, 'DBA') or hasRole(idSessione, 'AB') or hasRole(idSessione, 'GM') or hasRole(idSessione, 'GCE') then
						modGUI1.Collegamento('Modifica',
                            'gruppo1.ModificaDatiTitoloIng?tipologiaIngID='||tipologia.idTipologiaIng,
                            'w3-btn w3-round-xxlarge w3-black');
						htp.print('&nbsp;');	
                        modGUI1.Collegamento('Elimina',
                            'gruppo1.CancellazioneTipologiaIng?tipologiaIngID='||tipologia.idTipologiaIng,
                            'w3-btn w3-round-xxlarge w3-black',
							'return confirm(''Sei sicuro di voler eliminare la tipologia '||tipologia.nome||'?'')'
							);
                    end if;
                	modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
        END LOOP;
        modGUI1.chiudiDiv;
      
end;


/* Procedura per inserimento Tipologie di ingresso */
PROCEDURE InserisciTipologiaIng

IS
	idSessione NUMBER(5) := modgui1.get_id_sessione();
BEGIN

    MODGUI1.ApriPagina('Inserimento tipologie ingresso', idSessione);
    HTP.BodyOpen;
	MODGUI1.Header(); 
	HTP.header(1,'Inserisci una nuova tipologia di ingresso', 'center');
	modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom w3-padding-large" style="max-width:600px; margin-top:110px"');
	HTP.header(2, 'Inserisci tipologia di ingresso');
	MODGUI1.ApriForm('gruppo1.ConfermaTipologiaIng');

	MODGUI1.Label('Nome*');
	MODGUI1.InputText('nome', 'Nome', 1);
	HTP.BR;
	MODGUI1.Label('Prezzo*');
	MODGUI1.InputNumber('Costo Totale', 'costoTotale', 1);
	HTP.BR;
	MODGUI1.Label('Limite Sale*');
	MODGUI1.InputNumber('Limite Sale', 'limiteSale', 0, '');
	HTP.BR;
	MODGUI1.Label('Limite Tempo*');
	MODGUI1.InputNumber('Limite Tempo', 'limiteTempo', 0, '');
	HTP.BR;
	MODGUI1.Label('Durata validità*');
	MODGUI1.InputNumber('Durata', 'durata', 1);
	HTP.BR;

	MODGUI1.InputRadioButton('Biglietto ', 'tipo', 'Biglietto', 0, 0, 1);
	HTP.BR;
	HTP.BR;
	MODGUI1.InputRadioButton('Abbonamento ', 'tipo', 'Abbonamento', 0, 0, 1);
	HTP.BR;
	MODGUI1.ApriDiv('style="display: none" id="abb"');
	
	HTP.BR;
	MODGUI1.Label('Numero intestatari*');
	MODGUI1.InputNumber('Numero Intestatari', 'numPersone', 1);
	HTP.BR;
	MODGUI1.ChiudiDiv;
	MODGUI1.InputSubmit('Inserisci');
	MODGUI1.ChiudiForm;
	MODGUI1.collegamento('Annulla','gruppo1.ListaTipologieIng','w3-button w3-block w3-black w3-section w3-padding');
	MODGUI1.collegamento('Torna al menu','gruppo1.ListaTipologieIng','w3-button w3-block w3-black w3-section w3-padding');
	MODGUI1.ChiudiDiv;

	htp.print('<script type="text/javascript">
        const radio = document.getElementsByName("tipo")
        console.log(radio[1].value)
		const div = document.getElementById("abb")
		radio[1].addEventListener("change", () => {
			if(radio[1].checked == true)
				{div.style.display = "block"
				console.log(radio[1].checked)}	
		})	
		radio[0].addEventListener("change", () => {
			if(radio[0].checked == true)
				{div.style.display = "none"
				console.log(radio[0].checked)}
			
		})
    </script>');

	HTP.BodyClose;
	HTP.HtmlClose;
END;

--Procedura per confermare i dati dell'inserimento delle Tipologie di ingresso
PROCEDURE ConfermaTipologiaIng(
	nome VARCHAR2 DEFAULT NULL,
	costoTotale NUMBER DEFAULT NULL,
	limiteSale NUMBER DEFAULT NULL,
	limiteTempo NUMBER DEFAULT NULL,
    durata VARCHAR2 DEFAULT NULL,
	tipo VARCHAR2 DEFAULT NULL,
	numPersone NUMBER DEFAULT NULL
)IS	

idSessione NUMBER(5) := modgui1.get_id_sessione();
BEGIN
	
    -- se tipologia non autorizzata: messaggio errore
	IF (nome IS NULL)
	OR (costoTotale = 0) 
	OR (limiteSale = 0 
		AND limiteTempo = 0)
	OR (limiteSale != 0 
		AND limiteTempo != 0)
	OR (durata = 0)
	THEN
		-- uno dei parametri con vincoli ha valori non validi
		MODGUI1.EsitoOperazione('Errore', 
            'Uno dei parametri non è stato inserito correttamente', 
            'Riprova', 'InserisciTipologiaIng', null,
            'Torna al menu delle tipologie', 'ListaTipologieIng', null);
	ELSE
		MODGUI1.APRIPAGINA('Pagina OK', 0);
		HTP.BodyOpen;

		MODGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom w3-padding-large" style="max-width:600px; margin-top:110px"');
		HTP.header(2, 'Conferma i dati della tipologia di ingresso');

		HTP.TableOpen;
		HTP.TableRowOpen;
		HTP.TableData('Nome: ');
		HTP.TableData(nome);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Prezzo: ');
		HTP.TableData(costoTotale);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Limite Sale: ');
		HTP.TableData(limiteSale);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Limite Tempo: ');
		HTP.TableData(limiteTempo);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Durata validità: ');
		HTP.TableData(durata);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Tipologia ingresso: ');
		HTP.TableData(tipo);
		HTP.TableRowClose;
		
		if tipo = 'Abbonamento'
		then
			HTP.TableRowOpen;
			HTP.TableData('Numero intestatari: ');
			HTP.TableData(numPersone);
			HTP.TableRowClose;
		end if;

        MODGUI1.ApriForm('gruppo1.InserisciDatiTipologieIng');
		HTP.FORMHIDDEN('Nome', nome);
		HTP.FORMHIDDEN('CostoTotale', costoTotale);
		HTP.FORMHIDDEN('LimiteSale', limiteSale);
		HTP.FORMHIDDEN('LimiteTempo', limiteTempo);
		HTP.FORMHIDDEN('Durata', durata);
		HTP.FORMHIDDEN('Tipo', tipo);
		if tipo = 'Abbonamento'
		then
			HTP.FORMHIDDEN('NumPersone', numPersone);
		end if;
		MODGUI1.InputSubmit('Conferma');
		MODGUI1.ChiudiForm;
		MODGUI1.Collegamento('Annulla', 'gruppo1.InserisciTipologiaIng', 'w3-button w3-block w3-black w3-section w3-padding');
		MODGUI1.ChiudiDiv;
		HTP.BodyClose;
		HTP.HtmlClose;
	END IF;
	
	EXCEPTION WHEN OTHERS THEN
		dbms_output.put_line('Error: '||sqlerrm);
END;

--Procedura per inserire i dati delle Tipologie di ingresso
PROCEDURE InserisciDatiTipologieIng (
	nome VARCHAR2 DEFAULT NULL,
	costoTotale NUMBER DEFAULT NULL,
	limiteSale NUMBER DEFAULT NULL,
	limiteTempo NUMBER DEFAULT NULL,
    durata VARCHAR2 DEFAULT NULL,
	tipo VARCHAR2 DEFAULT NULL,
	numPersone NUMBER DEFAULT NULL 
) IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
limiteSaleTmp TIPOLOGIEINGRESSO.limiteSala%TYPE;
limiteTempoTmp TIPOLOGIEINGRESSO.limiteTempo%TYPE;
varIdTipologiaIng TIPOLOGIEINGRESSO.IdTipologiaIng%TYPE;

BEGIN
    
    varIdTipologiaIng := IdTipologiaingSeq.NEXTVAL; 
	
	IF limiteSale = 0 THEN
		limiteSaleTmp := NULL;
	ELSE
		limiteSaleTmp := limiteSale;	
	END IF;

	IF limiteTempo = 0 THEN
		limiteTempoTmp := NULL;
	ELSE
		limiteTempoTmp := limiteTempo;	
	END IF;	 
    -- tutti i parametri sono stati controllati prima, dobbiamo solo inserirli nella tabella
    IF tipo = 'Biglietto'
	THEN
        insert into TIPOLOGIEINGRESSO(IDTIPOLOGIAING, NOME, COSTOTOTALE, LIMITESALA, LIMITETEMPO, DURATA, ELIMINATO)
        values (varIdTipologiaIng, nome, costoTotale, limiteSaleTmp, limiteTempoTmp, durata, 0);

        insert into BIGLIETTI(IDTIPOLOGIAING, ELIMINATO)
        values (varIdTipologiaIng, 0);
    
    ELSE
        insert into TIPOLOGIEINGRESSO(IDTIPOLOGIAING, NOME, COSTOTOTALE, LIMITESALA, LIMITETEMPO, DURATA, ELIMINATO)
        values (varIdTipologiaIng, nome, costoTotale, limiteSaleTmp, limiteTempoTmp, durata, 0);

        insert into ABBONAMENTI(IDTIPOLOGIAING, NUMPERSONE, ELIMINATO)
        values (varIdTipologiaIng, numPersone, 0);
    END IF;    

	IF SQL%FOUND
	THEN
		-- faccio il commit dello statement precedente
		commit;

		MODGUI1.EsitoOperazione('Successo', 
            'Tipologia di ingresso inserita correttamente', 
            null, '', null,
            'Torna al menu delle tipologie', 'ListaTipologieIng', null);

	ELSE

		MODGUI1.EsitoOperazione('Errore', 
            'Tipologia ingresso non inserita', 
            'Riprova', 'InserisciTipologiaIng', null,
            'Torna al menu delle tipologie', 'ListaTipologieIng', null);

	END IF;

END;		


/* Procedura per la visualizzazione dei dati di un titolo di ingresso */
PROCEDURE VisualizzaDatiTitoloIng(
	tipologiaIngID NUMBER 
)
IS
	idSessione NUMBER(5) := modgui1.get_id_sessione();
	NomeTipologia TIPOLOGIEINGRESSO.nome%TYPE;
	PrezzoTotaleTipologia TIPOLOGIEINGRESSO.costoTotale%TYPE;
	LimiteSaleTipologia TIPOLOGIEINGRESSO.limiteSala%TYPE;
	LimiteTempoTipologia TIPOLOGIEINGRESSO.limiteTempo%TYPE;
	DurataValiditàTipologia TIPOLOGIEINGRESSO.durata%TYPE;
	Eliminato TIPOLOGIEINGRESSO.eliminato%TYPE;
	temp NUMBER(5) := 0;
	NumPersone ABBONAMENTI.numPersone%TYPE; 


BEGIN

	select NOME, COSTOTOTALE, LIMITESALA, LIMITETEMPO, DURATA, ELIMINATO
	into NomeTipologia, PrezzoTotaleTipologia, LimiteSaleTipologia, LimiteTempoTipologia, DurataValiditàTipologia, Eliminato
	from TIPOLOGIEINGRESSO
	where IDTIPOLOGIAING = tipologiaIngID;

	select count(*)
	into temp
	from ABBONAMENTI
	where tipologiaIngID = ABBONAMENTI.idtipologiaing;

	if temp > 0 then
		select numPersone
		into NumPersone
		from ABBONAMENTI
		where tipologiaIngID = ABBONAMENTI.idtipologiaing;

	end if;

	IF SQL%FOUND
	THEN

		MODGUI1.ApriPagina('Profile tipologiaIng', idSessione);
		HTP.BodyOpen;
		MODGUI1.Header;
		modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom w3-center" style="max-width:600px; margin-top:110px"');
		
		HTP.tableopen;
		HTP.tablerowopen;
		HTP.tabledata('Nome: '||NomeTipologia);
		HTP.tablerowclose;
		HTP.tablerowopen;
		HTP.tabledata('Prezzo: '||PrezzoTotaleTipologia);
		HTP.tablerowclose;
		HTP.tablerowopen;
		HTP.tabledata('Limite Sale: '||LimiteSaleTipologia);
		HTP.tablerowclose;
		HTP.tablerowopen;
		HTP.tabledata('Limite Tempo: '||LimiteTempoTipologia);
		HTP.tablerowclose;
		HTP.tablerowopen;
		HTP.tabledata('Durata Validità: '||DurataValiditàTipologia);
		HTP.tablerowclose;

		if temp > 0 then
			HTP.tablerowopen;
			HTP.tabledata('Numero intestatari: '||NumPersone);
			HTP.tablerowclose;
		end if;

		HTP.tableClose;
		if hasRole(idSessione, 'DBA') or hasRole(idSessione, 'AB') or hasRole(idSessione, 'GM') or hasRole(idSessione, 'GCE') then
			MODGUI1.Collegamento('Modifica', 'gruppo1.ModificaDatiTitoloIng?&tipologiaIngID=' || tipologiaIngID, 'w3-btn w3-round-xxlarge w3-black');
			htp.print('&nbsp;');
			if Eliminato = 0
			then
				MODGUI1.Collegamento('Elimina',
					'gruppo1.CancellazioneTipologiaIng?&tipologiaIngID='||tipologiaIngID,
					'w3-btn w3-round-xxlarge w3-black',
					'return confirm(''Sei sicuro di voler eliminare il titolo di ingresso '||NomeTipologia||'?'')');
			end if;		
		end if;		

		MODGUI1.collegamento('Torna al menu','gruppo1.ListaTipologieIng','w3-button w3-block w3-black w3-section w3-padding');
		MODGUI1.ChiudiDiv;
		HTP.BodyClose;
		HTP.HtmlClose;

	ELSE

		MODGUI1.EsitoOperazione('Errore', 
            'Tipologia di ingresso non trovata', 
            null, '', null,
            'Torna al menu delle tipologie', 'ListaTipologieIng', null);

	END IF;
END;


/* Procedura per la modifica dei dati di un titolo di ingresso */

PROCEDURE ModificaDatiTitoloIng(
	tipologiaIngID NUMBER
)
IS
	idSessione NUMBER(5) := modgui1.get_id_sessione();
	NomeTipologia TIPOLOGIEINGRESSO.nome%TYPE;
	PrezzoTotaleTipologia TIPOLOGIEINGRESSO.costoTotale%TYPE;
	LimiteSaleTipologia TIPOLOGIEINGRESSO.limiteSala%TYPE;
	LimiteTempoTipologia TIPOLOGIEINGRESSO.limiteTempo%TYPE;
	DurataValiditàTipologia TIPOLOGIEINGRESSO.durata%TYPE;
	temp NUMBER(5) := 0;
	RipristinaEliminato NUMBER(5) := 0;
	NumPersone ABBONAMENTI.numPersone%TYPE; 
	tipo VARCHAR2(20) := ''; 


BEGIN

	select NOME, COSTOTOTALE, LIMITESALA, LIMITETEMPO, DURATA, ELIMINATO
	into NomeTipologia, PrezzoTotaleTipologia, LimiteSaleTipologia, LimiteTempoTipologia, DurataValiditàTipologia, RipristinaEliminato
	from TIPOLOGIEINGRESSO
	where IDTIPOLOGIAING = tipologiaIngID;

	select count(*)
	into temp
	from ABBONAMENTI
	where tipologiaIngID = ABBONAMENTI.idtipologiaing;

	if temp > 0 then
		select numPersone
		into NumPersone
		from ABBONAMENTI
		where tipologiaIngID = ABBONAMENTI.idtipologiaing;

		tipo := 'Abbonamento';

	else	

		tipo := 'Biglietto';

	end if;


	IF SQL%FOUND
	THEN

		MODGUI1.ApriPagina('Profile tipologiaIng', idSessione);
		HTP.BodyOpen;
		MODGUI1.Header;
		MODGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom w3-padding-large" style="max-width:600px; margin-top:110px"');
		HTP.header(2, 'Modifica tipologia di ingresso');
		MODGUI1.ApriForm('gruppo1.ConfermaModificaTipologiaIng');

		HTP.FORMHIDDEN('IdTipologiaIng', tipologiaIngID);
		HTP.FORMHIDDEN('tipo', tipo);
		MODGUI1.Label('Nome*');
		MODGUI1.InputText('nomeNew', 'Nome tipologia', 1, NomeTipologia);
		HTP.BR;
		MODGUI1.Label('Prezzo*');
		MODGUI1.InputNumber('Costo Totale', 'costoTotaleNew', 1, PrezzoTotaleTipologia);
		HTP.BR;
		if LimiteSaleTipologia is NULL then
			MODGUI1.Label('Limite Sale*');
			MODGUI1.InputNumber('Limite Sale', 'limiteSaleNew', 0);
			HTP.BR;
		else	
			MODGUI1.Label('Limite Sale*');
			MODGUI1.InputNumber('Limite Sale', 'limiteSaleNew', 0, LimiteSaleTipologia);
			HTP.BR;
		end if;
		if LimiteTempoTipologia is NULL then	
			MODGUI1.Label('Limite Tempo*');
			MODGUI1.InputNumber('Limite Tempo', 'limiteTempoNew', 0);
			HTP.BR;
		else	
			MODGUI1.Label('Limite Tempo*');
			MODGUI1.InputNumber('Limite Tempo', 'limiteTempoNew', 0, LimiteTempoTipologia);
			HTP.BR;
		end if;	
		MODGUI1.Label('Durata Validità*');
		MODGUI1.InputText('durataNew', 'Durata', 1, DurataValiditàTipologia);
		HTP.BR;

		if temp > 0 then
			MODGUI1.Label('Numero intestatari*');
	        MODGUI1.InputNumber('Numero Intestatari', 'numPersoneNew', 1, NumPersone);
			HTP.BR;
		end if;

		if RipristinaEliminato > 0 then
			MODGUI1.InputCheckbox('Ripristina', 'ripristinaEliminato');
		end if;

		MODGUI1.InputSubmit('Salva');

		if RipristinaEliminato > 0 then
			MODGUI1.collegamento('Annulla','gruppo1.VisualizzaTipologieEliminate','w3-button w3-block w3-black w3-section w3-padding');
		else	
			MODGUI1.collegamento('Annulla','gruppo1.ListaTipologieIng','w3-button w3-block w3-black w3-section w3-padding');
		end if;

		MODGUI1.ChiudiForm;

		MODGUI1.ChiudiDiv;

		HTP.BodyClose;
		HTP.HtmlClose;

	ELSE

		MODGUI1.EsitoOperazione('Errore', 
            'Tipologia di ingresso non trovata', 
            null, '', null,
            'Torna al menu delle tipologie', 'ListaTipologieIng', null);

	END IF;
END;

--Procedura per confermare i dati della modifica delle Tipologie di ingresso
PROCEDURE ConfermaModificaTipologiaIng(
	IdTipologiaIng NUMBER DEFAULT NULL,
	nomeNew VARCHAR2 DEFAULT NULL,
	costoTotaleNew NUMBER DEFAULT NULL,
	limiteSaleNew NUMBER DEFAULT NULL,
	limiteTempoNew NUMBER DEFAULT NULL,
    durataNew VARCHAR2 DEFAULT NULL,
	tipo VARCHAR2 DEFAULT NULL,
	numPersoneNew NUMBER DEFAULT NULL,
	ripristinaEliminato VARCHAR2 DEFAULT NULL
)IS	

idSessione NUMBER(5) := modgui1.get_id_sessione();
BEGIN
	
    -- se tipologia non autorizzata: messaggio errore
	IF (nomeNew IS NULL)
	OR (costoTotaleNew = 0) 
	OR (limiteSaleNew = 0 
		AND limiteTempoNew = 0)
	OR (limiteSaleNew != 0 
		AND limiteTempoNew != 0)
	OR (durataNew = 0)
	THEN
		-- uno dei parametri con vincoli ha valori non validi
		MODGUI1.EsitoOperazione('Errore', 
            'Uno dei parametri non è stato inserito correttamente', 
            null, null, null,
            'Torna al menu delle tipologie', 'ListaTipologieIng', null);

	ELSE

		MODGUI1.APRIPAGINA('Pagina OK', 0);
		HTP.BodyOpen;

		MODGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom w3-padding-large" style="max-width:600px; margin-top:110px"');
		HTP.header(2, 'Conferma dati');

		HTP.TableOpen;
		HTP.TableRowOpen;
		HTP.TableData('Nome: ');
		HTP.TableData(nomeNew);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Prezzo: ');
		HTP.TableData(costoTotaleNew);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Limite Sale: ');
		HTP.TableData(limiteSaleNew);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Limite Tempo: ');
		HTP.TableData(limiteTempoNew);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Durata validità: ');
		HTP.TableData(durataNew);
		HTP.TableRowClose;
		HTP.TableRowOpen;
		HTP.TableData('Tipologia ingresso: ');
		HTP.TableData(tipo);
		HTP.TableRowClose;
		
		if tipo = 'Abbonamento'
		then
			HTP.TableRowOpen;
			HTP.TableData('Numero intestatari: ');
			HTP.TableData(numPersoneNew);
			HTP.TableRowClose;
		end if;

		if ripristinaEliminato = 'on' then
			HTP.TableRowOpen;
			HTP.TableData('Ripristina tipologia di ingresso: ');
			HTP.TableData('Sì');
			HTP.TableRowClose;
		end if;	

        MODGUI1.ApriForm('gruppo1.ModificaDatiTipologieIng');
		HTP.FORMHIDDEN('IdTipologia', IdTipologiaIng);
		HTP.FORMHIDDEN('nomeNew', nomeNew);
		HTP.FORMHIDDEN('costoTotaleNew', costoTotaleNew);
		HTP.FORMHIDDEN('limiteSaleNew', limiteSaleNew);
		HTP.FORMHIDDEN('limiteTempoNew', limiteTempoNew);
		HTP.FORMHIDDEN('durataNew', durataNew);
		HTP.FORMHIDDEN('ripristinaELiminato', ripristinaEliminato);
		HTP.FORMHIDDEN('tipo', tipo);

		if tipo = 'Abbonamento'
		then
			HTP.FORMHIDDEN('numPersoneNew', numPersoneNew);
		end if;

		MODGUI1.InputSubmit('Conferma');
		MODGUI1.ChiudiForm;
		MODGUI1.Collegamento('Annulla', 'gruppo1.ModificaDatiTitoloIng?tipologiaIngID='||IdTipologiaIng,'w3-button w3-block w3-black w3-section w3-padding');
		MODGUI1.ChiudiDiv;
		HTP.BodyClose;
		HTP.HtmlClose;
	END IF;
	
	EXCEPTION WHEN OTHERS THEN
		dbms_output.put_line('Error: '||sqlerrm);
END;

--Procedura per modificare i dati delle Tipologie di ingresso
PROCEDURE ModificaDatiTipologieIng (
	IdTipologia NUMBER DEFAULT NULL,
	nomeNew VARCHAR2 DEFAULT NULL,
	costoTotaleNew NUMBER DEFAULT NULL,
	limiteSaleNew NUMBER DEFAULT NULL,
	limiteTempoNew NUMBER DEFAULT NULL,
    durataNew VARCHAR2 DEFAULT NULL,
	tipo VARCHAR2 DEFAULT NULL,
	numPersoneNew NUMBER DEFAULT NULL,
	ripristinaEliminato VARCHAR2 DEFAULT NULL 
) IS
idSessione NUMBER(5) := modgui1.get_id_sessione();
limiteSaleTmp TIPOLOGIEINGRESSO.limiteSala%TYPE;
limiteTempoTmp TIPOLOGIEINGRESSO.limiteTempo%TYPE;

BEGIN

	IF limiteSaleNew = 0 THEN
		limiteSaleTmp := NULL;
	ELSE
		limiteSaleTmp := limiteSaleNew;	
	END IF;

	IF limiteTempoNew = 0 THEN
		limiteTempoTmp := NULL;
	ELSE
		limiteTempoTmp := limiteTempoNew;	
	END IF;	 

	IF ripristinaEliminato = 'on'
	THEN
		-- tutti i parametri sono stati controllati prima, dobbiamo solo inserirli nella tabella (caso di modifica di una tipologia eliminata)
    	IF tipo = 'Biglietto'
		THEN
			UPDATE TIPOLOGIEINGRESSO
			SET NOME = nomeNew, COSTOTOTALE = costoTotaleNew, LIMITESALA = limiteSaleTmp, LIMITETEMPO = limiteTempoTmp, DURATA = durataNew, ELIMINATO = 0   
			WHERE IDTIPOLOGIAING = IdTipologia;

			UPDATE BIGLIETTI
      	    SET ELIMINATO = 0
	  		WHERE IDTIPOLOGIAING = IdTipologia;
    
    	ELSE
     	    UPDATE TIPOLOGIEINGRESSO
			SET NOME = nomeNew, COSTOTOTALE = costoTotaleNew, LIMITESALA = limiteSaleTmp, LIMITETEMPO = limiteTempoTmp, DURATA = durataNew, ELIMINATO = 0  
			WHERE IDTIPOLOGIAING = IdTipologia;

      		UPDATE ABBONAMENTI
      	    SET NUMPERSONE = numPersoneNew, ELIMINATO = 0
	  		WHERE IDTIPOLOGIAING = IdTipologia;
    	END IF; 
	
	ELSE
    	-- tutti i parametri sono stati controllati prima, dobbiamo solo inserirli nella tabella (caso di modifica di una tipologia non eliminata)
    	IF tipo = 'Biglietto'
		THEN
			UPDATE TIPOLOGIEINGRESSO
			SET NOME = nomeNew, COSTOTOTALE = costoTotaleNew, LIMITESALA = limiteSaleTmp, LIMITETEMPO = limiteTempoTmp, DURATA = durataNew   
			WHERE IDTIPOLOGIAING = IdTipologia;
    
    	ELSE
        	UPDATE TIPOLOGIEINGRESSO
			SET NOME = nomeNew, COSTOTOTALE = costoTotaleNew, LIMITESALA = limiteSaleTmp, LIMITETEMPO = limiteTempoTmp, DURATA = durataNew  
			WHERE IDTIPOLOGIAING = IdTipologia;

        	UPDATE ABBONAMENTI
        	SET NUMPERSONE = numPersoneNew
			WHERE IDTIPOLOGIAING = IdTipologia;

    	END IF;  
	END IF;  

	IF SQL%FOUND
	THEN
		-- faccio il commit dello statement precedente
		commit;

		MODGUI1.EsitoOperazione('Successo', 
            'Tipologia di ingresso modificata correttamente', 
            null, null, null,
            'Torna al menu delle tipologie', 'ListaTipologieIng', null);

	ELSE

		MODGUI1.EsitoOperazione('Errore', 
            'Tipologia di ingresso non modificata correttamente', 
            'Riprova', 'ModificaDatiTitoloIng', null,
            'Torna al menu delle tipologie', 'ListaTipologieIng', null);

	END IF;

END;


--Procedura che implementa la cancellazione di una tipologia (settando il flag ELIMINATO a 1)
procedure CancellazioneTipologiaIng(
	tipologiaIngID NUMBER 
)
IS
	idSessione NUMBER(5) := modgui1.get_id_sessione();
	temp number(1);		--Variabile temporale usata per verificare che la query sql abbia restituito una tipologia di ingresso
	temp2 number(1);	--Variabile temporale usata per verificare che l'operazione di eliminazione (update) sia stata eseguita correttamente o meno
BEGIN

	select count(*)  
	into temp 
	from TIPOLOGIEINGRESSO 
	where IDTIPOLOGIAING = tipologiaIngID;

	if temp>0
	then

		UPDATE BIGLIETTI
		SET ELIMINATO = 1
		WHERE IDTIPOLOGIAING = tipologiaIngID;
		
		UPDATE ABBONAMENTI
		SET ELIMINATO = 1
		WHERE IDTIPOLOGIAING = tipologiaIngID;

		UPDATE TIPOLOGIEINGRESSO
		SET ELIMINATO = 1
		WHERE IDTIPOLOGIAING = tipologiaIngID;

		select count(*) 
		into temp2 
		from TIPOLOGIEINGRESSO 
		where IDTIPOLOGIAING = tipologiaIngID AND ELIMINATO = 1;

		if temp2>0
		then

			MODGUI1.EsitoOperazione('Successo', 
            'Tipologia di ingresso eliminata correttamente', 
            null, '', null,
            'Torna al menu delle tipologie', 'ListaTipologieIng', null);

		else

			MODGUI1.EsitoOperazione('Errore', 
            'Tipologia di ingresso non eliminata correttamente', 
            null, '', null,
            'Torna al menu delle tipologie', 'ListaTipologieIng', null);

		end if;

	ELSE

		MODGUI1.EsitoOperazione('Errore', 
            'Tipologia di ingresso non trovata', 
            null, '', null,
            'Torna al menu delle tipologie', 'ListaTipologieIng', null);

	end if;
		
END;

--Procedura che implementa l'operazione statistica di visualizzazione della tipologia più scelta in un lasso di tempo scelto
procedure TipologiaPiuScelta(
	dataInizioFun VARCHAR2 DEFAULT NULL,
	dataFineFun VARCHAR2 DEFAULT NULL
)
is
	dataInizio DATE := TO_DATE(dataInizioFun default NULL on conversion error, 'YYYY-MM-DD');
	dataFine DATE := TO_DATE(dataFineFun default NULL on conversion error, 'YYYY-MM-DD');
	var1 NUMBER(20);	--Variabile utilizzata per visualizzare il risultato della query a schermo (Biglietto)
	var2 NUMBER(20);	--Variabile utilizzata per visualizzare il risultato della query a schermo (Abbonamento)
	idSessione NUMBER(5) := modgui1.get_id_sessione();

	cursor countTitoli is (
				select nome, count(*) as ctitoli, IdTipologiaIng
				from TITOLIINGRESSO
				join TIPOLOGIEINGRESSO on tipologia = IdTipologiaIng
				where Emissione > dataInizio and Emissione < dataFine
				group by NOME, IdTipologiaIng
			);

	BEGIN
		select count(*)
		into var1
		from TITOLIINGRESSO
		where EXISTS (select *
					  from ABBONAMENTI
					  where ABBONAMENTI.IdTipologiaIng = TITOLIINGRESSO.tipologia AND 
					  TITOLIINGRESSO.emissione > dataInizio and TITOLIINGRESSO.emissione < dataFine);

		select count(*)
		into var2
		from TITOLIINGRESSO
		where EXISTS (select *
					  from BIGLIETTI
					  where BIGLIETTI.IdTipologiaIng = TITOLIINGRESSO.tipologia AND 
					  TITOLIINGRESSO.emissione > dataInizio and TITOLIINGRESSO.emissione < dataFine); 


		modGUI1.ApriPagina('EsitoPositivoUtenti',idSessione);
            modGUI1.Header;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom w3-padding-large" style="max-width:450px"');
                modGUI1.ApriDiv('class="w3-center"');
                htp.print('<h1>Operazione eseguita correttamente </h1>');
				if var1 = var2 and var1 = 0
				then
					htp.print('<h3>Non sono presenti tipologie per l''arco temporale scelto  </h3>');
				else
					if var1 < var2 then
						htp.print('<h3>La tipologia più scelta nell arco di tempo indicato sono Biglietti '||var2||' </h3>');
					ELSE
						htp.print('<h3>La tipologia più scelta nell arco di tempo indicato sono Abbonamenti '||var1||' </h3>');	
					end if;	
				end if;	
				modgui1.apriTabella('w3-table w3-striped w3-centered');
				for x in countTitoli
						LOOP
						modgui1.apriRigaTabella;
						modgui1.apriElementoTabella;
						htp.print(x.nome);
						modgui1.chiudiElementoTabella;
						modgui1.apriElementoTabella;
						htp.print(x.ctitoli);
						modgui1.chiudiElementoTabella;
						modgui1.apriElementoTabella;
						modGUI1.Collegamento('Visualizza',
                            'gruppo1.VisualizzaDatiTitoloIng?tipologiaIngID='||x.idTipologiaIng,
                            'w3-btn w3-round-xxlarge w3-black');
						modgui1.chiudiElementoTabella;	
						modgui1.chiudiRigaTabella;
						end LOOP;
				modgui1.chiudiTabella;		
                MODGUI1.collegamento('Torna alle statistiche','gruppo1.StatisticheTipologieIng','w3-button w3-block w3-black w3-section w3-padding');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
			HTP.BodyClose;
		HTP.HtmlClose;

END;

--Procedura che implementa l'operazione statistica di visualizzazione di tutte le tipologie in ordine crescente
PROCEDURE VisualizzaTipologieIngOrdine
is
idSessione NUMBER(5) := modgui1.get_id_sessione();
begin
	modGUI1.ApriPagina('Lista tipologie ing',idSessione);
            modGUI1.Header;
		modGUI1.ApriDiv('class="w3-center" style="margin-top:110px;"');
        htp.prn('<h1>Lista tipologie di ingresso ordinata</h1>');
		
        modGUI1.ChiudiDiv;
        htp.br;
        modGUI1.ApriDiv('class="w3-row w3-container"');
   		for tipologia in (select * from TIPOLOGIEINGRESSO where ELIMINATO = 0 order by NOME, COSTOTOTALE)  loop
                modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                    modGUI1.ApriDiv('class="w3-card-4" style="height:200px;"');
						modGUI1.ApriDiv('class="w3-container w3-center"');
							htp.prn('<p>'|| tipologia.nome ||'</p>');
							htp.br;
						modGUI1.ChiudiDiv;
						modGUI1.Collegamento('Visualizza',
                            'gruppo1.VisualizzaDatiTitoloIng?tipologiaIngID='||tipologia.idTipologiaIng,
                            'w3-btn w3-round-xxlarge w3-black');
						htp.print('&nbsp;');	
                    if hasRole(idSessione, 'DBA') or hasRole(idSessione, 'AB') or hasRole(idSessione, 'GM') or hasRole(idSessione, 'GCE') then
						modGUI1.Collegamento('Modifica',
                            'gruppo1.ModificaDatiTitoloIng?tipologiaIngID='||tipologia.idTipologiaIng,
                            'w3-btn w3-round-xxlarge w3-black');
						htp.print('&nbsp;');
                        modGUI1.Collegamento('Elimina',
                            'gruppo1.CancellazioneTipologiaIng?tipologiaIngID='||tipologia.idTipologiaIng,
                            'w3-btn w3-round-xxlarge w3-black',
							'return confirm(''Sei sicuro di voler eliminare la tipologia '||tipologia.nome||'?'')'
							);
                    end if;
                	modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
        END LOOP;
		MODGUI1.collegamento('Torna al menu','gruppo1.ListaTipologieIng','w3-button w3-block w3-black w3-section w3-padding');
        modGUI1.chiudiDiv;
      
end;

--Procedura che implementa l'operazione statistica di visualizzazione di tutte le tipologie eliminate
PROCEDURE VisualizzaTipologieEliminate
is
idSessione NUMBER(5) := modgui1.get_id_sessione();
begin
	modGUI1.ApriPagina('Lista tipologie ing',idSessione);
            modGUI1.Header;
		modGUI1.ApriDiv('class="w3-center" style="margin-top:110px;"');
        htp.prn('<h1>Lista tipologie di ingresso eliminate</h1>');
		
        modGUI1.ChiudiDiv;
        htp.br;
        modGUI1.ApriDiv('class="w3-row w3-container"');
   		for tipologia in (select * from TIPOLOGIEINGRESSO where ELIMINATO = 1)  loop
                modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                    modGUI1.ApriDiv('class="w3-card-4" style="height:200px;"');
						modGUI1.ApriDiv('class="w3-container w3-center"');
							htp.prn('<p>'|| tipologia.nome ||'</p>');
							htp.br;
						modGUI1.ChiudiDiv;
						modGUI1.Collegamento('Visualizza',
                            'gruppo1.VisualizzaDatiTitoloIng?tipologiaIngID='||tipologia.idTipologiaIng,
                            'w3-btn w3-round-xxlarge w3-black');
						htp.print('&nbsp;');	
                        if hasRole(idSessione, 'DBA') or hasRole(idSessione, 'AB') or hasRole(idSessione, 'GM') or hasRole(idSessione, 'GCE') then
						modGUI1.Collegamento('Modifica',
                            'gruppo1.ModificaDatiTitoloIng?tipologiaIngID='||tipologia.idTipologiaIng,
                            'w3-btn w3-round-xxlarge w3-black');
                    	end if;
                	modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
        END LOOP;
		MODGUI1.collegamento('Torna al menu','gruppo1.ListaTipologieIng','w3-button w3-block w3-black w3-section w3-padding');
        modGUI1.chiudiDiv;
      
end;

--Procedura che implementa la home page delle statistiche delle tipologie di ingresso
procedure StatisticheTipologieIng
is
	idSessione NUMBER(5) := modgui1.get_id_sessione();
	nomeutente utenti.nome%TYPE;
	cognomeutente utenti.cognome%TYPE;
	varidutente utenti.Idutente%TYPE;
begin
		MODGUI1.ApriPagina('Statistiche ambiente di servizio', idSessione);
			HTP.BodyOpen;
			MODGUI1.Header;
			modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="margin-top:110px"');
			modgui1.apriTabella('w3-table w3-striped w3-centered');
				
				modgui1.apriRigaTabella;
				HTP.header(1,'Menù statistiche tipologie di ingresso', 'center');
				modgui1.chiudiRigaTabella;

				modgui1.apriRigaTabella;
				modgui1.intestazioneTabella('Dati');
				modgui1.intestazioneTabella('Operazione');
				modgui1.intestazioneTabella('Risultato');
				modgui1.chiudiRigaTabella;

				modgui1.apriRigaTabella;
					MODGUI1.ApriForm('gruppo1.TipologiaPiuScelta');
					modgui1.apriElementoTabella;
						modgui1.apridiv('class="w3-padding-24"');
						modgui1.elementoTabella('Tutte le tipologie');
						modgui1.chiudiDiv;
						htp.br;
						MODGUI1.Label('Data inizio');
						MODGUI1.InputDate('dataInizioFun', 'dataInizioFun', 1);
						htp.br;
						MODGUI1.Label('Data fine');
						MODGUI1.InputDate('dataFineFun', 'dataFineFun', 1);
					modgui1.chiudiElementoTabella;
					modgui1.apriElementoTabella;
						modgui1.apridiv('class="w3-padding-24"');
						modgui1.elementoTabella('Tipologia più venduta in un arco temporale');
						modgui1.chiudiDiv;
					modgui1.chiudiElementoTabella;
					modgui1.apriElementoTabella;
						MODGUI1.InputSubmit('Calcola');
					modgui1.chiudiElementoTabella;
					MODGUI1.ChiudiForm;
				modgui1.chiudiRigaTabella;

				modgui1.apriRigaTabella;
					MODGUI1.ApriForm('gruppo1.VisualizzaTipologieIngOrdine');
					modgui1.apriElementoTabella;
						modgui1.apridiv('class="w3-padding-24"');
						modgui1.elementoTabella('Tutte le tipologie');
						modgui1.chiudiDiv;
					modgui1.chiudiElementoTabella;
					modgui1.apriElementoTabella;
						modgui1.apridiv('class="w3-padding-24"');
						modgui1.elementoTabella('Lista tipologie in ordine di nome');
						modgui1.chiudiDiv;
					modgui1.chiudiElementoTabella;
					modgui1.apriElementoTabella;
						MODGUI1.InputSubmit('Calcola');
					modgui1.chiudiElementoTabella;
					MODGUI1.ChiudiForm;
				modgui1.chiudiRigaTabella;

				modgui1.apriRigaTabella;
					MODGUI1.ApriForm('gruppo1.VisualizzaTipologieEliminate');
					modgui1.apriElementoTabella;
						modgui1.apridiv('class="w3-padding-24"');
						modgui1.elementoTabella('Tutte le tipologie');
						modgui1.chiudiDiv;
					modgui1.chiudiElementoTabella;
					modgui1.apriElementoTabella;
						modgui1.apridiv('class="w3-padding-24"');
						modgui1.elementoTabella('Lista tipologie eliminate');
						modgui1.chiudiDiv;
					modgui1.chiudiElementoTabella;
					modgui1.apriElementoTabella;
						MODGUI1.InputSubmit('Calcola');
					modgui1.chiudiElementoTabella;
					MODGUI1.ChiudiForm;
				modgui1.chiudiRigaTabella;



			modgui1.chiudiTabella;
			MODGUI1.collegamento('Torna al menu','gruppo1.ListaTipologieIng','w3-button w3-block w3-black w3-section w3-padding');
		HTP.BodyClose;
		HTP.HtmlClose;
end;

END GRUPPO1;