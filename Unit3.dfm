object Form3: TForm3
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Form3'
  ClientHeight = 332
  ClientWidth = 351
  Color = clBlue
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clAqua
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 286
    Top = 289
    Width = 57
    Height = 19
    Caption = 'Close'
    Flat = True
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 160
    Top = 289
    Width = 57
    Height = 19
    Caption = 'Set!'
    Flat = True
    OnClick = SpeedButton2Click
  end
  object SpeedButton3: TSpeedButton
    Left = 223
    Top = 289
    Width = 57
    Height = 19
    Caption = 'Cancel'
    Enabled = False
    Flat = True
    OnClick = SpeedButton3Click
  end
  object Label2: TLabel
    Left = 8
    Top = 295
    Width = 126
    Height = 13
    Caption = 'Time remaining: 0 seconds'
    Visible = False
  end
  object Label3: TLabel
    Left = 96
    Top = 215
    Width = 80
    Height = 13
    Caption = 'Nothing selected'
    Enabled = False
  end
  object Bevel3: TBevel
    Left = 0
    Top = 81
    Width = 400
    Height = 1
    Style = bsRaised
  end
  object Bevel1: TBevel
    Left = -25
    Top = 280
    Width = 400
    Height = 1
    Style = bsRaised
  end
  object LabeledEdit1: TLabeledEdit
    Left = 96
    Top = 27
    Width = 42
    Height = 21
    Color = clBlue
    EditLabel.Width = 28
    EditLabel.Height = 13
    EditLabel.Caption = 'Hours'
    TabOrder = 0
    Text = '0'
    OnKeyPress = LabeledEdit1KeyPress
  end
  object LabeledEdit2: TLabeledEdit
    Left = 144
    Top = 27
    Width = 42
    Height = 21
    Color = clBlue
    EditLabel.Width = 37
    EditLabel.Height = 13
    EditLabel.Caption = 'Minutes'
    TabOrder = 1
    Text = '10'
    OnKeyPress = LabeledEdit1KeyPress
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 314
    Width = 335
    Height = 10
    Max = 10000
    ParentShowHint = False
    Step = 1
    ShowHint = True
    TabOrder = 2
    Visible = False
  end
  object LabeledEdit3: TLabeledEdit
    Left = 192
    Top = 27
    Width = 42
    Height = 21
    Color = clBlue
    EditLabel.Width = 40
    EditLabel.Height = 13
    EditLabel.Caption = 'Seconds'
    TabOrder = 3
    Text = '0'
    OnKeyPress = LabeledEdit1KeyPress
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 95
    Width = 65
    Height = 17
    Caption = 'Message'
    TabOrder = 4
    OnClick = CheckBox1Click
  end
  object Memo1: TMemo
    Left = 96
    Top = 87
    Width = 247
    Height = 66
    Color = clBlue
    Enabled = False
    TabOrder = 5
  end
  object CheckBox2: TCheckBox
    Left = 8
    Top = 291
    Width = 95
    Height = 17
    Caption = 'Close after Set'
    Checked = True
    State = cbChecked
    TabOrder = 6
    OnClick = CheckBox1Click
  end
  object CheckBox3: TCheckBox
    Left = 8
    Top = 159
    Width = 105
    Height = 17
    Caption = 'Ring the Alarm'
    Checked = True
    State = cbChecked
    TabOrder = 7
    OnClick = CheckBox3Click
  end
  object CheckBox4: TCheckBox
    Left = 8
    Top = 198
    Width = 233
    Height = 17
    Caption = 'Launch an External Program or Open a File'
    TabOrder = 8
    OnClick = CheckBox4Click
  end
  object DateTimePicker1: TDateTimePicker
    Left = 96
    Top = 54
    Width = 121
    Height = 21
    Date = 36892.000000000000000000
    Time = 36892.000000000000000000
    Color = clBlue
    Enabled = False
    TabOrder = 9
  end
  object DateTimePicker2: TDateTimePicker
    Left = 223
    Top = 54
    Width = 120
    Height = 21
    Date = 36892.000000000000000000
    Time = 36892.000000000000000000
    Color = clBlue
    Enabled = False
    Kind = dtkTime
    TabOrder = 10
  end
  object RadioButton3: TRadioButton
    Left = 8
    Top = 31
    Width = 82
    Height = 17
    Caption = 'Alarm after...'
    Checked = True
    TabOrder = 11
    TabStop = True
    OnClick = RadioButton3Click
  end
  object RadioButton4: TRadioButton
    Left = 8
    Top = 56
    Width = 82
    Height = 17
    Caption = 'Alarm on...'
    TabOrder = 12
    OnClick = RadioButton3Click
  end
  object Panel1: TPanel
    Left = 96
    Top = 174
    Width = 193
    Height = 18
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 13
    object RadioButton1: TRadioButton
      Left = 0
      Top = 1
      Width = 78
      Height = 17
      Caption = 'Ring Once'
      TabOrder = 0
    end
    object RadioButton2: TRadioButton
      Left = 92
      Top = 1
      Width = 77
      Height = 17
      Caption = 'Loop Sound'
      Checked = True
      TabOrder = 1
      TabStop = True
    end
  end
  object CheckBox5: TCheckBox
    Left = 8
    Top = 234
    Width = 166
    Height = 17
    Caption = 'Execute selected command'
    TabOrder = 14
    OnClick = CheckBox5Click
  end
  object ComboBox1: TComboBox
    Left = 96
    Top = 253
    Width = 247
    Height = 21
    Style = csDropDownList
    Color = clBlue
    DropDownCount = 15
    Enabled = False
    ItemHeight = 13
    TabOrder = 15
  end
  object MainMenu1: TMainMenu
    Left = 288
    Top = 103
    object File1: TMenuItem
      Caption = '&File'
      Visible = False
      object Set1: TMenuItem
        Caption = '&Set'
        ShortCut = 13
        OnClick = SpeedButton2Click
      end
      object Quit1: TMenuItem
        Caption = '&Quit'
        ShortCut = 27
        OnClick = SpeedButton1Click
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 256
    Top = 103
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Executables [*.exe]|*.exe|All files [*.*]|*.*'
    Left = 248
    Top = 199
  end
end
