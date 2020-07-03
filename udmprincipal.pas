{
drop table if exists fornecedores;
create table fornecedores(
  fornecedorID int not null auto_increment primary key,
  fornecedor varchar(50),
  cnpj char(18)
);

drop table if exists produtos;
create table produtos(
  produtoID int not null auto_increment primary key,
  produto varchar(50)
);
}
unit uDMPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, ZConnection, ZDataset;

type

  { Tdm_principal }

  Tdm_principal = class(TDataModule)
    sqlCadastrosbairro: TStringField;
    sqlCadastroscadastroID: TLongintField;
    sqlCadastroscep: TStringField;
    sqlCadastroscomplemento: TStringField;
    sqlCadastroscpf: TStringField;
    sqlCadastrosdata_cadastro: TDateField;
    sqlCadastrosdocumento: TStringField;
    sqlCadastrosdocumento_tipo: TStringField;
    sqlCadastrosdtnascimento: TDateField;
    sqlCadastrosemail: TStringField;
    sqlCadastrosendereco: TStringField;
    sqlCadastrosestado: TStringField;
    sqlCadastrosfoto: TBlobField;
    sqlCadastrosmunicipio: TStringField;
    sqlCadastrosnome: TStringField;
    sqlCadastrosnumero: TLongintField;
    sqlCadastrosnum_celular: TStringField;
    sqlCadastrossexo: TStringField;
    sqlCadastrossituacao: TSmallintField;
    sqlCadastrostel_fixo: TStringField;
    sqlDadoscadastroID: TLongintField;
    sqlDadoscad_bairro: TStringField;
    sqlDadoscad_batizado: TSmallintField;
    sqlDadoscad_celular: TStringField;
    sqlDadoscad_cep: TStringField;
    sqlDadoscad_complemento: TStringField;
    sqlDadoscad_conjugue: TStringField;
    sqlDadoscad_cpf: TStringField;
    sqlDadoscad_dt_nasc: TDateField;
    sqlDadoscad_email: TStringField;
    sqlDadoscad_endereco: TStringField;
    sqlDadoscad_estado: TStringField;
    sqlDadoscad_foto: TBlobField;
    sqlDadoscad_local_batismo: TStringField;
    sqlDadoscad_municipio: TStringField;
    sqlDadoscad_nome: TStringField;
    sqlDadoscad_numero: TLongintField;
    sqlDadoscad_obs: TMemoField;
    sqlDadoscad_rg: TStringField;
    sqlDadoscad_sexo: TStringField;
    sqlDadoscad_situacao: TSmallintField;
    sqlDadoscad_tel_fixo: TStringField;
    sqlFornecedorescnpj: TStringField;
    sqlFornecedoresfornecedor: TStringField;
    sqlFornecedoresfornecedorID: TLongintField;
    sqlFornecedorestipoID: TLongintField;
    ZConnection1: TZConnection;
    sqlCadastros: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
  private

  public

  end;

var
  dm_principal: Tdm_principal;

  Dados: TZQuery;

implementation

{$R *.lfm}

{ Tdm_principal }

procedure Tdm_principal.DataModuleCreate(Sender: TObject);
begin
  Dados:=sqlCadastros;
end;

end.

