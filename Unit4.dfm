object Form4: TForm4
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Shutdown'
  ClientHeight = 100
  ClientWidth = 384
  Color = clBlue
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clAqua
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = -8
    Top = 35
    Width = 500
    Height = 1
    Style = bsRaised
  end
  object Label1: TLabel
    Left = 8
    Top = 42
    Width = 116
    Height = 13
    Caption = '&Shutdown in 60 seconds'
  end
  object Cancel2: TSpeedButton
    Left = 319
    Top = 73
    Width = 57
    Height = 19
    Caption = 'Cancel'
    Flat = True
    OnClick = Cancel1Click
  end
  object OK2: TSpeedButton
    Left = 193
    Top = 73
    Width = 57
    Height = 19
    Caption = 'OK'
    Flat = True
    OnClick = OK2Click
  end
  object Pause2: TSpeedButton
    Left = 256
    Top = 73
    Width = 57
    Height = 19
    Caption = 'Pause'
    Flat = True
    OnClick = Pause1Click
  end
  object CheckBox1: TCheckBox
    Left = 223
    Top = 8
    Width = 97
    Height = 17
    Caption = '&Forced'
    Enabled = False
    TabOrder = 0
  end
  object ComboBox1: TComboBox
    Left = 8
    Top = 8
    Width = 209
    Height = 21
    Style = csDropDownList
    Color = clBlue
    DropDownCount = 10
    ItemHeight = 13
    TabOrder = 1
    OnChange = ComboBox1Change
    Items.Strings = (
      'Shutdown'
      'Hibernate'
      'Reboot'
      'Standby'
      'Lock Workstation'
      'Log off'
      'Screensaver'
      'Standby Monitor'
      'Restart Application'
      'Quit Application')
  end
  object MainMenu1: TMainMenu
    Left = 88
    Top = 68
    object File1: TMenuItem
      Caption = '&File'
      Visible = False
      object OK1: TMenuItem
        Caption = 'OK'
        ShortCut = 13
        OnClick = OK2Click
      end
      object Pause1: TMenuItem
        Caption = 'Pause'
        ShortCut = 32
        OnClick = Pause1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Cancel1: TMenuItem
        Caption = 'Cancel'
        ShortCut = 27
        OnClick = Cancel1Click
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 128
    Top = 68
  end
end
