/* trigger per inserimento automatico Utenti inseriti nella base di dati nella tabella di login */
/* Ricevono il ruolo 'U' e la password 'utente'
   L'username per loggarsi è dato dalla concatenazione dell'attributo Nome dell'Utente ed il cognome
   (trasformato in maiuscolo).
*/
CREATE OR REPLACE TRIGGER AddClienteLogin
AFTER INSERT ON Utenti FOR EACH ROW 
BEGIN
   INSERT INTO UtentiLogin (IdUtenteLogin, IdCliente, Username, Password, Ruolo)
   VALUES (
    IdUtenteLoginSeq.nextval,
    :new.IdUtente,
    :new.Nome||UPPER(:new.Cognome), 
    'utente', 
    'U');
END;