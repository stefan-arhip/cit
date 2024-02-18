unit Unit7;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, Buttons;

type
  TForm7 = class(TForm)
    mon: TMainMenu;
    Iesire1: TMenuItem;
    SpeedButton1: TSpeedButton;
    MonthCalendar1: TMonthCalendar;
    PopupMenu1: TPopupMenu;
    Addalarm1: TMenuItem;
    Removealarm1: TMenuItem;
    Editalarm1: TMenuItem;
    N1: TMenuItem;
    Gototoday1: TMenuItem;
    procedure Iesire1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Gototoday1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Addalarm1Click(Sender: TObject);
  private
    { Private declarations }
    Moving:Boolean;
    Delta:TPoint;
  public
    { Public declarations }
  end;

var
  Form7: TForm7;

implementation

uses Unit3;

{$R *.dfm}

procedure TForm7.Addalarm1Click(Sender: TObject);
begin
  Form3.ShowModal;
end;

procedure TForm7.FormCreate(Sender: TObject);
begin
//  Position:=poScreenCenter;
  MonthCalendar1.Date:=Now();
end;

procedure TForm7.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  If Button=mbLeft Then
    Begin
      Moving:=True;
      Delta:=Point(X,Y);
    End;
end;

procedure TForm7.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
Const SnapSize:Integer=25;
Var l,t:Integer;
    WorkRect:TRect;
begin
//  If Not Form2.CheckBox1.Checked Then
    Begin
      If Moving Then // You should add support for DualHead/Matrox Configurations
        Begin
          If Not SystemParametersInfo(SPI_GETWORKAREA,0,@WorkRect,0) Then
            WorkRect:=Bounds(0,0,Screen.Width,Screen.Height);
          Dec(WorkRect.Right,Width);
          Dec(WorkRect.Bottom,Height);
          l:=Left+X-Delta.X;
          t:=Top+Y-Delta.Y;
          If (l<WorkRect.Left+SnapSize) And (l>WorkRect.Left-SnapSize) Then
            l:=WorkRect.Left;
          If (l>WorkRect.Right-SnapSize) And (l<WorkRect.Right+SnapSize) Then
              l:=WorkRect.Right;
          If (t<WorkRect.Top+SnapSize) And (t>WorkRect.Top-SnapSize) Then
            t:=WorkRect.Top;
          If (t>WorkRect.Bottom-SnapSize) And (t<WorkRect.Bottom+SnapSize) Then
            t:=WorkRect.Bottom;
          Left:=l;  // NOTE: This will always "Show window
          Top:=t;   // contents while dragging"
        End;
    End;
end;

procedure TForm7.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Moving:=False;
end;

procedure TForm7.Gototoday1Click(Sender: TObject);
begin
  MonthCalendar1.Date:=Now;  
end;

procedure TForm7.Iesire1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm7.PopupMenu1Popup(Sender: TObject);
begin
//  MonthCalendar1.Date:=Now;
end;

end.
