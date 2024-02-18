unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Menus, Buttons;

type
  TForm4 = class(TForm)
    CheckBox1: TCheckBox;
    Bevel1: TBevel;
    Label1: TLabel;
    Cancel2: TSpeedButton;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Cancel1: TMenuItem;
    Timer1: TTimer;
    OK2: TSpeedButton;
    OK1: TMenuItem;
    Pause2: TSpeedButton;
    N1: TMenuItem;
    Pause1: TMenuItem;
    ComboBox1: TComboBox;
    procedure Cancel1Click(Sender: TObject);
    procedure OK2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Pause1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
    Moving:Boolean;
    Delta:TPoint;
  public
    { Public declarations }
    WaitUntilRun:Integer;
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

Uses CoolThings, Unit1;

function LockWorkStation: boolean; stdcall; external 'user32.dll' name 'LockWorkStation';
function SetSuspendState(hibernate, forcecritical, disablewakeevent: boolean): boolean; stdcall; external 'powrprof.dll' name 'SetSuspendState';
function IsHibernateAllowed: boolean; stdcall; external 'powrprof.dll' name 'IsPwrHibernateAllowed';
function IsPwrSuspendAllowed: Boolean; stdcall; external 'powrprof.dll' name 'IsPwrSuspendAllowed';
function IsPwrShutdownAllowed: Boolean; stdcall; external 'powrprof.dll' name 'IsPwrShutdownAllowed';

Const NameOfAction:Array[1..10]Of String=('Shutdown','Hibernate','Reboot','Standby',
                                         'Lock Workstation','Log Off',
                                         'Screensaver','Standby Monitor',
                                         'Restart Application','Quit Application');

procedure TForm4.ComboBox1Change(Sender: TObject);
begin
  CheckBox1.Enabled:=ComboBox1.ItemIndex In [0,2];
  Label1.Caption:=NameOfAction[ComboBox1.ItemIndex+1];//+' in '+IntToStr(WaitUntilRun)+' seconds';
  Timer1.Enabled:=False;
  Pause2.Caption:='Resume';
end;

procedure TForm4.FormActivate(Sender: TObject);
begin
  Timer1.Enabled:=True;
  Timer1Timer(Sender);
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
  Position:=poScreenCenter;
end;

procedure TForm4.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  If Button=mbLeft Then
    Begin
      Moving:=True;
      Delta:=Point(X,Y);
    End;
end;

procedure TForm4.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
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

procedure TForm4.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Moving:=False;
end;

procedure TForm4.Cancel1Click(Sender: TObject);
begin
  Timer1.Enabled:=False;
  Close;
end;

procedure TForm4.Timer1Timer(Sender: TObject);
begin
  If (WaitUntilRun<=0) And (Form4.Visible) Then
    Begin
      Timer1.Enabled:=False;
      Form4.Visible:=False;
      Case ComboBox1.ItemIndex Of
        0:If CheckBox1.Checked Then WindowsExit(EWX_POWEROFF Or EWX_FORCE)
          Else WindowsExit(EWX_POWEROFF);
        1:If IsHibernateAllowed Then SetSuspendState(True,False,False)
          Else MessageDlg('System Hibernate not supported on this system.', mtWarning, [mbOK], 0);
        2:If CheckBox1.Checked Then WindowsExit(EWX_REBOOT Or EWX_FORCE)
          Else WindowsExit(EWX_REBOOT);
        3:If IsPwrSuspendAllowed Then SetSuspendState(False, False, False)
          Else MessageDlg('System Standby not supported on this system.', mtWarning, [mbOK], 0);
        4:If Not LockWorkStation Then MessageDlg('System not locked successfully.', mtWarning, [mbOK], 0);
        5:ExitWindowsEx(EWX_LOGOFF,0);
        6:SendMessage(Handle,WM_SYSCOMMAND,SC_SCREENSAVE,1);
        7:SendMessage(Handle,WM_SYSCOMMAND,SC_MONITORPOWER,2);
        8:Begin
            Form1.RestoreWorkArea;
            Form1.RefreshDesktop;
            Form1.RestartApplication1Click(Sender);
          End;
        (*
        //Var FullProgPath:PChar;
          Begin
        //  MyUniqueID:='modificat ca sa poata reporni aplicatia';
        //  FullProgPath:=PChar(Application.ExeName);
        //  WinExec(FullProgPath, SW_SHOW); // Or better use the CreateProcess function
        //  Application.Terminate;// or:Close;
          End;
        *)
        9:Begin
            Form1.ScriereSetari(ExtractFilePath(ParamStr(0))+'settings.ini');
            Form1.RestoreWorkArea;
            Form1.RefreshDesktop;
            Application.Terminate;
          End;
      End;
      Form4.Visible:=True;
      Form4.Close;
    End;
  Label1.Caption:=NameOfAction[ComboBox1.ItemIndex+1]+' in '+IntToStr(WaitUntilRun)+' seconds';
  Dec(WaitUntilRun);
end;

procedure TForm4.OK2Click(Sender: TObject);
begin
  WaitUntilRun:=0;
  Timer1Timer(Sender);
end;

procedure TForm4.Pause1Click(Sender: TObject);
begin
  Timer1.Enabled:=Not Timer1.Enabled;
  If Timer1.Enabled Then Pause2.Caption:='Pause'
  Else Pause2.Caption:='Resume';
end;

end.
