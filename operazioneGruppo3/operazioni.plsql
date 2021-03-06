CREATE OR REPLACE PACKAGE BODY operazioniGruppo3 as

    /*
    * OPERAZIONI SULLE STANZE
    * - Inserimento ❌
    * - Modifica ❌
    * - Visualizzazione ❌
    * - Cancellazione (rimozione) ❌
    * - Monitoraggio e statistiche
    * OPERAZIONI STATISTICHE E MONITORAGGIO
    * - Opere presenti nella sala ❌
    * - Numero visitatori unici in un arco temporale scelto ❌
    * - Numero medio visitatori in un arco temporale scelto ❌
    * - Media permanenza in una sala ❌
    */

    /*
    * OPERAZIONI SUI VARCHI
    * - Inserimento ❌
    * - Modifica ❌
    * - Visualizzazione ❌
    * - Cancellazione (rimozione) ❌
    * OPERAZIONI STATISTICHE E MONITORAGGIO
    * - Numero visite che hanno attraversato il Varco in un arco temporale scelto ❌
    * - Numero medio che hanno attraversato il Varco visite in una fascia oraria scelta ❌
    * - Numero varchi in una stanza ❌
    */

    /*
    * OPERAZIONI SULLE VISITE
    * - Inserimento ✅
    * - Modifica ❌
    * - Visualizzazione ❌
    * - Cancellazione (rimozione) ❌
    * - Monitoraggio e statistiche
    * OPERAZIONI STATISTICHE E MONITORAGGIO
    * - Numero visitatori unici in un arco temporale scelto ❌
    * - Numero medio visitatori in un arco temporale scelto ❌
    * - Numero Visite effettuate con Abbonamenti in un arco temporale scelto ❌
    * - Numero Visite effettuate con Biglietti in un arco temporale scelto ❌
    * - Durata media di una visita in un arco temporale scelto ❌
    */

    procedure formVisita is
        NomeUtente UTENTI.Nome%TYPE;
        CognomeUtente UTENTI.Cognome%TYPE;
        varIdUtente UTENTI.IdUtente%TYPE;
    begin
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
            modGUI1.ApriForm('creaVisita',NULL,'w3-container');
                modGUI1.ApriDiv('class="w3-section"');
                    modGUI1.Label('Inserisci data della visita:');
                    modGUI1.InputDate('DataVisita', 'DataVisita');
                    htp.br;
                    modGUI1.Label('Durata della visita');
                    modGUI1.InputNumber('DurataVisita', 'DurataVisita');
                    htp.br;

                    modGUI1.Label('Utente');
                    htp.prn('<select>');
                        for utente in (select IdUtente from UTENTIMUSEO)
                        loop 
                            select IdUtente, Nome, Cognome into varIdUtente, NomeUtente, CognomeUtente
                            from UTENTI
                            where IdUtente = utente.IdUtente;
                            htp.print('
                                <option value="'|| varIdUtente ||'">
                                    '|| NomeUtente ||' '|| CognomeUtente ||'
                                </option>
                            ');  
                        end loop;
                    htp.prn('</select>');
                    htp.br;

                    modGUI1.Label('Titolo di ingresso');
                    htp.prn('<select>');
                        for titolo in (select IdTitoloing  from TITOLIINGRESSO)
                        loop 
                            -- todo Non andrebbe aggiunto un nome alla tipologia di ingresso? 
                            -- select Nome into NomeTiologiaIngresso
                            -- from TIPOLOGIEINGRESSO
                            -- where IdTipologiaIng = titolo.Tipologia;
                            htp.print('
                                <option value="'|| titolo.IdTitoloing ||'">
                                    '|| titolo.IdTitoloing ||'
                                </option>
                            ');  
                        end loop;
                    htp.prn('</select>');
                    htp.br;

                    htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit">Invia</button>');
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiForm;
        modGUI1.ChiudiDiv;
    end;

    procedure homepage is
    begin
        modGUI1.ApriPagina();
        modGUI1.Header();
        modGUI1.ApriDiv('style="margin-top: 110px"');
            operazioniGruppo3.formVisita();
        modGUI1.ChiudiDiv();
        htp.prn('</body>
        </html>');
    end;

end operazioniGruppo3;