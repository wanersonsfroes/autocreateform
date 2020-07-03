unit uFrameConsultas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Forms, Controls, ExtCtrls, DBGrids, ComCtrls, StdCtrls,
  ZDataset, LCLType, Dialogs, uFrameDados, uformdados;

type

  { TFrameConsultas }

  TFrameConsultas = class(TFrame)
    btnEditar: TButton;
    dtsDados: TDataSource;
    DBGrid1: TDBGrid;
    edtLocalizar: TLabeledEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    StatusBar1: TStatusBar;
    procedure btnEditarClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure dtsDadosDataChange(Sender: TObject; Field: TField);
    procedure edtLocalizarKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    ExternalDataSet: TZQuery;
  public
    constructor Create(AOwner: TComponent; DataSet: TZQuery; aFieldList: array of TField);
    destructor Destroy; override;
  end;

implementation

uses
  uVarFrames;

{$R *.lfm}

{ TFrameConsultas }

procedure TFrameConsultas.edtLocalizarKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  S: String;
begin
  if(Key=VK_RETURN)then begin
    S:=edtLocalizar.Text+'%';
    ExternalDataSet.Close;
    ExternalDataSet.ParamByName(ExternalDataSet.Params.Items[0].DisplayName).AsString:=S;
    ExternalDataSet.Open;
    if(ExternalDataSet.RecordCount=0)then
      Application.MessageBox(PChar('Sem registros'), PChar(Application.Title), MB_ICONINFORMATION);
  end;
end;

procedure TFrameConsultas.dtsDadosDataChange(Sender: TObject; Field: TField);
begin
  btnEditar.Enabled:=dtsDados.DataSet.RecordCount>0;
end;

procedure TFrameConsultas.btnEditarClick(Sender: TObject);
begin
  try
    FormDados:=TFormDados.Create(Self, ExternalDataSet);
    FormDados.ShowModal;
  finally
    FreeAndNil(FormDados);
  end;
end;

procedure TFrameConsultas.DBGrid1DblClick(Sender: TObject);
begin
  if(dtsDados.DataSet.RecordCount>0)then
    try
      FormDados:=TFormDados.Create(Self, ExternalDataSet);
      FormDados.ShowModal;
    finally
      FreeAndNil(FormDados);
    end;
end;

constructor TFrameConsultas.Create(AOwner: TComponent; DataSet: TZQuery; aFieldList: array of TField);
var
  i,
  Tamanho: Integer;
begin
  inherited Create(AOwner);

  DBGrid1.Columns.Clear;
  for i:=Low(aFieldList) to High(aFieldList) do begin
    Tamanho:=aFieldList[i].Size;
    if(Tamanho<20)then
      Tamanho:=Length(aFieldList[i].DisplayLabel)*10
    else
      Tamanho:=Tamanho*3;

    DBGrid1.Columns.Add;
    DBGrid1.Columns[i].FieldName:=aFieldList[i].FieldName;
    DBGrid1.Columns[i].Title.Caption:=aFieldList[i].DisplayLabel;
    DBGrid1.Columns[i].Width:=Tamanho;
  end;

  ExternalDataSet:=DataSet;
  dtsDados.DataSet:=ExternalDataSet;
  dtsDados.DataSet.Open;
end;

destructor TFrameConsultas.Destroy;
begin
  inherited Destroy;
end;

end.

