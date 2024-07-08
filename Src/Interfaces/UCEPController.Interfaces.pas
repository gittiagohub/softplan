unit UCEPController.Interfaces;

interface

uses
  uCEP.Types,
  UCEPPersistencia,
  UCEP.Interfaces;

type
  ICEPController = interface
    ['{E9B5C8D4-8A5F-48F9-B5D8-1C6E4F9D4F8D}']
    function CreateCEP(ACep, ALogradouro, AComplemento, ABairro, ALocalidade,
                       AUF: string): ICEP;
    function GetCEP(ACEP: String): ICEP;
    function GetCEPs(AEstado, ACidade, ALogradouro: String): TArray<ICEP>;
    function GetAllCEPs: TArray<ICEP>;
    function UpdateCEP(ACEP: ICEP): Boolean;
    function DeleteCEP(ACEP: String): Boolean;
  end;

 implementation

end.
