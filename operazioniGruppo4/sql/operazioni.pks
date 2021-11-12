create or replace package operazioniGruppo4 as

procedure controllacampiestivi
(
   newNome in CAMPIESTIVI.Nome%TYPE default null,
   newMuseo in Musei.Nome%TYPE,
   newStato in CAMPIESTIVI.Stato%TYPE default null, 
   newDatainizio in VARCHAR2 default null,
   newDataConclusione in VARCHAR2 default null
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

end operazioniGruppo4;