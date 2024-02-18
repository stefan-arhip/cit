object Form7: TForm7
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Form7'
  ClientHeight = 186
  ClientWidth = 195
  Color = clBlue
  Font.Charset = ANSI_CHARSET
  Font.Color = clAqua
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = mon
  OldCreateOrder = False
  OnCreate = FormCreate
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 130
    Top = 160
    Width = 57
    Height = 19
    Caption = 'Close'
    Flat = True
    OnClick = Iesire1Click
  end
  object MonthCalendar1: TMonthCalendar
    Left = 0
    Top = 0
    Width = 195
    Height = 160
    CalColors.BackColor = clWhite
    CalColors.TextColor = clAqua
    CalColors.TitleBackColor = clAqua
    CalColors.TitleTextColor = clBlue
    CalColors.MonthBackColor = clBlue
    CalColors.TrailingTextColor = clYellow
    Date = 0.917897129627817800
    PopupMenu = PopupMenu1
    TabOrder = 0
    TabStop = True
    WeekNumbers = True
  end
  object mon: TMainMenu
    Left = 120
    Top = 88
    object Iesire1: TMenuItem
      Caption = 'Iesire'
      ShortCut = 27
      Visible = False
      OnClick = Iesire1Click
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 48
    Top = 88
    object Addalarm1: TMenuItem
      Caption = 'Add alarm...'
      OnClick = Addalarm1Click
    end
    object Removealarm1: TMenuItem
      Caption = 'Remove alarm'
      Enabled = False
    end
    object Editalarm1: TMenuItem
      Caption = 'Edit alarm...'
      Enabled = False
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Gototoday1: TMenuItem
      Caption = 'Go to today'
      OnClick = Gototoday1Click
    end
  end
end
