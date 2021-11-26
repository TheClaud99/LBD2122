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

-- GRUPPO 2
@operazioni_gruppo2/sql/gruppo2PKS.pkb
@operazioni_gruppo2/sql/gruppo2PKB.pkb

-- GRUPPO 1
@operazioniGruppo1/sql/gruppo1.pks
@operazioniGruppo1/sql/gruppo1.pkb
@operazioniGruppo1/sql/TitoliIngresso.plsql
@operazioniGruppo1/sql/TitoliIngressoBody.plsql

-- GRUPPO 4
@operazioniGruppo4/sql/operazioni.pks
@operazioniGruppo4/sql/operazioni.pkb
@operazioniGruppo4/sql/pagamentiCampiEstivi.pks
@operazioniGruppo4/sql/pagamentiCampiEstivi.pkb
@operazioniGruppo4/sql/tariffeCampiEstivi.pks
@operazioniGruppo4/sql/tariffeCampiEstivi.pkb
