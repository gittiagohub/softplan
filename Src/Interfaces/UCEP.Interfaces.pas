unit UCEP.Interfaces;

interface

type

   ICEP = interface
    ['{20C6BCB6-3A0C-4081-AE61-DB46B156EF01}']
    function getCodigo: Integer;
    function getCep: string;
    function getLogradouro: string;
    function getComplemento: string;
    function getBairro: string;
    function getLocalidade: string;
    function getUF: string;
    procedure SetCep(const Value: string);

    property Codigo: Integer read getCodigo;
    property Cep: string read getCep write SetCep;
    property Logradouro: string read getLogradouro;
    property Complemento: string read getComplemento;
    property Bairro: string read getBairro;
    property Localidade: string read getLocalidade;
    property UF: string read getUF;
  end;

  ICepService = interface
   ['{75103F91-B485-4E0D-BC5A-DB0F2FE1C06F}']
    function ConsultarCep(aCEP: string): ICEP overload;
    function ConsultarCep(AEstado,ACidade,AEndereco: string): TArray<ICEP> overload;
  end;

  implementation

end.
