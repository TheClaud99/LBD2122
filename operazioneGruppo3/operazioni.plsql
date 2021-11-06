CREATE OR REPLACE PACKAGE BODY operazioniGruppo3 as

    procedure formVisita is
    begin
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
            modGUI1.ApriForm('creaVisita',NULL,'w3-container');
                modGUI1.ApriDiv('class="w3-section"');
                    modGUI1.Label('Data:');
                    modGUI1.InputDate('data_visita','Inserisci data visita');
                    htp.br;
                    modGUI1.Label('Password:');
                    modGUI1.InputText('password','Enter Password',1);
                    htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit">Login</button>');
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