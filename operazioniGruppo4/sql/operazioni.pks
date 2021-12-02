create or replace package operazioniGruppo4 as

/*OPERAZIONI CAMPIESTIVI*/
procedure menucampiestivi
(
   idsessione IN number default 0
);
procedure menumusei
(
   idsessione IN number default 0
);
procedure inseriscicampiestivi
(
   newNome in CAMPIESTIVI.Nome%TYPE default null,
   newMuseo in Musei.Nome%TYPE,
   newStato in CAMPIESTIVI.Stato%TYPE default null, 
   newDatainizio in VARCHAR2 default null,
   newDataConclusione in VARCHAR2 default null
);
procedure confermacampiestivi
(
   newNome in CAMPIESTIVI.Nome%TYPE default null,
   newMuseo in Musei.Nome%TYPE,
   newStato in CAMPIESTIVI.Stato%TYPE default null, 
   newDatainizio in VARCHAR2 default null,
   newDataConclusione in VARCHAR2 default null
);
procedure controllacampiestivi
(
   newNome in CAMPIESTIVI.Nome%TYPE default null,
   newMuseo in Musei.Nome%TYPE,
   newStato in CAMPIESTIVI.Stato%TYPE default null, 
   newDatainizio in VARCHAR2 default null,
   newDataConclusione in VARCHAR2 default null
);
procedure visualizzacampiestivi
(
   campiestiviId IN  CAMPIESTIVI.IdCampiEstivi%TYPE
);
/*OPERAZIONI MUSEO*/
procedure inseriscimuseo
( 
   idsessione IN number default 0,
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
);
procedure confermamusei
(
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
);
procedure controllamusei
(
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
);
procedure visualizzamusei
(
   idsessione IN number default 0,
   MuseoId IN MUSEI.IdMuseo%TYPE
);
procedure modificamusei 
(
   idsessione IN number default 0,
   MuseoId IN MUSEI.IdMuseo%TYPE,
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
);
procedure confermamodificamuseo
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
);
procedure updatemusei
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
);
/*STATISTICHE MUSEO*/
procedure controllastatistica
(
   idsessione IN number default 0,
   MuseoId IN MUSEI.IdMuseo%TYPE,
   scelta in number
);
procedure controllastatistica2
(
   idsessione IN number default 0,
   MuseoId IN MUSEI.IdMuseo%TYPE,
   scelta in number,
   Data1 varchar2,
   Data2 varchar2
);
procedure form1monitoraggio
(
   idsessione IN number default 0,
   MuseoId IN MUSEI.IdMuseo%TYPE,
   NameMuseo IN MUSEI.NOME%TYPE
);
procedure form2monitoraggio
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   NameMuseo IN MUSEI.NOME%TYPE,
   Data1 VARCHAR2,
   Data2 VARCHAR2
);


procedure salepresenti
(
   idsessione IN number default 0,
   MuseoId IN  Musei.IdMuseo%TYPE
);
procedure operepresentimuseo
(
   idsessione IN number default 0,
   MuseoId IN  Musei.IdMuseo%TYPE
);
procedure opereprestate
(
   idsessione IN number default 0,
   MuseoId IN Musei.IdMuseo%TYPE
);
procedure introitimuseo
(
   idsessione IN number default 0,
   MuseoId IN Musei.IdMuseo%TYPE
);
procedure visitatoriunici
(
    idsessione IN number default 0,
   MuseoId IN MUSEI.IdMuseo%TYPE,
   Data1 VARCHAR2,
   Data2 VARCHAR2
);
procedure visitatorimedi 
(
   idsessione IN number default 0,
   MuseoId IN MUSEI.IdMuseo%TYPE,
   Data1 VARCHAR2,
   Data2 VARCHAR2
);
/*---------statistiche CAMPI ESTIVI-----------*/
procedure form1campiestivi
(
   idsessione IN number default 0,
   CampoestivoId IN CAMPIESTIVI.IDCAMPIESTIVI%TYPE,
   NameCampoestivo IN CAMPIESTIVI.NOME%TYPE
);
procedure controllastatisticacampo
(
   CampoestivoId IN CAMPIESTIVI.IDCAMPIESTIVI%TYPE,
   scelta in number
);
procedure utentiiscritti
(
   sessionID IN number default 0,
   CampoestivoId IN CAMPIESTIVI.IDCAMPIESTIVI%TYPE
);
procedure tariffecampi
(
   sessionID IN number default 0,
   CampoestivoId IN CAMPIESTIVI.IDCAMPIESTIVI%TYPE
);
procedure etamediatariffe(
   sessionID IN number default 0,
   CampoestivoId IN CAMPIESTIVI.IDCAMPIESTIVI%TYPE
);
end operazioniGruppo4;