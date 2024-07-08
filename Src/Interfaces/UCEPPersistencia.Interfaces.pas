unit UCEPPersistencia.Interfaces;

interface

uses
  UCEP.Types,
  FireDAC.Comp.Client,
  System.Generics.Collections,
  UCEP.Interfaces;

type
  ICEPPersistencia = interface
    ['{86A726D8-CCFB-4C97-9D6E-1E6A7367014F}']
    function CreateCEP(ACEP: ICEP): Integer;
    function GetFullCEPByCEP(ACEP: String): ICEP;
    function GetAllCEPs: TArray<ICEP>; overload;
    function GetAllCEPs(AEstado, ACidade, ALogradouro: String): TArray<ICEP>; overload;
    function UpdateCEP(ACEP: ICEP): Boolean;
    function DeleteCEP(ACep: string): Boolean;
  end;

  implementation

end.
