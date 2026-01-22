#define MyAppName "Hash Renamer"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "MyGitHubUser"
#define MyAppExeName "hash_renamer.exe"

[Setup]
AppId={{B927D793-HASH-RENAME-ABC}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
OutputBaseFilename=HashRenamer_Setup
Compression=lzma
SolidCompression=yes
PrivilegesRequired=admin
ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "target\release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion

[Registry]
; 1. Right-click on FOLDERS (Batch Rename)
Root: HKCR; Subkey: "Directory\shell\{#MyAppName}"; ValueType: string; ValueName: ""; ValueData: "Rename Files inside (MD5)"; Flags: uninsdeletekey
Root: HKCR; Subkey: "Directory\shell\{#MyAppName}"; ValueType: string; ValueName: "Icon"; ValueData: "imageres.dll,-80"; Flags: uninsdeletekey
Root: HKCR; Subkey: "Directory\shell\{#MyAppName}\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""; Flags: uninsdeletekey

; 2. Right-click on SINGLE FILES
Root: HKCR; Subkey: "*\shell\{#MyAppName}"; ValueType: string; ValueName: ""; ValueData: "Rename to MD5"; Flags: uninsdeletekey
Root: HKCR; Subkey: "*\shell\{#MyAppName}"; ValueType: string; ValueName: "Icon"; ValueData: "imageres.dll,-80"; Flags: uninsdeletekey
Root: HKCR; Subkey: "*\shell\{#MyAppName}\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""; Flags: uninsdeletekey