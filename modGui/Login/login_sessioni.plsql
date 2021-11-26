DROP TABLE UTENTILOGIN;
DROP TABLE RUOLISESSIONI;
DROP SEQUENCE IdUtenteLoginSeq;

/* Tabella che contiene username, password e ruolo di ogni utente */
Create Table UTENTILOGIN
(
   IdUtenteLogin number(5) primary key,
   IdCliente NUMBER(5) DEFAULT NULL REFERENCES Utenti(IdUtente),
   Username VARCHAR2(50) not null,
   Password VARCHAR2(50) not null,
   Ruolo VARCHAR2(10) DEFAULT 'U' not null,
   CHECK(Ruolo IN ('DBA', 'SU', 'AB', 'GM', 'GCE', 'GO', 'U'))
);
/* Definizione ruoli  */
/*
DBA = Amministratore della base di dati
SU = SuperUser
AB = Addetto biglietteria
GM = Gestore museo (non ha riferimento al particolare museo)
GCE = Gestore campi estivi (non ha riferimento al particolare campo)
GO = Gestore opere (non ha riferimento al particolare museo)
U = UTENTE (cliente)
*/

/* Tabella delle sessioni: contiene lo storico degli utenti loggati */
CREATE TABLE Sessioni(
   LoginID NUMBER(5) REFERENCES UtentiLogin(IdUtenteLogin),
   DataInizio DATE NOT NULL,
   DataFine DATE DEFAULT NULL, -- DataFine viene settata != null quando utente fa logout
   CONSTRAINT PK_sessioni PRIMARY KEY (LoginID,DataInizio),
   CHECK (DataInizio < DataFine OR DataFine IS NULL)
);

CREATE SEQUENCE IdUtenteLoginSeq
start with 1
increment by 1
maxvalue 99999
cycle;

ALTER SEQUENCE IdUtenteLoginSeq RESTART START WITH 1;

commit;


/* Inserimento di utenti con non sono clienti (non hanno FK in IdCliente) */
INSERT INTO UTENTILOGIN (IdUtenteLogin, IdCliente, Username, Password, Ruolo)
VALUES (IdUtenteLoginSeq.nextval, NULL, 'MarioROSSI', 'dba', 'DBA');
INSERT INTO UTENTILOGIN (IdUtenteLogin, IdCliente, Username, Password, Ruolo)
VALUES (IdUtenteLoginSeq.nextval, NULL, 'LuigiBIANCHI', 'ab', 'AB');
INSERT INTO UTENTILOGIN (IdUtenteLogin, IdCliente, Username, Password, Ruolo)
VALUES (IdUtenteLoginSeq.nextval, NULL, 'StefanoVERDI', 'gm', 'GM');
INSERT INTO UTENTILOGIN (IdUtenteLogin, IdCliente, Username, Password, Ruolo)
VALUES (IdUtenteLoginSeq.nextval, NULL, 'PaoloNERI', 'go', 'GO');
INSERT INTO UTENTILOGIN (IdUtenteLogin, IdCliente, Username, Password, Ruolo)
VALUES (IdUtenteLoginSeq.nextval, NULL, 'MarcoGIALLI', 'gce', 'GCE');

commit;