create OR REPLACE trigger triggerDeleteStanza 
after update on STANZE
for each row
begin
if(:new.eliminato = 1) then
    UPDATE sale s
    SET s.eliminato = 1
    WHERE s.idStanza = :new.idStanza;

    UPDATE AMBIENTIDISERVIZIO ads
    SET ads.eliminato = 1
    WHERE ads.idStanza = :new.idStanza;
end if;
end triggerDeleteStanza;