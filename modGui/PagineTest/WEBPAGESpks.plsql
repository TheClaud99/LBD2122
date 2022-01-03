CREATE OR REPLACE PACKAGE WebPages as

procedure Home;
procedure MuseiHome;
procedure CampiEstiviHome;
PROCEDURE Inserimento;
PROCEDURE Conferma(
    nome VARCHAR2 DEFAULT 'Sconosciuto',
    cognome VARCHAR2 DEFAULT 'Sconosciuto',
    dataNascita VARCHAR2 DEFAULT NULL,
    dataMorte VARCHAR2 DEFAULT NULL,
    nazionalita VARCHAR2 DEFAULT 'Sconosciuta'
);
end WebPages;
