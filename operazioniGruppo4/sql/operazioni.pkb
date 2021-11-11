Create or replace PACKAGE body operazioniGruppo4 as
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
   modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
   modGUI1.ApriForm('operazioniGruppo4.confermacampiestivi','invia','w3-container');
   MODGUI1.LABEL('Nome');
   modgui1.INPUTTEXT('newNome','Nome',1);
   htp.br;  
   MODGUI1.LABEL('Nome Museo');
   modgui1.INPUTTEXT('newMuseo','Nome Museo',1);
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
         insert into CAMPIESTIVI VALUES (IDCAMPIESTIVISEQ.NEXTVAL,newStato,newNome,v_dateini,v_datefin,newidMuseo);
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
   MODGUI1.APRIDIV('class="w3-modal-content w3-card-4" style="max-width:600px"');
   modgui1.ApriForm('operazioniGruppo4.confermamusei','invia','w3-container');
   modgui1.LABEL('Nome museo');
   modgui1.INPUTTEXT('newNome','Nome',0);
   htp.br;
   modgui1.LABEL('Indirizzo museo');
   modgui1.INPUTTEXT('newIndirizzo','Indirizzo',0);
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
   modgui1.APRIPAGINA('Viusalizza Museo');
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
end operazioniGruppo4;