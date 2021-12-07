create or replace package tariffeCampiEstiviOperazioni as

procedure InserisciTariffeCampiEstivi
(
    prezzo in TARIFFECAMPIESTIVI.Prezzo%type default 0,
    etaMinima in TARIFFECAMPIESTIVI.Etaminima%type default 0,
    etaMassima in TARIFFECAMPIESTIVI.Etamassima%type default 0,
    campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type default 0
);

procedure ConfermaTariffeCampiEstivi
(
    prezzo in TARIFFECAMPIESTIVI.Prezzo%type default 0,
    etaMinima in TARIFFECAMPIESTIVI.Etaminima%type default 0,
    etaMassima in TARIFFECAMPIESTIVI.Etamassima%type default 0,
    campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type default 0
);

procedure ControllaTariffeCampiEstivi
(
    prezzo in TARIFFECAMPIESTIVI.Prezzo%type default 0,
    etaMinima in TARIFFECAMPIESTIVI.Etaminima%type default 0,
    etaMassima in TARIFFECAMPIESTIVI.Etamassima%type default 0,
    campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type default 0
);

procedure VisualizzaTariffeCampiEstivi
(
    idTariffa in TARIFFECAMPIESTIVI.IdTariffa%type
);

procedure ModificaTariffeCampiEstivi
(
    idTariffa in TARIFFECAMPIESTIVI.IdTariffa%type, 
    prezzo in TARIFFECAMPIESTIVI.Prezzo%type default 0,
    etaMinima in TARIFFECAMPIESTIVI.Etaminima%type default 0,
    etaMassima in TARIFFECAMPIESTIVI.Etamassima%type default 0,
    campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type default 0
);

procedure CancellaTariffeCampiEstivi
(
    idTariffa in TARIFFECAMPIESTIVI.IdTariffa%type
);

procedure MonitoraTariffeCampiEstivi_preferenzaTariffa
(
);

procedure monitoraTariffeCampiEstivi_tariffeAnno
(
    anno in number
);

procedure MonitoraTariffeCampiEstivi_tariffeCampo
(
    campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type
);

end tariffeCampiEstiviOperazioni;