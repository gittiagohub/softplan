unit UCEPManager;

interface

uses
   CEP.Interfaces,
   System.SysUtils,
   UCEPController,
   CEP.Types;

type

  TCEPManager = class
  private
    FCEPController: TCEPController;
    FFormatoRetorno: TFormatoRetorno;
    procedure SetFormatoRetorno(const Value: TFormatoRetorno);
  public
    constructor Create;
    destructor Destroy; override;
    function GetCEP(aCEP: string): ICEP;
  published
      property FormatoRetorno :TFormatoRetorno read FFormatoRetorno write SetFormatoRetorno;
  end;

implementation

uses
  UCepService.XML, UCepService.Json;

{ TCEPManager }

constructor TCEPManager.Create;
begin
     FCEPController := TCEPController.Create;
end;

destructor TCEPManager.Destroy;
begin
     FCEPController.Free;
     inherited;
end;

function TCEPManager.GetCEP(aCEP: string): ICEP;
var LCepService: ICepService;
begin
     // Verifica se o CEP existe no banco de dados
     Result := FCEPController.GetCEP(aCEP);

     // Se não encontrar busca na API
     if Result = nil then
     begin
          case FormatoRetorno of
              FRXML  : LCepService := TCepServiceXml.Create;
              FRJSON : LCepService := TCepServiceJson.Create;
          end;

          LCepService.ConsultarCep(aCEP);
          Result := LCepService.ConsultarCep(aCEP);

          // Se encontrou na API salva no banco
          if Assigned(Result) then
          begin
               FCEPController.CreateCEP(Result.getCep,
                                        Result.getLogradouro,
                                        Result.getComplemento,
                                        Result.getBairro,
                                        Result.getLocalidade,
                                        Result.getUF);
          end;
     end;
end;

procedure TCEPManager.SetFormatoRetorno(const Value: TFormatoRetorno);
begin
     FFormatoRetorno := Value;
end;

end.

