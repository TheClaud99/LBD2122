SET DEFINE OFF;
Create or replace PACKAGE body operazioniGruppo4 as
/*visualizza tutti i campi estivi*/
/*
 * OPERAZIONI SUI MUSEI
 * - Inserimento ✅
 * - Modifica ✅
 * - Visualizzazione ✅ 
 * - Cancellazione (rimozione) (da non fare)
 * OPERAZIONI STATISTICHE E MONITORAGGIO
 * - Sale presenti ✅
 * - Opere presenti nel Museo ✅
 * - Opere in prestito al Museo ✅
 * - Numero visitatori unici in un arco temporale scelto ✅
 * - Numero medio visitatori in un arco temporale scelto ✅(da aggiustare)
 * -Introiti museo (sia ottenuti attraverso vendita di biglietti e abbonamenti
che attraverso campi estivi, potendo opportunamente decidere uno, due
o entrambi i casi) ✅
 */

/*
 * OPERAZIONI SUI CAMPI ESTIVI
 * - Inserimento ✅ da modificare
 * - Modifica ✅ da modificare
 * - Visualizzazione ✅ 
 * - Cancellazione  ✅ 
 * OPERAZIONI STATISTICHE E MONITORAGGIO
 * - Numero iscritti ✅
 * - Utenti iscritti al campo Estivo ✅
 * - Tariffe che danno accesso al campo ✅
 * - Età media visitatori iscritti al Campo Estivo ✅ 
 * - Introiti relativi ad un Museo tramite i Campi Estivi ✅
 */


 /*
 * OPERAZIONI SUI PAGAMENTI CAMPI ESTIVI
 * - Inserimento ✅
 * - Modifica (da non fare)
 * - Visualizzazione ✅ 
 * - Cancellazione (da non fare) 
 * OPERAZIONI STATISTICHE E MONITORAGGIO
 * - Pagamenti effettuati ✅
 * - Utenti relativi ad un pagamento ✅
 * - Numero di pagamenti relativi ad una tariffa ✅
 */


 /*
 * OPERAZIONI SULLE TARIFFE CAMPI ESTIVI
 * - Inserimento ✅
 * - Modifica ✅
 * - Visualizzazione ✅ 
 * - Cancellazione ✅ 
 * OPERAZIONI STATISTICHE E MONITORAGGIO
 * - Preferenza Tariffa per ogni campo estivo ✅
 * - Lista Tariffe relative ad un Campo Estivo scelto in ordine di prezzocrescente ✅
 
 */


procedure menutariffe
(
   idCampo IN number default 0,
   ordine IN number default 0
)
is 
   sessionid NUMBER(5):=modGUI1.get_id_sessione();
   nomecampo CAMPIESTIVI.NOME%TYPE;
BEGIN
   Select Nome
   into nomecampo
   from CAMPIESTIVI
   where idcampo=IDCAMPIESTIVI;

   htp.prn('<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> ');
   modGUI1.ApriPagina('Tariffe Campi Estivi');
   modGUI1.Header();
   htp.br;htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 Align="center"> Tariffe </h1>');
   htp.prn('<p style="font-size:25px; text-align:center" ><b>'||nomecampo||'</b></p>');
  
   modGUI1.APRIDIV('class="w3-col l4 w3-padding-large w3-left"');
   modGUI1.APRIDIV('class="w3-center"');
   if hasrole(sessionid,'DBA') or hasrole(sessionid,'GCE')
   then
      modGUI1.Collegamento('inserisci Tariffa',operazioniGruppo4.gr4||'inserisciTariffeCampiEstivi?prezzo=&etaMinima=&etaMassima=&campoEstivo='||idCampo,'w3-black w3-round w3-margin w3-button');
   end if;
   modGUI1.ChiudiDiv();
   modGUI1.ChiudiDiv();


   modGUI1.APRIDIV('class="w3-col l4 w3-padding-large w3-center"');
      modGUI1.Collegamento('campi estivi',operazioniGruppo4.gr4||operazioniGruppo4.menu_ce,'w3-btn w3-round-xxlarge w3-black ');
   modGUI1.ChiudiDiv();

   modGUI1.APRIDIV('class="w3-col l4 w3-padding-large w3-right"');
   modGUI1.APRIDIV('class="w3-center"');
   if hasrole(sessionid,'DBA') or hasrole(sessionid,'GCE')
   then   
      modGUI1.Collegamento('Tariffe preferite',operazioniGruppo4.gr4||'preferenzaTariffa?campoid='||idCampo,'w3-black w3-round w3-margin w3-button');
   end if;
      htp.br;htp.br;
      modGUI1.APRIFORM(operazioniGruppo4.gr4||'menutariffe?idCampo='||idCampo||'&ordine='||ordine);
         htp.FORMHIDDEN('idCampo',idCampo);
         MODGUI1.LABEL('Ordine');
         MODGUI1.SELECTOPEN('ordine',ordine);
         modGUI1.SELECTOPTION(0,'Id');
         modGUI1.SELECTOPTION(1,'Prezzo');
         modGUI1.SELECTOPTION(2,'Età Minima');
         modGUI1.SELECTOPTION(3,'Età Massima');
         modgui1.SELECTCLOSE;
         htp.print('&nbsp;&nbsp;&nbsp;');
         htp.prn('<input type="submit" class="w3-button w3-round w3-black" value="invia" style="display:inline;">');
      modGUI1.ChiudiForm;
   modGUI1.Chiudidiv();
   modGUI1.Chiudidiv();

   modGUI1.ApriDiv('class="w3-row w3-container"');
   FOR tariffa IN (Select IdTariffa,Prezzo,Etaminima,Etamassima,CAMPOESTIVO,Eliminato from TARIFFECAMPIESTIVI where campoestivo=idCampo AND Eliminato=0 
            order by (CASE WHEN ordine=0 then IdTariffa end),
                     (CASE WHEN ordine=1 then Prezzo end),
                     (CASE WHEN ordine=2 then Etaminima end),
                     (CASE WHEN ordine=3 then Etamassima end))
                        
   LOOP
      modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
         modGUI1.ApriDiv('class="w3-card-4" style="height:250px;"');
            modGUI1.ApriDiv('class="w3-container w3-center"');
               HTP.TABLEOPEN(CALIGN  => 'center' );
               HTP.TableRowOpen;
               HTP.TableData('IdTariffa',CATTRIBUTES  =>'style="font-weight:bold; text-align: center"');
               HTP.TableData('Prezzo ',CATTRIBUTES  =>'style="font-weight:bold; text-align: center"');
               HTP.TableData('Età minima',CATTRIBUTES  =>'style="font-weight:bold; text-align: center"');
               HTP.TableData('Età massima',CATTRIBUTES  =>'style="font-weight:bold; text-align: center"');
               HTP.TableRowClose;
               HTP.TableRowOpen;
               HTP.TableData(tariffa.IdTariffa ,'center');
               HTP.TableData(tariffa.Prezzo || '€','center');
               HTP.TableData(tariffa.Etaminima,'center');
               HTP.TableData(tariffa.Etamassima,'center');
               HTP.TableRowClose;
               HTP.TableClose;
            modGUI1.ChiudiDiv;      
            modGUI1.ApriDiv('class="w3-center"');
               if hasrole(sessionid,'DBA') or hasRole(sessionid,'GCE') or hasRole(sessionid,'AB')
               then
                  modGUI1.Collegamento('Visualizza',operazioniGruppo4.gr4||'VisualizzaTariffeCampiEstivi?Tariffa='||tariffa.idTariffa,'w3-green w3-margin w3-button');
               end if;
               if hasrole(sessionid,'DBA') or hasrole(sessionid,'GCE')
               then
                  modGUI1.Collegamento('Modifica',operazioniGruppo4.gr4||'ModificaTariffeCampiEstivi?up_idTariffa='||tariffa.idTariffa,'w3-red w3-margin w3-button');
                  htp.prn('<button onclick="document.getElementById(''Elimtariffa'||tariffa.IdTariffa||''').style.display=''block''" class="w3-margin w3-button w3-black w3-hover-white">Elimina</button>');
                  operazioniGruppo4.eliminatariffa(tariffa.IdTariffa); 
               end if;
               
               if hasrole(sessionid,'DBA') or hasrole(sessionid,'GCE')
               then
                  htp.prn('<h1 Align="center" style="font-size:170%;">Pagamenti</h1>');
                  modGUI1.Collegamento('inserisci pagamento',operazioniGruppo4.gr4||'InserisciPagamentoCampiEstivi?datapagamento=&tariffa='||tariffa.IdTariffa||'&acquirente=','w3-green w3-margin w3-button');
                  modGUI1.Collegamento('visualizza pagamenti',operazioniGruppo4.gr4||'PagamentoCampiEstivi?tariffaid='||tariffa.IdTariffa,'w3-red w3-margin w3-button');
               end if;
                        
            modGUI1.ChiudiDiv;
         modGUI1.ChiudiDiv;
      modGUI1.ChiudiDiv;
   END LOOP;
   modGUI1.chiudiDiv;
end;

procedure menucampiestivi
(
   searchmuseo In MUSEI.IDMUSEO%TYPE default NULL
)
is
   sessionid NUMBER(5):=modGUI1.get_id_sessione();
   Nomemus MUSEI.NOME%TYPE;
   CURSOR cur IS 
   Select MUSEI.IDMUSEO, MUSEI.NOME
   FROM MUSEI;
BEGIN
   htp.prn('<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> ');
   modGUI1.ApriPagina('Campi Estivi');
   modGUI1.Header();
   htp.br;htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 Align="center" style="font-size:50px">Campi Estivi</h1>');
   if hasRole(sessionid,'DBA') or hasRole(sessionid,'GCE')
   then
      modGUI1.APRIDIV('class="w3-col l4 w3-padding-large w3-left"');
      modGUI1.APRIDIV('class="w3-center"');
      modGUI1.Collegamento('inserisci',OperazioniGruppo4.gr4 ||'inseriscicampiestivi?newNome=&newMuseo=&newDatainizio=&newDataConclusione=','w3-black w3-round w3-margin w3-button');
      htp.br;
      modGUI1.APRIFORM(operazioniGruppo4.gr4||operazioniGruppo4.menu_ce);
      modgui1.LABEL('Museo');
      modgui1.SELECTOPEN('searchmuseo',searchmuseo);
      FOR Mus_cur IN cur LOOP
         modGUI1.SelectOption(Mus_cur.IDMUSEO,Mus_cur.NOME);
      END LOOP;
      modgui1.selectclose;
      htp.print('&nbsp;&nbsp;&nbsp;');
         htp.prn('<input type="submit" class="w3-button w3-round w3-black" value="filtra" style="display:inline;">');
         htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
         modGUI1.Collegamento('reset',operazioniGruppo4.gr4||operazioniGruppo4.menu_ce,'w3-btn  w3-black ');
      modGUI1.chiudiform;
      
      modGUI1.ChiudiDiv();
      modGUI1.ChiudiDiv();
      
      modGUI1.APRIDIV('class="w3-col l4 w3-padding-large w3-right"');
      modGUI1.APRIDIV('class="w3-center"');
         modGUI1.Collegamento('Statistiche',OperazioniGruppo4.gr4 || 'form1campiestivi?&CampoestivoId=&NameCampoestivo=','w3-black w3-round w3-margin w3-button');
         checkDataButton; 
      modGUI1.ChiudiDiv();
      modGUI1.ChiudiDiv();
   end if;
   modGUI1.ApriDiv('class="w3-row w3-container"');
   FOR campo IN (Select Eliminato,IdCampiEstivi,Nome,Stato,DataInizio,DataConclusione,Museo from CAMPIESTIVI where ELIMINATO=0 AND Museo LIKE '%'||searchmuseo||'%')
   LOOP
      modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
         modGUI1.ApriDiv('class="w3-card-4" style="height:600px;"');
            modGUI1.ApriDiv('class="w3-container w3-center"');
               Select NOME
               into Nomemus
               FROM MUSEI
               WHERE MUSEI.IDMUSEO=campo.Museo;
               htp.prn('<p style="text-align:center; font-size:25px">'||campo.nome||'</p>');
               htp.prn('<p style="text-align:center"><b>Museo:</b>'||Nomemus||'</p>');
               htp.prn('<p style="text-align:center"><b>Stato:</b>'||campo.Stato||'</p>');
               HTP.TABLEOPEN(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table"' );
               HTP.TableRowOpen;
               HTP.TableData('Data Inizio',CATTRIBUTES  =>'style="font-weight:bold; text-align: center"');
               HTP.TableData('Data Conclusione',CATTRIBUTES  =>'style="font-weight:bold; text-align: center"');
               HTP.TableRowClose;
               HTP.TableRowOpen;
               if campo.DataInizio is null then
                  HTP.TableData('Inesistente',CATTRIBUTES=>'style="text-align:center"');
               else
                  HTP.TableData(campo.DataInizio,CATTRIBUTES=>'style="text-align:center"');
               end if;
               if campo.DataConclusione is null then 
                  HTP.TableData('Inesistente',CATTRIBUTES=>'style="text-align:center"');
               else
                  HTP.TableData(campo.DataConclusione, CATTRIBUTES=>'style="text-align:center"');
               end if;
               HTP.TableRowClose;
               HTP.TableClose;
            modGUI1.ChiudiDiv;
            if hasRole(sessionid,'DBA') or hasRole(sessionid,'GCE')      
            then
               modGUI1.Collegamento('Visualizza',OperazioniGruppo4.gr4 ||'visualizzacampiestivi?campiestiviId='||campo.IdCampiEstivi,'w3-green w3-margin w3-button');
               modGUI1.COLLEGAMENTO('Modifica',OperazioniGruppo4.gr4 ||'modificacampiestivi?idcampo='||campo.IDCAMPIESTIVI ||'&newNome=' ||campo.Nome ||'&newDatainizio='||campo.DataInizio||'&newDataConclusione='||campo.DataConclusione,'w3-red w3-round w3-margin w3-button');
            end if;
            if hasRole(sessionid,'DBA')
            then
               htp.prn('<button onclick="document.getElementById(''Elimcampo'||campo.IdCampiEstivi||''').style.display=''block''" class="w3-margin w3-button w3-black w3-hover-white">Elimina</button>');
               OperazioniGruppo4.eliminacampo(campo.IdCampiEstivi);
            end if;
            htp.br;htp.br;
            htp.prn('<h1 Align="center" style="font-size:170%;"><b>Tariffe-Pagamenti</b></h1>');
            modGUI1.Collegamento('tariffe',OperazioniGruppo4.gr4 ||'menutariffe?idCampo='||campo.IdCampiEstivi,'w3-red w3-margin w3-button');
            if hasRole(sessionid,'DBA') or hasRole(sessionid,'GCE')
            then
               modGUI1.Collegamento('storico pagamenti',OperazioniGruppo4.gr4 ||'form1tariffe?campoEstivo='||campo.IdCampiEstivi||'&Data1=&Data2=','w3-black w3-round w3-margin w3-button');
            end if;
         modGUI1.ChiudiDiv;
      modGUI1.ChiudiDiv;
   END LOOP;
   modGUI1.chiudiDiv; 
end;


procedure inseriscicampiestivi
(
   newNome in CAMPIESTIVI.Nome%TYPE default null,
   newMuseo in Musei.Nome%TYPE,
   newDatainizio in VARCHAR2 default null,
   newDataConclusione in VARCHAR2 default null
)
is
   CURSOR cur IS 
   Select MUSEI.IDMUSEO, MUSEI.NOME
   FROM MUSEI;
BEGIN
   htp.htmlOpen;
   modGUI1.ApriPagina('Inserisci Campo');
   modGUI1.Header();
   htp.bodyOpen;
   htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;  
   htp.prn('<h1 align="center">Inserimento Campo Estivo</h1>');
   modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
   modGUI1.Collegamento('M',operazioniGruppo4.gr4||operazioniGruppo4.menu_ce,'w3-btn  w3-black w3-display-topright ');
   modGUI1.ApriForm(operazioniGruppo4.gr4||'confermacampiestivi','invia','w3-container');
   modGUI1.LABEL('Nome');
   modGUI1.INPUTTEXT('newNome','Nome',1,newNome);
   htp.br;  
   modGUI1.LABEL('Nome Museo');
   modGUI1.SelectOpen('newMuseo',newMuseo);
   FOR Mus_cur IN cur LOOP
      modGUI1.SelectOption(Mus_cur.NOME,Mus_cur.NOME);
   END LOOP;
   modGUI1.SelectClose;
   htp.br;  
   modGUI1.LABEL('Data Inizio');
   modGUI1.InputDate('newDatainizio','newDatainizio',0,newDatainizio);
   htp.br;
   modGUI1.LABEL('DataConclusione');
   modGUI1.InputDate('newDataConclusione','newDataConclusione',0,newDataConclusione);
   htp.br;
   htp.br;
   modGUI1.INPUTSUBMIT('Invia');
   modGUI1.ChiudiForm;
   modGUI1.ChiudiDiv;
   htp.bodyClose; 
   htp.htmlClose;
END inseriscicampiestivi;

procedure confermacampiestivi
(
   newNome in CAMPIESTIVI.Nome%TYPE default null,
   newMuseo in Musei.Nome%TYPE,
   newDatainizio in VARCHAR2 default null,
   newDataConclusione in VARCHAR2 default null
)
is
   newidMuseo CAMPIESTIVI.MUSEO%TYPE;
   v_dateini Date:= TO_DATE(newDatainizio default NULL on conversion error, 'YYYY-MM-DD');
   v_datefin Date:= TO_DATE(newDataConclusione default NULL on conversion error, 'YYYY-MM-DD');
BEGIN
   htp.htmlOpen;
   modGUI1.APRIPAGINA('Conferma Campi Estivi');
   modGUI1.HEADER();
   htp.bodyopen();
   htp.br;htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 align="center">Conferma dati</h1>');
   modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
   if v_dateini>v_datefin 
   then 
      modGUI1.LABEL('Parametri inseriti in maniera errata');
      modGUI1.ApriForm(operazioniGruppo4.gr4||'inseriscicampiestivi');
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newMuseo',  newMuseo);
      HTP.FORMHIDDEN('newDatainizio',newDatainizio);
      HTP.FORMHIDDEN('newDataConclusione',newDataConclusione);
      modGUI1.InputSubmit('indietro');
      modGUI1.ChiudiForm;
   else
      htp.tableopen(CALIGN =>'CENTER');
      htp.tablerowopen;
      htp.tabledata('Nome: ',CATTRIBUTES  =>'style="font-weight:bold"');
      htp.tabledata(newNome);
      htp.tablerowclose;
      htp.tablerowopen;
      htp.tabledata('Stato: ',CATTRIBUTES  =>'style="font-weight:bold"');
      htp.tabledata('increazione');
      htp.tablerowclose;
      htp.tablerowopen;
      htp.tabledata('Data inizio: ',CATTRIBUTES  =>'style="font-weight:bold"');
      htp.tabledata(newDatainizio);
      htp.tablerowclose;
      htp.tablerowopen;
      htp.tabledata('Data Conclusione: ',CATTRIBUTES  =>'style="font-weight:bold"');
      htp.tabledata(newDataConclusione);
      htp.tablerowclose;
      htp.tablerowopen;
      htp.tabledata('Museo: ',CATTRIBUTES  =>'style="font-weight:bold"');
      htp.tabledata(newMuseo);
      htp.tablerowclose;
      htp.tableclose;
      modGUI1.ApriForm(operazioniGruppo4.gr4||'controllacampiestivi');
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newMuseo',  newMuseo);
      HTP.FORMHIDDEN('newDatainizio',newDatainizio);
      HTP.FORMHIDDEN('newDataConclusione',newDataConclusione);
      modGUI1.InputSubmit('Conferma');
      modGUI1.ChiudiForm;
      modGUI1.ApriForm(operazioniGruppo4.gr4||'inseriscicampiestivi');
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newMuseo',  newMuseo);
      HTP.FORMHIDDEN('newDatainizio',newDatainizio);
      HTP.FORMHIDDEN('newDataConclusione',newDataConclusione);
      modGUI1.InputSubmit('Annulla');
      modGUI1.ChiudiForm;
      modGUI1.ChiudiDiv;
     
   end if;
   htp.br;
   htp.bodyclose();
   htp.htmlClose();
END confermacampiestivi;

/*Funzione che  inserisce all'interno della tabella campi estivi*/
procedure controllacampiestivi
(
   newNome in CAMPIESTIVI.Nome%TYPE default null,
   newMuseo in Musei.Nome%TYPE,
   newDatainizio in VARCHAR2 default null,
   newDataConclusione in VARCHAR2 default null
)
is
   newidMuseo CAMPIESTIVI.MUSEO%TYPE default null;
   newStato VARCHAR2(50) :='increazione';
   v_dateini Date:= TO_DATE(newDatainizio default NULL on conversion error, 'YYYY-MM-DD');
   v_datefin Date:= TO_DATE(newDataConclusione default NULL on conversion error, 'YYYY-MM-DD');
BEGIN
   select IDMUSEO
   into newidMuseo
   from MUSEI
   where Musei.NOME=newMuseo;
   htp.htmlOpen;
   modGUI1.APRIPAGINA('Campi Estivi');
   modGUI1.HEADER();
   htp.bodyopen();
   htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
   insert into CAMPIESTIVI VALUES (IDCAMPIESTIVISEQ.NEXTVAL,newStato,newNome,v_dateini,v_datefin,newidMuseo,0);
   modGUI1.RedirectEsito('Inserimento completato',newNome,'Inserisci un nuovo campo estivo',operazioniGruppo4.gr4||'inseriscicampiestivi?','//newNome='||newNome||'//newMuseo='||newMuseo||'//newDatainizio='||newDataInizio||'//newDataConclusione='||newDataConclusione,'Torna al menu',operazioniGruppo4.gr4||operazioniGruppo4.menu_ce,null);
   htp.bodyclose();
   htp.htmlClose();
END controllacampiestivi;

procedure visualizzacampiestivi
(
   campiestiviId IN  CAMPIESTIVI.IdCampiEstivi%TYPE
)
is
campo CAMPIESTIVI%rowtype;
BEGIN 
   select *
   into campo
   from CAMPIESTIVI
   where  campiestiviId=CAMPIESTIVI.IdCampiEstivi;

   modGUI1.apripagina();
   modGUI1.header();
   htp.br;htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 align="center">Campo Estivo</h1>');
   modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
   modGUI1.Collegamento('M',operazioniGruppo4.gr4||operazioniGruppo4.menu_ce,'w3-btn  w3-black w3-display-topright ');
   htp.tableopen(CALIGN =>'CENTER',CATTRIBUTES =>'class="w3-table"');
        htp.tablerowopen;
        htp.tabledata('Nome: ',CATTRIBUTES  =>'style="font-weight:bold"');
        htp.tabledata(campo.Nome);
        htp.tablerowclose;
        htp.tablerowopen;
        htp.tabledata('Stato: ',CATTRIBUTES  =>'style="font-weight:bold"');
        htp.tabledata(campo.stato);
        htp.tablerowclose;
        htp.tablerowopen;
        htp.tabledata('Data inizio: ',CATTRIBUTES  =>'style="font-weight:bold"');
        htp.tabledata(campo.DataInizio);
        htp.tablerowclose;
        htp.tablerowopen;
        htp.tabledata('Data Conclusione: ',CATTRIBUTES  =>'style="font-weight:bold"');
        htp.tabledata(campo.DataConclusione);
        htp.tablerowclose;
        htp.tablerowopen;
        htp.tabledata('Museo: ',CATTRIBUTES  =>'style="font-weight:bold"');
        htp.tabledata(campo.Museo);
        htp.tablerowclose;
   htp.tableclose;
   htp.br;htp.br;htp.br;
   modGUI1.ApriForm(operazioniGruppo4.gr4||'controllastatisticacampo','invia','w3-container');
   htp.FORMHIDDEN('campoestivoId',campiestiviId);
   modGUI1.label('Operazione');
   htp.br;
   modGUI1.SelectOpen('Scelta');
      modGUI1.SelectOption(1,'utenti iscritti');
      modGUI1.SelectOption(2,'tariffe campi');
      modGUI1.SelectOption(3,'età media utenti');
      modGUI1.SelectOption(4,'introiti campo');
   modGUI1.SelectClose;
   modGUI1.INPUTSUBMIT('invia');
   modGUI1.chiudiform;
   modGUI1.ChiudiDiv();

END visualizzacampiestivi;

procedure modificacampiestivi
(
   idcampo in CAMPIESTIVI.IDCAMPIESTIVI%TYPE default null,
   newNome in CAMPIESTIVI.Nome%TYPE default null,
   newDatainizio in VARCHAR2 default null,
   newDataConclusione in VARCHAR2 default null
)
is
BEGIN 
   htp.htmlOpen;
   modGUI1.ApriPagina('Modifica Campo');
   modGUI1.Header();
   htp.bodyOpen;
   htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;  
   htp.prn('<h1 align="center">Modifica Campi Estivi</h1>');
   modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
   modGUI1.Collegamento('M',operazioniGruppo4.gr4||operazioniGruppo4.menu_ce,'w3-btn  w3-black w3-display-topright ');
   modGUI1.ApriForm(operazioniGruppo4.gr4||'confermamodificacampo','invia','w3-container');
   htp.FORMHIDDEN('idcampo',idcampo);
   modGUI1.LABEL('Nome');
   modGUI1.INPUTTEXT('newNome','Nome',1,newNome);
   htp.br;  
   modGUI1.LABEL('Data Inizio');
   modGUI1.InputDate('newDatainizio','newDatainizio',1,newDatainizio);
   htp.br;
   modGUI1.LABEL('DataConclusione');
   modGUI1.InputDate('newDataConclusione','newDataConclusione',0,newDataConclusione);
   htp.br;
   htp.br;
   modGUI1.INPUTSUBMIT('modifica');
   modGUI1.ChiudiForm;
   modGUI1.ChiudiDiv;
   htp.bodyClose; 
   htp.htmlClose;

end;

procedure confermamodificacampo
(
   idcampo in CAMPIESTIVI.IDCAMPIESTIVI%TYPE default null,
   newNome in CAMPIESTIVI.Nome%TYPE default null,
   newDatainizio in VARCHAR2 default null,
   newDataConclusione in VARCHAR2 default null
)
is
   v_dateini Date:= TO_DATE(newDatainizio default NULL on conversion error, 'YYYY-MM-DD');
   v_datefin Date:= TO_DATE(newDataConclusione default NULL on conversion error, 'YYYY-MM-DD');
BEGIN

   htp.htmlOpen;
   modGUI1.APRIPAGINA('Conferma Campi Estivi');
   modGUI1.HEADER();
   htp.bodyopen();
   htp.br;htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 align="center">Modifica Campo Estivo</h1>');
   modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
   
   if (v_dateini>v_datefin) 
      then modGUI1.LABEL('Parametri inseriti in maniera errata');
      modGUI1.ApriForm(operazioniGruppo4.gr4||'modificacampiestivi');
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newDatainizio',newDatainizio);
      HTP.FORMHIDDEN('newDataConclusione',newDataConclusione);
      modGUI1.InputSubmit('indietro');
      modGUI1.ChiudiForm;
   else
      htp.tableopen(CALIGN =>'CENTER',CATTRIBUTES =>'class="w3-table"');
        htp.tablerowopen;
        htp.tabledata('Nome: ',CATTRIBUTES  =>'style="font-weight:bold"');
        htp.tabledata(newNome);
        htp.tablerowclose;
        htp.tablerowopen;
        htp.tabledata('Data inizio: ',CATTRIBUTES  =>'style="font-weight:bold"');
        htp.tabledata(newDatainizio);
        htp.tablerowclose;
        htp.tablerowopen;
        htp.tabledata('Data Conclusione: ',CATTRIBUTES  =>'style="font-weight:bold"');
        htp.tabledata(newDataConclusione);
        htp.tablerowclose;
      htp.tableclose;
      modGUI1.ApriForm(operazioniGruppo4.gr4||'updatecampi');
      HTP.FORMHIDDEN('idcampo',idcampo);
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newDatainizio',newDatainizio);
      HTP.FORMHIDDEN('newDataConclusione',newDataConclusione);
      modGUI1.InputSubmit('Conferma');
      modGUI1.ChiudiForm;
      modGUI1.ApriForm(operazioniGruppo4.gr4||'modificacampiestivi');
      HTP.FORMHIDDEN('idcampo',idcampo);
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newDatainizio',newDatainizio);
      HTP.FORMHIDDEN('newDataConclusione',newDataConclusione);
      modGUI1.InputSubmit('Annulla');
      modGUI1.ChiudiForm;
      modGUI1.ChiudiDiv;
     
   end if;
   htp.br;

   htp.bodyclose();
   htp.htmlClose();
end;

procedure updatecampi
(
   idcampo in CAMPIESTIVI.IDCAMPIESTIVI%TYPE default null,
   newNome in CAMPIESTIVI.Nome%TYPE default null,
   newDatainizio in VARCHAR2 default null,
   newDataConclusione in VARCHAR2 default null
)
is
v_dateini Date:= TO_DATE(newDatainizio default NULL on conversion error, 'YYYY-MM-DD');
v_datefin Date:= TO_DATE(newDataConclusione default NULL on conversion error, 'YYYY-MM-DD');
BEGIN
   modGUI1.ApriPagina('Update campo');
   modGUI1.HEADER();
   htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
   UPDATE CAMPIESTIVI SET
      Nome=newNome,
      DataInizio=v_dateini,
      DataConclusione=v_datefin
   WHERE idcampo=idcampiestivi;
   modGUI1.RedirectEsito('Modifica riuscita','Campo Estivo modificato correttamente',null,null,null,'Menu Campi Estivi',operazioniGruppo4.gr4||operazioniGruppo4.menu_ce,null);

end updatecampi;


procedure eliminacampo
(
   idcampo in CAMPIESTIVI.IDCAMPIESTIVI%TYPE 
)
is 
var1 VARCHAR2(100);
idSessione NUMBER(5) :=  modGUI1.get_id_sessione();
BEGIN
    modGUI1.ApriDiv('id="Elimcampo'||idcampo||'" class="w3-modal"');
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
            modGUI1.ApriDiv('class="w3-center"');
               htp.br;
               htp.prn('<span onclick="document.getElementById(''Elimcampo'||idcampo||''').style.display=''none''" class="w3-button w3-xlarge w3-red w3-display-topright" title="Close Modal">X</span>');
               htp.print('<h1><b>Confermi?</b></h1>');
            modGUI1.ChiudiDiv;
                    modGUI1.ApriDiv('class="w3-section"');
                        htp.br;
                        SELECT Nome INTO var1 FROM CAMPIESTIVI WHERE IDCAMPIESTIVI=idcampo;
                        htp.prn('stai per rimuovere: '||var1);
                        modGUI1.Collegamento('Conferma',
                        Operazionigruppo4.gr4||'rimuovicampo?idcampo='||idcampo,
                        'w3-button w3-block w3-green w3-section w3-padding');
                        htp.prn('<span onclick="document.getElementById(''Elimcampo'||idcampo||''').style.display=''none''" class="w3-button w3-block w3-red w3-section w3-padding" title="Close Modal">Annulla</span>');
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiForm;
        modGUI1.ChiudiDiv;
    modGUI1.ChiudiDiv;
end;


procedure rimuovicampo
(
   idcampo in CAMPIESTIVI.IDCAMPIESTIVI%TYPE 
)
IS
BEGIN
update campiestivi set
   ELIMINATO=1
where IDCAMPIESTIVI=idcampo;
modGUI1.RedirectEsito('Eliminazione riuscita','Campo Estivo eliminato correttamente',null,null,null,'Torna al menu dei campiestivi',operazioniGruppo4.gr4||operazioniGruppo4.menu_ce,null);

END;


/*--------------------------------------------------------------MUSEI-----------------------------------------*/

procedure menumusei
is
   sessionid NUMBER(10):=modGUI1.get_id_sessione();
BEGIN
   htp.prn('<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> ');
   modGUI1.ApriPagina('Musei');
   modGUI1.Header();
   htp.br;htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 Align="center" style="font-size:50px">Musei</h1>');
   if hasRole(sessionid,'DBA')
   then
      modGUI1.APRIDIV('class="w3-col l4 w3-padding-large w3-left"');
      modGUI1.APRIDIV('class="w3-center"');
      modGUI1.Collegamento('inserisci',operazioniGruppo4.gr4||'inseriscimuseo?newNome=&newIndirizzo=','w3-black w3-round w3-margin w3-button');
      modGUI1.ChiudiDiv();
      modGUI1.ChiudiDiv();
   end if;
   if hasRole(sessionid,'DBA') or hasRole(sessionid,'GM')
   then
      modGUI1.APRIDIV('class="w3-col l4 w3-padding-large w3-right"');
      modGUI1.APRIDIV('class="w3-center"');
      modGUI1.Collegamento('Statistiche',operazioniGruppo4.gr4||'form1monitoraggio?MuseoId=&NameMuseo=','w3-black w3-round w3-margin w3-button');
      modGUI1.Collegamento('Visitatori',operazioniGruppo4.gr4||'form2monitoraggio?MuseoId=&NameMuseo=&Data1=&Data2=','w3-black w3-round w3-margin w3-button');
      modGUI1.ChiudiDiv();
      modGUI1.ChiudiDiv();
   end if;
   modGUI1.ApriDiv('class="w3-row w3-container"');
   FOR museo IN (Select IdMuseo,Nome,Indirizzo from MUSEI)
   LOOP
      modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
         modGUI1.ApriDiv('class="w3-card-4" style="height:600px;"');
            htp.prn('<img src="https://a.travel-assets.com/findyours-php/viewfinder/images/res70/227000/227553-Kunsthalle-Bremen.jpg" alt="Alps" style="width:100%;">');
            modGUI1.ApriDiv('class="w3-container w3-center"');
            htp.prn('<p style="text-align:center; font-size:25px">'||museo.nome||'</p>');
            htp.br;
            htp.prn('<p style="text-align:center"><b>Indirizzo</b></p>');
            htp.prn('<p style="text-align:center">'||museo.Indirizzo||'</p>');
            modGUI1.ChiudiDiv; 
            if hasRole(sessionid,'DBA') or hasRole(sessionid,'GM')
            then     
               modGUI1.Collegamento('Visualizza',operazioniGruppo4.gr4||'visualizzaMusei?museoId='||museo.IdMuseo,'w3-green w3-margin w3-button');
               modGUI1.Collegamento('Modifica',operazioniGruppo4.gr4||'modificamusei?museoId='||museo.IdMuseo||'&newNome='||museo.Nome||'&newIndirizzo='||museo.Indirizzo,'w3-red w3-margin w3-button');
            end if;
         modGUI1.ChiudiDiv;
      modGUI1.ChiudiDiv;
   END LOOP;
   modGUI1.chiudiDiv;
end;
   /*funzione che inserisce un museo-*/
procedure inseriscimuseo
( 
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
)
is
BEGIN
   htp.htmlOpen;
   modGUI1.APRIPAGINA('Inserisci Museo');
   modGUI1.HEADER();
   htp.bodyOpen;
   htp.br;htp.br;htp.br; htp.br;htp.br;htp.br;  
   htp.prn('<h1 align="center">Inserimento Musei</h1>');
   modGUI1.APRIDIV('class="w3-modal-content w3-card-4" style="max-width:600px"');
   modGUI1.ApriForm(operazioniGruppo4.gr4||'confermamusei','invia','w3-container');
   modGUI1.Collegamento('M',operazioniGruppo4.gr4||'menumusei?','w3-btn  w3-black w3-display-topright' );
   modGUI1.LABEL('Nome museo');
   modGUI1.INPUTTEXT('newNome','Nome',1,newNome);
   htp.br;
   modGUI1.LABEL('Indirizzo museo');
   modGUI1.INPUTTEXT('newIndirizzo','Indirizzo',1,newIndirizzo);
   htp.br;
   modGUI1.INPUTSUBMIT('Invia');
   modGUI1.ChiudiForm;
   modGUI1.ChiudiDiv;
   htp.bodyClose; 
   htp.htmlClose;
END inseriscimuseo;
/*conferma dell'inserimento dei musei*/
procedure confermamusei
(
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
)
is
BEGIN
   htp.htmlOpen;
   modGUI1.APRIPAGINA('Conferma Musei');
   modGUI1.HEADER();
   htp.bodyopen();
   htp.br;htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 align="center">Conferma dati</h1>');
   modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
   if (newNome is null) or (newIndirizzo is null)
   then 
      modGUI1.LABEL('Parametri inseriti in maniera errata');
      modGUI1.ApriForm(operazioniGruppo4.gr4||'inseriscimuseo');
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newIndirizzo',  newIndirizzo);
      modGUI1.InputSubmit('indietro');
   else
      HTP.TableOpen(CALIGN =>'CENTER',CATTRIBUTES =>'class="w3-table"');
         HTP.TableRowOpen;
         HTP.TableData('Nome: ',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
         HTP.TableData(newNome,CATTRIBUTES  =>'style="text-align:center"');
         HTP.TableRowClose;
         HTP.TableRowOpen;
         HTP.TableData('Indirizzo: ',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
         HTP.TableData(newIndirizzo,CATTRIBUTES  =>'style="text-align:center"');
         HTP.TableRowClose;
      HTP.TableClose;
      htp.br;
      modGUI1.ApriForm(operazioniGruppo4.gr4||'controllamusei');
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newIndirizzo',  newIndirizzo);
      modGUI1.InputSubmit('Conferma');
      modGUI1.ChiudiForm;
      modGUI1.ApriForm(operazioniGruppo4.gr4||'inseriscimuseo');
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newIndirizzo',  newIndirizzo);
      modGUI1.InputSubmit('Annulla');
      modGUI1.ChiudiForm;
   modGUI1.ChiudiDiv;
      
   end if;
   htp.bodyclose();
   htp.htmlClose();
end confermamusei;
/*inserimento dei musei nella bse di dati*/
procedure controllamusei
(
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
)
is

BEGIN
   htp.htmlOpen;
   modGUI1.APRIPAGINA('Controlla Museo');
   modGUI1.HEADER();
   htp.bodyOpen;
   htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
   modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
   insert into Musei VALUES (IdMuseoseq.NEXTVAL,newNome,newIndirizzo,0);
   if sql%found
   then 
      commit;
      modGUI1.RedirectEsito('Inserimento completato', null,'Inserisci un nuovo museo',operazioniGruppo4.gr4||'inseriscimuseo?','//newNome='||newNome||'//newIndirizzo='||newIndirizzo,'Torna al menu musei',operazioniGruppo4.gr4||operazioniGruppo4.menu_m,null);
   end if;    
   exception when others then
      modGUI1.RedirectEsito('Inserimento fallito', null,'Inserisci un nuovo museo',operazioniGruppo4.gr4||'inseriscimuseo?','//newNome='||newNome||'//newIndirizzo='||newIndirizzo,'Torna al menu musei',operazioniGruppo4.gr4||operazioniGruppo4.menu_m,null);
   
   htp.bodyClose;
   htp.htmlClose;
END controllamusei;

procedure visualizzamusei
(
   MuseoId IN MUSEI.IdMuseo%TYPE
)
is
museo MUSEI%rowtype;
BEGIN 
   select *
   into museo
   from MUSEI
   where  MuseoId=MUSEI.IDMUSEO;

   modGUI1.apripagina('Visualizza museo');
   modGUI1.header();
   htp.br;htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 align="center">Museo</h1>');
   modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
   modGUI1.Collegamento('M',operazioniGruppo4.gr4||'menumusei?','w3-btn  w3-black w3-display-topright' );
   htp.tableopen(CALIGN =>'CENTER',CATTRIBUTES =>'class="w3-table"');
        htp.tablerowopen;
        htp.tabledata('Nome: ',CATTRIBUTES  =>'style="font-weight:bold"');
        htp.tabledata(museo.Nome);
        htp.tablerowclose;
        htp.tablerowopen;
        htp.tabledata('Indirizzo: ',CATTRIBUTES  =>'style="font-weight:bold"');
        htp.tabledata(museo.Indirizzo);
        htp.tablerowclose;
   htp.TableClose;
   htp.br;htp.br;htp.br;
   modGUI1.ApriForm(operazioniGruppo4.gr4||'controllastatistica','invia','w3-container'); 
   htp.FORMHIDDEN('MuseoId',MuseoId);
   modGUI1.label('Operazione');
   htp.br;
   modGUI1.SelectOpen('Scelta');
      modGUI1.SelectOption(2,'opere presenti');
      modGUI1.SelectOption(3,'opere prestate');
      modGUI1.SelectOption(1,'sale presenti');
      modGUI1.SelectOption(4,'introti museo');
   modGUI1.SelectClose;
   modGUI1.INPUTSUBMIT('invia');
   modGUI1.chiudiform;
   modGUI1.ChiudiDiv();

END visualizzamusei;

procedure modificamusei
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
)
is 
BEGIN
   htp.htmlOpen;
   modGUI1.APRIPAGINA('Modifica Museo');
   modGUI1.HEADER();
   htp.bodyOpen;
   htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;  
   htp.prn('<h1 align="center">Modifica Musei</h1>');
   modGUI1.APRIDIV('class="w3-modal-content w3-card-4" style="max-width:600px"');
   modGUI1.ApriForm(operazioniGruppo4.gr4||'confermamodificamuseo','invia','w3-container');
   modGUI1.Collegamento('M',operazioniGruppo4.gr4||operazioniGruppo4.menu_m,'w3-btn  w3-black w3-display-topright ');
   HTP.FORMHIDDEN('MuseoId', MuseoId);
   modGUI1.LABEL('Nome museo');
   modGUI1.INPUTTEXT('newNome','Nome',1,newNome);
   htp.br;
   modGUI1.LABEL('Indirizzo museo');
   modGUI1.INPUTTEXT('newIndirizzo','Indirizzo',1,newIndirizzo);
   htp.br;
   modGUI1.INPUTSUBMIT('Invia');
   modGUI1.ChiudiForm;
   modGUI1.ChiudiDiv;
   htp.bodyClose; 
   htp.htmlClose;
end modificamusei;

procedure confermamodificamuseo
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
)
is
BEGIN 
   modGUI1.APRIPAGINA('Modifica Museo');
   modGUI1.HEADER();
   htp.br;htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 align="center">Conferma Modifica</h1>');
   modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
   if (newNome is null) or (newIndirizzo is null)
   then 
      modGUI1.LABEL('Parametri inseriti in maniera errata');
      modGUI1.ApriForm(operazioniGruppo4.gr4||'modificamusei');
      HTP.FORMHIDDEN('MuseoId', MuseoId);
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newIndirizzo',  newIndirizzo);
      modGUI1.InputSubmit('indietro');
   else
      HTP.TableOpen(CALIGN=>'CENTER',CATTRIBUTES =>'class="w3-table"');
      HTP.TableRowOpen;
      HTP.TableData('Nome: ',CATTRIBUTES  =>'style="font-weight:bold;text-align:center"');
      HTP.TableData(newNome,CATTRIBUTES  =>'style="text-align:center"');
      HTP.TableRowClose;
      HTP.TableRowOpen;
      HTP.TableData('Indirizzo: ',CATTRIBUTES  =>'style="font-weight:bold;text-align:center"');
      HTP.TableData(newIndirizzo,CATTRIBUTES  =>'style="text-align:center"');
      HTP.TableRowClose;
      HTP.TableClose;
      htp.br;
      modGUI1.ApriForm(operazioniGruppo4.gr4||'updatemusei');
      HTP.FORMHIDDEN('MuseoId', MuseoId);
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newIndirizzo',  newIndirizzo);
      modGUI1.InputSubmit('Conferma');
      modGUI1.ChiudiForm;
      modGUI1.ApriForm(operazioniGruppo4.gr4||'modificamusei');
      HTP.FORMHIDDEN('MuseoId', MuseoId);
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newIndirizzo',  newIndirizzo);
      modGUI1.InputSubmit('Annulla');
      modGUI1.ChiudiForm;
      modGUI1.ChiudiDiv;
   end if;
end confermamodificamuseo;

procedure updatemusei
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
)
is

BEGIN
   modGUI1.ApriPagina(' Update museo');
   modGUI1.HEADER();
   htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
   UPDATE MUSEI SET
      Nome=newNome,
      Indirizzo=newIndirizzo
   WHERE IdMuseo=MuseoId;
   modGUI1.RedirectEsito('Modifica riuscita','Museo modificato correttamente',null,null,null,'Torna al menu musei',operazioniGruppo4.gr4||operazioniGruppo4.menu_m,null);
end updatemusei;
/*----------statistiche musei----*/
procedure form1monitoraggio
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   NameMuseo IN MUSEI.NOME%TYPE
)
is
CURSOR cur IS Select MUSEI.IDMUSEO, MUSEI.NOME
                        FROM MUSEI;
MusId_cur cur%Rowtype; 
BEGIN
   htp.htmlOpen;
   modGUI1.ApriPagina('Statistiche museo');
   modGUI1.HEADER();
   htp.BODYOPEN();
   htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 align="center">Scegli museo</h1>');
   modGUI1.apridiv('class="w3-modal-content w3-card-4" style="max-width:600px; margin-top:110px"');
   modGUI1.Collegamento('M',operazioniGruppo4.gr4||'menumusei','w3-btn  w3-black w3-display-topright ');
   modGUI1.ApriForm(operazioniGruppo4.gr4||'controllastatistica','invia','w3-container'); 
   modGUI1.LABEL('Nome del museo');
   modGUI1.SelectOpen('MuseoId',NameMuseo);
   FOR MusId_cur IN cur LOOP
      modGUI1.SelectOption(MusId_cur.IdMuseo,MusId_cur.NOME);
   END LOOP;
   modGUI1.SelectClose;
   htp.br;htp.br;
   modGUI1.LABEL('Operazione');
   htp.br;
   modGUI1.INPUTRADIOBUTTON('sale presenti','scelta',1,checked=>1);
   htp.br;
   modGUI1.INPUTRADIOBUTTON('opere presenti','scelta',2);
   htp.br;
   modGUI1.INPUTRADIOBUTTON('opere prestate','scelta',3);
   htp.br;
   modGUI1.INPUTRADIOBUTTON('introiti museo','scelta',4);
   htp.br;htp.br;htp.br;
   modGUI1.INPUTSUBMIT('invia');
   modGUI1.ChiudiForm;
   modGUI1.ChiudiDiv();
   htp.htmlClose;
END form1monitoraggio;

procedure form2monitoraggio
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   NameMuseo IN MUSEI.NOME%TYPE,
   Data1 VARCHAR2,
   Data2 VARCHAR2
)
is

   CURSOR cur IS Select MUSEI.IDMUSEO, MUSEI.NOME
                           FROM MUSEI;
   MusId_cur cur%Rowtype; 
BEGIN
   htp.htmlOpen;
   modGUI1.ApriPagina('Statistiche sale museo');
   modGUI1.HEADER();
   htp.BODYOPEN();
   htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 align="center">Scegli museo</h1>');
   modGUI1.apridiv('class="w3-modal-content w3-card-4" style="max-width:600px; margin-top:110px"');
   modGUI1.Collegamento('M',operazioniGruppo4.gr4||'menumusei','w3-btn  w3-black w3-display-topright ');
   modGUI1.ApriForm(operazioniGruppo4.gr4||'controllastatistica2','invia','w3-container'); 
   modGUI1.LABEL('Nome del museo');
   modGUI1.SelectOpen('MuseoId',NameMuseo);
   FOR MusId_cur IN cur LOOP
      modGUI1.SelectOption(MusId_cur.IdMuseo,MusId_cur.NOME);
   END LOOP;
   modGUI1.SelectClose;
   htp.br;htp.br;
   modGUI1.LABEL('Operazione');
   htp.br;
   modGUI1.INPUTRADIOBUTTON('visitatori unici','scelta',5,checked=>1);
   htp.br;
   modGUI1.INPUTRADIOBUTTON('visitatori medi','scelta',6);
   htp.br;
   modGUI1.InputDate('Data1','Data1',1,Data1);
   htp.br;
   modGUI1.InputDate('Data2','Data2',1,Data2);
   htp.br;htp.br;
   modGUI1.INPUTSUBMIT('invia');
   modGUI1.ChiudiForm;
   modGUI1.ChiudiDiv();
   htp.htmlClose;
end form2monitoraggio;
/*-----------------------------------------*/
procedure salepresenti
(
   MuseoId IN  Musei.IdMuseo%TYPE
)
is 
   CURSOR sal_cursor IS
   Select STANZE.IdStanza,STANZE.Nome,STANZE.Dimensione,SALE.NUMOPERE,SALE.TIPOSALA
   FROM STANZE,SALE
   WHERE STANZE.MUSEO=MuseoId AND STANZE.IdStanza=SALE.IdStanza;
   val_sal sal_cursor%Rowtype;
BEGIN
/*controllo sull'ID*/
   modGUI1.ApriPagina('Visualizzazione sale museo');
   modGUI1.HEADER();
   htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 align="center">Sale Museo</h1>');
   modGUI1.APRIDIV('class="w3-center"');
   modGUI1.Collegamento('menù',operazioniGruppo4.gr4||operazioniGruppo4.menu_m,'w3-btn w3-round-xxlarge w3-black ');
   htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
   modGUI1.Collegamento('statistiche',operazioniGruppo4.gr4||'form1monitoraggio?&MuseoId='||MuseoId||'&NameMuseo=','w3-btn w3-round-xxlarge w3-black ');
   modGUI1.ChiudiDiv;
   modGUI1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px; margin-top:110px"');
   HTP.TABLEOPEN(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"' );
      HTP.TableRowOpen;
      HTP.TableData('Nome Stanza',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      HTP.TableData('Dimensione Stanza',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      HTP.TableData('Numero Opere Stanza',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      HTP.TableData('Tipo Stanza',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      HTP.TableData('info',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      /* inserire il tipo stanza*/
      HTP.TableRowClose;
      FOR val_sal in sal_cursor
      loop
         HTP.TableRowOpen;
         HTP.TableData(val_sal.Nome,CATTRIBUTES  =>'style="text-align:center"');
         HTP.TableData(val_sal.Dimensione ,CATTRIBUTES  =>'style="text-align:center"');
         HTP.TableData(val_sal.NUMOPERE,CATTRIBUTES  =>'style="text-align:center"'); 
         if val_sal.TipoSala=1
            then HTP.TableData('mostra temporanea' ,CATTRIBUTES  =>'style="text-align:center"');
         else 
            HTP.TableData('museale' ,CATTRIBUTES  =>'style="text-align:center"');
         end if;
         HTP.TableData('<a href="'|| Costanti.server || Costanti.radice || operazioniGruppo4.packstanze ||'visualizzaSala?'||'varIdSala='||val_sal.IdStanza||'"'||'class="w3-black w3-round w3-margin w3-button"'||'>'||'Dettagli'||'</a>');
         HTP.TableRowClose;
      end loop;
   HTP.TableClose;
   modGUI1.ChiudiDiv();
   htp.br;htp.br;
   modGUI1.APRIDIV('class="w3-center"');
   htp.br;htp.br;
   modGUI1.Collegamento('menù',operazioniGruppo4.gr4||operazioniGruppo4.menu_m,'w3-btn w3-round-xxlarge w3-black ');
   htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
   modGUI1.Collegamento('statistiche',operazioniGruppo4.gr4||'form1monitoraggio?&MuseoId='||MuseoId||'&NameMuseo=','w3-btn w3-round-xxlarge w3-black ');
   modGUI1.ChiudiDiv;
   htp.bodyClose;
END salepresenti;
/*OPERE PRESENTI NEL MUSEO*/
procedure operepresentimuseo
(
   MuseoId IN  Musei.IdMuseo%TYPE
)

IS
  CURSOR oper_cursor IS
  Select DISTINCT Opere.idopera,Opere.Titolo,Opere.Anno,Opere.FinePeriodo
  FROM OPERE,STANZE,SALEOPERE
  WHERE STANZE.MUSEO=MuseoId AND STANZE.IdStanza=SALEOPERE.Sala AND  OPERE.IdOpera=SALEOPERE.Opera AND SALEOPERE.DataUscita IS NULL;
  val_ope oper_cursor%Rowtype;

BEGIN
   modGUI1.ApriPagina('Visualizzazione opere museo');
   modGUI1.HEADER();
   htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 align="center">Opere Museo</h1>');
   modGUI1.APRIDIV('class="w3-center"');
   modGUI1.Collegamento('menù',operazioniGruppo4.gr4||operazioniGruppo4.menu_m,'w3-btn w3-round-xxlarge w3-black ');
   htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
   modGUI1.Collegamento('statistiche',operazioniGruppo4.gr4||'form1monitoraggio?&MuseoId='||MuseoId||'&NameMuseo=','w3-btn w3-round-xxlarge w3-black ');
   modGUI1.ChiudiDiv;
   modGUI1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px; margin-top:110px"');
   HTP.TABLEOPEN(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"' );
         HTP.TableRowOpen;
         HTP.TableData('Titolo opera',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
         HTP.TableData('Anno opera',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
         HTP.TableData('Periodo opera',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
         HTP.TableData('info',CATTRIBUTES  =>'style="font-weight:bold"');
         /* inserire il tipo stanza*/
         HTP.TableRowClose;
   FOR val_ope in oper_cursor
   loop
      HTP.TableRowOpen;
      HTP.TableData(val_ope.Titolo,CATTRIBUTES  =>'style="text-align:center"');
      HTP.TableData(val_ope.Anno ,CATTRIBUTES  =>'style="text-align:center"');
      HTP.TableData(val_ope.FinePeriodo,CATTRIBUTES  =>'style="text-align:center"');
      htp.tabledata('<button onclick="document.getElementById(''LinguaeLivelloOpera'||val_ope.IdOpera||''').style.display=''block''" class="w3-margin w3-button w3-black w3-hover-white">Dettagli</button>');
      gruppo2.linguaELivello(val_ope.IdOpera);
      HTP.TableRowClose;
   end loop; 
   htp.tableclose;
   modGUI1.ChiudiDiv();
   htp.br;htp.br;
   modGUI1.APRIDIV('class="w3-center"');
   modGUI1.Collegamento('menù',operazioniGruppo4.gr4||operazioniGruppo4.menu_m,'w3-btn w3-round-xxlarge w3-black ');
   htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
   modGUI1.Collegamento('statistiche',operazioniGruppo4.gr4||'form1monitoraggio?&MuseoId='||MuseoId||'&NameMuseo=','w3-btn w3-round-xxlarge w3-black ');
   modGUI1.ChiudiDiv;
   htp.bodyClose;
END operepresentimuseo;

procedure opereprestate
(
   MuseoId IN MUSEI.IdMuseo%TYPE
)

is 
   CURSOR oper_cursor IS
   Select  DISTINCT IdOpera,Opere.Titolo,Opere.Anno,Opere.FinePeriodo
   FROM STANZE,OPERE,SALEOPERE
   WHERE  STANZE.MUSEO=MuseoId AND STANZE.IdStanza=SALEOPERE.Sala AND  OPERE.IdOpera=SALEOPERE.Opera AND OPERE.Museo<>MuseoId  AND SALEOPERE.DataUscita IS NULL;
   val_ope oper_cursor%Rowtype;

BEGIN
/*controllo sull'ID*/
   modGUI1.ApriPagina('Visualizzazione opere prestate museo');
   modGUI1.HEADER();
   htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 align="center">Opere Museo</h1>');
   modGUI1.APRIDIV('class="w3-center"');
   modGUI1.Collegamento('menù',operazioniGruppo4.gr4||operazioniGruppo4.menu_m,'w3-btn w3-round-xxlarge w3-black ');
   htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
   modGUI1.Collegamento('statistiche',operazioniGruppo4.gr4||'form1monitoraggio?&MuseoId='||MuseoId||'&NameMuseo=','w3-btn w3-round-xxlarge w3-black ');
   modGUI1.ChiudiDiv;
   modGUI1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px; margin-top:110px"');
   HTP.TABLEOPEN(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"' );
      HTP.TableRowOpen;
      HTP.TableData('Titolo opera',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      HTP.TableData('Anno opera',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      HTP.TableData('Periodo opera',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      HTP.TableData('info',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      /* inserire il tipo stanza*/
      HTP.TableRowClose;
   FOR val_ope in oper_cursor
   loop
      HTP.TableRowOpen;
      HTP.TableData(val_ope.Titolo,CATTRIBUTES  =>'style="text-align:center"');
      HTP.TableData(val_ope.Anno ,CATTRIBUTES  =>'style="text-align:center"');
      HTP.TableData(val_ope.FinePeriodo,CATTRIBUTES  =>'style="text-align:center"');
      htp.tabledata('<button onclick="document.getElementById(''LinguaeLivelloOpera'||val_ope.IdOpera||''').style.display=''block''" class="w3-margin w3-button w3-black w3-hover-white">Dettagli</button>');
      gruppo2.linguaELivello(val_ope.IdOpera);
      HTP.TableRowClose;    
   end loop;
   HTP.TableClose;
   modGUI1.ChiudiDiv();
   htp.br;htp.br;
   modGUI1.APRIDIV('class="w3-center"');
   modGUI1.Collegamento('menù',operazioniGruppo4.gr4||operazioniGruppo4.menu_m,'w3-btn w3-round-xxlarge w3-black ');
   htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
   modGUI1.Collegamento('statistiche',operazioniGruppo4.gr4||'form1monitoraggio?&MuseoId='||MuseoId||'&NameMuseo=','w3-btn w3-round-xxlarge w3-black ');
   modGUI1.ChiudiDiv;
   htp.bodyClose;
END opereprestate;

procedure visitatoriunici
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   Data1 VARCHAR2,
   Data2 VARCHAR2
)
is 
   dateini Date:= TO_DATE(Data1 default NULL on conversion error, 'YYYY-MM-DD');
   datefin Date:= TO_DATE(Data2 default NULL on conversion error, 'YYYY-MM-DD');
   CURSOR vis_cursor IS
   Select   UTENTI.IDUTENTE,UTENTI.NOME,UTENTI.COGNOME,UTENTI.DATANASCITA,UTENTI.INDIRIZZO,UTENTI.EMAIL
   FROM TITOLIINGRESSO,VISITE,UTENTIMUSEO,UTENTI
   WHERE TITOLIINGRESSO.MUSEO=MuseoId AND  VISITE.TITOLOINGRESSO= TITOLIINGRESSO.IDTITOLOING AND  VISITE.VISITATORE=UTENTIMUSEO.IDUTENTE AND UTENTIMUSEO.IDUTENTE=UTENTI.IDUTENTE AND VISITE.DATAVISITA>dateini AND VISITE.DATAVISITA<datefin;
   val_vis vis_cursor%Rowtype;
   nvisitatori number;
BEGIN 

   Select  Count(*)
   INTO nvisitatori
   FROM TITOLIINGRESSO,VISITE,UTENTIMUSEO
   WHERE TITOLIINGRESSO.MUSEO=MuseoId AND  VISITE.TITOLOINGRESSO= TITOLIINGRESSO.IDTITOLOING AND  VISITE.VISITATORE=UTENTIMUSEO.IDUTENTE AND VISITE.DATAVISITA>dateini AND VISITE.DATAVISITA<datefin;
   modGUI1.ApriPagina('Visitatori Museo');
   modGUI1.HEADER();
   htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 align="center">Visitatori Museo</h1>');
   modGUI1.APRIDIV('class="w3-center"');
   modGUI1.Collegamento('menù',operazioniGruppo4.gr4||operazioniGruppo4.menu_m,'w3-btn w3-round-xxlarge w3-black ');
   htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
   modGUI1.Collegamento('statistiche',operazioniGruppo4.gr4||'form2monitoraggio?&MuseoId='||MuseoId||'&NameMuseo=&Data1=&Data2=','w3-btn w3-round-xxlarge w3-black ');
   modGUI1.ChiudiDiv;
   htp.prn('<p align="center"><b>numero visitatori museo periodo ' || Data1 ||'--'|| Data2 ||':</b> ' || nvisitatori ||'</p>');
   modGUI1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:1600px; margin-top:110px"');
   HTP.TABLEOPEN(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"' );
      HTP.TableRowOpen;
      HTP.TableData('Nome',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      HTP.TableData('Cognome',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      HTP.TableData('Indirizzo',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      HTP.TableData('Email',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      HTP.TableData('Data di Nascita',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      HTP.TableRowClose;
   FOR val_vis in vis_cursor
   loop
      HTP.TableRowOpen;
      HTP.TableData(val_vis.Nome, CATTRIBUTES  =>'style="text-align:center"');
      HTP.TableData(val_vis.Cognome ,CATTRIBUTES  =>'style="text-align:center"');
      HTP.TableData(val_vis.Indirizzo,CATTRIBUTES  =>'style="text-align:center"');
      HTP.TableData(val_vis.Email,CATTRIBUTES  =>'style="text-align:center"');
      HTP.TableData(val_vis.DATANASCITA,CATTRIBUTES  =>'style="text-align:center"');  
      HTP.TableRowClose;    
   end loop;

   HTP.TableClose;
   modGUI1.chiudiDiv();
   htp.br;
   modGUI1.APRIDIV('class="w3-center"');
   modGUI1.Collegamento('menù',operazioniGruppo4.gr4||operazioniGruppo4.menu_m,'w3-btn w3-round-xxlarge w3-black ');
   htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
   modGUI1.Collegamento('statistiche',operazioniGruppo4.gr4||'form1monitoraggio?&MuseoId='||MuseoId||'&NameMuseo=','w3-btn w3-round-xxlarge w3-black ');
   modGUI1.ChiudiDiv;
   htp.bodyClose;
end visitatoriunici;

procedure visitatorimedi 
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   Data1 VARCHAR2,
   Data2 VARCHAR2
)
is 
   dateini Date:= TO_DATE(Data1 default NULL on conversion error, 'YYYY-MM-DD');
   datefin Date:= TO_DATE(Data2 default NULL on conversion error, 'YYYY-MM-DD');
   CURSOR vis_cursor IS
   Select   UTENTI.IDUTENTE,UTENTI.NOME,UTENTI.COGNOME,UTENTI.DATANASCITA,UTENTI.INDIRIZZO,UTENTI.EMAIL
   FROM TITOLIINGRESSO,VISITE,UTENTIMUSEO,UTENTI
   WHERE TITOLIINGRESSO.MUSEO=MuseoId AND  VISITE.TITOLOINGRESSO= TITOLIINGRESSO.IDTITOLOING AND  VISITE.VISITATORE=UTENTIMUSEO.IDUTENTE AND UTENTIMUSEO.IDUTENTE=UTENTI.IDUTENTE AND VISITE.DATAVISITA>dateini AND VISITE.DATAVISITA<datefin;
   val_vis vis_cursor%Rowtype;
   nvisitatori number;
   ngiorni number;
   mvisitatori number;
BEGIN
   /*ngiorni query*/
   select count(*)
   into ngiorni
   from (
      select distinct DATAVISITA
      from VISITE join TITOLIINGRESSO on VISITE.titoloingresso = TITOLIINGRESSO.IdTitoloing
      where DATAVISITA > dateini 
         and DATAVISITA < datefin
         and TITOLIINGRESSO.museo = MuseoId
   );

   Select  count(*)
   into nvisitatori
   FROM TITOLIINGRESSO,VISITE,UTENTIMUSEO,UTENTI
   WHERE TITOLIINGRESSO.MUSEO=MuseoId AND  VISITE.TITOLOINGRESSO= TITOLIINGRESSO.IDTITOLOING AND  VISITE.VISITATORE=UTENTIMUSEO.IDUTENTE AND UTENTIMUSEO.IDUTENTE=UTENTI.IDUTENTE AND VISITE.DATAVISITA>dateini AND VISITE.DATAVISITA<datefin;
   mvisitatori:=nvisitatori/ngiorni;
   modGUI1.ApriPagina('Visitatori museo');
   modGUI1.HEADER();
   htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 align="center">visitatori medi del Museo</h1>');
   htp.br;
   modGUI1.APRIDIV('class="w3-center"');
   modGUI1.Collegamento('menù',operazioniGruppo4.gr4||operazioniGruppo4.menu_m,'w3-btn w3-round-xxlarge w3-black ');
   htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
   modGUI1.Collegamento('statistiche',operazioniGruppo4.gr4||'form2monitoraggio?&MuseoId='||MuseoId||'&NameMuseo=&Data1=&Data2=','w3-btn w3-round-xxlarge w3-black ');
   modGUI1.ChiudiDiv;
   htp.prn('<p align="center" style="font-size:30px"><b>numero dei visitatori medi nel periodo ' || Data1 ||'--'|| Data2 ||':</b> ' || ROUND(mvisitatori,5) ||'</p>');
end; 

procedure introitimuseo
(
   MuseoId IN Musei.IdMuseo%TYPE
)
is 
   CURSOR  cur is
   select EMISSIONE,SCADENZA,COSTOTOTALE,NOME
   FROM TIPOLOGIEINGRESSO,TITOLIINGRESSO,ABBONAMENTI
   where MuseoId=TITOLIINGRESSO.MUSEO AND TITOLIINGRESSO.TIPOLOGIA=TIPOLOGIEINGRESSO.IDTIPOLOGIAING AND TIPOLOGIEINGRESSO.IDTIPOLOGIAING=ABBONAMENTI.IDTIPOLOGIAING;
   abb_cur cur%Rowtype; 

   CURSOR  cur2 is
   select EMISSIONE,SCADENZA,COSTOTOTALE,NOME
   FROM TIPOLOGIEINGRESSO,TITOLIINGRESSO,BIGLIETTI
   where MuseoId=TITOLIINGRESSO.MUSEO AND TITOLIINGRESSO.TIPOLOGIA=TIPOLOGIEINGRESSO.IDTIPOLOGIAING AND TIPOLOGIEINGRESSO.IDTIPOLOGIAING=BIGLIETTI.IDTIPOLOGIAING;
   bigl_cur cur2%Rowtype; 

   introiti_campiestivi number:=0;
   introiti_museo number:=0;
   introiti_totale number:=0;

BEGIN 
   select SUM(TIPOLOGIEINGRESSO.COSTOTOTALE)
   into introiti_museo
   from TIPOLOGIEINGRESSO,TITOLIINGRESSO
   where MuseoId=TITOLIINGRESSO.MUSEO AND TITOLIINGRESSO.TIPOLOGIA=TIPOLOGIEINGRESSO.IDTIPOLOGIAING;


   SELECT SUM(TARIFFECAMPIESTIVI.PREZZO)
   into introiti_campiestivi
   FROM TARIFFECAMPIESTIVI,CAMPIESTIVI,PAGAMENTICAMPIESTIVI
   WHERE MuseoId=CAMPIESTIVI.MUSEO AND CAMPIESTIVI.IDCAMPIESTIVI=TARIFFECAMPIESTIVI.CAMPOESTIVO AND PAGAMENTICAMPIESTIVI.TARIFFA=TARIFFECAMPIESTIVI.IDTARIFFA;

   introiti_totale:=introiti_museo+introiti_campiestivi;
   modGUI1.ApriPagina('Visualizzazione introiti museo');
   modGUI1.HEADER();
   htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 align="center">Introiti Museo </h1>');
   modGUI1.APRIDIV('class="w3-center"');
   modGUI1.Collegamento('menù',operazioniGruppo4.gr4||operazioniGruppo4.menu_m,'w3-btn w3-round-xxlarge w3-black ');
   htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
   modGUI1.Collegamento('statistiche',operazioniGruppo4.gr4||'form1monitoraggio?&MuseoId='||MuseoId||'&NameMuseo=','w3-btn w3-round-xxlarge w3-black ');
   modGUI1.ChiudiDiv;
   htp.br;
   modGUI1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:900px; margin-top:110px"');
   HTP.TABLEOPEN(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"' );
         HTP.TableRowOpen;
         HTP.TableData('Introti del museo: ',CATTRIBUTES  =>'style="font-weight:bold; font-size:25px"');
         HTP.TableData( introiti_museo|| ' €',CATTRIBUTES  =>'style="font-size:25px"');
         HTP.TableRowClose;
         HTP.TableRowOpen;
         HTP.TABLEDATA('BIGLIETTI',CATTRIBUTES  =>'style="font-weight:bold; font-size:25px"');
         HTP.TableRowClose;
         HTP.TableRowOpen;
         HTP.TableData('Nome',CATTRIBUTES  =>'style="font-weight:bold"');
         HTP.TableData('Data Emissione',CATTRIBUTES  =>'style="font-weight:bold"');
         HTP.TableData('Scadenza',CATTRIBUTES  =>'style="font-weight:bold"');
         HTP.TableData('Costo',CATTRIBUTES  =>'style="font-weight:bold"');
         HTP.TableRowClose;
         FOR bigl_cur in cur2 
         loop
            HTP.TableRowOpen;
            HTP.TableData(bigl_cur.Nome,'center');
            HTP.TableData(TO_CHAR(bigl_cur.Emissione, 'DD Month YYYY'),'center');
            HTP.TableData(TO_CHAR(bigl_cur.Scadenza, 'DD Month YYYY' ),'center');
            HTP.TableData(bigl_cur.Costototale || '€','center'); 
            HTP.TableRowClose;
         end loop;
         HTP.TableRowOpen;
         HTP.TABLEDATA('ABBONAMENTI',CATTRIBUTES  =>'style="font-weight:bold; font-size:25px"');
         HTP.TableRowClose;
         HTP.TableRowOpen;
         HTP.TableData('Nome',CATTRIBUTES  =>'style="font-weight:bold"');
         HTP.TableData('Data Emissione',CATTRIBUTES  =>'style="font-weight:bold"');
         HTP.TableData('Scadenza',CATTRIBUTES  =>'style="font-weight:bold"');
         HTP.TableData('Costo',CATTRIBUTES  =>'style="font-weight:bold"');
         HTP.TableRowClose;
         FOR  abb_cur in cur
         loop
            HTP.TableRowOpen;
            HTP.TableData(abb_cur.Nome,'center');
            HTP.TableData(TO_CHAR(abb_cur.Emissione, 'DD Month YYYY'),'center');
            HTP.TableData(TO_CHAR(abb_cur.Scadenza, 'DD Month YYYY') ,'center');
            HTP.TableData(abb_cur.Costototale || '€','center'); 
            HTP.TableRowClose;
         end loop;
         HTP.TableRowOpen;
         HTP.TableData('Introti dei campiestivi: ',CATTRIBUTES  =>'style="font-weight:bold; font-size:25px"');
         HTP.TableData( introiti_campiestivi|| ' €',CATTRIBUTES  =>'style="font-size:25px"');
         HTP.TableRowClose;
         HTP.TableRowOpen;
         HTP.TableData('Introti totali: ',CATTRIBUTES  =>'style="font-weight:bold; font-size:25px"');
         HTP.TableData( introiti_totale || ' €',CATTRIBUTES  =>'style="font-size:25px"');
         HTP.TableRowClose;
   HTP.TableClose;
         /* inserire il tipo stanza*/
   modGUI1.chiudiDiv();
   htp.br;htp.br;
   modGUI1.APRIDIV('class="w3-center"');
   modGUI1.Collegamento('menù',operazioniGruppo4.gr4||operazioniGruppo4.menu_m,'w3-btn w3-round-xxlarge w3-black ');
   htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
   modGUI1.Collegamento('statistiche',operazioniGruppo4.gr4||'form1monitoraggio?&MuseoId='||MuseoId||'&NameMuseo=','w3-btn w3-round-xxlarge w3-black ');
   modGUI1.ChiudiDiv;
   htp.bodyClose;
end introitimuseo;

procedure controllastatistica
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   scelta in number
)
is BEGIN
if scelta=2
   then operepresentimuseo(MuseoId);
else if scelta=1
   then salepresenti(MuseoId);
   else if scelta=3
   then opereprestate(MuseoId);
   else if scelta=4
   then introitimuseo(MuseoId);
   end if;
   end if;
end if;
  end if;
end controllastatistica;


procedure controllastatistica2
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   scelta in number,
   Data1 VARCHAR2,
   Data2  varchar2
)
is 

BEGIN
if scelta=5
   then visitatoriunici(MuseoId,Data1,Data2);
else if scelta=6
   then visitatorimedi(MuseoId,Data1,Data2);
end if;
  end if;
end controllastatistica2;

/*---------------STATISTICHE CAMPI ESTIVI-------------------------------*/
procedure form1campiestivi
(
   CampoestivoId IN CAMPIESTIVI.IDCAMPIESTIVI%TYPE,
   NameCampoestivo IN CAMPIESTIVI.NOME%TYPE
)

is
   CURSOR cur IS Select Eliminato,CAMPIESTIVI.IDCAMPIESTIVI,CAMPIESTIVI.NOME
                           FROM CAMPIESTIVI
                           WHERE ELIMINATO=0;
   campId_cur cur%Rowtype; 
BEGIN
   htp.htmlOpen;
   modGUI1.ApriPagina('Statistiche campiesitvi');
   modGUI1.HEADER();
   htp.BODYOPEN();
   htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;

   htp.prn('<h1 align="center">Statistiche  campi estivi</h1>');
   modGUI1.apridiv('class="w3-modal-content w3-card-4" style="max-width:600px; margin-top:110px"');
   modGUI1.Collegamento('M',operazioniGruppo4.gr4||operazioniGruppo4.menu_ce,'w3-btn  w3-black w3-display-topright ');
   modGUI1.ApriForm(operazioniGruppo4.gr4||'controllastatisticacampo','invia','w3-container'); 
   modGUI1.LABEL('Nome del Campo estivo');
   modGUI1.SelectOpen('CampoestivoId',NameCampoestivo);
   FOR campId_cur IN cur LOOP
      modGUI1.SelectOption(campId_cur.IdCampiEstivi,campId_cur.NOME);
   END LOOP;
   modGUI1.SelectClose;
   htp.br;htp.br;
   modGUI1.LABEL('Operazione');
   htp.br;
   modGUI1.INPUTRADIOBUTTON('Utenti iscritti','scelta',1,checked=>1);
   htp.br;
   modGUI1.INPUTRADIOBUTTON('tariffe','scelta',2);
   htp.br;
   modGUI1.INPUTRADIOBUTTON('età media tariffe','scelta',3);
   htp.br;
   modGUI1.INPUTRADIOBUTTON('introiti campo','scelta',4);
   htp.br;htp.br;htp.br;
   modGUI1.INPUTSUBMIT('invia');
   modGUI1.ChiudiForm;
   modGUI1.ChiudiDiv();
   htp.htmlClose;
END form1campiestivi;

procedure controllastatisticacampo
(
   CampoestivoId IN CAMPIESTIVI.IDCAMPIESTIVI%TYPE,
   scelta in number
)
is 
BEGIN
if scelta=1
   then utentiiscritti(CampoestivoId);
else if scelta=2
   then tariffecampi(CampoestivoId);
else if scelta=3
   then etamediatariffe(CampoestivoId);
else if scelta=4
   then introiticampi(CampoestivoId);
   end if;
   end if;
   end if;
  end if;
end controllastatisticacampo;

procedure utentiiscritti
(
   CampoestivoId IN CAMPIESTIVI.IDCAMPIESTIVI%TYPE
)

IS
  CURSOR ut_cursor IS
  Select UTENTI.NOME,UTENTI.COGNOME,UTENTI.DATANASCITA,UTENTI.INDIRIZZO,UTENTI.EMAIL
  FROM UTENTI,UTENTIPAGAMENTI,PAGAMENTICAMPIESTIVI,TARIFFECAMPIESTIVI,UTENTICAMPIESTIVI
  WHERE CampoestivoId=TARIFFECAMPIESTIVI.CAMPOESTIVO AND PAGAMENTICAMPIESTIVI.TARIFFA=TARIFFECAMPIESTIVI.IDTARIFFA AND PAGAMENTICAMPIESTIVI.IDPAGAMENTO=UTENTIPAGAMENTI.IDPAGAMENTO AND UTENTIPAGAMENTI.IDUTENTE= UTENTICAMPIESTIVI.IDUTENTE AND UTENTI.IDUTENTE= UTENTICAMPIESTIVI.IDUTENTE;
  val_ut ut_cursor%Rowtype;
  nutenti number;
BEGIN
   modGUI1.ApriPagina('Visualizzazione utenti iscritti');
   modGUI1.HEADER();
   /*conto il numero delgi uteni iscritti*/
   Select count(*)
   INTO nutenti
   FROM UTENTI,UTENTIPAGAMENTI,PAGAMENTICAMPIESTIVI,TARIFFECAMPIESTIVI,UTENTICAMPIESTIVI
   WHERE CampoestivoId=TARIFFECAMPIESTIVI.CAMPOESTIVO AND PAGAMENTICAMPIESTIVI.TARIFFA=TARIFFECAMPIESTIVI.IDTARIFFA AND PAGAMENTICAMPIESTIVI.IDPAGAMENTO=UTENTIPAGAMENTI.IDPAGAMENTO AND UTENTIPAGAMENTI.IDUTENTE= UTENTICAMPIESTIVI.IDUTENTE AND UTENTI.IDUTENTE= UTENTICAMPIESTIVI.IDUTENTE;

   htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 align="center">Utenti Campo estivo </h1>');
   htp.br;htp.br;
   htp.prn('<p align="center"><b>numero iscritti al campo estivo:</b> ' || nutenti ||'</p>');
   modGUI1.APRIDIV('class="w3-center"');
   modGUI1.Collegamento('menù',operazioniGruppo4.gr4||operazioniGruppo4.menu_ce,'w3-btn w3-round-xxlarge w3-black ');
   htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
   modGUI1.Collegamento('statistiche',operazioniGruppo4.gr4||'form1campiestivi?&CampoestivoId=&NameCampoestivo=','w3-btn w3-round-xxlarge w3-black ');
   modGUI1.chiudidiv;
   modGUI1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:1400px; margin-top:110px"');

   HTP.TABLEOPEN(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"' );
      HTP.TableRowOpen;
      HTP.TableData('Nome',CATTRIBUTES  =>'style="font-weight:bold; text-align:center""');
      HTP.TableData('Cognome',CATTRIBUTES  =>'style="font-weight:bold; text-align:center""');
      HTP.TableData('Indirizzo',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      HTP.TableData('Email',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      HTP.TableData('Data di Nascita',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      HTP.TableRowClose;

      FOR val_ut in ut_cursor
      loop
         HTP.TableRowOpen;
         HTP.TableData(val_ut.Nome,CATTRIBUTES  =>'style="text-align:center"');
         HTP.TableData(val_ut.Cognome ,CATTRIBUTES  =>'style="text-align:center"');
         HTP.TableData(val_ut.Indirizzo,CATTRIBUTES  =>'style="text-align:center"');
         HTP.TableData(val_ut.Email,CATTRIBUTES  =>'style="text-align:center"');
         HTP.TableData(val_ut.DATANASCITA,CATTRIBUTES  =>'style="text-align:center"');  
         HTP.TableRowClose;
      end loop;
   HTP.TableClose;
   modGUI1.ChiudiDiv();
   htp.bodyClose;
END utentiiscritti;  


procedure tariffecampi
(
   CampoestivoId IN CAMPIESTIVI.IDCAMPIESTIVI%TYPE
)
IS
   CURSOR tar_cursor IS
   Select TARIFFECAMPIESTIVI.IDTARIFFA,TARIFFECAMPIESTIVI.Prezzo,TARIFFECAMPIESTIVI.Etaminima,TARIFFECAMPIESTIVI.Etamassima
   FROM TARIFFECAMPIESTIVI
   WHERE CampoestivoId=TARIFFECAMPIESTIVI.CAMPOESTIVO;
   val_tar tar_cursor%Rowtype;
BEGIN
   modGUI1.ApriPagina('Tariffe campi estivi');
   modGUI1.HEADER();
   htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 align="center">Tariffe Campo estivo </h1>');
   modGUI1.APRIDIV('class="w3-center"');
   modGUI1.Collegamento('menù',operazioniGruppo4.gr4||operazioniGruppo4.menu_ce,'w3-btn w3-round-xxlarge w3-black ');
   htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
   modGUI1.Collegamento('statistiche',operazioniGruppo4.gr4||'form1campiestivi?&CampoestivoId=&NameCampoestivo=','w3-btn w3-round-xxlarge w3-black ');
   modGUI1.CHIUDIdiv;
   modGUI1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px; margin-top:110px"');
   HTP.TABLEOPEN(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"' );
      HTP.TableRowOpen;
      HTP.TableData('id tariffa',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Prezzo',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Età minima',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      HTP.TableData('Età massima',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      HTP.TableData('info',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      HTP.TableRowClose;
      FOR val_tar in tar_cursor
      loop
         HTP.TableRowOpen;
         HTP.TableData(val_tar.IDTARIFFA,'center');
         HTP.TableData(val_tar.Prezzo || ' €' ,'center');
         HTP.TableData(val_tar.Etaminima,'center');
         HTP.TableData(val_tar.Etamassima,'center');  
         htp.tabledata('<a href="'|| Costanti.server || Costanti.radice || operazioniGruppo4.gr4||'VisualizzaTariffeCampiEstivi?'||'Tariffa='||val_tar.IDTARIFFA||'"'||'class="w3-black w3-round w3-margin w3-button"'||'>'||'Dettagli'||'</a>');
         HTP.TableRowClose;
      end loop;
   HTP.TableClose;
   modGUI1.ChiudiDiv();
   htp.bodyClose;
end tariffecampi;

procedure etamediatariffe
(
   CampoestivoId IN CAMPIESTIVI.IDCAMPIESTIVI%TYPE
)IS
   etamedia number(5);
   CURSOR etacur IS
   Select Utenti.Nome,Utenti.COGNOME,ETA,CAMPOESTIVO
   from vistaetamedia ,Utenti
   where vistaetamedia.campoestivo=CampoestivoId AND UTENTI.IDUTENTE=vistaetamedia.IDUTENTE;
   val_cur etacur%Rowtype;

BEGIN
   Select trunc(avg(etam.eta),0) 
   into etamedia
   from vistaetamedia etam
   where etam.campoestivo=CampoestivoId;
   
   modGUI1.ApriPagina('Età Media Iscritti Campo Estivo');
   modGUI1.HEADER();
   htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 align="center">Utenti Campo estivo </h1>');
   modGUI1.APRIDIV('class="w3-center"');
   modGUI1.Collegamento('menù',operazioniGruppo4.gr4||operazioniGruppo4.menu_ce,'w3-btn w3-round-xxlarge w3-black ');
   htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
   modGUI1.Collegamento('statistiche',operazioniGruppo4.gr4||'form1campiestivi?&CampoestivoId=&NameCampoestivo=','w3-btn w3-round-xxlarge w3-black ');
   modGUI1.CHIUDIdiv;
   htp.prn('<p align="center" style="font-size:20px"><b> età media visitatori :</b>' ||etamedia || '</p>');
   modGUI1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px; margin-top:110px"');
   HTP.TABLEOPEN(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"' );
      HTP.TableRowOpen;
      HTP.TableData('Nome',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Cognome',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Età',CATTRIBUTES  =>'style="font-weight:bold;"');
      HTP.TableRowClose;
      FOR val_cur in etacur
      loop
         HTP.TableRowOpen;
         HTP.TableData(val_cur.Nome);
         HTP.TableData(val_cur.Cognome);
         HTP.TableData(val_cur.eta,'style="text-align:center"');
         HTP.TableRowClose;
      end loop;
   HTP.TableClose;
   modGUI1.chiudiDiv;
end etamediatariffe;

procedure introiticampi
(
   CampoestivoId in CAMPIESTIVI.IDCAMPIESTIVI%TYPE
)
IS
   introiti_campiestivi number;
BEGIN

   SELECT SUM(TARIFFECAMPIESTIVI.PREZZO)
   into introiti_campiestivi
   FROM TARIFFECAMPIESTIVI,PAGAMENTICAMPIESTIVI
   WHERE  CampoestivoId=TARIFFECAMPIESTIVI.CAMPOESTIVO AND PAGAMENTICAMPIESTIVI.TARIFFA=TARIFFECAMPIESTIVI.IDTARIFFA;

   modGUI1.ApriPagina('Visualizzazione introiti museo');
   modGUI1.HEADER();
   htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 align="center">Introiti Campo </h1>');
   modGUI1.APRIDIV('class="w3-center"');
   modGUI1.Collegamento('menù',operazioniGruppo4.gr4||operazioniGruppo4.menu_ce,'w3-btn w3-round-xxlarge w3-black ');
   htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
   modGUI1.Collegamento('statistiche',operazioniGruppo4.gr4||'form1campiestivi?&CampoestivoId=&NameCampoestivo=','w3-btn w3-round-xxlarge w3-black ');
   modGUI1.ChiudiDiv;
   htp.br;
   modGUI1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px; margin-top:110px"');
   HTP.TABLEOPEN(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"' );
         HTP.TableRowOpen;
         HTP.TableData('Introti del campo estivo: ',CATTRIBUTES  =>'style="font-weight:bold"');
         HTP.TableData( introiti_campiestivi|| ' €');
         HTP.TableRowClose;
   HTP.TableClose;
   modGUI1.chiudiDiv();
   htp.bodyClose;
end;

/*Inserisci pagamento campi estivi*/
/****************************************************************/
procedure InserisciPagamentoCampiEstivi(
   dataPagamento in varchar2 default NULL,
   tariffa in PAGAMENTICAMPIESTIVI.Tariffa%type default 0, 
   acquirente in PAGAMENTICAMPIESTIVI.Acquirente%type default 0 
) 
is
campo TARIFFECAMPIESTIVI.CAMPOESTIVO%type;
idSessione number(5) :=  modGUI1.get_id_sessione();
BEGIN
   select CampoEstivo
   into campo
   from TARIFFECAMPIESTIVI
   where TARIFFECAMPIESTIVI.IDTARIFFA=tariffa;

   modGUI1.ApriPagina('Inserimento pagamento campo estivo');
   modGUI1.header();
   htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 align="center">Inserimento Pagamento Campo Estivo</h1>');
   modGUI1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px; margin-top:110px"');
      modGUI1.apridiv('class="w3-section"');
         modGUI1.collegamento('X',operazioniGruppo4.gr4||operazioniGruppo4.menu_t||'?idCampo='||campo,' w3-btn w3-large w3-red w3-display-topright');
         modGUI1.ApriForm(operazioniGruppo4.gr4||'ConfermaPagamentoCampiEstivi', null, 'w3-container');
               modGUI1.label('Data Pagamento');
               modGUI1.InputDate('dataPagamento', 'dataPagamento', 1, dataPagamento);
               htp.br;
               htp.formhidden('tariffa',tariffa);
               modGUI1.label('Acquirente');
               modGUI1.selectopen('Acquirente');
               for utente in 
                  (select NOME,UTENTI.IDUTENTE from UTENTI )
               loop
                  modGUI1.selectoption(utente.IDUTENTE, utente.NOME);
               end loop;
               modGUI1.selectclose;
               htp.br;
               modGUI1.inputsubmit('Aggiungi');
         modGUI1.ChiudiForm;
      modGUI1.ChiudiDiv;
   modGUI1.ChiudiDiv;
   htp.bodyClose;
   htp.htmlClose;
end InserisciPagamentoCampiEstivi;

procedure ConfermaPagamentoCampiEstivi(
    dataPagamento in varchar2 default NULL,
    tariffa in PAGAMENTICAMPIESTIVI.Tariffa%type default 0, 
    acquirente in PAGAMENTICAMPIESTIVI.Acquirente%type default 0
) is 
   idSessione number(5) :=  modGUI1.get_id_sessione();
   newIdPagamento PAGAMENTICAMPIESTIVI.IdPagamento%type;
   nomeut Utenti%rowtype;
BEGIN
   Select *
   into nomeut
   from UTENTI
   where UTENTI.IDUTENTE=ACQUIRENTE;

    if tariffa = 0
    or dataPagamento is null
    or acquirente = 0
    then
      modGUI1.apripagina('Pagina errore');
      htp.bodyopen;
      modGUI1.apridiv;
      htp.print('Uno dei parametri immessi non valido');
      modGUI1.chiudidiv;
      htp.bodyclose;
      htp.htmlclose;
   else
      modGUI1.apripagina('Conferma', idSessione);
      modGUI1.header();
      htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
      htp.prn('<h1 align="center">Conferma dati</h1>');--DA MODIFICARE
      modGUI1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px" ');
      htp.TABLEOPEN(CALIGN=>'center',CATTRIBUTES =>'class="w3-table"');
      htp.TABLEROWOPEN();
      htp.TABLEDATA('Data Pagamento:',CATTRIBUTES=>'style="font-weight:bold;text-align:center"');
      htp.TABLEDATA(dataPagamento,CATTRIBUTES =>'style="text-align:center"');
      htp.TableRowClose;
      htp.TABLEROWOPEN();
      htp.TABLEDATA('Tariffa:',CATTRIBUTES=>'style="font-weight:bold;text-align:center""');
      htp.TABLEDATA(tariffa,CATTRIBUTES =>'style="text-align:center"');
      htp.TableRowClose;
      htp.TABLEROWOPEN();
      htp.TABLEDATA('Acquirente:',CATTRIBUTES=>'style="font-weight:bold;text-align:center""');
      htp.TABLEDATA(nomeut.NOME ||' '||nomeut.COGNOME,CATTRIBUTES =>'style="text-align:center"');
      htp.TableRowClose;
      htp.tableclose;
      modGUI1.apriform(operazioniGruppo4.gr4||'ControllaPagamentoCampiEstivi');
      htp.formhidden('dataPagamento', dataPagamento);
      htp.formhidden('tariffa', tariffa);
      htp.formhidden('acquirente', acquirente);
      modGUI1.inputsubmit('Conferma');
      modGUI1.chiudiform;
      modGUI1.apriform(operazioniGruppo4.gr4||'InserisciPagamentoCampiEstivi');
      htp.formhidden('dataPagamento', dataPagamento);
      htp.formhidden('tariffa', tariffa);
      htp.formhidden('acquirente', acquirente);
      modGUI1.inputsubmit('Annulla');
      modGUI1.chiudiform;
   modGUI1.chiudidiv;
    end if;
    exception when others then
        dbms_output.put_line('Error: '||sqlerrm);
end ConfermaPagamentoCampiEstivi;
        
procedure ControllaPagamentoCampiEstivi(
    dataPagamento in varchar2 default NULL, 
    tariffa in PAGAMENTICAMPIESTIVI.Tariffa%type, 
    acquirente in PAGAMENTICAMPIESTIVI.Acquirente%type
) is 
   idSessione number(5) :=  modGUI1.get_id_sessione();
   dataPagamento_date date := TO_DATE(dataPagamento, 'YYYY-MM-DD');
   type errorsTable is table of varchar2(32);
   errors errorsTable;
   errorsCount integer := 0;
   campo TARIFFECAMPIESTIVI.CAMPOESTIVO%type;
   trovato number(10):=0;
BEGIN
   SELECT TARIFFECAMPIESTIVI.CAMPOESTIVO
   into campo
   FROM TARIFFECAMPIESTIVI
   where TARIFFECAMPIESTIVI.IDTARIFFA=TARIFFA;

   SELECT count(*)
   into trovato
   FROM UTENTICAMPIESTIVI
   where UTENTICAMPIESTIVI.IDUTENTE=ACQUIRENTE;

   if trovato=0
   THEN
      INSERT into UTENTICAMPIESTIVI
      values(ACQUIRENTE,0);
   end if;

   insert into PAGAMENTICAMPIESTIVI(IdPagamento, DataPagamento, Tariffa, Acquirente)
      values (IdPagamentoSeq.nextval, dataPagamento_date, tariffa, acquirente);
   if sql%found then
      commit;
       modGUI1.redirectesito('Inserimento andato a buon fine', null,
      'Inserisci un nuovo pagamento',operazioniGruppo4.gr4||'InserisciPagamentoCampiEstivi','?dataPagamento='||dataPagamento||'//tariffa='||tariffa||'//acquirente='||acquirente,
      'menu tariffe',operazioniGruppo4.gr4||operazioniGruppo4.menu_t,'?idCampo='||campo);
   end if;
   exception when others then
       modGUI1.redirectesito('Inserimento non riuscito', null,
      'Riprova',operazioniGruppo4.gr4||'InserisciPagamentoCampiEstivi','?dataPagamento='||dataPagamento||'//tariffa='||tariffa||'//acquirente='||acquirente,
      'menu tariffe',operazioniGruppo4.gr4||operazioniGruppo4.menu_t,'?idCampo='||campo);
 
end ControllaPagamentoCampiEstivi;


procedure eliminatariffa
(
   Tariffaid in TARIFFECAMPIESTIVI.IdTariffa%type
) 
is 
BEGIN
   htp.htmlopen;
   modGUI1.ApriDiv('id="Elimtariffa'||Tariffaid||'" class="w3-modal"');
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
            modGUI1.ApriDiv('class="w3-center"');
               htp.br;
               htp.prn('<span onclick="document.getElementById(''Elimtariffa'||Tariffaid||''').style.display=''none''" class="w3-button w3-xlarge w3-red w3-display-topright" title="Close Modal">X</span>');
               htp.print('<h1><b>Confermi?</b></h1>');
            modGUI1.ChiudiDiv;
                    modGUI1.ApriDiv('class="w3-section"');
                        htp.br;
                        htp.prn('stai per rimuovere la Tariffa');
                        modGUI1.Collegamento('Conferma',
                        Operazionigruppo4.gr4||'rimuovitariffa?Tariffaid='||Tariffaid,
                        'w3-button w3-block w3-green w3-section w3-padding');
                        htp.prn('<span onclick="document.getElementById(''Elimtariffa'||Tariffaid||''').style.display=''none''" class="w3-button w3-block w3-red w3-section w3-padding" title="Close Modal">Annulla</span>');
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiForm;
        modGUI1.ChiudiDiv;
    modGUI1.ChiudiDiv;
   htp.htmlclose;
end;

procedure rimuovitariffa
(
   Tariffaid in TARIFFECAMPIESTIVI.IdTariffa%type
)
IS
BEGIN
   update TARIFFECAMPIESTIVI set
      ELIMINATO=1
   where IDTARIFFA=Tariffaid;
   modGUI1.RedirectEsito('Eliminazione riuscita','Campo Estivo eliminato correttamente',null,null,null,'Torna al menu dei campiestivi',operazioniGruppo4.gr4||operazioniGruppo4.menu_ce,null);
end;

procedure PagamentoCampiEstivi
(
   tariffaid in PAGAMENTICAMPIESTIVI.Tariffa%type default 0
) 
is 
   CURSOR cur IS
   select IdPagamento,DataPagamento,Tariffa,Acquirente
   from PAGAMENTICAMPIESTIVI
   where  PAGAMENTICAMPIESTIVI.Tariffa = tariffaid;
   pagId_cur cur%Rowtype; 
   pagamentiTariffa number;
   campo TARIFFECAMPIESTIVI.CampoEstivo%type;
   utente UTENTI%Rowtype;
BEGIN
   htp.htmlopen;
   modGUI1.ApriPagina();
   modGUI1.Header();
   htp.bodyopen;
   select count(IdPagamento) into pagamentiTariffa
   from PAGAMENTICAMPIESTIVI
   where  PAGAMENTICAMPIESTIVI.Tariffa = tariffaid;

   Select CampoEstivo
   into campo
   from TARIFFECAMPIESTIVI
   WHERE TARIFFECAMPIESTIVI.IDTARIFFA=tariffaid;

   htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 align="center">Pagamenti</h1>');
   modGUI1.APRIDIV('class="w3-center"');
   modGUI1.Collegamento('menu',operazioniGruppo4.gr4||menu_t||'?idCampo='||campo,'w3-btn w3-round-xxlarge w3-black ');
   modGUI1.chiudiDiv;
   htp.prn('<p align="center"><b>numero di pagamenti: </b>'||pagamentiTariffa||'</p>');
   modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
   HTP.TABLEOPEN(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"' );
   HTP.TableRowOpen;
   HTP.TableData('IdPagamento',CATTRIBUTES  =>'style="font-weight:bold"');
   HTP.TableData('DataPagamento',CATTRIBUTES  =>'style="font-weight:bold"');
   HTP.TableData('Acquirente',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
   HTP.TableData('',CATTRIBUTES =>'style="font-weight:bold"');
   FOR pagId_cur IN cur LOOP
      Select *
      into utente
      from UTENTI
      where UTENTI.IDUTENTE=pagId_cur.Acquirente;

      htp.tablerowopen;
      htp.tabledata(pagId_cur.IdPagamento,CATTRIBUTES =>'style="text-align:center"');
      htp.tabledata(pagId_cur.DataPagamento,CATTRIBUTES =>'style="text-align:center"');
      htp.tabledata(utente.Nome ||' '||utente.Cognome,CATTRIBUTES =>'style="text-align:center"');
      htp.tabledata('<a href="'|| Costanti.server || Costanti.radice || operazioniGruppo4.gr4||'Utentipagamenti?'||'pagamentoid='||pagId_cur.IdPagamento||'"'||'class="w3-black w3-round w3-margin w3-button"'||'>'||'Dettagli'||'</a>');
      htp.tablerowclose;

   END LOOP;
   modGUI1.chiudidiv;
   htp.bodyclose;
   htp.htmlclose;
end;
/*-------------------TARIFFE CAMPI ESTIVI---------------------------------------------------------*/
procedure InserisciTariffeCampiEstivi
(
   prezzo in TARIFFECAMPIESTIVI.Prezzo%type default 0,
   etaMinima in TARIFFECAMPIESTIVI.Etaminima%type default 0,
   etaMassima in TARIFFECAMPIESTIVI.Etamassima%type default 0,
   campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type default 0
) 
is
   idSessione number(5) :=  modGUI1.get_id_sessione();
BEGIN
   modGUI1.apripagina('Inserimento tariffa campo estivo');
   modGUI1.header;
   htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;

   htp.prn('<h1 align="center">Inserimento Tariffa Campo Estivo</h1>');
   modGUI1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px; margin-top:110px"');
      modGUI1.apridiv('class="w3-section"');
         modGUI1.collegamento('X',operazioniGruppo4.gr4||operazioniGruppo4.menu_t||'?idCampo='||campoEstivo,' w3-btn w3-large w3-red w3-display-topright');
         modGUI1.ApriForm(operazioniGruppo4.gr4||'ConfermaTariffeCampiEstivi', null, 'w3-container');
            modGUI1.label('Prezzo');
            modGUI1.inputtext('prezzo', 'prezzo', 1, prezzo);
            htp.br;
            modGUI1.label('Eta minima');
            modGUI1.inputtext('etaMinima', 'etaMinima', 1, etaMinima);
            htp.br;
            modGUI1.label('Eta massima');
            modGUI1.inputtext('etaMassima', 'etaMassima', 1, etaMassima);
            htp.br;
            modGUI1.label('Campo Estivo');
            modGUI1.selectopen('CampoEstivo',CampoEstivo);
            for campo in
               (select Eliminato,IdCampiEstivi, nome from campiestivi where  Eliminato=0 AND IdCampiEstivi = campoEstivo)
            loop
               modGUI1.selectoption(campo.IdCampiEstivi, campo.nome);
            end loop;
            for campo in
               (select Eliminato,IdCampiEstivi, nome from campiestivi where  Eliminato=0 AND IdCampiEstivi <> campoEstivo)
            loop
               modGUI1.selectoption(campo.IdCampiEstivi, campo.nome);
            end loop;
            modGUI1.selectclose;
            htp.br;
            modGUI1.inputsubmit('Aggiungi');
            modGUI1.chiudiform;
      modGUI1.chiudidiv;
   modGUI1.chiudidiv;
   htp.bodyclose;
   htp.htmlclose;
end InserisciTariffeCampiEstivi;

procedure ConfermaTariffeCampiEstivi
(
    prezzo in TARIFFECAMPIESTIVI.Prezzo%type default 0,
    etaMinima in TARIFFECAMPIESTIVI.Etaminima%type default 0,
    etaMassima in TARIFFECAMPIESTIVI.Etamassima%type default 0,
    campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type default 0
) is
    idSessione number(5) :=  modGUI1.get_id_sessione();
    campoFound number;
   campoEstivo_niceName varchar(100);
BEGIN
   

   select count(*) into campoFound
   from CAMPIESTIVI
   where CAMPIESTIVI.IDCAMPIESTIVI = campoEstivo;

   if etaminima > Etamassima
   or prezzo < 0
   or etaminima < 0
   or campoFound is null
   or campoFound = 0
   then
      modGUI1.apripagina('Pagina errore');
      modGUI1.header;
      htp.bodyopen;
      htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
      htp.prn('<h1 align="center">Errore</h1>');
      modGUI1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px" ');
      htp.prn('<p style="text-align:center"> Parametri inseriti in maniera errata </p>');
      modGUI1.APRIFORM(operazioniGruppo4.gr4||'InserisciTariffeCampiEstivi');
      HTP.FORMHIDDEN('prezzo',prezzo);
      HTP.FORMHIDDEN('etaMinima',etaMinima);
      HTP.FORMHIDDEN('etaMassima',etaMassima);
      HTP.FORMHIDDEN('campoEstivo',campoEstivo);
      MODGUI1.INPUTSUBMIT('indietro');
      modGUI1.ChiudiForm;
      modGUI1.chiudidiv;
      htp.bodyclose;
      htp.htmlclose;
   else
      select NOME into campoEstivo_niceName
      from CAMPIESTIVI
      where CAMPIESTIVI.IDCAMPIESTIVI = campoEstivo;
      modGUI1.apripagina('Conferma', idSessione);
      modGUI1.header;
      htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
      htp.prn('<h1 align="center">Conferma Dati</h1>');--DA MODIFICARE
      modGUI1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px" ');
      htp.TABLEOPEN(CALIGN=>'center',CATTRIBUTES =>'class="w3-table"');
      htp.TABLEROWOPEN();
      htp.TABLEDATA('Prezzo:',CATTRIBUTES=>'style="font-weight:bold;text-align:center"');
      htp.TABLEDATA(prezzo,CATTRIBUTES =>'style="text-align:center"');
      htp.TableRowClose;
      htp.TABLEROWOPEN();
      htp.TABLEDATA('Età Minima:',CATTRIBUTES=>'style="font-weight:bold;text-align:center""');
      htp.TABLEDATA(etaMinima,CATTRIBUTES =>'style="text-align:center"');
      htp.TableRowClose;
      htp.TABLEROWOPEN();
      htp.TABLEDATA('Età Massima:',CATTRIBUTES=>'style="font-weight:bold;text-align:center""');
      htp.TABLEDATA(etaMassima,CATTRIBUTES =>'style="text-align:center"');
      htp.TableRowClose;
      htp.TABLEROWOPEN();
      htp.TABLEDATA('Campo Estivo:',CATTRIBUTES=>'style="font-weight:bold;text-align:center""');
      htp.TABLEDATA(campoEstivo_niceName,CATTRIBUTES =>'style="text-align:center"');
      htp.TableRowClose;
      htp.tableclose;
      modGUI1.apriform(operazioniGruppo4.gr4||'ControllaTariffeCampiEstivi');
         htp.formhidden('prezzo', prezzo);
         htp.formhidden('etaMinima', etaMinima);
         htp.formhidden('etaMassima', etaMassima);
         htp.formhidden('campoEstivo', campoEstivo);
         modGUI1.inputsubmit('Conferma');
         modGUI1.chiudiform;
         modGUI1.apriform(operazioniGruppo4.gr4||'InserisciTariffeCampiEstivi');
         htp.formhidden('prezzo', prezzo);
         htp.formhidden('etaMinima', etaMinima);
         htp.formhidden('etaMassima', etaMassima);
         htp.formhidden('campoEstivo', campoEstivo);
         modGUI1.inputsubmit('Annulla');
         modGUI1.chiudiform;
      modGUI1.chiudidiv;
         
   end if;
   exception when others then
      dbms_output.put_line('Error: '||sqlerrm);
end ConfermaTariffeCampiEstivi;


procedure ControllaTariffeCampiEstivi
(
   prezzo in TARIFFECAMPIESTIVI.Prezzo%type default 0,
   etaMinima in TARIFFECAMPIESTIVI.Etaminima%type default 0,
   etaMassima in TARIFFECAMPIESTIVI.Etamassima%type default 0,
   campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type default 0
) 
is
   idSessione number(5) :=  modGUI1.get_id_sessione();
   type errorsTable is table of varchar2(32);
   errors errorsTable;
   errorsCount integer := 0;
   campoEstivoExists integer := 0;

BEGIN
   insert into TARIFFECAMPIESTIVI(IdTariffa, Prezzo, Etaminima, Etamassima, CampoEstivo, Eliminato)
      values (IdTariffaSeq.nextval, prezzo, etaMinima, etaMassima, campoEstivo, 0);
   if sql%found then
      commit;
       modGUI1.redirectesito('Inserimento Completato', null,
      'Inserisci una nuova tariffa',operazioniGruppo4.gr4||'InserisciTariffeCampiEstivi','?campoEstivo='||campoEstivo,
      'Menu Tariffe',operazioniGruppo4.gr4||operazioniGruppo4.menu_t, '?idCampo='||campoEstivo);
   end if;
   exception when others then
       modGUI1.redirectesito('Inserimento Fallito', null,
      'Riprova',operazioniGruppo4.gr4||'InserisciTariffeCampiEstivi',null,
      'Menu Tariffe',operazioniGruppo4.gr4||operazioniGruppo4.menu_t,'?idCampo='||campoEstivo);
end ControllaTariffeCampiEstivi;

procedure VisualizzaTariffeCampiEstivi
(
   Tariffa in TARIFFECAMPIESTIVI.IdTariffa%type
) 
is
   sessionId number(5):=modGUI1.get_id_sessione();
   tariffe TARIFFECAMPIESTIVI%rowtype;
   nomecampo CAMPIESTIVI.Nome%type;
BEGIN
   select *
   into tariffe
   from TARIFFECAMPIESTIVI
   where TARIFFECAMPIESTIVI.IdTariffa = Tariffa;   

   htp.htmlopen;
   modGUI1.apripagina('Visualizza Tariffe');
   modGUI1.header();
   htp.bodyopen;
   htp.br;htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 align="center">Tariffa campo estivo</h1>');
   modGUI1.apridiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
   modGUI1.collegamento('X',operazioniGruppo4.gr4||operazioniGruppo4.menu_t||'?idCampo='||tariffe.campoEstivo,' w3-btn w3-large w3-red w3-display-topright');


   htp.tableopen(CALIGN =>'CENTER',CATTRIBUTES =>'class="w3-table"');
      htp.tablerowopen;
      htp.tabledata('idTariffa: ',CATTRIBUTES  =>'style="font-weight:bold"');
      htp.tabledata(tariffe.idtariffa);
      htp.tablerowclose;
      htp.tablerowopen;
      htp.tabledata('Prezzo: ',CATTRIBUTES  =>'style="font-weight:bold"');
      htp.tabledata(tariffe.Prezzo||' €');
      htp.tablerowclose;
      htp.tablerowopen;
      htp.tabledata('Etaminima: ',CATTRIBUTES  =>'style="font-weight:bold"');
      htp.tabledata(tariffe.Etaminima);
      htp.tablerowclose;
      htp.tablerowopen;
      htp.tabledata('Etamassima: ',CATTRIBUTES  =>'style="font-weight:bold"');
      htp.tabledata(tariffe.Etamassima);
      htp.tablerowclose;
      htp.tablerowopen;
      Select Nome
      into nomecampo
      from CAMPIESTIVI,TARIFFECAMPIESTIVI
      where TARIFFECAMPIESTIVI.CAMPOESTIVO=IDCAMPIESTIVI AND TARIFFECAMPIESTIVI.IDTARIFFA=Tariffa;
      htp.tabledata('Campo Estivo: ',CATTRIBUTES  =>'style="font-weight:bold"');
      htp.tabledata(nomecampo);
      htp.tablerowclose;
   htp.tableclose;
   if hasrole(sessionId,'DBA') or hasrole(sessionId,'GCE')
   then
      modGUI1.APRIDIV('class="w3-center "');
      modGUI1.Collegamento('visualizza pagamenti',operazioniGruppo4.gr4||'PagamentoCampiEstivi?tariffaid='||tariffe.IdTariffa,'w3-black w3-margin w3-button w3-round');
      modGUI1.chiudiDiv;
      modGUI1.chiudiDiv;
   end if;
   htp.bodyclose;
   htp.htmlclose;

end; 

procedure ModificaTariffeCampiEstivi
(
    up_idTariffa in TARIFFECAMPIESTIVI.IdTariffa%type
) is 
    idSessione number(5) :=  modGUI1.get_id_sessione();
    tariffa TariffecampiEstivi%rowtype;
BEGIN
    select * into tariffa from tariffecampiestivi where idtariffa = up_idTariffa;
     modGUI1.apripagina('Modifica Tariffa CampiEstivi', idSessione);
     modGUI1.header;
    htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
     modGUI1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px" ');
         modGUI1.apridiv('class="w3-section"');
             modGUI1.collegamento('X',operazioniGruppo4.gr4||operazioniGruppo4.menu_t||'?idCampo='||tariffa.CampoEstivo,' w3-btn w3-large w3-red w3-display-topright');
            htp.br;
            htp.header(2, 'Tariffa', 'center');
             modGUI1.apriform(operazioniGruppo4.gr4||'AggiornaTariffeCampiEstivi');
               htp.formhidden('up_idTariffa', tariffa.idtariffa);
               modGUI1.label('Prezzo');
               modGUI1.inputtext('up_prezzo', 'up_prezzo', 1, tariffa.prezzo);
               htp.br;
               modGUI1.label('Eta minima');
               modGUI1.inputtext('up_etaMinima', 'up_etaMinima', 1, tariffa.etaMinima);
               htp.br;
               modGUI1.label('Eta massima');
               modGUI1.inputtext('up_etaMassima', 'up_etaMassima', 1, tariffa.etaMassima);
               htp.br;
               modGUI1.label('Campo Estivo');
               modGUI1.selectopen('up_campoEstivo');
               for campoEstivo in
                  (select IdCampiEstivi, nome from campiestivi where IdCampiEstivi = tariffa.campoEstivo)
               loop
                   modGUI1.selectoption(campoEstivo.IdCampiEstivi, campoEstivo.nome);
               end loop;
               for campoEstivo in
                  (select IdCampiEstivi, nome from campiestivi where IdCampiEstivi <> tariffa.campoEstivo)
               loop
                  modGUI1.selectoption(campoEstivo.IdCampiEstivi, campoEstivo.nome);
               end loop;
               modGUI1.selectclose;
               htp.br;
               modGUI1.inputsubmit('Aggiorna');
             modGUI1.chiudiform;
         modGUI1.chiudidiv;
     modGUI1.chiudidiv;
end;

procedure AggiornaTariffeCampiEstivi
(
    up_idTariffa number default 0, 
    up_prezzo in TARIFFECAMPIESTIVI.Prezzo%type default 0,
    up_etaMinima in TARIFFECAMPIESTIVI.Etaminima%type default 0,
    up_etaMassima in TARIFFECAMPIESTIVI.Etamassima%type default 0,
    up_campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type default 0 
)
is
   idSessione number(5) :=  modGUI1.get_id_sessione();
BEGIN
   if up_etaminima > up_etamassima
   or up_prezzo < 0
   or up_etaminima < 0
   or up_campoEstivo is null
   or up_campoEstivo = 0
   then
       modGUI1.redirectesito('Parametri invalidi', 
      'Errore: paramtri aggiornamento tariffa campi estivi non validi', 
      'Torna alla modifica', operazioniGruppo4.gr4||'ModificaTariffeCampiEstivi', 
      '?up_idTariffa='|| up_idTariffa, 
      'Torna al menu', operazioniGruppo4.gr4||operazioniGruppo4.menu_t,'?idCampo='|| up_campoEstivo);
   end if;

   update tariffecampiestivi set
      prezzo = up_prezzo, 
      etaminima = up_etaMinima, 
      etamassima = up_etaMassima, 
      campoestivo = up_campoEstivo
   where idtariffa = up_idTariffa;
   commit;
    modGUI1.redirectesito('Aggiornamento riuscito', null, null, null, null, 
      'Torna al menu', operazioniGruppo4.gr4||operazioniGruppo4.menu_t,'?idCampo='|| up_campoEstivo);
   exception when others then
       modGUI1.redirectesito('Aggiornamento fallito', 
      'Errore: sconosciuto', 
      'Torna alla modifica', operazioniGruppo4.gr4||'ModificaTariffeCampiEstivi', 
      '?up_idTariffa='|| up_idTariffa, 
      'Torna al menu', operazioniGruppo4.gr4||operazioniGruppo4.menu_t,'?idCampo='|| up_campoEstivo);
end;

procedure form1tariffe
(
   campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type,
   Data1 in  varchar2,
   Data2 in  varchar2
)
is 
CURSOR cur IS Select CAMPIESTIVI.IDCAMPIESTIVI,CAMPIESTIVI.NOME
                        FROM CAMPIESTIVI;
BEGIN
htp.htmlOpen;
  modGUI1.ApriPagina('Tariffe Campi Estivi');
  modGUI1.HEADER();
  htp.BODYOPEN();
  htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
   
  htp.prn('<h1 align="center">Storico Pagamenti</h1>');
  modGUI1.apridiv('class="w3-modal-content w3-card-4" style="max-width:600px; margin-top:110px"');
  modGUI1.Collegamento('M',operazioniGruppo4.gr4||operazioniGruppo4.menu_ce,'w3-btn  w3-black w3-display-topright ');
  modGUI1.ApriForm(operazioniGruppo4.gr4||'monitoratariffeAnno','invia','w3-container'); 
  
   htp.br;
   modGUI1.LABEL('Seleziona il Periodo:');
   htp.br;
   htp.FORMHIDDEN('campoEstivo',campoEstivo);
   modGUI1.LABEL('Da');
    modGUI1.InputDate('Data1', 'Data1', 1, Data1);
   htp.br;
   modGUI1.LABEL('a');
    modGUI1.InputDate('Data2', 'Data2', 1, Data2);
   htp.br;
   htp.br;htp.br;htp.br;
   modGUI1.INPUTSUBMIT('invia');
 
  modGUI1.ChiudiForm;
  modGUI1.ChiudiDiv();
  htp.htmlClose;
end;

procedure preferenzaTariffa
(
   campoid in TARIFFECAMPIESTIVI.CampoEstivo%type
)
 is 
   tarif TariffecampiEstivi%rowtype;
   found number := 0;
BEGIN
    /*tariffa piu gettonata per ogni campoEstivo*/
   htp.htmlopen;
   modGUI1.apripagina();
   modGUI1.header();
   htp.bodyopen;
   
   htp.br;htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 align="center">Tariffa preferita</h1>');
    modGUI1.apridiv('class="w3-center"');
   modGUI1.Collegamento('menu',operazioniGruppo4.gr4||menu_t||'?idCampo='||campoid,'w3-btn w3-round-xxlarge w3-black ');
    modGUI1.chiudidiv;
   htp.br;htp.br;
    modGUI1.apridiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
   htp.tableopen(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"');
   htp.tablerowopen;
   htp.TableData('IdTariffa',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
   htp.TableData('Età Minima',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
   htp.TableData('Età Massima',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
   htp.TableData('Prezzo',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
   htp.TableData('N° acquisti',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
   htp.TableData('info',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
   htp.tablerowclose;

   if campoid = 0 then /*campo estivo non specificato*/
      for tariffa in (
         select Tariffa, count(*) as conto
         from PAGAMENTICAMPIESTIVI
         group by Tariffa
         having count(*) = (
               select max(subconto) from (
                  select count(*) as subconto
                  from PAGAMENTICAMPIESTIVI
                  group by Tariffa
               )
         )
      )
      loop
      select *
         into tarif
         from TARIFFECAMPIESTIVI
         where TARIFFECAMPIESTIVI.IDTARIFFA=tariffa.TARIFFA;

         htp.tablerowopen;
         htp.tabledata(tarif.IdTariffa,CATTRIBUTES  =>'style="text-align:center"');
         htp.tabledata(tarif.Etaminima,CATTRIBUTES  =>'style="text-align:center"');
         htp.tabledata(tarif.Etamassima,CATTRIBUTES  =>'style="text-align:center"');
         htp.tabledata(tarif.Prezzo ||' €',CATTRIBUTES  =>'style="text-align:center"');
         htp.tabledata(tariffa.conto,CATTRIBUTES  =>'style="text-align:center"');
         htp.tabledata('<a href="'|| Costanti.server || Costanti.radice || operazioniGruppo4.gr4||'VisualizzaTariffeCampiEstivi?'||'Tariffa='||tarif.IDTARIFFA||'"'||'class="w3-black w3-round w3-margin w3-button"'||'>'||'Dettagli'||'</a>');
         htp.tablerowclose;
      end loop;
   else /*campo estivo specificato*/
      for tariffa in (
         select Tariffa, count(*) as conto
         from PAGAMENTICAMPIESTIVI join tariffecampiestivi 
         on PAGAMENTICAMPIESTIVI.tariffa = tariffecampiestivi.idTariffa
         where tariffecampiestivi.campoestivo = campoid
         group by Tariffa
         having count(*) = (
               select max(subconto) from (
                  select count(*) as subconto
                  from PAGAMENTICAMPIESTIVI,TARIFFECAMPIESTIVI
                  where tariffecampiestivi.campoestivo = campoid AND   PAGAMENTICAMPIESTIVI.tariffa = tariffecampiestivi.idTariffa
                  group by Tariffa
               )
         )
      )
      loop
         select *
         into tarif
         from TARIFFECAMPIESTIVI
         where TARIFFECAMPIESTIVI.IDTARIFFA=tariffa.TARIFFA;

         htp.tablerowopen;
         htp.tabledata(tarif.IdTariffa,CATTRIBUTES  =>'style="text-align:center"');
         htp.tabledata(tarif.Etaminima,CATTRIBUTES  =>'style="text-align:center"');
         htp.tabledata(tarif.Etamassima,CATTRIBUTES  =>'style="text-align:center"');
         htp.tabledata(tarif.Prezzo,CATTRIBUTES  =>'style="text-align:center"');
         htp.tabledata(tariffa.conto,CATTRIBUTES  =>'style="text-align:center"');
         htp.tabledata('<a href="'|| Costanti.server || Costanti.radice || operazioniGruppo4.gr4||'VisualizzaTariffeCampiEstivi?'||'Tariffa='||tarif.IDTARIFFA||'"'||'class="w3-black w3-round w3-margin w3-button"'||'>'||'Dettagli'||'</a>');
         htp.tablerowclose;
      end loop;
   end if;
   htp.tableclose;
    modGUI1.chiudidiv;
   
   htp.bodyclose;
   htp.htmlclose;


end;

procedure monitoratariffeAnno
(
   campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type,
   Data1 in  varchar2,
   Data2 in  varchar2
) is
   newdata1 DATE:=TO_DATE(Data1 default NULL on conversion error, 'YYYY-MM-DD');
   newdata2 DATE:=TO_DATE(Data2 default NULL on conversion error, 'YYYY-MM-DD');
BEGIN
   htp.htmlopen;
   modGUI1.apripagina();
   modGUI1.header();
   
   htp.bodyopen;
   htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
   if newdata1>newdata2
   then
      modGUI1.apridiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
      MODGUI1.APRIFORM(operazioniGruppo4.gr4||'form1Tariffe');
      htp.FORMHIDDEN('campoEstivo',campoEstivo);
      htp.FORMHIDDEN('Data1',Data1);
      htp.FORMHIDDEN('Data2',Data2);
      MODGUI1.INPUTSUBMIT('Indietro');
      MODGUI1.ChiudiForm;
      MODGUI1.chiudiDiv;
   else
      htp.prn('<h1 align="center">Storico Pagamenti</h1>');
      modGUI1.apridiv('class="w3-center"');
      modGUI1.Collegamento('menu',operazioniGruppo4.gr4||menu_ce,'w3-btn w3-round-xxlarge w3-black ');
      htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
      modGUI1.Collegamento('indietro',operazioniGruppo4.gr4||'form1tariffe?&campoEstivo='||campoEstivo||'&Data1='||Data1||'&Data2='||Data2,'w3-btn w3-round-xxlarge w3-black ');
      modGUI1.chiudidiv;
      htp.br;htp.br;
      modGUI1.apridiv('class="w3-modal-content w3-card-4" style="max-width:1000px"');
      HTP.TABLEOPEN(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"' );
         HTP.TableRowOpen;
         HTP.TableData('Tariffa',CATTRIBUTES  =>'style="font-weight:bold"');
         HTP.TableData('Eta Minima',CATTRIBUTES  =>'style="font-weight:bold"');
         HTP.TableData('Eta Massima',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
         HTP.TableData('Prezzo',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
         HTP.TableData('Acquirente',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
         HTP.TableData('Data Pagamento',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      for tariffa in 
      (
         select TARIFFA, DATAPAGAMENTO,ETAMINIMA,ETAMASSIMA,PREZZO,UTENTI.NOME,UTENTI.COGNOME
         from PAGAMENTICAMPIESTIVI,TARIFFECAMPIESTIVI,CAMPIESTIVI,UTENTI
         where DATAPAGAMENTO>newdata1 AND DATAPAGAMENTO<newdata2 AND PAGAMENTICAMPIESTIVI.TARIFFA=TARIFFECAMPIESTIVI.IDTARIFFA AND CAMPIESTIVI.IDCAMPIESTIVI=campoEstivo AND PAGAMENTICAMPIESTIVI.ACQUIRENTE=UTENTI.IDUTENTE
         order by DATAPAGAMENTO
      )
      loop
         htp.tablerowopen;
         htp.tabledata(tariffa.Tariffa,CATTRIBUTES  =>'style="text-align:center"');
         htp.tabledata(tariffa.ETAMINIMA,CATTRIBUTES  =>'style="text-align:center"');
         htp.tabledata(tariffa.ETAMASSIMA,CATTRIBUTES  =>'style="text-align:center"');
         htp.tabledata(tariffa.PREZZO||' €',CATTRIBUTES  =>'style="text-align:center"');
         htp.tabledata(tariffa.NOME ||' '||tariffa.COGNOME,CATTRIBUTES  =>'style="text-align:center"');
         htp.tabledata(tariffa.DataPagamento,CATTRIBUTES  =>'style="text-align:center"');
         htp.tablerowclose;
      end loop;

      htp.tableclose;
   end if;
   htp.bodyclose;
   htp.htmlclose;
end;

procedure Utentipagamenti
(
   pagamentoid in PagamentiCampiEstivi.idpagamento%type
)
is 
tarif TARIFFECAMPIESTIVI.IDTARIFFA%type;
BEGIN

   select TARIFFA
   into tarif
   from PAGAMENTICAMPIESTIVI
   where PAGAMENTICAMPIESTIVI.IDPAGAMENTO=pagamentoid;

    modGUI1.apripagina('Pagamento Utenti');
    modGUI1.header();
   htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 align="center">Utenti coinvolti nel pagamento</h1>');
   htp.br;
    modGUI1.apridiv('class="w3-center"');
   modGUI1.Collegamento('indietro',operazioniGruppo4.gr4||'Pagamentocampiestivi?tariffaid='||tarif,'w3-btn w3-round-xxlarge w3-black ');
    modGUI1.chiudidiv;
   htp.br;
    modGUI1.apridiv('class="w3-modal-content w3-card-4" style="max-width:600px"');

   HTP.TABLEOPEN(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"' );
   HTP.TableRowOpen;
   HTP.TableData('Nome',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
   HTP.TableData('Cognome',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
   HTP.TableData('Data di Nascita',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
   HTP.TableData('Indirizzo',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
   HTP.tableRowClose;
   for utente in (
      select  Nome,Cognome,DataNascita, Indirizzo 
      from UTENTIPAGAMENTI,UTENTI
      where UTENTIPAGAMENTI.IDPAGAMENTO=pagamentoid AND UTENTIPAGAMENTI.IDUTENTE=UTENTI.IDUTENTE
    )
   loop
      htp.tablerowopen;
      htp.tabledata(utente.Nome,CATTRIBUTES  =>'style="text-align:center"');
      htp.tabledata(utente.Cognome,CATTRIBUTES  =>'style="text-align:center"');
      htp.tabledata(utente.DataNascita,CATTRIBUTES  =>'style="text-align:center"');
      htp.tabledata(utente.Indirizzo,CATTRIBUTES  =>'style="text-align:center"');
      htp.tablerowclose;
   end loop;

   HTP.TABLECLOSE;
    modGUI1.chiudidiv();


end;
/*BUTTON PER Aggiorane lo stato*/
PROCEDURE checkData -- increazione -> incorso | incorso -> terminato
    -- shoud be the same as CAMPIESTIVI.DataInizio%TYPE
IS
   v_dataCorrente  DATE;
BEGIN
    SELECT SYSTIMESTAMP -- SYSDATE is an alternative
    INTO v_dataCorrente
    FROM DUAL;

    -- change campi that are increazione to incorso
    -- if (datainizio < v_dataCorrente < dataconclusione)
    UPDATE CAMPIESTIVI
    SET stato = 'incorso'
    WHERE 
	   datainizio IS NOT NULL
	  AND dataconclusione IS NOT NULL
	  AND eliminato = 0
	  AND datainizio <= v_dataCorrente
	  AND dataconclusione >= v_dataCorrente;

    UPDATE CAMPIESTIVI
    SET stato = 'terminato'
    WHERE 
    	  datainizio IS NOT NULL
	  AND dataconclusione IS NOT NULL
	  AND eliminato = 0
	  AND datainizio <= v_dataCorrente
	  AND dataconclusione <= v_dataCorrente;
END;


PROCEDURE checkDataButton 
IS
BEGIN

    modgui1.Bottone('w3-red', 'Controlla Date Campi Estivi', 'checkDate', 'checkDateFun(this);');
    htp.prn('
    <script>
	var checkDateFun = async function(sel) {
	    await fetch ("' || costanti.server || costanti.radice || OperazioniGruppo4.gr4||'checkData");
	    sel.classList.toggle("w3-red");
	    sel.classList.toggle("w3-gray");
       location.reload();
	}
    </script>
    ');
END;
end operazioniGruppo4;
-- SET DEFINE ON;