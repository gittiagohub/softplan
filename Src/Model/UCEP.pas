unit UCEP;

interface

uses
 UCEP.Interfaces;

type
    TCEP = class(TInterfacedObject, ICEP)
    private
     FCodigo : Integer;
     FCep    : string;
     FLogradouro : string;
     FComplemento : string;
     FBairro : string;
     FLocalidade : string;
     FUF : string;

     function getCodigo: Integer;
     function getCep: string;
     function getLogradouro: string;
     function getComplemento: string;
     function getBairro: string;
     function getLocalidade: string;
     function getUF: string;
     procedure SetCep(const Value: string);

    public

    property Codigo: Integer read getCodigo;
    property Cep: string read getCep write SetCep;
    property Logradouro: string read getLogradouro;
    property Complemento: string read getComplemento;
    property Bairro: string read getBairro;
    property Localidade: string read getLocalidade;
    property UF: string read getUF;
     constructor Create(ACodigo: Integer; ACep, ALogradouro, AComplemento,
                        ABairro, ALocalidade, AUF: string);

    end;

implementation

uses
  System.SysUtils;
constructor TCEP.Create(ACodigo: Integer; ACep, ALogradouro, AComplemento,
                        ABairro, ALocalidade, AUF: string);
begin
     FCodigo := ACodigo;
     FCep := ACep;
     FLogradouro := ALogradouro;
     FComplemento := AComplemento;
     FBairro := ABairro;
     FLocalidade := ALocalidade;
     FUF := AUF;
end;

function TCEP.getCodigo: Integer;
begin
     Result := FCodigo;
end;

function TCEP.getCep: string;
begin
     Result := FCep;
end;

function TCEP.getLogradouro: string;
begin
     Result := FLogradouro;
end;

function TCEP.getComplemento: string;
begin
     Result := FComplemento;
end;

function TCEP.getBairro: string;
begin
     Result := FBairro;
end;

function TCEP.getLocalidade: string;
begin
     Result := FLocalidade;
end;

function TCEP.getUF: string;
begin
     Result := FUF;
end;

procedure TCEP.SetCep(const Value: string);
begin
     FCep := Value;
end;

end.
