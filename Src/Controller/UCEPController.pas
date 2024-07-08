unit UCEPController;

interface

uses
  UCEP.Interfaces,
  UCEP,
  System.SysUtils,
  System.Generics.Collections,
  UCEPPersistencia,
  UUtils,
  UCEPPersistencia.Interfaces,
  UCEPController.Interfaces;

type
  TCEPController = class(TInterfacedObject,ICEPController)
  private
    FCEPPersistencia: ICEPPersistencia;

  public
    constructor Create(ACEPPersistencia :ICEPPersistencia);
    destructor Destroy; override;
    function CreateCEP(ACep, ALogradouro, AComplemento, ABairro, ALocalidade,
                       AUF: string): ICEP;
    function GetCEP(ACEP: String): ICEP;
    function GetCEPs(AEstado,ACidade,ALogradouro: String): TArray<ICEP>;
    function GetAllCEPs: TArray<ICEP>;
    function UpdateCEP(ACEP: ICEP): Boolean;
    function DeleteCEP(ACEP: String): Boolean;

  end;

implementation

uses
  UCEP.Types;

{ TCEPController }

constructor TCEPController.Create(ACEPPersistencia :ICEPPersistencia);
begin
     FCEPPersistencia := ACEPPersistencia;
end;

destructor TCEPController.Destroy;
begin
     inherited;
end;

function TCEPController.CreateCEP(ACep, ALogradouro, AComplemento, ABairro,
                                  ALocalidade, AUF: string): ICEP;
var
  LCEP,LUpdateCEP: ICEP;
  LCodigo: Integer;
begin
     //Verifico se já existe no banco, caso sim, o mesmo será atualizado
     try
        LCEP := GetCEP(ACep);

        if Assigned(LCEP) then
        begin
             LUpdateCEP := TCEP.Create(LCEP.Codigo,
                                       ACep,
                                       ALogradouro,
                                       AComplemento,
                                       ABairro,
                                       ALocalidade,
                                       AUF);
             UpdateCEP(LUpdateCEP);

             Result := LUpdateCEP;
        end
        else
        begin

                ACep := TUtils.RetiraMascara(ACep);

                LCEP := TCEP.Create(0,
                                    ACep,
                                    ALogradouro,
                                    AComplemento,
                                    ABairro,
                                    ALocalidade,
                                    AUF);

                LCodigo := FCEPPersistencia.CreateCEP(LCEP);

                Result := TCEP.Create(LCodigo,
                                      ACep,
                                      ALogradouro,
                                      AComplemento,
                                      ABairro,
                                      ALocalidade,
                                      AUF);


        end;
     except
           on  E : ECEPException  do
           begin
                Raise
           end
           else
           begin
                raise ECEPException.Create('Erro Ao Salvar o CEP.');
           end;
     end;
end;

function TCEPController.GetCEP(ACEP: String): ICEP;
begin
     ACEP := TUtils.RetiraMascara(ACEP);
     try
        Result := FCEPPersistencia.GetFullCEPByCEP(ACEP);
      except
           on  E : ECEPException  do
           begin
                Raise
           end
           else
           begin
                raise ECEPException.Create('Erro Ao Obter o CEP.');
           end;
     end;
end;

function TCEPController.GetAllCEPs: TArray<ICEP>;
begin
     try
        Result := FCEPPersistencia.GetAllCEPs
     except
           on  E : ECEPException  do
           begin
                Raise
           end
           else
           begin
                raise ECEPException.Create('Erro Ao Obter os CEPs.');
           end;
     end;
end;

function TCEPController.GetCEPs(AEstado, ACidade,
  ALogradouro: String): TArray<ICEP>;
begin
     try
        Result := FCEPPersistencia.GetAllCEPs(AEstado,ACidade,ALogradouro);
     except
           on  E : ECEPException  do
           begin
                Raise
           end
           else
           begin
                raise ECEPException.Create('Erro Ao Obter os CEPs por Endereço Completo.');
           end;
     end;
end;

function TCEPController.UpdateCEP(ACEP: ICEP): Boolean;
begin
     TUtils.RetiraMascara(ACEP);
     try
        Result := FCEPPersistencia.UpdateCEP(ACEP);
     except
           on  E : ECEPException  do
           begin
                Raise
           end
           else
           begin
                raise ECEPException.Create('Erro Ao Atualizar o CEP.');
           end;
     end;;
end;

function TCEPController.DeleteCEP(ACEP: String): Boolean;
begin
     try
        Result := FCEPPersistencia.DeleteCEP(ACEP);
     except
           on  E : ECEPException  do
           begin
                Raise
           end
           else
           begin
                raise ECEPException.Create('Erro Ao Apagar o CEP.');
           end;
     end;
end;

end.

