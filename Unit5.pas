unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, MMSystem;

type
  TForm5 = class(TForm)
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    SpeedButton2: TSpeedButton;
    Label2: TLabel;
    SpeedButton3: TSpeedButton;
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
    Moving:Boolean;
    Delta:TPoint;
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

uses Unit3;

{$R *.dfm}

procedure TForm5.FormCreate(Sender: TObject);
begin
  Position:=poScreenCenter;
end;

procedure TForm5.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  If Button=mbLeft Then
    Begin
      Moving:=True;
      Delta:=Point(X,Y);
    End;
end;

procedure TForm5.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
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

procedure TForm5.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Moving:=False;
end;

procedure TForm5.SpeedButton1Click(Sender: TObject);
begin
  sndPlaySound(nil, 0); // Stops the sound
  Close;
end;

procedure TForm5.SpeedButton2Click(Sender: TObject);
begin
  sndPlaySound(nil, 0); // Stops the sound
  With Form3 Do
    Begin
      Form5.Visible:=False;
//      Form3.Visible:=True;
      SpeedButton2Click(Sender);
    End;
end;

procedure TForm5.SpeedButton3Click(Sender: TObject);
begin
  sndPlaySound(nil, 0); // Stops the sound
  SpeedButton3.Enabled:=False;
end;

end.
