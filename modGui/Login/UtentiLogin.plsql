DROP TABLE UTENTILOGIN;
DROP SEQUENCE IdUtenteLoginSeq;

Create Table UTENTILOGIN
(
   IdUtenteLogin number(5) primary key,
   Email VARCHAR2(50),
   Username VARCHAR2(25) not null,
   Password VARCHAR2(25) not null,
   Ruolo VARCHAR2(5) not null   
);

/*UTENTILOGIN
create sequence IdUtenteLoginSeq
start with 1
increment by 1
maxvalue 99999
cycle;
*/

/*INSERIMENTO UTENTI*/
INSERT INTO UTENTILOGIN (idUTenteLogin, Email, Username, Password, Ruolo)
VALUES (1, NULL, 'marioROSSI','LBD2122','DBA');
INSERT INTO UTENTILOGIN (idUTenteLogin, Email, Username, Password, Ruolo)
VALUES (2, NULL, 'LuigiBIANCHI','LBD2122','AB');
INSERT INTO UTENTILOGIN (idUTenteLogin, Email, Username, Password, Ruolo)
VALUES (3, NULL, 'giuseppeVERDI','LBD2122','GM');
INSERT INTO UTENTILOGIN (idUTenteLogin, Email, Username, Password, Ruolo)
VALUES (4, NULL, 'carloNERI','LBD2122', 'GCE');
INSERT INTO UTENTILOGIN (idUTenteLogin, Email, Username, Password, Ruolo)
VALUES (5, NULL, 'mariaGIALLI','LBD2122','GO');

/*

DBA= AMMINISTRATORE
AB= ADDETTO BIGLIETTERIA
GM= GESTORE MUSEO
GCE= GESTORE CAMPO ESTIVO
GO= GESTORE OPERE
U= UTENTE

*/