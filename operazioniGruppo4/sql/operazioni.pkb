Create or replace PACKAGE body operazioniGruppo4 as
/*visualizza tutti i campi estivi*/
procedure menucampiestivi
   is
   begin
   htp.prn('<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> ');
   modGUI1.ApriPagina('Campi Estivi');
   modGUI1.Header();
   htp.br;htp.br;htp.br;htp.br;htp.br;
   htp.prn('<h1 Align="center">Campi Estivi</h1>');
   modGUI1.ApriDiv('class="w3-row w3-container"');
    FOR campo IN (Select IdCampiEstivi,Nome,Stato,DataInizio,DataConclusione,Museo from CAMPIESTIVI)
    LOOP
        modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
            modGUI1.ApriDiv('class="w3-card-4" style="height:600px;"');
                htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%;">');
                modGUI1.ApriDiv('class="w3-container w3-center"');
                    htp.prn('<p>'|| campo.Nome ||' '||campo.Stato||' '||campo.DataInizio||' ' ||campo.DataConclusione||' ' ||campo.Museo||'</p>');
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
BEGIN
   htp.htmlOpen;
   modGUI1.ApriPagina();
   modGUI1.Header();
   htp.bodyOpen;
   htp.br;
   htp.br;  
   htp.br;
   htp.br;  
   htp.br;
   htp.br;  
   htp.prn('<h1 align="center">Inserimento Campi Estivi</h1>');
   modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
   modGUI1.ApriForm('operazioniGruppo4.confermacampiestivi','invia','w3-container');
   MODGUI1.LABEL('Nome');
   modgui1.INPUTTEXT('newNome','Nome',1,newNome);
   htp.br;  
   MODGUI1.LABEL('Nome Museo');
   modgui1.INPUTTEXT('newMuseo','Nome Museo',1,newMuseo);
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
    modGUI1.InputDate('newDataConclusione','newDataConclusione',1,newDataConclusione);
    htp.br;
    htp.br;
   modgui1.INPUTSUBMIT('Invia');

   modgui1.ChiudiForm;
   modgui1.ChiudiDiv;
   htp.bodyClose; 
   htp.htmlClose;
END inseriscicampiestivi;


/*Funzione per confermare o annulare l'iserimento di un campo estivo*/
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
     HTP.TableOpen;
      HTP.TableRowOpen;
      HTP.TableData('Nome: ');
      HTP.TableData(newNome);
      HTP.TableRowClose;
      HTP.TableRowOpen;
      HTP.TableData('Museo: ');
      HTP.TableData(newMuseo);
      HTP.TableRowClose;
      HTP.TableRowOpen;
      HTP.TableData('Stato: ');
      HTP.TableData(newStato);
      HTP.TableRowClose;
      HTP.TableRowOpen;
      HTP.TableData('Data inizio: ');
      HTP.TableData(newDatainizio);
      HTP.TableRowClose;
      HTP.TableRowOpen;
      HTP.TableData('Data Conclusione: ');
      HTP.TableData(newDataConclusione);
      HTP.TableRowClose;
      HTP.TableClose;

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
   htp.br;
   htp.br;
   htp.br;
   htp.br;
   htp.br;
   htp.br;
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

   htp.tableopen('ALIGN CENTER');
        htp.tablerowopen;
        htp.tabledata('Nome: ');
        htp.tabledata(campo.Nome);
        htp.tablerowclose;
        htp.tablerowopen;
        htp.tabledata('Stato: ');
        htp.tabledata(campo.stato);
        htp.tablerowclose;
        htp.tablerowopen;
        htp.tabledata('Data inizio: ');
        htp.tabledata(campo.DataInizio);
        htp.tablerowclose;
        htp.tablerowopen;
        htp.tabledata('Data Conclusione: ');
        htp.tabledata(campo.DataConclusione);
        htp.tablerowclose;
        htp.tablerowopen;
        htp.tabledata('Museo: ');
        htp.tabledata(campo.Museo);
        htp.tablerowclose;


   modgui1.ChiudiDiv();

END visualizzacampiestivi;
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
   htp.br;
   htp.br;
   htp.br;
   htp.br;
   htp.br;
   htp.br;  
   htp.prn('<h1 align="center">Inserimento Musei</h1>');
   MODGUI1.APRIDIV('class="w3-modal-content w3-card-4" style="max-width:600px"');
   modgui1.ApriForm('operazioniGruppo4.confermamusei','invia','w3-container');
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
      HTP.TableData('Nome: ');
      HTP.TableData(newNome);
      HTP.TableRowClose;
      HTP.TableRowOpen;
      HTP.TableData('Indirizzo: ');
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
   htp.br;
   htp.br;
   htp.br;
   htp.br;
   htp.br;
   htp.br;
   modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
   select count(*) into quanti
   from MUSEI
   where  newNome = Musei.NOME;
   if quanti >0
      then 
      MODGUI1.Label('Il Museo specificato è già stato inserito');
      MODGUI1.ApriForm('operazioniGruppo4.inseriscimuseo');
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newIndirizzo',  newIndirizzo);
      MODGUI1.InputSubmit('Reinserisci');
      MODGUI1.ChiudiForm;
 ELSE
      insert into Musei(IdMuseo,Nome,Indirizzo) VALUES (IdMuseoseq.NEXTVAL,newNome,newIndirizzo);
       htp.print('<H1 ALIGN=CENTER>');
      modgui1.LABEL('Museo inserito correttamente');
      htp.print('</H1>');
      htp.prn('<TABLE ALIGN=Center> <TR> <TD ALIGN=Center> <b>Nome</b></TD><TD ALIGN=Center> <b>Indirizzo</b> </TD> </TR>');
      for museo in (select nome,indirizzo from MUSEI)
      LOOP
         htp.prn('<TR> <TD>'||museo.nome);
         htp.prn('</TD> <TD>'||museo.indirizzo);
         htp.prn('</TD> </TR>');
      end LOOP;
      htp.prn('</TABLE>');
      MODGUI1.ApriForm('operazioniGruppo4.inseriscimuseo');
      HTP.FORMHIDDEN('newNome', newNome);
      HTP.FORMHIDDEN('newIndirizzo',  newIndirizzo);
      MODGUI1.InputSubmit('Reinserisci');
   end if;
   
   MODGUI1.ChiudiForm;
   MODGUI1.ChiudiDiv;
      htp.bodyClose;
      htp.htmlClose;


END controllamusei;
procedure modificamusei
(
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
   modgui1.ApriForm('operazioniGruppo4.confermamusei','invia','w3-container');/*da completare*/
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
  sessionID IN number default 0,
   MuseoId IN  Musei.IdMuseo%TYPE
)
is 
CURSOR sal_cursor IS
Select STANZE.Nome,STANZE.Dimensione,SALE.NUMOPERE
FROM STANZE,SALE
WHERE STANZE.MUSEO=MuseoId AND STANZE.IdStanza=SALE.IdStanza;
val_sal sal_cursor%Rowtype;

BEGIN
/*controllo sull'ID*/
MODGUI1.ApriPagina('Visualizzazione sale museo');
MODGUI1.HEADER();
  htp.br;htp.br;htp.br;htp.br;
htp.prn('<h1 align="center">Sale Museo</h1>');
modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px; margin-top:110px"');
HTP.TABLEOPEN(CALIGN  => 'center' );
      HTP.TableRowOpen;
      HTP.TableData('Nome Stanza',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Dimensione Stanza',CATTRIBUTES  =>'style="font-weight:bold"');
      HTP.TableData('Numero Opere Stanza',CATTRIBUTES  =>'style="font-weight:bold"');
      /* inserire il tipo stanza*/
      HTP.TableRowClose;
FOR val_sal in sal_cursor
loop
    HTP.TableRowOpen;
    HTP.TableData(val_sal.Nome);
    HTP.TableData(val_sal.Dimensione ,'center');
    HTP.TableData(val_sal.NUMOPERE,'center');
    HTP.TableRowClose;
    
end loop;
HTP.TableClose;
modGUI1.ChiudiDiv();
htp.bodyClose;
END salepresenti;
/*OPERE PRESENTI NEL MUSEO*/
procedure operepresentimuseo
(
   sessionID IN number default 0,
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
modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px; margin-top:110px"');
HTP.TABLEOPEN(CALIGN  => 'center' );
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
END operepresentimuseo;

procedure opereprestate
(
   sessionID IN number default 0,
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
modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px; margin-top:110px"');
HTP.TABLEOPEN(CALIGN  => 'center' );
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
   sessionID IN number default 0,
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
htp.prn('<p align="center"><b>numero visitatori museo periodo ' || Data1 ||'--'|| Data2 ||':</b> ' || nvisitatori ||'</p>');
modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:1600px; margin-top:110px"');
HTP.TABLEOPEN(CALIGN  => 'center' );
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

procedure introitimuseo
(
   sessionID in number default 0,
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
htp.br;
modgui1.apridiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px; margin-top:110px"');
HTP.TABLEOPEN(CALIGN  => 'center',   CATTRIBUTES =>'style="font-size:20px"' );
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
   MuseoId IN MUSEI.IdMuseo%TYPE,
   scelta in number
)
is begin
if scelta=2
   then operepresentimuseo(0,MuseoId);
else if scelta=1
   then salepresenti(0,MuseoId);
   else if scelta=3
   then opereprestate(0,MuseoId);
   else if scelta=4
   then introitimuseo(0,MuseoId);
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
   then visitatoriunici(0,MuseoId,Data1,Data2);
else if scelta=6
   then salepresenti(0,MuseoId);
end if;
  end if;
end controllastatistica2;

/*---------------STATISTICHE CAMPI ESTIVI-------------------------------*/
procedure form1campiestivi
(
   CampoestivoId IN CAMPIESTIVI.IDCAMPIESTIVI%TYPE,
   NameCampoestivo IN CAMPIESTIVI.NOME%TYPE,
   SessionId In NUMBER default 0
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

  htp.prn('<h1 align="center">Scegli museo</h1>');
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

HTP.TABLEOPEN(CALIGN  => 'center' );
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

HTP.TABLEOPEN(CALIGN  => 'center' );
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
end operazioniGruppo4;