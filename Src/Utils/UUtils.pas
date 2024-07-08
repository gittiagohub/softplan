unit UUtils;

interface

uses
  UCEP.Interfaces;
   type
   TUtils = class
   private
    { private declarations }
   protected
    { protected declarations }
   public
    { public declarations }
    class function RetiraMascara(aCep: String) : string ;overload;
    class procedure RetiraMascara(var aCep: ICEP);overload;
    class procedure RetiraMascara(var aCep :TArray<ICEP>);overload;

    class function InsereMascara(aCep: String):string ;overload;
    class procedure InsereMascara(var aCep: ICEP);overload;
    class procedure InsereMascara(var aCep :TArray<ICEP>);overload;

   published
    { published declarations }
   end;

implementation

uses
  System.SysUtils;

{ TUtils }

class function TUtils.RetiraMascara(aCep: String): string;
begin
     // A máscara contém apenas "-"
     Result := StringReplace(aCep,'-','',[]);
end;

class procedure TUtils.RetiraMascara(var aCep: ICEP);
begin
     aCep.Cep := RetiraMascara(aCep.Cep);
end;

class function TUtils.InsereMascara(aCep: String) :String;
begin
     if not(aCep.Contains('-')) then
     begin
          Insert('-',aCep,6);
     end;

     Result := aCep;
end;

class procedure TUtils.InsereMascara(var aCep: ICEP);
begin
     aCep.Cep := InsereMascara(aCep.Cep);
end;

class procedure TUtils.InsereMascara(var aCep: TArray<ICEP>);
var
  I: Integer;
begin
     for I := Low(aCep) to High(aCep) do
     begin
          InsereMascara(aCep[i]);
     end;
end;

class procedure TUtils.RetiraMascara(var aCep: TArray<ICEP>);
var
  I: Integer;
begin
     for I := Low(aCep) to High(aCep) do
     begin
          RetiraMascara(aCep[i]);
     end;
end;

end.
