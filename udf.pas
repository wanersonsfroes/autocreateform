unit UDF;

{$mode objfpc}{$H+}

interface

uses
  Windows, Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ZDataset, ZConnection, LCLType, DBCtrls, uDMPrincipal, DBDateTimePicker,
  typinfo, messages;

type
  { TDBComboBox }
  TDBComboBox = class(DBCtrls.TDBComboBox)
  protected
    procedure WMPaint(var Msg: TMessage); message WM_Paint;
  end;

function IsEnumResult(sqlInstruction, FieldName: String;
  Connection: TZConnection): String;
procedure CreateComponents(zConnection: TZConnection; QueryDataSet: String;
  DataSource: TDataSource; OwnerComponent: TWinControl; WithStyle: Boolean = false);

implementation

function IsEnumResult(sqlInstruction, FieldName: String;
  Connection: TZConnection): String;
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
  temp.Close;
  temp.Free;
end;

procedure CreateComponents(zConnection: TZConnection; QueryDataSet: String;
  DataSource: TDataSource; OwnerComponent: TWinControl;
  WithStyle: Boolean = false);
const
  Limite = 1024;
var
  i,
  x,
  nTag,
  nPanelGroups,
  nLeft,
  nTamanho,
  Index,
  Linha
    : Integer;

  isGroupped: Boolean;

  aAlign: TAlign;

  PanelFields,
  PanelField,
  PanelGroupFields  : TPanel;
  ShapeFields       : TShape;
  Labels            : TLabel;
  DBEdits           : TDBEdit;
  DBDateTimePickers : TDBDateTimePicker;
  DBMemos           : TDBMemo;
  DBCHeckBoxs       : TDBCheckBox;
  DBLookupComboBox  : TDBLookupComboBox;
  DBComboBox        : TDBComboBox;
  Image             : TImage;

  LabelCaption,
  FieldsName,
  EnumResult,
  S: String;

  sEnumList         : TStringList;
begin

  i:=0;
  x:=0;
  nTag:=0;
  Index:=0;
  nLeft:=0;
  nPanelGroups:=0;
  Linha:=0;

  isGroupped:=false;

  PanelFields:=nil;

  for i:=0 to DataSource.DataSet.FieldCount-1 do begin
    if(DataSource.DataSet.Fields.Fields[i].Visible=true)then begin

      if(not Assigned(PanelFields))then
        aAlign:=alLeft
      else begin
        if(aAlign=alClient)then
          aAlign:=alRight
        else
          aAlign:=alLeft;
      end;

      if(DataSource.DataSet.Fields[i].DisplayWidth<20)then begin
        nTamanho:=100
      end
      else if(DataSource.DataSet.Fields[i].DisplayWidth<100)then begin
        nTamanho:=200
      end;
      if(DataSource.DataSet.Fields[i].DisplayWidth>=200)then
        aAlign:=alClient;

      isGroupped:=DataSource.DataSet.Fields.Fields[i].Tag<>0; // if 0 then single else number is grupped
      nTag:=DataSource.DataSet.Fields[i].Tag;
      LabelCaption:=DataSource.DataSet.Fields.Fields[i].DisplayLabel;
      FieldsName:=DataSource.DataSet.Fields.Fields[i].FieldName;
      if(isGroupped=true)then begin
        if(DataSource.DataSet.Fields[i].Tag<>nPanelGroups)then begin
          PanelGroupFields:=TPanel.Create(OwnerComponent);
          PanelGroupFields.Parent:=OwnerComponent;
          PanelGroupFields.Align:=alTop;
          PanelGroupFields.BevelOuter:=bvNone;
          PanelGroupFields.BorderSpacing.Around:=5;
          PanelGroupFields.Height:=60; //48;
          PanelGroupFields.Top:=i*30;

          nPanelGroups:=DataSource.DataSet.Fields.Fields[i].Tag;
          aAlign:=alLeft;
        end;
        if(Assigned(PanelFields))then
          nLeft:=PanelFields.Left;
        PanelFields:=TPanel.Create(PanelGroupFields);
        PanelFields.Parent:=PanelGroupFields;
        PanelFields.Align:=aAlign;
        PanelFields.BevelOuter:=bvNone;
        PanelFields.BorderSpacing.Around:=3;
        PanelFields.BorderWidth:=2;
        PanelFields.Left:=nLeft+10;
        PanelFields.Name:='PanelFields'+IntToStr(i+1);
        PanelFields.Width:=nTamanho;
        //DataSource.DataSet.Fields.Fields[i].Size*4;

        ShapeFields:=TShape.Create(PanelFields);
        ShapeFields.Parent:=PanelFields;
        ShapeFields.Align:=alClient;
        ShapeFields.Pen.Color:=$00E3E3E3;
        ShapeFields.Pen.Width:=2;
        ShapeFields.Shape:=stRoundRect;

        PanelField:=TPanel.Create(PanelFields);
        PanelField.Parent:=PanelFields;
        PanelField.Align:=alClient;
        PanelField.BevelOuter:=bvNone;
        PanelField.BorderSpacing.Around:=6;
        PanelField.Caption:=EmptyStr;
        PanelField.Color:=clWhite;
        PanelField.TabOrder:=0;
        PanelField.Width:=DataSource.DataSet.Fields.Fields[i].Size;
      end
      else begin
        PanelFields:=TPanel.Create(OwnerComponent);
        PanelFields.Parent:=OwnerComponent;
        PanelFields.Align:=alTop;
        PanelFields.BevelOuter:=bvNone;
        PanelFields.BorderSpacing.Around:=3;
        PanelFields.BorderWidth:=2;
        //PanelFields.Left:=nLeft+10;
        PanelFields.Name:='PanelFields'+IntToStr(i+1);
        PanelFields.Width:=nTamanho;
        //DataSource.DataSet.Fields.Fields[i].Size*4;
        PanelFields.Top:=i*30;

        ShapeFields:=TShape.Create(PanelFields);
        ShapeFields.Parent:=PanelFields;
        ShapeFields.Align:=alClient;
        ShapeFields.Pen.Color:=$00E3E3E3;
        ShapeFields.Pen.Width:=2;
        ShapeFields.Shape:=stRoundRect;

        PanelField:=TPanel.Create(PanelFields);
        PanelField.Parent:=PanelFields;
        PanelField.Align:=alClient;
        PanelField.BevelOuter:=bvNone;
        PanelField.BorderSpacing.Around:=6;
        PanelField.Caption:=EmptyStr;
        PanelField.Color:=clWhite;
        PanelField.TabOrder:=0;
        //PanelField.Width:=DataSource.DataSet.Fields.Fields[i].Size;
      end;

      Labels:=TLabel.Create(PanelField);
      Labels.Parent:=PanelField;
      Labels.Align:=alTop;
      Labels.Caption:=LabelCaption;

      if(DataSource.DataSet.Fields.Fields[i].DataType in [ftInteger, ftString]) and (DataSource.DataSet.Fields.Fields[i].FieldKind=fkData)then begin
        EnumResult:=IsEnumResult(QueryDataSet, DataSource.DataSet.Fields.Fields[i].FieldName, zConnection);
        if(Pos('enum', EnumResult)<>0)then begin
          PanelField.Height:=54;
          Delete(EnumResult, 1, 4);
          DBComboBox:=TDBComboBox.Create(PanelField);
          DBComboBox.Parent:=PanelField;
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
          DBComboBox.Align:=alClient;
          DBComboBox.BorderStyle:=bsNone;
          DBComboBox.DataField:=FieldsName;
          DBComboBox.DataSource:=DataSource;
          DBComboBox.TabOrder:=0;
          DBComboBox.Style:=csDropDownList;
        end
        else begin
          DBEdits:=TDBEdit.Create(PanelField);
          DBEdits.Parent:=PanelField;
          DBEdits.Align:=alClient;
          DBEdits.BorderStyle:=bsNone;
          DBEdits.CharCase:=ecUppercase;
          DBEdits.Color:=$00F0F0F0;
          DBEdits.DataField:=FieldsName;
          DBEdits.DataSource:=DataSource;
          DBEdits.MaxLength:=DataSource.DataSet.Fields.Fields[i].Size;
          DBEdits.TabOrder:=0;
          //DBEdits.Width:=DataSource.DataSet.Fields.Fields[i].Size*2;
        end { DBEdit / DBComboBox }
      end

      //DBDateTimePicker
      else if(DataSource.DataSet.Fields.Fields[i].DataType in [ftDate, ftDateTime])then begin
        DBDateTimePickers:=TDBDateTimePicker.Create(PanelField);
        DBDateTimePickers.Parent:=PanelField;
        DBDateTimePickers.Align:=alClient;
        DBDateTimePickers.BorderStyle:=bsNone;
        DBDateTimePickers.DataField:=FieldsName;
        DBDateTimePickers.DataSource:=DataSource;
        DBDateTimePickers.TabOrder:=0;
      end { DBDateTimePicker }

      //DBMemo
      else if(DataSource.DataSet.Fields.Fields[i].DataType in [ftMemo])then begin
        DBMemos:=TDBMemo.Create(PanelField);
        DBMemos.Parent:=PanelField;
        DBMemos.Align:=alClient;
        DBMemos.BorderStyle:=bsNone;
        DBMemos.DataField:=FieldsName;
        DBMemos.DataSource:=DataSource;
        DBMemos.TabOrder:=0;
      end { DBMemo }

      //DBCheBox
      else if(DataSource.DataSet.Fields.Fields[i].DataType in [ftSmallint])then begin
        DBCheckBoxs:=TDBCheckBox.Create(PanelField);
        DBCheckBoxs.Parent:=PanelField;
        DBCHeckBoxs.Align:=alClient;
        DBCheckBoxs.DataField:=DataSource.DataSet.Fields.Fields[i].FieldName;
        DBCheckBoxs.DataSource:=DataSource;
        DBCheckBoxs.Caption:=DataSource.DataSet.Fields.Fields[i].DisplayLabel;
        DBCheckBoxs.ValueChecked:='1';
        DBCheckBoxs.ValueUnchecked:='0';
        DBCheckBoxs.TabOrder:=0;
      end { DBCheckBox }

      //DBLookupComboBox
      else if(DataSource.DataSet.Fields.Fields[i].DataType in [ftString]) and (DataSource.DataSet.Fields.Fields[i].FieldKind=fkLookup)then begin
        DBLookupComboBox:=TDBLookupComboBox.Create(PanelField);
        DBLookupComboBox.Parent:=PanelField;
        DBLookupComboBox.DataField:=FieldsName;
        DBLookupComboBox.DataSource:=DataSource;
        DBLookupComboBox.TabOrder:=0;
      end { DBLookupComboBox }
    end;
  end;
end;

{ TComboBox }

procedure TDBComboBox.WMPaint(var Msg: TMessage);
var
  MCanvas: TControlCanvas;
  R: TRect;
begin
  inherited;
  MCanvas := TControlCanvas.Create;
  try
    MCanvas.Control := Self;
    with MCanvas do
    begin
      //
      //    a magica esta na cor da borda...nao da pra "tirar" a borda, tem que enganar...kkk
      Brush.Color := clWhite;
      //
      //
      R := ClientRect;
      FrameRect(R);
      InflateRect(R, -1, -1);
      FrameRect(R);
    end;
  finally
    MCanvas.Free;
  end;
end;


end.

