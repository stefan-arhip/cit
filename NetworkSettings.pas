unit NetworkSettings;


//***************************************************************************//
//                 Delphi  NETWORK INTERFACE MONITOR                         //
//***************************************************************************//
//                                                                           //
//  Tested on   :  Delphi 4.03, Delphi 6.0 Enterprise, Delphi 7              //
//                 WIN-NT4/SP6, WIN2K, WIN98se, Win XP                       //
//***************************************************************************//
//                    This software is FREEWARE                              //
//  If this software works, it was surely initally written by Dirk Claessens //
//                      <dirkcl@pandora.be>                                  //
//                                                                           //
//  (If it doesn't, I don't know anything about it.)                         //
//                                                                           //
//  GUI modifications and TTraffic class coded by Zarko Gajic                 //
//                      http://delphi.about.com                              //
//***************************************************************************//


(* definitions

sample interval     : time interval between samples ( fixed 1000ms interval )
octets/sec. in/out  : number of octets IN/OUT from/to adapter in previous
------------------    one second period

peak in/out per sec.: highest number of octets IN/OUT measured during observation
-------------------   period.

avg. in/out per sec. : accumulated sample average over observation period
-------------------


NOTES:
------
1/ internet traffic is bursty by nature, so for calculation of average
   values zero values are _not_ used. A separate sample counter is
   maintained for each interface ( ActiveCountIn/Out ), which only counts
   samples with byte count <> 0.
   Example: say  500 samples were taken. if only 400 of them contain data,
   the accumulated average is calculated from Totalcount/400 seconds, not 500.

2/ Peak values _may_ show figures exceeding the theoretical maximum bitrate
   for an adapter. This is caused by sampling artefacts, and the internal
   - unknown :0) - workings of IpHlpAPI.dll.

*)

interface

uses
  Windows, Graphics, ExtCtrls, Controls, StdCtrls, Buttons, Tabs,
  ComCtrls, Classes, SysUtils, Forms, dialogs,
  TrafficUnit, IPHelper, IPHLPAPI, ShellAPI, CoolThings, Menus;


type
  TNetworkSettingsForm = class(TForm)
    pnlBottom: TPanel;
    ExitButton: TButton;
    UnFreezeButton: TBitBtn;
    FreezeButton: TBitBtn;
    ClearCountersButton: TBitBtn;
    Timer: TTimer;
    RemoveInactiveButton: TBitBtn;
    cbOnTop: TCheckBox;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Quit1: TMenuItem;
    ledAdapterDescription: TLabeledEdit;
    ledMACAddress: TLabeledEdit;
    ledSpeed: TLabeledEdit;
    ledStartedAt: TLabeledEdit;
    ledActiveFor: TLabeledEdit;
    Label1: TLabel;
    ledOctInSec: TLabeledEdit;
    ledPeakINSec: TLabeledEdit;
    ledAvgINSec: TLabeledEdit;
    ledTotalIN: TLabeledEdit;
    Label2: TLabel;
    ledOctOUTSec: TLabeledEdit;
    ledPeakOUTSec: TLabeledEdit;
    ledAvgOUTSec: TLabeledEdit;
    ledTotalOUT: TLabeledEdit;
    Label3: TLabel;
    StatusText: TLabel;
    TrafficTabs: TTabSet;
    SpeedButton1: TSpeedButton;
    procedure TimerTimer(Sender: TObject);
    procedure ClearCountersButtonClick(Sender: TObject);
    procedure cbOnTopClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TrafficTabsChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
    procedure ExitButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FreezeButtonClick(Sender: TObject);
    procedure UnFreezeButtonClick(Sender: TObject);
    procedure RemoveInactiveButtonClick(Sender: TObject);
    procedure lblURLClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure pcChange(Sender: TObject);
    procedure ledAdapterDescriptionChange(Sender: TObject);
    procedure Quit1Click(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    Moving:Boolean;
    Delta:TPoint;
    procedure HandleNewAdapter(ATraffic : TTraffic);
    procedure HandleFreeze(ATraffic : TTraffic);
    procedure HandleUnFreeze(ATraffic : TTraffic);
    function LocateTraffic(AdapterIndex : DWord) : TTraffic;
    procedure ProcessMIBData;
    procedure ClearDisplay;
    procedure RefreshDisplay;
  public
    { Public declarations }
  end;


var
  NetworkSettingsForm: TNetworkSettingsForm;
  ActiveTraffic : TTraffic;

implementation

uses Unit2, Unit1;
{$R *.dfm}

procedure TNetworkSettingsForm.ClearDisplay;
var
  j:integer;
begin
  TrafficTabs.Tabs.Clear;
  StatusText.Caption:='';
  for j:= 0 to (*GroupBox.*)ControlCount-1 do
  begin
    if (*GroupBox.*)Controls[j] is TCustomEdit then
      TCustomEdit((*GroupBox.*)Controls[j]).Text := '';
  end;
end; (*ClearDisplay*)

procedure TNetworkSettingsForm.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := False;
  ProcessMIBData;
  Timer.Enabled := True;
end; (*TimerTimer*)

procedure TNetworkSettingsForm.ClearCountersButtonClick(Sender: TObject);
begin
  ActiveTraffic.Reset;

  RefreshDisplay;
end;

procedure TNetworkSettingsForm.cbOnTopClick(Sender: TObject);
begin
  if cbOnTop.Checked = true then
     FormStyle := fsSTAYONTOP
  else
     FormStyle := fsNORMAL;
end;

procedure TNetworkSettingsForm.FormDestroy(Sender: TObject);
var
  i : integer;
begin
  Timer.OnTimer := nil;
  ActiveTraffic := nil;

  for i:= 0 to -1 + TrafficTabs.Tabs.Count do
    TrafficTabs.Tabs.Objects[i].Free;
end;

procedure TNetworkSettingsForm.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
//  If Not Form2.CheckBox1.Checked Then
    If Button=mbLeft Then
      Begin
        Moving:=True;
        Delta:=Point(X,Y);
      End;
end;

procedure TNetworkSettingsForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
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

procedure TNetworkSettingsForm.FormMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
//  If Not Form2.CheckBox1.Checked Then
    Moving:=False;
end;

procedure TNetworkSettingsForm.TrafficTabsChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
begin
  if NewTab = -1 then
    ActiveTraffic := nil
  else
    ActiveTraffic := TTraffic(TrafficTabs.Tabs.Objects[NewTab]);
  RefreshDisplay;
end;

procedure TNetworkSettingsForm.ExitButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TNetworkSettingsForm.FormCreate(Sender: TObject);
Var Allow:Boolean;
begin
  Height:=215;
  //do NOT change
  Timer.Interval := 1000; // all calculatoins on 1 sec.

  //remove design time testing data
  ClearDisplay;
  ActiveTraffic := nil;

  pcChange(Sender);
  
  Timer.Enabled := True;
end;        

procedure TNetworkSettingsForm.RefreshDisplay;
begin
  if not Assigned(ActiveTraffic) then
  begin
    ClearDisplay;
    Exit;
  end;

  with ActiveTraffic do
  begin

    FreezeButton.Visible := Connected;
    UnFreezeButton.Visible := Connected;
    ClearCountersButton.Visible := Connected;
    RemoveInactiveButton.Visible := not Connected;

    FreezeButton.Enabled := Running;
    UnFreezeButton.Enabled := not Running;

    ledAdapterDescription.Text := Description;
    ledMACAddress.Text := MAC;

    ledSpeed.Text := Bytes2Str(Speed,0,False);//Bytes2Str(Speed,0,);

    ledOctInSec.Text := Bytes2Str(InPerSec,0,False);
    ledPeakInSec.Text := Bytes2Str(PeakInPerSec,0,False);
    ledAvgINSec.Text := Bytes2Str(AverageInPerSec,0,False);
    ledTotalIN.Text := Bits2Str(InTotal,0,True);

    ledOctOUTSec.Text := Bytes2Str(OutPerSec,0,False);
    ledPeakOUTSec.Text := Bytes2Str(PeakOutPerSec,0,False);
    ledAvgOUTSec.Text := Bytes2Str(AverageOutPerSec,0,False);
    ledTotalOUT.Text := Bits2Str(OutTotal,0,True);

    self.ledStartedAt.Text := DateTimeToStr(StartedAt);
    self.ledActiveFor.Text := FriendlyRunningTime;

    StatusText.Caption := GetStatus;
    SetAttributes(StatusText,False);

    If Form1.ProgressBar5.Max<InPerSec Then
      Form1.ProgressBar5.Max:=InPerSec;//Speed Div 3;
    Form1.ProgressBar5.Position:=InPerSec;
    Form1.Label24.Caption:='In '+Bytes2Str(InPerSec,0,False)+'/'+
                           Bits2Str(8*Speed,0,True);
    If Form1.ProgressBar6.Max<InPerSec Then
      Form1.ProgressBar6.Max:=OutPerSec;//Speed Div 3;
    Form1.ProgressBar6.Position:=OutPerSec;
    Form1.Label23.Caption:='Out '+Bytes2Str(OutPerSec,0,False)+'/'+
                           Bits2Str(8*Speed,0,True);
    Form1.Label24.Hint:=FloatToStrF(8*InPerSec*100/Speed,ffFixed,16,2)+' %'#13+
                        Bits2Str(InTotal,0,True);
    Form1.Label23.Hint:=FloatToStrF(8*OutPerSec*100/Speed/8,ffFixed,16,2)+' %'#13+
                        Bits2Str(OutTotal,0,True);
  end;//with
end; (*RefreshDisplay*)

procedure TNetworkSettingsForm.ProcessMIBData;
var
 MibArr : IpHlpAPI.TMIBIfArray;
 i : integer;
 ATraffic : TTraffic;
begin
  Get_IfTableMIB(MibArr);  // get current MIB data


  //Mark not Found as NOT Connected
  for i:= 0 to -1 + TrafficTabs.Tabs.Count do
  begin
    ATraffic := TTraffic(TrafficTabs.Tabs.Objects[i]);
    if ATraffic.Connected then ATraffic.Found := False;
  end;
//  ATraffic := nil;

  //process
  if Length(MibArr) > 0 then
  begin
    for i := Low(MIBArr) to High(MIBArr) do
    begin
      ATraffic := LocateTraffic(MIBArr[i].dwIndex);
      if Assigned(ATraffic) then
      begin
        //already connected
        ATraffic.NewCycle(MIBArr[i].dwInOctets, MIBArr[i].dwOutOctets, MIBArr[i].dwSpeed);
      end
      else
      begin
        //New one!
        ATraffic := TTraffic.Create(MIBArr[i], HandleNewAdapter);
        ATraffic.Found := True;
        ATraffic.OnFreeze := HandleFreeze;
        ATraffic.OnUnFreeze := HandleUnFreeze;
      end;
    end;
  end;

  //Mark not Found as Inactive
  for i:= 0 to -1 + TrafficTabs.Tabs.Count do
    if NOT TTraffic(TrafficTabs.Tabs.Objects[i]).Found then
      TTraffic(TrafficTabs.Tabs.Objects[i]).MarkDisconnected;

  RefreshDisplay;
end;

procedure TNetworkSettingsForm.Quit1Click(Sender: TObject);
begin
  Close;
end;

(*ProcessMIBData*)

function TNetworkSettingsForm.LocateTraffic(AdapterIndex : DWord): TTraffic;
var
  j : cardinal;
  ATraffic : TTraffic;
begin
  Result := nil;
  if TrafficTabs.Tabs.Count = 0 then Exit;

  for j:= 0 to -1 + TrafficTabs.Tabs.Count do
  begin
    ATraffic := TTraffic(TrafficTabs.Tabs.Objects[j]);
    if ATraffic.InterfaceIndex = AdapterIndex then
    begin
      Result := ATraffic;
      Result.Found := True;
      Break;
    end;
  end;
end; (*LocateAdapter*)

procedure TNetworkSettingsForm.HandleNewAdapter(ATraffic: TTraffic);
begin
  //add adapter
  TrafficTabs.Tabs.AddObject(ATraffic.IP, ATraffic);
  //select it
  TrafficTabs.TabIndex := -1 + TrafficTabs.Tabs.Count;
  TrafficTabs.TabIndex:=0;
end; (*HandleNewAdapter*)

procedure TNetworkSettingsForm.FreezeButtonClick(Sender: TObject);
begin
  ActiveTraffic.Freeze;
end;

procedure TNetworkSettingsForm.UnFreezeButtonClick(Sender: TObject);
begin
  ActiveTraffic.UnFreeze;
end;

procedure TNetworkSettingsForm.HandleFreeze(ATraffic: TTraffic);
begin
  self.FreezeButton.Enabled := ATraffic.Running;
  self.UnFreezeButton.Enabled := not ATraffic.Running;
end;

procedure TNetworkSettingsForm.HandleUnFreeze(ATraffic: TTraffic);
begin
  self.FreezeButton.Enabled := ATraffic.Running;
  self.UnFreezeButton.Enabled := not ATraffic.Running;
end;

procedure TNetworkSettingsForm.RemoveInactiveButtonClick(Sender: TObject);
begin
  If not ActiveTraffic.Connected then //just checking
  begin
    ActiveTraffic.Free;
    ActiveTraffic := nil;
    TrafficTabs.Tabs.Delete(TrafficTabs.TabIndex);
    TrafficTabs.SelectNext(False);
  end;

  RefreshDisplay;
end; (*RemoveInactiveButtonClick*)


procedure TNetworkSettingsForm.lblURLClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open','http://delphi.about.com',nil,nil,SW_SHOWNORMAL);
end;

procedure TNetworkSettingsForm.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open','mailto:delphi.guide@about.com',nil,nil,SW_SHOWNORMAL);
end;

procedure TNetworkSettingsForm.pcChange(Sender: TObject);
begin
//  pnlBottom.Visible := pc.ActivePage = tsTraffic;
end;

procedure TNetworkSettingsForm.ledAdapterDescriptionChange(Sender: TObject);
begin
  //testing - not working since GroupBox is disabled
  ledAdapterDescription.Hint := ledAdapterDescription.Text;
  ledAdapterDescription.ShowHint := Canvas.TextWidth(ledAdapterDescription.Text) > ledAdapterDescription.ClientWidth;
end;

end.

