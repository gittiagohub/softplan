unit UCepService.XML;

interface

uses
  UCEP.Interfaces,
  UCepService.Base,
  Xml.XMLIntf;

type
    TCepServiceXml = class(TCepServiceBase, ICepService)
    private
     function XMLToCEP (var ACepNo: IXMLNode) : ICEP;
    public
     function ConsultarCep(aCEP: string): ICEP; overload;override;
     function ConsultarCep(AEstado, ACidade,
                           AEndereco: string): TArray<ICEP>; overload;override;
    end;

implementation
  uses
   Xml.XMLDoc,
   UCEP.Types,
   System.SysUtils,
   UCEP;

function TCepServiceXml.ConsultarCep(aCEP: string): ICEP;
var
  LRecurso: string;
  LRetornoCep: TRetornoCep;
  LXMLCep: IXMLDocument;
  LNoRaiz: IXMLNode;
begin
     try
        LRecurso := '/'+aCEP+'/xml';
        LRetornoCep := BuscaCepApi(LRecurso);

        if ((LRetornoCep.StatusCode <> 200) or
            (LRetornoCep.Content.Contains('<erro>true</erro>'))) then
        begin
             //Cep Não encontrado
             Exit;
        end;

        LXMLCep := TXMLDocument.Create(nil);

        LXMLCep.LoadFromXML(LRetornoCep.Content);
        LXMLCep.Active := True;

        LNoRaiz := LXMLCep.DocumentElement;

        if Assigned(LNoRaiz) then
        begin
             Result := XMLToCEP(LNoRaiz);
        end;

     except
         on  E : ECEPException  do
         begin
              Raise
         end
         else
         begin
              raise ECEPException.Create('Erro Ao Consultar CEP Online Por XML.');
         end;
     end;
end;

function TCepServiceXml.ConsultarCep(AEstado, ACidade,
                                     AEndereco: string): TArray<ICEP>;
var
  LRecurso: string;
  LRetornoCep: TRetornoCep;
  LXMLCep: IXMLDocument;
  LNoRaiz: IXMLNode;
  LCepsNo: IXMLNode;
  I: Integer;
  LCepNo: IXMLNode;
begin
     Result := nil;
     try
        LRecurso := AEstado+'/'+ACidade+'/'+AEndereco+'/xml';
        LRetornoCep := BuscaCepApi(LRecurso);

        if ((LRetornoCep.StatusCode <> 200) or
            (LRetornoCep.Content.Contains('<erro>true</erro>')))  then
        begin
             Exit;
        end;

        LXMLCep := TXMLDocument.Create(nil);

        LXMLCep.LoadFromXML(LRetornoCep.Content);
        LXMLCep.Active := True;

        LNoRaiz := LXMLCep.DocumentElement;

        if Assigned(LNoRaiz) then
        begin
             // Endereço é o nó de CEPS
             LCepsNo := LNoRaiz.ChildNodes.FindNode('enderecos');

             if Assigned(LCepsNo) then
             begin
                  for I := 0 to LCepsNo.ChildNodes.Count - 1 do
                  begin
                       LCepNo := LCepsNo.ChildNodes[i];
                       //Ganrante que so vai pegar o Nó endereco que é o de CEP
                       if LCepNo.NodeName = 'endereco' then
                       begin
                            SetLength(Result,Length(Result) + 1);
                            Result[High(result)] := XMLToCEP(LCepNo);
                       end;
                  end;
             end;
        end;

     except
         on  E : ECEPException  do
         begin
              Raise
         end
         else
         begin
               raise ECEPException.Create('Erro Ao Consultar CEP Online Por XML.');
         end;
     end;
end;

function TCepServiceXml.XMLToCEP(var ACepNo: IXMLNode): ICEP;
begin
     try
        Result:= TCEP.Create(0,
                             ACepNo.ChildNodes['cep'].Text,
                             ACepNo.ChildNodes['logradouro'].Text,
                             ACepNo.ChildNodes['complemento'].Text,
                             ACepNo.ChildNodes['bairro'].Text,
                             ACepNo.ChildNodes['localidade'].Text,
                             ACepNo.ChildNodes['uf'].Text);
     
     except
         on  E : ECEPException  do
         begin
              Raise
         end
         else
         begin
              raise ECEPException.Create('Erro Ao Transformar Os Dados XML Retornados Em CEP');
         end;
     end;
end;

end.
