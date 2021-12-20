CREATE OR REPLACE VIEW OpereEsposte AS
SELECT M.IdMuseo Museo,M.Nome Nome, SO.Opera Opera
FROM Musei M JOIN Stanze S ON M.IdMuseo = S.Museo
	JOIN SaleOpere SO ON S.IdStanza = SO.Sala
WHERE SO.datauscita IS NULL
ORDER BY M.IdMuseo;