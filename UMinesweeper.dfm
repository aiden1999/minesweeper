object Minesweeper: TMinesweeper
  Left = 507
  Top = 175
  Caption = 'Minesweeper'
  ClientHeight = 683
  ClientWidth = 649
  Color = clActiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LabelMinesLeft: TLabel
    Left = 8
    Top = 5
    Width = 89
    Height = 28
    Caption = 'Mines Left'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object LabelMinesLeftValue: TLabel
    Left = 111
    Top = 5
    Width = 9
    Height = 28
    Caption = 'x'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object LabelSquaresLeft: TLabel
    Left = 159
    Top = 5
    Width = 106
    Height = 28
    Caption = 'Squares Left'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object LabelSquaresLeftValue: TLabel
    Left = 277
    Top = 5
    Width = 9
    Height = 28
    Caption = 'x'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object WinLoseLabel: TLabel
    Left = 440
    Top = 5
    Width = 120
    Height = 28
    Caption = 'WinLoseLabel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object StringGrid: TStringGrid
    Left = 8
    Top = 39
    Width = 633
    Height = 636
    Color = clBlack
    ColCount = 30
    DefaultColWidth = 20
    DefaultRowHeight = 20
    FixedColor = clBlack
    FixedCols = 0
    RowCount = 30
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Segoe UI Emoji'
    Font.Style = []
    GradientEndColor = clBlack
    GradientStartColor = clBlack
    ParentFont = False
    TabOrder = 0
    OnClick = StringGridOnClick
    OnDblClick = StringGridOnDblClick
    OnDrawCell = GridDrawCell
    ColWidths = (
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20)
    RowHeights = (
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20
      20)
  end
  object OKButton: TButton
    Left = 566
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    Visible = False
    OnClick = FormCreate
  end
end
