unit Unit6;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, Menus, ExtCtrls, StdCtrls;

type
  TForm6 = class(TForm)
    ProgramIcon: TImage;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    MainMenu1: TMainMenu;
    Iesire1: TMenuItem;
    SpeedButton1: TSpeedButton;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Iesire1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Moving:Boolean;
    Delta:TPoint;
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

{$R *.dfm}

procedure TForm6.FormCreate(Sender: TObject);
begin
  Position:=poScreenCenter;
end;

procedure TForm6.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  If Button=mbLeft Then
    Begin
      Moving:=True;
      Delta:=Point(X,Y);
    End;
end;

procedure TForm6.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
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

procedure TForm6.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Moving:=False;
end;

procedure TForm6.Iesire1Click(Sender: TObject);
begin
  Close;
end;

end.
