unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, DBCtrls,
  StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    LabelFieldTitle: TLabel;
    LabelFieldTitle1: TLabel;
    LabelFieldTitle2: TLabel;
    LabelFieldTitle3: TLabel;
    LabelFieldTitle4: TLabel;
    LabelFieldTitle5: TLabel;
    LabelFieldTitle6: TLabel;
    Panel1: TPanel;
    PanelField: TPanel;
    PanelField1: TPanel;
    PanelField2: TPanel;
    PanelField3: TPanel;
    PanelField4: TPanel;
    PanelField5: TPanel;
    PanelField6: TPanel;
    PanelGroupFields: TPanel;
    PanelGroupFields1: TPanel;
    PanelMainField: TPanel;
    PanelMainField1: TPanel;
    PanelMainField2: TPanel;
    PanelMainField3: TPanel;
    PanelMainField4: TPanel;
    PanelMainField5: TPanel;
    PanelMainField6: TPanel;
    ShapeField: TShape;
    ShapeField1: TShape;
    ShapeField2: TShape;
    ShapeField3: TShape;
    ShapeField4: TShape;
    ShapeField5: TShape;
    ShapeField6: TShape;
    procedure FormResize(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormResize(Sender: TObject);
begin
  Panel1.Width:=Self.Width-100;
end;

end.

