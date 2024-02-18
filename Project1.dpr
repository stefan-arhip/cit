program Project1;

uses
  Forms,
  Windows,
  Variants,
  Unit1 in 'Unit1.pas' {Form1},
  AudioMixer in 'AudioMixer.pas',
  CoolThings in 'CoolThings.pas',
  MultipleInstancePrevention in 'MultipleInstancePrevention.pas',
  Unit2 in 'Unit2.pas' {Form2},
  IPHelper in 'IPHelper.pas',
  IPHLPAPI in 'IPHLPAPI.pas',
  TrafficUnit in 'TrafficUnit.pas',
  NetworkSettings in 'NetworkSettings.pas',
  Unit4 in 'Unit4.pas' {Form4},
  Unit3 in 'Unit3.pas' {Form3},
  Unit5 in 'Unit5.pas' {Form5},
  Unit6 in 'Unit6.pas' {Form6},
  Unit7 in 'Unit7.pas' {Form7};

{$R *.res}

Const MyUniqueID:String='Computer Information''s Toolbar';

begin
  If (FindWindow('TForm1','CIT v1.0')=0) Then
    Begin
  Application.Initialize;
  //If (MultipleInstance.IsAllreadyStarted(MyUniqueID)) Then
  //  Begin
  //    If (MultipleInstance.ShowApplication(MyUniqueID)) Then Exit;
  //  End;
  MultipleInstance.SetAppHandle(MyUniqueID, Application.Handle);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TNetworkSettingsForm, NetworkSettingsForm);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TForm6, Form6);
  Application.CreateForm(TForm7, Form7);
  Application.Run;
    End;
end.
