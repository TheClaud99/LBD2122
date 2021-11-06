-- Il package FILES_ORCL2122_API definisce una API
-- per la generazione dei corretti header necessari per mandare in risposta 
-- un file presente nella directory FILES_ORCL2122_DIR del database
-- Il solo parametro da passare alle procedure � la stringa contenente il nome del file
create or replace PACKAGE files_orcl2122_api AS

-- Pagine HTML
PROCEDURE GetHtml  (p_name  IN  files_orcl2122.name%TYPE);

-- Files CSS
PROCEDURE GetCss  (p_name  IN  files_orcl2122.name%TYPE);

-- Files Javascript
PROCEDURE GetJs  (p_name  IN  files_orcl2122.name%TYPE);

-- Files Immagine
PROCEDURE GetImage  (p_name  IN  files_orcl2122.name%TYPE);

-- Files di testo
PROCEDURE GetText  (p_name  IN  files_orcl2122.name%TYPE);

-- Files binari
PROCEDURE GetBinary  (p_name  IN  files_orcl2122.name%TYPE);

END;

