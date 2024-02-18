unit CoolThings;

interface

Uses StdCtrls, SysUtils, Windows, ComCtrls, WinSock, Graphics, Registry,
     ShellApi, Activex, ShlObj, ComObj, Forms, Classes, Dialogs;

Type TKeyType = (ktCapsLock, ktNumLock, ktScrollLock);
     PHICON = ^HICON;

Procedure SetActivePartition(Active:Boolean);
Function Bytes2Str(Bytes:Extended;Decimal:Byte;Bytes2Bits:Boolean):String;
Function Bits2Str(Bits:Extended;Decimal:Byte;Bits2Bytes:Boolean):String;
Function AddZero(i:Integer;n:Byte):String;
Function AddZeroS(s:String;n:Byte):String;
//function UpTime: string;
Function UpTime(Var WindowsStartDate:String):String;
Function GetCPUSpeed: Extended;
Function UsedMemory:Extended;
Function TotalMemory:Extended;
Function GiveCPUUsage:Extended;
Function GetLocalIP:string;
Function GetIPFromHost (var HostName, IPaddr, WSAErr: string): Boolean;
Function GiveSystemPowerStatus:String;
Procedure SetAttributes(l:TLabel;b:Boolean);
Function IsRemotelyControlled: Boolean;
Function IsCapsLockOn : boolean;
Function IsNumLockOn:Boolean;
Function IsScrollLockOn:Boolean;
Function IsRunningInsideVirtualPC:Boolean;Assembler;
Function LowOrderBitSet(Int:Integer):Boolean;
Function InsertOn: boolean;
Procedure SetLedState(KeyCode: TKeyType; bOn: Boolean);
Function GetTimeZone:String;
Procedure GetFreeSpace;
Function WindowsExit(RebootParam: Word): Boolean;
Function GetWindowsDir: TFileName;
Function GetSystemDir: TFileName;
Procedure GetAssociatedIcon(FileName: TFilename; PLargeIcon, PSmallIcon: PHICON);
Function SearchInWinDir(s:TFileName):TFileName;
Procedure ShowDesktop(const YesNo:Boolean);
Function GetExeByExtension(sExt:string):string;
Function RecycleBinIsEmpty: Boolean;
Function SecondsToTime(Seconds:Int64):String;
Function GetWinVersion: String;
Function GetWindowsVersion: String;
Function GetTempDirectory: String;
Function FindComponentEx(Const Name: string): TComponent;
Function IsWOW64: String;

Var tempFolder: Array [0..MAX_PATH] Of Char;
    BackGroundColor,ColorOfTheFont,ActiveColorOfTheFont,WarningColorOfTheFont:TColor;
    LastTagForSpeedButton: Integer;
    PopUpMenuSender: String;

implementation

Uses adCPUUsage, Unit1, Unit2;

Var ActivePartition:Array[1..30]Of Boolean;

Function FindComponentEx(Const Name: String): TComponent;
Var FormName: String;
    CompName: String;
    p: Integer;
    Found: Boolean;
    Form: TForm;
    i: Integer;
begin
  // Split up in a valid form and a valid component name
  p := Pos('.', Name);
  If p = 0 Then
    Begin
      Raise Exception.Create('No valid form name given');
    End;
  FormName:= Copy(Name, 1, p - 1);
  CompName:= Copy(Name, p + 1, High(Integer));
  Found   := False;
  // find the form
  For i:= 0 to Screen.FormCount - 1 Do
    Begin
      Form := Screen.Forms[i];
      // case insensitive comparing
      If AnsiSameText(Form.Name, FormName) Then
        Begin
          Found := True;
          Break;
        End;
    End;
  If Found Then
    Begin
      For i:= 0 To Form.ComponentCount - 1 Do
        Begin
          Result := Form.Components[i];
          If AnsiSameText(Result.Name, CompName) Then
            Exit;
        End;
    End;
  Result := Nil;
end;


Function GetWindowsVersion: String;
Var VerInfo: TOsversionInfo;
    PlatformId, VersionNumber: String;
    Reg: TRegistry;
Begin
  VerInfo.dwOSVersionInfoSize := SizeOf(VerInfo);
  GetVersionEx(VerInfo);
  // Detect platform
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Case VerInfo.dwPlatformId Of
    VER_PLATFORM_WIN32s:
      Begin
        PlatformId := 'Windows 3.1';
      End;
    VER_PLATFORM_WIN32_WINDOWS:
      Begin
        // Registry
        Reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion', False);
        PlatformId    := Reg.ReadString('ProductName');
        VersionNumber := Reg.ReadString('VersionNumber');
      End;
    VER_PLATFORM_WIN32_NT:
      Begin
        Reg.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion', False);
        PlatformId    := Reg.ReadString('ProductName');
        VersionNumber := Reg.ReadString('CurrentVersion');
      End;
  End;
  Reg.Free;
  Result := PlatformId + ' (version ' + VersionNumber + ')';
End;

Function GetTempDirectory: String;
Var tempFolder: Array [0..MAX_PATH] Of Char;
Begin
  GetTempPath(MAX_PATH, @tempFolder);
  Result:= IncludeTrailingPathDelimiter(StrPas(tempFolder));
End;

Function SecondsToTime(Seconds:Int64):String;
Var h,m,s:Int64;
Begin
  h:=(Seconds Div 60) Div 60;
  m:=(Seconds-(h*60*60)) Div 60;
  s:=(Seconds Mod 60) Mod 60;
  Result:=AddZero(h,2)+':'+AddZero(m,2)+':'+AddZero(s,2);
End;

function RecycleBinIsEmpty: Boolean;
const
  CLSID_IRecycleBin: TGUID = (D1: $645FF040; D2: $5081; D3: $101B;
    D4: ($9F, $08, $00, $AA, $00, $2F, $95, $4E));
var
  EnumIDList: IEnumIDList;
  FileItemIDList: PItemIDList;
  ItemCount: ULONG;
  RecycleBin: IShellFolder;
begin
  CoInitialize(nil);
  OleCheck(CoCreateInstance(CLSID_IRecycleBin, nil, CLSCTX_INPROC_SERVER or
    CLSCTX_LOCAL_SERVER, IID_IShellFolder, RecycleBin));
  RecycleBin.EnumObjects(0,
    SHCONTF_FOLDERS or
    SHCONTF_NONFOLDERS or
    SHCONTF_INCLUDEHIDDEN,
    EnumIDList);
  Result := EnumIDList.Next(1, FileItemIDList, ItemCount) <> NOERROR;
  CoUninitialize;
end;

function GetExeByExtension(sExt:string):string;
var sExtDesc:string;
begin
   with TRegistry.Create do
   begin
     try
       RootKey:=HKEY_CLASSES_ROOT;
       if OpenKeyReadOnly(sExt) then
       begin
         sExtDesc:=ReadString('') ;
         CloseKey;
       end;
       if sExtDesc <>'' then
       begin
         if OpenKeyReadOnly(sExtDesc + '\Shell\Open\Command') then
         begin
           Result:= ReadString('') ;
         end
       end;
     finally
       Free;
     end;
   end;

   if Result <> '' then
   begin
     if Result[1] = '"' then
     begin
       Result:=Copy(Result,2,-1 + Pos('"',Copy(Result,2,MaxINt))) ;
     end
   end;
end;

procedure ShowDesktop(const YesNo : boolean) ;
var h : THandle;
begin
  h := FindWindow('ProgMan', nil) ;
  h := GetWindow(h, GW_CHILD) ;
  if YesNo = True then
    ShowWindow(h, SW_SHOW)
  else
    ShowWindow(h, SW_HIDE) ;
end;

function GetWindowsDir: TFileName;
var WinDir: array [0..MAX_PATH-1] of char;
begin
  SetString(Result,WinDir,GetWindowsDirectory(WinDir,MAX_PATH));
  if Result='' then
    raise Exception.Create(SysErrorMessage(GetLastError));
end;

function GetSystemDir: TFileName;
var SysDir: array [0..MAX_PATH-1] of char;
begin
  SetString(Result, SysDir, GetSystemDirectory(SysDir, MAX_PATH));
  if Result='' then
    raise Exception.Create(SysErrorMessage(GetLastError));
end;

Function SearchInWinDir(s:TFileName):TFileName;
Begin
  If FileExists(s) Then
    Result:=s
  Else If FileExists(GetWindowsDir+'\'+s) Then  //C:\Windows
    Result:=GetWindowsDir+'\'+s
  Else If FileExists(GetSystemDir+'\'+s) Then   //C:\Windows\System32
    Result:=GetSystemDir+'\'+s
  Else If FileExists(GetWindowsDir+'\system\'+s) Then
    Result:=GetWindowsDir+'\system\'+s
  Else
    Result:=s;
End;

Function InternetLink(FileName:TFileName):Boolean;
Var s1,s2,s3:TFileName;//http://,https://,ftp://
Begin
  s1:=LowerCase(FileName);             //ftp://
  Delete(s1,7,Length(s1));
  s2:=LowerCase(FileName);             //http://
  Delete(s2,8,Length(s2));
  s3:=LowerCase(FileName);
  Delete(s3,9,Length(s3));  //https://
  Result:=False;
  If (s1='ftp://') Or (s2='http://') Or (s3='https://') Then
    Result:=True;
End;

procedure GetAssociatedIcon(FileName: TFilename; PLargeIcon, PSmallIcon: PHICON);
// Gets the icons of a given file
var IconIndex:UINT;  // Position of the icon in the file
    FileExt,FileType,OriginalFileName:string;
    Reg:TRegistry;
    p:integer;
    p1,p2:pchar;
label noassoc;
begin
  OriginalFileName:=FileName;
  If InternetLink(OriginalFileName) Then
    Begin
      IconIndex:=0;
      FileName:=GetExeByExtension('.html');
      if ExtractIconEx(pchar(FileName), IconIndex, PLargeIcon^, PSmallIcon^, 1) <> 1 then
          begin
            // Failed to get the icon. Just "return" zeroes.
            if PLargeIcon <> nil then PLargeIcon^ := 0;
            if PSmallIcon <> nil then PSmallIcon^ := 0;
          end;
    End
  else
    Begin
      IconIndex:=0;
      // Get the extension of the file
      FileExt:=UpperCase(ExtractFileExt(FileName));
      if ((FileExt<>'.EXE') and (FileExt<>'.ICO')) or not FileExists(FileName) then
        begin
          // If the file is an EXE or ICO and it exists, then
          // we will extract the icon from this file. Otherwise
          // here we will try to find the associated icon in the
          // Windows Registry...
          Reg:=nil;
          try
            Reg:=TRegistry.Create(KEY_QUERY_VALUE);
            Reg.RootKey:=HKEY_CLASSES_ROOT;
            if FileExt='.EXE' then FileExt := '.COM';
            if Reg.OpenKeyReadOnly(FileExt) then
              try
                FileType := Reg.ReadString('');
              finally
                Reg.CloseKey;
              end;
            if (FileType<>'') and Reg.OpenKeyReadOnly(FileType+'\DefaultIcon') then
              try
                FileName:=Reg.ReadString('');
              finally
                Reg.CloseKey;
              end;
          finally
            Reg.Free;
          end;
          // If we couldn't find the association, we will
          // try to get the default icons
          if FileName='' then goto noassoc;
          // Get the filename and icon index from the
          // association (of form '"filaname",index')
          p1:=PChar(FileName);
          p2:=StrRScan(p1,',');
          if p2<>nil then
            begin
              p:=p2-p1+1; // Position of the comma
              IconIndex:=StrToInt(Copy(FileName,p+1,Length(FileName)-p));
              SetLength(FileName,p-1);
            end;
        end;
      // Attempt to get the icon
      if ExtractIconEx(pchar(FileName),IconIndex,PLargeIcon^,PSmallIcon^,1)<>1 then
      begin
    noassoc:
        // The operation failed or the file had no associated
        // icon. Try to get the default icons from SHELL32.DLL
        try // to get the location of SHELL32.DLL
          FileName:=IncludeTrailingBackslash(GetSystemDir)+'SHELL32.DLL';
        except
          FileName:='C:\WINDOWS\SYSTEM\SHELL32.DLL';
        end;
        // Determine the default icon for the file extension
        {if InternetLink(OriginalFileName)
                                   then IconIndex := 55*4//13
        else} if (FileExt = '.DOC') then IconIndex := 1
        else if (FileExt = '.EXE')
             or (FileExt = '.COM') then IconIndex := 2
        else if (FileExt = '.HLP') then IconIndex := 23
        else if (FileExt = '.MSC') then IconIndex := 35
        else if (FileExt = '.INI')
             or (FileExt = '.INF') then IconIndex := 63
        else if (FileExt = '.TXT') then IconIndex := 64
        else if (FileExt = '.BAT') then IconIndex := 65
        else if (FileExt = '.DLL')
             or (FileExt = '.SYS')
             or (FileExt = '.VBX')
             or (FileExt = '.OCX')
             or (FileExt = '.VXD') then IconIndex := 66
        else if (FileExt = '.FON') then IconIndex := 67
        else if (FileExt = '.TTF') then IconIndex := 68
        else if (FileExt = '.FOT') then IconIndex := 69
        else IconIndex := 50; //29 = shortcut arrow, 50 = blank
        // Attempt to get the icon.
        if ExtractIconEx(pchar(FileName), IconIndex, PLargeIcon^, PSmallIcon^, 1) <> 1 then
          begin
            // Failed to get the icon. Just "return" zeroes.
            if PLargeIcon <> nil then PLargeIcon^ := 0;
            if PSmallIcon <> nil then PSmallIcon^ := 0;
          end;
      end;
    End;
end;

Function AddZero(i:Integer;n:Byte):String;
Var s:String;
Begin
  s:=IntToStr(i);
  If Length(s)<n Then
    While Length(s)<n Do
      Begin
        s:='0'+s;
      End;
  Result:=s;
End;

Function AddZeroS(s:String;n:Byte):String;
Begin
  If Length(s)<n Then
    While Length(s)<n Do
      Begin
        s:='0'+s;
      End;
  Result:=s;
End;

(*function UpTime: string;
const
  ticksperday: Integer    = 1000 * 60 * 60 * 24;
  ticksperhour: Integer   = 1000 * 60 * 60;
  ticksperminute: Integer = 1000 * 60;
  tickspersecond: Integer = 1000;
var
  t:          LongInt;
  d, h, m, s: Integer;
begin
  t := GetTickCount;
  d := t div ticksperday;
  Dec(t, d * ticksperday);
  h := t div ticksperhour;
  Dec(t, h * ticksperhour);
  m := t div ticksperminute;
  Dec(t, m * ticksperminute);
  s := t div tickspersecond;
  //Result := 'Win Uptime  : '+IntToStr(d)+'d '+IntToStr(h)+'h '+IntToStr(m)+'m '+IntToStr(s)+'s ';
  Result := 'Win Uptime: '+AddZero(d,2)+':'+AddZero(h,2)+':'+AddZero(m,2)+':'+AddZero(s,2);
end;*)

function UpTime(Var WindowsStartDate:String):String;
var ndays: double;
    ticks: LongInt;
    btime: TDateTime;
begin
  ticks:=GetTickCount;       {The GetTickCount function retrieves the number of milliseconds that have elapsed since Windows was started.}
  ndays:=ticks/86400000;     {to convert this to the number of days, divide by number of milliseconds in a day, 24*60*60*1000=86400000}
  bTime:=now-ndays;          {to calculate the boot time we subtract the number-of-days-since-boot from the DateTime now. This works because a TDateTime is a double value which holds days and decimal days}
  WindowsStartDate:=FormatDateTime('"Windows started on" dddd, mm/dd/yyyy, "at" HH:nn:ss',bTime);
  Result:= 'Win Uptime '+AddZeroS(IntToStr(Trunc(nDays)),2)+'d ' +
                         AddZeroS(FormatDateTime('h',ndays),2)+':'+
                         AddZeroS(FormatDateTime('n',ndays),2)+':'+
                         AddZeroS(FormatDateTime('s',ndays),2);
end;

function GetCPUSpeed: Extended;
const DelayTime = 500;
var   TimerHi, TimerLo: DWORD;
      PriorityClass, Priority: Integer;
begin
  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority := GetThreadPriority(GetCurrentThread);
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);
  Sleep(10);
  asm
    dw 310Fh
    mov TimerLo, eax
    mov TimerHi, edx
  end;
  Sleep(DelayTime);
  asm
    dw 310Fh
    sub eax, TimerLo
    sbb edx, TimerHi
    mov TimerLo, eax
    mov TimerHi, edx
  end;
  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);
  Result:=TimerLo / (1000 * DelayTime);
end;

function UsedMemory:Extended;
var memory:TMemoryStatus;                     //load  100
begin                                         //     total
  memory.dwLength:=SizeOf(memory);
  GlobalMemoryStatus(memory);
  Result:=(memory.dwTotalPhys-memory.dwAvailPhys)/1024/1024;
end;

function TotalMemory:Extended;
Var Memory:TMemoryStatus;
Begin
  memory.dwLength:=SizeOf(memory);
  GlobalMemoryStatus(memory);
  Result:=memory.dwTotalPhys/1024/1024;
End;

Function GiveCPUUsage:Extended;
Var i:Integer;
    CPUUsage:Extended;
    CPUCount:Integer;
Begin
  CollectCPUData;
  CPUUsage:=0;
  CPUCount:=GetCPUCount;
  For i:=1 To CPUCount Do
    CPUUsage:=CPUUsage+GetCPUUsage(i-1)*100;
  Result:=0;
  If CpuCount<>0 Then
    Begin
      CPUUsage:=CPUUsage/CpuCount;
      Result:=CPUUsage;
    End;
End;

function GetLocalIP:string;
type TaPInAddr = array [0..10] of PInAddr;
     PaPInAddr = ^TaPInAddr;
var  phe  : PHostEnt;
     pptr : PaPInAddr;
     Buffer : array [0..63] of char;
     I    : Integer;
     GInitData      : TWSADATA;
begin
    WSAStartup($101, GInitData);
    Result := '';
    GetHostName(Buffer, SizeOf(Buffer));
    phe :=GetHostByName(buffer);
    if phe = nil then Exit;
    pptr := PaPInAddr(Phe^.h_addr_list);
    I := 0;
    while pptr^[I] <> nil do begin
      result:=StrPas(inet_ntoa(pptr^[I]^));
      Inc(I);
    end;
    WSACleanup;
end;

function GetIPFromHost (var HostName, IPaddr, WSAErr: string): Boolean;
type Name = array[0..100] of Char;
     PName = ^Name;
var HEnt: pHostEnt;
    HName: PName;
    WSAData: TWSAData;
    i: Integer;
begin
  Result := False;
  if WSAStartup($0101, WSAData) <> 0 then begin
    WSAErr := 'Winsock is not responding."';
    Exit;
  end;
  IPaddr := '';
  New(HName);
  if GetHostName(HName^, SizeOf(Name)) = 0 then
  begin
    HostName := StrPas(HName^);
    HEnt := GetHostByName(HName^);
    for i := 0 to HEnt^.h_length - 1 do
      IPaddr:=Concat(IPaddr,IntToStr(Ord(HEnt^.h_addr_list^[i])) + '.');
    SetLength(IPaddr, Length(IPaddr) - 1);
    Result := True;
  end
  else begin
   case WSAGetLastError of
    WSANOTINITIALISED:WSAErr:='WSANotInitialised';
    WSAENETDOWN      :WSAErr:='WSAENetDown';
    WSAEINPROGRESS   :WSAErr:='WSAEInProgress';
   end;
  end;
  Dispose(HName);
  WSACleanup;
end;

Function GiveSystemPowerStatus:String;
Var SysPowerStatus: TSystemPowerStatus;
    Capacity:Byte;
begin
  GetSystemPowerStatus(SysPowerStatus);
  if Boolean(SysPowerStatus.ACLineStatus) then
    begin
      Result:='Running on AC';
      //Form1.Gauge1.Visible:=False;
      //Form1.Gauge1.Progress:=100;
    end
  else
    Begin
      Capacity:=SysPowerStatus.BatteryLifePercent;
      Result:=Format('Battery: %d %%', [Capacity]);
      //Form1.Gauge1.Visible:=True;
      //Form1.Gauge1.Progress:=Capacity;
    End;
end;

Procedure SetAttributes(l:TLabel;b:Boolean);
Begin
  If b Then
    Begin
      l.Font.Color:=ActiveColorOfTheFont;//clYellow;
      l.Font.Style:=[fsBold];
    End
  Else
    Begin
      l.Font.Color:=ColorOfTheFont;//clAqua;//Form2.Font.Color;//
      l.Font.Style:=[];
    End;
End;

function IsRemotelyControlled: Boolean;
const
  SM_REMOTECONTROL = $2001; // from WinUser.h
begin
  Result := Boolean(GetSystemMetrics(SM_REMOTECONTROL));
end;

function IsCapsLockOn : boolean;
begin
  Result:=0<>(GetKeyState(VK_CAPITAL) and $01);
end;

Function IsNumLockOn:Boolean;
var KeyState: TKeyboardState;
begin
  GetKeyboardState(KeyState);
  Result:=(KeyState[VK_NUMLOCK]<>0);
end;

Function IsScrollLockOn:Boolean;
Begin
  Result:=GetKeyState(VK_SCROLL)<>0;
End;

function IsRunningInsideVirtualPC:Boolean;Assembler;
asm
  push ebp
  mov  ecx, offset @@exception_handler
  mov  ebp, esp
  push ebx
  push ecx
  push dword ptr fs:[0]
  mov  dword ptr fs:[0], esp
  mov  ebx, 0 // flag
  mov  eax, 1 // VPC function number call VPC
  db 00Fh, 03Fh, 007h, 00Bh
  mov eax, dword ptr ss:[esp]
  mov dword ptr fs:[0], eax
  add esp, 8
  test ebx, ebx
  setz al
  lea esp, dword ptr ss:[ebp-4]
  mov ebx, dword ptr ss:[esp]
  mov ebp, dword ptr ss:[esp+4]
  add esp, 8
  jmp @@ret
  @@exception_handler:
  mov ecx, [esp+0Ch]
  mov dword ptr [ecx+0A4h], -1 // EBX = -1 -> not running, ebx = 0 -> running
  add dword ptr [ecx+0B8h], 4 // -> skip past the detection code
  xor eax, eax // exception is handled
  ret
  @@ret:
end;

Function LowOrderBitSet(Int:Integer):Boolean;
{----------------------------------------------------------------}
{ Tests whether the low order bit of the given integer is set.   }
{----------------------------------------------------------------}
Const LowOrderBit=0;
Type BitSet=Set Of 0..15;
begin
//  If LowOrderBit In BitSet(Int)
//    Then LowOrderBitSet:=True
//    Else LowOrderBitSet:=False;
end;

function InsertOn: boolean;
{----------------------------------------------------------------}
{ Returns the status of the Insert key.                          }
{----------------------------------------------------------------}
begin
  if LowOrderBitSet(GetKeyState(VK_INSERT))
    then InsertOn := true
    else InsertOn := false
end;

procedure SetLedState(KeyCode: TKeyType; bOn: Boolean);
 var
   KBState: TKeyboardState;
   Code: Byte;
 begin
   case KeyCode of
     ktScrollLock: Code := VK_SCROLL;
     ktCapsLock: Code := VK_CAPITAL;
     ktNumLock: Code := VK_NUMLOCK;
   end;
   GetKeyboardState(KBState);
   if (Win32Platform = VER_PLATFORM_WIN32_NT) then
   begin
     if Boolean(KBState[Code]) <> bOn then
     begin
       keybd_event(Code,
                   MapVirtualKey(Code, 0),
                   KEYEVENTF_EXTENDEDKEY,
                   0);

       keybd_event(Code,
                   MapVirtualKey(Code, 0),
                   KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP,
                   0);
     end;
   end
   else
   begin
     KBState[Code] := Ord(bOn);
     SetKeyboardState(KBState);
   end;
 end;

Function GetTimeZone:String;
Var TimeZone: TTimeZoneInformation;
    n:Integer;
    s:String;
Begin
  GetTimeZoneInformation(TimeZone);
  n:=TimeZone.Bias div -60;
  If n=0 Then
    s:=s+IntToStr(n)
  Else If n>0 Then
    s:=s+'+'+IntToStr(n)
  Else
    s:=s+'-'+IntToStr(n);
  Result:='GMT'+s;
End;

Function Bytes2Str(Bytes:Extended;Decimal:Byte;Bytes2Bits:Boolean):String;
Const UMBytes:Array[1..2,0..4] Of String=((' b',' Kb',' Mb',' Gb',' Tb'),
                                          (' B',' KB',' MB',' GB',' TB'));
Var k:Byte;
    Factor:Integer;
Begin
  k:=2;
  Factor:=1024;
  If Bytes2Bits Then
    Begin
      Bytes:=Bytes*8;//transform in bits
      k:=1;
      Factor:=1000;
    End;
  If Bytes<Factor Then
    Result:=FloatToStrF(Bytes,ffFixed,16,Decimal)+UMBytes[k,0]
  Else If Bytes/Factor<Factor Then
    Result:=FloatToStrF(Bytes/Factor,ffFixed,16,Decimal)+UMBytes[k,1]
  Else If Bytes/Factor/Factor<Factor Then
    Result:=FloatToStrF(Bytes/Factor/Factor,ffFixed,16,Decimal)+UMBytes[k,2]
  Else If Bytes/Factor/Factor/Factor<Factor Then
    Result:=FloatToStrF(Bytes/Factor/Factor/Factor,ffFixed,16,Decimal)+UMBytes[k,3]
  Else If Bytes/Factor/Factor/Factor/Factor<Factor Then
    Result:=FloatToStrF(Bytes/Factor/Factor/Factor/Factor,ffFixed,16,Decimal)+UMBytes[k,4]
End;

Function Bits2Str(Bits:Extended;Decimal:Byte;Bits2Bytes:Boolean):String;
Const UMBytes:Array[1..2,0..4] Of String=((' b',' Kb',' Mb',' Gb',' Tb'),
                                          (' B',' KB',' MB',' GB',' TB'));
Var k:Byte;
    Factor:Integer;
Begin
  k:=1;
  Factor:=1000;
  If Bits2Bytes Then
    Begin
      Bits:=Bits/8;//transform in bytes
      k:=2;
      Factor:=1024;
    End;
  If Bits<Factor Then
    Result:=FloatToStrF(Bits,ffFixed,16,Decimal)+UMBytes[k,0]
  Else If Bits/Factor<Factor Then
    Result:=FloatToStrF(Bits/Factor,ffFixed,16,Decimal)+UMBytes[k,1]
  Else If Bits/Factor/Factor<Factor Then
    Result:=FloatToStrF(Bits/Factor/Factor,ffFixed,16,Decimal)+UMBytes[k,2]
  Else If Bits/Factor/Factor/Factor<Factor Then
    Result:=FloatToStrF(Bits/Factor/Factor/Factor,ffFixed,16,Decimal)+UMBytes[k,3]
  Else If Bits/Factor/Factor/Factor/Factor<Factor Then
    Result:=FloatToStrF(Bits/Factor/Factor/Factor/Factor,ffFixed,16,Decimal)+UMBytes[k,4]
End;

Procedure SetActivePartition(Active:Boolean);
Var i:Integer;
Begin
  For i:=1 To 30 Do
    ActivePartition[i]:=Active;
End;

function IsLogicalDrive(Drive: string): boolean;
var
  sDrive: string;
  cDrive: char;
begin
  sDrive := ExtractFileDrive(Drive);
  if sDrive = '' then
    Result := False
  else begin
    cDrive := UpCase(sDrive[1]);
    if cDrive in ['A'..'Z'] then
      result := (GetLogicalDrives And
        (1 Shl (Ord(cDrive) - Ord('A')))) <> 0
    else
      Result := False;
  end;
end;

//***************************************** vvvvvvvvvvvvvvvvvvv

function DriveSpace(DriveLetter : String; var FreeSpace, UsedSpace, TotalSpace : int64) : Boolean;
begin
  Result := SysUtils.GetDiskFreeSpaceEx(Pchar(DriveLetter), UsedSpace, TotalSpace, @FreeSpace);

  if UsedSpace > 0 then
    UsedSpace := TotalSpace - FreeSpace;

  if not Result then
  begin
    UsedSpace   := 0;
    TotalSpace  := 0;
    FreeSpace   := 0;
  end;
end;

procedure ListDrivesOfType(DriveType : Integer; var Drives : TStringList);
var
  DriveMap,
  dMask : DWORD;
  dRoot : String;
  I     : Integer;
begin
  dRoot     := 'A:\'; //' // work around highlighting
  DriveMap  := GetLogicalDrives;
  dMask     := 1;

  for I := 0 to 32 do
  begin
    if (dMask and DriveMap) <> 0 then
      if GetDriveType(PChar(dRoot)) = DriveType then
      begin
        Drives.Add(dRoot[1] + ':');
      end;

    dMask := dMask shl 1;
    Inc(dRoot[1]);
  end;
end;

//***************************************** ^^^^^^^^^^^

Procedure GetFreeSpace;
const BytesPerMB = 1048576;
var   MyDrives   : TStringlist;
      I : Integer;
      FreeSpace,
      UsedSpace,
      TotalSpace : int64;
begin
  MyDrives := TStringlist.Create;
  ListDrivesOfType(DRIVE_FIXED, MyDrives);
  //Memo1.Lines.Clear;
  Form1.Label25.Visible:= False;
  Form1.Label26.Visible:= False;
  for I := 0 to MyDrives.Count - 1 do
    begin
      FreeSpace  := 0;
      UsedSpace  := 0;
      TotalSpace := 0;
      if DriveSpace(MyDrives.Strings[I], FreeSpace, UsedSpace, TotalSpace) then
        begin
//          FreeSpace  := FreeSpace  div BytesPerMB Div 1024; // I div to 1024 to have result in GB
//          UsedSpace  := UsedSpace  div BytesPerMB Div 1024;
//          TotalSpace := TotalSpace div BytesPerMB Div 1024;
          Case i Of
            0:
              Begin
                Form1.Label25.Visible:= True;
                Form1.Label25.Caption:=MyDrives.Strings[I]+' '+Bytes2Str(UsedSpace,0,False)+'/'+Bytes2Str(TotalSpace,0,False);
                Form1.Label25.Hint:=Bytes2Str(UsedSpace*100/TotalSpace,2,False)+' % occupied space';
                Form1.Progressbar1.Hint:=Form1.Label25.Hint;
                Form1.ProgressBar1.Max:= 10000;
                Form1.ProgressBar1.Position:=Round(UsedSpace*10000/TotalSpace);
              End;
            1:
              Begin
                Form1.Label26.Visible:= True;
                Form1.Label26.Caption:=MyDrives.Strings[I]+' '+Bytes2Str(UsedSpace,0,False)+'/'+Bytes2Str(TotalSpace,0,False);
                Form1.Label26.Hint:=Bytes2Str(UsedSpace*100/TotalSpace,2,False)+' % occupied space';
                Form1.Progressbar2.Hint:=Form1.Label25.Hint;
                Form1.ProgressBar2.Position:=Round(UsedSpace*10000/TotalSpace);
              End;
          End;
//          Memo1.Lines.Add('Drive: ' + MyDrives.Strings[I] + ' ( ' + IntToStr(FreeSpace) +
//                      ' + ' + IntToStr(UsedSpace) + ' = ' + IntToStr(TotalSpace) + ' )');
        end;
    end;
end;

Procedure GetFreeSpace_I_DO_NOT_USE_THIS_ANYMORE;
Var s,k:Integer;
    T,O:Int64;
begin
  Form1.ListBox3.Clear;
  k:=0;
  For s:=1 To 30 Do
    If ActivePartition[s] (*And IsLogicalDrive(Chr(s+64))*) Then
      Begin
        Try
          If DiskFree(s)<>-1 Then
            begin
              Inc(k);
              T:=DiskSize(s);
              O:=T-DiskFree(s);
              Form1.ListBox3.Items.Add(Chr(s+64)+': '+Bytes2Str(O,0,False)+'/'+Bytes2Str(T,0,False));
              If k=1 Then
                Begin
                  Form1.Label25.Caption:=Chr(s+64)+': '+Bytes2Str(O,0,False)+'/'+Bytes2Str(T,0,False);
                  Form1.Label25.Hint:=Bytes2Str(O*100/T,2,False)+' % occupied space';
                  Form1.Progressbar1.Hint:=Form1.Label25.Hint;
                  Form1.ProgressBar1.Position:=Round(O*10000/T);
                End
              Else If k=2 Then
                Begin
                  Form1.Label26.Caption:=Chr(s+64)+': '+Bytes2Str(O,0,False)+'/'+Bytes2Str(T,0,False);
                  Form1.Label26.Hint:=Bytes2Str(O*100/T,2,False)+' % occupied space';
                  Form1.Progressbar2.Hint:=Form1.Label26.Hint;
                  Form1.ProgressBar2.Position:=Round(O*10000/T);
                End;
//              Else Break;
            End
          Else
            ActivePartition[s]:=False;
        Except
          T:=0;
          O:=0;
          ActivePartition[s]:=False;
        End;
      End;
end;

function WindowsExit(RebootParam: Word): Boolean;
var
   TTokenHd:THandle;
   TTokenPvg:TTokenPrivileges;
   cbtpPrevious:DWORD;
   rTTokenPvg:TTokenPrivileges;
   pcbtpPreviousRequired:DWORD;
   tpResult:Boolean;
const
   SE_SHUTDOWN_NAME='SeShutdownPrivilege';
begin
   if Win32Platform=VER_PLATFORM_WIN32_NT
     then
       begin
         tpResult:=OpenProcessToken(GetCurrentProcess(),
                                    TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,
                                    TTokenHd);
         if tpResult
           then
             begin
               tpResult:=LookupPrivilegeValue(nil,SE_SHUTDOWN_NAME,
                                              TTokenPvg.Privileges[0].Luid);
               TTokenPvg.PrivilegeCount:=1;
               TTokenPvg.Privileges[0].Attributes:=SE_PRIVILEGE_ENABLED;
               cbtpPrevious:=SizeOf(rTTokenPvg);
               pcbtpPreviousRequired:=0;
               if tpResult
                 then
                   Windows.AdjustTokenPrivileges(TTokenHd,False,TTokenPvg,cbtpPrevious,
                                                 rTTokenPvg,pcbtpPreviousRequired);
             end;
       end;
   Result:=ExitWindowsEx(RebootParam,0);
end;

procedure ForcedShutdown1Click(Sender: TObject);
begin
  WindowsExit(EWX_POWEROFF or EWX_FORCE);
end;

Function GetWinVersion: String;
Var osVerInfo: TOSVersionInfo;
    majorVersion, minorVersion: Integer;
Begin
  Result := 'Unknown';
  osVerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo) ;
  If GetVersionEx(osVerInfo) Then
    Begin
      minorVersion := osVerInfo.dwMinorVersion;
      majorVersion := osVerInfo.dwMajorVersion;
      Case osVerInfo.dwPlatformId Of
        VER_PLATFORM_WIN32_NT:
          Begin
            If majorVersion <= 4 Then
              Result := 'Win NT'
            Else If (majorVersion = 5) And (minorVersion = 0) Then
              Result := 'Win 2000'
            Else If (majorVersion = 5) And (minorVersion = 1) Then
              Result := 'Win XP'
            Else If (majorVersion = 6) And (minorVersion = 0) Then
              Result := 'Win Vista'
            Else If (majorVersion = 6) And (minorVersion = 1) Then
              Result := 'Win 7';
          end;
        VER_PLATFORM_WIN32_WINDOWS:
          Begin
            If (majorVersion = 4) And (minorVersion = 0) Then
              Result := 'Win 95'
            Else If (majorVersion = 4) And (minorVersion = 10) Then
              Begin
                If osVerInfo.szCSDVersion[1] = 'A' Then
                  Result := 'Win 98SE'
                Else
                  Result := 'Win 98';
              End
            Else If (majorVersion = 4) And (minorVersion = 90) Then
              Result := 'Win ME'
            Else
              Result := 'Unknown';
          End;
      End;
    End;
End;

Function IsWOW64: String;
Type TIsWow64Process = Function(Handle: THandle; Var Res: BOOL): BOOL; stdcall;
Var  IsWow64Result: BOOL;
     IsWow64Process: TIsWow64Process;
Begin
  Result:= '??Bit';
  IsWow64Process := GetProcAddress(GetModuleHandle('kernel32'), 'IsWow64Process');
  If Assigned(IsWow64Process) Then
    Begin
      If Not IsWow64Process(GetCurrentProcess, IsWow64Result) Then
        Raise Exception.Create('Bad process handle');
      If IsWow64Result Then
        Result:= '64bit'
      Else
        Result:= '32bit';
    End
  Else
    Result := '32bit';
end;

end.
