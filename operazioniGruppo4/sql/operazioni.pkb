Create or replace PACKAGE body operazioniGruppo4 as
procedure inseriscicampiestivi
(
   newNome in CAMPIESTIVI.Nome%TYPE default null,
   newMuseo in Musei.Nome%TYPE,
   newStato in CAMPIESTIVI.Stato%TYPE default null, 
   newDatainizio in CAMPIESTIVI.DataInizio%TYPE default null,
   newDataConclusione in CAMPIESTIVI.DATACONCLUSIONE%TYPE default null
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
   htp.print('<H1 ALIGN=CENTER>');
   modgui1.LABEL('Immetti i dati dei Campi Estivi');
   htp.print('</H1>');
   htp.br;
   htp.br;  
   
   modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
   modGUI1.ApriForm('operazioniGruppo4.controllacampiestivi','invia','w3-container');
   MODGUI1.LABEL('Nome');
   modgui1.INPUTTEXT('newNome','Nome',1);
   htp.br;
   MODGUI1.LABEL('Nome Museo');
   modgui1.INPUTTEXT('newMuseo','Nome Museo',1);
   htp.br;
   MODGUI1.LABEL('Stato');
   htp.br;
   htp.formSelectOpen('newStato');
   htp.formSelectOption('increazione');
   htp.formSelectOption('sospeso');
   htp.formSelectOption('incorso');
   htp.formSelectOption('terminato');
   htp.formSelectClose;
   htp.br;
   htp.br;
   MODGUI1.LABEL('Data Inizio');
   modGUI1.InputDate('Inserisci data inizio','newDatainizio');
   htp.br;
   MODGUI1.LABEL('DataConclusione');
    modGUI1.InputDate('Inserisci data fine','newDataConclusione');
    htp.br;
    htp.br;
   modgui1.INPUTSUBMIT('Invia');

   modgui1.ChiudiForm;
   modgui1.ChiudiDiv;
   htp.bodyClose; 
   htp.htmlClose;
END inseriscicampiestivi;

procedure controllacampiestivi
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
   htp.br;
   
   Select IdMuseo
   into newidMuseo
   from Musei
   where Nome=newMuseo;
   /*controllo sulla data*/
   
   if newidMuseo is NULL
      then MODGUI1.LABEL('Il Museo inserito è inesistente');
   else insert into CAMPIESTIVI VALUES (IDCAMPIESTIVISEQ.NEXTVAL,newStato,newNome,v_dateini,v_datefin,newidMuseo);
        htp.print('<H1 ALIGN=CENTER>');
      MODGUI1.LABEL('Campo estivo inserito correttamente');
        htp.print('</H1>');
      modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
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
         
   MODGUI1.ChiudiDiv;
   htp.bodyclose();
   htp.htmlClose();
END controllacampiestivi;
/*-------------------------------------*/
procedure inseriscimuseo
( 
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
)
is
BEGIN
   htp.htmlOpen;
   modgui1.APRIPAGINA(TITOLO  => 'Inserisci Museo');
   modgui1.HEADER();
   htp.bodyOpen;
   htp.br;
   htp.br;
   htp.br;
   htp.br;
   htp.print('<H1 ALIGN=CENTER>');
   modgui1.LABEL(TESTO  =>'Immetti i dati dei musei');
   htp.print('</H1>');
   htp.br;
   htp.br;  
   MODGUI1.APRIDIV('class="w3-modal-content w3-card-4" style="max-width:600px"');
   modgui1.ApriForm('operazioniGruppo4.controllamusei','invia','w3-container');
   modgui1.LABEL(TESTO  =>'Nome museo');
   modgui1.INPUTTEXT(NOME  =>'newNome',PLACEHOLDER  => 'Nome',REQUIRED  =>0);
   htp.br;
   htp.br;  
   modgui1.LABEL(TESTO  =>'Indirizzo museo');
   modgui1.INPUTTEXT(NOME  =>'newIndirizzo',PLACEHOLDER  => 'Indirizzo',REQUIRED  =>0);
   htp.br;
   htp.br;  
   modgui1.INPUTSUBMIT(TESTO  =>'Invia');
   modgui1.ChiudiForm;
   modgui1.ChiudiDiv;
   htp.bodyClose; 
   htp.htmlClose;
END inseriscimusei;
procedure controllamusei
(
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
)
is
quanti Number;
BEGIN
   htp.htmlOpen;
   modgui1.APRIPAGINA(TITOLO  => 'Viusalizza Museo');
   modgui1.HEADER();

   htp.bodyOpen;
   htp.br;
   htp.br;
   htp.br;
   htp.br;
   htp.print('<H1 ALIGN=CENTER>');
   modgui1.LABEL(TESTO  =>'Risultato Inserimento');
   htp.print('</H1>');
   htp.br;
   htp.br;  
 
   htp.br;
   htp.br;
   modGUI1.ApriDiv('class="w3-modal-content w3-card-4" style="max-width:600px"');
   if(newNome is null) or(newIndirizzo is null)
      then htp.prn('Nome Museo o Indirizzo Museo non specificato');
   ELSE
      select count(*) into quanti
      from MUSEI
      where  newNome = Musei.NOME and newIndirizzo = Musei.Indirizzo;
      if quanti >0
         then htp.prn('Il Museospecificato è già stato inserito');
      ELSE
         insert into Musei(IdMuseo,Nome,Indirizzo) VALUES (IdMuseoseq.NEXTVAL,newNome,newIndirizzo);
         htp.prn('<TABLE ALIGN=Center> <TR> <TD ALIGN=Center> <b>Nome</b></TD><TD ALIGN=Center> <b>Indirizzo</b> </TD> </TR>');
         for museo in (select nome,indirizzo from MUSEI)
         LOOP
         htp.prn('<TR> <TD>'||museo.nome);
         htp.prn('</TD> <TD>'||museo.indirizzo);
         htp.prn('</TD> </TR>');
         end LOOP;
         htp.prn('</TABLE>');
      end if;
   end if;
   MODGUI1.ChiudiDiv;
      htp.bodyClose;
      htp.htmlClose;


END controllamusei;
end operazioniGruppo4;
