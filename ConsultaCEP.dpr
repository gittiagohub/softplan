program ConsultaCEP;

uses
  Vcl.Forms,
  UFormPrincipal in 'UFormPrincipal.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Sistema de Consulta de CEP.';
  ReportMemoryLeaksOnShutdown :=true;
  Application.CreateForm(TFormPrincipalCep, FormPrincipalCep);
  Application.Run;
end.
