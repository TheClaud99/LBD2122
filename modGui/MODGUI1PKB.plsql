CREATE OR REPLACE PACKAGE BODY modGUI1 as

    procedure ApriPagina(titolo varchar2 default 'Senza titolo', idSessione int default 0) is
    begin
        htp.htmlOpen;
        htp.headOpen;
        htp.prn('<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css"> ');
        htp.print('<script> ' || Costanti.jscript || ' </script>');
        htp.title(titolo);
        htp.headClose;
    end ApriPagina;

    procedure Header (idSessione int default 0) is /*Testata pagina che include tendina ☰ e banner utente */
    begin
        modGUI1.ApriDiv('class="w3-dropdown w3-bar w3-top w3-black w3-large" style="height:90px;"');
            htp.prn('<button onclick="myFunction()" class="w3-button w3-hover-white w3-black w3-xxxlarge"><h1>☰</h1></button>');
            modGUI1.ApriDiv('id="Demo" class="w3-dropdown-content w3-bar-block w3-black w3-sidebar" style="width:20%;position:fixed;z-index:-1;"');
                modGUI1.Collegamento('HOME','Home?idSessione='|| idSessione,'w3-bar-item w3-button');
                if (idSessione!=0)
                then
                    modGUI1.Collegamento('Musei','MuseiHome?idSessione='|| idSessione,'w3-bar-item w3-button');
                    modGUI1.Collegamento('Campi Estivi','CampiEstiviHome?idSessione='|| idSessione,'w3-bar-item w3-button');
                    modGUI1.Collegamento('LOG OUT','Home?idSessione=0','w3-bar-item w3-button w3-red');
                end if;
            modGUI1.ChiudiDiv;
            modGUI1.BannerUtente(idSessione);
        modGUI1.ChiudiDiv;
        htp.prn('
            <script>
                function myFunction() {
                    var x = document.getElementById("Demo");
                    if (x.className.indexOf("w3-show") == -1) {
                        x.className += " w3-show w3-animate-left";
                    }else{
                        x.className = x.className.replace(" w3-show", "");
                    }
                }
            </script>
        ');
    end Header;


    procedure BannerUtente (idSessione int default 0)is /*Banner Log-In o utente */
    nome varchar2(50) default 'Sconosciuto';
    impiego varchar(50) default 'Sconosciuto';
    begin
        if (idSessione = 0) then
            modGUI1.ApriDiv('class="w3-container w3-right w3-large"');
                htp.prn('
                    <button onclick="document.getElementById(''id01'').style.display=''block''" class="w3-margin w3-button w3-black w3-hover-white w3-large">LOG IN</button>
                ');
            modGUI1.chiudiDiv;
            modGUI1.Login;
        else
            modGUI1.ApriDiv('class="w3-right w3-padding"  style="max-height:80px; width:400px; margin-top:5px;"');
                SELECT Username,Ruolo INTO nome,impiego FROM UtentiLogin WHERE idSessione=idUtenteLogin;
                modGUI1.ApriDiv('class="w3-threequarter" style="text-align:right;"');
                    htp.prn(nome);
                    htp.br;
                    htp.prn(impiego);
                modGUI1.ChiudiDiv;
                modGUI1.ApriDiv('class="w3-quarter w3-right w3-dropdown-hover"');
                    htp.prn('<img src="https://www.sologossip.it/wp-content/uploads/2020/12/clementino-sologossip.jpg" style="margin-left:6px; width:60px; height:60px;">');
                    modGUI1.ApriDiv('class="w3-dropdown-content" style="background-color:transparent;position:fixed;z-index:1;"');
                        modGUI1.Collegamento('LOG OUT','Home?idSessione=0','w3-button w3-red w3-small"');
                    modGUI1.ChiudiDiv;
                modGUI1.ChiudiDiv;
            modGUI1.ChiudiDiv;
        end if;
    end BannerUtente;


    procedure Login is /*Form popup per accesso utente */
    begin
        modGUI1.ApriDiv('id="id01" class="w3-modal"');
            modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:500px"');
                modGUI1.ApriDiv('class="w3-center"');
                    htp.br;
                    htp.prn('<span onclick="document.getElementById(''id01'').style.display=''none''" class="w3-button w3-xlarge w3-red w3-display-topright" title="Close Modal">X</span>
                            <img src="https://termoidraulicabassini.it/wp-content/uploads/2015/12/utente.png" alt="Avatar" style="width:30%" class="w3-circle w3-margin-top">');
                modGUI1.ChiudiDiv;
                    modGUI1.ApriForm('CreazioneSessione','formLogIn','w3-container',1);
                        modGUI1.ApriDiv('class="w3-section"');
                            modGUI1.Label('Username:');
                            modGUI1.InputText('usernames','Enter Username',1);
                            htp.br;
                            modGUI1.Label ('Password:');
                            modGUI1.InputText('passwords','Enter Password',1);
                            htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding" type="submit">Login</button>');
                        modGUI1.ChiudiDiv;
                    modGUI1.ChiudiForm;
            modGUI1.ChiudiDiv;
        modGUI1.ChiudiDiv;
    end Login;

    procedure CreazioneSessione (usernames VARCHAR2 DEFAULT 'Sconosciuto', passwords VARCHAR2 DEFAULT 'Sconosciuto')is
    var1 NUMBER DEFAULT 0;
    begin
        SELECT idUtenteLogin INTO var1 FROM UTENTILOGIN
        WHERE username=usernames AND password=passwords;
        modGUI1.Redirect('Home?idSessione='||var1);
        --TODO 
        --ECCEZIONI PER LOGIN FALLIO (reindirizzamento alla home con un flag di errore che mostrerà in home un popup con il login fallito)
    end;


    procedure Bottone (colore varchar2, text varchar2 default 'myButton', id varchar2 default '') is /*Bottone(colore,testo) - specificare colore in inglese preceduto da "w3-" - testo contenuto nel bottone*/
    begin
        htp.prn ('<button id="'|| id ||'" class="w3-button '|| colore ||' w3-margin">'||text||'</button>');
    end Bottone;

    procedure ApriDiv (attributi varchar2 default '') is /*attributi -> parametri stile*/
    begin
        htp.prn('<div '|| attributi ||'>');
    end ApriDiv;

    procedure ChiudiDiv is
    begin
        htp.prn('</div>');
    end ChiudiDiv;

    procedure Collegamento(testo varchar2, indirizzo varchar2, classe varchar2 default '') is /*LINK, testo -> testo cliccabile, Indirizzo -> pagina di destinazione, classe -> parametri di stile*/
    begin
        htp.prn('<a href="' || Costanti.server || Costanti.radice || indirizzo ||'" class="'|| classe ||'">' || testo || '</a>');
    end Collegamento;

    procedure ApriForm(azione varchar2, nome varchar2 default 'myForm', classe varchar2 default '', root varchar2 default 0) is /*azione -> pagina di destinazione, nome -> nome form, classe -> parametri di stile*/
    begin
        if (root=0) then
            htp.print('<form name="'|| nome || '" action="'|| Costanti.radice || azione || '" method="GET" class="' || classe || '">');
        else
            htp.print('<form name="'|| nome || '" action="'|| Costanti.radice2 || azione || '" method="GET" class="' || classe || '">');
        end if;
    end ApriForm;

    procedure ChiudiForm is
    begin
      htp.print('</form>');
    end ChiudiForm;

    procedure InputText (nome varchar2, placeholder varchar2 default '', required int default 0, valore varchar2 default '', lunghezza int default 1000) is /*Casella di input testuale, nome -> nome casella, placeholder -> testo visualizzato quando vuota, required -> vincolo di NOT NULL*/
    begin
        htp.prn('<input class="w3-padding w3-round-xlarge w3-border w3-margin-top w3-margin-bottom" style="max-width:'|| lunghezza ||';height:35px;" type="text" name="'|| nome ||'" placeholder="'|| placeholder ||'" value="' || valore || '"');
        if (required = 0)
        then
            htp.prn('>');
        else
            htp.prn(' required>');
        end if;
    end InputText;

    procedure InputTextArea (nome varchar2, placeholder varchar2 default '', required int default 0) is /*Casella di input testuale più grande, nome -> nome casella, placeholder -> testo visualizzato quando vuota, required -> vincolo di NOT NULL*/
    begin
        htp.prn('<textarea class="w3-input w3-round-xlarge w3-border" style="resize:none; height:40%" name="'|| nome ||'" placeholder="'|| placeholder ||'"');
        if (required = 0)
        then
            htp.prn('></textarea>');
        else
            htp.prn('required></textarea>');
        end if;
    end InputTextArea;

    procedure Label (testo varchar2) is /*Etichetta utilizzabile prima di un input*/
    begin
        htp.prn('<label style="color:black;margin:10px;"><b>'|| testo ||'</b></label>');
    end Label;

    procedure InputImage (id varchar2, nome varchar2 ) is
    begin
        htp.prn('<input type="file" id="'||id||'" name="'||nome||'" accept="image/png, image/jpeg">');
    end InputImage;

    procedure InputSubmit (testo varchar2 default 'Submit') is /*Bottone per invio del form*/
    begin
        htp.prn('<button class="w3-button w3-block w3-black w3-section w3-padding">'|| testo ||'</button>');
    end InputSubmit;

    procedure InputDate (id varchar2, nome varchar2, required int default 0, defaultValue varchar2 default '') is /*Input di tipo calendario*/
    begin
        htp.prn('<input class="w3-border w3-margin-top w3-margin-bottom w3-round-xlarge" style="max-width:300px;" type="date" id="'|| id ||'" name="'|| nome ||'" value="" min="1900-01-01" max="2030-12-31"');
        if (required = 1)
        then
            htp.prn('required');
        end if;
        htp.prn('>');
        htp.print('<script type="text/javascript">
                if("'||defaultValue||'") {
                    const res = new Date("'||defaultValue||'")
                    document.getElementById("'||id||'").setAttribute("value", res.toISOString().split("T")[0])
                }
        </script>');
    end InputDate;

    procedure InputTime (id varchar2, nome varchar2, required int default 0, defaultValue varchar2 default '') is /*Input di tipo orario*/
    begin
        htp.prn('<input type="time" id="'|| id ||'" name="'|| nome ||'" value="'|| defaultValue ||'" min="09:00" max="18:00"');
        if (required = 1)
        then
            htp.prn('required');
        end if;
        htp.prn('>');
    end InputTime;

    procedure InputNumber (id varchar2, nome varchar2, required int default 0, defaultValue int default 0) is /*Input di tipo numerico*/
    begin
        htp.prn('<input class="w3-padding w3-border w3-margin-top w3-margin-bottom w3-round-xlarge" style="max-width:100px;" type="number" id="'|| id ||'" name="'|| nome ||'"  value="'|| defaultValue ||'"');
        if (required = 1)
        then
            htp.prn('required');
        end if;
        htp.prn('>');
    end InputNumber;

    procedure SelectOpen(nome varchar2 default 'mySelect', id varchar2 default 'mySelect') is
    begin
        htp.prn('<select id="'|| id ||'" class="w3-select w3-border w3-margin-top w3-margin-bottom w3-round-xlarge" style="max-width:250px;" name="'|| nome ||'">');
    end SelectOpen;

    procedure SelectOption(valore varchar2, testo varchar2 default 'Opzione', selected int default 0) is
    begin
        htp.prn('<option value="'||valore||'"');
        if (selected=1)
        then
            htp.prn('selected>');
        else
            htp.prn('>');
        end if;
        htp.prn(''|| testo ||'</option>');
    end SelectOption;

    procedure SelectClose is
    begin
        htp.prn('</select>');
    end SelectClose;

    procedure InputRadioButton (testo varchar2, nome varchar2, valore varchar2, checked int default 0, disabled int default 0) is
    begin
        htp.print('<input class="w3-radio" type="radio" name="'|| nome ||'" value="'|| valore ||'"');
        if (checked=1)
        then
            htp.prn(' checked');
        end if;
        if (disabled=1)
        then
            htp.prn(' disabled');
        end if;
        htp.prn('> ');
        htp.prn(testo);
    end InputRadioButton;

    procedure InputCheckbox (testo varchar2, nome varchar2, checked int default 0, disabled int default 0) is
    begin
        htp.print('<input class="w3-check" type="checkbox" style="color:black;margin:10px;" name="'|| nome ||'"');
        if (checked=1)
        then
            htp.prn(' checked');
        end if;
        if (disabled=1)
        then
            htp.prn(' disabled');
        end if;
        htp.prn('>');
        htp.prn(testo);
    end InputCheckbox;

    procedure InputCheckboxOnClick (testo varchar2, nome varchar2, fun varchar2, id varchar2, checked int default 0, disabled int default 0) is
    begin
        htp.print('<input class="w3-check" style="color:black;margin:10px;" type="checkbox" name="'|| nome ||'"');
        if (checked=1)
        then
            htp.prn(' checked');
        end if;
        if (disabled=1)
        then
            htp.prn(' disabled');
        end if;
        htp.prn(' onClick="' || fun ||'"');
        htp.prn(' id="' || id ||'"');
        htp.prn('>');
        htp.prn(testo);
    end InputCheckboxOnClick;

    procedure ApriDivCard is --DIV di tipo w3-card: Rettangolo che può contenere FORM di inserimento. Si chiude con ChiudiDiv
    begin
        modGUI1.ApriDiv('class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px"');
    end ApriDivCard;

    procedure InputReset is --RESET CAMPI del form
    begin
        htp.prn('<input type="reset" class="w3-button w3-right w3-grey w3-margin">');
    end InputReset;

    procedure Redirect (destinazione VARCHAR2) is
    begin
        htp.print('<script> window.location = "'||costanti.server|| costanti.radice || destinazione||'"</script>');
    end Redirect;

end modGUI1;