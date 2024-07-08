unit UCEPPersistencia;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  UCEP.Interfaces,
  UCEP,
  UConnection,
  UConnection.Interfaces,
  UCEPPersistencia.Interfaces;

type
  TCEPPersistencia = class (TInterfacedObject,ICEPPersistencia)
  private
    FConexao: IConnection;
    FQuery  : TFDQuery;
    function QueryToCEP(AQuery: TFDQuery): ICEP;
    procedure CriaTabelaCEP;

  public
    constructor Create(AConnection : IConnection);
    destructor Destroy; override;
    function CreateCEP(ACEP: ICEP): Integer;
    function GetFullCEPByCEP(ACEP: String): ICEP;
    function GetAllCEPs: TArray<ICEP>;overload;
    function GetAllCEPs(AEstado,ACidade,ALogradouro : String): TArray<ICEP>;overload;
    function UpdateCEP(ACEP: ICEP): Boolean;
    function DeleteCEP(ACep : string): Boolean;

  end;

implementation

uses
  System.Classes,
  System.Generics.Collections,
  Firedac.DApt,
  Firedac.Stan.Async,
  UCEP.Types;

{ TCEPDataAccess }

constructor TCEPPersistencia.Create(AConnection : IConnection);
begin
     FConexao := AConnection;
     FQuery   := TFDQuery.Create(nil);
     FQuery.Connection := TFDConnection(FConexao);
end;

destructor TCEPPersistencia.Destroy;
begin
     FreeAndNil(FQuery);
     inherited;
end;

function TCEPPersistencia.QueryToCEP(AQuery: TFDQuery): ICEP;
begin
     with AQuery do
     begin
          Result := TCEP.Create(FieldByName('Codigo').AsInteger,
                                FieldByName('Cep').AsString,
                                FieldByName('Logradouro').AsString,
                                FieldByName('Complemento').AsString,
                                FieldByName('Bairro').AsString,
                                FieldByName('Localidade').AsString,
                                FieldByName('UF').AsString);
     end;
end;

function TCEPPersistencia.CreateCEP(ACEP: ICEP): Integer;
begin
     try
        FQuery.SQL.Text := 'INSERT INTO '
                          +'    cep ( '
                          +'        Cep, '
                          +'        Logradouro, '
                          +'        Complemento, '
                          +'        Bairro, '
                          +'        Localidade, '
                          +'        UF '
                          +'    ) '
                          +'VALUES '
                          +'    ( '
                          +'        :Cep, '
                          +'        :Logradouro, '
                          +'        :Complemento, '
                          +'        :Bairro, '
                          +'        :Localidade, '
                          +'        :UF '
                          +'    )';
       FQuery.ParamByName('Cep').AsString         := ACEP.Cep;
       FQuery.ParamByName('Logradouro').AsString  := ACEP.Logradouro;
       FQuery.ParamByName('Complemento').AsString := ACEP.Complemento;
       FQuery.ParamByName('Bairro').AsString      := ACEP.Bairro;
       FQuery.ParamByName('Localidade').AsString  := ACEP.Localidade;
       FQuery.ParamByName('UF').AsString          := ACEP.UF;

       FQuery.ExecSQL;

       FQuery.SQL.Text := 'SELECT LAST_INSERT_ID() AS Codigo';
       FQuery.Open;

       Result := FQuery.FieldByName('Codigo').AsInteger;
     except
           on  E : ECEPException  do
           begin
                Raise
           end
           else
           begin
                raise ECEPException.Create('Error Ao Criar O CEP no Banco de Dados.');
           end;
     end;
end;

procedure TCEPPersistencia.CriaTabelaCEP;
begin
     try
        FQuery.SQL.Text:= 'CREATE TABLE `cep` ( '
                       +'  `codigo` int(11) NOT NULL AUTO_INCREMENT, '
                       +'  `cep` varchar(8) NOT NULL, '
                       +'  `uf` varchar(2) NOT NULL, '
                       +'  `bairro` varchar(255) DEFAULT NULL, '
                       +'  `localidade` varchar(255) DEFAULT NULL, '
                       +'  `logradouro` varchar(255) DEFAULT NULL, '
                       +'  `complemento` varchar(255) DEFAULT NULL, '
                       +'  PRIMARY KEY (`codigo`), '
                       +'  UNIQUE KEY `cep_cep_key` (`cep`) '
                       +') ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;';

        FQuery.Execute();
     except on E: Exception do
        begin
             raise ECEPException.Create('Error Ao Criar a Tabela de CEP no Banco.'
                                        +slinebreak
                                        +'Verifique se Tem Permissão Para Criar a Tabela.');
        end;
     end;
end;

function TCEPPersistencia.GetAllCEPs(AEstado, ACidade,
                                     ALogradouro: String): TArray<ICEP>;
begin
     try
        FQuery.SQL.Text := 'SELECT * FROM cep '+
                           ' Where '+
                           ' UF =:UF and '+
                           ' localidade like :localidade and '+
                           ' logradouro like :logradouro';

        FQuery.ParamByName('logradouro').AsString  := '%'+ALogradouro+'%';
        FQuery.ParamByName('localidade').AsString  := '%'+ACidade+'%';
        FQuery.ParamByName('UF').AsString          := AEstado;
        FQuery.Open;

        FQuery.First;
        while not FQuery.Eof do
        begin
             SetLength(Result,Length(Result) + 1);
             Result[High(Result)] := QueryToCEP(FQuery);
             FQuery.Next;
        end;

     except
           on  E : ECEPException  do
           begin
                Raise
           end
           else
           begin
                raise ECEPException.Create('Error Ao Obter O(s) CEP(s) ');
           end;
     end;
end;

function TCEPPersistencia.GetFullCEPByCEP(ACEP: String): ICEP;
begin
     Result := nil;
     try
        FQuery.SQL.Text := 'SELECT * FROM cep WHERE CEP = :CEP';
        FQuery.Params.ParamByName('CEP').AsString := ACEP;
        FQuery.Open;

        if not FQuery.Eof then
        begin
             Result := QueryToCEP(FQuery);
        end;

     except
           on  E : ECEPException do
           begin
                Raise
           end;
           on e :Exception do
           begin

                if E.message.Contains('doesn''t exist') then
                begin
                     try
                        CriaTabelaCEP;
                     except on E: ECEPException do
                         Raise
                     end;

                end
                else
                begin
                     raise ECEPException.Create('Error Ao Obter O CEP '+
                                            slinebreak+E.Message);
                end;

           end;
     end;
end;

function TCEPPersistencia.GetAllCEPs: TArray<ICEP>;
begin
     try
        FQuery.SQL.Text := 'SELECT * FROM cep';
        FQuery.Open;

        FQuery.First;
        while not FQuery.Eof do
        begin
             SetLength(Result,Length(Result) + 1);
             Result[High(Result)] := QueryToCEP(FQuery);
             FQuery.Next;
        end;
     except
           on  E : ECEPException do
           begin
                Raise
           end;
           on e :Exception do
           begin

                if E.message.Contains('doesn''t exist') then
                begin
                     try
                        CriaTabelaCEP;
                     except on E: ECEPException do
                         Raise
                     end;
                end
                else
                begin
                     raise ECEPException.Create('Error Ao Obter O CEP '+
                                            slinebreak+E.Message);
                end;

           end;
     end;
end;

function TCEPPersistencia.UpdateCEP(ACEP: ICEP): Boolean;
begin
     Result := False;
     try
        FQuery.SQL.Text := 'UPDATE '
                          +'    cep '
                          +'SET '
                          +'    Cep = :Cep, '
                          +'    Logradouro = :Logradouro, '
                          +'    Complemento = :Complemento, '
                          +'    Bairro = :Bairro, '
                          +'    Localidade = :Localidade, '
                          +'    UF = :UF '
                          +'WHERE '
                          +'    Codigo = :Codigo';

        FQuery.ParamByName('Codigo').AsInteger     := ACEP.Codigo;
        FQuery.ParamByName('Cep').AsString         := ACEP.Cep;
        FQuery.ParamByName('Logradouro').AsString  := ACEP.Logradouro;
        FQuery.ParamByName('Complemento').AsString := ACEP.Complemento;
        FQuery.ParamByName('Bairro').AsString      := ACEP.Bairro;
        FQuery.ParamByName('Localidade').AsString  := ACEP.Localidade;
        FQuery.ParamByName('UF').AsString          := ACEP.UF;
        FQuery.ExecSQL;

        Result := True;
     except
           on  E : ECEPException  do
           begin
                Raise
           end
           else
           begin
                raise ECEPException.Create('Error Ao Atualizar O CEP No Banco de Dados');
           end;
     end;
end;

function TCEPPersistencia.DeleteCEP(ACep: String): Boolean;
begin
     Result := False;
     try
        FQuery.SQL.Text := 'DELETE FROM cep WHERE cep = :cep';
        FQuery.Params.ParamByName('CEP').AsString := ACEP;
        FQuery.ExecSQL;

        Result := True;
     except
           on  E : ECEPException  do
           begin
                Raise
           end
           else
           begin
                raise ECEPException.Create('Error Ao Apagar O CEP No Banco de Dados');
           end;
     end;
end;

end.

