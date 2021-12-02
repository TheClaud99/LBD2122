SET DEFINE OFF;
Create or replace PACKAGE body operazioniGruppo4 as
/*visualizza tutti i campi estivi*/
procedure menucampiestivi
(
   idsessione IN number default 0
)
   is
   begin
   htp.prn('<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> ');
   modGUI1.ApriPagina('Campi Estivi');
   modGUI1.Header();
   htp.br;htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 Align="center">Campi Estivi</h1>');
    MODGUI1.APRIDIV('class="w3-col l4 w3-padding-large w3-left"');
   htp.prn('<h1 Align="center">Inserimento</h1>');
   MODGUI1.APRIDIV('class="w3-center"');
   modGUI1.Collegamento('inserisci Campo Estivo',
                            'operazioniGruppo4.inseriscicampiestivi?newNome=&newMuseo=&newStato=&newDatainizio=&newDataConclusione=',
                            'w3-black w3-round w3-margin w3-button');
   MODGUI1.ChiudiDiv();
   MODGUI1.ChiudiDiv();
   MODGUI1.APRIDIV('class="w3-col l4 w3-padding-large w3-right"');
   htp.prn('<h1 Align="center">Statistiche</h1>');
    MODGUI1.APRIDIV('class="w3-center"');
   modGUI1.Collegamento('Statistiche',
                            'operazioniGruppo4.form1campiestivi?idsessione=&CampoestivoId=&NameCampoestivo=',
                            'w3-black w3-round w3-margin w3-button');
   MODGUI1.ChiudiDiv();
   MODGUI1.ChiudiDiv();
   modGUI1.ApriDiv('class="w3-row w3-container"');
    FOR campo IN (Select IdCampiEstivi,Nome,Stato,DataInizio,DataConclusione,Museo from CAMPIESTIVI)
    LOOP
        modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
            modGUI1.ApriDiv('class="w3-card-4" style="height:600px;"');
                htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%;">');
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
               modGUI1.Collegamento('VisualizzaCampiestivi',
                            'operazioniGruppo4.visualizzacampiestivi?campiestiviId='||campo.IdCampiEstivi,
                            'w3-green w3-margin w3-button');
               
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
   newStato in CAMPIESTIVI.Stato%TYPE default null, 
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
   modGUI1.ApriForm('operazioniGruppo4.confermacampiestivi','invia','w3-container');
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
   MODGUI1.LABEL('Stato');
     MODGUI1.SelectOpen('newStato');

   modGUI1.SelectOption('increazione','increazione');
   modGUI1.SelectOption('sospeso','sospeso');
   modGUI1.SelectOption('incorso','incorso');
   modGUI1.SelectOption('terminato','terminato');
   MODGUI1.SelectClose;
   htp.br;
   MODGUI1.LABEL('Data Inizio');
   modGUI1.InputDate('newDatainizio','newDatainizio',1,newDatainizio);
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
   newStato in CAMPIESTIVI.Stato%TYPE default null, 
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
   htp.br;
   htp.br;
   htp.br;
   htp.br;
   htp.br;
   htp.prn('<h1 align="center">Inserimento Campi Estivi</h1>');
   modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
   if (newNome is null) or (newMuseo is null) or (newStato is null)
      then MODGUI1.LABEL('Parametri inseriti in maniera errata');
      MODGUI1.ApriForm('operazioniGruppo4.inseriscicampiestivi');
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newMuseo',  newMuseo);
      HTP.FORMHIDDEN('newStato', newStato);
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
        htp.tabledata(newStato);
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

      MODGUI1.ApriForm('operazioniGruppo4.controllacampiestivi');
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newMuseo',  newMuseo);
      HTP.FORMHIDDEN('newStato', newStato);
      HTP.FORMHIDDEN('newDatainizio',newDatainizio);
      HTP.FORMHIDDEN('newDataConclusione',newDataConclusione);
      MODGUI1.InputSubmit('Conferma');
      MODGUI1.ChiudiForm;
      MODGUI1.ApriForm('operazioniGruppo4.inseriscicampiestivi');
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newMuseo',  newMuseo);
      HTP.FORMHIDDEN('newStato', newStato);
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
   newStato in CAMPIESTIVI.Stato%TYPE default null, 
   newDatainizio in VARCHAR2 default null,
   newDataConclusione in VARCHAR2 default null
)
is
   newidMuseo CAMPIESTIVI.MUSEO%TYPE default null;
   countmuseo NUMBER;
   countinserimenti NUMBER;
   v_dateini Date:= TO_DATE(newDatainizio default NULL on conversion error, 'YYYY-MM-DD');
   v_datefin Date:= TO_DATE(newDataConclusione default NULL on conversion error, 'YYYY-MM-DD');
BEGIN
   htp.htmlOpen;
   modgui1.APRIPAGINA('Viusalizza Campi Estivi');
   modgui1.HEADER();
   htp.bodyopen();
   htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
   Select count(*)
   into countmuseo
   from Musei
   where Nome=newMuseo;
      /* aggiungere controllo sulla data e sui not null*/
   
    modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
   if countmuseo = 0
      then 
      MODGUI1.LABEL('Il Museo inserito è inesistente');
     MODGUI1.ApriForm('operazioniGruppo4.inseriscicampiestivi');
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newMuseo',  newMuseo);
      HTP.FORMHIDDEN('newStato', newStato);
      HTP.FORMHIDDEN('newDatainizio',newDatainizio);
      HTP.FORMHIDDEN('newDataConclusione',newDataConclusione);
      MODGUI1.InputSubmit('Reinserisci');

   else 
      Select IdMuseo
      into newidMuseo
      from Musei
      where Nome=newMuseo;
      
      Select count(*)
      into countinserimenti
      from CAMPIESTIVI
      where newidMuseo=Museo and  newNome=Nome;
      
      if countinserimenti > 0
      then
         MODGUI1.LABEL('Il Campo inserito è già presente');
         MODGUI1.ApriForm('operazioniGruppo4.inseriscicampiestivi');
         HTP.FORMHIDDEN('newNome', newNome);
         HTP.FORMHIDDEN('newMuseo',  newMuseo);
         HTP.FORMHIDDEN('newStato', newStato);
         HTP.FORMHIDDEN('newDatainizio',newDatainizio);
         HTP.FORMHIDDEN('newDataConclusione',newDataConclusione);
         MODGUI1.InputSubmit('Reinserisci');
      else
         insert into CAMPIESTIVI VALUES (IDCAMPIESTIVISEQ.NEXTVAL,newStato,newNome,v_dateini,v_datefin,newidMuseo,0);
         htp.prn('<TABLE ALIGN=Center> <TR> <TD  ALIGN=Center> <b>Nome</b></TD><TD  ALIGN=Center> <b>IdMuseo</b> </TD> <TD  ALIGN=Center> <b>Stato</b> </TD> <TD  ALIGN=Center> <b>Datainizio</b> </TD> <TD  ALIGN=Center> <b>DataConclusione</b> </TD> </TR>');
         for CAMPOESTIVO in (select * from CAMPIESTIVI)
         LOOP
            htp.prn('<TR> <TD>'||CAMPOESTIVO.nome);
            htp.prn('</TD> <TD>'||CAMPOESTIVO.MUSEO);
            htp.prn('</TD> <TD>'||CAMPOESTIVO.STATO);
            htp.prn('</TD> <TD>'||CAMPOESTIVO.DATAINIZIO);
            htp.prn('</TD> <TD>'||CAMPOESTIVO.DATACONCLUSIONE);
            htp.prn('</TD> </TR>');
         end LOOP;
         htp.prn('</TABLE>');
      end if;
   end if;
         
   MODGUI1.ChiudiDiv;
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


   modgui1.ChiudiDiv();

END visualizzacampiestivi;

/*--------------------------------------------------------------MUSEI-----------------------------------------*/

procedure menumusei
(
   idsessione IN number default 0
)
   is
   begin
   htp.prn('<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> ');
   modGUI1.ApriPagina('MUSEI');
   modGUI1.Header();
   htp.br;htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 Align="center">Musei</h1>');
   MODGUI1.APRIDIV('class="w3-col l4 w3-padding-large w3-left"');
   htp.prn('<h1 Align="center">Inserimento</h1>');
   MODGUI1.APRIDIV('class="w3-center"');
   modGUI1.Collegamento('inserisci Musei',
                            'operazioniGruppo4.inseriscimuseo?newNome=&newIndirizzo=',
                            'w3-black w3-round w3-margin w3-button');
   MODGUI1.ChiudiDiv();
   MODGUI1.ChiudiDiv();
   MODGUI1.APRIDIV('class="w3-col l4 w3-padding-large w3-right"');
   htp.prn('<h1 Align="center">Statistiche</h1>');
    MODGUI1.APRIDIV('class="w3-center"');
   modGUI1.Collegamento('Statistiche1',
                            'operazioniGruppo4.form1monitoraggio?MuseoId=&NameMuseo=',
                            'w3-black w3-round w3-margin w3-button');
   modGUI1.Collegamento('Statistiche2',
                            'operazioniGruppo4.form2monitoraggio?MuseoId=&NameMuseo=&Data1=&Data2=',
                            'w3-black w3-round w3-margin w3-button');
   MODGUI1.ChiudiDiv();
   MODGUI1.ChiudiDiv();
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
                  modGUI1.Collegamento('VisualizzaMusei',
                            'operazioniGruppo4.visualizzaMusei?museoId='||museo.IdMuseo,
                            'w3-green w3-margin w3-button');
            
                  modGUI1.Collegamento('Modifica Musei',
                            'operazioniGruppo4.modificamusei?museoId='||museo.IdMuseo||'&newNome='||museo.Nome||'&newIndirizzo='||museo.Indirizzo,
                            'w3-red w3-margin w3-button');
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
    END LOOP;
    modGUI1.chiudiDiv;
   end;
   /*funzione che inserisce un museo-*/
procedure inseriscimuseo
( 
   idsessione IN number default 0,
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
)
is
BEGIN
   htp.htmlOpen;
   modgui1.APRIPAGINA('Inserisci Museo');
   modgui1.HEADER();
   htp.bodyOpen;
   htp.br;
   htp.br;
   htp.br;
   htp.br;
   htp.br;
   htp.br;  
   htp.prn('<h1 align="center">Inserimento Musei</h1>');
   MODGUI1.APRIDIV('class="w3-modal-content w3-card-4" style="max-width:600px"');
   modgui1.ApriForm('operazioniGruppo4.confermamusei','invia','w3-container');
    modGUI1.Collegamento('M','operazioniGruppo4.menumusei?idsessione='||idsessione,'w3-btn  w3-black w3-display-topright ');
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
   htp.br;
   htp.br;
   htp.br;
    htp.br;
   htp.br;
   modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
   if (newNome is null) or (newIndirizzo is null)
     then MODGUI1.LABEL('Parametri inseriti in maniera errata');

     MODGUI1.ApriForm('operazioniGruppo4.inseriscimuseo');
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

      MODGUI1.ApriForm('operazioniGruppo4.controllamusei');
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newIndirizzo',  newIndirizzo);
      MODGUI1.InputSubmit('Conferma');
      MODGUI1.ChiudiForm;

      MODGUI1.ApriForm('operazioniGruppo4.inseriscimuseo');
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
      MODGUI1.RedirectEsito(0,'Inserimento fallito', null,'Inserisci una nuovo museo','operazioniGruppo4.inseriscimuseo','//newNome='||newNome||'//newIndirizzo='||newIndirizzo,'Torna al menu musei','operazioniGruppo4.menumusei',null);
 ELSE
      insert into Musei VALUES (IdMuseoseq.NEXTVAL,newNome,newIndirizzo,0);
      MODGUI1.RedirectEsito(0,'Inserimento completato', null,'Inserisci una nuovo museo','operazioniGruppo4.inseriscimuseo','//newNome='||newNome||'//newIndirizzo='||newIndirizzo,'Torna al menu musei','operazioniGruppo4.menumusei',null);
   end if;
      htp.bodyClose;
      htp.htmlClose;


END controllamusei;
procedure visualizzamusei
(
   idsessione IN number default 0,
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
   modGUI1.Collegamento('Torna al menù','operazioniGruppo4.menumusei?idsessione='||idsessione,'w3-btn w3-round w3-black ');
   modgui1.ChiudiDiv();

END visualizzamusei;
procedure modificamusei
(
   idsessione IN number default 0,
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
   modgui1.ApriForm('operazioniGruppo4.confermamodificamuseo','invia','w3-container');
   modGUI1.Collegamento('M','operazioniGruppo4.menumusei?idsessione='||idsessione,'w3-btn  w3-black w3-display-topright ');
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

     MODGUI1.ApriForm('operazioniGruppo4.modificamusei');
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

      MODGUI1.ApriForm('operazioniGruppo4.updatemusei');
      HTP.FORMHIDDEN('MuseoId', MuseoId);
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newIndirizzo',  newIndirizzo);
      MODGUI1.InputSubmit('Conferma');
      MODGUI1.ChiudiForm;

      MODGUI1.ApriForm('operazioniGruppo4.modificamusei');
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
MODGUI1.RedirectEsito(0,'Modifica riuscita','Museo modificato correttamente',null,null,null,'Torna al menu musei','operazioniGruppo4.menumusei',null);

end updatemusei;
/*----------statistiche musei----*/
procedure form1monitoraggio
(
   idsessione IN number default 0,
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
  modGUI1.Collegamento('M','operazioniGruppo4.menumusei?idsessione='||idsessione,'w3-btn  w3-black w3-display-topright ');
  modGUI1.ApriForm('operazioniGruppo4.controllastatistica','invia','w3-container'); 
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
  modGUI1.ApriForm('operazioniGruppo4.controllastatistica2','invia','w3-container'); 
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
  idsessione IN number default 0,
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
modGUI1.Collegamento('menù','operazioniGruppo4.menumusei?idsessione='||idsessione,'w3-btn w3-round-xxlarge w3-black ');
htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
modGUI1.Collegamento('statistiche','operazioniGruppo4.form1monitoraggio?idsessione='||idsessione||'&MuseoId='||MuseoId||'&NameMuseo=','w3-btn w3-round-xxlarge w3-black ');
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
htp.bodyClose;
END salepresenti;
/*OPERE PRESENTI NEL MUSEO*/
procedure operepresentimuseo
(
   idsessione IN number default 0,
   MuseoId IN  Musei.IdMuseo%TYPE
)
/*problema*/
IS
  CURSOR oper_cursor IS
  Select DISTINCT Opere.Titolo,Opere.Anno,Opere.FinePeriodo
  FROM OPERE,STANZE,SALEOPERE
  WHERE STANZE.MUSEO=MuseoId AND STANZE.IdStanza=SALEOPERE.Sala AND  OPERE.IdOpera=SALEOPERE.Opera AND SALEOPERE.DataUscita IS NULL;
  val_ope oper_cursor%Rowtype;

BEGIN
MODGUI1.ApriPagina('Visualizzazione opere museo');
MODGUI1.HEADER();
  htp.br;htp.br;htp.br;htp.br;
htp.prn('<h1 align="center">Opere Museo</h1>');

MODGUI1.APRIDIV('class="w3-center"');
modGUI1.Collegamento('menù','operazioniGruppo4.menumusei?idsessione='||idsessione,'w3-btn w3-round-xxlarge w3-black ');
htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
modGUI1.Collegamento('statistiche','operazioniGruppo4.form1monitoraggio?idsessione='||idsessione||'&MuseoId='||MuseoId||'&NameMuseo=','w3-btn w3-round-xxlarge w3-black ');
MODGUI1.ChiudiDiv;

modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px; margin-top:110px"');
HTP.TABLEOPEN(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"' );
      HTP.TableRowOpen;
      HTP.TableData('Titolo opera',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Anno opera',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Periodo opera',CATTRIBUTES  =>'style="font-weight:bold"');
      /* inserire il tipo stanza*/
      HTP.TableRowClose;
FOR val_ope in oper_cursor
loop
    HTP.TableRowOpen;
    HTP.TableData(val_ope.Titolo);
    HTP.TableData(val_ope.Anno ,'center');
    HTP.TableData(val_ope.FinePeriodo,'center');
    HTP.TableRowClose;
    
end loop; 
modGUI1.ChiudiDiv();
htp.bodyClose;
END operepresentimuseo;

procedure opereprestate
(
   idsessione IN number default 0,
   MuseoId IN MUSEI.IdMuseo%TYPE
)
/*problema*/
is 
CURSOR oper_cursor IS
Select  DISTINCT Opere.Titolo,Opere.Anno,Opere.FinePeriodo
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
modGUI1.Collegamento('menù','operazioniGruppo4.menumusei?idsessione='||idsessione,'w3-btn w3-round-xxlarge w3-black ');
htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
modGUI1.Collegamento('statistiche','operazioniGruppo4.form1monitoraggio?idsessione='||idsessione||'&MuseoId='||MuseoId||'&NameMuseo=','w3-btn w3-round-xxlarge w3-black ');
MODGUI1.ChiudiDiv;

modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px; margin-top:110px"');
HTP.TABLEOPEN(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"' );
      HTP.TableRowOpen;
      HTP.TableData('Titolo opera',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Anno opera',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Periodo opera',CATTRIBUTES  =>'style="font-weight:bold"');
      /* inserire il tipo stanza*/
      HTP.TableRowClose;
FOR val_ope in oper_cursor
loop
    HTP.TableRowOpen;
    HTP.TableData(val_ope.Titolo);
    HTP.TableData(val_ope.Anno ,'center');
    HTP.TableData(val_ope.FinePeriodo,'center');
    HTP.TableRowClose;
    
end loop;
HTP.TableClose;
modGUI1.ChiudiDiv();
htp.bodyClose;
END opereprestate;
/*scelta statistica*/
procedure visitatoriunici
(
   idsessione IN number default 0,
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
modGUI1.Collegamento('menù','operazioniGruppo4.menumusei?idsessione='||idsessione,'w3-btn w3-round-xxlarge w3-black ');
htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
modGUI1.Collegamento('statistiche','operazioniGruppo4.form2monitoraggio?idsessione='||idsessione||'&MuseoId='||MuseoId||'&NameMuseo=','w3-btn w3-round-xxlarge w3-black ');
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
htp.bodyClose;
end visitatoriunici;

procedure visitatorimedi 
(
   idsessione IN number default 0,
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
modGUI1.Collegamento('menù','operazioniGruppo4.menumusei?idsessione='||idsessione,'w3-btn w3-round-xxlarge w3-black ');
htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
modGUI1.Collegamento('statistiche','operazioniGruppo4.form2monitoraggio?idsessione='||idsessione||'&MuseoId='||MuseoId||'&NameMuseo=','w3-btn w3-round-xxlarge w3-black ');
MODGUI1.ChiudiDiv;
htp.prn('<p align="center"><b>numero dei visitatori medi nel periodo ' || Data1 ||'--'|| Data2 ||':</b> ' || mvisitatori ||'</p>');

end; 
procedure introitimuseo
(
   idsessione IN number default 0,
   MuseoId IN Musei.IdMuseo%TYPE
)
is 
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
modGUI1.Collegamento('menù','operazioniGruppo4.menumusei?idsessione='||idsessione,'w3-btn w3-round-xxlarge w3-black ');
htp.print('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
modGUI1.Collegamento('statistiche','operazioniGruppo4.form1monitoraggio?idsessione='||idsessione||'&MuseoId='||MuseoId||'&NameMuseo=','w3-btn w3-round-xxlarge w3-black ');
MODGUI1.ChiudiDiv;

htp.br;
modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px; margin-top:110px"');
HTP.TABLEOPEN(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"' );
      HTP.TableRowOpen;
      HTP.TableData('Introti del museo: ',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData( introiti_museo|| ' €');
      HTP.TableRowClose;
     
      HTP.TableRowOpen;
      HTP.TableData('Introti dei campiestivi: ',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData( introiti_campiestivi|| ' €');
      HTP.TableRowClose;
      HTP.TableRowOpen;
      HTP.TableData('Introti totali: ',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData( introiti_totale || ' €');
      HTP.TableRowClose;
HTP.TableClose;
      /* inserire il tipo stanza*/
      
modgui1.chiudiDiv();
htp.bodyClose;
end introitimuseo;

procedure controllastatistica
(
   idsessione IN number default 0,
   MuseoId IN MUSEI.IdMuseo%TYPE,
   scelta in number
)
is begin
if scelta=2
   then operepresentimuseo(idsessione,MuseoId);
else if scelta=1
   then salepresenti(idsessione,MuseoId);
   else if scelta=3
   then opereprestate(idsessione,MuseoId);
   else if scelta=4
   then introitimuseo(idsessione,MuseoId);
   end if;
   end if;
end if;
  end if;
end controllastatistica;


procedure controllastatistica2
(
   idsessione IN number default 0,
   MuseoId IN MUSEI.IdMuseo%TYPE,
   scelta in number,
   Data1 VARCHAR2,
   Data2  varchar2
)
is 

begin
if scelta=5
   then visitatoriunici(idsessione,MuseoId,Data1,Data2);
else if scelta=6
   then visitatorimedi(idsessione,MuseoId,Data1,Data2);
end if;
  end if;
end controllastatistica2;

/*---------------STATISTICHE CAMPI ESTIVI-------------------------------*/
procedure form1campiestivi
(
   idsessione IN number default 0,
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
  modGUI1.ApriForm('operazioniGruppo4.controllastatisticacampo','invia','w3-container'); 
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
   then utentiiscritti(0,CampoestivoId);
else if scelta=2
   then tariffecampi(0,CampoestivoId);
else if scelta=3
   then etamediatariffe(0,CampoestivoId);
   end if;
   end if;
  end if;
end controllastatisticacampo;

procedure utentiiscritti
(
   sessionID IN number default 0,
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
   sessionID IN number default 0,
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

procedure etamediatariffe(
   sessionID IN number default 0,
   CampoestivoId IN CAMPIESTIVI.IDCAMPIESTIVI%TYPE
)IS
Cursor tarif_cursor IS
    Select tce.IDTARIFFA, trunc(avg(etam.eta),0) as etamedia
    from vistaetamedia etam, tariffecampiestivi tce
    WHERE CampoestivoId = tce.campoestivo AND tce.idtariffa = etam.idtariffa
    group by tce.IDTARIFFA;
    val_tarif tarif_cursor%RowType;
begin
    MODGUI1.ApriPagina('Eta Media Tariffe Campi Estivi');
    MODGUI1.HEADER();
htp.br;htp.br;htp.br;htp.br;
htp.prn('<h1 align="center">Tariffe Campo estivo </h1>');
modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px; margin-top:110px"');
 
HTP.TABLEOPEN(CALIGN  => 'center',CATTRIBUTES =>'class="w3-table w3-striped"' );
      HTP.TableRowOpen;
      HTP.TableData('id tariffa',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Età Media',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableRowClose;
 
FOR val_tarif in tarif_cursor
loop
   HTP.TableRowOpen;
   HTP.TableData(val_tarif.IDTARIFFA,'center');
   HTP.TableData(val_tarif.etamedia,'center');  
   HTP.TableRowClose;
end loop;
HTP.TableClose;
modGUI1.ChiudiDiv();
htp.bodyClose;
end etamediatariffe;
end operazioniGruppo4;
-- SET DEFINE ON;