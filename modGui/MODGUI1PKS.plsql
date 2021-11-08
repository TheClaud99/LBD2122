CREATE OR REPLACE PACKAGE modGUI1 as

procedure ApriPagina(titolo varchar2 default 'Senza titolo', idSessione int default 0);
procedure Header (idSessione int default 0);
procedure BannerUtente (idSessione int default 0);
procedure Login;
procedure Bottone (colore varchar2,text varchar2 default 'myButton');
procedure ApriDiv (attributi varchar2 default '');
procedure ChiudiDiv;
procedure Collegamento(testo varchar2, indirizzo varchar2, classe varchar2 default '');
procedure ApriForm(azione varchar2, nome varchar2 default 'myForm', classe varchar2 default '');
procedure ChiudiForm;
procedure InputText (nome varchar2, placeholder varchar2 default '', required int default 0);
procedure Label (testo varchar2);
procedure InputImage (id varchar2, nome varchar2 );
procedure InputTextArea (nome varchar2, placeholder varchar2 default '', required int default 0);
procedure InputSubmit (testo varchar2 default 'Submit');
procedure InputDate (id varchar2, nome varchar2);
procedure InputTime (id varchar2, nome varchar2);
procedure InputNumber (id varchar2, nome varchar2);

end modGUI1;