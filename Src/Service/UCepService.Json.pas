unit UCepService.Json;

interface

uses
  uCEP.Interfaces,
  UCepService.Base,
  System.JSON;


type
    TCepServiceJson = class(TCepServiceBase, ICepService)
    private
     function JsonToCEP(AJson :TJSONValue) : ICEP;
    public
     function ConsultarCep(ACEP: string): ICEP; overload; override;

     function ConsultarCep(AEstado, ACidade,
                           AEndereco: string): TArray<ICEP>; overload;override;
    end;

implementation

   uses
   RESTRequest4D,
   System.SysUtils,
   UCEP.Types,
   UCEP;

function TCepServiceJson.ConsultarCep(aCEP: string): ICEP;
var LRetornoCep :TRetornoCep;
    LJSONCep : TJSONValue;
    LRecurso: String;
begin
     Result := nil;
     try
        LRecurso := '/'+aCEP+'/json';

        LRetornoCep := BuscaCepApi(LRecurso);

       if ((LRetornoCep.StatusCode <> 200) or
            (LRetornoCep.Content.Contains('"erro": "true"'))) then
        begin
             //Cep Não encontrado
             Exit;
        end;

        LJSONCep := TJSONObject
                    .ParseJSONValue(LRetornoCep.Content) as TJSONValue;
        try
           Result := JsonToCEP(LJSONCep);
        finally
            FreeAndNil(LJSONCep);
        end;

     except
           on  E : ECEPException  do
           begin
                Raise
           end
           else
           begin
                raise ECEPException.Create('Erro Ao Consultar CEP Online Por Json.');
           end;
     end;
end;

function TCepServiceJson.ConsultarCep(AEstado, ACidade,
                                      AEndereco: string): TArray<ICEP>;
var
  LRetornoCep: TRetornoCep;
  LRecurso : String;
  LJSONCepArray: TJSONArray;
  LJSONCep : TJSONValue;
begin
     Result := nil;
     try
        LRecurso := AEstado+'/'+ACidade+'/'+AEndereco+'/json';
        LRetornoCep := BuscaCepApi(LRecurso);

        if ((LRetornoCep.StatusCode <> 200) or
            (LRetornoCep.Content.Contains('"erro": "true"'))) then
        begin
             Exit;
        end;

        if LRetornoCep.Content.StartsWith('[') then
        begin
             LJSONCepArray := TJSONObject.ParseJSONValue(LRetornoCep.Content) as TJSONArray;
             try
                for LJSONCep in LJSONCepArray do
                begin
                     SetLength(Result, Length(Result) + 1);
                     Result[High(result)] := JsonToCEP(LJSONCep as TJSONObject);
                end;
             finally
                 FreeAndNil(LJSONCepArray);
             end;
        end
        else
        begin
             LJSONCep := TJSONObject.ParseJSONValue(LRetornoCep.Content) as TJSONValue;
             try
                SetLength(Result, Length(Result) + 1);
                Result[High(result)] := JsonToCEP(LJSONCep);
             finally
                 FreeAndNil(LJSONCep);
             end;
        end;
        
     except
           on  E : ECEPException  do
           begin
                Raise
           end
           else
           begin
                raise ECEPException.Create('Erro Ao Consultar CEP Online Por Json.');
           end;
     end;
end;

function TCepServiceJson.JsonToCEP(AJson: TJSONValue): ICEP;
var
  LLocalidade: String;
begin
     try
        if not AJson.TryGetValue('localidade',LLocalidade) then
        begin
             LLocalidade := AJson.GetValue<String>('cidade');
        end;

        Result := TCEP.Create(0,
                              AJson.GetValue<String>('cep'),
                              AJson.GetValue<String>('logradouro'),
                              AJson.GetValue<String>('complemento'),
                              AJson.GetValue<String>('bairro'),
                              LLocalidade,
                              AJson.GetValue<String>('uf'));

     except
           on  E : ECEPException  do
           begin
                Raise
           end
           else
           begin
                raise ECEPException.Create('Erro Ao Transformar O Dados Json Retornados Em CEP');
           end;
     end;
end;

end.
