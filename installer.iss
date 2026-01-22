#define MyAppName "Hash Renamer"
#define MyAppExeName "hash_renamer.exe"
#define MyAppPublisher "MyGitHubUser"

; 优化：允许 Actions 通过命令行 /D 参数传入版本号
; 如果本地编译没传参数，则使用默认值 "1.0.0"
#ifndef MyAppVersion
  #define MyAppVersion "1.0.0"
#endif

[Setup]
AppId={{B927D793-HASH-RENAME-ABC}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes

; 基础配置
OutputBaseFilename=HashRenamer_Setup
; 优化：明确输出目录为 Output，方便 Actions 抓取
OutputDir=Output

Compression=lzma2
SolidCompression=yes
PrivilegesRequired=admin
ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "target\release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion

[Registry]
; ------------------------------------------------------------
; 1. 右键点击【文件夹图标】 (Directory)
; 场景：在父目录对着文件夹图标右键
; ------------------------------------------------------------
Root: HKCR; Subkey: "Directory\shell\{#MyAppName}"; ValueType: string; ValueName: ""; ValueData: "Rename Files inside (MD5)"; Flags: uninsdeletekey
Root: HKCR; Subkey: "Directory\shell\{#MyAppName}"; ValueType: string; ValueName: "Icon"; ValueData: "imageres.dll,-80"; Flags: uninsdeletekey
Root: HKCR; Subkey: "Directory\shell\{#MyAppName}\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""; Flags: uninsdeletekey

; ------------------------------------------------------------
; 2. 【修复】右键点击【文件夹内部空白处】 (Directory Background)
; 场景：进入文件夹后，在空白处右键
; 注意：这里必须使用 "%V" (Working Directory)，而不是 "%1"
; ------------------------------------------------------------
Root: HKCR; Subkey: "Directory\Background\shell\{#MyAppName}"; ValueType: string; ValueName: ""; ValueData: "Rename Files Here (MD5)"; Flags: uninsdeletekey
Root: HKCR; Subkey: "Directory\Background\shell\{#MyAppName}"; ValueType: string; ValueName: "Icon"; ValueData: "imageres.dll,-80"; Flags: uninsdeletekey
Root: HKCR; Subkey: "Directory\Background\shell\{#MyAppName}\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%V"""; Flags: uninsdeletekey

; ------------------------------------------------------------
; 3. 右键点击【单个文件】 (*)
; ------------------------------------------------------------
Root: HKCR; Subkey: "*\shell\{#MyAppName}"; ValueType: string; ValueName: ""; ValueData: "Rename to MD5"; Flags: uninsdeletekey
Root: HKCR; Subkey: "*\shell\{#MyAppName}"; ValueType: string; ValueName: "Icon"; ValueData: "imageres.dll,-80"; Flags: uninsdeletekey
Root: HKCR; Subkey: "*\shell\{#MyAppName}\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""; Flags: uninsdeletekey