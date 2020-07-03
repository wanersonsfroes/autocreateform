unit uFrameDados;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Forms, Controls, ZDataset, LCLType, StdCtrls, DBCtrls,
  ExtCtrls, Dialogs;

type

  { TFrameDados }

  TFrameDados = class(TFrame)
    btnFechar: TButton;
    btnSalvar: TButton;
    btnCancelar: TButton;
    dtsDados: TDataSource;
    Panel1: TPanel;
  procedure btnFecharClick(Sender: TObject);
  procedure btnSalvarClick(Sender: TObject);
  procedure CreateComponents(DataSet: TZQuery);
  procedure dtsDadosStateChange(Sender: TObject);
  private
    ExternalDataSet: TZQuery;
  public
    constructor Create(AOwner: TComponent; DataSet: TZQuery);
    destructor Destroy; override;
  end;

implementation


{$R *.lfm}

{ TFrameDados }

procedure TFrameDados.CreateComponents(DataSet: TZQuery);
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

procedure TFrameDados.btnFecharClick(Sender: TObject);
var
  i: Integer;
begin
  if(dtsDados.DataSet.State in [dsEdit, dsInsert])then begin
    if(Application.MessageBox(PChar('Sair sem salvar?'), PChar(Application.Title), MB_ICONQUESTION+MB_YESNO+MB_DEFBUTTON1)=IDYES)then begin
      dtsDados.DataSet.Cancel;
      FreeAndNil(Self);
    end
  end
  else begin
    Application.ReleaseComponent(Self);
    FreeAndNil(Self);
  end;
//
//  for i:=0 to ComponentCount-1 do begin
//    if(Components[i] is TLabel)then
//      (Components[i] as TLabel).Free;
//    if(Components[i] is TDBEdit)then
//      (Components[i] as TDBEdit).Free;
//  end;
//
//  dtsDados.DataSet:=nil;
end;

procedure TFrameDados.btnSalvarClick(Sender: TObject);
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

procedure TFrameDados.dtsDadosStateChange(Sender: TObject);
var
  PodeSalvar,
  PodeCancelar: Boolean;
begin
  PodeSalvar:=(Sender as TDataSource).DataSet.State in [dsEdit, dsInsert];
  PodeCancelar:=(Sender as TDataSource).DataSet.State=dsEdit;

  btnSalvar.Enabled:=PodeSalvar;
  btnCancelar.Enabled:=PodeCancelar;
end;

constructor TFrameDados.Create(AOwner: TComponent; DataSet: TZQuery);
begin
  inherited Create(AOwner);

  ExternalDataSet:=DataSet;
  dtsDados.DataSet:=ExternalDataSet;
  CreateComponents(ExternalDataSet);
end;

destructor TFrameDados.Destroy;
begin
  inherited Destroy;
end;

end.

