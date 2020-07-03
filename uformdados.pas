unit uformdados;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ZDataset, LCLType, DBCtrls, uDMPrincipal, UDF, DBDateTimePicker,
  typinfo;

type

  { TFormDados }

  TFormDados = class(TForm)
    btnCancelar: TButton;
    btnFechar: TButton;
    btnSalvar: TButton;
    dtsDados: TDataSource;
    Image1: TImage;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    ScrollBox1: TScrollBox;
    function IsEnumResultZ(sqlInstruction, FieldName: String): String;
    procedure CreateComponentsZ(DataSet: TZQuery);
    procedure btnFecharClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure dtsDadosDataChange(Sender: TObject; Field: TField);
    procedure dtsDadosStateChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormKeyPress(Sender: TObject; var Key: char);
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
  if((Sender as TDataSource).State<>dsInactive)then begin
    PodeSalvar:=(Sender as TDataSource).DataSet.State in [dsEdit, dsInsert];
    PodeCancelar:=(Sender as TDataSource).DataSet.State=dsEdit;

    btnSalvar.Enabled:=PodeSalvar;
    btnCancelar.Enabled:=PodeCancelar;
  end;
end;

procedure TFormDados.FormClose(Sender: TObject; var CloseAction: TCloseAction);
//var
//  i: Integer;
begin
  //for i:=0 to ComponentCount-1 do
  //  Components[i].Free;
  CloseAction:=caFree;
end;

procedure TFormDados.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  if(dtsDados.DataSet.State in [dsEdit, dsInsert])then begin
    if(Application.MessageBox(PChar('Sair sem salr as alterações?'), PChar(Application.Title), MB_ICONQUESTION+MB_YESNO+MB_DEFBUTTON1)=IDYES)then
      dtsDados.DataSet.Cancel;
  end;
end;

procedure TFormDados.FormKeyPress(Sender: TObject; var Key: char);
begin
  if(Key=#27)then begin
    Key:=#0;
    Close
  end;
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

procedure TFormDados.dtsDadosDataChange(Sender: TObject; Field: TField);
var
  i: Integer;
begin
  //for i:=0 to (Sender as TDataSource).DataSet.Fields.Count-1 do
  //  if((Sender as TDataSource).DataSet.Fields.Fields[i].DataType=ftBlob)then begin
  //    if((Sender as TDataSource).DataSet.FieldByName((Sender as TDataSource).DataSet.Fields.Fields[i].FieldName).IsNull)then
  //      if(Assigned(FormFotos))then
  //        FreeAndNil(FormFotos)
  //    else begin
  //      FormFotos:=TFormFotos.Create(Self);
  //      FormFotos.ShowOnTop;
  //      Break;
  //    end;
  //  end;
end;

function TFormDados.IsEnumResultZ(sqlInstruction, FieldName: String): String;
var
  Table: String;
  n: Integer;
  temp: TZQuery;
begin
  Result:=EmptyStr;
  n:=Pos('FROM', sqlInstruction)+3;
  Delete(sqlInstruction, 1, n);
  n:=Pos(' ', Trim(sqlInstruction));
  Table:=Trim(Copy(sqlInstruction, 1, n));

  temp:=TZQuery.Create(nil);
  temp.Connection:=dm_principal.ZConnection1;
  temp.SQL.Clear;
  temp.SQL.Add('SHOW COLUMNS FROM '+Table+' WHERE FIELD = '+QuotedStr(FieldName));
  temp.Open;
  Result:=temp.FieldByName('type').AsString;
//ShowMessage(Result);
  temp.Close;
  temp.Free;
end;

procedure TFormDados.CreateComponentsZ(DataSet: TZQuery);
const
  nEsquerda = 20;
var
  i, x,
  nTab,
  nPanels,
  nGroupPanels,

  nTop,
  nTopoLegenda,
  nTopoComponente,
  nTamanho: Integer;

  EnumResult: String;
  sEnumList: TStringList;
  S: String;

  Panels,
  GroupPanels       : TPanel;
  Labels            : TLabel;
  DBEdits           : TDBEdit;
  DBDateTimePickers : TDBDateTimePicker;
  DBMemos           : TDBMemo;
  DBCHeckBoxs       : TDBCheckBox;
  DBLookupComboBox  : TDBLookupComboBox;
  DBComboBox        : TDBComboBox;

  Simples,
  Grupo: Boolean;
begin

  i:=0;

  nPanels:=0;
  nGroupPanels:=0;

  nPanels:=0;
  nTopoLegenda:=0;
  nTopoComponente:=0;
  nTamanho:=0;

  nTop:=0;

  for i:=DataSet.FieldCount-1 downto 0 do begin
    if(DataSet.Fields.Fields[i].Visible=true)then begin
      nTopoLegenda:=5; //nTopoComponente+30;
      nTopoComponente:=nTopoLegenda+16;  //nTopoLegenda+16;

      nTab:=DataSet.Fields.Fields[i].Index;
      if(DataSet.Fields.Fields[i].Tag=0)then begin
        Panels:=TPanel.Create(ScrollBox1);
        Panels.Parent:=ScrollBox1;
        Panels.TabOrder:=DataSet.Fields.Fields[i].Index;
        Panels.Height:=50;
        Panels.Name:='Panel'+IntToStr(i+1);
        Panels.Tag:=DataSet.Fields.Fields[i].Tag;
        Panels.TabOrder:=nGroupPanels;
        Panels.Align:=alTop;
        Panels.Top:=nTop;
        Panels.BevelOuter:=bvNone;
        Panels.BevelWidth:=5;
        Panels.BorderSpacing.Around:=5;
        Panels.Caption:=EmptyStr;
        Panels.AutoSize:=true;
        Panels.TabOrder:=nTab;

        Labels:=TLabel.Create(Panels);
        Labels.Parent:=Panels;
      end
      else begin
        if(DataSet.Fields.Fields[i].Tag<>nGroupPanels)then begin
          Panels:=TPanel.Create(ScrollBox1);
          Panels.Parent:=ScrollBox1;
          Panels.Height:=50;
          Panels.Name:='Panel'+IntToStr(i+1);
          Panels.Tag:=DataSet.Fields.Fields[i].Tag;
          Panels.TabOrder:=nGroupPanels;
          Panels.Align:=alTop;
          Panels.Top:=nTop;
          Panels.TabOrder:=DataSet.Fields.Fields[i].Index;
          Panels.BevelOuter:=bvNone;
          Panels.BevelWidth:=5;
          Panels.BorderSpacing.Around:=5;
          Panels.Caption:=EmptyStr;
          Panels.AutoSize:=true;
          Panels.TabOrder:=nTab;
          nGroupPanels:=DataSet.Fields.Fields[i].Tag;
        end;
        if(DataSet.Fields.Fields[i].Tag=nGroupPanels)then begin
          GroupPanels:=TPanel.Create(Panels);
          GroupPanels.Parent:=Panels;
          GroupPanels.Caption:=EmptyStr;
          GroupPanels.AutoSize:=true;
          GroupPanels.BevelOuter:=bvNone;
          GroupPanels.BorderSpacing.Around:=5;

          GroupPanels.Height:=50;
          GroupPanels.Name:='Panel'+IntToStr(i+1);
          GroupPanels.Tag:=DataSet.Fields.Fields[i].Tag;
          GroupPanels.TabOrder:=DataSet.Fields.Fields[i].Index;
          GroupPanels.Align:=alLeft;
          GroupPanels.Caption:=EmptyStr;
          GroupPanels.TabOrder:=nTab;

          Labels:=TLabel.Create(GroupPanels);
          Labels.Parent:=GroupPanels;
        end;
      end;
      Labels.Name:='Label'+IntToStr(i+1);
      Labels.Caption:=DataSet.Fields.Fields[i].DisplayName;
      Labels.Top:=nTopoLegenda;
      Labels.Left:=nEsquerda;

      if(DataSet.Fields.Fields[i].DataType in [ftInteger, ftString]) and (DataSet.Fields.Fields[i].FieldKind=fkData)then begin
        EnumResult:=IsEnumResultZ(DataSet.SQL.Text,  DataSet.Fields.Fields[i].FieldName);
        if(Pos('enum', EnumResult)<>0)then begin
          Delete(EnumResult, 1, 4);
          nTamanho:=DataSet.Fields.Fields[i].DisplayWidth*10;
          if(DataSet.Fields.Fields[i].Tag<>0)then begin
            if(DataSet.Fields.Fields[i].Tag=nGroupPanels)then begin
              DBComboBox:=TDBComboBox.Create(GroupPanels);
              DBComboBox.Parent:=GroupPanels;
            end
          end
          else begin
            DBComboBox:=TDBComboBox.Create(Panels);
            DBComboBox.Parent:=Panels;
          end;
          S:=StringReplace(EnumResult, '(', '|', [rfReplaceAll]);
          S:=StringReplace(S, '''', '', [rfReplaceAll]);
          S:=StringReplace(S, ')', '|', [rfReplaceAll]);
          S:=StringReplace(S, ',', '| |', [rfReplaceAll]);
          sEnumList:=TStringList.Create;
          sEnumList.Delimiter:=' ';
          sEnumList.QuoteChar:='|';
          sEnumList.DelimitedText:=S;
          for x:=0 to sEnumList.Count-1 do
            DBComboBox.Items.Add(sEnumList[x]);
          DBComboBox.TabOrder:=nTab;
          DBComboBox.Name:='DBComboBox'+IntToStr(i);
          DBComboBox.DataField:=DataSet.Fields.Fields[i].FieldName;
          DBComboBox.DataSource:=dtsDados;
          DBComboBox.Top:=nTopoComponente;
          DBComboBox.Left:=nEsquerda;
          DBComboBox.Width:=nTamanho;
          DBComboBox.TabOrder:=DataSet.Fields.Fields[i].Index;
        end
        else begin
          nTamanho:=DataSet.Fields.Fields[i].DisplayWidth*10;
          if(DataSet.Fields.Fields[i].Tag<>0)then begin
            if(DataSet.Fields.Fields[i].Tag=nGroupPanels)then begin
              DBEdits:=TDBEdit.Create(GroupPanels);
              DBEdits.Parent:=GroupPanels;
            end
          end
          else begin
            DBEdits:=TDBEdit.Create(Panels);
            DBEdits.Parent:=Panels;
          end;
          DBEdits.TabOrder:=nTab;
          DBEdits.Name:='DBEdit'+IntToStr(i);
          DBEdits.DataField:=DataSet.Fields.Fields[i].FieldName;
          DBEdits.DataSource:=dtsDados;
          DBEdits.CharCase:=ecUppercase;
          DBEdits.Top:=nTopoComponente;
          DBEdits.Left:=nEsquerda;
          DBEdits.Width:=nTamanho;
          DBEdits.TabOrder:=DataSet.Fields.Fields[i].Index;
        end
      end
      //
      else if(DataSet.Fields.Fields[i].DataType in [ftString]) and (DataSet.Fields.Fields[i].FieldKind=fkLookup)then begin
        nTamanho:=DataSet.Fields.Fields[i].DisplayWidth*10;
        if(DataSet.Fields.Fields[i].Tag<>0)then begin
          if(DataSet.Fields.Fields[i].Tag=nGroupPanels)then begin
            DBLookupComboBox:=TDBLookupComboBox.Create(GroupPanels);
            DBLookupComboBox.Parent:=GroupPanels;
          end
        end
        else begin
          DBLookupComboBox:=TDBLookupComboBox.Create(Panels);
          DBLookupComboBox.Parent:=Panels;
        end;
        DBLookupComboBox.TabOrder:=nTab;
        DBLookupComboBox.Name:='DBLookupComboBox'+IntToStr(i);
        DBLookupComboBox.DataField:=DataSet.Fields.Fields[i].FieldName;
        DBLookupComboBox.DataSource:=dtsDados;
        DBLookupComboBox.Top:=nTopoComponente;
        DBLookupComboBox.Left:=nEsquerda;
        DBLookupComboBox.Width:=nTamanho;
        DBLookupComboBox.TabOrder:=DataSet.Fields.Fields[i].Index;
      end
      //
      else if(DataSet.Fields.Fields[i].DataType in [ftString]) and (DataSet.Fields.Fields[i].FieldKind=fkLookup)then begin
        nTamanho:=DataSet.Fields.Fields[i].DisplayWidth*10;
        if(DataSet.Fields.Fields[i].Tag<>0)then begin
          if(DataSet.Fields.Fields[i].Tag=nGroupPanels)then begin
            DBLookupComboBox:=TDBLookupComboBox.Create(GroupPanels);
            DBLookupComboBox.Parent:=GroupPanels;
          end
        end
        else begin
          DBLookupComboBox:=TDBLookupComboBox.Create(Panels);
          DBLookupComboBox.Parent:=Panels;
        end;
        DBLookupComboBox.TabOrder:=nTab;
        DBLookupComboBox.Name:='DBLookupComboBox'+IntToStr(i);
        DBLookupComboBox.DataField:=DataSet.Fields.Fields[i].FieldName;
        DBLookupComboBox.DataSource:=dtsDados;
        DBLookupComboBox.Top:=nTopoComponente;
        DBLookupComboBox.Left:=nEsquerda;
        DBLookupComboBox.Width:=nTamanho;
        DBLookupComboBox.TabOrder:=DataSet.Fields.Fields[i].Index;
      end
      //
      else if(DataSet.Fields.Fields[i].DataType in [ftDate, ftDateTime])then begin
        nTamanho:=DataSet.Fields.Fields[i].DisplayWidth*10;
        if(DataSet.Fields.Fields[i].Tag<>0)then begin
          if(DataSet.Fields.Fields[i].Tag=nGroupPanels)then begin
            DBDateTimePickers:=TDBDateTimePicker.Create(GroupPanels);
            DBDateTimePickers.Parent:=GroupPanels;
          end
        end
        else begin
          DBDateTimePickers:=TDBDateTimePicker.Create(Panels);
          DBDateTimePickers.Parent:=Panels;
        end;
        DBDateTimePickers.TabOrder:=nTab;
        DBDateTimePickers.Name:='DBDateTimePicker'+IntToStr(i);
        DBDateTimePickers.DataField:=DataSet.Fields.Fields[i].FieldName;
        DBDateTimePickers.DataSource:=dtsDados;
        DBDateTimePickers.Top:=nTopoComponente;
        DBDateTimePickers.Left:=nEsquerda;
        DBDateTimePickers.Width:=nTamanho;
        DBDateTimePickers.TabOrder:=DataSet.Fields.Fields[i].Index;
      end
      //
      else if(DataSet.Fields.Fields[i].DataType in [ftMemo])then begin
        nTamanho:=DataSet.Fields.Fields[i].DisplayWidth*10;
        if(DataSet.Fields.Fields[i].Tag<>0)then begin
          if(DataSet.Fields.Fields[i].Tag=nGroupPanels)then begin
            DBMemos:=TDBMemo.Create(GroupPanels);
            DBMemos.Parent:=GroupPanels;
          end
        end
        else begin
          DBMemos:=TDBMemo.Create(Panels);
          DBMemos.Parent:=Panels;
        end;
        DBMemos.TabOrder:=nTab;
        DBMemos.Name:='DBMemo'+IntToStr(i);
        DBMemos.DataField:=DataSet.Fields.Fields[i].FieldName;
        DBMemos.DataSource:=dtsDados;
        DBMemos.Top:=nTopoComponente;
        DBMemos.Left:=nEsquerda;
        DBMemos.Width:=350;
        DBMemos.Height:=100;
        DBMemos.TabOrder:=DataSet.Fields.Fields[i].Index;
      end
      //
      else if(DataSet.Fields.Fields[i].DataType in [ftSmallint])then begin
        if(DataSet.Fields.Fields[i].Tag<>0)then begin
          if(DataSet.Fields.Fields[i].Tag=nGroupPanels)then begin
            DBCheckBoxs:=TDBCheckBox.Create(GroupPanels);
            DBCheckBoxs.Parent:=GroupPanels;
          end
        end
        else begin
          DBCheckBoxs:=TDBCheckBox.Create(Panels);
          DBCheckBoxs.Parent:=Panels;
        end;
        DBCheckBoxs.Name:='DBCheBox'+IntToStr(i);
        DBCheckBoxs.DataField:=DataSet.Fields.Fields[i].FieldName;
        DBCheckBoxs.DataSource:=dtsDados;
        DBCheckBoxs.Caption:=DataSet.Fields.Fields[i].DisplayLabel;
        DBCheckBoxs.ValueChecked:='1';
        DBCheckBoxs.ValueUnchecked:='0';
        DBCheckBoxs.Top:=nTopoComponente;
        DBCheckBoxs.Left:=nEsquerda;
        DBCheckBoxs.TabOrder:=DataSet.Fields.Fields[i].Index;
      end;
    end;

  //  else if(DataSet.Fields.Fields[i].DataType in [ft])then begin
  //    if(DataSet.Fields.Fields[i].Tag<>0)then begin
  //      if(DataSet.Fields.Fields[i].Tag=nGroupPanels)then begin
  //        DBCheckBoxs:=TDBCheckBox.Create(GroupPanels);
  //        DBCheckBoxs.Parent:=GroupPanels;
  //      end
  //    end
  //    else begin
  //      DBCheckBoxs:=TDBCheckBox.Create(Panels);
  //      DBCheckBoxs.Parent:=Panels;
  //    end;
  //    DBCheckBoxs.Name:='DBCheBox'+IntToStr(i);
  //    DBCheckBoxs.DataField:=DataSet.Fields.Fields[i].FieldName;
  //    DBCheckBoxs.DataSource:=dtsDados;
  //    DBCheckBoxs.Caption:=DataSet.Fields.Fields[i].DisplayLabel;
  //    DBCheckBoxs.ValueChecked:='1';
  //    DBCheckBoxs.ValueUnchecked:='0';
  //    DBCheckBoxs.Top:=nTopoComponente;
  //    DBCheckBoxs.Left:=nEsquerda;
  //    DBCheckBoxs.TabOrder:=DataSet.Fields.Fields[i].Index;
  //  end;
  //  end;


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
//  CreateComponentsZ(ExternalDataSet);
  CreateComponents(dm_principal.ZConnection1, Dados.SQL.Text, dtsDados, ScrollBox1, true);
end;

end.

