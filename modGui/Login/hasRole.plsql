CREATE OR REPLACE function hasRole(
	sessionID NUMBER DEFAULT 0, 
	role VARCHAR2 DEFAULT 'U') 
RETURN BOOLEAN IS
ruoloUtente VARCHAR2(20);
BEGIN
    select Ruolo into ruoloUtente from UtentiLogin where sessionID = IdUtenteLogin;
    if UPPER(ruoloUtente) = UPPER(role) THEN
        return TRUE;
    ELSE
        return FALSE;
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
            return FALSE;
END hasRole;