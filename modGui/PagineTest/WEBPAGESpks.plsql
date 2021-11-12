CREATE OR REPLACE PACKAGE WebPages as

procedure BodyHome (idSessione varchar2 default 0);
procedure MuseiHome (idSessione int default 0);
procedure CampiEstiviHome (idSessione int default 0);
PROCEDURE Inserimento(idSessione NUMBER DEFAULT 0);
PROCEDURE Conferma(
    idSessione NUMBER DEFAULT 0,
    nome VARCHAR2 DEFAULT 'Sconosciuto',
    cognome VARCHAR2 DEFAULT 'Sconosciuto',
    dataNascita VARCHAR2 DEFAULT NULL,
    dataMorte VARCHAR2 DEFAULT NULL,
    nazionalita VARCHAR2 DEFAULT 'Sconosciuta'
);
end WebPages;