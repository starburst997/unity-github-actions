//#define AppDisplay "Unity Test"
//#define App "Unity.Test"
//#define Folder "build-windows"
//#define Version "1.0.0"
//#define Copyright "Copyright (C) 2025 Jean-Denis Boivin"
//#define Company "Jean-Denis Boivin"

[Setup]
AppName={#AppDisplay}
AppVersion={#Version}
VersionInfoVersion={#Version}
AppCopyright={#Copyright}
AppPublisher={#Company}
WizardStyle=modern
DefaultDirName={autopf}\{#AppDisplay}
DefaultGroupName={#AppDisplay}
Compression=lzma2
SolidCompression=yes
OutputDir=setup
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=lowest
OutputBaseFilename={#App}.setup
SetupIconFile=icon.ico
UninstallDisplayIcon={app}\{#AppDisplay}.exe
CloseApplications=force

//PrivilegesRequiredOverridesAllowed=dialog 
PrivilegesRequiredOverridesAllowed=commandline

[Files]
Source: "{#Folder}\*"; DestDir: "{app}\"; Flags: ignoreversion recursesubdirs

[Icons]
Name: "{group}\{#AppDisplay}"; Filename: "{app}\{#AppDisplay}.exe"

[Run]
Filename: {app}\{#AppDisplay}.exe; Description: {cm:LaunchProgram,{#AppDisplay}}; Flags: nowait postinstall skipifsilent

// Personally, I prefer installers that are "one-click", this auto skip all pages and user inputs
// This makes the installer act as if "/SILENT" was used
[Code]
function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result := True;
end;

function SetTimer(hWnd, nIDEvent, uElapse, lpTimerFunc: LongWord): LongWord;
  external 'SetTimer@User32.dll stdcall';
function KillTimer(hWnd, nIDEvent: LongWord): LongWord;
  external 'KillTimer@User32.dll stdcall';

var
  SubmitPageTimer: LongWord;

procedure KillSubmitPageTimer;
begin
  KillTimer(0, SubmitPageTimer);
  SubmitPageTimer := 0;
end;  

procedure SubmitPageProc(
  H: LongWord; Msg: LongWord; IdEvent: LongWord; Time: LongWord);
begin
  WizardForm.NextButton.OnClick(WizardForm.NextButton);
  KillSubmitPageTimer;
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = wpReady then
  begin
    SubmitPageTimer := SetTimer(0, 0, 100, CreateCallback(@SubmitPageProc));
  end
    else
  begin
    if SubmitPageTimer <> 0 then
    begin
      KillSubmitPageTimer;
    end;
  end;
end;