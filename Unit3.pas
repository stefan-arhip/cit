unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, Buttons, ExtCtrls, StdCtrls, ComCtrls, MMSystem, CommCtrl, ShellApi;

type
  TForm3 = class(TForm)
    SpeedButton1: TSpeedButton;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Quit1: TMenuItem;
    Timer1: TTimer;
    SpeedButton2: TSpeedButton;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    ProgressBar1: TProgressBar;
    Set1: TMenuItem;
    LabeledEdit3: TLabeledEdit;
    SpeedButton3: TSpeedButton;
    CheckBox1: TCheckBox;
    Memo1: TMemo;
    Label2: TLabel;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    Label3: TLabel;
    OpenDialog1: TOpenDialog;
    Bevel3: TBevel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    Bevel1: TBevel;
    Panel1: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    CheckBox5: TCheckBox;
    ComboBox1: TComboBox;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton1Click(Sender: TObject);
    procedure LabeledEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
  private
    { Private declarations }
    Moving:Boolean;
    Delta:TPoint;
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses Unit5, CoolThings, Unit4, Unit1, Unit2;

{$R *.dfm}
//{$R sounds.res}
{$R RTWarning.res}

Var WhenWillHorn,PassedTime:Int64;

procedure TForm3.CheckBox1Click(Sender: TObject);
begin
  Memo1.Enabled:=CheckBox1.Checked;
end;

procedure TForm3.CheckBox3Click(Sender: TObject);
begin
  RadioButton1.Enabled:=CheckBox3.Checked;
  RadioButton2.Enabled:=CheckBox3.Checked;
end;

procedure TForm3.CheckBox4Click(Sender: TObject);
begin
  If CheckBox4.Checked Then
    If OpenDialog1.Execute Then
      Begin
        Label3.Caption:=ExtractFileName(OpenDialog1.FileName);
        Label3.Enabled:=True;
      End
    Else
  Else
    Begin
      CheckBox4.Checked:=False;
      Label3.Caption:='Nothing selected';
      Label3.Enabled:=False;
    End;
end;

procedure TForm3.CheckBox5Click(Sender: TObject);
begin
  ComboBox1.Enabled:=CheckBox5.Checked;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  Position:=poScreenCenter;
  ProgressBar1.Brush.Color:=clBlue;
  SendMessage(ProgressBar1.Handle,PBM_SETBARCOLOR,0,ColorOfTheFont);
  ComboBox1.Items:=Form4.ComboBox1.Items;
  ComboBox1.ItemIndex:=Form4.ComboBox1.ItemIndex;
  DateTimePicker1.Date:=Now();
  DateTimePicker1.Time:=Now();
  If Form3.Timer1.Enabled Then Form1.GridPanel1.ColumnCollection[11].Value:=50
  Else Form1.GridPanel1.ColumnCollection[11].Value:=0;
end;

procedure TForm3.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
//  If Not Form2.CheckBox1.Checked Then
    If Button=mbLeft Then
      Begin
        Moving:=True;
        Delta:=Point(X,Y);
      End;
end;

procedure TForm3.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
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

procedure TForm3.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
//  If Not Form2.CheckBox1.Checked Then
    Moving:=False;
end;

procedure TForm3.LabeledEdit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in [#8, '0'..'9']) then
    begin
      Key := #0;
    end;
end;

procedure TForm3.RadioButton3Click(Sender: TObject);
begin
  DateTimePicker1.Enabled:=RadioButton4.Checked;
  DateTimePicker2.Enabled:=RadioButton4.Checked;
  LabeledEdit1.Enabled:=RadioButton3.Checked;
  LabeledEdit2.Enabled:=RadioButton3.Checked;
  LabeledEdit3.Enabled:=RadioButton3.Checked;
end;

procedure TForm3.SpeedButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm3.SpeedButton2Click(Sender: TObject);
begin
  WhenWillHorn:=StrToInt(LabeledEdit1.Text)*60*60+
                StrToInt(LabeledEdit2.Text)   *60+
                StrToInt(LabeledEdit3.Text);
  PassedTime:=0;
  ProgressBar1.Max:=WhenWillHorn;//10000;
  ProgressBar1.Position:=PassedTime;//0
  ProgressBar1.Visible:=True;
  Label2.Visible:=True;
  CheckBox2.Visible:=False;
//  SpeedButton1.Enabled:=False;
  SpeedButton2.Enabled:=False;
  SpeedButton3.Enabled:=True;
  LabeledEdit1.ReadOnly:=True;
  LabeledEdit2.ReadOnly:=True;
  LabeledEdit3.ReadOnly:=True;
  Timer1.Enabled:=True;
  If Timer1.Enabled Then Form1.GridPanel1.ColumnCollection[11].Value:=50
  Else Form1.GridPanel1.ColumnCollection[11].Value:=0;
  If CheckBox2.Checked Then Close;
end;

procedure TForm3.SpeedButton3Click(Sender: TObject);
begin
  ProgressBar1.Visible:=False;
  Label2.Visible:=False;
  CheckBox2.Visible:=True;
//  SpeedButton1.Enabled:=True;
  SpeedButton2.Enabled:=True;
  SpeedButton3.Enabled:=False;
  LabeledEdit1.ReadOnly:=False;
  LabeledEdit2.ReadOnly:=False;
  LabeledEdit3.ReadOnly:=False;
  Timer1.Enabled:=False;
  If Timer1.Enabled Then Form1.GridPanel1.ColumnCollection[11].Value:=50
  Else Form1.GridPanel1.ColumnCollection[11].Value:=0;
end;

procedure TForm3.Timer1Timer(Sender: TObject);
Var RemainingTime: Longint;
begin
  Inc(PassedTime);
  ProgressBar1.Position:=PassedTime;//Round(PassedTime*ProgressBar1.Max/WhenWillHorn);
  RemainingTime:=WhenWillHorn-PassedTime;
  Label2.Caption:='Remaining time: '+SecondsToTime(RemainingTime);
  Form1.Label13.Hint:= Label2.Caption;
  If RemainingTime<60 Then                 //seconds
    Begin
      Form1.Label13.Caption:=IntToStr(RemainingTime)+'s';
      AlterneazaCuloarea:= True;
      Form1.Label13.Font.Color:= Form2.Shape4.Brush.Color;
    End
  Else If RemainingTime<60*60 Then         //minutes
    Begin
      Form1.Label13.Caption:=IntToStr(RemainingTime Div 60)+'m';
      AlterneazaCuloarea:= False;
      Form1.Label13.Font.Color:= Form2.Shape3.Brush.Color;
    End
  Else If RemainingTime<60*60*60 Then      //hours
    Begin
      Form1.Label13.Caption:=IntToStr(RemainingTime Div 60 Div 60)+'h';
      AlterneazaCuloarea:= False;
      Form1.Label13.Font.Color:= Form2.Shape2.Brush.Color;
    End;
  If PassedTime>=WhenWillHorn Then
    Begin
      ProgressBar1.Visible:=False;
//      SpeedButton1.Enabled:=True;
      SpeedButton2.Enabled:=True;
      SpeedButton3.Enabled:=False;
      LabeledEdit1.ReadOnly:=False;
      LabeledEdit2.ReadOnly:=False;
      LabeledEdit3.ReadOnly:=False;
      Timer1.Enabled:=False;
      If Timer1.Enabled Then Form1.GridPanel1.ColumnCollection[11].Value:=50
      Else Form1.GridPanel1.ColumnCollection[11].Value:=0;
      //If Memo1.Text<>'' Then
      If CheckBox3.Checked Then
        Begin
          //PlaySound('tada', hInstance, SND_RESOURCE or SND_ASYNC);
          If RadioButton1.Checked Then
            PlaySound('RTWarning', hInstance, SND_RESOURCE Or SND_ASYNC)
          Else If RadioButton2.Checked Then
            PlaySound('RTWarning', hInstance, SND_RESOURCE Or SND_ASYNC Or SND_LOOP);
          //sndPlaySound(nil, 0); // Stops the sound
          Form3.Visible:=False;
          With Form5 Do
            Begin
              SpeedButton3.Enabled:=True;
              Label1.Caption:=Memo1.Text;
              Visible:=True;
            End;
        End;
      If CheckBox4.Checked Then
        ShellExecute(Handle,'open',PChar(OpenDialog1.FileName),Nil,Nil,SW_SHOWNORMAL);
      If CheckBox5.Checked Then
        With Form4 Do
          Begin
            WaitUntilRun:=0;
            Form4.ComboBox1.ItemIndex:=Form3.ComboBox1.ItemIndex;
            //ComboBox1.ItemIndex:=9; //Quit Application
            Timer1.Enabled:=True;
            If Timer1.Enabled Then Form1.GridPanel1.ColumnCollection[11].Value:=50
            Else Form1.GridPanel1.ColumnCollection[11].Value:=0;
            ShowModal;
          End;
    End;
end;

end.
