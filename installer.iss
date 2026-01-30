#define MyAppName "Hash Renamer"
#define MyAppExeName "hash_renamer.exe"
#define MyAppPublisher "MyGitHubUser"

#ifndef MyAppVersion
  #define MyAppVersion "1.0.0"
#endif

[Setup]
AppId={{326968ce-83cd-470c-b1a8-cc4d01ffff43}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes

OutputBaseFilename=HashRenamer_Setup
OutputDir=Output

Compression=lzma2
SolidCompression=yes
PrivilegesRequired=admin
ArchitecturesInstallIn64BitMode=x64
; [新增] 设置安装包自身的图标
SetupIconFile=app_icon.ico

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "target\release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion

[Registry]
; ------------------------------------------------------------
; 1. 右键点击【文件夹图标】 (Directory)
; ------------------------------------------------------------
Root: HKCR; Subkey: "Directory\shell\{#MyAppName}"; ValueType: string; ValueName: ""; ValueData: "Rename Files inside (MD5)"; Flags: uninsdeletekey
; [修改] 图标指向主程序 (原为 imageres.dll,-80)
Root: HKCR; Subkey: "Directory\shell\{#MyAppName}"; ValueType: string; ValueName: "Icon"; ValueData: "{app}\{#MyAppExeName}"; Flags: uninsdeletekey
Root: HKCR; Subkey: "Directory\shell\{#MyAppName}\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""; Flags: uninsdeletekey

; ------------------------------------------------------------
; 2. 【修复】右键点击【文件夹内部空白处】 (Directory Background)
; ------------------------------------------------------------
Root: HKCR; Subkey: "Directory\Background\shell\{#MyAppName}"; ValueType: string; ValueName: ""; ValueData: "Rename Files Here (MD5)"; Flags: uninsdeletekey
; [修改] 图标指向主程序
Root: HKCR; Subkey: "Directory\Background\shell\{#MyAppName}"; ValueType: string; ValueName: "Icon"; ValueData: "{app}\{#MyAppExeName}"; Flags: uninsdeletekey
Root: HKCR; Subkey: "Directory\Background\shell\{#MyAppName}\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%V"""; Flags: uninsdeletekey

; ------------------------------------------------------------
; 3. 右键点击【单个文件】 (*)
; ------------------------------------------------------------
Root: HKCR; Subkey: "*\shell\{#MyAppName}"; ValueType: string; ValueName: ""; ValueData: "Rename to MD5"; Flags: uninsdeletekey
; [修改] 图标指向主程序
Root: HKCR; Subkey: "*\shell\{#MyAppName}"; ValueType: string; ValueName: "Icon"; ValueData: "{app}\{#MyAppExeName}"; Flags: uninsdeletekey
Root: HKCR; Subkey: "*\shell\{#MyAppName}\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""; Flags: uninsdeletekey