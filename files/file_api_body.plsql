create or replace PACKAGE BODY files_orcl2122_api AS

-- Ogni procedura differisce dall'altra per il parametro passato
-- a OWA_UTIL.mime_header, per altri tipi consultare il sito
-- https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types

PROCEDURE GetHtml (p_name  IN  files_orcl2122.name%TYPE) IS
  l_blob  BLOB;
BEGIN
  SELECT datafile
  INTO   l_blob
  FROM   files_orcl2122
  WHERE  name = p_name;
  OWA_UTIL.mime_header('text/html', FALSE);
  HTP.print('Content-Length: ' || DBMS_LOB.getlength(l_blob));
  HTP.print('Content-Disposition: filename="' || p_name || '"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
END GetHtml;

PROCEDURE GetCss (p_name  IN  files_orcl2122.name%TYPE) IS
  l_blob  BLOB;
BEGIN
  SELECT datafile
  INTO   l_blob
  FROM   files_orcl2122
  WHERE  name = p_name;
  OWA_UTIL.mime_header('text/css', FALSE);
  HTP.print('Content-Length: ' || DBMS_LOB.getlength(l_blob));
  HTP.print('Content-Disposition: filename="' || p_name || '"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
END GetCss;

PROCEDURE GetJs (p_name  IN  files_orcl2122.name%TYPE) IS
  l_blob  BLOB;
BEGIN
  SELECT datafile
  INTO   l_blob
  FROM   files_orcl2122
  WHERE  name = p_name;
  OWA_UTIL.mime_header('application/javascript', FALSE);
  HTP.print('Content-Length: ' || DBMS_LOB.getlength(l_blob));
  HTP.print('Content-Disposition: filename="' || p_name || '"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
END GetJs;

PROCEDURE GetImage (p_name  IN  files_orcl2122.name%TYPE) IS
  l_blob  BLOB;
BEGIN
  SELECT datafile
  INTO   l_blob
  FROM   files_orcl2122
  WHERE  name = p_name;
  OWA_UTIL.mime_header('image', FALSE);
  HTP.print('Content-Length: ' || DBMS_LOB.getlength(l_blob));
  HTP.print('Content-Disposition: filename="' || p_name || '"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
END GetImage;

PROCEDURE GetText (p_name  IN  files_orcl2122.name%TYPE) IS
  l_blob  BLOB;
BEGIN
  SELECT datafile
  INTO   l_blob
  FROM   files_orcl2122
  WHERE  name = p_name;
  OWA_UTIL.mime_header('text/plain', FALSE);
  HTP.print('Content-Length: ' || DBMS_LOB.getlength(l_blob));
  HTP.print('Content-Disposition: filename="' || p_name || '"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
END GetText;

PROCEDURE GetBinary (p_name  IN  files_orcl2122.name%TYPE) IS
  l_blob  BLOB;
BEGIN
  SELECT datafile
  INTO   l_blob
  FROM   files_orcl2122
  WHERE  name = p_name;
  OWA_UTIL.mime_header('application/octet-stream', FALSE);
  HTP.print('Content-Length: ' || DBMS_LOB.getlength(l_blob));
  HTP.print('Content-Disposition: filename="' || p_name || '"');
  OWA_UTIL.http_header_close;
  WPG_DOCLOAD.download_file(l_blob);
END GetBinary;

END files_orcl2122_api;

