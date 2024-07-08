unit UCEP.Types;

interface

uses
 System.SysUtils;

type

 TRetornoCep = record
    StatusCode: Integer;
    Content: String;
 end;

 TRetornoValidacao = record
    OK: Boolean;
    Mensagem: String;
 end;

 TFormatoRetorno = (FRXML, FRJson);

 ECEPException = class(Exception)
 private
  { private declarations }
 protected
  { protected declarations }
 public
  { public declarations }
  constructor Create(const Msg: string); reintroduce; overload;
 published
  { published declarations }
 end;

implementation

{ ECEPException }

constructor ECEPException.Create(const Msg: string);
begin
     inherited Create(Msg);
end;

end.
