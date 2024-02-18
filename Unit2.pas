unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, Buttons, StdCtrls, ComCtrls, Registry, ExtCtrls, ShellApi;

type
  TForm2 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Quit1: TMenuItem;
    SpeedButton1: TSpeedButton;
    CheckBox1: TCheckBox;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    CheckBox2: TCheckBox;
    ColorDialog1: TColorDialog;
    GroupBox1: TGroupBox;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    SpeedButton2: TSpeedButton;
    CheckBox3: TCheckBox;
    SpeedButton3: TSpeedButton;
    CheckBox4: TCheckBox;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Quit1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure ProgressBar1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ProgressBar1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure ProgressBar1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CheckBox2Click(Sender: TObject);
    procedure Shape1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Shape2MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Shape3MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Shape4MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
    Setting:Boolean;
    Moving:Boolean;
    Delta:TPoint;
    Click:Boolean;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Unit1, Unit3, Unit4, Unit5, Unit6, Unit7, CoolThings;

{$R *.dfm}

procedure TForm2.CheckBox1Click(Sender: TObject);
begin
  If CheckBox1.Checked Then
    Begin
      With Form1 Do
        Begin
          RestoreWorkArea;
          RefreshDesktop;
        End;
      Form1.Timer2.Enabled:=False;
      Form1.Timer3.Enabled:=False;
      Form1.Left:=0;//(Screen.Width-Form1.Width) Div 2;
      Form1.Top:=0;
    End
  Else
    Form1.FixWorkArea;
end;

procedure TForm2.CheckBox2Click(Sender: TObject);
begin
  With TRegistry.Create Do
    Begin
      RootKey:=HKEY_CURRENT_USER;
      If CheckBox2.Checked Then
          If OpenKey('Software\Microsoft\Windows\CurrentVersion\Run',TRUE) Then
            WriteString('CIT','"'+Application.ExeName+'"')
          Else
            MessageDlg('Registry read error',mtError,[mbOk],0)
        Else
          If OpenKey('Software\Microsoft\Windows\CurrentVersion\Run',TRUE) Then
            WriteString('CIT','')
          Else
            MessageDlg('Registry read error',mtError,[mbOk],0);
        CloseKey;
    End;
end;

procedure TForm2.CheckBox3Click(Sender: TObject);
begin
  If Tag<>10000 Then
    Begin
      ShowDesktop(CheckBox3.Checked);
      Tag:=10000;
      CheckBox3.Checked:=Not CheckBox3.Checked;
      Tag:=0;
    End;
  Tag:=0;
end;

procedure TForm2.CheckBox4Click(Sender: TObject);
begin
  Form1.ShowBigClock(CheckBox4.Checked);
end;

procedure TForm2.FormCreate(Sender: TObject);
Var s:TShiftState;
begin
//  BackGroundColor:=clBlue;
  CheckBox4.Checked:=Form1.BigClock;
  ProgressBar1.Position:=Form1.Transparency;
//  CheckBox4Click(Sender);
  Shape1.Brush.Color:=BackGroundColor;
//  ColorOfTheFont:=clAqua;
  Shape2.Brush.Color:=ColorOfTheFont;
//  ActiveColorOfTheFont:=clYellow;
  Shape3.Brush.Color:=ActiveColorOfTheFont;
//  WarningColorOfTheFont:=clRed;
  Shape4.Brush.Color:=WarningColorOfTheFont;
  Position:=poScreenCenter;
  Setting:=True;
  ProgressBar1.Max:=255;
  ProgressBar1.Position:=Round(ProgressBar1.Max*20/100);
  ProgressBar1.Cursor:=crHSplit;
  ProgressBar1MouseMove(Sender,s,0,0);
  Setting:=False;
  With TRegistry.Create do
    Begin
      RootKey:=HKEY_CURRENT_USER;
      If OpenKey('Software\Microsoft\Windows\CurrentVersion\Run',TRUE) Then
        Begin
          CheckBox2.Checked:=ReadString('CIT')<>'';
        End
      Else
        Begin
          MessageDlg('Registry read error', mtError, [mbOk], 0);
        End;
      CloseKey;
    End;
end;

procedure TForm2.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  If Button=mbLeft Then
    Begin
      Moving:=True;
      Delta:=Point(X,Y);
    End;
end;

procedure TForm2.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
Const SnapSize:Integer=25;
Var l,t:Integer;
    WorkRect:TRect;
begin
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
end;

procedure TForm2.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Moving:=False;
end;

procedure TForm2.FormMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  If ProgressBar1.Position<>ProgressBar1.Max Then
    ProgressBar1.Position:=ProgressBar1.Position+1;
end;

procedure TForm2.FormMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  If ProgressBar1.Position<>ProgressBar1.Min Then
    ProgressBar1.Position:=ProgressBar1.Position-1;
end;

procedure TForm2.FormPaint(Sender: TObject) ;
Var Row,Ht:Word;
Begin
{  Ht:=(ClientHeight+255) Div 256;
  For Row:=0 To 255 Do
    With Canvas Do
      Begin
        Brush.Color:=RGB(0,0,Row);
        FillRect(Rect(0,Row*Ht,ClientWidth,(Row+1)*Ht));
      End; }
End;

procedure TForm2.ProgressBar1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Click:=True;
  ProgressBar1MouseMove(Sender,Shift,X,Y);
end;

procedure TForm2.ProgressBar1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
Var newPosition:Integer;
begin
  If Click Then
    Begin
      newPosition:=Round(x*ProgressBar1.Max/ProgressBar1.ClientWidth);
      ProgressBar1.Position:=newPosition;
//      TrackBar1.Position:=TrackBar1.Max-newPosition;
    End;
//  AudioMixer1.GetMute(0,-1,Mute);
//  If Mute Then
//    Label12.Caption:='Volume muted'
//  Else
    Label1.Caption:=Format('Transparency %2d %%',[Round((ProgressBar1.Position)*100/ProgressBar1.Max)]);
    Form1.SetTransparency(ProgressBar1.Max-ProgressBar1.Position);
//    Form2.AlphaBlendValue:=ProgressBar1.Max-ProgressBar1.Position;
//    Form3.AlphaBlendValue:=ProgressBar1.Max-ProgressBar1.Position;
//    Form4.AlphaBlendValue:=ProgressBar1.Max-ProgressBar1.Position;
//    Form5.AlphaBlendValue:=ProgressBar1.Max-ProgressBar1.Position;
  SetProgressBarColor(ProgressBar1);
end;

procedure TForm2.ProgressBar1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Click:=False;
end;

procedure TForm2.Quit1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm2.Shape1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  If ColorDialog1.Execute Then
    Begin
      BackGroundColor:=ColorDialog1.Color;
      Shape1.Brush.Color:=BackGroundColor;
      Form1.ApplyNewColors;
    End;
end;

procedure TForm2.Shape2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  If ColorDialog1.Execute Then
    Begin
      ColorOfTheFont:=ColorDialog1.Color;
      Shape2.Brush.Color:=ColorOfTheFont;
      Form1.ApplyNewColors;
    End;
end;

procedure TForm2.Shape3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  If ColorDialog1.Execute Then
    Begin
      ActiveColorOfTheFont:=ColorDialog1.Color;
      Shape3.Brush.Color:=ActiveColorOfTheFont;
      Form1.ApplyNewColors;
    End;
end;

procedure TForm2.Shape4MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  If ColorDialog1.Execute Then
    Begin
      WarningColorOfTheFont:=ColorDialog1.Color;
      Shape4.Brush.Color:=WarningColorOfTheFont;
      Form1.ApplyNewColors;
    End;
end;

procedure TForm2.SpeedButton2Click(Sender: TObject);
Var f:TextFile;
begin
  If Not FileExists(ExtractFilePath(ParamStr(0))+'menu.ini') Then
    Begin
      AssignFile(f,ExtractFilePath(ParamStr(0))+'menu.ini');
      Rewrite(f);
      WriteLn(f,'[Accessibility]');
      WriteLn(f,'N1=Character Map');
      WriteLn(f,'C1=charmap.exe');
      WriteLn(f,'N2=Clipboard Viewer');
      WriteLn(f,'C2=clipbrd.exe');
      WriteLn(f,'N3=Narrator');
      WriteLn(f,'C3=narrator.exe');
      WriteLn(f,'N4=On Screen Keyboard');
      WriteLn(f,'C4=osk.exe');
      WriteLn(f,'[Communications]');
      WriteLn(f,'N1=Network Connection');
      WriteLn(f,'C1=rasphone.exe');
      WriteLn(f,'N2=Remote Desktop Connection');
      WriteLn(f,'C2=mstsc.exe');
      WriteLn(f,'N3=Shared Folder Wizard');
      WriteLn(f,'C3=shrpubw.exe');
      WriteLn(f,'[Information]');
      WriteLn(f,'N1=DxDiag');
      WriteLn(f,'C1=dxdiag.exe');
      WriteLn(f,'N2=Task Manager');
      WriteLn(f,'C2=taskmgr.exe');
      WriteLn(f,'[Programs]');
      WriteLn(f,'N1=Calculator');
      WriteLn(f,'C1=calc.exe');
      WriteLn(f,'N2=Command Prompt');
      WriteLn(f,'C2=cmd.exe');
      WriteLn(f,'N3=Explorer');
      WriteLn(f,'C3=explorer.exe');
      WriteLn(f,'N4=IExpress');
      WriteLn(f,'C4=iexpress.exe');
      WriteLn(f,'N5=Notepad');
      WriteLn(f,'C5=notepad.exe');
      WriteLn(f,'N6=Paint');
      WriteLn(f,'C6=mspaint.exe');
      WriteLn(f,'[System Tools]');
      WriteLn(f,'N1=Clean Manager');
      WriteLn(f,'C1=cleanmgr.exe');
      WriteLn(f,'N2=Computer Management');
      WriteLn(f,'C2=compmgmt.msc');
      WriteLn(f,'N3=Disk Defragmenter');
      WriteLn(f,'C3=dfrg.msc');
      WriteLn(f,'N4=Disk Management');
      WriteLn(f,'C4=diskmgmt.msc');
      WriteLn(f,'N5=Registry Editor');
      WriteLn(f,'C5=regedit.exe');
      WriteLn(f,'[Sites]');
      WriteLn(f,'N1=Google');
      WriteLn(f,'C1=http://www.google.com');
      WriteLn(f,'N2=Yahoo');
      WriteLn(f,'C2=http://www.yahoo.com');
    End;
  ShellExecute(Handle,'open',PChar(ExtractFilePath(ParamStr(0))+'menu.ini'),Nil,Nil,SW_SHOWNORMAL);
end;

procedure TForm2.SpeedButton3Click(Sender: TObject);
begin
  Form1.Synchronizetime1Click(Sender);
end;

end.
