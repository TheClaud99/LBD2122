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
    up_idTariffa in TARIFFECAMPIESTIVI.IdTariffa%type
);

procedure AggiornaTariffeCampiEstivi
(
    up_idTariffa number default 0, 
    up_prezzo in TARIFFECAMPIESTIVI.Prezzo%type default 0,
    up_etaMinima in TARIFFECAMPIESTIVI.Etaminima%type default 0,
    up_etaMassima in TARIFFECAMPIESTIVI.Etamassima%type default 0,
    up_campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type default 0
);

procedure CancellaTariffeCampiEstivi
(
    idTariffa in TARIFFECAMPIESTIVI.IdTariffa%type
);

procedure MonitoraTariffeCampiEstivi_preferenzaTariffa;
(
    campoEstivo in tariffecampiestivi.campoestivo%type default 0
);

procedure MonitoraTariffeCampiEstivi_tariffeAnno
(
    anno in number
);

procedure MonitoraTariffeCampiEstivi_tariffeCampo
(
    campoEstivo in TARIFFECAMPIESTIVI.CampoEstivo%type
);

end tariffeCampiEstiviOperazioni;