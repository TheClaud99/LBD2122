CREATE OR REPLACE package PackageStanze as

PROCEDURE visualizzaSale (
        idSessione IN int default 0,
        Sort IN int default 0,
        Deleted IN int default 0,
        Search IN VARCHAR2 default NULL
    );
procedure visualizzaAmbientiServizio (idSessione IN int default 0);
PROCEDURE formSala (
        idSessione IN int default 0,
        modifica IN NUMBER default 0,
        varIdStanza IN NUMBER default NULL,
        varSalaMuseo IN NUMBER default NULL,
        varSalaNome VARCHAR2 default NULL,
        varSalaDimensione NUMBER default NULL,
        varSalaTipo NUMBER default NULL,
        varSalaOpere NUMBER default NULL
        );
PROCEDURE visualizzaSala(
        idSessione in INT default 0,
        varIdSala in NUMBER
        );
PROCEDURE inserisciSala (
        idSessione IN int default 0,
        selectMusei IN musei.idmuseo%TYPE,
        nomeSala       IN  VARCHAR2,
        dimSala            IN  NUMBER,
        tipoSalaform         IN  NUMBER,
        nOpereform           IN NUMBER
    );
PROCEDURE modificaSala (
        idSessione IN int default 0,
        varIdStanza IN NUMBER,
        selectMusei IN musei.idmuseo%TYPE,
        nomeSala       IN  VARCHAR2,
        dimSala            IN  NUMBER,
        tipoSalaform         IN  NUMBER,
        nOpereform           IN NUMBER
    );
PROCEDURE rimuoviSala (
        idSessione IN int default 0,
        varIdStanza IN NUMBER
    );
PROCEDURE ripristinaSala (
        idSessione IN int default 0,
        varIdStanza IN NUMBER
    );
procedure formAmbienteServizio (
        modifica IN NUMBER default 0,
        varASMuseo IN NUMBER default NULL,
        varASNome VARCHAR2 default NULL,
        varASDimensione NUMBER default NULL,
        varASTipo VARCHAR2 default NULL
    );
PROCEDURE inserisciAmbienteServizio (
        selectMusei IN musei.idmuseo%TYPE,
        nomeSala       IN  VARCHAR2,
        dimSala            IN  NUMBER,
        tipoAmbienteForm   IN VARCHAR2
    );
end PackageStanze;