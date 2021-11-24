create or replace package tariffeCampiEstiviOperazioni as

procedure InserisciTariffeCampiEstivi
(
    sessionID in number, 
    prezzo in TARIFFECAMPIESTIVI.Prezzo%type default 0,
    etaMinima in TARIFFECAMPIESTIVI.Etaminima%type default 0,
    etaMassima in TARIFFECAMPIESTIVI.Etamassima%type default 0,
    campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type default 0
);

procedure ConfermaTariffeCampiEstivi
(
    sessionID in number, 
    prezzo in TARIFFECAMPIESTIVI.Prezzo%type default 0,
    etaMinima in TARIFFECAMPIESTIVI.Etaminima%type default 0,
    etaMassima in TARIFFECAMPIESTIVI.Etamassima%type default 0,
    campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type default 0
);

procedure ControllaTariffeCampiEstivi
(
    sessionID in number, 
    prezzo in TARIFFECAMPIESTIVI.Prezzo%type default 0,
    etaMinima in TARIFFECAMPIESTIVI.Etaminima%type default 0,
    etaMassima in TARIFFECAMPIESTIVI.Etamassima%type default 0,
    campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type default 0
);

procedure VisualizzaTariffeCampiEstivi
(
    sessionID in number, 
    idTariffa in TARIFFECAMPIESTIVI.IdTariffa%type
);

procedure ModificaTariffeCampiEstivi
(
    sessionID in number, 
    idTariffa in TARIFFECAMPIESTIVI.IdTariffa%type, 
    prezzo in TARIFFECAMPIESTIVI.Prezzo%type default 0,
    etaMinima in TARIFFECAMPIESTIVI.Etaminima%type default 0,
    etaMassima in TARIFFECAMPIESTIVI.Etamassima%type default 0,
    campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type default 0
);

procedure CancellaTariffeCampiEstivi
(
    sessionID in number, 
    idTariffa in TARIFFECAMPIESTIVI.IdTariffa%type
);

procedure MonitoraTariffeCampiEstivi_preferenzaTariffa
(
    sessionID in number
);

procedure monitoraTariffeCampiEstivi_tariffeAnno
(
    sessionID in number, 
    anno in number
);

procedure MonitoraTariffeCampiEstivi_tariffeCampo
(
    sessionID in number, 
    campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type
);

end tariffeCampiEstiviOperazioni;