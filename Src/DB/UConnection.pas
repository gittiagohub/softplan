unit UConnection;

interface
uses
     FireDAC.Comp.Client,FireDAC.Phys.MySQL,System.Classes,uConfig,
     FireDAC.Stan.def,FireDAC.Phys.MySQLWrapper, UConfig.Interfaces,
     FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Comp.UI,
     UConnection.Interfaces;
type
   TConnection = class(TFDConnection,IConnection)
   private
      FDPhysMySQLDriverLink: TFDPhysMySQLDriverLink;
      FDGUIxWaitCursor: TFDGUIxWaitCursor;

      procedure Setup(aConfiguracao : IConfig);
      { private declarations }
   protected
      { protected declarations }
   public
      { public declarations }
      constructor Create(AOwner: TComponent; aConfiguracao : IConfig); reintroduce;
      function ActiveTransaction : Boolean;
      destructor Destroy; override;


   published
      { published declarations }
   end;


implementation

uses
  System.SysUtils, Vcl.Dialogs, UCEP.Types;

{ TConnection }
constructor TConnection.Create(AOwner: TComponent; aConfiguracao: IConfig);
begin
     inherited Create(AOwner);
     Setup(aConfiguracao);
end;

destructor TConnection.Destroy;
begin
     FreeAndNil(FDPhysMySQLDriverLink);
     FreeAndNil(FDGUIxWaitCursor);
     inherited;
end;

function TConnection.ActiveTransaction: Boolean;
begin
     Result := Self.InTransaction;
end;

procedure TConnection.Setup(aConfiguracao : IConfig);
var
  xDirDLL: string;
begin
     try
        xDirDLL := ExtractFilePath(ParamStr(0))+aConfiguracao.DBDLL;

        Self.Params.DriverID := 'mysql';
        Self.Params.add('Server=' +aConfiguracao.DBHost);
        Self.Params.add('Port=' +IntToStr(aConfiguracao.DBPort));
        Self.Params.Database := aConfiguracao.DB;
        Self.Params.UserName := aConfiguracao.DBUserName;
        Self.Params.Password := aConfiguracao.DBPassword;

        Self.ResourceOptions.Persistent := True;
        Self.UpdateOptions.AutoCommitUpdates :=True;

        FDPhysMySQLDriverLink := TFDPhysMySQLDriverLink.Create(Self);
        FDPhysMySQLDriverLink.VendorLib := xDirDLL;

        try
           Self.Connected := True;
        except
            raise ECEPException.Create('Para Usar o Sistema '+
                                       'Defina os parâmetros de conexão com o'+
                                       ' banco de dados em '+
                                       ExtractFilePath(ParamStr(0))+'Config.ini'+
                                       slinebreak+'Falhou ao Tentar Conectar No'+
                                       ' banco '+aConfiguracao.DB.QuotedString);
        end;
     except
           on  E : ECEPException  do
           begin
                Raise
           end;
           on  E : Exception  do
           begin
                raise ECEPException.Create('Erro fazer conexão com o banco de dados ' +
                                     aConfiguracao.DB +Slinebreak+E.Message);
           end;
     end;
end;

end.
