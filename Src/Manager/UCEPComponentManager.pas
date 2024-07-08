unit UCEPComponentManager;

interface

uses
   System.SysUtils,
   System.Classes,
   UCEPController,
   UCEP.Types,
   UCEP.Interfaces,
   Data.DB, UCEPController.Interfaces;

type
  TCEPManager = class(TComponent)
  private
    { Private declarations }
    FFormatoRetorno: TFormatoRetorno;
    FDataSource: TDataSource;
    procedure SetFormatoRetorno(const Value: TFormatoRetorno);
    procedure SetDataSource(const Value: TDataSource);

    procedure CEPToDataSet(ACEP : ICEP);overload;
    procedure CEPToDataSet(ACEP : TArray<ICEP>);overload;

    function  CEPController() : ICEPController;

  protected
    { Protected declarations }
  public
    procedure Execute(ACEP: string);overload;
    procedure Execute(AEstado,ACidade,ALogradouro : String);overload;
    procedure CarregaTodosRegistros;

    procedure Notification(AComponent: TComponent;
                           Operation: TOperation); override;
    { Public declarations }
  published
   property FormatoRetorno :TFormatoRetorno read FFormatoRetorno
                                         write SetFormatoRetorno;

   property DataSource : TDataSource read FDataSource write SetDataSource;
    { Published declarations }
  end;

procedure Register;

implementation

uses
  UCepService.XML, UCepService.Json, Vcl.Dialogs, UUtils,
  uValidation.Interfaces, UValidation, UConfig, UConfig.Interfaces,
  UConnection, UConnection.Interfaces, UCEPPersistencia,
  UCEPPersistencia.Interfaces;


procedure Register;
begin
     RegisterComponents('Samples', [TCEPManager]);
end;

procedure TCEPManager.Execute(ACEP: string);
var LCepService       : ICepService;
    LCEP              : ICEP;
    LBuscarApi        : Boolean;
    LValidationCep    : IValidationCep;
    LRetornoValidacao : TRetornoValidacao;
    LCEPController    : ICEPController;
begin
     LValidationCep := TValidationCep.Create(ACEP);

     LRetornoValidacao :=  LValidationCep.ValidaCep;

     if not(LRetornoValidacao.OK) then
     begin
          Showmessage(LRetornoValidacao.Mensagem);
          Exit;
     end;

     LBuscarApi := True;
     try
        LCEPController := CEPController;
        // Verifica se o CEP existe no banco de dados
        LCEP := LCEPController.GetCEP(aCEP);

        if Assigned(LCEP) then
        begin
             LBuscarApi := MessageDlg('Registro Encontrado Internamente '
                                     +SlineBreak+ 'Deseja Buscar Online e Atualizar'+
                                     ' a Base de Dados ?'
                                     ,mtConfirmation,
                                     [mbYes, mbNo],
                                     0) = 6;
        end;

        if LBuscarApi then
        begin
             case FormatoRetorno of
                 FRXML  : LCepService := TCepServiceXml.Create;
                 FRJSON : LCepService := TCepServiceJson.Create;
             end;

             LCEP := LCepService.ConsultarCep(aCEP);

             // Se encontrou na API salva no banco
             if Assigned(LCEP) then
             begin
                  LCEPController.CreateCEP(LCEP.Cep,
                                           LCEP.Logradouro,
                                           LCEP.Complemento,
                                           LCEP.Bairro,
                                           LCEP.Localidade,
                                           LCEP.UF);
             end;

             if Assigned(LCEP) then
             begin
                  Showmessage('CEP '+ACEP + ' Encontrado Com Sucesso!');
             end
             else
             begin
                  Showmessage('O CEP '+ACEP + ' Não Foi Encontrado.');
             end;
        end;

        CEPToDataSet(LCEP);

     except
       on E: ECEPException do
       begin
            ShowMessage(E.Message);
       end
       else
       begin
            ShowMessage('Erro ao busca por CEP');
       end;
     end;
end;

procedure TCEPManager.CEPToDataSet(ACEP: ICEP);
begin
     if Assigned(ACEP) and Assigned(DataSource) and
                           Assigned(DataSource.DataSet) then
     begin
          TUtils.InsereMascara(ACEP);

          with DataSource.DataSet do
          begin
               if Locate('CEP',ACEP.Cep,[]) then
               begin
                    Edit;
               end
               else
               begin
                    Append;
               end;

               FieldByName('CEP').AsString         := ACEP.Cep;
               FieldByName('LOGRADOURO').AsString  := ACEP.Logradouro;
               FieldByName('COMPLEMENTO').AsString := ACEP.Complemento;
               FieldByName('BAIRRO').AsString      := ACEP.Bairro;
               FieldByName('LOCALIDADE').AsString  := ACEP.Localidade;
               FieldByName('UF').AsString          := ACEP.UF;
               Post;
          end;
     end;
end;

procedure TCEPManager.CarregaTodosRegistros;
 var LCEPs : TArray<ICEP>;
  LCEPController: ICEPController;
begin
     try
        LCEPController := CEPController;
        LCEPs := LCEPController.GetAllCEPs;

        CEPToDataSet(LCEPs);

     except
       on E: ECEPException do
       begin
            ShowMessage(E.Message);
       end
       else
       begin
            ShowMessage('Erro Ao Carregar os Registros.');
       end;
     end;
end;

function TCEPManager.CEPController: ICEPController;
var LConfig           : IConfig;
    LConnection       : IConnection;
    LCEPPersistencia  : ICEPPersistencia;
begin
     try
        LConfig          := TConfig.create;
        LConnection      := TConnection.Create(Self,LConfig);
        LCEPPersistencia := TCEPPersistencia.Create(LConnection);
        Result           := TCEPController.create(LCEPPersistencia);
     except on E: Exception do
          ShowMessage(E.Message);
     end;
end;

procedure TCEPManager.CEPToDataSet(ACEP: TArray<ICEP>);
var
  I: Integer;
begin
     for I := Low(ACEP) to High(ACEP) do
     begin
          CEPToDataSet(ACEP[i]);
     end;
end;

procedure TCEPManager.Execute(AEstado, ACidade, ALogradouro: String);
var LCepService      : ICepService;
    LCEPs            : TArray<ICEP>;
    I                : Integer;
    LTotalRegistros  : Integer;
    LBuscarApi       : Boolean;
    LValidationCep   : IValidationCEP;
    LRetornoValidacao: TRetornoValidacao;
    LCEPController   : ICEPController;
begin
     LValidationCep := TValidationCep.Create(AEstado, ACidade, ALogradouro);

     LRetornoValidacao :=  LValidationCep.ValidaEnderecoCompleto;

     if not(LRetornoValidacao.OK) then
     begin
          Showmessage(LRetornoValidacao.Mensagem);
          Exit;
     end;

     LBuscarApi := True;
     try
        LCEPController := CEPController;
        // Verifica se o CEP existe no banco de dados
        LCEPs := LCEPController.GetCEPs(AEstado, ACidade, ALogradouro);

        LTotalRegistros := Length(LCEPs);

        if LTotalRegistros > 0 then
        begin
             LBuscarApi := MessageDlg('Internamente foi encontrado '
                                     +LTotalRegistros.ToString + ' Registro(s). '
                                     +SlineBreak+ 'Deseja buscar online ?'
                                     ,mtConfirmation,
                                     [mbYes, mbNo],
                                     0) = 6// 6  = mbYes;
        end;

        // busca na API
        if LBuscarApi then
        begin
             case FormatoRetorno of
                 FRXML  : LCepService := TCepServiceXml.Create;
                 FRJSON : LCepService := TCepServiceJson.Create;
             end;

             LCEPs := LCepService.ConsultarCep(AEstado, ACidade, ALogradouro);

             // Se encontrou na API salva no banco
             if Assigned(LCEPs) then
             begin
                  for I := Low(LCEPs) to High(LCEPs) do
                  begin
                       LCEPController.CreateCEP(LCEPs[i].Cep,
                                                LCEPs[i].Logradouro,
                                                LCEPs[i].Complemento,
                                                LCEPs[i].Bairro,
                                                LCEPs[i].Localidade,
                                                LCEPs[i].UF);
                  end;
             end;

             if Assigned(LCEPs) then
             begin
                  Showmessage(IntToStr(Length(LCEPs))+' CEP(s) Encontrado(s) '+
                              'Com Sucesso!');
             end
             else
             begin
                  Showmessage('Nenhum CEP Encontrado.');
             end;
        end;

        CEPToDataSet(LCEPs);

     except
       on E: ECEPException do
       begin
            ShowMessage(E.Message);
       end
       else
       begin
            ShowMessage('Erro ao busca por Endereço Completo');
       end;
     end;
end;

procedure TCEPManager.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
     inherited;
     if (Operation = opRemove) and (AComponent = DataSource) then
     begin
          DataSource := nil;
     end;
end;

procedure TCEPManager.SetDataSource(const Value: TDataSource);
begin
     FDataSource := Value;
end;

procedure TCEPManager.SetFormatoRetorno(const Value: TFormatoRetorno);
begin
     FFormatoRetorno := Value;
end;

end.
