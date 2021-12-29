SET DEFINE OFF;
Create or replace PACKAGE body operazioniGruppo4 as
/*visualizza tutti i campi estivi*/
/*
 * OPERAZIONI SUI MUSEI
 * - Inserimento ✅
 * - Modifica ✅
 * - Visualizzazione ✅ 
 * - Cancellazione (rimozione) ❌(da non fare)
 * OPERAZIONI STATISTICHE E MONITORAGGIO
 * - Sale presenti ✅
 * - Opere presenti nel Museo ✅
 * - Opere in prestito al Museo ✅
 * - Numero visitatori unici in un arco temporale scelto ✅
 * - Numero medio visitatori in un arco temporale scelto ✅(da aggiustare)
 * -Introiti museo (sia ottenuti attraverso vendita di biglietti e abbonamenti
che attraverso campi estivi, potendo opportunamente decidere uno, due
o entrambi i casi) ✅(da completare)
 */

/*
 * OPERAZIONI SUI CAMPI ESTIVI
 * - Inserimento ✅ da modificare
 * - Modifica ✅ da modificare
 * - Visualizzazione ✅ 
 * - Cancellazione (rimozione) ❌ da aggiustare
 * OPERAZIONI STATISTICHE E MONITORAGGIO
 * - Numero iscritti ✅
 * - Utenti iscritti al campo Estivo ✅
 * - Tariffe che danno accesso al campo ✅
 * - Età media visitatori iscritti al Campo Estivo ✅ (da aggiustare)
 * - Introiti relativi ad un Museo tramite i Campi Estivi ✅ (Operazione compresa in Introtiti museo)
 */


 /*
 * OPERAZIONI SUI PAGAMENTI CAMPI ESTIVI
 * - Inserimento ✅
 * - Modifica ❌
 * - Visualizzazione ✅ 
 * - Cancellazione (rimozione) ❌
 * OPERAZIONI STATISTICHE E MONITORAGGIO
 * - Pagamenti effettuati ✅
 * - Utenti relativi ad un pagamento ✅
 * - Numero di pagamenti relativi ad una tariffa ✅
 */


 /*
 * OPERAZIONI SULLE TARIFFE CAMPI ESTIVI
 * - Inserimento ✅
 * - Modifica ❌
 * - Visualizzazione ✅ 
 * - Cancellazione (rimozione) ❌
 * OPERAZIONI STATISTICHE E MONITORAGGIO
 * - Preferenza Tariffa per ogni campo estivo ❌
 * - Lista Tariffe relative ad un anno scelto ✅
 * - Lista Tariffe relative ad un Campo Estivo scelto in ordine di prezzocrescente ✅
 
 */


procedure menutariffe
(
   idCampo IN number default 0
)
is 

begin 

 htp.prn('<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> ');
   modGUI1.ApriPagina(' Tariffe Campi Estivi');
   modGUI1.Header();
   htp.br;htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 Align="center"> Tariffe Campi Estivi</h1>');
    MODGUI1.APRIDIV('class="w3-col l4 w3-padding-large w3-left"');
   MODGUI1.APRIDIV('class="w3-center"');
   modGUI1.Collegamento('inserisci Tariffa',
                            'operazioniGruppo4.inserisciTariffeCampiEstivi?prezzo=&etaMinima=&etaMassima=&campoEstivo=',
                            'w3-black w3-round w3-margin w3-button');
   MODGUI1.ChiudiDiv();
   MODGUI1.ChiudiDiv();

   MODGUI1.APRIDIV('class="w3-col l4 w3-padding-large w3-center"');
   modGUI1.Collegamento('campi estivi','operazioniGruppo4.menucampiestivi','w3-btn w3-round-xxlarge w3-black ');
   MODGUI1.ChiudiDiv();

   MODGUI1.APRIDIV('class="w3-col l4 w3-padding-large w3-right"');
   MODGUI1.APRIDIV('class="w3-center"');
   modGUI1.Collegamento('Tariffe preferite',
                            'operazioniGruppo4.preferenzaTariffa?campoEstivo='||idCampo,
                            'w3-black w3-round w3-margin w3-button');
   MODGUI1.Chiudidiv();
   MODGUI1.Chiudidiv();
   
  
   modGUI1.ApriDiv('class="w3-row w3-container"');
    FOR tariffa IN (Select IdTariffa,Prezzo,Etaminima,Etamassima,CAMPOESTIVO,Eliminato from TARIFFECAMPIESTIVI where campoestivo=idCampo)
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
               modGUI1.Collegamento('Visualizza',
                            'operazioniGruppo4.VisualizzaTariffeCampiEstivi?Tariffa='||tariffa.idTariffa,
                            'w3-green w3-margin w3-button');
               modGUI1.Collegamento('Modifica',
                            'operazioniGruppo4.ModificaTariffeCampiEstivi?up_idTariffa='||tariffa.idTariffa,
                            'w3-red w3-margin w3-button');
                   htp.prn('<h1 Align="center" style="font-size:170%;">Pagamenti</h1>');
                     modGUI1.Collegamento('inserisci pagamento',
                            'operazioniGruppo4.InserisciPagamentoCampiEstivi?datapagamento=&tariffa='||tariffa.IdTariffa||'&acquirente=',
                            'w3-green w3-margin w3-button');
                    modGUI1.Collegamento('visualizza pagamenti',
                            'operazioniGruppo4.PagamentoCampiEstivi?idtariffa='||tariffa.IdTariffa,
                            'w3-red w3-margin w3-button');
                   
                modgui1.ChiudiDiv;
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
    END LOOP;
    modGUI1.chiudiDiv;
   end;

procedure menucampiestivi
   is
   sessionid NUMBER(5):=MODGUI1.get_id_sessione();
   begin
   htp.prn('<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> ');
   modGUI1.ApriPagina('Campi Estivi');
   modGUI1.Header();
   htp.br;htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 Align="center" style="font-size:60px">Campi Estivi</h1>');
   if hasRole(sessionid,'DBA') or hasRole(sessionid,'GCE')
   then
      MODGUI1.APRIDIV('class="w3-col l4 w3-padding-large w3-left"');
      htp.prn('<h1 Align="center">Inserimento</h1>');
      MODGUI1.APRIDIV('class="w3-center"');
      modGUI1.Collegamento('inserisci Campo Estivo',OperazioniGruppo4.gr4 ||'inseriscicampiestivi?newNome=&newMuseo=&newDatainizio=&newDataConclusione=','w3-black w3-round w3-margin w3-button');
      MODGUI1.ChiudiDiv();
      MODGUI1.ChiudiDiv();

      MODGUI1.APRIDIV('class="w3-col l4 w3-padding-large w3-right"');
      htp.prn('<h1 Align="center">Statistiche</h1>');
      MODGUI1.APRIDIV('class="w3-center"');
      modGUI1.Collegamento('Statistiche',OperazioniGruppo4.gr4 || 'form1campiestivi?&CampoestivoId=&NameCampoestivo=','w3-black w3-round w3-margin w3-button');
      MODGUI1.ChiudiDiv();
      MODGUI1.ChiudiDiv();
   end if;
   modGUI1.ApriDiv('class="w3-row w3-container"');
   
    FOR campo IN (Select IdCampiEstivi,Nome,Stato,DataInizio,DataConclusione,Museo from CAMPIESTIVI)
    LOOP
        modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
            modGUI1.ApriDiv('class="w3-card-4" style="height:450px;"');
                modGUI1.ApriDiv('class="w3-container w3-center"');
               
                  HTP.TABLEOPEN(CALIGN  => 'center' );
                  HTP.TableRowOpen;
                  HTP.TableData('Nome',CATTRIBUTES  =>'style="font-weight:bold; text-align: center"');
                  HTP.TableData('Stato',CATTRIBUTES  =>'style="font-weight:bold; text-align: center"');
                  HTP.TableData('Data Inizio',CATTRIBUTES  =>'style="font-weight:bold; text-align: center"');
                  HTP.TableData('Data Conclusione',CATTRIBUTES  =>'style="font-weight:bold; text-align: center"');
                  HTP.TableData('Museo',CATTRIBUTES  =>'style="font-weight:bold; text-align: center"');
                  HTP.TableRowClose;

                  HTP.TableRowOpen;
                  HTP.TableData(campo.Nome ,'center');
                  HTP.TableData(campo.Stato,'center');
                  HTP.TableData(campo.DataInizio,'center');
                  HTP.TableData(campo.DataConclusione,'center');
                  HTP.TableData(campo.Museo,'center');
      
                  HTP.TableRowClose;
    
                  HTP.TableClose;
               modGUI1.ChiudiDiv;
               if hasRole(sessionid,'DBA') or hasRole(sessionid,'GCE')      
               then
                  modGUI1.Collegamento('Visualizza',OperazioniGruppo4.gr4 ||'visualizzacampiestivi?campiestiviId='||campo.IdCampiEstivi,'w3-green w3-margin w3-button');
                  MODGUI1.COLLEGAMENTO('Modifica',OperazioniGruppo4.gr4 ||'modificacampiestivi?idcampo='||campo.IDCAMPIESTIVI ||'&newNome=' ||campo.Nome ||'&newDatainizio='||campo.DataInizio||'&newDataConclusione='||campo.DataConclusione,'w3-red w3-round w3-margin w3-button');
               end if;
               if hasRole(sessionid,'DBA')
               then
                  htp.prn('<button onclick="document.getElementById(''Elimcampo'||campo.IdCampiEstivi||''').style.display=''block''" class="w3-margin w3-button w3-black w3-hover-white">Elimina</button>');
                  OperazioniGruppo4.eliminacampo(campo.IdCampiEstivi);
               end if;
               htp.prn('<h1 Align="center" style="font-size:170%;">Tariffe-Pagamenti</h1>');
               modGUI1.Collegamento('tariffe',OperazioniGruppo4.gr4 ||'menutariffe?idCampo='||campo.IdCampiEstivi,'w3-red w3-margin w3-button');
               if hasRole(sessionid,'DBA') or hasRole(sessionid,'GCE')
               then
                  modGUI1.Collegamento('storico pagamenti',OperazioniGruppo4.gr4 ||'form1tariffe?campoEstivo='||campo.IdCampiEstivi||'&Data1=&Data2=','w3-black w3-round w3-margin w3-button');
               end if;
               modgui1.ChiudiDiv;
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
    END LOOP;
    modGUI1.chiudiDiv; 
   end;
   /*Funzione che genera il form d'inserimento*/
procedure inseriscicampiestivi
(
   newNome in CAMPIESTIVI.Nome%TYPE default null,
   newMuseo in Musei.Nome%TYPE,
   newDatainizio in VARCHAR2 default null,
   newDataConclusione in VARCHAR2 default null
)
is
CURSOR cur IS Select MUSEI.IDMUSEO, MUSEI.NOME
                        FROM MUSEI;
BEGIN
   htp.htmlOpen;
   modGUI1.ApriPagina();
   modGUI1.Header();
   htp.bodyOpen;
   htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;  
   htp.prn('<h1 align="center">Inserimento Campi Estivi</h1>');
   modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
   modGUI1.Collegamento('M','operazioniGruppo4.menucampiestivi','w3-btn  w3-black w3-display-topright ');
   modGUI1.ApriForm(operazioniGruppo4.gr4||'confermacampiestivi','invia','w3-container');
   MODGUI1.LABEL('Nome');
   modgui1.INPUTTEXT('newNome','Nome',1,newNome);
   htp.br;  
   MODGUI1.LABEL('Nome Museo');
   MODGUI1.SelectOpen('newMuseo',newMuseo);
   FOR Mus_cur IN cur LOOP
    MODGUI1.SelectOption(Mus_cur.NOME,Mus_cur.NOME);
  END LOOP;
  MODGUI1.SelectClose;
   htp.br;  
   MODGUI1.LABEL('Data Inizio');
   modGUI1.InputDate('newDatainizio','newDatainizio',0,newDatainizio);
   htp.br;
   MODGUI1.LABEL('DataConclusione');
   modGUI1.InputDate('newDataConclusione','newDataConclusione',0,newDataConclusione);
   htp.br;
   htp.br;
   modgui1.INPUTSUBMIT('Invia');
   modgui1.ChiudiForm;
   modgui1.ChiudiDiv;
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
   modgui1.APRIPAGINA('Viusalizza Campi Estivi');
   modgui1.HEADER();
   htp.bodyopen();
   htp.br;htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 align="center">Inserimento Campi Estivi</h1>');
   modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
   if (newNome is null) or (newMuseo is null) 
      then MODGUI1.LABEL('Parametri inseriti in maniera errata');
      MODGUI1.ApriForm(operazioniGruppo4.gr4||'inseriscicampiestivi');
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newMuseo',  newMuseo);
      HTP.FORMHIDDEN('newDatainizio',newDatainizio);
      HTP.FORMHIDDEN('newDataConclusione',newDataConclusione);
      MODGUI1.InputSubmit('indietro');
      MODGUI1.ChiudiForm;
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
      MODGUI1.ApriForm(operazioniGruppo4.gr4||'controllacampiestivi');
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newMuseo',  newMuseo);
      HTP.FORMHIDDEN('newDatainizio',newDatainizio);
      HTP.FORMHIDDEN('newDataConclusione',newDataConclusione);
      MODGUI1.InputSubmit('Conferma');
      MODGUI1.ChiudiForm;
      MODGUI1.ApriForm(operazioniGruppo4.gr4||'inseriscicampiestivi');
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newMuseo',  newMuseo);
      HTP.FORMHIDDEN('newDatainizio',newDatainizio);
      HTP.FORMHIDDEN('newDataConclusione',newDataConclusione);
      MODGUI1.InputSubmit('Annulla');
      MODGUI1.ChiudiForm;
      MODGUI1.ChiudiDiv;
     
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
   where Musei.NOME=newNome;
   htp.htmlOpen;
   modgui1.APRIPAGINA('Campi Estivi');
   modgui1.HEADER();
   htp.bodyopen();
    htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
     insert into CAMPIESTIVI VALUES (IDCAMPIESTIVISEQ.NEXTVAL,newStato,newNome,v_dateini,v_datefin,newidMuseo,0);
   MODGUI1.RedirectEsito('Inserimento completato',newNome,'Inserisci un nuovo campo estivo',operazioniGruppo4.gr4||'inseriscicampiestivi?','//newNome='||newNome||'//newMuseo='||newMuseo||'//newDatainizio='||newDataInizio||'//newDataConclusione='||newDataConclusione,'Torna al menu','operazioniGruppo4.menucampiestivi',null);
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

   modgui1.apripagina();
   modgui1.header();
   htp.br;htp.br;htp.br;htp.br;htp.br;
   modgui1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');

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

   modGUI1.Collegamento('menù','operazioniGruppo4.menucampiestivi','w3-btn w3-round-xxlarge w3-black ');
   modgui1.ChiudiDiv();

END visualizzacampiestivi;

procedure modificacampiestivi
(
   idcampo in CAMPIESTIVI.IDCAMPIESTIVI%TYPE default null,
   newNome in CAMPIESTIVI.Nome%TYPE default null,
   newDatainizio in VARCHAR2 default null,
   newDataConclusione in VARCHAR2 default null
)
is
begin 
   htp.htmlOpen;
   modGUI1.ApriPagina();
   modGUI1.Header();
   htp.bodyOpen;
   htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;  
   htp.prn('<h1 align="center">Modifica Campi Estivi</h1>');
   modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
   modGUI1.Collegamento('M','operazioniGruppo4.menucampiestivi','w3-btn  w3-black w3-display-topright ');
   modGUI1.ApriForm(operazioniGruppo4.gr4||'confermamodificacampo','invia','w3-container');
   htp.FORMHIDDEN('idcampo',idcampo);
   MODGUI1.LABEL('Nome');
   modgui1.INPUTTEXT('newNome','Nome',1,newNome);
   htp.br;  
   MODGUI1.LABEL('Data Inizio');
   modGUI1.InputDate('newDatainizio','newDatainizio',1,newDatainizio);
   htp.br;
   MODGUI1.LABEL('DataConclusione');
   modGUI1.InputDate('newDataConclusione','newDataConclusione',0,newDataConclusione);
   htp.br;
   htp.br;
   modgui1.INPUTSUBMIT('modifica');
   modgui1.ChiudiForm;
   modgui1.ChiudiDiv;
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
   newidMuseo CAMPIESTIVI.MUSEO%TYPE;
   v_dateini Date:= TO_DATE(newDatainizio default NULL on conversion error, 'YYYY-MM-DD');
   v_datefin Date:= TO_DATE(newDataConclusione default NULL on conversion error, 'YYYY-MM-DD');
BEGIN
   htp.htmlOpen;
   modgui1.APRIPAGINA('Conferma Campi Estivi');
   modgui1.HEADER();
   htp.bodyopen();
   htp.br;htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 align="center">Modifica Campo Estivo</h1>');
   modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
   if (newNome is null) 
      then MODGUI1.LABEL('Parametri inseriti in maniera errata');
      MODGUI1.ApriForm(operazioniGruppo4.gr4||'modificacampiestivi');
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newDatainizio',newDatainizio);
      HTP.FORMHIDDEN('newDataConclusione',newDataConclusione);
      MODGUI1.InputSubmit('indietro');
      MODGUI1.ChiudiForm;
   else
      htp.tableopen(CALIGN =>'CENTER');
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
      MODGUI1.ApriForm(operazioniGruppo4.gr4||'updatecampi');
      HTP.FORMHIDDEN('idcampo',idcampo);
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newDatainizio',newDatainizio);
      HTP.FORMHIDDEN('newDataConclusione',newDataConclusione);
      MODGUI1.InputSubmit('Conferma');
      MODGUI1.ChiudiForm;
      MODGUI1.ApriForm(operazioniGruppo4.gr4||'modificacampiestivi');
      HTP.FORMHIDDEN('idcampo',idcampo);
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newDatainizio',newDatainizio);
      HTP.FORMHIDDEN('newDataConclusione',newDataConclusione);
      MODGUI1.InputSubmit('Annulla');
      MODGUI1.ChiudiForm;
      MODGUI1.ChiudiDiv;
     
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
begin
MODGUI1.ApriPagina('campo');
MODGUI1.HEADER();
htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
UPDATE CAMPIESTIVI SET
		Nome=newNome,
      DataInizio=v_dateini,
		DataConclusione=v_datefin
	WHERE idcampo=idcampiestivi;
MODGUI1.RedirectEsito('Modifica riuscita','Campo Estivo modificato correttamente',null,null,null,'Torna al menu dei campiestivi','operazioniGruppo4.menucampiestivi',null);

end updatecampi;

procedure eliminacampo
(
   idcampo in CAMPIESTIVI.IDCAMPIESTIVI%TYPE 
)
is 
var1 VARCHAR2(100);
idSessione NUMBER(5) := modgui1.get_id_sessione();
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
MODGUI1.RedirectEsito('Eliminazione riuscita','Campo Estivo eliminato correttamente',null,null,null,'Torna al menu dei campiestivi','operazioniGruppo4.menucampiestivi',null);

END;


/*--------------------------------------------------------------MUSEI-----------------------------------------*/

procedure menumusei
   is
   sessionid NUMBER(10):=MODGUI1.get_id_sessione();
   begin
   htp.prn('<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> ');
   modGUI1.ApriPagina('MUSEI');
   modGUI1.Header();
   htp.br;htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 Align="center">Musei</h1>');
   if hasRole(sessionid,'DBA')
   then
      MODGUI1.APRIDIV('class="w3-col l4 w3-padding-large w3-left"');
      htp.prn('<h1 Align="center">Inserimento</h1>');
      MODGUI1.APRIDIV('class="w3-center"');
      modGUI1.Collegamento('inserisci Musei','operazioniGruppo4.inseriscimuseo?newNome=&newIndirizzo=','w3-black w3-round w3-margin w3-button');
      MODGUI1.ChiudiDiv();
      MODGUI1.ChiudiDiv();
   end if;
   if hasRole(sessionid,'DBA') or hasRole(sessionid,'GM')
   then
      MODGUI1.APRIDIV('class="w3-col l4 w3-padding-large w3-right"');
      htp.prn('<h1 Align="center">Statistiche</h1>');
      MODGUI1.APRIDIV('class="w3-center"');
      modGUI1.Collegamento('Statistiche1','operazioniGruppo4.form1monitoraggio?MuseoId=&NameMuseo=','w3-black w3-round w3-margin w3-button');
      modGUI1.Collegamento('Statistiche2','operazioniGruppo4.form2monitoraggio?MuseoId=&NameMuseo=&Data1=&Data2=','w3-black w3-round w3-margin w3-button');
      MODGUI1.ChiudiDiv();
      MODGUI1.ChiudiDiv();
   end if;
   modGUI1.ApriDiv('class="w3-row w3-container"');
    FOR museo IN (Select IdMuseo,Nome,Indirizzo from MUSEI)
    LOOP
        modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
            modGUI1.ApriDiv('class="w3-card-4" style="height:600px;"');
                htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%;">');
                modGUI1.ApriDiv('class="w3-container w3-center"');
                  HTP.TABLEOPEN(CALIGN  => 'center' );
                  HTP.TableRowOpen;
                  HTP.TableData('Nome',CATTRIBUTES  =>'style="font-weight:bold; text-align: center"');
                  HTP.TableData('Indirizzo',CATTRIBUTES  =>'style="font-weight:bold; text-align: center"');
                  HTP.TableRowClose;
                  HTP.TableRowOpen;
                  HTP.TableData(museo.Nome ,'center');
                  HTP.TableData(museo.Indirizzo,'center');
                  HTP.TableRowClose;
                  HTP.TableClose;
                  modGUI1.ChiudiDiv; 
                  if hasRole(sessionid,'DBA') or hasRole(sessionid,'GM')
                  then     
                     modGUI1.Collegamento('VisualizzaMusei','operazioniGruppo4.visualizzaMusei?museoId='||museo.IdMuseo,'w3-green w3-margin w3-button');
                     modGUI1.Collegamento('Modifica Musei','operazioniGruppo4.modificamusei?museoId='||museo.IdMuseo||'&newNome='||museo.Nome||'&newIndirizzo='||museo.Indirizzo,'w3-red w3-margin w3-button');
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
   modgui1.APRIPAGINA('Inserisci Museo');
   modgui1.HEADER();
   htp.bodyOpen;
   htp.br;htp.br;htp.br; htp.br;htp.br;htp.br;  
   htp.prn('<h1 align="center">Inserimento Musei</h1>');
   MODGUI1.APRIDIV('class="w3-modal-content w3-card-4" style="max-width:600px"');
   modgui1.ApriForm(operazioniGruppo4.gr4||'confermamusei','invia','w3-container');
    modGUI1.Collegamento('M',operazioniGruppo4.gr4||'menumusei?','w3-btn  w3-black w3-display-topright' );
   modgui1.LABEL('Nome museo');
   modgui1.INPUTTEXT('newNome','Nome',1,newNome);
   htp.br;
   modgui1.LABEL('Indirizzo museo');
   modgui1.INPUTTEXT('newIndirizzo','Indirizzo',1,newIndirizzo);
   htp.br;
   modgui1.INPUTSUBMIT('Invia');
   modgui1.ChiudiForm;
   modgui1.ChiudiDiv;
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
begin
    htp.htmlOpen;
   modgui1.APRIPAGINA('Conferma Musei');
   modgui1.HEADER();
   htp.bodyopen();
   htp.br;htp.br;htp.br;htp.br;htp.br;
   modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
   if (newNome is null) or (newIndirizzo is null)
     then MODGUI1.LABEL('Parametri inseriti in maniera errata');

     MODGUI1.ApriForm(operazioniGruppo4.gr4||'inseriscimuseo');
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newIndirizzo',  newIndirizzo);
      MODGUI1.InputSubmit('indietro');
   else
     HTP.TableOpen;
      HTP.TableRowOpen;
      HTP.TableData('Nome: ',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData(newNome);
      HTP.TableRowClose;
      HTP.TableRowOpen;
      HTP.TableData('Indirizzo: ',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData(newIndirizzo);
      HTP.TableRowClose;
      HTP.TableClose;
      
      htp.br;

      MODGUI1.ApriForm(operazioniGruppo4.gr4||'controllamusei');
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newIndirizzo',  newIndirizzo);
      MODGUI1.InputSubmit('Conferma');
      MODGUI1.ChiudiForm;

      MODGUI1.ApriForm(operazioniGruppo4.gr4||'inseriscimuseo');
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newIndirizzo',  newIndirizzo);
      MODGUI1.InputSubmit('Annulla');
      MODGUI1.ChiudiForm;

      MODGUI1.ChiudiDiv;
      
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
quanti Number;
BEGIN
   htp.htmlOpen;
   modgui1.APRIPAGINA('Conferma Museo');
   modgui1.HEADER();
   htp.bodyOpen;
   htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
   modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
   select count(*) into quanti
   from MUSEI
   where  newNome = Musei.NOME;
   if quanti >0
      then 
      MODGUI1.RedirectEsito('Inserimento fallito', null,'Inserisci una nuovo museo','operazioniGruppo4.inseriscimuseo','//newNome='||newNome||'//newIndirizzo='||newIndirizzo,'Torna al menu musei','operazioniGruppo4.menumusei',null);
 ELSE
      insert into Musei VALUES (IdMuseoseq.NEXTVAL,newNome,newIndirizzo,0);
      MODGUI1.RedirectEsito('Inserimento completato', null,'Inserisci una nuovo museo','operazioniGruppo4.inseriscimuseo','//newNome='||newNome||'//newIndirizzo='||newIndirizzo,'Torna al menu musei','operazioniGruppo4.menumusei',null);
   end if;
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

   modgui1.apripagina();
   modgui1.header();
   htp.br;htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 align="center">Museo</h1>');
   modgui1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');

   htp.tableopen(CALIGN =>'CENTER');
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
   htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
   modGUI1.Collegamento('Torna al menù','operazioniGruppo4.menumusei','w3-btn w3-round w3-black ');
   modgui1.ChiudiDiv();

END visualizzamusei;
procedure modificamusei
(
    MuseoId IN MUSEI.IdMuseo%TYPE,
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
)
is 
begin
htp.htmlOpen;
   modgui1.APRIPAGINA('Modifica Museo');
   modgui1.HEADER();
   htp.bodyOpen;
   htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;  
   htp.prn('<h1 align="center">Modifica Musei</h1>');
   MODGUI1.APRIDIV('class="w3-modal-content w3-card-4" style="max-width:600px"');
   modgui1.ApriForm(operazioniGruppo4.gr4||'confermamodificamuseo','invia','w3-container');
   modGUI1.Collegamento('M','operazioniGruppo4.menumusei','w3-btn  w3-black w3-display-topright ');
   HTP.FORMHIDDEN('MuseoId', MuseoId);
   modgui1.LABEL('Nome museo');
   modgui1.INPUTTEXT('newNome','Nome',1,newNome);
   htp.br;
   modgui1.LABEL('Indirizzo museo');
   modgui1.INPUTTEXT('newIndirizzo','Indirizzo',1,newIndirizzo);
   htp.br;
   modgui1.INPUTSUBMIT('Invia');
   modgui1.ChiudiForm;
   modgui1.ChiudiDiv;
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
begin 
modgui1.APRIPAGINA('Modifica Museo');
modgui1.HEADER();
   htp.br;
   htp.br;
   htp.br;
    htp.br;
   htp.br;
   modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
   if (newNome is null) or (newIndirizzo is null)
     then MODGUI1.LABEL('Parametri inseriti in maniera errata');

     MODGUI1.ApriForm(operazioniGruppo4.gr4||'modificamusei');
     HTP.FORMHIDDEN('MuseoId', MuseoId);
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newIndirizzo',  newIndirizzo);
      MODGUI1.InputSubmit('indietro');
   else
     HTP.TableOpen(CALIGN=>'CENTER');
      HTP.TableRowOpen;
      HTP.TableData('Nome: ',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData(newNome);
      HTP.TableRowClose;
      HTP.TableRowOpen;
      HTP.TableData('Indirizzo: ',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData(newIndirizzo);
      HTP.TableRowClose;
      HTP.TableClose;
      
      htp.br;

      MODGUI1.ApriForm(operazioniGruppo4.gr4||'updatemusei');
      HTP.FORMHIDDEN('MuseoId', MuseoId);
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newIndirizzo',  newIndirizzo);
      MODGUI1.InputSubmit('Conferma');
      MODGUI1.ChiudiForm;

      MODGUI1.ApriForm(operazioniGruppo4.gr4||'modificamusei');
      HTP.FORMHIDDEN('MuseoId', MuseoId);
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newIndirizzo',  newIndirizzo);
      MODGUI1.InputSubmit('Annulla');
      MODGUI1.ChiudiForm;

      MODGUI1.ChiudiDiv;
   end if;
  
end confermamodificamuseo;

procedure updatemusei
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
)
is

begin
MODGUI1.ApriPagina('museo');
MODGUI1.HEADER();
htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
UPDATE MUSEI SET
		Nome=newNome,
		Indirizzo=newIndirizzo
	WHERE IdMuseo=MuseoId;
MODGUI1.RedirectEsito('Modifica riuscita','Museo modificato correttamente',null,null,null,'Torna al menu musei','operazioniGruppo4.menumusei',null);

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
  MODGUI1.ApriPagina('Statistiche sale museo');
  MODGUI1.HEADER();
  htp.BODYOPEN();
  htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;

  htp.prn('<h1 align="center">Scegli museo</h1>');
  MODGUI1.apridiv('class="w3-modal-content w3-card-4" style="max-width:600px; margin-top:110px"');
  modGUI1.Collegamento('M',operazioniGruppo4.gr4||'menumusei','w3-btn  w3-black w3-display-topright ');
  modGUI1.ApriForm(operazioniGruppo4.gr4||'controllastatistica','invia','w3-container'); 
  MODGUI1.LABEL('Nome del museo');
  MODGUI1.SelectOpen('MuseoId',NameMuseo);
  FOR MusId_cur IN cur LOOP
    MODGUI1.SelectOption(MusId_cur.IdMuseo,MusId_cur.NOME);
  END LOOP;
  MODGUI1.SelectClose;
  htp.br;htp.br;
   MODGUI1.LABEL('Operazione');
   htp.br;
   modgui1.INPUTRADIOBUTTON('sale presenti','scelta',1);
   htp.br;
   modgui1.INPUTRADIOBUTTON('opere presenti','scelta',2);
   htp.br;
   modgui1.INPUTRADIOBUTTON('opere prestate','scelta',3);
   htp.br;
   modgui1.INPUTRADIOBUTTON('introiti museo','scelta',4);
   htp.br;htp.br;htp.br;
  modgui1.INPUTSUBMIT('invia');
  
  MODGUI1.ChiudiForm;
  MODGUI1.ChiudiDiv();
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
  
  MODGUI1.ApriPagina('Statistiche sale museo');
  MODGUI1.HEADER();
  htp.BODYOPEN();
  htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;

  htp.prn('<h1 align="center">Scegli museo</h1>');
  MODGUI1.apridiv('class="w3-modal-content w3-card-4" style="max-width:600px; margin-top:110px"');
   modGUI1.Collegamento('M',operazioniGruppo4.gr4||'menumusei','w3-btn  w3-black w3-display-topright ');
  modGUI1.ApriForm(operazioniGruppo4.gr4||'controllastatistica2','invia','w3-container'); 
  MODGUI1.LABEL('Nome del museo');
  MODGUI1.SelectOpen('MuseoId',NameMuseo);
  FOR MusId_cur IN cur LOOP
    MODGUI1.SelectOption(MusId_cur.IdMuseo,MusId_cur.NOME);
  END LOOP;
  MODGUI1.SelectClose;
  htp.br;htp.br;
   MODGUI1.LABEL('Operazione');
   htp.br;
   modgui1.INPUTRADIOBUTTON('visitatori unici','scelta',5);
   htp.br;
   modgui1.INPUTRADIOBUTTON('visitatori medi','scelta',6);
   htp.br;
   modGUI1.InputDate('Data1','Data1',1,Data1);
   htp.br;
   modGUI1.InputDate('Data2','Data2',1,Data2);
   htp.br;htp.br;
  modgui1.INPUTSUBMIT('invia');
  
  MODGUI1.ChiudiForm;
  MODGUI1.ChiudiDiv();
  htp.htmlClose;
end form2monitoraggio;
/*-----------------------------------------*/
procedure salepresenti
(
   MuseoId IN  Musei.IdMuseo%TYPE
)
is 
CURSOR sal_cursor IS
Select STANZE.Nome,STANZE.Dimensione,SALE.NUMOPERE,SALE.TIPOSALA
FROM STANZE,SALE
WHERE STANZE.MUSEO=MuseoId AND STANZE.IdStanza=SALE.IdStanza;
val_sal sal_cursor%Rowtype;

BEGIN
/*controllo sull'ID*/
MODGUI1.ApriPagina('Visualizzazione sale museo');
MODGUI1.HEADER();
htp.br;htp.br;htp.br;htp.br;
htp.prn('<h1 align="center">Sale Museo</h1>');
MODGUI1.APRIDIV('class="w3-center"');
modGUI1.Collegamento('menù','operazioniGruppo4.menumusei','w3-btn w3-round-xxlarge w3-black ');
htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
modGUI1.Collegamento('statistiche','operazioniGruppo4.form1monitoraggio?&MuseoId='||MuseoId||'&NameMuseo=','w3-btn w3-round-xxlarge w3-black ');
MODGUI1.ChiudiDiv;
modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px; margin-top:110px"');
HTP.TABLEOPEN(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"' );
      HTP.TableRowOpen;
      HTP.TableData('Nome Stanza',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Dimensione Stanza',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Numero Opere Stanza',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Tipo Stanza',CATTRIBUTES  =>'style="font-weight:bold"');
      /* inserire il tipo stanza*/
      HTP.TableRowClose;
FOR val_sal in sal_cursor
loop
    HTP.TableRowOpen;
    HTP.TableData(val_sal.Nome);
    HTP.TableData(val_sal.Dimensione ,'center');
    HTP.TableData(val_sal.NUMOPERE,'center');
   if val_sal.TipoSala=1
      then HTP.TableData('mostra temporanea' ,'center');
   else 
       HTP.TableData('museale' ,'center');
   end if;
   HTP.TableRowClose;
    
end loop;
HTP.TableClose;
modGUI1.ChiudiDiv();
htp.br;htp.br;
MODGUI1.APRIDIV('class="w3-center"');
htp.br;htp.br;
modGUI1.Collegamento('menù','operazioniGruppo4.menumusei','w3-btn w3-round-xxlarge w3-black ');
htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
modGUI1.Collegamento('statistiche','operazioniGruppo4.form1monitoraggio?&MuseoId='||MuseoId||'&NameMuseo=','w3-btn w3-round-xxlarge w3-black ');
MODGUI1.ChiudiDiv;
htp.bodyClose;
END salepresenti;
/*OPERE PRESENTI NEL MUSEO*/
procedure operepresentimuseo
(
   MuseoId IN  Musei.IdMuseo%TYPE
)
/*problema*/
IS
  CURSOR oper_cursor IS
  Select DISTINCT Opere.idopera,Opere.Titolo,Opere.Anno,Opere.FinePeriodo
  FROM OPERE,STANZE,SALEOPERE
  WHERE STANZE.MUSEO=MuseoId AND STANZE.IdStanza=SALEOPERE.Sala AND  OPERE.IdOpera=SALEOPERE.Opera AND SALEOPERE.DataUscita IS NULL;
  val_ope oper_cursor%Rowtype;

BEGIN
MODGUI1.ApriPagina('Visualizzazione opere museo');
MODGUI1.HEADER();
  htp.br;htp.br;htp.br;htp.br;
htp.prn('<h1 align="center">Opere Museo</h1>');

MODGUI1.APRIDIV('class="w3-center"');
modGUI1.Collegamento('menù','operazioniGruppo4.menumusei','w3-btn w3-round-xxlarge w3-black ');
htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
modGUI1.Collegamento('statistiche','operazioniGruppo4.form1monitoraggio?&MuseoId='||MuseoId||'&NameMuseo=','w3-btn w3-round-xxlarge w3-black ');
MODGUI1.ChiudiDiv;

modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px; margin-top:110px"');
HTP.TABLEOPEN(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"' );
      HTP.TableRowOpen;
      HTP.TableData('Titolo opera',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Anno opera',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Periodo opera',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('info',CATTRIBUTES  =>'style="font-weight:bold"');
      /* inserire il tipo stanza*/
      HTP.TableRowClose;
FOR val_ope in oper_cursor
loop
    HTP.TableRowOpen;
    HTP.TableData(val_ope.Titolo);
    HTP.TableData(val_ope.Anno ,'center');
    HTP.TableData(val_ope.FinePeriodo,'center');
    htp.tabledata('<button onclick="document.getElementById(''LinguaeLivelloOpera'||val_ope.IdOpera||''').style.display=''block''" class="w3-margin w3-button w3-black w3-hover-white">Dettagli</button>');
    gruppo2.linguaELivello(val_ope.IdOpera);
    HTP.TableRowClose;
    
end loop; 
   htp.tableclose;
modGUI1.ChiudiDiv();
htp.br;htp.br;
MODGUI1.APRIDIV('class="w3-center"');
modGUI1.Collegamento('menù','operazioniGruppo4.menumusei','w3-btn w3-round-xxlarge w3-black ');
htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
modGUI1.Collegamento('statistiche','operazioniGruppo4.form1monitoraggio?&MuseoId='||MuseoId||'&NameMuseo=','w3-btn w3-round-xxlarge w3-black ');
MODGUI1.ChiudiDiv;

htp.bodyClose;
END operepresentimuseo;

procedure opereprestate
(
   MuseoId IN MUSEI.IdMuseo%TYPE
)
/*problema*/
is 
CURSOR oper_cursor IS
Select  DISTINCT IdOpera,Opere.Titolo,Opere.Anno,Opere.FinePeriodo
FROM STANZE,OPERE,SALEOPERE
WHERE  STANZE.MUSEO=MuseoId AND STANZE.IdStanza=SALEOPERE.Sala AND  OPERE.IdOpera=SALEOPERE.Opera AND OPERE.Museo<>MuseoId  AND SALEOPERE.DataUscita IS NULL;
val_ope oper_cursor%Rowtype;

BEGIN
/*controllo sull'ID*/
MODGUI1.ApriPagina('Visualizzazione opere museo');
MODGUI1.HEADER();
  htp.br;htp.br;htp.br;htp.br;
htp.prn('<h1 align="center">Opere Museo</h1>');

MODGUI1.APRIDIV('class="w3-center"');
modGUI1.Collegamento('menù','operazioniGruppo4.menumusei','w3-btn w3-round-xxlarge w3-black ');
htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
modGUI1.Collegamento('statistiche','operazioniGruppo4.form1monitoraggio?&MuseoId='||MuseoId||'&NameMuseo=','w3-btn w3-round-xxlarge w3-black ');
MODGUI1.ChiudiDiv;

modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px; margin-top:110px"');
HTP.TABLEOPEN(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"' );
      HTP.TableRowOpen;
      HTP.TableData('Titolo opera',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Anno opera',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Periodo opera',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('info',CATTRIBUTES  =>'style="font-weight:bold"');
      /* inserire il tipo stanza*/
      HTP.TableRowClose;
FOR val_ope in oper_cursor
loop
    HTP.TableRowOpen;
    HTP.TableData(val_ope.Titolo);
    HTP.TableData(val_ope.Anno ,'center');
    HTP.TableData(val_ope.FinePeriodo,'center');
    htp.tabledata('<button onclick="document.getElementById(''LinguaeLivelloOpera'||val_ope.IdOpera||''').style.display=''block''" class="w3-margin w3-button w3-black w3-hover-white">Dettagli</button>');
    gruppo2.linguaELivello(val_ope.IdOpera);
    HTP.TableRowClose;
    
end loop;
HTP.TableClose;
modGUI1.ChiudiDiv();
htp.br;htp.br;
MODGUI1.APRIDIV('class="w3-center"');
modGUI1.Collegamento('menù','operazioniGruppo4.menumusei','w3-btn w3-round-xxlarge w3-black ');
htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
modGUI1.Collegamento('statistiche','operazioniGruppo4.form1monitoraggio?&MuseoId='||MuseoId||'&NameMuseo=','w3-btn w3-round-xxlarge w3-black ');
MODGUI1.ChiudiDiv;
htp.bodyClose;
END opereprestate;
/*scelta statistica*/
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
begin 

Select  Count(*)
INTO nvisitatori
FROM TITOLIINGRESSO,VISITE,UTENTIMUSEO
WHERE TITOLIINGRESSO.MUSEO=MuseoId AND  VISITE.TITOLOINGRESSO= TITOLIINGRESSO.IDTITOLOING AND  VISITE.VISITATORE=UTENTIMUSEO.IDUTENTE AND VISITE.DATAVISITA>dateini AND VISITE.DATAVISITA<datefin;
MODGUI1.ApriPagina('Visualizzazione opere museo');
MODGUI1.HEADER();
htp.br;htp.br;htp.br;htp.br;
htp.prn('<h1 align="center">visitatori Museo</h1>');
MODGUI1.APRIDIV('class="w3-center"');
modGUI1.Collegamento('menù','operazioniGruppo4.menumusei','w3-btn w3-round-xxlarge w3-black ');
htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
modGUI1.Collegamento('statistiche','operazioniGruppo4.form2monitoraggio?&MuseoId='||MuseoId||'&NameMuseo=','w3-btn w3-round-xxlarge w3-black ');
MODGUI1.ChiudiDiv;
htp.prn('<p align="center"><b>numero visitatori museo periodo ' || Data1 ||'--'|| Data2 ||':</b> ' || nvisitatori ||'</p>');
modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:1600px; margin-top:110px"');

HTP.TABLEOPEN(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"' );
      HTP.TableRowOpen;
      HTP.TableData('Nome',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Cognome',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Indirizzo',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      HTP.TableData('Email',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      HTP.TableData('Data di Nascita',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
    
      /* inserire il tipo stanza*/
      HTP.TableRowClose;

FOR val_vis in vis_cursor
loop
   HTP.TableRowOpen;
   HTP.TableData(val_vis.Nome);
   HTP.TableData(val_vis.Cognome ,'center');
   HTP.TableData(val_vis.Indirizzo,'center');
   HTP.TableData(val_vis.Email,'center');
   HTP.TableData(val_vis.DATANASCITA,'center');  
   HTP.TableRowClose;
    
end loop;
HTP.TableClose;
modgui1.chiudiDiv();
MODGUI1.APRIDIV('class="w3-center"');
modGUI1.Collegamento('menù','operazioniGruppo4.menumusei','w3-btn w3-round-xxlarge w3-black ');
htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
modGUI1.Collegamento('statistiche','operazioniGruppo4.form1monitoraggio?&MuseoId='||MuseoId||'&NameMuseo=','w3-btn w3-round-xxlarge w3-black ');
MODGUI1.ChiudiDiv;
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
ngiorni number:=datefin-dateini;
mvisitatori number;
begin

Select  count(*)
into nvisitatori
FROM TITOLIINGRESSO,VISITE,UTENTIMUSEO,UTENTI
WHERE TITOLIINGRESSO.MUSEO=MuseoId AND  VISITE.TITOLOINGRESSO= TITOLIINGRESSO.IDTITOLOING AND  VISITE.VISITATORE=UTENTIMUSEO.IDUTENTE AND UTENTIMUSEO.IDUTENTE=UTENTI.IDUTENTE AND VISITE.DATAVISITA>dateini AND VISITE.DATAVISITA<datefin;
mvisitatori:=nvisitatori/ngiorni;
MODGUI1.ApriPagina('Visualizzazione introiti museo');
MODGUI1.HEADER();
htp.br;htp.br;htp.br;htp.br;
htp.prn('<h1 align="center">visitatori medi del Museo</h1>');
htp.br;
MODGUI1.APRIDIV('class="w3-center"');
modGUI1.Collegamento('menù','operazioniGruppo4.menumusei','w3-btn w3-round-xxlarge w3-black ');
htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
modGUI1.Collegamento('statistiche','operazioniGruppo4.form2monitoraggio?&MuseoId='||MuseoId||'&NameMuseo=','w3-btn w3-round-xxlarge w3-black ');
MODGUI1.ChiudiDiv;
htp.prn('<p align="center"><b>numero dei visitatori medi nel periodo ' || Data1 ||'--'|| Data2 ||':</b> ' || mvisitatori ||'</p>');

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

introiti_campiestivi number;
introiti_museo number;
introiti_totale number;

begin 

select SUM(TIPOLOGIEINGRESSO.COSTOTOTALE)
into introiti_museo
from TIPOLOGIEINGRESSO,TITOLIINGRESSO
where MuseoId=TITOLIINGRESSO.MUSEO AND TITOLIINGRESSO.TIPOLOGIA=TIPOLOGIEINGRESSO.IDTIPOLOGIAING;


SELECT SUM(TARIFFECAMPIESTIVI.PREZZO)
into introiti_campiestivi
FROM TARIFFECAMPIESTIVI,CAMPIESTIVI,PAGAMENTICAMPIESTIVI
WHERE MuseoId=CAMPIESTIVI.MUSEO AND CAMPIESTIVI.IDCAMPIESTIVI=TARIFFECAMPIESTIVI.CAMPOESTIVO AND PAGAMENTICAMPIESTIVI.TARIFFA=TARIFFECAMPIESTIVI.IDTARIFFA;

introiti_totale:=introiti_museo+introiti_campiestivi;

MODGUI1.ApriPagina('Visualizzazione introiti museo');
MODGUI1.HEADER();
htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
htp.prn('<h1 align="center">Introiti Museo </h1>');

MODGUI1.APRIDIV('class="w3-center"');
modGUI1.Collegamento('menù','operazioniGruppo4.menumusei','w3-btn w3-round-xxlarge w3-black ');
htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
modGUI1.Collegamento('statistiche','operazioniGruppo4.form1monitoraggio?&MuseoId='||MuseoId||'&NameMuseo=','w3-btn w3-round-xxlarge w3-black ');
MODGUI1.ChiudiDiv;

htp.br;
modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:900px; margin-top:110px"');
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
         HTP.TableData(bigl_cur.Emissione,'center');
         HTP.TableData(bigl_cur.Scadenza ,'center');
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
         HTP.TableData(abb_cur.Emissione,'center');
         HTP.TableData(abb_cur.Scadenza ,'center');
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
      
modgui1.chiudiDiv();
MODGUI1.APRIDIV('class="w3-center"');
modGUI1.Collegamento('menù','operazioniGruppo4.menumusei','w3-btn w3-round-xxlarge w3-black ');
htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
modGUI1.Collegamento('statistiche','operazioniGruppo4.form1monitoraggio?&MuseoId='||MuseoId||'&NameMuseo=','w3-btn w3-round-xxlarge w3-black ');
MODGUI1.ChiudiDiv;
htp.bodyClose;
end introitimuseo;

procedure controllastatistica
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   scelta in number
)
is begin
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

begin
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
CURSOR cur IS Select CAMPIESTIVI.IDCAMPIESTIVI,CAMPIESTIVI.NOME
                        FROM CAMPIESTIVI;
campId_cur cur%Rowtype; 
BEGIN
  htp.htmlOpen;
  MODGUI1.ApriPagina('Statistiche campiesitvi');
  MODGUI1.HEADER();
  htp.BODYOPEN();
  htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;

  htp.prn('<h1 align="center">Statistiche  campi estivi</h1>');
  MODGUI1.apridiv('class="w3-modal-content w3-card-4" style="max-width:600px; margin-top:110px"');
  modGUI1.Collegamento('M',operazioniGruppo4.gr4||'menucampiestivi','w3-btn  w3-black w3-display-topright ');
  modGUI1.ApriForm(operazioniGruppo4.gr4||'controllastatisticacampo','invia','w3-container'); 
  MODGUI1.LABEL('Nome del Campo estivo');
  MODGUI1.SelectOpen('CampoestivoId',NameCampoestivo);
  FOR campId_cur IN cur LOOP
    MODGUI1.SelectOption(campId_cur.IdCampiEstivi,campId_cur.NOME);
  END LOOP;
  MODGUI1.SelectClose;
  htp.br;htp.br;
   MODGUI1.LABEL('Operazione');
   htp.br;
   modgui1.INPUTRADIOBUTTON('Utenti iscritti','scelta',1);
   htp.br;
   modgui1.INPUTRADIOBUTTON('tariffe','scelta',2);
   htp.br;
   modgui1.INPUTRADIOBUTTON('età media tariffe','scelta',3);
   htp.br;
   modgui1.INPUTRADIOBUTTON('introiti campo','scelta',4);
   htp.br;htp.br;htp.br;
  modgui1.INPUTSUBMIT('invia');
  
  MODGUI1.ChiudiForm;
  MODGUI1.ChiudiDiv();
  htp.htmlClose;
END form1campiestivi;

procedure controllastatisticacampo
(
   CampoestivoId IN CAMPIESTIVI.IDCAMPIESTIVI%TYPE,
   scelta in number
)
is 
begin
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
MODGUI1.ApriPagina('Visualizzazione utenti iscritti');
MODGUI1.HEADER();
/*conto il numero delgi uteni iscritti*/
Select count(*)
   INTO nutenti
  FROM UTENTI,UTENTIPAGAMENTI,PAGAMENTICAMPIESTIVI,TARIFFECAMPIESTIVI,UTENTICAMPIESTIVI
  WHERE CampoestivoId=TARIFFECAMPIESTIVI.CAMPOESTIVO AND PAGAMENTICAMPIESTIVI.TARIFFA=TARIFFECAMPIESTIVI.IDTARIFFA AND PAGAMENTICAMPIESTIVI.IDPAGAMENTO=UTENTIPAGAMENTI.IDPAGAMENTO AND UTENTIPAGAMENTI.IDUTENTE= UTENTICAMPIESTIVI.IDUTENTE AND UTENTI.IDUTENTE= UTENTICAMPIESTIVI.IDUTENTE;



htp.br;htp.br;htp.br;htp.br;
htp.prn('<h1 align="center">Utenti Campo estivo </h1>');
htp.br;htp.br;
htp.prn('<p align="center"><b>numero iscritti al camo estivo:</b> ' || nutenti ||'</p>');
MODGUI1.APRIDIV('class="w3-center"');
modGUI1.Collegamento('menù','operazioniGruppo4.menucampiestivi','w3-btn w3-round-xxlarge w3-black ');
htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
modGUI1.Collegamento('statistiche','operazioniGruppo4.form1campiestivi?&CampoestivoId=&NameCampoestivo=','w3-btn w3-round-xxlarge w3-black ');

MODGUI1.chiudidiv;
modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:1400px; margin-top:110px"');

HTP.TABLEOPEN(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"' );
      HTP.TableRowOpen;
      HTP.TableData('Nome',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Cognome',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Indirizzo',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      HTP.TableData('Email',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      HTP.TableData('Data di Nascita',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
    
      /* inserire il tipo stanza*/
      HTP.TableRowClose;

FOR val_ut in ut_cursor
loop
   HTP.TableRowOpen;
   HTP.TableData(val_ut.Nome);
   HTP.TableData(val_ut.Cognome ,'center');
   HTP.TableData(val_ut.Indirizzo,'center');
   HTP.TableData(val_ut.Email,'center');
   HTP.TableData(val_ut.DATANASCITA,'center');  
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
begin
MODGUI1.ApriPagina('Tariffe campi estivi');
MODGUI1.HEADER();
htp.br;htp.br;htp.br;htp.br;
htp.prn('<h1 align="center">Tariffe Campo estivo </h1>');
MODGUI1.APRIDIV('class="w3-center"');
modGUI1.Collegamento('menù','operazioniGruppo4.menucampiestivi','w3-btn w3-round-xxlarge w3-black ');
htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
modGUI1.Collegamento('statistiche','operazioniGruppo4.form1campiestivi?&CampoestivoId=&NameCampoestivo=','w3-btn w3-round-xxlarge w3-black ');

MODGUI1.CHIUDIdiv;
modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px; margin-top:110px"');

HTP.TABLEOPEN(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"' );
      HTP.TableRowOpen;
      HTP.TableData('id tariffa',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Prezzo',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Età minima',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      HTP.TableData('Età massima',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      HTP.TableRowClose;

FOR val_tar in tar_cursor
loop
   HTP.TableRowOpen;
   HTP.TableData(val_tar.IDTARIFFA,'center');
   HTP.TableData(val_tar.Prezzo || ' €' ,'center');
   HTP.TableData(val_tar.Etaminima,'center');
   HTP.TableData(val_tar.Etamassima,'center');  
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
begin

Select trunc(avg(etam.eta),0) 
into etamedia
from vistaetamedia etam;

MODGUI1.ApriPagina('Eta Media Tariffe Campi Estivi');
MODGUI1.HEADER();
htp.br;htp.br;htp.br;htp.br;
htp.prn('<h1 align="center">Tariffe Campo estivo </h1>');
MODGUI1.APRIDIV('class="w3-center"');
modGUI1.Collegamento('menù','operazioniGruppo4.menucampiestivi','w3-btn w3-round-xxlarge w3-black ');
htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
modGUI1.Collegamento('statistiche','operazioniGruppo4.form1campiestivi?&CampoestivoId=&NameCampoestivo=','w3-btn w3-round-xxlarge w3-black ');

MODGUI1.CHIUDIdiv;
htp.prn('<p align="center"><b> età media visitatori :</b>' ||etamedia || '</p>');
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

MODGUI1.ApriPagina('Visualizzazione introiti museo');
MODGUI1.HEADER();
htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
htp.prn('<h1 align="center">Introiti Museo </h1>');
MODGUI1.APRIDIV('class="w3-center"');
modGUI1.Collegamento('menù','operazioniGruppo4.menucampiestivi','w3-btn w3-round-xxlarge w3-black ');
htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
modGUI1.Collegamento('statistiche','operazioniGruppo4.form1campiestivi?&CampoestivoId=&NameCampoestivo=','w3-btn w3-round-xxlarge w3-black ');
MODGUI1.ChiudiDiv;

htp.br;
modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px; margin-top:110px"');
HTP.TABLEOPEN(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"' );
      HTP.TableRowOpen;
      HTP.TableData('Introti del campo estivo: ',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData( introiti_campiestivi|| ' €');
      HTP.TableRowClose;
HTP.TableClose;
      /* inserire il tipo stanza*/
      
modgui1.chiudiDiv();
htp.bodyClose;
end;

/*Inserisci pagamento campi estivi*/
/****************************************************************/
procedure InserisciPagamentoCampiEstivi(
    dataPagamento in varchar2 default NULL,
    tariffa in PAGAMENTICAMPIESTIVI.Tariffa%type default 0, 
    acquirente in PAGAMENTICAMPIESTIVI.Acquirente%type default 0 
) is
idSessione number(5) := modgui1.get_id_sessione();
begin
    MODGUI1.ApriPagina('Inserimento pagamento campo estivo', 0);
    if idSessione is null then
        modgui1.header;
    else
        modgui1.header(idSessione);
    end if;
    htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;

    htp.prn('<h1 align="center">Inserimento Pagamento Campo Estivo</h1>');
    modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px; margin-top:110px"');
        modgui1.apridiv('class="w3-section"');
        modgui1.collegamento('X',operazioniGruppo4.gr4||operazioniGruppo4.menu_ce,' w3-btn w3-large w3-red w3-display-topright');
            modgui1.ApriForm(operazioniGruppo4.gr4||'ConfermaPagamentoCampiEstivi', null, 'w3-container');
                modgui1.label('Data Pagamento');
                modgui1.InputDate('dataPagamento', 'dataPagamento', 1, dataPagamento);
                htp.br;
                htp.formhidden('tariffa',tariffa);
                modgui1.selectopen('Acquirente');
                modgui1.label('Acquirente');
                for utente in 
                    (select NOME,UTENTI.IDUTENTE from UTENTICAMPIESTIVI,UTENTI WHERE UTENTICAMPIESTIVI.IDUTENTE=UTENTI.IDUTENTE)
                loop
                    modgui1.selectoption(utente.IDUTENTE, utente.NOME);
                end loop;
                modgui1.selectclose;
                htp.br;
 
                modgui1.inputsubmit('Aggiungi');
            modgui1.ChiudiForm;
        modgui1.ChiudiDiv;
    modgui1.ChiudiDiv;
    htp.bodyClose;
    htp.htmlClose;

end InserisciPagamentoCampiEstivi;

procedure ConfermaPagamentoCampiEstivi(
    dataPagamento in varchar2 default NULL,
    tariffa in PAGAMENTICAMPIESTIVI.Tariffa%type default 0, 
    acquirente in PAGAMENTICAMPIESTIVI.Acquirente%type default 0
) is 
    idSessione number(5) := modgui1.get_id_sessione();
    newIdPagamento PAGAMENTICAMPIESTIVI.IdPagamento%type;
begin
    if tariffa = 0
    or dataPagamento is null
    or acquirente = 0
    then
        modgui1.apripagina('Pagina errore', 0);
        htp.bodyopen;
        modgui1.apridiv;
        htp.print('Uno dei parametri immessi non valido');
        modgui1.chiudidiv;
        htp.bodyclose;
        htp.htmlclose;
    else
        modgui1.apripagina('Conferma', idSessione);
        if idSessione is null then
            modgui1.header;
        else
            modgui1.header(idSessione);
        end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
        htp.prn('<h1 align="center">CONFERMA DATI</h1>');--DA MODIFICARE
        modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px" ');
            modgui1.apridiv('class="w3-section"');
                htp.br;
                modgui1.label('Data pagamento:');
                htp.print(dataPagamento);
                htp.br;
                modgui1.label('Tariffa:');
                htp.print(tariffa);
                htp.br;
                modgui1.label('Acquirente:');
                htp.print(acquirente);
                htp.br;
            modgui1.chiudidiv;

            modgui1.apriform(operazioniGruppo4.gr4||'ControllaPagamentoCampiEstivi');
            htp.formhidden('dataPagamento', dataPagamento);
            htp.formhidden('tariffa', tariffa);
            htp.formhidden('acquirente', acquirente);
            modgui1.inputsubmit('Conferma');
            modgui1.chiudiform;
            modgui1.apriform(operazioniGruppo4.gr4||'InserisciPagamentoCampiEstivi');
            htp.formhidden('dataPagamento', dataPagamento);
            htp.formhidden('tariffa', tariffa);
            htp.formhidden('acquirente', acquirente);
            modgui1.inputsubmit('Annulla');
            modgui1.chiudiform;
        modgui1.chiudidiv;
    end if;
    exception when others then
        dbms_output.put_line('Error: '||sqlerrm);
end ConfermaPagamentoCampiEstivi;
        
procedure ControllaPagamentoCampiEstivi(
    dataPagamento in varchar2 default NULL, 
    tariffa in PAGAMENTICAMPIESTIVI.Tariffa%type, 
    acquirente in PAGAMENTICAMPIESTIVI.Acquirente%type
) is 
     idSessione number(5) := modgui1.get_id_sessione();
    dataPagamento_date date := TO_DATE(dataPagamento, 'YYYY-MM-DD');
    type errorsTable is table of varchar2(32);
    errors errorsTable;
    errorsCount integer := 0;
begin
    insert into PAGAMENTICAMPIESTIVI(IdPagamento, DataPagamento, Tariffa, Acquirente)
        values (IdPagamentoSeq.nextval, dataPagamento_date, tariffa, acquirente);
    if sql%found then
        commit;
        modgui1.redirectesito('Inserimento andato a buon fine', null,
        'Inserisci un nuovo pagamento',operazioniGruppo4.gr4||'InserisciPagamentoCampiEstivi', null,
        'Torna ai campi estivi',operazioniGruppo4.gr4||operazioniGruppo4.menu_ce, null);
    end if;
    exception when others then
        modgui1.redirectesito('Inserimento non riuscito', null,
        'Riprova',operazioniGruppo4.gr4||'InserisciPagamentoCampiEstivi',null,
        'Torna ai campi estivi',operazioniGruppo4.gr4||operazioniGruppo4.menu_ce,null);
 
end ControllaPagamentoCampiEstivi;

procedure VisualizzaPagamentoCampiEstivi(
    idPagamento in PAGAMENTICAMPIESTIVI.IdPagamento%type
) is
    idSessione number(5) := modgui1.get_id_sessione();
    found NUMBER(10) := 0;
begin
    htp.prn('<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> ');
    if idSessione is null then
        modgui1.header;
    else
        modgui1.header(idSessione);
    end if;    
    htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
    modgui1.apridiv('class="w3-center"');

    select count(*) 
    into found
    from PAGAMENTICAMPIESTIVI
    where PAGAMENTICAMPIESTIVI.IdPagamento = idPagamento;

    htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
    if found > 0 then
        modgui1.apridiv('class="w3-center"');
            htp.tableopen;
            for pagamento in (
                select DataPagamento, Tariffa, Acquirente 
                from PAGAMENTICAMPIESTIVI
                where PAGAMENTICAMPIESTIVI.IdPagamento = idPagamento
            )
            loop
            htp.tablerowopen;
            htp.tabledata(pagamento.DataPagamento);
            htp.tabledata(pagamento.Tariffa);
            htp.tabledata(pagamento.Acquirente);
            htp.tablerowclose;
            end loop;
            htp.tableclose;
        modgui1.chiudidiv;
    else
        modgui1.ApriPagina('Pagamento non trovato');
        htp.prn('Pagamento non trovato');
    end if;

    htp.bodyclose;
    htp.htmlclose;
  
end;

procedure CancellaPagamentoCampiEstivi(
    idPagamento in PAGAMENTICAMPIESTIVI.IdPagamento%type
) is 
begin
    htp.htmlopen;
    htp.htmlclose;
end;

procedure MonitoraggioPeriodoPagamentoCampiEstivi(
    dataInizio in PAGAMENTICAMPIESTIVI.DataPagamento%type default NULL,
    dataFine in PAGAMENTICAMPIESTIVI.DataPagamento%type default NULL
) is 
begin
    htp.htmlopen;
    modgui1.ApriPagina();
    modgui1.Header();
    htp.bodyopen;
    htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
    modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');

    htp.tableopen;
    for pagamento in (
        select IdPagamento, DataPagamento, Tariffa, Acquirente 
        from PAGAMENTICAMPIESTIVI
        where PAGAMENTICAMPIESTIVI.DataPagamento <= dataFine and PAGAMENTICAMPIESTIVI.DataPagamento >= dataInizio
    )
    loop
        htp.tablerowopen;
        htp.tabledata(pagamento.IdPagamento);
        htp.tabledata(pagamento.DataPagamento);
        htp.tabledata(pagamento.Tariffa);
        htp.tabledata(pagamento.Acquirente);
        htp.tablerowclose;
    end loop;

    modgui1.chiudidiv;
    htp.tableclose;
    htp.bodyclose;
    htp.htmlclose;
  
end;

procedure PagamentoCampiEstivi(
    idtariffa in PAGAMENTICAMPIESTIVI.Tariffa%type default 0
) is 

CURSOR cur IS
select IdPagamento,DataPagamento,Tariffa,Acquirente
from PAGAMENTICAMPIESTIVI
where  PAGAMENTICAMPIESTIVI.Tariffa = idtariffa;
pagId_cur cur%Rowtype; 

pagamentiTariffa number;
begin
    htp.htmlopen;
    modgui1.ApriPagina();
    modgui1.Header();
    htp.bodyopen;
    select count(IdPagamento) into pagamentiTariffa
    from PAGAMENTICAMPIESTIVI
    where  PAGAMENTICAMPIESTIVI.Tariffa = idtariffa;
    htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
    htp.prn('<h1 align="center">Pagamenti campi estivi</h1>');
   /*modGUI1.Collegamento('campi estivi','operazioniGruppo4.menuctariffe','w3-btn w3-round-xxlarge w3-black ');*/
   
    htp.prn('<p align="center"><b>numero di pagamenti: </b>'||pagamentiTariffa||'</p>');
    modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
    

    
     HTP.TABLEOPEN(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"' );
      HTP.TableRowOpen;
      HTP.TableData('IdPagamento',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('DataPagamento',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Acquirente',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      HTP.TableData('',CATTRIBUTES =>'style="font-weight:bold"');
      FOR pagId_cur IN cur LOOP
         htp.tablerowopen;
        htp.tabledata(pagId_cur.IdPagamento);
        htp.tabledata(pagId_cur.DataPagamento);
        htp.tabledata(pagId_cur.Acquirente);
        htp.tabledata('<a href="'|| Costanti.server || Costanti.radice ||'operazioniGruppo4.Utentipagamenti?'||'pagamentoid='||pagId_cur.IdPagamento||'"'||'class="w3-black w3-round w3-margin w3-button"'||'>'||'Dettagli'||'</a>');
        htp.tablerowclose;

      END LOOP;
    
    modgui1.chiudidiv;
    
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
) is
    idSessione number(5) := modgui1.get_id_sessione();
begin
    modgui1.apripagina('Inserimento tariffa campo estivo');
    if idSessione is null then
        modgui1.header;
    else
        modgui1.header(idSessione);
    end if;
    htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;

    htp.prn('<h1 align="center">Inserimento Tariffa Campo Estivo</h1>');
    modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px; margin-top:110px"');
        modgui1.apridiv('class="w3-section"');
        modgui1.collegamento('X',operazioniGruppo4.gr4||operazioniGruppo4.menu_ce,' w3-btn w3-large w3-red w3-display-topright');
            modgui1.ApriForm(operazioniGruppo4.gr4||'ConfermaTariffeCampiEstivi', null, 'w3-container');
                modgui1.label('Prezzo');
                modgui1.inputtext('prezzo', 'prezzo', 0, prezzo);
                htp.br;
                modgui1.label('Eta minima');
                modgui1.inputtext('etaMinima', 'etaMinima', 0, etaMinima);
                htp.br;
                modgui1.label('Eta massima');
                modgui1.inputtext('etaMassima', 'etaMassima', 0, etaMassima);
                htp.br;
                modgui1.label('Campo Estivo');
                modgui1.selectopen('CampoEstivo');
                for campoEstivo in
                    (select IdCampiEstivi, nome from campiestivi)
                loop
                    modgui1.selectoption(campoEstivo.IdCampiEstivi, campoEstivo.nome);
                end loop;
                modgui1.selectclose;
                htp.br;
                
                modgui1.inputsubmit('Aggiungi');
            modgui1.chiudiform;
        modgui1.chiudidiv;
    modgui1.chiudidiv;
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
    idSessione number(5) := modgui1.get_id_sessione();
    campoFound number;
   campoEstivo_niceName varchar(100);
begin

    select count(*) into campoFound
    from CAMPIESTIVI
    where CAMPIESTIVI.IDCAMPIESTIVI = campoEstivo;

    if etaminima > Etamassima
    or prezzo < 0
    or etaminima < 0
    or campoFound is null
    or campoFound = 0
    then
        modgui1.apripagina('Pagina errore', 0);
        htp.bodyopen;
        modgui1.apridiv;
        htp.print('Uno dei parametri immessi non valido');
        modgui1.chiudidiv;
        htp.bodyclose;
        htp.htmlclose;
    else
        select NOME into campoEstivo_niceName
        from CAMPIESTIVI
        where CAMPIESTIVI.IDCAMPIESTIVI = campoEstivo;
        modgui1.apripagina('Conferma', idSessione);
        if idSessione is null then
            modgui1.header;
        else
            modgui1.header(idSessione);
        end if;
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
        htp.prn('<h1 align="center">CONFERMA DATI</h1>');--DA MODIFICARE
        modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px" ');
            modgui1.apridiv('class="w3-section"');
                htp.br;
                modgui1.label('Prezzo:');
                htp.print(prezzo);
                htp.br;
                modgui1.label('Eta minima:');
                htp.print(etaMinima);
                htp.br;
                modgui1.label('Eta massima:');
                htp.print(etaMassima);
                htp.br;
                modgui1.label('Campo Estivo:');
                htp.print(campoEstivo_niceName);
                htp.br;
            modgui1.chiudidiv;
            modgui1.apriform(operazioniGruppo4.gr4||'ControllaTariffeCampiEstivi');
            htp.formhidden('prezzo', prezzo);
            htp.formhidden('etaMinima', etaMinima);
            htp.formhidden('etaMassima', etaMassima);
            htp.formhidden('campoEstivo', campoEstivo);
            modgui1.inputsubmit('Conferma');
            modgui1.chiudiform;
            modgui1.apriform(operazioniGruppo4.gr4||'InserisciTariffeCampiEstivi');
            htp.formhidden('prezzo', prezzo);
            htp.formhidden('etaMinima', etaMinima);
            htp.formhidden('etaMassima', etaMassima);
            htp.formhidden('campoEstivo', campoEstivo);
            modgui1.inputsubmit('Annulla');
            modgui1.chiudiform;
        modgui1.chiudidiv;
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
) is 
    idSessione number(5) := modgui1.get_id_sessione();
    type errorsTable is table of varchar2(32);
    errors errorsTable;
    errorsCount integer := 0;
    campoEstivoExists integer := 0;

begin
    insert into TARIFFECAMPIESTIVI(IdTariffa, Prezzo, Etaminima, Etamassima, CampoEstivo, Eliminato)
        values (IdTariffaSeq.nextval, prezzo, etaMinima, etaMassima, campoEstivo, 0);
    if sql%found then
        commit;
        modgui1.redirectesito('Inserimento andato a buon fine', null,
        'Inserisci una nuova tariffa',operazioniGruppo4.gr4||'InserisciTariffeCampiEstivi', null,
        'Torna ai campi estivi',operazioniGruppo4.gr4||operazioniGruppo4.menu_ce, null);
    end if;
    exception when others then
        modgui1.redirectesito('Inserimento non riuscito', null,
        'Riprova',operazioniGruppo4.gr4||'InserisciTariffeCampiEstivi',null,
        'Torna ai campi estivi',operazioniGruppo4.gr4||operazioniGruppo4.menu_ce,null);
end ControllaTariffeCampiEstivi;

procedure VisualizzaTariffeCampiEstivi
(
    Tariffa in TARIFFECAMPIESTIVI.IdTariffa%type
) is 
    tariffe TARIFFECAMPIESTIVI%rowtype;
begin

    htp.htmlopen;
    modgui1.apripagina();
    modgui1.header();
    htp.bodyopen;
    htp.br;htp.br;htp.br;htp.br;htp.br;
    modgui1.apridiv('class="w3-modal-content w3-card-4" style="max-width:600px"');

    select *
    into tariffe
    from TARIFFECAMPIESTIVI
    where TARIFFECAMPIESTIVI.IdTariffa = Tariffa;

 htp.tableopen(CALIGN =>'CENTER',CATTRIBUTES =>'class="w3-table"');
        htp.tablerowopen;
        htp.tabledata('idTariffa: ',CATTRIBUTES  =>'style="font-weight:bold"');
        htp.tabledata(tariffe.idtariffa);
        htp.tablerowclose;
        htp.tablerowopen;
        htp.tabledata('Prezzo: ',CATTRIBUTES  =>'style="font-weight:bold"');
        htp.tabledata(tariffe.Prezzo);
        htp.tablerowclose;
        htp.tablerowopen;
        htp.tabledata('Etaminima: ',CATTRIBUTES  =>'style="font-weight:bold"');
        htp.tabledata(tariffe.Etaminima);
        htp.tablerowclose;
        htp.tablerowopen;
        htp.tabledata('Etamassima: ',CATTRIBUTES  =>'style="font-weight:bold"');
        htp.tabledata(tariffe.Etamassima);
        htp.tablerowclose;
   htp.tableclose;

    htp.bodyclose;
    htp.htmlclose;
    
end;

procedure ModificaTariffeCampiEstivi
(
    up_idTariffa in TARIFFECAMPIESTIVI.IdTariffa%type
) is 
    idSessione number(5) := modgui1.get_id_sessione();
    tariffa TariffecampiEstivi%rowtype;
begin
    select * into tariffa from tariffecampiestivi where idtariffa = up_idTariffa;
    modgui1.apripagina('Modifica Tariffa CampiEstivi', idSessione);
    modgui1.header;
    htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
    modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px" ');
        modgui1.apridiv('class="w3-section"');
            modgui1.collegamento('X',operazioniGruppo4.gr4||operazioniGruppo4.menu_ce,' w3-btn w3-large w3-red w3-display-topright');
            htp.br;
            htp.header(2, 'Tariffa', 'center');
             modgui1.apriform(operazioniGruppo4.gr4||'AggiornaTariffeCampiEstivi');
                htp.formhidden('up_idTariffa', tariffa.idtariffa);
                modgui1.label('Prezzo');
                modgui1.inputtext('up_prezzo', 'up_prezzo', 0, tariffa.prezzo);
                htp.br;
                modgui1.label('Eta minima');
                modgui1.inputtext('up_etaMinima', 'up_etaMinima', 0, tariffa.etaMinima);
                htp.br;
                modgui1.label('Eta massima');
                modgui1.inputtext('up_etaMassima', 'up_etaMassima', 0, tariffa.etaMassima);
                htp.br;
                modgui1.label('Campo Estivo');
                modgui1.selectopen('up_campoEstivo');
                for campoEstivo in
                    (select IdCampiEstivi, nome from campiestivi where IdCampiEstivi = tariffa.campoEstivo)
                loop
                    modgui1.selectoption(campoEstivo.IdCampiEstivi, campoEstivo.nome);
                end loop;
                for campoEstivo in
                    (select IdCampiEstivi, nome from campiestivi where IdCampiEstivi <> tariffa.campoEstivo)
                loop
                    modgui1.selectoption(campoEstivo.IdCampiEstivi, campoEstivo.nome);
                end loop;
                modgui1.selectclose;
                htp.br;
                modgui1.inputsubmit('Aggiorna');
            modgui1.chiudiform;
        modgui1.chiudidiv;
    modgui1.chiudidiv;
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
    idSessione number(5) := modgui1.get_id_sessione();
begin
    if up_etaminima > up_etamassima
    or up_prezzo < 0
    or up_etaminima < 0
    or up_campoEstivo is null
    or up_campoEstivo = 0
    then
        modgui1.redirectesito('Parametri invalidi', 
        'Errore: paramtri aggiornamento tariffa campi estivi non validi', 
        'Torna alla modifica', operazioniGruppo4.gr4||'ModificaTariffeCampiEstivi', 
        'up_idTariffa='|| up_idTariffa, 
        'Torna al menu', operazioniGruppo4.gr4||operazioniGruppo4.menu_ce);
    end if;

    update tariffecampiestivi set
        prezzo = up_prezzo, 
        etaminima = up_etaMinima, 
        etamassima = up_etaMassima, 
        campoestivo = up_campoEstivo
    where idtariffa = up_idTariffa;
    commit;
    modgui1.redirectesito('Aggiornamento riuscito', null, null, null, null, 
        'Torna al menu', operazioniGruppo4.gr4||operazioniGruppo4.menu_ce);
    exception when others then
        modgui1.redirectesito('Aggiornamento fallito', 
        'Errore: sconosciuto', 
        'Torna alla modifica', operazioniGruppo4.gr4||'ModificaTariffeCampiEstivi', 
        'up_idTariffa='|| up_idTariffa, 
        'Torna al menu', operazioniGruppo4.gr4||operazioniGruppo4.menu_ce);
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
begin
htp.htmlOpen;
  MODGUI1.ApriPagina('Tariffe Campi Estivi');
  MODGUI1.HEADER();
  htp.BODYOPEN();
  htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
   
  htp.prn('<h1 align="center">Tariffe Campi Estivi</h1>');
  MODGUI1.apridiv('class="w3-modal-content w3-card-4" style="max-width:600px; margin-top:110px"');
  modGUI1.ApriForm(operazioniGruppo4.gr4||'monitoratariffeAnno','invia','w3-container'); 
  
   htp.br;
   /*MODGUI1.SelectOpen('CampoEstivo');
  FOR campId_cur IN cur LOOP
    MODGUI1.SelectOption(campId_cur.IdCampiEstivi,campId_cur.NOME);
  END LOOP;
  MODGUI1.SelectClose;*/
   htp.FORMHIDDEN('campoEstivo',campoEstivo);
   MODGUI1.LABEL('Da');
   modgui1.inputtext('Data1', 'Data', 0, Data1);
   htp.br;
   MODGUI1.LABEL('a');
   modgui1.inputtext('Data2', 'Data', 0, Data2);
   htp.br;
   htp.br;htp.br;htp.br;
  modgui1.INPUTSUBMIT('invia');
 
  MODGUI1.ChiudiForm;
  MODGUI1.ChiudiDiv();
  htp.htmlClose;
end;

procedure preferenzaTariffa
(
   campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type
)
 is 
   found number := 0;
begin
    /*tariffa piu gettonata per ogni campoEstivo*/
    htp.htmlopen;
    modgui1.apripagina();
    modgui1.header();
    htp.bodyopen;
    htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
    modgui1.apridiv('class="w3-modal-content w3-card-4" style="max-width:600px"');

    htp.tableopen(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"');
    htp.tablerowopen;
    htp.TableData('Tariffa',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
    htp.TableData('Count',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
    htp.tablerowclose;

    if campoEstivo = 0 then /*campo estivo non specificato*/
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
            htp.tablerowopen;
            htp.tabledata(tariffa.Tariffa, 'center');
            htp.tabledata(tariffa.conto, 'center');
            htp.tablerowclose;
        end loop;
    else /*campo estivo specificato*/
        for tariffa in (
            select Tariffa, count(*) as conto
            from PAGAMENTICAMPIESTIVI join tariffecampiestivi 
                on PAGAMENTICAMPIESTIVI.tariffa = tariffecampiestivi.idTariffa
            where tariffecampiestivi.campoestivo = campoEstivo
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
            htp.tablerowopen;
            htp.tabledata(tariffa.Tariffa, 'center');
            htp.tabledata(tariffa.conto, 'center');
            htp.tablerowclose;
        end loop;
    end if;

    modgui1.chiudidiv;
    htp.tableclose;
    htp.bodyclose;
    htp.htmlclose;


end;

procedure monitoratariffeAnno
(
   campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type,
   Data1 in  varchar2,
   Data2 in  varchar2
) is
   newdata1 number(5):=TO_NUMBER(Data1);
   newdata2 number(5):=TO_NUMBER(Data2);
begin
    htp.htmlopen;
    modgui1.apripagina();
    modgui1.header();
    htp.bodyopen;
    htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
    htp.prn('<h1 align="center">Storico Pagamenti</h1>');
    modgui1.apridiv('class="w3-modal-content w3-card-4" style="max-width:600px"');

    HTP.TABLEOPEN(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"' );
      HTP.TableRowOpen;
      HTP.TableData('Tariffa',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Eta Minima',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Eta Massima',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      HTP.TableData('Prezzo',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      HTP.TableData('Data Pagamento',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
    for tariffa in (
        select TARIFFA, DATAPAGAMENTO,ETAMINIMA,ETAMASSIMA,PREZZO
        from PAGAMENTICAMPIESTIVI,TARIFFECAMPIESTIVI,CAMPIESTIVI
        where extract(year from DATAPAGAMENTO)>newdata1 AND extract(year from DATAPAGAMENTO)<newdata2 AND PAGAMENTICAMPIESTIVI.TARIFFA=TARIFFECAMPIESTIVI.IDTARIFFA AND CAMPIESTIVI.IDCAMPIESTIVI=campoEstivo
    )
    loop
        htp.tablerowopen;
        htp.tabledata(tariffa.Tariffa);
        htp.tabledata(tariffa.ETAMINIMA);
        htp.tabledata(tariffa.ETAMASSIMA);
        htp.tabledata(tariffa.PREZZO);
        htp.tabledata(tariffa.DataPagamento);
        htp.tablerowclose;
    end loop;

    htp.tableclose;
    htp.bodyclose;
    htp.htmlclose;
end;

procedure MonitoraTariffeCampiEstivi_tariffeCampo
(
   campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type
)
 is 
begin
    htp.htmlopen;
    modgui1.apripagina();
    modgui1.header();
    htp.bodyopen;
    modgui1.apridiv('class="w3-modal-content w3-card-4" style="max-width:600px"');

   HTP.TABLEOPEN(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"' );
      HTP.TableRowOpen;
      HTP.TableData('Tariffa',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Eta Minima',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Eta Massima',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
      HTP.TableData('Prezzo',CATTRIBUTES  =>'style="font-weight:bold; text-align:center"');
    
    for tariffa in (
        select distinct Tariffa,EtaMinima,EtaMassima, Prezzo, CampoEstivo
        from TARIFFECAMPIESTIVI join PAGAMENTICAMPIESTIVI 
        on TARIFFECAMPIESTIVI.IdTariffa = PAGAMENTICAMPIESTIVI.TARIFFA
        where CampoEstivo = campoEstivo
        order by Prezzo desc
    )
    loop
        htp.tablerowopen;
        htp.tabledata(tariffa.Tariffa);
        htp.tabledata(tariffa.EtaMinima);
        htp.tabledata(tariffa.EtaMassima);
        htp.tabledata(tariffa.Prezzo);
        htp.tablerowclose;
    end loop;

    htp.tableclose;
    htp.bodyclose;
    htp.htmlclose;
end;
procedure Utentipagamenti
(
   pagamentoid in PagamentiCampiEstivi.idpagamento%type
)
is 

begin 
   modgui1.apripagina();
   modgui1.header();
   htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 align="center">Utenti coinvolti nel pagamento</h1>');
    modgui1.apridiv('class="w3-modal-content w3-card-4" style="max-width:600px"');

      HTP.TABLEOPEN(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"' );
      HTP.TableRowOpen;
      HTP.TableData('Nome',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Cognome',CATTRIBUTES  =>'style="font-weight:bold"');
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
        htp.tabledata(utente.Nome);
        htp.tabledata(utente.Cognome);
        htp.tabledata(utente.DataNascita);
        htp.tabledata(utente.Indirizzo);
        htp.tablerowclose;
    end loop;

      HTP.TABLECLOSE;
   modgui1.chiudidiv();


end;
end operazioniGruppo4;
-- SET DEFINE ON;