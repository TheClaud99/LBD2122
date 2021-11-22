DROP TABLE UTENTILOGIN;
DROP TABLE RUOLISESSIONI;
DROP SEQUENCE IdUtenteLoginSeq;

/* Tabella di corrispondenze tra ruolo e idsessione */
CREATE TABLE RUOLISESSIONI (
   Ruolo VARCHAR2(5) PRIMARY KEY,
   IdSessione NUMBER(5) DEFAULT 0
);

/* Tabella che contiene username, password e ruolo di ogni utente */
Create Table UTENTILOGIN
(
   IdUtenteLogin number(5) primary key,
   IdCliente NUMBER(5) DEFAULT NULL REFERENCES Utenti(IdUtente),
   Username VARCHAR2(50) not null,
   Password VARCHAR2(25) not null,
   Ruolo VARCHAR2(5) not null REFERENCES RuoliSessioni(Ruolo)
);

CREATE SEQUENCE IdUtenteLoginSeq
start with 1
increment by 1
maxvalue 99999
cycle;

ALTER SEQUENCE IdUtenteLoginSeq RESTART START WITH 1;

commit;

/* Definizione ruoli e relativo IdSessione */
/*
DBA = AMMINISTRATORE
AB = ADDETTO BIGLIETTERIA
GM = GESTORE MUSEO
GCE = GESTORE CAMPO ESTIVO
GO = GESTORE OPERE
U = UTENTE (cliente)
*/
INSERT INTO RuoliSessioni (Ruolo, IdSessione) VALUES ('U', 0);
INSERT INTO RuoliSessioni (Ruolo, IdSessione) VALUES ('DBA', 1);
INSERT INTO RuoliSessioni (Ruolo, IdSessione) VALUES ('AB', 2);
INSERT INTO RuoliSessioni (Ruolo, IdSessione) VALUES ('GM', 3);
INSERT INTO RuoliSessioni (Ruolo, IdSessione) VALUES ('GO', 4);
INSERT INTO RuoliSessioni (Ruolo, IdSessione) VALUES ('GCE', 5);

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