unit UValidation.Interfaces;

interface

uses
  UCEP.Types;

type
  IValidationCEP = interface
    ['{F8C3B735-D918-4B6F-89BB-0939998724F2}']
    function ValidaCep: TRetornoValidacao;
    function ValidaEnderecoCompleto: TRetornoValidacao;
    procedure SetCEP(const Value: String);
    procedure SetCidade(const Value: String);
    procedure SetEstado(const Value: String);
    procedure SetLogradouro(const Value: String);

    property CEP: String write SetCEP;
    property Estado: String write SetEstado;
    property Cidade: String write SetCidade;
    property Logradouro: String write SetLogradouro;
  end;
    implementation

end.
