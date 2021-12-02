CREATE OR REPLACE PACKAGE modGUI1 as

procedure erroreLogin;

procedure ApriPagina(titolo varchar2 default 'Senza titolo', idSessione int default 0);
procedure Header (idSessione int default 0);
procedure BannerUtente (idSessione int default 0);
/* Login & logout */
procedure Login;
--PROCEDURE Logout(idSessione NUMBER DEFAULT 0);
procedure set_cookie (idSessione IN UTENTILOGIN.idUtenteLogin%TYPE, url VARCHAR2 DEFAULT '');
function get_id_sessione return NUMBER;
procedure CreazioneSessione (usernames VARCHAR2 DEFAULT 'Sconosciuto', passwords VARCHAR2 DEFAULT 'Sconosciuto', url VARCHAR2 DEFAULT 'Sconosciuto');
procedure RimozioneSessione(idsessione NUMBER DEFAULT 0);

procedure Bottone (colore varchar2,text varchar2 default 'myButton', id varchar2 default '', fun VARCHAR2 DEFAULT '');
procedure ApriDiv (attributi varchar2 default '');
procedure ChiudiDiv;
procedure Collegamento(testo varchar2, indirizzo varchar2, classe varchar2 default '', fun VARCHAR2 default '');
procedure ApriForm(azione varchar2, nome varchar2 default 'myForm', classe varchar2 default '', root varchar2 default 0);
procedure ChiudiForm;
procedure InputText (nome varchar2, placeholder varchar2 default '', required int default 0, valore varchar2 default '', lunghezza int default 1000);
procedure Label (testo varchar2);
procedure InputImage (id varchar2, nome varchar2 );
procedure InputTextArea (nome varchar2, placeholder varchar2 default '', required int default 0,valore varchar2 default '');
procedure InputSubmit (testo varchar2 default 'Submit');
procedure InputDate (id varchar2, nome varchar2, required int default 0, defaultValue varchar2 default '');
procedure InputTime (id varchar2, nome varchar2, required int default 0, defaultValue varchar2 default '');
procedure InputNumber (id varchar2, nome varchar2, required int default 0, defaultValue int default 0);
procedure SelectOpen(nome varchar2 default 'mySelect', id varchar2 default 'mySelect');
procedure SelectOption(valore varchar2, testo varchar2 default 'Opzione', selected int default 0);
procedure EmptySelectOption(selected int default 0);
procedure SelectClose;
procedure InputRadioButton (testo varchar2, nome varchar2, valore varchar2, checked int default 0, disabled int default 0,required int default 0);
procedure InputCheckbox (testo varchar2, nome varchar2, checked int default 0, disabled int default 0);
procedure InputCheckboxOnClick (testo varchar2, nome varchar2, fun varchar2, id varchar2, checked int default 0, disabled int default 0);
procedure ApriDivCard;
procedure InputReset;
procedure Redirect (destinazione varchar2);
procedure apriTabella(classe varchar2 default 'defTable');
procedure chiudiTabella;
procedure apriRigaTabella(classe varchar2 default 'defRowTable');
procedure chiudiRigaTabella;
procedure apriElementoTabella(classe varchar2 default 'defElementoTabella', id varchar2 default '');
procedure chiudiElementoTabella;
procedure ElementoTabella(testo varchar2);
procedure intestazioneTabella(testo varchar2, classe varchar2 default 'defHeaderTable');
procedure RedirectEsito (
    pageTitle VARCHAR2 DEFAULT NULL,
    msg VARCHAR2 DEFAULT NULL,
    nuovaOp VARCHAR2 DEFAULT NULL,
    nuovaOpURL VARCHAR2 DEFAULT NULL,
    parametrinuovaOp VARCHAR2 DEFAULT '',
    backToMenu VARCHAR2 DEFAULT NULL,
    backToMenuURL VARCHAR2 DEFAULT NULL,
    parametribackToMenu VARCHAR2 DEFAULT ''
    );
 
procedure EsitoOperazione(
    pageTitle VARCHAR2 DEFAULT NULL,
    msg VARCHAR2 DEFAULT NULL,
    nuovaOp VARCHAR2 DEFAULT NULL,
    nuovaOpURL VARCHAR2 DEFAULT NULL,
    parametrinuovaOp VARCHAR2 DEFAULT '',
    backToMenu VARCHAR2 DEFAULT NULL,
    backToMenuURL VARCHAR2 DEFAULT NULL,
    parametribackToMenu VARCHAR2 DEFAULT ''
    );

end modGUI1;
