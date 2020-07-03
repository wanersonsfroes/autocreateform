unit uFormFoto;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  uDMPrincipal;

type

  { TFormFotos }

  TFormFotos = class(TForm)
    dtsDados: TDataSource;
    Image1: TImage;
    Panel1: TPanel;
    procedure dtsDadosDataChange(Sender: TObject; Field: TField);
  private

  public

  end;

var
  FormFotos: TFormFotos;

implementation

{$R *.lfm}

{ TFormFotos }

procedure TFormFotos.dtsDadosDataChange(Sender: TObject; Field: TField);
begin
  if(dtsDados.DataSet.FieldByName('foto').IsNull)then
    Image1.Picture:=nil;
end;

end.

