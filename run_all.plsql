-- CREAZIONE TABELLE
@gestioneDB/delete_data.plsql
@gestioneDB/create_table.plsql
--@modGUI/Login/login_sessioni.plsql
@modGui/Login/trigger_utenti.plsql
@modGui/Login/hasRole.plsql

-- INSERIMENTO DATI
@gestioneDB/populate_table.plsql

----------------
-- OPERAZIONI --
----------------

-- MODGUI
@modGui/COSTANTI.plsql
@modGui/MODGUI1PKS.plsql
@modGui/MODGUI1PKB.plsql

-- GRUPPO 3
@operazioneGruppo3/visite.plsql
@operazioneGruppo3/visiteBody.plsql
@operazioneGruppo3/view_visite.plsql



-- GRUPPO 1
@operazioniGruppo1/sql/gruppo1.pks
@operazioniGruppo1/sql/gruppo1.pkb
@operazioniGruppo1/sql/Newsletters.plsql
@operazioniGruppo1/sql/NewslettersB.plsql
@operazioniGruppo1/sql/TitoliIngresso.plsql
@operazioniGruppo1/sql/TitoliIngressoBody.plsql
@operazioniGruppo1/sql/view_titoli.plsql

grant execute on modgui1 to anonymous;
grant execute on modgui1 to public;
grant execute on webpages to anonymous;
grant execute on webpages to public;
grant execute on packageacquistatitoli to anonymous;
grant execute on packageacquistatitoli to public;
grant execute on newsletters to anonymous;
grant execute on newsletters to public;
grant execute on gruppo1 to anonymous;
grant execute on gruppo1 to public;
grant execute on gruppo2 to anonymous;
grant execute on gruppo2 to public;
grant execute on packagevisite to anonymous;
grant execute on packagevisite to public;
grant execute on operazionigruppo3 to anonymous;
grant execute on operazionigruppo3 to public;
grant execute on operazionigruppo4 to anonymous;
grant execute on operazionigruppo4 to public;
grant execute on tariffeCampiEstiviOperazioni to anonymous;
grant execute on tariffeCampiEstiviOperazioni to public;
/*
grant execute on PagamentiCampiEstivi to anonymous;
grant execute on PagamentiCampiEstivi to public;
*/

