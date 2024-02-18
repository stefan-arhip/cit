object Form2: TForm2
  Left = 0
  Top = 0
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'Settings'
  ClientHeight = 251
  ClientWidth = 384
  Color = clBlue
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clAqua
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 319
    Top = 224
    Width = 57
    Height = 19
    Caption = 'Close'
    Flat = True
    OnClick = Quit1Click
  end
  object Label1: TLabel
    Left = 8
    Top = 99
    Width = 92
    Height = 13
    Caption = 'Transparency 50%'
    Transparent = True
  end
  object SpeedButton2: TSpeedButton
    Left = 10
    Top = 160
    Width = 100
    Height = 19
    Caption = 'Edit Custom &Menu'
    Flat = True
    OnClick = SpeedButton2Click
  end
  object SpeedButton3: TSpeedButton
    Left = 10
    Top = 185
    Width = 100
    Height = 19
    Caption = 'Syncronize Time'
    Flat = True
    OnClick = SpeedButton3Click
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 8
    Width = 201
    Height = 17
    Caption = 'Autohide MainWindow'
    TabOrder = 0
    OnClick = CheckBox1Click
  end
  object ProgressBar1: TProgressBar
    Left = 10
    Top = 114
    Width = 100
    Height = 10
    Max = 10000
    Step = 1
    TabOrder = 1
    OnMouseDown = ProgressBar1MouseDown
    OnMouseMove = ProgressBar1MouseMove
    OnMouseUp = ProgressBar1MouseUp
  end
  object CheckBox2: TCheckBox
    Left = 8
    Top = 31
    Width = 201
    Height = 17
    Caption = 'Autostart with Windows'
    TabOrder = 2
    OnClick = CheckBox2Click
  end
  object GroupBox1: TGroupBox
    Left = 215
    Top = 8
    Width = 161
    Height = 122
    Caption = 'Colors'
    TabOrder = 3
    object Shape1: TShape
      Left = 124
      Top = 16
      Width = 21
      Height = 19
      Cursor = crHandPoint
      OnMouseUp = Shape1MouseUp
    end
    object Shape2: TShape
      Left = 124
      Top = 41
      Width = 21
      Height = 19
      Cursor = crHandPoint
      OnMouseUp = Shape2MouseUp
    end
    object Shape3: TShape
      Left = 124
      Top = 66
      Width = 21
      Height = 19
      Cursor = crHandPoint
      OnMouseUp = Shape3MouseUp
    end
    object Shape4: TShape
      Left = 124
      Top = 91
      Width = 21
      Height = 19
      Cursor = crHandPoint
      OnMouseUp = Shape4MouseUp
    end
    object Label2: TLabel
      Left = 16
      Top = 22
      Width = 82
      Height = 13
      Caption = 'Background color'
    end
    object Label3: TLabel
      Left = 16
      Top = 47
      Width = 82
      Height = 13
      Caption = 'Normal font color'
    end
    object Label4: TLabel
      Left = 16
      Top = 72
      Width = 79
      Height = 13
      Caption = 'Active font color'
    end
    object Label5: TLabel
      Left = 16
      Top = 97
      Width = 66
      Height = 13
      Caption = 'Warning color'
    end
  end
  object CheckBox3: TCheckBox
    Left = 8
    Top = 54
    Width = 201
    Height = 17
    Caption = 'Hide Desktop Icons'
    TabOrder = 4
    OnClick = CheckBox3Click
  end
  object CheckBox4: TCheckBox
    Left = 8
    Top = 77
    Width = 201
    Height = 17
    Caption = 'Show big clock'
    TabOrder = 5
    OnClick = CheckBox4Click
  end
  object MainMenu1: TMainMenu
    Left = 144
    Top = 64
    object File1: TMenuItem
      Caption = '&File'
      Visible = False
      object Quit1: TMenuItem
        Caption = '&Quit'
        ShortCut = 27
        OnClick = Quit1Click
      end
    end
  end
  object ColorDialog1: TColorDialog
    Left = 176
    Top = 64
  end
end
