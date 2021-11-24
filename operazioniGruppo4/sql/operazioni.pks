create or replace package operazioniGruppo4 as

/*OPERAZIONI CAMPIESTIVI*/
procedure menucampiestivi;
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
procedure modificamusei /*da finire*/
(
   newNome in Musei.Nome%TYPE default null,
   newIndirizzo in MUSEI.INDIRIZZO%TYPE default null
);
/*STATISTICHE MUSEO*/
procedure controllastatistica
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   scelta in number
);
procedure form1monitoraggio
(
   MuseoId IN MUSEI.IdMuseo%TYPE,
   NameMuseo IN MUSEI.NOME%TYPE
);


procedure salepresenti
(
   sessionID IN number default 0,
   MuseoId IN  Musei.IdMuseo%TYPE
);
procedure operepresentimuseo
(
   sessionID IN number default 0,
   MuseoId IN  Musei.IdMuseo%TYPE
);
procedure opereprestate
(
   sessionID IN number default 0,
   MuseoId IN Musei.IdMuseo%TYPE
);
/*---------statistiche CAMPI ESTIVI-----------*/
procedure form1campiestivi
(
   CampoestivoId IN CAMPIESTIVI.IDCAMPIESTIVI%TYPE,
   NameCampoestivo IN CAMPIESTIVI.NOME%TYPE,
   SessionId In NUMBER default 0
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
end operazioniGruppo4;