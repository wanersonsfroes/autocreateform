unit uDados;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ZDataset, LCLType, DBCtrls;

type

  { TFormDados }

  TFormDados = class(TForm)
    btnCancelar: TButton;
    btnFechar: TButton;
    btnSalvar: TButton;
    dtsDados: TDataSource;
    Panel1: TPanel;
    procedure CreateComponents(DataSet: TZQuery);
    procedure btnFecharClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure dtsDadosStateChange(Sender: TObject);
    procedure FormCreate(Sender: TObject; DataSet: TZQuery);
  private
    ExternalDataSet: TZQuery;
  public
    constructor Create(AOwner: TComponent; DataSet: TZQuery);
  end;

var
  FormDados: TFormDados;

implementation

{$R *.lfm}

{ TFormDados }

procedure TFormDados.dtsDadosStateChange(Sender: TObject);
var
  PodeSalvar,
  PodeCancelar: Boolean;
begin
  PodeSalvar:=(Sender as TDataSource).DataSet.State in [dsEdit, dsInsert];
  PodeCancelar:=(Sender as TDataSource).DataSet.State=dsEdit;

  btnSalvar.Enabled:=PodeSalvar;
  btnCancelar.Enabled:=PodeCancelar;
end;

procedure TFormDados.btnSalvarClick(Sender: TObject);
begin
  try
    ExternalDataSet.Post;
  except
    on  E: Exception do begin
      ExternalDataSet.Cancel;
      Application.MessageBox(PChar(E.Message), PChar(Application.Title), MB_ICONERROR);
    end;
  end;
end;

procedure TFormDados.CreateComponents(DataSet: TZQuery);
var
  i: Integer;
  Labels: array of TLabel;
  DBEdits: array of TDBEdit;
begin
  SetLength(Labels, DataSet.FieldCount);
  SetLength(DBEdits, DataSet.FieldCount);

  for i:=0 to DataSet.FieldCount-1 do begin
    Labels[i]:=TLabel.Create(Self);
    Labels[i].Parent:=Self;
    Labels[i].Caption:=DataSet.Fields.Fields[i].DisplayName;

    DBEdits[i]:=TDBEdit.Create(Self);
    DBEdits[i].Parent:=Self;
    DBEdits[i].DataField:=DataSet.Fields.Fields[i].FieldName;
    DBEdits[i].DataSource:=dtsDados;

    if(i=0)then begin
      Labels[i].Top:=70;
      Labels[i].Left:=30;
      DBEdits[i].Top:=90;
      DBEdits[i].Left:=30;;
    end
    else begin
      Labels[i].Top:=DBEdits[i-1].Top+30;
      Labels[i].Left:=30;
      DBEdits[i].Top:=Labels[i].Top+18;
      DBEdits[i].Left:=30;
    end;
    DBEdits[i].Width:=DataSet.Fields.Fields[i].DisplayWidth*10;
  end;
end;

procedure TFormDados.btnFecharClick(Sender: TObject);
begin
  if(dtsDados.DataSet.State in [dsEdit, dsInsert])then begin
    if(Application.MessageBox(PChar('Sair sem salvar?'), PChar(Application.Title), MB_ICONQUESTION+MB_YESNO+MB_DEFBUTTON1)=IDYES)then begin
      dtsDados.DataSet.Cancel;
      Close
    end
  end
  else begin
    Close
  end;
end;


constructor TFormDados.Create(AOwner: TComponent; DataSet: TZQuery);
begin
  inherited Create(AOwner);
  ExternalDataSet:=DataSet;
  dtsDados.DataSet:=ExternalDataSet;
  CreateComponents(ExternalDataSet);
end;

end.

