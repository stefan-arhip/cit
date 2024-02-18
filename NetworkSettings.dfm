object NetworkSettingsForm: TNetworkSettingsForm
  Left = 292
  Top = 205
  BorderIcons = [biSystemMenu]
  BorderStyle = bsNone
  Caption = 'Network Settings'
  ClientHeight = 267
  ClientWidth = 472
  Color = clBlue
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clAqua
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  DesignSize = (
    472
    267)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 87
    Width = 76
    Height = 13
    Caption = 'From last reset:'
  end
  object Label2: TLabel
    Left = 8
    Top = 127
    Width = 72
    Height = 13
    Caption = 'IN (download):'
  end
  object Label3: TLabel
    Left = 8
    Top = 167
    Width = 68
    Height = 13
    Caption = 'OUT (upload):'
  end
  object StatusText: TLabel
    Left = 8
    Top = 197
    Width = 64
    Height = 13
    Caption = 'Status text'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clYellow
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object SpeedButton1: TSpeedButton
    Left = 399
    Top = 190
    Width = 65
    Height = 19
    Caption = 'Close'
    Flat = True
    OnClick = Quit1Click
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 215
    Width = 472
    Height = 52
    Align = alBottom
    BevelInner = bvLowered
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    Visible = False
    DesignSize = (
      472
      52)
    object ExitButton: TButton
      Left = 409
      Top = 6
      Width = 57
      Height = 39
      Anchors = [akTop, akRight]
      Caption = 'Exit'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = ExitButtonClick
    end
    object UnFreezeButton: TBitBtn
      Left = 80
      Top = 6
      Width = 65
      Height = 35
      Caption = 'Unfreeze'
      TabOrder = 1
      OnClick = UnFreezeButtonClick
    end
    object FreezeButton: TBitBtn
      Left = 8
      Top = 6
      Width = 65
      Height = 35
      Caption = 'Freeze'
      TabOrder = 2
      OnClick = FreezeButtonClick
    end
    object ClearCountersButton: TBitBtn
      Left = 152
      Top = 6
      Width = 89
      Height = 35
      Caption = 'Clear counters'
      TabOrder = 3
      OnClick = ClearCountersButtonClick
    end
    object RemoveInactiveButton: TBitBtn
      Left = 244
      Top = 6
      Width = 65
      Height = 35
      Caption = 'Remove'
      TabOrder = 4
      OnClick = RemoveInactiveButtonClick
    end
    object cbOnTop: TCheckBox
      Left = 315
      Top = 7
      Width = 86
      Height = 37
      Caption = 'Stay On Top'
      TabOrder = 5
      OnClick = cbOnTopClick
    end
  end
  object ledAdapterDescription: TLabeledEdit
    Left = 8
    Top = 41
    Width = 279
    Height = 19
    Anchors = [akLeft, akTop, akRight]
    Color = clBlue
    Ctl3D = False
    EditLabel.Width = 94
    EditLabel.Height = 13
    EditLabel.Caption = 'Adapter description'
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 1
    OnChange = ledAdapterDescriptionChange
  end
  object ledMACAddress: TLabeledEdit
    Left = 290
    Top = 41
    Width = 103
    Height = 19
    Anchors = [akTop, akRight]
    Color = clBlue
    Ctl3D = False
    EditLabel.Width = 64
    EditLabel.Height = 13
    EditLabel.Caption = 'MAC Address'
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 2
  end
  object ledSpeed: TLabeledEdit
    Left = 399
    Top = 41
    Width = 65
    Height = 19
    Anchors = [akTop, akRight]
    Color = clBlue
    Ctl3D = False
    EditLabel.Width = 30
    EditLabel.Height = 13
    EditLabel.Caption = 'Speed'
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 3
  end
  object ledStartedAt: TLabeledEdit
    Left = 131
    Top = 85
    Width = 173
    Height = 19
    Color = clBlue
    Ctl3D = False
    EditLabel.Width = 49
    EditLabel.Height = 13
    EditLabel.Caption = 'Started at'
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 4
  end
  object ledActiveFor: TLabeledEdit
    Left = 307
    Top = 85
    Width = 157
    Height = 19
    Color = clBlue
    Ctl3D = False
    EditLabel.Width = 41
    EditLabel.Height = 13
    EditLabel.Caption = 'Duration'
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 5
  end
  object ledOctInSec: TLabeledEdit
    Left = 131
    Top = 125
    Width = 85
    Height = 19
    Color = clBlue
    Ctl3D = False
    EditLabel.Width = 75
    EditLabel.Height = 13
    EditLabel.Caption = 'Traffic / second'
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 6
  end
  object ledPeakINSec: TLabeledEdit
    Left = 219
    Top = 125
    Width = 85
    Height = 19
    Color = clBlue
    Ctl3D = False
    EditLabel.Width = 67
    EditLabel.Height = 13
    EditLabel.Caption = 'Peak / second'
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 7
  end
  object ledAvgINSec: TLabeledEdit
    Left = 307
    Top = 125
    Width = 85
    Height = 19
    Color = clBlue
    Ctl3D = False
    EditLabel.Width = 85
    EditLabel.Height = 13
    EditLabel.Caption = 'Average / second'
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 8
  end
  object ledTotalIN: TLabeledEdit
    Left = 399
    Top = 125
    Width = 65
    Height = 19
    Color = clBlue
    Ctl3D = False
    EditLabel.Width = 32
    EditLabel.Height = 13
    EditLabel.Caption = 'TOTAL'
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 9
  end
  object ledOctOUTSec: TLabeledEdit
    Left = 131
    Top = 165
    Width = 85
    Height = 19
    Color = clBlue
    Ctl3D = False
    EditLabel.Width = 75
    EditLabel.Height = 13
    EditLabel.Caption = 'Traffic / second'
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 10
  end
  object ledPeakOUTSec: TLabeledEdit
    Left = 219
    Top = 165
    Width = 85
    Height = 19
    Color = clBlue
    Ctl3D = False
    EditLabel.Width = 67
    EditLabel.Height = 13
    EditLabel.Caption = 'Peak / second'
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 11
  end
  object ledAvgOUTSec: TLabeledEdit
    Left = 307
    Top = 165
    Width = 85
    Height = 19
    Color = clBlue
    Ctl3D = False
    EditLabel.Width = 85
    EditLabel.Height = 13
    EditLabel.Caption = 'Average / second'
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 12
  end
  object ledTotalOUT: TLabeledEdit
    Left = 399
    Top = 165
    Width = 65
    Height = 19
    Color = clBlue
    Ctl3D = False
    EditLabel.Width = 32
    EditLabel.Height = 13
    EditLabel.Caption = 'TOTAL'
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 13
  end
  object TrafficTabs: TTabSet
    Left = 0
    Top = 0
    Width = 472
    Height = 21
    Align = alTop
    BackgroundColor = clBlue
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clAqua
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentBackground = True
    SelectedColor = clAqua
    SoftTop = True
    Style = tsModernPopout
    Tabs.Strings = (
      '1'
      '2'
      '3')
    TabIndex = 0
    UnselectedColor = clBlue
    OnChange = TrafficTabsChange
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 220
    Top = 200
  end
  object MainMenu1: TMainMenu
    Left = 256
    Top = 200
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
end
