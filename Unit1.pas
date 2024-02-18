unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, ImgList, Menus, Winsock, ShellApi,
  CommCtrl, IniFiles, ActiveX, Buttons, StrUtils;

type
  TForm1 = class(TForm)
    Label11: TLabel;
    Label4: TLabel;
    Label8: TLabel;
    TrackBar1: TTrackBar;
    PopupMenu1: TPopupMenu;
    Settings1: TMenuItem;
    Help1: TMenuItem;
    N4: TMenuItem;
    EmptyRecycleBin1: TMenuItem;
    Quit1: TMenuItem;
    Timer1: TTimer;
    ImageList1: TImageList;
    TrayIcon1: TTrayIcon;
    ListBox3: TListBox;
    N9: TMenuItem;
    Timer2: TTimer;
    ListBox1: TListBox;
    NetworkSettings1: TMenuItem;
    N1: TMenuItem;
    SetAlarm1: TMenuItem;
    Image1: TImage;
    Timer3: TTimer;
    HideClockfromTray1: TMenuItem;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    RefreshWorkarea1: TMenuItem;
    Timer4: TTimer;
    RefreshWorkarea2: TMenuItem;
    Help2: TMenuItem;
    Settings2: TMenuItem;
    NetworkSettings2: TMenuItem;
    N2: TMenuItem;
    SetAlarm2: TMenuItem;
    GridPanel1: TGridPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Image2: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    ProgressBar3: TProgressBar;
    ProgressBar4: TProgressBar;
    Label25: TLabel;
    Label26: TLabel;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    Label23: TLabel;
    Label24: TLabel;
    ProgressBar6: TProgressBar;
    ProgressBar5: TProgressBar;
    Label9: TLabel;
    Label2: TLabel;
    Label12: TLabel;
    ProgressBar7: TProgressBar;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label18: TLabel;
    Panel9: TPanel;
    Label14: TLabel;
    Label15: TLabel;
    Panel10: TPanel;
    Panel11: TPanel;
    Label3: TLabel;
    PopupMenu2: TPopupMenu;
    Delete1: TMenuItem;
    N3: TMenuItem;
    MovetoLeft1: TMenuItem;
    MovetoRight1: TMenuItem;
    Panel13: TPanel;
    Label13: TLabel;
    Minimizeallwindows1: TMenuItem;
    Mimimizeallwindows1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure Label5DblClick(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure Label6DblClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ProgressBar7MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ProgressBar7MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ProgressBar7MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Synchronizetime1Click(Sender: TObject);
    procedure EmptyRecycleBin1Click(Sender: TObject);
    procedure MiniMe(Sender: TObject);
    procedure MaxiMe(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
    procedure NetworkSettings1Click(Sender: TObject);
    procedure Label12DblClick(Sender: TObject);
    procedure SetAlarm1Click(Sender: TObject);
    procedure Quit1Click(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HideClockfromTray1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Help1Click(Sender: TObject);
    procedure RestartApplication1Click(Sender: TObject);
    procedure FixWorkArea;
    procedure RestoreWorkArea;
    procedure StoreWorkArea;
    procedure RefreshDesktop;
    procedure RefreshWorkarea1Click(Sender: TObject);
    procedure Label15DblClick(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure RefreshWorkarea2Click(Sender: TObject);
    procedure ShowBigClock(b:Boolean);
    procedure SetTransparency(i:Integer);
    procedure Minimizeallwindows1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure FormPaint(Sender: TObject);
(*    procedure DrawBar(ACanvas: TCanvas);
    procedure DrawItemText(X: integer;ACanvas: TCanvas;ARect: TRect;Text: string);
    procedure MenuDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);*)
  private
    { Private declarations }
    Setting:Boolean;
    Moving:Boolean;
    Delta:TPoint;
    Click:Boolean;
    Mute:Boolean;
    speedButton : Array of TSpeedButton;
    Procedure PopupItemClick(Sender:TObject);
    Procedure SpeedButtonClick(Sender:TObject);
    Procedure SpeedButtonMouseActivate(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y, HitTest: Integer; var MouseActivate: TMouseActivate);
    Procedure PopupDelete1Click(Sender:TObject);
    procedure FreeButtons(buttons : Array of TSpeedButton);
    Procedure ReadCustomMenu(f:String);
  public
    { Public declarations }
    BigClock:Boolean;
    Transparency:Integer;
    Procedure CitireSetari(f:String);
    procedure ScriereSetari(f:String);
    procedure ApplyNewColors;
  end;

Procedure SetProgressBarColor(ProgressBar:TProgressBar);

var
  Form1: TForm1;
  AlterneazaCuloarea: Boolean;

implementation

{$R *.dfm}

Uses AudioMixer, CoolThings, Unit2, NetworkSettings, Unit3, Unit4, Unit6, MultipleInstancePrevention,
  Unit7, Unit5;

var L,R,M:Integer;
    VD,MD:Boolean;
    Stereo,IsSelect:Boolean;
    AudioMixer1:TAudioMixer;
    TheGetCPUSpeed:Extended;
    StartTime,NowTime:TDateTime;
    fStoredWorkAreaRect:TRect;
    nrSB:Integer;

procedure TForm1.FreeButtons(buttons : array of TSpeedButton);
Var i : integer;
begin
   For i := Low(buttons) To High(buttons) Do
     Begin
       buttons[i].Free;
       buttons[i] := Nil;
     End;
end;

procedure TForm1.SetTransparency(i:Integer);
Begin
  AlphaBlendValue:=i;
End;

procedure TForm1.ShowBigClock(b: Boolean);
begin
  If b Then
    Begin
      GridPanel1.ColumnCollection.Items[8].Value:=0;
      GridPanel1.ColumnCollection.Items[10].Value:=220;
      Label3.Visible:=True;
      Label3.Font.Size:=18;
      //Label3.Left:=Form1.Width-Form1.Label3.Width-5;
      Label3.Left:=(Panel11.Width-Label3.Width) Div 2;
      Label14.Visible:=False;
      Label15.Visible:=False;
    End
  Else
    Begin
      GridPanel1.ColumnCollection.Items[8].Value:=100;
      GridPanel1.ColumnCollection.Items[10].Value:=0;
      Label3.Visible:=False;
      Label14.Visible:=True;
      Label15.Visible:=True;
    End;
end;

Procedure TForm1.CitireSetari(f:String);
Var
  ini:TIniFile;
begin
  ini:=TIniFile.Create(f);
  Try
    BackGroundColor:=ini.ReadInteger('Setari','BackGroundColor',clBlue);
    ColorOfTheFont:=ini.ReadInteger('Setari','ColorOfTheFont',clAqua);
    ActiveColorOfTheFont:=ini.ReadInteger('Setari','ActiveColorOfTheFont',clYellow);
    WarningColorOfTheFont:=ini.ReadInteger('Setari','WarningColorOfTheFont',clRed);
    BigClock:=ini.ReadBool('Setari','BigClock',True);
    ShowBigClock(BigClock);
    Transparency:=ini.ReadInteger('Setari','Transparency',200);
    ProgressBar1.Position:=Transparency;
  Finally
    ini.Free;
  End;
end;

procedure TForm1.Delete1Click(Sender: TObject);
Var c: TComponent;
begin
  //ShowMessage(TMenuItem(Sender).Caption+#13#13+InttoStr(TMenuItem(Sender).Tag));
  //ShowMessage(PopUpMenuSender);
  //TSpeedButton.
  //PopupMenuSender.
  c:= FindComponentEx('Form1.'+PopUpMenuSender);
//  If MessageDlg('Remove shortcut from Program bar?'#13+ c.Name, mtConfirmation, [mbYesNo],0) Then
    c.Free;
end;

Procedure TForm1.ScriereSetari(f:String);
Var
  ini:TIniFile;
begin
  ini:=TIniFile.Create(f);
  Try
    ini.WriteInteger('Setari','BackGroundColor',BackGroundColor);
    ini.WriteInteger('Setari','ColorOfTheFont',ColorOfTheFont);
    ini.WriteInteger('Setari','ActiveColorOfTheFont',ActiveColorOfTheFont);
    ini.WriteInteger('Setari','WarningColorOfTheFont',WarningColorOfTheFont);
    ini.WriteBool('Setari','BigClock',Form2.CheckBox4.Checked);
    ini.WriteInteger('Setari','Transparency',Form2.ProgressBar1.Max-Form2.ProgressBar1.Position);//Transparency
  Finally
    ini.Free;
  End;
end;

procedure TForm1.ApplyNewColors;
Begin
//  Form2.Shape1.Brush.Color:=BackGroundColor;
  Form1.Panel1.Color:=BackGroundColor;
  Form1.Panel2.Color:=BackGroundColor;
  Form1.Panel3.Color:=BackGroundColor;
  Form1.Panel4.Color:=BackGroundColor;
  Form1.Panel5.Color:=BackGroundColor;
  Form1.Panel6.Color:=BackGroundColor;
  Form1.Panel7.Color:=BackGroundColor;
  Form1.Panel8.Color:=BackGroundColor;
  Form1.Panel9.Color:=BackGroundColor;
  Form1.Panel10.Color:=BackGroundColor;
  Form1.Panel11.Color:=BackGroundColor;
  Form1.Panel13.Color:=BackGroundColor;
  Form1.Color:=BackGroundColor;
  Form2.Color:=BackGroundColor;
  Form3.Color:=BackGroundColor;
  Form4.Color:=BackGroundColor;
  Form5.Color:=BackGroundColor;
  Form6.Color:=BackGroundColor;
  Form7.Color:=BackGroundColor;
  Form3.LabeledEdit1.Color:=BackGroundColor;
  Form3.LabeledEdit2.Color:=BackGroundColor;
  Form3.LabeledEdit3.Color:=BackGroundColor;
  Form3.Memo1.Color:=BackGroundColor;
  Form3.DateTimePicker1.Color:=BackGroundColor;
  Form3.DateTimePicker2.Color:=BackGroundColor;
  Form3.ComboBox1.Color:=BackGroundColor;
  Form4.ComboBox1.Color:=BackGroundColor;
  Form7.MonthCalendar1.CalColors.MonthBackColor:=BackGroundColor;
  Form7.MonthCalendar1.CalColors.TitleTextColor:=BackGroundColor;
  NetworkSettingsForm.Color:=BackGroundColor;
  NetworkSettingsForm.ledAdapterDescription.Color:=BackGroundColor;
  NetworkSettingsForm.ledMACAddress.Color:=BackGroundColor;
  NetworkSettingsForm.ledSpeed.Color:=BackGroundColor;
  NetworkSettingsForm.ledStartedAt.Color:=BackGroundColor;
  NetworkSettingsForm.ledActiveFor.Color:=BackGroundColor;
  NetworkSettingsForm.ledOctInSec.Color:=BackGroundColor;
  NetworkSettingsForm.ledPeakINSec.Color:=BackGroundColor;
  NetworkSettingsForm.ledAvgINSec.Color:=BackGroundColor;
  NetworkSettingsForm.ledTotalIN.Color:=BackGroundColor;
  NetworkSettingsForm.ledOctOUTSec.Color:=BackGroundColor;
  NetworkSettingsForm.ledPeakOUTSec.Color:=BackGroundColor;
  NetworkSettingsForm.ledAvgOUTSec.Color:=BackGroundColor;
  NetworkSettingsForm.ledTotalOUT.Color:=BackGroundColor;
  NetworkSettingsForm.TrafficTabs.BackgroundColor:=BackGroundColor;
  NetworkSettingsForm.TrafficTabs.UnSelectedColor:=BackGroundColor;
///////
//  Form2.Shape2.Brush.Color:=ColorOfTheFont;
  Form1.Font.Color:=ColorOfTheFont;
  Form2.Font.Color:=ColorOfTheFont;
  Form3.Font.Color:=ColorOfTheFont;
  Form4.Font.Color:=ColorOfTheFont;
  Form5.Font.Color:=ColorOfTheFont;
  Form6.Font.Color:=ColorOfTheFont;
  Form7.Font.Color:=ColorOfTheFont;
  Form6.Shape1.Brush.Color:=ColorOfTheFont;
  Form6.Shape2.Brush.Color:=ColorOfTheFont;
  Form7.MonthCalendar1.CalColors.TextColor:=ColorOfTheFont;
  Form7.MonthCalendar1.CalColors.TitleBackColor:=ColorOfTheFont;
  NetworkSettingsForm.Font.Color:=ColorOfTheFont;
  NetworkSettingsForm.TrafficTabs.Font.Color:=ColorOfTheFont;
//////
//  Form2.Shape3.Brush.Color:=ActiveColorOfTheFont;
  Form7.MonthCalendar1.CalColors.TrailingTextColor:=ActiveColorOfTheFont;
  NetworkSettingsForm.TrafficTabs.SelectedColor:=ActiveColorOfTheFont;
//////
//  Form2.Shape4.Brush.Color:=WarningColorOfTheFont;
End;

procedure TForm1.FixWorkArea;
const MYHEIGHT=28;
var rcWork: TRect;
begin
  SystemParametersInfo(SPI_GETWORKAREA, 0, @rcWork, 0);
  //rcWork.Top := rcWork.Top + MYHEIGHT;
  rcWork.Top := 0 + MYHEIGHT;
  SystemParametersInfo(SPI_SETWORKAREA, 0, @rcwork, 0);
  RefreshDesktop;
end;

procedure TForm1.RestoreWorkArea;
begin
  SystemParametersInfo(SPI_SETWORKAREA, 0, @fStoredWorkAreaRect, 0);
end;

procedure TForm1.StoreWorkArea;
begin
  SystemParametersInfo(SPI_GETWORKAREA, 0, @fStoredWorkAreaRect, 0);
  fStoredWorkAreaRect.top:=0;
end;

procedure TForm1.RefreshDesktop;
begin
  InvalidateRect(0, nil, FALSE);
end;

procedure TForm1.RefreshWorkarea1Click(Sender: TObject);
begin
  RefreshDesktop;
end;

procedure TForm1.RefreshWorkarea2Click(Sender: TObject);
begin
  FixWorkArea;
end;

Procedure SetProgressBarColor(ProgressBar:TProgressBar);
Begin
  If ProgressBar.Position>Round(ProgressBar.Max*75/100) Then
    SendMessage(ProgressBar.Handle,PBM_SETBARCOLOR,0,WarningColorOfTheFont)
  Else If ProgressBar.Position>Round(ProgressBar.Max*50/100) Then
    SendMessage(ProgressBar.Handle,PBM_SETBARCOLOR,0,ActiveColorOfTheFont)
  Else
    SendMessage(ProgressBar.Handle,PBM_SETBARCOLOR,0,ColorOfTheFont);
End;

Procedure TForm1.SpeedButtonClick(Sender:TObject);
Var s: String;
Begin
  If Sender is TSpeedButton Then
    Begin
      s:= TSpeedButton(Sender).Hint;
      Delete(s, 1, Pos('[', s));
      Delete(s, Pos(']', s), Length(s));
      If s<> '' Then
        ShellExecute(Handle,'open',PChar(s),Nil,Nil,SW_SHOWNORMAL);
    End;
End;

Procedure TForm1.PopupDelete1Click(Sender:TObject);
Begin
  ShowMessage('Delete');   // >>> de unde a aparut asta?
End;

Procedure TForm1.PopupItemClick(Sender:TObject);
Var menuItem:TMenuItem;
    b:TBitmap;
    i:Integer;
    AllowCreation:Boolean;
    s: String;
begin
  If Not (Sender is TMenuItem) Then
     Begin
       ShowMessage('Hm, if this was not called by Menu Click, who called this?!');
       ShowMessage(Sender.ClassName);
       Exit;
     End;
   menuItem:=TMenuItem(Sender);
   AllowCreation:=True;
   If nrSB>0 Then
     For i:=1 To nrSB Do
       Begin
         s:= SpeedButton[i].Hint;
         Delete(s, 1, Pos('[',s));
         Delete(s, Pos(']',s), Length(s));
         If menuItem.Hint= s Then
           Begin
             AllowCreation:=False;
             Break;
           End;
       End;
   If AllowCreation Then
     Begin
       Inc(nrSB);  //3+23
       If (2 + (3 + 18)*(nrSB - 1))<=Panel10.Width Then
         Begin
           Speedbutton[nrSB] := TSpeedButton.Create(Self) ;
           //if no parent is set, button will not be visible!
           Speedbutton[nrSB].Parent := Panel10; //TPanel
           //assign the OnClick event handler
           SpeedButton[nrSB].Hint := StringReplace(menuItem.Caption,'&','',[rfReplaceAll])+#13+'['+menuItem.Hint+']';
           SpeedButton[nrSB].ShowHint:= True;
           Inc(LastTagForSpeedButton);
           SpeedButton[nrSB].Tag := LastTagForSpeedButton;
           SpeedButton[nrSB].Name := 'SB'+AddZero(LastTagForSpeedButton,2);
           Speedbutton[nrSB].OnClick := SpeedButtonClick;
           SpeedButton[nrSB].OnMouseActivate := SpeedButtonMouseActivate;
           Speedbutton[nrSB].SetBounds (5 + 18 * Pred(nrSB), 5, 18, 18);
           SpeedButton[nrSB].Transparent := True;
           SpeedButton[nrSB].Flat := True;
           SpeedButton[nrSB].Cursor := crHandPoint;
           SpeedButton[nrSB].PopupMenu := PopupMenu2;
           //
//           speedButton[nrSB].Tag:=0;
//           speedButton[nrSB].GroupIndex:=1;
//           speedButton[nrSB].Down:=False;
//           speedButton[nrSB].Visible:=True;
           //
           b:=TBitmap.Create;
           ImageList1.GetBitmap(menuItem.ImageIndex,b);
           b.SaveToFile(GetTempDirectory+'saved.bmp');
           SpeedButton[nrSB].Glyph.Assign(b);
           SpeedButton[nrSB].Glyph.TransparentColor:=b.Canvas.Pixels[1,1];//Rgb(1,1,1);
//           SpeedButton[nrSB].ShowHint:=True;
           b.Free;
         End;
     End;
  //If AnsiStartsStr(LowerCase('cmd.exe '),LowerCase(menuItem.Hint)) Then
  //  Begin
  //    //ShellExecute(Handle,'open',PChar('cmd.exe'),PChar(AnsiRightStr(menuItem.Hint,Length(menuItem.Hint)-Length('cmd.exe '))),Nil,SW_SHOWNORMAL);
  //    ShellExecute(Handle,'open','"%windir%\network diagnostic\xpnetdiag.exe"',Nil,Nil,SW_SHOWNORMAL);
  //    //ShowMessage(AnsiRightStr(menuItem.Hint,Length(menuItem.Hint)-Length('cmd.exe ')));
  //  End
  //Else
    ShellExecute(Handle,'open',PChar(menuItem.Hint),Nil,Nil,SW_SHOWNORMAL)
   //ShowMessage(menuItem.Hint);
   //WinExec(PChar(menuItem.Hint),SW_NORMAL);
end;

procedure TForm1.PopupMenu1Popup(Sender: TObject);
begin
//  BringToFront();
  Form1.PopupMenu:=PopupMenu1;
end;

Procedure TForm1.SpeedButtonMouseActivate(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y, HitTest: Integer; var MouseActivate: TMouseActivate);
Begin
  PopUpMenuSender:= TSpeedButton(Sender).Name;
  //Label9.Tag    :=          TSpeedButton(Sender).Tag;
  //Label9.Caption:= IntToStr(TSpeedButton(Sender).Tag);
End;

procedure TForm1.PopupMenu2Popup(Sender: TObject);
begin
//  PopUpMenuSender:= TMenuItem(Sender).Name;
end;

(*procedure TForm1.DrawBar(ACanvas: TCanvas);
var
  lf : TLogFont;
  tf : TFont;
begin
  with ACanvas do begin
    Brush.Color := clGray;
    FillRect(Rect(0,0,20,185)); //0,0,20,150
    Font.Name := 'Tahoma';
    Font.Style := Font.Style + [fsBold];
    Font.Color := clWhite;
    tf := TFont.Create;
    try
      tf.Assign(Font);
      GetObject(tf.Handle, sizeof(lf), @lf);
      lf.lfEscapement := 900;
      lf.lfHeight := Font.Height - 2;
      tf.Handle := CreateFontIndirect(lf);
      Font.Assign(tf);
    finally
      tf.Free;
    end;
    TextOut(2, 175, 'stedanarh.wordpress.com');//2,115
  end;
end;

procedure TForm1.DrawItemText(X: integer;ACanvas: TCanvas;ARect: TRect;Text: string);
begin
 ARect.Left:=X;
 DrawText(ACanvas.Handle,PChar(Text),-1,ARect,DT_LEFT or DT_VCENTER or DT_SINGLELINE or DT_NOCLIP);
end;

procedure TForm1.MenuDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
var ImgID:Integer;
    menuItem:TMenuItem;
begin
  if Selected then
    ACanvas.Brush.Color:=ActiveColorOfTheFont
  else
    ACanvas.Brush.Color:=BackGroundColor;
  ARect.Left:=0;//20
  ACanvas.FillRect(ARect);
//  if mnuBold.Checked then
//    ImgID := 1
//  else
//    ImgID := 0;
//  ImageList1.Draw(ACanvas,22,ARect.Top + 2,ImgID);
//  ACanvas.Font.Style := [fsBold];
  menuItem:=TMenuItem(Sender);
  If TMenuItem(Sender).Caption<>'-' Then
    DrawItemText(25,ACanvas,ARect,TMenuItem(Sender).Caption)//45
  Else
    //
 //when all the menu items are drawn we draw the 'delphi.about.com' bar
 DrawBar(ACanvas);

end;*)

Procedure TForm1.ReadCustomMenu(f:String);
Var ini:TIniFile;
    i,j,Pos:Integer;
    sC,sH:String;
    Menu,Sub:TMenuItem;
    SmallIcon:HICON;
    Bmp,resizedBmp:TBitmap;
    stretchrect:TRect;
    PosIcon:Integer;
begin
  If FileExists(f) Then
    Begin
      ListBox3.Clear;
      ini:=TIniFile.Create(f);
      Pos:=7;
      PosIcon:=0;
      Try
        ini.ReadSections(ListBox3.Items);
        Menu:=TMenuItem.Create(Self);
        Menu.Caption:='-';
        Menu.Tag:=GetTickCount;
        //Sub:=TMenuItem.Create(Self);
        //Menu.Add(Sub);
        PopupMenu1.Items.Insert(Pos,Menu);
        Inc(Pos);
        For j:=0 To ListBox3.Items.Capacity-1 Do
          Begin
            ListBox1.Clear;
            ini.ReadSection(ListBox3.Items[j],ListBox1.Items);
            Menu:=TMenuItem.Create(Self);
            Menu.Caption:=ListBox3.Items[j];
            Menu.Tag:=GetTickCount;
            For i:=1 To ListBox1.Items.Capacity Do
              Begin
                Sub:=TMenuItem.Create(Self);
                sC:=ini.ReadString(ListBox3.Items[j],'N'+IntToStr(i),'...');
                sH:=ini.ReadString(ListBox3.Items[j],'C'+IntToStr(i),'...');
                If (sC<>'...') And (sH<>'...') Then
                  Begin
                    Sub.Caption:=sC;
                    Sub.Hint:=sH;
                    Sub.Tag:=GetTickCount;
                    Sub.OnClick:=PopupItemClick;
                    (*Sub.OnDrawItem:=MenuDrawItem;*)
                    Menu.Add(Sub);
//////////////////////////////////////
                    If sh<>'-' Then
                      Begin
                        Image1.Picture:=Nil;
                        GetAssociatedIcon(SearchInWinDir(sH),nil,@SmallIcon);
                        if SmallIcon<>0 then
                          Begin
                            Icon.Handle:=SmallIcon;
                            DrawIcon(Image1.Canvas.Handle,0,0,SmallIcon);
                            Bmp:=TBitmap.Create;
                            resizedBmp:=TBitmap.Create;
                            PopupMenu1.Images:=ImageList1;
                            try
                              Bmp.Assign(Image1.Picture);
                              stretchRect.Left:=0;
                              stretchRect.Top:=0;
                              stretchRect.Right:=16;
                              stretchRect.Bottom:=16;
                              resizedBmp.Width:=16;
                              resizedBmp.height:=16;
                              resizedBmp.Canvas.StretchDraw(stretchrect,Bmp);
                              try
                                ImageList1.AddMasked(resizedBmp,Rgb(1,1,1));//resizedBmp.TransparentColor);
                                Inc(PosIcon);
                                ImageList1.GetIcon(PosIcon,Icon);
                              finally
                              end;
                              Sub.ImageIndex:=PosIcon;
                            finally
                              Bmp.Free;
                              resizedBmp.Free;
                            end;
                          End;
                      End;
//////////////////////////////////////
                  End;
              End;
            PopupMenu1.Items.Insert(Pos,Menu);
            Inc(Pos);
          End;
      Finally
        ini.Free;
      End;
    End;
end;

procedure TForm1.RestartApplication1Click(Sender: TObject);
Var FullProgPath:PChar;
begin
//  MultipleInstance.Free;
  Form1.Caption:='CIT - modificat ca sa poata reporni aplicatia';
  FullProgPath:=PChar(Application.ExeName);
  WinExec(FullProgPath, SW_SHOW); // Or better use the CreateProcess function
  Application.Terminate;// or:Close;
end;

procedure TForm1.MiniMe(Sender: TObject);
begin
  If Form2.CheckBox1.Checked Then
    Begin
      Timer2.Enabled:=True;
      Timer3.Enabled:=False;
    End;
end;

procedure TForm1.Minimizeallwindows1Click(Sender: TObject);
Var h: HWnd;
begin
  h := Handle; 
  while h > 0 do 
  begin 
    if IsWindowVisible(h) then 
      PostMessage(h, WM_SYSCOMMAND, SC_MINIMIZE, 0); 
    h := GetNextWindow(h, GW_HWNDNEXT);
  end; 
end;

procedure TForm1.MaxiMe(Sender: TObject);
begin
  If Form2.CheckBox1.Checked Then
    Begin
      Timer2.Enabled:=False;
      Timer3.Enabled:=True;
    End;
end;

Procedure EmptyRecycleBin;
Const SHERB_NOCONFIRMATION=$00000001;
      SHERB_NOPROGRESSUI=$00000002;
      SHERB_NOSOUND=$00000004;
Type TSHEmptyRecycleBin=function(Wnd: HWND; pszRootPath: PChar; dwFlags: DWORD): HRESULT;  stdcall;
Var SHEmptyRecycleBin:TSHEmptyRecycleBin;
    LibHandle:THandle;
begin  { EmptyRecycleBin }
  LibHandle:=LoadLibrary(PChar('Shell32.dll'));
  If LibHandle<>0 Then
    @SHEmptyRecycleBin:=GetProcAddress(LibHandle,'SHEmptyRecycleBinA')
  Else
    begin
      MessageDlg('Failed to load Shell32.dll.', mtError, [mbOK], 0);
      Exit;
    end;
  If @SHEmptyRecycleBin <> nil then
    SHEmptyRecycleBin(Application.Handle,nil,SHERB_NOCONFIRMATION or SHERB_NOPROGRESSUI or SHERB_NOSOUND);
  FreeLibrary(LibHandle);
  @SHEmptyRecycleBin:=nil;
end;

procedure TForm1.EmptyRecycleBin1Click(Sender: TObject);
begin
(*  EmptyRecycleBin;*)
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
  ApplyNewColors;
  SetTransparency(Transparency);
end;

procedure TForm1.FormClick(Sender: TObject);
begin
//  PopupMenu:=PopupMenu1;
  //RefreshDesktop;
  FixWorkArea;
end;

procedure TForm1.FormCreate(Sender: TObject);
Var Host,IP,Err:String;
begin
  Label10.Caption:='Running OS: '+GetWinVersion + ' '+IsWOW64;
  Label10.Hint:=GetWindowsVersion;
  SetLength(speedbutton,30);
  FreeButtons(speedbutton);
  nrSB:=0;
  CitireSetari(ExtractFilePath(ParamStr(0))+'settings.ini');
  Form1.Caption:='CIT v1.0';// - modificat ca sa poata reporni aplicatia';
  AddFontResource('swisscl.ttf') ;
  SendMessage(HWND_BROADCAST,WM_FONTCHANGE,0,0);
  SetActivePartition(True);
  Application.OnDeactivate:=MiniMe;
  Application.OnActivate:=MaxiMe;
  Click:=False;
  StartTime:=Now();
  Left:=0;//(Screen.Width-Width) Div 2;
  Width:=Screen.Width;
  Top:=0;
  Height:=28;
  AudioMixer1:=TAudioMixer.Create(Form1);
  With AudioMixer1 Do
    begin
      Parent:=Form1;  // this is important
      Name:='AudioMixer1';
      GetVolume(0,-1,L,R,M,Stereo,VD,MD,IsSelect);
      Setting:=True;
      TrackBar1.Visible:=Not VD;
      If TrackBar1.Visible then
        TrackBar1.Position:=TrackBar1.Max-Round(L*100/65535);
      GetMute(0,-1,Mute);
      If Mute Then
        Label12.Caption:='Volume muted'
      Else
        Label12.Caption:=Format('Volume %2d %%',[Round((TrackBar1.Max-TrackBar1.Position)*100/TrackBar1.Max)]);
      ProgressBar7.Max:=TrackBar1.Max;
      ProgressBar7.Position:=TrackBar1.Max-TrackBar1.Position;
      ProgressBar7.Cursor:=crHSplit;
      Setting:=False;
    end;
  TheGetCPUSpeed:=GetCPUSpeed;
  Label11.Caption:='IP: '+GetLocalIP;
  If GetIPFromHost(Host,IP,Err) Then
    Label11.Hint:='Host: '+Host+', Host IP: '+IP
  Else
    Label11.Hint:='Error, '+Err;
  ProgressBar3.Max:=Round(10000);
  ProgressBar4.Max:=Round(10000);
  SetAttributes(Label8,IsRunningInsideVirtualPC);
  Label5.Hint:='CapsLock state'#13'Double click to inverse';
  Label6.Hint:='NumLock state'#13'Double click to inverse';
  Label7.Hint:='ScrollLock state'#13'Double click to inverse';
  Label18.Hint:='Insert state';
  Label14.Hint:='System time'#13'Double click to syncronize';
  Label15.Hint:='Current date'#13'Double click to show month calendar';
  ProgressBar1.Brush.Color:=clBlue;
  SendMessage(ProgressBar1.Handle,PBM_SETBARCOLOR,0,ColorOfTheFont);
  ProgressBar2.Brush.Color:=clBlue;
  SendMessage(ProgressBar2.Handle,PBM_SETBARCOLOR,0,ColorOfTheFont);
  ProgressBar3.Brush.Color:=clBlue;
  SendMessage(ProgressBar3.Handle,PBM_SETBARCOLOR,0,ColorOfTheFont);
  ProgressBar4.Brush.Color:=clBlue;
  SendMessage(ProgressBar4.Handle,PBM_SETBARCOLOR,0,ColorOfTheFont);
  ProgressBar5.Brush.Color:=clBlue;
  SendMessage(ProgressBar5.Handle,PBM_SETBARCOLOR,0,ColorOfTheFont);
  ProgressBar6.Brush.Color:=clBlue;
  SendMessage(ProgressBar6.Handle,PBM_SETBARCOLOR,0,ColorOfTheFont);
  ProgressBar7.Brush.Color:=clBlue;
  SendMessage(ProgressBar7.Handle,PBM_SETBARCOLOR,0,ColorOfTheFont);
  Timer1Timer(Sender);
  ReadCustomMenu(ExtractFilePath(ParamStr(0))+'menu.ini');
  StoreWorkArea;
  FixWorkArea;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  RemoveFontResource('swisscl.ttf');
  SendMessage(HWND_BROADCAST,WM_FONTCHANGE,0,0);
  RestoreWorkArea;
  RefreshDesktop;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
//  If Not Form2.CheckBox1.Checked Then
//    If Button=mbLeft Then
//      Begin
//        Moving:=True;
//        Delta:=Point(X,Y);
//      End;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
//Const SnapSize:Integer=25;
//Var l,t:Integer;
//    WorkRect:TRect;
begin
//  If Not Form2.CheckBox1.Checked Then
//    Begin
//      If Moving Then // You should add support for DualHead/Matrox Configurations
//        Begin
//          If Not SystemParametersInfo(SPI_GETWORKAREA,0,@WorkRect,0) Then
//            WorkRect:=Bounds(0,0,Screen.Width,Screen.Height);
//          Dec(WorkRect.Right,Width);
//          Dec(WorkRect.Bottom,Height);
//          l:=Left+X-Delta.X;
//          t:=Top+Y-Delta.Y;
//          If (l<WorkRect.Left+SnapSize) And (l>WorkRect.Left-SnapSize) Then
//            l:=WorkRect.Left;
//          If (l>WorkRect.Right-SnapSize) And (l<WorkRect.Right+SnapSize) Then
//            l:=WorkRect.Right;
//          If (t<WorkRect.Top+SnapSize) And (t>WorkRect.Top-SnapSize) Then
//            t:=WorkRect.Top;
//          If (t>WorkRect.Bottom-SnapSize) And (t<WorkRect.Bottom+SnapSize) Then
//            t:=WorkRect.Bottom;
//          Left:=l;  // NOTE: This will always "Show window
//          Top:=t;   // contents while dragging"
//        End;
//    End;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
//  If Not Form2.CheckBox1.Checked Then
//    Moving:=False;
end;

procedure TForm1.FormPaint(Sender: TObject);
Var Row,Ht:Word;
    r,g,b:Byte;
begin
{  Ht:=(ClientHeight+255) div 256;
  for Row:=0 to ClientHeight do
    with Canvas do
      begin
        r:=Row*(GetRValue(Form2.Shape1.Brush.Color)-
                GetRValue(Form2.Shape2.Brush.Color)) Div ClientHeight;
        g:=Row*(GetGValue(Form2.Shape1.Brush.Color)-
                GetGValue(Form2.Shape2.Brush.Color)) Div ClientHeight;
        b:=Row*(GetBValue(Form2.Shape1.Brush.Color)-
                GetBValue(Form2.Shape2.Brush.Color)) Div ClientHeight;
        Brush.Color:=RGB(r,g,b);
        FillRect(Rect(0,Row*Ht,ClientWidth,(Row+1)*Ht));
      end;}
end;

procedure TForm1.FormShow(Sender: TObject);
Var i:Integer;
begin
  For i:=0 To ComponentCount-1 Do
    If Components[i] Is TLabel Then
      Begin
        (Components[i] As TLabel).Font.Name:='Swiss 721 Light Condensed BT';
        (Components[i] As TLabel).Font.Size:=8;
      End;
end;

procedure TForm1.Help1Click(Sender: TObject);
begin
  Form6.ShowModal;
end;

procedure TForm1.HideClockfromTray1Click(Sender: TObject);
begin
(*  If HideClockfromTray1.Checked Then
    ShowWindow(FindWindowEx(FindWindowEx(FindWindow('Shell_TrayWnd',Nil),HWND(0),'TrayNotifyWnd',Nil),HWND(0),'TrayClockWClass',nil),Sw_Hide)
  Else
    ShowWindow(FindWindowEx(FindWindowEx(FindWindow('Shell_TrayWnd',Nil),HWND(0),'TrayNotifyWnd',Nil),HWND(0),'TrayClockWClass',nil),Sw_Show);
  HideClockfromTray1.Checked:=Not HideClockfromTray1.Checked;*)
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
  PopupMenu1.Popup(Form1.Left+Image2.Left,Form1.Top+Image2.Top);
end;

procedure TForm1.Synchronizetime1Click(Sender: TObject);
var SEInfo: TShellExecuteInfo;
    ExitCode: DWORD;
begin
  Label14.Font.Color:=ActiveColorOfTheFont;
  Label14.Font.Style:=[fsBold];
  Label14.Caption:='Synchronize...';
  FillChar(SEInfo, SizeOf(SEInfo), 0) ;
  SEInfo.cbSize := SizeOf(TShellExecuteInfo) ;
  with SEInfo do begin
    fMask := SEE_MASK_NOCLOSEPROCESS;
    Wnd := Application.Handle;
    lpFile := PChar('w32tm') ;
    lpParameters := PChar('/resync') ;   {ParamString can contain the application parameters. }
    lpDirectory := PChar(ExtractFilePath(ParamStr(0)));  {StartInString specifies the name of the working directory. If ommited, the current directory is used.}
  end;
  if ShellExecuteEx(@SEInfo) then begin
    repeat
      Application.ProcessMessages;
      GetExitCodeProcess(SEInfo.hProcess, ExitCode) ;
    until (ExitCode <> STILL_ACTIVE) or Application.Terminated;
  end;
  Label14.Font.Color:=ColorOfTheFont;
  Label14.Font.Style:=[];
  //net start w32time
  //w32tm /resync
end;

procedure TForm1.Label12DblClick(Sender: TObject);
begin
  AudioMixer1.GetMute(0,-1,Mute);
  Mute:=Not Mute;
  AudioMixer1.SetMute(0,-1,Mute);
  If Mute Then
    Label12.Caption:='Volume muted'
  Else ;
end;

procedure TForm1.Label15DblClick(Sender: TObject);
begin
  With Form7 Do
    Begin
      If Label15.Visible Then
        Left:=Form1.Left+Label15.Left
      Else
        Left:=Form1.Width-Form7.Width;
      Top:=Form1.Top+Form1.Height;
      ShowModal;
    End;
end;

procedure TForm1.Label5DblClick(Sender: TObject);
begin
  SetLedState(ktCapsLock,Not ISCapsLockOn);
end;

procedure TForm1.Label6DblClick(Sender: TObject);
begin
  SetLedState(ktNumLock,Not ISNumLockOn);
end;

procedure TForm1.Label7Click(Sender: TObject);
begin
  SetLedState(ktScrollLock,Not ISScrollLockOn);
end;

procedure TForm1.NetworkSettings1Click(Sender: TObject);
begin
  NetworkSettingsForm.ShowModal;
end;

procedure TForm1.ProgressBar7MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Click:=True;
  ProgressBar7MouseMove(Sender,Shift,X,Y);
end;

procedure TForm1.ProgressBar7MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
Var newPosition:Integer;
begin
  If Click Then
    Begin
      newPosition:=Round(x*ProgressBar7.Max/ProgressBar7.ClientWidth);
      ProgressBar7.Position:=newPosition;
      TrackBar1.Position:=TrackBar1.Max-newPosition;
    End;
  AudioMixer1.GetMute(0,-1,Mute);
  If Mute Then
    Label12.Caption:='Volume muted'
  Else
    Label12.Caption:=Format('Volume %2d %%',[Round((TrackBar1.Max-TrackBar1.Position)*100/TrackBar1.Max)]);
  SetProgressBarColor(ProgressBar7);
end;

procedure TForm1.ProgressBar7MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Click:=False;
end;

procedure TForm1.Quit1Click(Sender: TObject);
begin
  With Form4 Do
    Begin
      WaitUntilRun:=10;
      ComboBox1.ItemIndex:=9; //Quit Application
      Timer1.Enabled:=True;
      ShowModal;
    End;
end;

procedure TForm1.SetAlarm1Click(Sender: TObject);
begin
  Form3.ShowModal;
end;

procedure TForm1.Settings1Click(Sender: TObject);
begin
  ProgressBar1.Position:=Transparency;
  Form2.ShowModal;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
Var Temp,TheTotalMemory:Extended;
    WindowsStartTime:String;
begin
  Label2.Caption:='Resolution '+IntToSTr(Screen.Width)+'x'+IntToStr(Screen.Height);
  EmptyRecycleBin1.Enabled:=Not RecycleBinIsEmpty;
  AudioMixer1.GetVolume (0,-1,L,R,M,Stereo,VD,MD,IsSelect);
  Setting:=True;
  If TrackBar1.Visible Then
    Begin
      TrackBar1.Position:=Round(TrackBar1.Max-(L*100/65535));
      ProgressBar7.Position:=ProgressBar7.Max-TrackBar1.Position;
    End;
  AudioMixer1.GetMute(0,-1,Mute);
  If Mute Then
    Label12.Caption:='Volume muted'
  Else
    Label12.Caption:=Format('Volume %2d %%',[Round((TrackBar1.Max-TrackBar1.Position)*100/TrackBar1.Max)]);
  Setting:=False;
  NowTime:=Now();
  Label1.Caption:=UpTime(WindowsStartTime);
  Label1.Hint:=WindowsStartTime;//+#13+
//               'Surveillance: 00d '+AddZeroS(FormatDateTime('h',NowTime-StartTime),2)+':'+
//                                    AddZeroS(FormatDateTime('n',NowTime-StartTime),2)+':'+
//                                    AddZeroS(FormatDateTime('s',NowTime-StartTime),2);
  Temp:=UsedMemory;
  TheTotalMemory:=TotalMemory;
  Label19.Caption:=Format('RAM %4.0f/%4.0f MB',[Temp,TheTotalMemory]);
  Label19.Hint:=Format('RAM: %2d%%',[Round(Temp*100/TheTotalMemory)]);
  ProgressBar3.Hint:=Format('RAM: %2d%%',[Round(Temp*100/TheTotalMemory)]);
  ProgressBar3.Position:=Round(Temp*10000/TheTotalMemory);
  Temp:=GiveCPUUsage;
  If TheGetCPUSpeed<>0 Then
    Begin
      Label20.Caption:=Format('CPU %4.0f/%4.0f MHz',[Temp*TheGetCPUSpeed/100,TheGetCPUSpeed]);
      Label20.Hint:=Format('CPU: %2d%%',[Round(Temp)]);
      ProgressBar4.Hint:=Format('CPU: %2d%%',[Round(Temp)]);
    End;
  ProgressBar4.Position:=Round(Temp*TheGetCPUSpeed*10000/100/TheGetCPUSpeed);
  Label9.Caption:=GiveSystemPowerStatus;
  /////////////////////////////////
  SetAttributes(Label10,False);
  SetAttributes(Label1,False);
  SetAttributes(Label20,False);
  SetAttributes(Label19,False);
  SetAttributes(Label25,False);
  SetAttributes(Label26,False);
  SetAttributes(Label24,False);
  SetAttributes(Label23,False);
  SetAttributes(Label2,False);
  SetAttributes(Label9,False);
  SetAttributes(Label12,False);
  If AlterneazaCuloarea Then
    SetAttributes(Label13,False);
  Label13.Font.Size:=18;
  Label13.Font.Style:=[fsBold];
  SetAttributes(Label14,False);
  SetAttributes(Label15,False);
  SetAttributes(Label3,False);
  /////////////////////////////////
  SetAttributes(Label5,ISCapsLockOn);
  SetAttributes(Label6,IsNumLockOn);
  SetAttributes(Label7,IsScrollLockOn);
  SetAttributes(Label4,IsRemotelyControlled);
  SetAttributes(Label18,InsertOn);
  Label14.Caption:=AddZeroS(FormatDateTime('hh',NowTime),2)+':'+
                   AddZeroS(FormatDateTime('nn',NowTime),2)+':'+
                   AddZeroS(FormatDateTime('ss',NowTime),2)+' '+
                   GetTimeZone;
  Label3.Caption:=AddZeroS(FormatDateTime('yyyy',NowTime),4)+'-'+
                  AddZeroS(FormatDateTime('mm',NowTime),2)+'-'+
                  AddZeroS(FormatDateTime('dd',NowTime),2)+' '+
                  AddZeroS(FormatDateTime('hh',NowTime),2)+':'+
                  AddZeroS(FormatDateTime('nn',NowTime),2)+':'+
                  AddZeroS(FormatDateTime('ss',NowTime),2);
  Label3.Font.Size:=18;
  Label3.Font.Style:=[fsBold];
  //Label3.Left:=Form1.Width-Label3.Width-5;
  Label3.Left:=(Panel11.Width-Label3.Width) Div 2;
  If Label14.Font.Color=ActiveColorOfTheFont Then
    Label14.Caption:='Synchronize...';
  Label15.Caption:=FormatDateTime('ddd',NowTime)+', '+
                   AddZeroS(FormatDateTime('mm',NowTime),2)+'/'+
                   AddZeroS(FormatDateTime('dd',NowTime),2)+'/'+
                   AddZeroS(FormatDateTime('yyyy',NowTime),4);
  //SetActivePartition(True); - moved to form create
  GetFreeSpace;
  SetProgressBarColor(ProgressBar1);
  SetProgressBarColor(ProgressBar2);
  SetProgressBarColor(ProgressBar3);
  SetProgressBarColor(ProgressBar4);
  SetProgressBarColor(ProgressBar5);
  SetProgressBarColor(ProgressBar6);
  SetProgressBarColor(ProgressBar7);
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  If Form2.CheckBox1.Checked Then
//    If CheckBox1.Checked Then
      Begin
        If Top<=2-Height Then
          Begin
            Timer2.Enabled:=False;
          End
        Else
          Top:=Top-2;
      End
(*    Else
      Begin
        If Top>=0 Then
          Begin
            Timer2.Enabled:=False;
            CheckBox1.Checked:=True;
          End
        Else
          Top:=Top+2;
      End;*)
end;

procedure TForm1.Timer3Timer(Sender: TObject);
begin
  If Form2.CheckBox1.Checked Then
(*    If CheckBox1.Checked Then
      Begin
        If Top<=2-Height Then
          Begin
            Timer2.Enabled:=False;
            CheckBox1.Checked:=False;
          End
        Else
          Top:=Top-2;
      End
    Else*)
      Begin
        If Top>=0 Then
          Begin
            Timer2.Enabled:=False;
          End
        Else
          Top:=Top+2;
      End;
end;

procedure TForm1.Timer4Timer(Sender: TObject);
begin
  FixWorkArea;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  If (not Setting) then
    begin
      Setting:=True;//ExTrackBar1.Position:=Round(L*100/65535);
      AudioMixer1.SetVolume (0,-1,Round((TrackBar1.Max-TrackBar1.Position)*65535/100),
                                  Round((TrackBar1.Max-TrackBar1.Position)*65535/100),Integer(False));
      AudioMixer1.GetMute(0,-1,Mute);
      If Mute Then
        Label12.Caption:='Volume muted'
      Else
        Label12.Caption:=Format('Volume %2d %%',[Round((TrackBar1.Max-TrackBar1.Position)*100/TrackBar1.Max)]);
      ProgressBar7.Position:=TrackBar1.Max-TrackBar1.Position;
      SetProgressBarColor(ProgressBar7);
      Setting:=False;
    end;
end;

Initialization
  LastTagForSpeedButton:= 10000;

end.



(*
var
  ndays: double;
  ticks: LongInt;
  btime: TDateTime;
begin
  {The GetTickCount function retrieves the number of
   milliseconds that have elapsed since Windows was started.}
  ticks := GetTickCount;

  {to convert this to the number of days, divide by number of
   milliseconds in a day, 24*60*60*1000=86400000}
  ndays := ticks/86400000;

  {to calculate the boot time we subtract the
   number-of-days-since-boot from the DateTime now.
   This works because a TDateTime is a double value
   which holds days and decimal days}
  bTime := now-ndays;

  {display the message}
  ShowMessage(
   FormatDateTime('"Windows started on" dddd, mmmm d, yyyy, ' +
                  '"at" hh:nn:ss AM/PM', bTime) + #10#13 +
   'Its been up for ' + IntToStr(Trunc(nDays)) + ' days,' +
   FormatDateTime(' h "hours," n "minutes," s "seconds"',ndays));
*)


(*
procedure TForm1.Button1Click(Sender: TObject) ;

  function FuncAvail(_dllname, _funcname: string;
                     var _p: pointer): boolean;
  {return True if _funcname exists in _dllname}
  var _lib: tHandle;
  begin
   Result := false;
   if LoadLibrary(PChar(_dllname)) = 0 then exit;
   _lib := GetModuleHandle(PChar(_dllname)) ;
   if _lib <> 0 then begin
    _p := GetProcAddress(_lib, PChar(_funcname)) ;
    if _p <> NIL then Result := true;
   end;
  end;

  {
  Call SHELL32.DLL for Win < Win98
  otherwise call URL.dll
  }
  {button code:}
  var
   InetIsOffline : function(dwFlags: DWORD):
                   BOOL; stdcall;
  begin
   if FuncAvail('URL.DLL', 'InetIsOffline',
                @InetIsOffline) then
    if InetIsOffLine(0) = true
     then ShowMessage('Not connected')
     else ShowMessage('Connected!') ;
  end;
*)

(*
function PtInPoly
   (const Points: Array of TPoint; X,Y: Integer):
   Boolean;
var Count, K, J : Integer;
begin
  Result := False;
  Count := Length(Points) ;
  J := Count-1;
  for K := 0 to Count-1 do begin
   if ((Points[K].Y <=Y) and (Y < Points[J].Y)) or
      ((Points[J].Y <=Y) and (Y < Points[K].Y)) then
   begin
    if (x < (Points[j].X - Points[K].X) *
       (y - Points[K].Y) /
       (Points[j].Y - Points[K].Y) + Points[K].X) then
        Result := not Result;
    end;
    J := K;
  end;
end;
*)