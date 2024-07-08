unit UValidation;

interface

uses
  UCEP.Types,
  UValidation.Interfaces;

  type
   TValidationCEP = class(TInterfacedObject,IValidationCEP)
   private
    FLogradouro: String;
    FCEP: String;
    FCidade: String;
    FEstado: String;
    procedure SetCEP(const Value: String);
    procedure SetCidade(const Value: String);
    procedure SetEstado(const Value: String);
    procedure SetLogradouro(const Value: String);
    { private declarations }
   protected
    { protected declarations }
   public
    { public declarations }
     constructor Create(ACEP :String);overload;
     constructor Create(AEstado,ACidade,ALogradouro: String);overload;

    function ValidaCep : TRetornoValidacao;
    function ValidaEnderecoCompleto : TRetornoValidacao;

    property CEP : String read FCEP write SetCEP;
    property Estado : String read FEstado write SetEstado;
    property Cidade : String read FCidade write SetCidade;
    property Logradouro : String read FLogradouro write SetLogradouro;

   published
    { published declarations }
   end;
implementation

uses
  System.SysUtils, UUtils;

{ TValidation }

constructor TValidationCEP.Create(ACEP: String);
begin
     FCEP := ACEP;
end;

constructor TValidationCEP.Create(AEstado, ACidade, ALogradouro: String);
begin
     FEstado := AEstado;
     FCidade := ACidade;
     FLogradouro := ALogradouro;
end;

procedure TValidationCEP.SetCEP(const Value: String);
begin
    FCEP := Value;
end;

procedure TValidationCEP.SetCidade(const Value: String);
begin
     FCidade := Value;
end;

procedure TValidationCEP.SetEstado(const Value: String);
begin
     FEstado := Value;
end;

procedure TValidationCEP.SetLogradouro(const Value: String);
begin
     FLogradouro := Value;
end;

function TValidationCEP.ValidaCep: TRetornoValidacao;
begin
     try
        Result.OK:= True;
        FCep := TUtils.RetiraMascara(FCep);

        FCep := StringReplace(fCep,' ','',[rfReplaceAll]);

        if FCep.Trim.IsEmpty then
        begin
             Result.OK:= False;
             Result.Mensagem := 'CEP não informado.';
             Exit;
        end;

        if FCep.Trim.Length <> 8 then
        begin
             Result.OK:= False;
             Result.Mensagem := 'CEP inválido. O CEP não tem 8 dígitos.';
             Exit;
        end;

        try
           StrToInt(FCep);
        except on E: EConvertError do
            begin
                 Result.OK:= False;
                 Result.Mensagem := 'CEP inválido. O CEP deve conter apenas números.';
            end;
        end;

     except on E: Exception do
        begin
             Result.OK:= False;
             Result.Mensagem := 'Erro ao validar o CEP informado.';
        end;
     end
end;

function TValidationCEP.ValidaEnderecoCompleto: TRetornoValidacao;
begin
     Result.OK := True;

     if FEstado.Trim.IsEmpty then
     begin
          Result.OK:= False;
          Result.Mensagem := 'O Estado Não Pode Estar Vazio.';
          Exit;
     end;

     if FEstado.Trim.Length <> 2 then
     begin
          Result.OK:= False;
          Result.Mensagem := 'O Estado Deve Ter Apenas 2 Caracteres.';
          Exit;
     end;

     if FCidade.Trim.IsEmpty then
     begin
          Result.OK:= False;
          Result.Mensagem := 'A Localidade Não Pode Estar Vazia.';
          Exit;
     end;

     if FCidade.Trim.Length < 2 then
     begin
          Result.OK:= False;
          Result.Mensagem := 'A Localidade Deve Ter 3 ou Mais Caracteres.';
          Exit;
     end;

     if FLogradouro.Trim.IsEmpty then
     begin
          Result.OK:= False;
          Result.Mensagem := 'O Logradouro Não Pode Estar Vazio.';
          Exit;
     end;

     if FLogradouro.Trim.Length < 2 then
     begin
          Result.OK:= False;
          Result.Mensagem := 'O Logradouro Deve Ter 3 ou Mais Caracteres.';
          Exit;
     end;
end;

end.
