CREATE OR REPLACE VIEW view_visite AS
    SELECT
        visite.*,
        titoliingresso.*,
        musei.nome     AS nome_museo,
        musei.idmuseo,
        utenti.idutente,
        utenti.nome    AS nome_utente
    FROM
        visite
        JOIN utenti ON visite.visitatore = utenti.idutente
        JOIN titoliingresso ON visite.titoloingresso = titoliingresso.idtitoloing
        JOIN musei ON titoliingresso.museo = musei.idmuseo
        JOIN tipologieingresso ON titoliingresso.tipologia = tipologieingresso.idtipologiaing;
        -- JOIN biglietti ON biglietti.idtipologiaing = tipologieingresso.idtipologiaing
        -- JOIN abbonamenti ON abbonamenti.idtipologiaing = tipologieingresso.idtipologiaing;
