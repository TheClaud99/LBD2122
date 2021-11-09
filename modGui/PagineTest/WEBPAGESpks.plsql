CREATE OR REPLACE PACKAGE WebPages as

procedure Home (idSessione varchar2 default 0);
procedure MuseiHome (idSessione int default 0);
procedure CampiEstiviHome (idSessione int default 0);
procedure Test (idSessione int default 0);

end WebPages;