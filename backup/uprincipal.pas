unit uPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, uDMPrincipal,
  uVarFrames, uFrameConsultas, uFrameDados, db;

type

  { TFormPrincipal }

  TFormPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem3: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
  private

  public

  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.lfm}

{ TFormPrincipal }

procedure TFormPrincipal.FormCreate(Sender: TObject);
begin
  dm_principal:=Tdm_principal.Create(Self);
end;

procedure TFormPrincipal.MenuItem1Click(Sender: TObject);
var
  aFields: array of TField;
begin
//
//  Dados.Close;
//  Dados.SQL.Clear;
//  Dados.SQL.Add('SELECT * FROM fornecedores WHERE fornecedor LIKE :fornecedor ORDER BY fornecedor');
//  Dados.Open;

  if(Assigned(FrameConsultas))then
    FreeAndNil(FrameConsultas);

  SetLength(aFields, 3);
  aFields[0]:=Dados.Fields.Fields[3];
  aFields[1]:=Dados.Fields.Fields[4];
  aFields[2]:=Dados.Fields.Fields[5];
  aFields[4]:=Dados.Fields.Fields[6];
  FrameConsultas:=TFrameConsultas.Create(FormPrincipal, Dados, aFields);
  FrameConsultas.Parent:=FormPrincipal;
end;

procedure TFormPrincipal.MenuItem3Click(Sender: TObject);
begin
  Close
end;

end.

