unit UCepService.Base;

interface

uses
    UCEP.Interfaces,
    RESTRequest4D,
    UCEP.Types;

type
    TCepServiceBase = class(TInterfacedObject, ICepService)
    protected
     function BuscaCepApi(aRecurso: String): TRetornoCep;
     const GBaseURL  = 'https://viacep.com.br/ws';
    public
     function ConsultarCep(aCEP: string): ICEP; overload; virtual; abstract;

     function ConsultarCep(AEstado, ACidade,
                          AEndereco: string):TArray<ICEP>;overload; virtual; abstract;

    end;

implementation

uses
    IpPeerClient,
    System.SysUtils;

function TCepServiceBase.BuscaCepApi(aRecurso: String): TRetornoCep;
var LResponse : IResponse;
begin
     try
        LResponse := TRequest
                     .New
                     .BaseURL(GBaseURL)
                     .Resource(aRecurso)
                     .Accept('application/json;application/xml')
                     .AcceptCharset('UTF-8')
                     .Get;

       Result.Content    := LResponse.Content;
       Result.StatusCode := LResponse.StatusCode;

     except on E: Exception do
         raise ECEPException.Create('Erro Ao Fazer a Requisição Na Api de CEP.');
     end;
end;


end.
