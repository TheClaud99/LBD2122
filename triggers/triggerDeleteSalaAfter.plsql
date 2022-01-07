create OR REPLACE trigger triggerDeleteSalaAfter
after update on SALE
for each row
begin
    if(:new.eliminato = 1) then
	update varchi
	set varchi.eliminato = 1
	where Stanza1=:new.idstanza OR Stanza2 = :new.idstanza;
    end if;
end triggerDeleteSalaAfter;