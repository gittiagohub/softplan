object FormPrincipalCep: TFormPrincipalCep
  Left = 0
  Top = 0
  Caption = 'Sistema de Consulta de CEP'
  ClientHeight = 692
  ClientWidth = 786
  Color = clBtnFace
  Constraints.MinHeight = 720
  Constraints.MinWidth = 800
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PanelPrincipal: TPanel
    Left = 0
    Top = 0
    Width = 786
    Height = 692
    Align = alClient
    BorderWidth = 5
    Color = clActiveCaption
    ParentBackground = False
    TabOrder = 0
    object GroupBoxPrincipal: TGroupBox
      Left = 6
      Top = 6
      Width = 774
      Height = 680
      Align = alClient
      Caption = 'C'#243'digo de Endere'#231'amento Postal'
      Color = clSkyBlue
      ParentBackground = False
      ParentColor = False
      TabOrder = 0
      DesignSize = (
        774
        680)
      object GroupBoxConsulta: TGroupBox
        Left = 56
        Top = 23
        Width = 654
        Height = 234
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Consulta'
        TabOrder = 0
        DesignSize = (
          654
          234)
        object RadioGroupFormatoRetorno: TRadioGroup
          Left = 392
          Top = 13
          Width = 222
          Height = 63
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Formato de Retorno da Consulta Online'
          ItemIndex = 0
          Items.Strings = (
            'Xml'
            'Json')
          TabOrder = 0
        end
        object RadioGroupConsultaPor: TRadioGroup
          Left = 23
          Top = 13
          Width = 363
          Height = 63
          Caption = 'Consulta por'
          Columns = 2
          Ctl3D = True
          DoubleBuffered = False
          ItemIndex = 0
          Items.Strings = (
            'CEP'
            'Endere'#231'o Completo')
          ParentCtl3D = False
          ParentDoubleBuffered = False
          TabOrder = 1
          WordWrap = True
          OnClick = RadioGroupConsultaPorClick
        end
        object GroupBoxCamposConsulta: TGroupBox
          Left = 23
          Top = 78
          Width = 591
          Height = 142
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
          DesignSize = (
            591
            142)
          object LabelCEPConsulta: TLabel
            Left = 10
            Top = 19
            Width = 19
            Height = 13
            Caption = 'CEP'
          end
          object LabelUFConsulta: TLabel
            Left = 11
            Top = 49
            Width = 13
            Height = 13
            Caption = 'UF'
          end
          object LabelLocalidadeConsulta: TLabel
            Left = 11
            Top = 76
            Width = 50
            Height = 13
            Caption = 'Localidade'
          end
          object LabelLogradouroConsulta: TLabel
            Left = 11
            Top = 104
            Width = 49
            Height = 13
            Caption = 'Lograduro'
          end
          object MaskEditCEPConsulta: TMaskEdit
            Left = 64
            Top = 17
            Width = 370
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            EditMask = '99999-999;1'
            MaxLength = 9
            TabOrder = 0
            Text = '     -   '
          end
          object EditUFConsulta: TEdit
            Left = 64
            Top = 44
            Width = 370
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 1
          end
          object EditLocalidadeConsulta: TEdit
            Left = 64
            Top = 71
            Width = 370
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 2
          end
          object EditLogradouroConsulta: TEdit
            Left = 64
            Top = 99
            Width = 370
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 3
          end
          object ButtonConsultar: TButton
            Left = 439
            Top = 36
            Width = 149
            Height = 63
            Anchors = [akTop, akRight]
            Caption = 'Consultar'
            Constraints.MinHeight = 60
            Constraints.MinWidth = 148
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 4
            OnClick = ButtonConsultarClick
          end
        end
      end
      object GroupBoxRetornoConsulta: TGroupBox
        Left = 54
        Top = 263
        Width = 656
        Height = 211
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Retorno'
        TabOrder = 1
        DesignSize = (
          656
          211)
        object LabelCEP: TLabel
          Left = 20
          Top = 28
          Width = 19
          Height = 13
          Caption = 'CEP'
        end
        object LabelUF: TLabel
          Left = 20
          Top = 54
          Width = 13
          Height = 13
          Caption = 'UF'
        end
        object LabelBairro: TLabel
          Left = 20
          Top = 88
          Width = 28
          Height = 13
          Caption = 'Bairro'
        end
        object LabelLocalidade: TLabel
          Left = 20
          Top = 117
          Width = 50
          Height = 13
          Caption = 'Localidade'
        end
        object LabelLogradouro: TLabel
          Left = 20
          Top = 146
          Width = 55
          Height = 13
          Caption = 'Logradouro'
        end
        object DBEditCEP: TDBEdit
          Left = 89
          Top = 24
          Width = 370
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'cep'
          DataSource = DataSourceCEP
          ReadOnly = True
          TabOrder = 0
        end
        object DBEditUF: TDBEdit
          Left = 89
          Top = 51
          Width = 370
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'uf'
          DataSource = DataSourceCEP
          ReadOnly = True
          TabOrder = 1
        end
        object DBEditBairro: TDBEdit
          Left = 89
          Top = 81
          Width = 370
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'bairro'
          DataSource = DataSourceCEP
          ReadOnly = True
          TabOrder = 2
        end
        object DBEditLocalidade: TDBEdit
          Left = 89
          Top = 111
          Width = 370
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'localidade'
          DataSource = DataSourceCEP
          ReadOnly = True
          TabOrder = 3
        end
        object DBEditLogradouro: TDBEdit
          Left = 89
          Top = 139
          Width = 370
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          DataField = 'logradouro'
          DataSource = DataSourceCEP
          ReadOnly = True
          TabOrder = 4
        end
      end
      object GroupBox1: TGroupBox
        Left = 54
        Top = 480
        Width = 656
        Height = 185
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = 'Navega'#231#227'o'
        Color = clSkyBlue
        ParentBackground = False
        ParentColor = False
        TabOrder = 2
        object DBGridNavegacao: TDBGrid
          Left = 2
          Top = 15
          Width = 652
          Height = 168
          Align = alClient
          DataSource = DataSourceCEP
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'cep'
              Title.Caption = 'CEP'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'uf'
              Title.Caption = 'UF'
              Width = 20
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'localidade'
              Title.Caption = 'Localidade'
              Width = 100
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'bairro'
              Title.Caption = 'Bairro'
              Width = 100
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'logradouro'
              Title.Caption = 'Logradouro'
              Width = 200
              Visible = True
            end
            item
              Alignment = taRightJustify
              Expanded = False
              FieldName = 'complemento'
              Title.Caption = 'Complemento'
              Width = 200
              Visible = True
            end>
        end
      end
    end
  end
  object CEPManager: TCEPManager
    FormatoRetorno = FRXML
    DataSource = DataSourceCEP
    Left = 22
    Top = 185
  end
  object FDMemTableCEP: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'cep'
        DataType = ftString
        Size = 9
      end
      item
        Name = 'uf'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'bairro'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'localidade'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'logradouro'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'complemento'
        DataType = ftString
        Size = 255
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 30
    Top = 489
  end
  object DataSourceCEP: TDataSource
    DataSet = FDMemTableCEP
    Left = 112
    Top = 496
  end
end
