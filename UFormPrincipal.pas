unit UFormPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
   System.Classes, Vcl.Graphics,  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
   Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask,
  System.Notification, Vcl.ComCtrls, UCEPComponentManager, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls ;

type
  TFormPrincipalCep = class(TForm)
    PanelPrincipal: TPanel;
    ButtonConsultar: TButton;
    GroupBoxConsulta: TGroupBox;
    GroupBoxPrincipal: TGroupBox;
    GroupBoxRetornoConsulta: TGroupBox;
    LabelCEP: TLabel;
    LabelUF: TLabel;
    LabelBairro: TLabel;
    LabelLocalidade: TLabel;
    LabelLogradouro: TLabel;
    RadioGroupFormatoRetorno: TRadioGroup;
    CEPManager: TCEPManager;
    FDMemTableCEP: TFDMemTable;
    DBGridNavegacao: TDBGrid;
    DataSourceCEP: TDataSource;
    GroupBox1: TGroupBox;
    RadioGroupConsultaPor: TRadioGroup;
    GroupBoxCamposConsulta: TGroupBox;
    MaskEditCEPConsulta: TMaskEdit;
    EditUFConsulta: TEdit;
    LabelCEPConsulta: TLabel;
    LabelUFConsulta: TLabel;
    LabelLocalidadeConsulta: TLabel;
    LabelLogradouroConsulta: TLabel;
    EditLocalidadeConsulta: TEdit;
    EditLogradouroConsulta: TEdit;
    DBEditCEP: TDBEdit;
    DBEditUF: TDBEdit;
    DBEditBairro: TDBEdit;
    DBEditLocalidade: TDBEdit;
    DBEditLogradouro: TDBEdit;
    procedure ButtonConsultarClick(Sender: TObject);
    procedure RadioGroupConsultaPorClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
      procedure Consulta(ACEP :String);overload;
      procedure Consulta(AEstado,ALocalidade,ALogradouro :String);overload;
      procedure PreparaCamposPesquisa;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipalCep: TFormPrincipalCep;

implementation
  uses
   System.IniFiles,
   System.IOUtils,
   UCEP.Types;

{$R *.dfm}

procedure TFormPrincipalCep.ButtonConsultarClick(Sender: TObject);
begin
    case RadioGroupConsultaPor.ItemIndex of
         0 : Consulta(MaskEditCEPConsulta.Text);
         1 : Consulta(EditUFConsulta.Text,
                      EditLocalidadeConsulta.Text,
                      EditLogradouroConsulta.Text);
     end;
end;

procedure TFormPrincipalCep.Consulta(aCEP: String);
begin
     case RadioGroupFormatoRetorno.ItemIndex of
         0 : CEPManager.FormatoRetorno := TFormatoRetorno.FRXML;
         1 : CEPManager.FormatoRetorno := TFormatoRetorno.FRJson;
     end;

     CEPManager.Execute(aCEP);
end;


procedure TFormPrincipalCep.Consulta(AEstado, ALocalidade, ALogradouro: String);
begin
     case RadioGroupFormatoRetorno.ItemIndex of
         0 : CEPManager.FormatoRetorno := TFormatoRetorno.FRXML;
         1 : CEPManager.FormatoRetorno := TFormatoRetorno.FRJson;
     end;

     CEPManager.Execute(AEstado,ALocalidade,ALogradouro);
end;

procedure TFormPrincipalCep.FormCreate(Sender: TObject);
begin
     PreparaCamposPesquisa;
     CEPManager.CarregaTodosRegistros;
end;

procedure TFormPrincipalCep.PreparaCamposPesquisa;
     procedure PreparaCampos(APorCEP: Boolean);
     begin
          MaskEditCEPConsulta.Enabled := APorCEP;

          EditUFConsulta.Enabled := not(APorCEP);
          EditLocalidadeConsulta.Enabled := not(APorCEP);
          EditLogradouroConsulta.Enabled := not(APorCEP);

          if APorCEP then
          begin
               EditUFConsulta.Text :='';
               EditLocalidadeConsulta.Text :='';
               EditLogradouroConsulta.Text :='';
          end
          else
          begin
               MaskEditCEPConsulta.Text :='';
          end;
     end;
begin
     case RadioGroupConsultaPor.ItemIndex of
       0 : PreparaCampos(True);
       1 : PreparaCampos(False);
     end;
end;

procedure TFormPrincipalCep.RadioGroupConsultaPorClick(Sender: TObject);
begin
     PreparaCamposPesquisa;
end;

end.
