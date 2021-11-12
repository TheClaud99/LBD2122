CREATE OR REPLACE PACKAGE BODY WebPages as

--SCHERMATA PRINCIPALE
procedure BodyHome (idSessione varchar2 default 0) is
    begin
    htp.htmlOpen;
    htp.headOpen;
    htp.prn('<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> ');
    htp.headClose;
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
    end BodyHome;



--MENU GENERICO VISUALIZZAZIONE MUSEI E TASTO AGGIUNTA
procedure MuseiHome (idSessione int default 0) is
    begin
        htp.prn('<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> ');
        modGUI1.Header(idSessione);
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
        modGUI1.ApriDiv('class="w3-center"');
            htp.prn('<h1>Musei</h1>'); --TITOLO

        if (idSessione=1)
        then
            modGUI1.Collegamento('Aggiungi','inserimento','w3-btn w3-round-xxlarge w3-black'); /*bottone che rimanda alla procedura inserimento solo se la sessione è 1*/
        end if;
 
        modGUI1.ChiudiDiv;
        htp.br;
        modGUI1.ApriDiv('class="w3-row w3-container"');
        --INIZIO LOOP DELLA VISUALIZZAZIONE
            FOR k IN 1..10 LOOP
                modGUI1.ApriDiv('class="w3-col l4 w3-padding-large w3-center"');
                    modGUI1.ApriDiv('class="w3-card-4"');
                    htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:100%">');
                            modGUI1.ApriDiv('class="w3-container w3-center"');
                            --INIZIO DESCRIZIONI
                                htp.prn('<p>Museo '|| k ||'</p>');
                                htp.prn('<p>testo di prova</p>');
                            --FINE DESCRIZIONI
                            modGUI1.ChiudiDiv;
                            
                            if(idSessione=1) then --Bottoni visualizzati in base alla sessione 
                               modGUI1.Bottone('w3-black','Visualizza');
                               modGUI1.Bottone('w3-green','Modifica');
                               modGUI1.Bottone('w3-red','Rimuovi');
                            else
                            modGUI1.Bottone('w3-black','Visualizza');
                            end if;

                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
            END LOOP;
        --FINE LOOP
        modGUI1.chiudiDiv;
    end MuseiHome;

--MENU VISUALIZZAZIONE CAMPI ESTIVI E TASTO AGGIUNTA
procedure CampiEstiviHome (idSessione int default 0) is
    begin
        htp.prn('<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> ');
        modGUI1.Header(idSessione);
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
        modGUI1.ApriDiv('class="w3-center"');
            htp.prn('<h1>Campi estivi</h1>'); --TITOLO

        if (idSessione=1)
        then
            modGUI1.Collegamento('Aggiungi','inserimento','w3-btn w3-round-xxlarge w3-black'); /*bottone che rimanda alla procedura inserimento*/
        end if;
        modGUI1.ChiudiDiv;
        htp.br;
        modGUI1.ApriDiv('class="w3-container" style="width:100%"');
        --INIZIO LOOP DELLA VISUALIZZAZIONE
            FOR k IN 1..10
            LOOP
            modGUI1.ApriDiv('class="w3-row w3-container w3-border w3-round-small w3-padding-large w3-hover-light-grey" style="width:100%"');
                    modGUI1.ApriDiv('class="w3-container w3-cell"');
                        htp.prn('<img src="https://cdn.pixabay.com/photo/2016/10/22/15/32/water-1761027__480.jpg" alt="Alps" style="width:500px; height:300px;">');
                    modGUI1.ChiudiDiv;
                    modGUI1.ApriDiv('class="w3-container w3-cell w3-border-right w3-cell-middle" style="width:1120px; height:300px"');
                    --DESCRIZIONI DA MODIFICARE
                        htp.prn('<h5>Campo estivo A</h5>');
                        htp.prn('<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus eget erat at velit bibendum lobortis. Integer commodo sed libero blandit scelerisque. Cras tristique justo in nibh pharetra, hendrerit eleifend orci volutpat. Sed sed dapibus mauris, ut cursus nibh. Maecenas cursus dolor eu arcu tincidunt condimentum. Etiam cursus tellus purus, vel feugiat mi maximus sit amet. Pellentesque id faucibus nulla. Nam quis feugiat est, non interdum dui. Fusce venenatis vitae diam vitae tincidunt. Vestibulum dictum, quam vitae molestie vehicula, leo urna blandit mauris, ut efficitur mi purus venenatis turpis. </p>');
                        htp.prn('<p>Orario: 9:00 - 18:00</p>');
                    --FINE DESCRIZIONI
                    modGUI1.ChiudiDiv;
                    modGUI1.ApriDiv('class="w3-container w3-cell w3-cell-middle"');

                        if(idSessione=1) then --Bottoni visualizzati in base alla sessione 
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
        --FINE LOOP VISUALIZZAZIONE
        modGUI1.chiudiDiv;
    end CampiEstiviHome;


--PROCEDURA PER INSERIMENTO
PROCEDURE Inserimento(
    idSessione NUMBER DEFAULT 0
) IS
BEGIN 
        modGUI1.ApriPagina('PROVA',idSessione);--DA MODIFICARE campo PROVA
        modGUI1.Header(idSessione);
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
        htp.prn('<h1 align="center">PROVA</h1>');--DA MODIFICARE
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
            modGUI1.ApriDiv('class="w3-section"');
            modGUI1.Collegamento('X','COLLEGAMENTOPROVA',' w3-btn w3-large w3-red w3-display-topright'); --Bottone per tornare indietro, cambiare COLLEGAMENTOPROVA
            --INIZIO SEZIONE DA MODIFICARE
                modGUI1.ApriForm('prova',NULL,'w3-container');
                    modGUI1.Label('Nome*');
                    modGUI1.Inputtext('nome', 'Nome studente',0);
                    htp.br;
                    modGUI1.Label('cognome*');
                    modGUI1.Inputtext('cognome', 'Cognome studente',0);
                    htp.br;
                    modGUI1.Label('Durata della prova*');
                    modGUI1.InputNumber('durataProva', 'Durata della prova',0); 
                    htp.br;
                    modGUI1.Label('Inserisci data prova*:');
                    modGUI1.InputDate('dataProva', 'Data della prova',0);
                    htp.br;
                    modGUI1.Label('Nome prova* ');
                    modGUI1.InputText('nomeProva', 'Nome della prova',10);
                    htp.br;
                    modGUI1.InputSubmit('Aggiungi');
                modGUI1.ChiudiForm;
            --FINE SEZIONE DA MODIFICARE
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
END Inserimento;



--PAGINA PER CONFERMARE
PROCEDURE Conferma(
    idSessione NUMBER DEFAULT 0,
    --LISTA VARIABILI PASSATE
    nome VARCHAR2 DEFAULT 'Sconosciuto',
    cognome VARCHAR2 DEFAULT 'Sconosciuto',
    dataNascita VARCHAR2 DEFAULT NULL,
    dataMorte VARCHAR2 DEFAULT NULL,
    nazionalita VARCHAR2 DEFAULT 'Sconosciuta'
) IS 
BEGIN 
    modGUI1.ApriPagina('Conferma',idSessione);
        modGUI1.Header(idSessione);
        htp.br;htp.br;htp.br;htp.br;htp.br;htp.br;
        htp.prn('<h1 align="center">CONFERMA DATI</h1>');--DA MODIFICARE
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px" ');
            modGUI1.ApriDiv('class="w3-section"');

            --INIZIO RIEPILOGO
                htp.br;
                modGUI1.Label('Nome:');
                HTP.PRINT(nome);--parametro passato
                htp.br;
                modGUI1.Label('Cognome:');
                HTP.PRINT(cognome);--parametro passato
                htp.br;
                modGUI1.Label('Data nascita:');
                HTP.PRINT(dataNascita);--parametro passato
                htp.br;
                modGUI1.Label('Data morte:');
                HTP.PRINT(dataMorte);--parametro passato
                htp.br;
                modGUI1.Label('Nazionalità:');
                HTP.PRINT(nazionalita);--parametro passato
                htp.br;
            --FINE RIEPILOGO
            modGUI1.ChiudiDiv;
            --Due form nascosti 
                --1)per inviare i dati alla procedura che inserisce i parametri nella tabella
            modGUI1.ApriForm('InsertDati');
            HTP.FORMHIDDEN('idSessione', idSessione);
            HTP.FORMHIDDEN('nome', nome);
            HTP.FORMHIDDEN('cognome', cognome);
            HTP.FORMHIDDEN('dataNascita', dataNascita);
            HTP.FORMHIDDEN('dataMorte', dataMorte);
            HTP.FORMHIDDEN('nazionalita', nazionalita);
            modGUI1.InputSubmit('Conferma');--bottone conferma
            modGUI1.ChiudiForm;
                --1)per inviare i dati alla procedura Menu
            modGUI1.ApriForm('Menu');
            HTP.FORMHIDDEN('idSessione', idSessione);
            HTP.FORMHIDDEN('nome', nome);
            HTP.FORMHIDDEN('cognome', cognome);
            HTP.FORMHIDDEN('dataNascita', dataNascita);
            HTP.FORMHIDDEN('dataMorte', dataMorte);
            HTP.FORMHIDDEN('nazionalita', nazionalita);
            modGUI1.InputSubmit('Annulla');--bottone annulla
    modGUI1.ChiudiDiv;  
END Conferma;


end WebPages;