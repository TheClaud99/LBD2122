CREATE OR REPLACE VIEW VISTAETAMEDIA AS 
 SELECT  u.IDUtente, tc.idtariffa, tc.campoestivo, TRUNC(((SYSDATE - u.DATANASCITA)/365),0) as eta
                            FROM Utenti u, Utenticampiestivi uc , utentipagamenti up, Pagamenticampiestivi pce , TariffeCampiestivi tc 
                            WHERE
                            uc.IDUTENTE = up.IDUTENTE AND
                            up.IDPAGAMENTO = pce.IDPAGAMENTO AND
                            pce.TARIFFA = tc.IDTARIFFA AND
                            u.IDUTENTE = uc.IDUTENTE;