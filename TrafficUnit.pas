unit TrafficUnit;

interface

uses SysUtils, Windows, IPHelper, IPHLPAPI;


type
  TTraffic = Class;

  TNewInstanceEvent = procedure(Sender :TTraffic) of object;
  TFreezeEvent = procedure(Sender :TTraffic) of object;

  TTraffic = Class
  private
    FIP: string;
    FMac: string;
    FInPerSec: Dword;
    FInTotal: Dword;
    FPeakInPerSec: Dword;
    FInterfaceIndex: DWord;
    FActiveCountIn: Dword;
    FSecondsActive: Cardinal;
    FPrevCountIn: DWord;
    FDescription: string;
    FOutTotal: Dword;
    FPeakOutPerSec: Dword;
    FOutPerSec: Dword;
    FPrevCountOut: DWord;
    FActiveCountOut: Dword;
    FAverageInPerSec: Dword;
    FAverageOutPerSec: Dword;
    FStartedAt: TDateTime;
    FRunning: boolean;
    FOnFreeze: TFreezeEvent;
    FOnUnFreeze: TFreezeEvent;
    FConnected: boolean;
    FFound: boolean;
    FSpeed: DWord;

    function GetIPFromIFIndex(InterfaceIndex: Cardinal): string;
  public
    property Found : boolean read FFound write FFound;
    property Connected : boolean read FConnected;
    property Running : boolean read FRunning;
    property InterfaceIndex : DWord read FInterfaceIndex;
    property IP : string read FIP;
    property Mac : string read FMac;
    property Description : string read FDescription;
    property StartedAt : TDateTime read FStartedAt;
    property SecondsActive : Cardinal read FSecondsActive;
    property Speed : DWord read FSpeed;
    property ActiveCountIn : Dword read FActiveCountIn; { count of samples where something was received }
    property PrevCountIn : DWord read FPrevCountIn; { previous byte count in }
    property InPerSec : Dword read FInPerSec; { byte count in of last sample period }
    property AverageInPerSec : Dword read FAverageInPerSec; { Average in }
    property InTotal : Dword read FInTotal; { total byte count in }
    property PeakInPerSec : Dword read FPeakInPerSec; { peak byte count in }

    property ActiveCountOut : Dword read FActiveCountOut; { count of samples where something was sent }
    property PrevCountOut : DWord read FPrevCountOut; { previous byte count out }
    property OutPerSec : Dword read FOutPerSec; { byte count out of last sample period }
    property AverageOutPerSec : Dword read FAverageOutPerSec; { Average Out }
    property OutTotal : Dword read FOutTotal; { total byte count out }
    property PeakOutPerSec : Dword read FPeakOutPerSec; { peak byte count out }

    procedure NewCycle(const InOctets, OutOctets, TrafficSpeed : Dword);
    procedure Reset;
    procedure Freeze;
    procedure UnFreeze;
    procedure MarkDisconnected;
    function GetStatus : string;
    function FriendlyRunningTime:string;
    constructor Create(const AMibIfRow : TMibIfRow; OnNewInstance : TNewInstanceEvent);
  published
    property OnFreeze :TFreezeEvent read FOnFreeze write FOnFreeze;
    property OnUnFreeze :TFreezeEvent read FOnUnFreeze write FOnUnFreeze;
  end;

(*  function BytesToFriendlyString(Value : DWord) : string;
  function BitsToFriendlyString(Value : DWord) : string;*)

implementation

(*function BytesToFriendlyString(Value : DWord) : string;
const
  OneKB = 1024;
  OneMB = OneKB * 1024;
  OneGB = OneMB * 1024;
begin
  if Value < OneKB then
    Result := FormatFloat('#,##0.00B',Value)
  else
    if Value < OneMB then
      Result := FormatFloat('#,##0.00KB', Value / OneKB)
    else
      if Value < OneGB then
        Result := FormatFloat('#,##0.00MB', Value / OneMB)
end; (*BytesToFriendlyString*)

(*function BitsToFriendlyString(Value : DWord) : string;
const
  OneKB = 1000;
  OneMB = OneKB * 1000;
  OneGB = OneMB * 1000;
begin
  if Value < OneKB then
    Result := FormatFloat('#,##0.00b',Value)
  else
    if Value < OneMB then
      Result := FormatFloat('#,##0.00Kb', Value / OneKB)
    else
      if Value < OneGB then
        Result := FormatFloat('#,##0.00Mb', Value / OneMB)
end; (*BytesToFriendlyString*)


{ TTraffic }
constructor TTraffic.Create(const AMibIfRow: TMibIfRow; OnNewInstance : TNewInstanceEvent);
var
  Descr : string;
begin

  inherited Create;

  FRunning := True;
  FConnected := True;

  self.FInterfaceIndex := AMibIfRow.dwIndex;
  self.FIP := GetIPFromIFIndex(self.InterfaceIndex);
  {add this line here for  vista}
  if (self.FIP = '!not_found!') then exit;

  self.FMac := MacAddr2Str(TMacAddress(AMibIfRow.bPhysAddr), AMibIfRow.dwPhysAddrLen);

  SetLength(Descr, Pred(AMibIfRow.dwDescrLen));
  Move(AMibIfRow.bDescr, Descr[1], pred(AMibIfRow.dwDescrLen));
  self.FDescription := Trim(Descr);

  self.FPrevCountIn := AMibIfRow.dwInOctets;
  self.FPrevCountOut := AMibIfRow.dwOutOctets;

  self.FStartedAt := Now;


  self.FSpeed := AMibIfRow.dwSpeed;

  FActiveCountIn := 0;
  FActiveCountOut:= 0;
  FInTotal := 0;
  FOutTotal:= 0;
  FInPerSec:= 0;
  FOutPerSec:= 0;
  FPeakInPerSec := 0;
  FPeakOutPerSec:=0;

  //notify this instance
  if Assigned(OnNewInstance) then OnNewInstance(self);
end; (*Create*)

procedure TTraffic.NewCycle(const InOctets, OutOctets, TrafficSpeed: Dword);
begin
  Inc(self.FSecondsActive);

  If not Running then Exit;

  FSpeed := TrafficSpeed;

  //IN
  self.FInPerSec := InOctets - self.PrevCountIn;
  Inc(self.FInTotal, self.InPerSec);
  if InPerSec > 0 then Inc(FActiveCountIn);
  if InPerSec > PeakInPerSec then FPeakInPerSec := InPerSec;
  try
    If ActiveCountIn<>0  then
    self.FAverageInPerSec := InTotal div ActiveCountIn
  except
    self.FAverageInPerSec := 0
  end;
  FPrevCountIn := InOctets;

  //OUT
  self.FOutPerSec := OutOctets - self.PrevCountOut;
  Inc(self.FOutTotal, self.OutPerSec);
  if OutPerSec > 0 then Inc(FActiveCountOut);
  if OutPerSec > PeakOutPerSec then FPeakOutPerSec := OutPerSec;
  try
    If ActiveCountOut<>0 Then
      self.FAverageOutPerSec := OutTotal div ActiveCountOut
  except
    self.FAverageOutPerSec := 0
  end;
  FPrevCountOut := OutOctets;

end; (*NewCycle*)


function TTraffic.GetIPFromIFIndex(InterfaceIndex: Cardinal): string;
var
 i:  integer;
 IPArr : TMIBIPAddrArray;
begin
   Result := '!not_found!';  // shouldn't happen...
   Get_IPAddrTableMIB( IpArr );  // get IP-address table
   if Length(IPArr) > 0 then
     for i := low(IPArr) to High(IPArr) do  // look for matching index...
       if IPArr[i].dwIndex = InterfaceIndex then
       begin
         Result := IPAddr2Str(IParr[i].dwAddr);
         BREAK;
       end;
end; (*GetIPFromIFIndex*)

procedure TTraffic.Reset;
begin
  self.FPrevCountIn := InPerSec;
  self.FPrevCountOut := OutPerSec;

  self.FStartedAt := Now;
  FSecondsActive := 0;

  FActiveCountIn := 0;
  FActiveCountOut:= 0;
  FInTotal := 0;
  FOutTotal := 0;
  FInPerSec := 0;
  FOutPerSec := 0;
  FPeakInPerSec := 0;
  FPeakOutPerSec := 0;
end; (*Reset*)

procedure TTraffic.Freeze;
begin
  FRunning := False;
  if Assigned(FOnFreeze) then OnFreeze(Self);
end; (*Freeze*)

procedure TTraffic.UnFreeze;
begin
  FRunning := True;
  if Assigned(FOnUnFreeze) then OnUnFreeze(Self);
end; (*UnFreeze*)

procedure TTraffic.MarkDisconnected;
begin
  self.FConnected := False;
  self.FRunning := False;
end; (*MarkDisconnected*)

function TTraffic.GetStatus: string;
begin
  if  self.Connected then
    Result := 'Connected'
  else
    Result := 'NOT connected';

  if self.Running then
    Result := Result + ', Running'
  else
    Result := Result + ', NOT running';
    
end; (*GetStatus*)

function TTraffic.FriendlyRunningTime: string;
var
  H, M, S: string;
  ZH, ZM, ZS: Integer;
begin
  ZH := SecondsActive div 3600;
  ZM := (Integer(SecondsActive) - (ZH*3600)) div 60;
  ZS := Integer(SecondsActive) - ((ZH * 3600) + (ZM * 60));
  H := Format('%.2d',[ZH]);
  M := Format('%.2d',[ZM]);
  S := Format('%.2d',[ZS]);

  Result := H + ':' + M + ':' + S;
end; (*FriendlyRunningTime*)


end.
