CREATE OR REPLACE PACKAGE BODY WebPages as

procedure Home (idSessione varchar2 default 0) is
    begin
    modGUI1.ApriPagina('HOME',idSessione);
    modGUI1.Header(idSessione);
    if (idSessione=1)
    then
        modGUI1.ApriDiv('style:"height:90%;"');
            modGUI1.ApriDiv;
                htp.prn('
                    <a href="'||Costanti.server || Costanti.radice||'MuseiHome?idSessione='|| idSessione ||'">
                    <img src="https://www.artribune.com/wp-content/uploads/2020/06/Museo-del-Prado-sala-24.jpg" style="width:50%; height:100%;" class="w3-opacity w3-hover-opacity-off w3-left">
                    </a>
                    <a href="'||Costanti.server || Costanti.radice||'CampiestiviHome?idSessione='|| idSessione ||'">
                    <img src="https://www.baritoday.it/~media/horizontal-hi/70029796349612/sc18nature-walk-2.jpg" style="width:50%; height:100%;" class="w3-opacity w3-hover-opacity-off w3-right">
                    </a>
                ');
            modGUI1.ChiudiDiv;
        modGUI1.chiudiDiv;
    else
        modGUI1.ApriDiv('style:"height:90%;"');
            modGUI1.ApriDiv;
                htp.prn('

                    <img src="https://www.artribune.com/wp-content/uploads/2020/06/Museo-del-Prado-sala-24.jpg" onclick="document.getElementById(''id01'').style.display=''block''" style="width:50%; height:100%;" class="w3-opacity w3-hover-opacity-off w3-left">

                    <img src="https://www.baritoday.it/~media/horizontal-hi/70029796349612/sc18nature-walk-2.jpg" onclick="document.getElementById(''id01'').style.display=''block''" style="width:50%; height:100%;" class="w3-opacity w3-hover-opacity-off w3-right">

                ');
            modGUI1.ChiudiDiv;
        modGUI1.chiudiDiv;
    end if;
    end Home;

    procedure MuseiHome (idSessione int default 0) is
    begin
        modGUI1.ApriPagina('Musei',idSessione);
        modGUI1.Header(idSessione);
        htp.br;
        htp.br;
        htp.br;
        htp.br;
        modGUI1.ApriDiv('class="w3-center"');
            htp.prn('<h1>Musei</h1>');
        modGUI1.ChiudiDiv;
        htp.br;
        modGUI1.ApriDiv('class="w3-row w3-container"');
        if (idSessione=1)
        then

                modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                    modGUI1.ApriDiv('class="w3-card-4" style="height:420px;"');
                    htp.br;
                    modGUI1.InputImage('ImmMuseo','ImmMuseo');
                            modGUI1.ApriDiv('class="w3-container w3-margin w3-center"');
                                modGUI1.ApriForm('InserisciMuseo','InserisciMuseo');
                                    modGUI1.Label('Nome:');
                                    modGUI1.InputText('nomeMuseo','Inserisci il nome del museo...', 1);
                                    modGUI1.Label('Descrizione:');
                                    htp.br;
                                    modGUI1.InputTextArea('desMuseo','Inserisci la descrizione del museo...', 1);
                                    htp.br;
                                    modGUI1.InputSubmit('Aggiungi');
                                modGUI1.ChiudiForm;
                            modGUI1.ChiudiDiv;

                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;


        end if;

            FOR k IN 1..10 LOOP
                modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                    modGUI1.ApriDiv('class="w3-card-4"');
                    htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%;">');
                            modGUI1.ApriDiv('class="w3-container w3-center"');
                                htp.prn('<p>Museo '|| k ||'</p>');
                            modGUI1.ChiudiDiv;
                            if(idSessione=1) then
                               modGUI1.Bottone('w3-black','Visualizza');
                               modGUI1.Bottone('w3-green','Modifica');
                               modGUI1.Bottone('w3-red','Rimuovi');
                            else
                            modGUI1.Bottone('w3-black','Visualizza');
                            end if;
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
            END LOOP;
        modGUI1.chiudiDiv;
    end MuseiHome;

    procedure CampiEstiviHome (idSessione int default 0) is
    begin
        modGUI1.ApriPagina('Campi Estivi',idSessione);
        modGUI1.Header(idSessione);
        htp.br;
        htp.br;
        htp.br;
        htp.br;
        modGUI1.ApriDiv('class="w3-center"');
            htp.prn('<h1>Campi estivi</h1>');
        modGUI1.ChiudiDiv;
        htp.br;
        modGUI1.ApriDiv('class="w3-container" style="width:100%"');
        if(idSessione=1)
        then
        modGUI1.ApriForm('AggiuntaCampo','campoEstivo',NULL);
            modGUI1.ApriDiv('class="w3-row w3-container w3-border w3-round-small w3-padding-large w3-hover-light-grey" style="width:100%"');
                    modGUI1.ApriDiv('class="w3-container w3-cell" style="width:500px; height:300px;"');
                        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
                        modGUI1.InputImage('imgEstivo','imgEstivo');
                    modGUI1.ChiudiDiv;
                    modGUI1.ApriDiv('class="w3-container w3-cell w3-cell-middle" style="width:1120px; height:300px"');
                        modGUI1.Label('Titolo:');
                        modGUI1.InputText('titoloEstivo','Inserisci il titolo del campo estivo...',1);
                        modGUI1.Label('Descrizione:');
                        modGUI1.InputTextArea('desEstivo','Inserisci la descrizione del campo estivo...',1);
                        htp.prn('<b>Partenza:</b>');
                        modGUI1.InputDate('dataEstivoInizio','DataInizio');
                        htp.prn('<b>Ritorno:</b>');
                        modGUI1.InputDate('dataEstivoFine','DataFine');
                    modGUI1.ChiudiDiv;
                    modGUI1.ApriDiv('class="w3-container w3-cell w3-cell-middle"');
                        modGUI1.InputSubmit('Aggiungi');
                    modGUI1.ChiudiDiv;
            modGUI1.chiudiDiv;
        modGUI1.ChiudiForm;
            htp.br;
            htp.br;
        end if;
            FOR k IN 1..10
            LOOP
            modGUI1.ApriDiv('class="w3-row w3-container w3-border w3-round-small w3-padding-large w3-hover-light-grey" style="width:100%"');
                    modGUI1.ApriDiv('class="w3-container w3-cell"');
                        htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:500px; height:300px;">');
                    modGUI1.ChiudiDiv;
                    modGUI1.ApriDiv('class="w3-container w3-cell w3-border-right w3-cell-middle" style="width:1120px; height:300px"');
                        htp.prn('<h5>Campo estivo A</h5>');
                        htp.prn('<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus eget erat at velit bibendum lobortis. Integer commodo sed libero blandit scelerisque. Cras tristique justo in nibh pharetra, hendrerit eleifend orci volutpat. Sed sed dapibus mauris, ut cursus nibh. Maecenas cursus dolor eu arcu tincidunt condimentum. Etiam cursus tellus purus, vel feugiat mi maximus sit amet. Pellentesque id faucibus nulla. Nam quis feugiat est, non interdum dui. Fusce venenatis vitae diam vitae tincidunt. Vestibulum dictum, quam vitae molestie vehicula, leo urna blandit mauris, ut efficitur mi purus venenatis turpis. </p>');
                        htp.prn('<p>Orario: 9:00 - 18:00</p>');
                    modGUI1.ChiudiDiv;
                    modGUI1.ApriDiv('class="w3-container w3-cell w3-cell-middle"');
                        if(idSessione=1) then
                                        modGUI1.Bottone('w3-black','Visualizza');
                                        htp.br;
                                        modGUI1.Bottone('w3-green','Modifica');
                                        htp.br;
                                        modGUI1.Bottone('w3-red','Elimina');
                            else
                                modGUI1.Bottone('w3-black','Visualizza');
                            end if;
                    modGUI1.ChiudiDiv;
            modGUI1.chiudiDiv;
            htp.br;
            htp.br;
            END LOOP;
        modGUI1.chiudiDiv;
    end CampiEstiviHome;

    procedure Test (idSessione int default 0) is
    begin
        modGUI1.ApriPagina('Test',idSessione);
        modGUI1.Header(idSessione);
        htp.br;
        htp.br;
        htp.br;
        htp.br;
        
    end Test;

end WebPages;