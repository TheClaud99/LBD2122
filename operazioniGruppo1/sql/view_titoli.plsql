CREATE OR REPLACE VIEW view_titoli AS
    select titoliingresso.idtitoloing as idtitolo, 
                    tipologieingresso.nome as nometipologia,
					tipologieingresso.IDTIPOLOGIAING as idtipologia,
					utenti.nome as nomeutente,
                    utenti.cognome as cognomeutente,
                    scadenza as datascadenza, 
                    emissione as dataemissione,
					titoliingresso.acquirente as idutente,
					musei.idmuseo as museo,
					musei.nome as nomemuseo
				from titoliingresso 
				join TIPOLOGIEINGRESSO on TITOLIINGRESSO.TIPOLOGIA=TIPOLOGIEINGRESSO.IDTIPOLOGIAING
				join utenti on titoliingresso.ACQUIRENTE=utenti.IDUTENTE
				join musei on titoliingresso.MUSEO= musei.IDMUSEO