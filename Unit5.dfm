object Form5: TForm5
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Form5'
  ClientHeight = 115
  ClientWidth = 319
  Color = clBlue
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clAqua
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 254
    Top = 90
    Width = 57
    Height = 19
    Caption = 'Close'
    Flat = True
    OnClick = SpeedButton1Click
  end
  object Label1: TLabel
    Left = 8
    Top = 27
    Width = 303
    Height = 57
    AutoSize = False
    WordWrap = True
    OnMouseDown = FormMouseDown
    OnMouseMove = FormMouseMove
    OnMouseUp = FormMouseUp
  end
  object SpeedButton2: TSpeedButton
    Left = 191
    Top = 90
    Width = 57
    Height = 19
    Caption = 'Repeat'
    Flat = True
    OnClick = SpeedButton2Click
  end
  object Label2: TLabel
    Left = 16
    Top = 8
    Width = 99
    Height = 13
    Caption = 'Alarm with message:'
  end
  object SpeedButton3: TSpeedButton
    Left = 8
    Top = 90
    Width = 57
    Height = 19
    Caption = 'Mute'
    Flat = True
    OnClick = SpeedButton3Click
  end
end
