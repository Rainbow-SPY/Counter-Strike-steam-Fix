@echo off
mode con cols=80 lines=25
title GE ������ �汾 v2.1.0
setlocal EnableDelayedExpansion
@rem ���ûҳ����
chcp 936>NUL
@rem ���32λ��64λϵͳ
if exist "%WinDir%\SysWOW64" (
	set "HostArchitecture=x64"
) else (
	set "HostArchitecture=x86"
)
:CheckService
if not exist "ToolKit.Application.service.goldengine.bat" (
	.\crashreportor\ToolKit.crashreportor.service.goldengine_%HostArchitecture%.exe
	exit
)
:CheckAdmin
@rem ���Ȩ���Ƿ���TrustedInstaller
Whoami|find /i "system">NUL
if errorlevel 1 (
	for /f "tokens=3 delims= " %%i in (
		'reg query "HKEY_CURRENT_USER\SOFTWARE\Valve\Steam" /v SteamExe'
	) do (
		echo %%i>%LOCALAPPDATA%\GoldEngine-ToolKit\cstrike\bin\steamPath.ini
	)
	start ToolKit.Application.service.goldengine.bat -service -admin -jump-steamPath
	exit
) else (
	echo.
	cls
)
:ReadMe //�����û����Э��
echo.===============================================================================
echo.######################## GE ������  - �����û����Э�� #########################
echo.===============================================================================
echo.
echo. Copyright (C) Rainbow SPY Technology(2019-2024). All rights reserved.
echo.
echo.
echo. GE ������������ڽ�Դ���濪������Ϸ
echo.
echo.
echo. �� GE �����䡰���������ṩ��ԭ�����ṩ�����Ҳ����κ���ʾ��ʾ�Եı�֤�����κ�
echo. ���֮�£����߾��������Ϊʹ�ô˽ű����ù��߶����¿��ܵ��κ��ƻ��е����Ρ���
echo. ����������κ���ҵ��Ϊ�������κη������⽫��ʹ���߳е���
echo.
echo.
echo. GE �����佫��ʹ�ø��������������������е�һ����������Ϊ��
echo.
echo.
echo. GE �����䡢��Դ���桢Gold Engine ��Ϊ����Թ�˾�����ߵ�ע���̱ꡣ
echo. (C) Microsoft Corporation. All rights reserved.
echo. 7-Zip Copyright (C) 1999-2018 Igor Pavlov.
echo. Copyright (C) 2021 Valve Corporation
echo.===============================================================================
%windir%\system32\choice.exe /C:AR /N /M "########################[ ����A��ͬ�� / ����R���ܾ� ]#########################"
if errorlevel 2 (
	color 00
	exit
)
:CheckTrustedInstaller
set srvname="TrustedInstaller" 
sc query|find %srvname% >NUL|| net start %srvname%
if errorlevel 1 (
	.\crashreportor\ToolKit.crashreportor.service.TrustedInstaller_%HostArchitecture%.exe
	exit
)
:CheckSteamPath
if exist "%LOCALAPPDATA%\GoldEngine-ToolKit\cstrike\bin\steamPath.ini" (
	pause
) else (
	.\crashreportor\ToolKit.crashreportor.config.steampath_%HostArchitecture%.exe
	exit
)
:ComputerInfo // �����ռ�������Ϣ
cls
@rem ���ڼ���Ƿ�ΪWindows 11 ϵͳ
for /f "tokens=3 delims= " %%i in (
	'reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "CurrentBuild" ^| find "REG_SZ"'
) do (
	set HostBuild=%%i
)
@rem ������ϵͳ�ڲ��汾
for /f "tokens=3 delims= " %%j in (
	'reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /f "ReleaseId" ^| find "REG_SZ"'
) do (
	set /A "HostReleaseVersion=%%j" & if "%%j" lss "2004" set HostDisplayVersion=%%j
)
if "%HostDisplayVersion%" equ "" (
	for /f "tokens=3 delims= " %%k in (
		'reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "DisplayVersion" ^| find "REG_SZ"'
	) do (
		set "HostDisplayVersion=%%k"
	)
)
@rem ������ϵͳ�汾
for /f "tokens=3 delims= " %%l in (
	'reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "EditionID" ^| find "REG_SZ"'
) do (
	if %%l equ Professional (
		set "HostEdition=רҵ��"
	) else (
		set "HostEdition=%%l"
	)
)
@rem ������ϵͳ�Ƿ�Ϊ�������汾
for /f "tokens=3 delims= " %%m in (
	'reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "InstallationType" ^| find "REG_SZ"'
) do (
	if %%m equ Client ( 
		set "HostInstallationType=�ͻ���"
	) else (
		set "HostInstallationType=%%m"
	)
)
for /f "tokens=7 delims=[]. " %%r in (
	'ver 2^>nul'
) do (
	set /A HostServicePackBuild=%%r
)
@rem ������ϵͳΪWindows x.x
for /f "tokens=4-5 delims=[]. " %%s in (
	'ver 2^>nul'
) do (
	set "HostVersion=%%s.%%t" & set "HostOSVersion=%%s"
)
if "%HostVersion%" equ "6.1" (
	set "HostOSVersion=7 SP1"
)
if "%HostVersion%" equ "6.3" (
	set "HostOSVersion=8.1"
)
if "%HostVersion%" equ "10.0" (
	if "%HostBuild%" geq "21996" (
		set "HostOSVersion=11"
	)
)
@rem ������ϵͳ����
for /f "tokens=3 delims=\ " %%o in (
	'reg query "HKCU\Control Panel\International\User Profile" /s /v "Languages" ^| findstr /I "REG_ _SZ"'
) do (
	if %%o equ zh-Hans-CN (
		set "HostLanguage=zh-CN"
	) else (
		set "HostLanguage=%%o"
	)
)
echo.===============================================================================
echo.                                GE ������ - ����
echo.===============================================================================
echo.
echo.���ڶ�ȡ��������ϵͳ��Ϣ����
echo.
echo.Windows %HostOSVersion% %HostEdition% %HostInstallationType% %HostDisplayVersion% - v%HostVersion%.%HostBuild%.%HostServicePackBuild% %HostArchitecture% %HostLanguage%
pause
:Command //�����������־�Ӣ��Ϸ��������
set Command_Game=
set Command_1=
set Command_2=
set Command_3=
set Command_4=
set HlCommand_1=
set HlCommand_2=
set HlCommand_3=
set HlCommand_4=
:DownloadList // aria2c���������ӿ�
set Link1=https://raw.fgit.cf/Rainbow-SPY/Counter-Strike-steam-Fix/Res-aria2c/resource-1.1.0-Offical.7z
set Link2=https://raw.fgit.cf/Rainbow-SPY/Counter-Strike-steam-Fix/Res-aria2c/cstrike_schinese/titles.txt
set Link3=https://raw.fgit.cf/Rainbow-SPY/Counter-Strike-steam-Fix/Res-aria2c/cstrike_english.txt
set Link4=https://raw.fgit.cf/Rainbow-SPY/Counter-Strike-steam-Fix/Res-aria2c/gameui_english.txt
set Link5=https://raw.fgit.cf/Rainbow-SPY/Counter-Strike-steam-Fix/Res-aria2c/serverbrowser_english.txt
set Link6=https://raw.fgit.cf/Rainbow-SPY/Counter-Strike-steam-Fix/Res-aria2c/valve_english.txt
:Path //����·��
set "ver=v2.0"
set "_#APPDATA#=%LOCALAPPDATA%\GoldEngine-ToolKit\cstrike\bin"
set "cstike_ver=Counter-Strike-1.6-vSteam"
set "title=GE ������ �汾: %ver%"
set "_line=-------------------------------------"
set "_Ecode_DLL_Engine_OpenGL=False"
set "_Ecode_DLL_Engine_D3D=False"
set "_Ecode_DLL_Engine_Software=False"
:CheckRes
if not exist "%~dp0bin\aria2\aria2c.exe" (
	.\crashreportor\ToolKit.crashreportor.aria2_%HostArchitecture%.exe
	exit
) else (
	echo.
)
for /f %%i in (
	'type %LOCALAPPDATA%\GoldEngine-ToolKit\cstrike\bin\steamPath.ini'
) do (
	.\bin\reg.exe add "HKCU\Software\Rainbow-SPY\GoldEngine-ToolKit\Settings" /v "SteamPath" /d "%%i" /F
)

:CheckFolder
if exist "%_#APPDATA#%" (
	echo.>NUL
) else (
	md "%_#APPDATA#%"
)
if exist "%_#APPDATA#%\Backup" (
    set _backup=%_#APPDATA#%\Backup
) else (
	md "%_#APPDATA#%\Backup"
)
if exist ".\Download" (
	rd /s/q ".\Download"
) else (
	md ".\Download"
)
@rem ���´�������¸��汾���� 
@rem if exist ".\cstrike_schinese" (
@rem     echo.>NUL
@rem ) else (
@rem 	md ".\cstrike_schinese"
@rem )
@rem if exist ".\platform" (
@rem     echo.>NUL
@rem ) else ( 
@rem 	md ".\platform"
@rem )
@rem if exist ".\platform\servers" (
@rem     echo.>NUL
@rem ) else (
@rem 	md ".\platform\servers"
@rem )
:Backup
copy /y "%~f0" "%_backup%" >NUL 2>NUL
if errorlevel 1 (
	.\crashreportor\ToolKit.crashreportor.system.copy_%HostArchitecture%.exe"
	exit
)
if errorlevel 0 (
	echo.>NUL
)
ren "%_backup%\GE ToolKit.bat" "Bak_%date:~0,4%_%date:~5,2%_%date:~8,2%_%time:~0,2%_%time:~3,2%_%time:~6,2%.bat"
if not exist "%_#APPDATA#%\certificate.ini" (
	echo [certificate]>>%_#APPDATA#%\certificate.ini
	call :certificate
) else (
	echo.>NUL
)
:MainMenu
cls
echo.===============================================================================
echo.                          GE ������ - ��  ��  ��
echo.===============================================================================
echo.
echo.                             [1]   ������Ϸ
echo.
echo.                             [2]   ������Ϸ
echo.
echo.                             [3]   ��      ��
echo.
echo.                             [4]   �Զ����λ
echo.
echo.                             [5]   �����л�
echo.
echo.                             [6]   ����ģ��
echo.
echo.                             [7]   ���ϰ�
echo.
echo.                             [8]   ��������
echo.
echo.                             [X]   ��      ��
echo.
echo.===============================================================================
choice /C:12345678X /N /M "���������ѡ�� ��"
if errorlevel 9 (
	exit
)
if errorlevel 8 (
	goto :Background
)
if errorlevel 7 (
	goto :All-in-one-Pack
)
if errorlevel 6 (
	goto :ChooseModels
)
if errorlevel 5 (
	goto :ChooseSoundLanguage
)
if errorlevel 4 (
	goto :Custombind
)
if errorlevel 3 (
	goto :ReportIssues
)
if errorlevel 2 (
	goto :ChineseText
)
if errorlevel 1 (
	goto :ChooseGame
)
:ChooseGame
cls
echo.===============================================================================
echo.                          GE ������ - ������Ϸ
echo.===============================================================================
echo.
echo ѡ�����������Ϸ......
echo.
echo.
echo.
echo ����Half-Life �� Half-Life:Uplink      ���� [1]
echo.
echo.
echo.
echo.
echo.
echo ����Counter-Strike                     ���� [2]
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.===============================================================================
echo.
.\bin\choice /c 12 /n /m "���ѡ��"
set _el=%errorlevel% 
if %_el%==1 (
	goto Half-life-config
)
if %_el%==2 (
	goto cstike-config-sv_rollangle
)
:Half-life-config
cls
echo.===============================================================================
echo.                          MSMG ������ - ������
echo.===============================================================================
echo.
echo.����ѡ������Ϸ��Half-Life �� Half-Life:Uplinkl
echo.
echo.
echo.
echo.��ѡ����Ҫ���ص�������......
echo.
echo.
echo.
echo.[1] �����ӽǻζ�����(Ĭ�ϣ�True, 2)
echo.
echo.
echo.
echo.[2] ������ǹ(Ĭ�ϣ�False, 0)
echo.
echo.
echo.
echo.[3] ������Ϸ
echo.
echo.===============================================================================
echo.
.\bin\choice /c 123 /n /m "���ѡ��"
if %errorlevel%==1 (
	goto Half-life-config-sv_rollangle
)
if %errorlevel%==2 (
	goto Half-Life-config-hud_fastswitch
)
if %errorlevel%==3 (
	goto RunningandEND
)
:cstike-config-sv_rollangle
echo [01] �ӽǻζ� ^| ��ǰ��ֵ��%sv_rollangle%
echo      - 0 ^| �ްڶ�����
echo      - 1 ^| �ڶ�����С
echo      - 2 ^| �ڶ����ȴ�
set /p sv_rollangle= # ���������������ֵ��
if "%sv_rollangle%" equ "0" (
	set %Command_1%=sv_rollangle 0
	echo ���� sv_rollangle=0
	goto cstike-config-hud_fastswitch
)
if "%sv_rollangle%" equ "1" (
	set %Command_1%=sv_rollangle 1
	echo ���� sv_rollangle=1
	goto cstike-config-hud_fastswitch
)
if "%sv_rollangle%" equ "2" (
	set %Command_1%=sv_rollangle 2
	echo ���� sv_rollangle=2
	goto cstike-config-hud_fastswitch
)
goto Half-life-config-sv_rollangle
:cstike-config-hud_fastswitch
echo [02] ������ǹ ^| ��ǰ��ֵ��%hud_fastswitch%
echo      - 0 ^| ���� ������ǹ
echo      - 1 ^| ���� ������ǹ
set /p ConfigChoice= # ���������������ֵ��
if "%hud_fastswitch%" equ "0" (
	set %Command_2%=hud_fastswitch 0
	echo ���� hud_fastswitch=0
	goto 
)
if "%hud_fastswitch%" equ "1" (
	set %Command_2%=hud_fastswitch 1
	echo ���� hud_fastswitch=1
)
goto cstike-config-hud_fastswitch
:cstike-config-cl_righthand
echo [03] ��ǹ�ӽ� ^| ��ǰ��ֵ��%cl_righthand%
echo      - 0 ^| ���ֳ�ǹ
echo      - 1 ^| ���ֳ�ǹ
set /p cl_righthand= # ���������������ֵ��
if "%cl_righthand%" equ "0" (
	set %Command_1%=cl_righthand 0
	echo ���� cl_righthand=0
	goto cstike-config-cl_righthand
)
if "%cl_righthand%" equ "1" (
	set %Command_1%=cl_righthand 1
	echo ���� cl_righthand=1
	goto cstike-config-cl_righthand
)
goto cstike-config-cl_righthand
:cstike-config-bind-all
echo.===============================================================================
echo.           GE ������ - �Զ����λ           ^|    ��ǰ���ã�config.cfg
echo.===============================================================================
echo [1]       ǰ��  ^|  Ĭ�ϼ�λ	[ W ]          ^|   ��ǰ��λ	[%bind-config_forward%]
echo [2]       ����  ^|  Ĭ�ϼ�λ	[ S ]          ^|   ��ǰ��λ	[%bind-config_back%]
echo [3]       ����  ^|  Ĭ�ϼ�λ	[ A ]          ^|   ��ǰ��λ	[%bind-config_moveleft%]
echo [4]       ����  ^|  Ĭ�ϼ�λ	[ D ]          ^|   ��ǰ��λ	[%bind-config_moveright%]
echo [5]       ����  ^|  Ĭ�ϼ�λ	[ LEFT SHIFT ] ^|   ��ǰ��λ	[%bind-config_speed%]
echo [6]       ��Ծ  ^|  Ĭ�ϼ�λ	[ SPACE ]      ^|   ��ǰ��λ	[%bind-config_jump%]
echo [7]       �׷�  ^|  Ĭ�ϼ�λ	[ LEFT CTRL ]  ^|   ��ǰ��λ	[%bind-config_duck%]
echo [8]     ��˷�  ^|  Ĭ�ϼ�λ	[ J ]          ^|   ��ǰ��λ	[%bind-config_voicerecord%]
echo [9]   ȫ����Ϣ  ^|  Ĭ�ϼ�λ	[ Y ]          ^|   ��ǰ��λ	[%bind-config_messagemode%]
echo [0]   �Ŷ���Ϣ  ^|  Ĭ�ϼ�λ	[ U ]          ^|   ��ǰ��λ	[%bind-config_messagemode2%]
echo [A]   ����˵�  ^|  Ĭ�ϼ�λ	[ B ]          ^|   ��ǰ��λ	[%bind-config_buy%]
@rem echo ������������ҩ  ^|  Ĭ�ϼ�λ	[ . ]          ^|   ��ǰ��λ	[]
@rem echo ����������ҩ  ^|  Ĭ�ϼ�λ	[ , ]          ^|   ��ǰ��λ	[]
@rem echo   ����װ���˵�  ^|  Ĭ�ϼ�λ	[ O ]          ^|   ��ǰ��λ	[]
echo [B]    �Զ����� ^|  Ĭ�ϼ�λ	[ F1 ]         ^|   ��ǰ��λ	[%bind-config_autobuy%]
echo [C]    ���¹��� ^|  Ĭ�ϼ�λ	[ F3 ]         ^|   ��ǰ��λ	[%bind-config_rebuy%]
echo [D]    ѡ����� ^|  Ĭ�ϼ�λ	[ M ]          ^|   ��ǰ��λ	[%bind-config_chooseteam%]
echo.===============================================================================
echo [X]    ���ز˵�
echo.
choice /c 1234567890ABCDX /n /m "���������б༭��λ..."
set _el=%errorlevel% 
if %_el%==1 (
	goto bind_forward
)
if %_el%==2 (
	goto bind_back
)
if %_el%==3 (
	goto bind_moveleft
)
if %_el%==4 (
	goto bind_moveright
)
if %_el%==5 (
	goto bind_speed
)
if %_el%==6 (
	goto bind_jump
)
if %_el%==7 (
	goto bind_duck
)
if %_el%==8 (
	goto bind_voicerecord
)
if %_el%==9 (
	goto bind_messagemode
)
if %_el%==0 (
	goto bind_messagemode2
)
if %_el%==A (
	goto bind_buy
)
if %_el%==B (
	goto bind_autobuy
)
if %_el%==C (
	goto bind_rebuy
)
if %_el%==D (
	goto bind_chooseteam
)
if %_el%==X (
	goto 
)
:bind_forward
cls
echo.===============================================================================
echo.           GE ������ - �Զ����λ           ^|    ��ǰ��λ��[%bind-config_forward%]
echo.===============================================================================
echo.
echo.
echo.
echo.�����·���������Ҫ���ĵļ�λ...
echo.
echo.
echo.          =======================================================
echo.                            ��           ��
echo.          =======================================================
echo.ע�⣡
echo.
echo.����������ַ�/���ֽ�������Ч������ر�֤��ƴд����
echo.
echo.�����쳣�����´�ʹ�ù�����ʱ����ѡ�����ü�λ
echo.
echo.������ɺ󣬵���Enter�س�������.
echo.
echo.�ο���W S A D F1 F2
echo.
echo.
echo.
set /p bind-config_forward= # ���������������ֵ��
:bind_back
cls
echo.===============================================================================
echo.           GE ������ - �Զ����λ           ^|    ��ǰ��λ��[%bind-config_back%]
echo.===============================================================================
echo.
echo.
echo.
echo.�����·���������Ҫ���ĵļ�λ...
echo.
echo.
echo.          =======================================================
echo.                            ��           ��
echo.          =======================================================
echo.ע�⣡
echo.
echo.����������ַ�/���ֽ�������Ч������ر�֤��ƴд����
echo.
echo.�����쳣�����´�ʹ�ù�����ʱ����ѡ�����ü�λ
echo.
echo.������ɺ󣬵���Enter�س�������.
echo.
echo.�ο���W S A D F1 F2
echo.
echo.
echo.
set /p bind-config_back= # ���������������ֵ��
:bind_moveleft
cls
echo.===============================================================================
echo.           GE ������ - �Զ����λ           ^|    ��ǰ��λ��[%bind-config_moveleft%]
echo.===============================================================================
echo.
echo.
echo.
echo.�����·���������Ҫ���ĵļ�λ...
echo.
echo.
echo.          =======================================================
echo.                            ��           ��
echo.          =======================================================
echo.ע�⣡
echo.
echo.����������ַ�/���ֽ�������Ч������ر�֤��ƴд����
echo.
echo.�����쳣�����´�ʹ�ù�����ʱ����ѡ�����ü�λ
echo.
echo.������ɺ󣬵���Enter�س�������.
echo.
echo.�ο���W S A D F1 F2
echo.
echo.
echo.
set /p bind-config_moveleft= # ���������������ֵ��
:bind_moveright
cls
echo.===============================================================================
echo.           GE ������ - �Զ����λ           ^|    ��ǰ��λ��[%bind-config_moveright%]
echo.===============================================================================
echo.
echo.
echo.
echo.�����·���������Ҫ���ĵļ�λ...
echo.
echo.
echo.          =======================================================
echo.                            ��           ��
echo.          =======================================================
echo.ע�⣡
echo.
echo.����������ַ�/���ֽ�������Ч������ر�֤��ƴд����
echo.
echo.�����쳣�����´�ʹ�ù�����ʱ����ѡ�����ü�λ
echo.
echo.������ɺ󣬵���Enter�س�������.
echo.
echo.�ο���W S A D F1 F2
echo.
echo.
echo.
set /p bind-config_moveright= # ���������������ֵ��
:bind_speed
cls
echo.===============================================================================
echo.           GE ������ - �Զ����λ           ^|    ��ǰ��λ��[%bind-config_speed%]
echo.===============================================================================
echo.
echo.
echo.
echo.�����·���������Ҫ���ĵļ�λ...
echo.
echo.
echo.          =======================================================
echo.                            ��           ��
echo.          =======================================================
echo.ע�⣡
echo.
echo.����������ַ�/���ֽ�������Ч������ر�֤��ƴд����
echo.
echo.�����쳣�����´�ʹ�ù�����ʱ����ѡ�����ü�λ
echo.
echo.������ɺ󣬵���Enter�س�������.
echo.
echo.�ο���W S A D F1 F2
echo.
echo.
echo.
set /p bind-config_speed= # ���������������ֵ��
:bind_jump
cls
echo.===============================================================================
echo.           GE ������ - �Զ����λ           ^|    ��ǰ��λ��[%bind-config_jump%]
echo.===============================================================================
echo.
echo.
echo.
echo.�����·���������Ҫ���ĵļ�λ...
echo.
echo.
echo.          =======================================================
echo.                            ��           ��
echo.          =======================================================
echo.ע�⣡
echo.
echo.����������ַ�/���ֽ�������Ч������ر�֤��ƴд����
echo.
echo.�����쳣�����´�ʹ�ù�����ʱ����ѡ�����ü�λ
echo.
echo.������ɺ󣬵���Enter�س�������.
echo.
echo.�ο���W S A D F1 F2
echo.
echo.
echo.
set /p bind-config_jump= # ���������������ֵ��
:bind_duck
cls
echo.===============================================================================
echo.           GE ������ - �Զ����λ           ^|    ��ǰ��λ��[%bind-config_duck%]
echo.===============================================================================
echo.
echo.
echo.
echo.�����·���������Ҫ���ĵļ�λ...
echo.
echo.
echo.          =======================================================
echo.                            ��           ��
echo.          =======================================================
echo.ע�⣡
echo.
echo.����������ַ�/���ֽ�������Ч������ر�֤��ƴд����
echo.
echo.�����쳣�����´�ʹ�ù�����ʱ����ѡ�����ü�λ
echo.
echo.������ɺ󣬵���Enter�س�������.
echo.
echo.�ο���W S A D F1 F2
echo.
echo.
echo.
set /p bind-config_duck= # ���������������ֵ��
:bind_voicerecord
cls
echo.===============================================================================
echo.           GE ������ - �Զ����λ           ^|    ��ǰ��λ��[%bind-config_voicerecord%]
echo.===============================================================================
echo.
echo.
echo.
echo.�����·���������Ҫ���ĵļ�λ...
echo.
echo.
echo.          =======================================================
echo.                            ��           ��
echo.          =======================================================
echo.ע�⣡
echo.
echo.����������ַ�/���ֽ�������Ч������ر�֤��ƴд����
echo.
echo.�����쳣�����´�ʹ�ù�����ʱ����ѡ�����ü�λ
echo.
echo.������ɺ󣬵���Enter�س�������.
echo.
echo.�ο���W S A D F1 F2
echo.
echo.
echo.
set /p bind-config_voicerecord= # ���������������ֵ��
:bind_messagemode
cls
echo.===============================================================================
echo.           GE ������ - �Զ����λ           ^|    ��ǰ��λ��[%bind-config_messagemode%]
echo.===============================================================================
echo.
echo.
echo.
echo.�����·���������Ҫ���ĵļ�λ...
echo.
echo.
echo.          =======================================================
echo.                            ��           ��
echo.          =======================================================
echo.ע�⣡
echo.
echo.����������ַ�/���ֽ�������Ч������ر�֤��ƴд����
echo.
echo.�����쳣�����´�ʹ�ù�����ʱ����ѡ�����ü�λ
echo.
echo.������ɺ󣬵���Enter�س�������.
echo.
echo.�ο���W S A D F1 F2
echo.
echo.
echo.
set /p bind-config_messagemode= # ���������������ֵ��
:bind_messagemode2
cls
echo.===============================================================================
echo.           GE ������ - �Զ����λ           ^|    ��ǰ��λ��[%bind-config_messagemode2%]
echo.===============================================================================
echo.
echo.
echo.
echo.�����·���������Ҫ���ĵļ�λ...
echo.
echo.
echo.          =======================================================
echo.                            ��           ��
echo.          =======================================================
echo.ע�⣡
echo.
echo.����������ַ�/���ֽ�������Ч������ر�֤��ƴд����
echo.
echo.�����쳣�����´�ʹ�ù�����ʱ����ѡ�����ü�λ
echo.
echo.������ɺ󣬵���Enter�س�������.
echo.
echo.�ο���W S A D F1 F2
echo.
echo.
echo.
set /p bind-config_messagemode2= # ���������������ֵ��
:bind_buy
cls
echo.===============================================================================
echo.           GE ������ - �Զ����λ           ^|    ��ǰ��λ��[%bind-config_buy%]
echo.===============================================================================
echo.
echo.
echo.
echo.�����·���������Ҫ���ĵļ�λ...
echo.
echo.
echo.          =======================================================
echo.                            ��           ��
echo.          =======================================================
echo.ע�⣡
echo.
echo.����������ַ�/���ֽ�������Ч������ر�֤��ƴд����
echo.
echo.�����쳣�����´�ʹ�ù�����ʱ����ѡ�����ü�λ
echo.
echo.������ɺ󣬵���Enter�س�������.
echo.
echo.�ο���W S A D F1 F2
echo.
echo.
echo.
set /p bind-config_buy= # ���������������ֵ��
:bind_autobuy
cls
echo.===============================================================================
echo.           GE ������ - �Զ����λ           ^|    ��ǰ��λ��[%bind-config_autobuy%]
echo.===============================================================================
echo.
echo.
echo.
echo.�����·���������Ҫ���ĵļ�λ...
echo.
echo.
echo.          =======================================================
echo.                            ��           ��
echo.          =======================================================
echo.ע�⣡
echo.
echo.����������ַ�/���ֽ�������Ч������ر�֤��ƴд����
echo.
echo.�����쳣�����´�ʹ�ù�����ʱ����ѡ�����ü�λ
echo.
echo.������ɺ󣬵���Enter�س�������.
echo.
echo.�ο���W S A D F1 F2
echo.
echo.
echo.
set /p bind-config_autobuy= # ���������������ֵ��
:bind_rebuy
cls
echo.===============================================================================
echo.           GE ������ - �Զ����λ           ^|    ��ǰ��λ��[%bind-config_rebuy%]
echo.===============================================================================
echo.
echo.
echo.
echo.�����·���������Ҫ���ĵļ�λ...
echo.
echo.
echo.          =======================================================
echo.                            ��           ��
echo.          =======================================================
echo.ע�⣡
echo.
echo.����������ַ�/���ֽ�������Ч������ر�֤��ƴд����
echo.
echo.�����쳣�����´�ʹ�ù�����ʱ����ѡ�����ü�λ
echo.
echo.������ɺ󣬵���Enter�س�������.
echo.
echo.�ο���W S A D F1 F2
echo.
echo.
echo.
set /p bind-config_rebuy= # ���������������ֵ��
:bind_chooseteam
cls
echo.===============================================================================
echo.           GE ������ - �Զ����λ           ^|    ��ǰ��λ��[%bind-config_chooseteam%]
echo.===============================================================================
echo.
echo.
echo.
echo.�����·���������Ҫ���ĵļ�λ...
echo.
echo.
echo.          =======================================================
echo.                            ��           ��
echo.          =======================================================
echo.ע�⣡
echo.
echo.����������ַ�/���ֽ�������Ч������ر�֤��ƴд����
echo.
echo.�����쳣�����´�ʹ�ù�����ʱ����ѡ�����ü�λ
echo.
echo.������ɺ󣬵���Enter�س�������.
echo.
echo.�ο���W S A D F1 F2
echo.
echo.
echo.
set /p bind-config_chooseteam= # ���������������ֵ��




















echo      ���� ^| �ڶ����ȴ�
echo      �����ڶ����� ^| �ڶ����ȴ�
echo      ���� ^| �ڶ����ȴ�
echo      ���ʹ�õ����� ^| �ڶ����ȴ�
echo      ҹ���� ^| �ڶ����ȴ�
echo      �ӵ����� ^| �ڶ����ȴ�
echo      ʹ����Ʒ ^| �ڶ����ȴ�
echo      �ֵ�Ͳ ^| �ڶ����ȴ�
echo      ��ͼ ^| �ڶ����ȴ�
set /p sv_rollangle= # ���������������ֵ��
:Half-life-config-sv_rollangle
echo [01] �ӽǻζ� ^| ��ǰ��ֵ��%sv_rollangle%
echo      - 0 ^| �ްڶ�����
echo      - 1 ^| �ڶ�����С
echo      - 2 ^| �ڶ����ȴ�
set /p sv_rollangle= # ���������������ֵ��
if "%sv_rollangle%" equ "0" (
	set %HlCommand_1%=sv_rollangle 0
	echo ���� sv_rollangle=0
	goto Half-life-config
)
if "%sv_rollangle%" equ "1" (
	set %HlCommand_1%=sv_rollangle 1
	echo ���� sv_rollangle=1
	goto Half-life-config
)
if "%sv_rollangle%" equ "2" (
	set %HlCommand_1%=sv_rollangle 2
	echo ���� sv_rollangle=2
	goto Half-life-config
)
goto Half-life-config
:Half-life-config-hud_fastswitch
echo [02] ������ǹ ^| ��ǰ��ֵ��%hud_fastswitch%
echo      - 0 ^| ���� ������ǹ
echo      - 1 ^| ���� ������ǹ
set /p ConfigChoice= # ���������������ֵ��
if "%hud_fastswitch%" equ "0" (
	set %HlCommand_2%=hud_fastswitch 0
	echo ���� hud_fastswitch=0
	goto Half-Life-config
)
if "%hud_fastswitch%" equ "1" (
	set %HlCommand_2%=hud_fastswitch 1
	echo ���� hud_fastswitch=1
	goto Half-life-config
)
goto Half-life-config-
:ChineseText
cls
set Nuber_aria2_download_compelete=1
set Nuber_aria2_download_all=5
set download_list_now=titles.txt
set download_list=%Link2%
if exist ".\Download\titles.txt" (
	set Nuber_aria2_download_compelete=2
	set download_list_now=cstrike_english.txt
	set download_list=%Link3%
)
if exist ".\Download\cstrike_english.txt" (
	set Nuber_aria2_download_compelete=3
	set download_list_now=gameui_english.txt
	set download_list=%Link4%
)
if exist ".\Download\gameui_english.txt" (
	set Nuber_aria2_download_compelete=4
	set download_list_now=serverbrowser_english.txt
	set download_list=%Link5%
)
if exist ".\Download\serverbrowser_english.txt" (
	set Nuber_aria2_download_compelete=5
	set download_list_now=valve_english.txt
	set download_list=%Link6%
)
if exist ".\Download\valve_english.txt" (
	goto ChineseTextComplete
)
echo.===============================================================================
echo.                          GE ������ - ������Ϸ
echo.===============================================================================
echo.
echo ����׼������......
title ������ [%Nuber_aria2_download_compelete%/%Nuber_aria2_download_all%]...... - aria2c - %title%
echo.===============================================================================
echo                        Download[%Nuber_aria2_download_compelete%/%Nuber_aria2_download_all%] - %download_list_now%
echo.===============================================================================
.\bin\aria2\aria2c.exe %download_list% -x 16 -c -d .\Download
goto ChineseText
:ChineseTextComplete
title 
echo.===============================================================================
echo.                          GE ������ - ������Ϸ
echo.===============================================================================
echo.
echo ���ں�����Ϸ.....
copy /y 
echo.������ɣ�
:aria2c-menu-cstike
cls
echo.
echo.
echo.
echo %_line%
echo			��Ҫ����
title ��Ҫ���� - aria2c - %title%
echo %_line%
echo ʹ�� aria2c ����������Դ��      ���� [1]
echo �����£������غ���              ���� [2]
.\bin\choice /c 12 /n /m "���ѡ��"
set _el=%errorlevel% 
if %_el%==1 (
	goto aria2c-download-resource
)
if %_el%==2 (
	echo [1.1.0]>>%_#APPDATA#%\Download-v1.1.0.ini
	echo 1.1.0 Update Pack Download Successful>>%_#APPDATA#%\Download-v1.1.0.ini
	goto Text
)
:aria2c-download-resource
cls
title ������[1/6]...... - aria2c - %title%
echo ----------------------------------------------------
echo        Download[1/6] - resource-1.1.0-Offical.7z
echo ----------------------------------------------------
.\bin\aria2c\aria2c.exe %Link1% -x 16 -c -d .\Download
cls
title ������[2/6]...... - aria2c - %title%
echo ----------------------------------------------------
echo        Download[2/6] - cstrike_english.txt
echo ----------------------------------------------------
.\bin\aria2c\aria2c.exe %Link12% -x 16 -c -d .\Download

cls
title ������[3/6]...... - aria2c - %title%
echo ----------------------------------------------------
echo        Download[3/6] - titles.txt
echo ----------------------------------------------------
.\bin\aria2c\aria2c.exe %Link13% -x 16 -c -d .\Download
cls
title ������[4/6]...... - aria2c - %title%
echo ----------------------------------------------------
echo        Download[4/6] - gameui_english.txt
echo ----------------------------------------------------
.\bin\aria2c\aria2c.exe %Link19% -x 16 -c -d .\Download

cls
title ������[5/6]...... - aria2c - %title%
echo ----------------------------------------------------
echo        Download[5/6] - serverbrowser_english.txt
echo ----------------------------------------------------
.\bin\aria2c\aria2c.exe %Link20% -x 16 -c -d .\Download

cls
title ������[6/6]...... - aria2c - %title%
echo ----------------------------------------------------
echo        Download[6/6] - valve_english.txt
echo ----------------------------------------------------
.\bin\aria2c\aria2c.exe %Link21% -x 16 -c -d .\Download
:aria2c-Download-successful
cls
title ������� - %title%
.\bin\mshta.exe vbscript:msgbox("�������",0+64+4096+65536,"")(window.close)
title ���ڼ����Դ������...... - %title%
echo ���ڼ����Դ������......
echo.
echo.
:aria2c-Check-Files-1
if not exist ".\Download\resource-1.1.0-Offical.7z" (
	echo 1���ļ���ȡʧ�ܣ�������������......
	.\bin\aria2c\aria2c.exe %Link1% -x 16 -c -d .\Download
	cls
	echo ���ڼ����Դ������......
	goto aria2c-Check-Files-1
) else (
	goto aria2c-Check-Files-12
)
:aria2c-Check-Files-12
if not exist ".\Download\titles.txt" (
	echo 1���ļ���ȡʧ�ܣ�������������......
    .\bin\aria2c\aria2c.exe %Link12% -x 16 -c -d .\Download
    cls
    echo ���ڼ����Դ������......
	goto aria2c-Check-Files-12
) else (
	goto aria2c-Check-Files-13
)
:aria2c-Check-Files-13
if not exist ".\Download\cstrike_english.txt" (
	echo 1���ļ���ȡʧ�ܣ�������������......
	.\bin\aria2c\aria2c.exe %Link13% -x 16 -c -d .\Download
	cls
	echo ���ڼ����Դ������......
	goto aria2c-Check-Files-13
) else (
	goto aria2c-Check-Files-14
)
:aria2c-Check-Files-14
if not exist ".\Download\gameui_english.txt" (
	echo 1���ļ���ȡʧ�ܣ�������������......
	.\bin\aria2c\aria2c.exe %Link19% -x 16 -c -d .\Download
	cls
	echo ���ڼ����Դ������......
	goto aria2c-Check-Files-14
) else (
	goto aria2c-Check-Files-15
)
:aria2c-Check-Files-15
if not exist ".\Download\serverbrowser_english.txt" (
	echo 1���ļ���ȡʧ�ܣ�������������......
	.\bin\aria2c\aria2c.exe %Link20% -x 16 -c -d .\Download
	cls
	echo ���ڼ����Դ������......
	goto aria2c-Check-Files-15
) else (
	goto aria2c-Check-Files-16
)
:aria2c-Check-Files-16
if not exist ".\Download\valve_english.txt" (
	echo 1���ļ���ȡʧ�ܣ�������������......
	.\bin\aria2c\aria2c.exe %Link21% -x 16 -c -d .\Download
	cls
	echo ���ڼ����Դ������......
	goto aria2c-Check-Files-16
) else (
	echo �����ļ�У�����.
)
:aria2c-Install-resource
title ��װ��...... - aria2c - %title%
echo.
echo.
echo.
echo ��װ��......
copy /y .\Download\titles.txt %~dp0\cstrike_schinese
copy /y .\Download\cstrike_english.txt %~dp0\cstrike\resource
copy /y .\Download\serverbrowser_english.txt %~dp0\platform\servers
copy /y .\Download\gameui_english.txt %~dp0\valve\resource
copy /y .\Download\valve_english.txt %~dp0\valve\resource
.\bin\7za.exe x .\Download\resource-1.1.0-Offical.7z -o%~dp0 -aoa >NUL
echo ��װ���!
title ��װ��ɣ� - aria2c - %title%
.\bin\mshta.exe vbscript:msgbox("��װ��ɣ�",0+64+4096+65536,"%title%")(window.close)
del /s /q .\cstrike_schinese\resource\cstrike_schinese.txt
rd /s/q .\Download
echo [1.1.0]>>Download-v1.1.0.ini
echo 1.1.0 Update Pack Download Successful>>Download-v1.1.0.ini
:ChooseCDKEY
cls
.\bin\mshta.exe vbscript:msgbox("Ϊ���ⱻValve�����ͬCD-KEY�������������ѡ��ͬCD-KEY������������",0+64+4096+65536,"%title%")(window.close)
title ѡ����ʹ�õ�CD-KEY...... - %title%
echo %_line%
echo ѡ����ʹ�õ�CD-KEY......
echo.
echo ����[  CDKEY1  ]  ���� [1]
echo ����[  CDKEY2  ]  ���� [2]
echo ����[  CDKEY3  ]  ���� [3]
echo ����[  CDKEY4  ]  ���� [4]
echo ����[  CDKEY5  ]  ���� [5]
echo ����[  CDKEY6  ]  ���� [6]
echo ����[  CDKEY7  ]  ���� [7]
echo ����[  CDKEY8  ]  ���� [8]
echo ����[  CDKEY9  ]  ���� [9]
echo ����[  CDKE10  ]  ���� [0]
echo %_line%
echo.
echo *Steam�����û���ʹ�÷�Steam��ʽ��Counter-Strike 1.6ʱ�������CD-KEY
echo.
.\bin\choice.exe /c 1234567890 /n /m "���ѡ��"
set _el=%errorlevel% 
if %_el%==1 (
	goto CDKEY1
)
if %_el%==2 (
	goto CDKEY2
)
if %_el%==3 (
	goto CDKEY3
)
if %_el%==4 (
	goto CDKEY4
)
if %_el%==5 (
	goto CDKEY5
)
if %_el%==6 (
	goto CDKEY6
)
if %_el%==7 (
	goto CDKEY7
)
if %_el%==8 (
	goto CDKEY8
)
if %_el%==9 (
	goto CDKEY9
)
if %_el%==10 (
	goto CDKEY10
)
:ChooseWideOrNormal
cls
title [SPY] ѡ����Ϸ�ֱ��ʱ���......
echo %_line%
echo ����[ ��ͨ 4:3  ]���� [1]
echo ����[ ���� 16:9 ]���� [2]
echo %_line%
echo.
.\bin\choice.exe /c 12 /n /m "���ѡ��"
set _el=%errorlevel% 
if %_el%==1 (
	goto 43Screen
)
if %_el%==2 (
	goto 169Screen
)
:ChooseScreenWindow
cls
title [SPY] ������Ϸ����......
echo %_line%
echo ����[ ��Ϸ���ڻ�  ]���� [1]
echo ����[ ��Ϸȫ����  ]���� [2]
echo %_line%
echo.
.\bin\choice.exe /c 12 /n /m "���ѡ��"
set _el=%errorlevel% 
if %_el%==1 (
	goto ScreenWindow
)
if %_el%==2 (
	goto NoScreenWindow
)
:ChooseScreenBPP
cls
title [SPY] ѡ����Ϸ����ɫ����......
echo %_line%
echo ����[ ��ɫ���� 32λ  ]���� [1]
echo ����[ ��ɫ���� 16λ  ]���� [2]
echo %_line%
echo.
.\bin\choice.exe /c 12 /n /m "���ѡ��"
set _el=%errorlevel% 
if %_el%==1 (
	goto 32xScreenBPP
)
if %_el%==2 (
	goto 16xScreenBPP
)
:ChooseEngine
cls
title [SPY] ѡ����Ϸ����......
echo %_line%
echo ����[ ��Ⱦģʽ ������� ]���� [1]
echo ����[ ��Ⱦģʽ OpenGL   ]���� [2]
echo %_line%
echo.
echo.
.\bin\choice.exe /c 12 /n /m "���ѡ��"
set _el=%errorlevel% 
if %_el%==1 (
	goto SoftwareEngine
)
if %_el%==2 (
	goto OpenGLEngine
)
:ChooseSoundLanguage
cls
title [SPY] ѡ����������......
echo %_line%
echo ����[ �������� ]���� [1]
echo ����[ Ӣ������   ]���� [2]
echo %_line%
echo.
echo.
.\bin\choice.exe /c 12 /n /m "���ѡ��"
set _el=%errorlevel% 
if %_el%==1 (
	goto ChineseSound
)
if %_el%==2 (
	goto EnglishSound
)
:ChineseSound
cls
title ������[1/1]...... - aria2c - %title%
echo ----------------------------------------------------
echo        Download[1/1] - resource_chinese_sound.zip
echo ----------------------------------------------------
.\bin\aria2c\aria2c.exe https://raw.fgit.cf/Rainbow-SPY/Counter-Strike-steam-Fix/Res-aria2c/resource_chinese_sound.zip -x 16 -c -d %aria2cDir%
title ��װ��...... - aria2c - %title%
echo ��װ��......
.\bin\7za.exe x .\Download\resource_chinese_sound.zip -o%~dp0\cstrike_schinese -aoa >NUL
title ��װ��ɣ� - aria2c - %title%
echo ��װ��ɣ�
goto loadRunningCstrikeandEND
:EnglishSound
cls
rd /s/q .\cstrike_schinese\sound
title ������ɣ� - aria2c - %title%
echo ������ɣ�
goto loadRunningCstrikeandEND
:43Screen
cls
title ѡ����ķֱ��� - %title%
echo %_line%
echo ����[  640x480  ]  ���� [1]
echo ����[  720x576  ]  ���� [2]
echo ����[  800x600  ]  ���� [3]
echo ����[  1024x768 ]  ���� [4]
echo ����[  1152x864 ]  ���� [5]
echo ����[  1280x960 ]  ���� [6]
echo ����[  1280x1024]  ���� [7]
echo %_line%
echo.
.\bin\choice.exe /c 1234567 /n /m "���ѡ��"
set _el=%errorlevel% 
if %_el%==1 (
	goto 640x480
)
if %_el%==2 (
	goto 720x576
)
if %_el%==3 (
	goto 800x600
)
if %_el%==4 (
	goto 1024x768
)
if %_el%==5 (
	goto 1152x864
)
if %_el%==6 (
	goto 1280x960
)
if %_el%==7 (
	goto 1280x1024
)
:169Screen
cls
title [SPY] ѡ����ķֱ���......
echo %_line%
echo ����[  1280x720  ]  ���� [1]
echo ����[  1280x800  ]  ���� [2]
echo ����[  1440x900  ]  ���� [3]
echo ����[  1600x900  ]  ���� [4]
echo ����[  1682x1050 ]  ���� [5]
echo ����[  1920x1080 ]  ���� [6]
echo %_line%
echo.
.\bin\choice.exe /c 123456 /n /m "���ѡ��"
set _el=%errorlevel% 
if %_el%==1 (
	goto 1280x720
)
if %_el%==2 (
	goto 1280x800
)
if %_el%==3 (
	goto 1440x900
)
if %_el%==4 (
	goto 1600x900
)
if %_el%==5 (
	goto 1682x1050
)
if %_el%==6 (
	goto 1920x1080
)
:CDKEY1
.\bin\reg.exe add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "5522H-HY5KC-VL6QQ-IGCHV-YJP2H" /F
if errorlevel 0 (
	echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini
	echo CD_KEY=5522H-HY5KC-VL6QQ-IGCHV-YJP2H>>%_#APPDATA#%\cd-key.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseWideOrNormal
:CDKEY2
.\bin\reg.exe add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "56RP8-4WYL5-49PQQ-59H92-Q3GKC" /F
if errorlevel 0 (
	echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini
	echo CD_KEY=56RP8-4WYL5-49PQQ-59H92-Q3GKC>>%_#APPDATA#%\cd-key.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseWideOrNormal
:CDKEY3
.\bin\reg.exe add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "547PV-RAE7Z-4XS5R-MMAPJ-I6AC3" /F >NUL 2>NUL
if errorlevel 0 (
	echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini
	echo CD_KEY=547PV-RAE7Z-4XS5R-MMAPJ-I6AC3>>%_#APPDATA#%\cd-key.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseWideOrNormal
:CDKEY4
.\bin\reg.exe add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "5RP2E-EPH3K-BR3LG-KMGTE-FN8PY" /F >NUL 2>NUL
if errorlevel 0 (
	echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini
	echo CD_KEY=5RP2E-EPH3K-BR3LG-KMGTE-FN8PY>>%_#APPDATA#%\cd-key.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseWideOrNormal
:CDKEY5
.\bin\reg.exe add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "5ZN2F-C6NTT-ZPBWP-L2DWQ-Y4B49" /F >NUL 2>NUL
if errorlevel 0 (
	echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini
	echo CD_KEY=5ZN2F-C6NTT-ZPBWP-L2DWQ-Y4B49>>%_#APPDATA#%\cd-key.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseWideOrNormal
:CDKEY6
.\bin\reg.exe add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "58V2E-CCKCJ-B8VSE-MEW9Y-ACB2K" /F >NUL 2>NUL
if errorlevel 0 (
	echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini
	echo CD_KEY=58V2E-CCKCJ-B8VSE-MEW9Y-ACB2K>>%_#APPDATA#%\cd-key.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseWideOrNormal
:CDKEY7
.\bin\reg.exe add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "5ZK2G-79JSD-FFSFD-CF35H-SDF4A" /F >NUL 2>NUL
if errorlevel 0 (
	echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini
	echo CD_KEY=5ZK2G-79JSD-FFSFD-CF35H-SDF4A>>%_#APPDATA#%\cd-key.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseWideOrNormal
:CDKEY8
.\bin\reg.exe add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "5Z62G-79JDV-79NAM-ZQVEB-ARBWY" /F >NUL 2>NUL
if errorlevel 0 (
	echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini
	echo CD_KEY=5Z62E-79JDV-79NAM-ZGVE6-ARBWY>>%_#APPDATA#%\cd-key.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseWideOrNormal
:CDKEY9
.\bin\reg.exe add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "5Z62E-79JDV-79NAM-ZGVE6-ARBWY" /F >NUL 2>NUL
if errorlevel 0 (
	echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini
	echo CD_KEY=5Z62G-79JDV-79NAM-ZQVEB-ARBWY>>%_#APPDATA#%\cd-key.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseWideOrNormal
:CDKEY10
.\bin\reg.exe add "HKCU\Software\Valve\Half-Life\Settings" /v "ValveKey" /d "5ZQ2A-NI239-4F4K7-H9N8Q-VTSYT" /F >NUL 2>NUL
if errorlevel 0 (
	echo [CD-KEY]>>%_#APPDATA#%\cd-key.ini
	echo CD_KEY=5ZQ2A-NI239-4F4K7-H9N8Q-VTSYT>>%_#APPDATA#%\cd-key.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseWideOrNormal
:640x480
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t REG_DWORD /f /d "480" >NUL 2>NUL
if errorlevel 0 (
	echo [Video]>>%_#APPDATA#%\video.ini
	echo Height=480>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t REG_DWORD /f /d "640" >NUL 2>NUL
if errorlevel 0 (
	echo Width=640>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenWindow
:720x576
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t reg_DWORD /f /d "576" >NUL 2>NUL
if errorlevel 0 (
	echo [Video]>>%_#APPDATA#%\video.ini
	echo Height=576>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t reg_DWORD /f /d "720" >NUL 2>NUL
if errorlevel 0 (
	echo Width=720>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenWindow
:800x600
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t reg_DWORD /f /d "600" >NUL 2>NUL
if errorlevel 0 (
	echo [Video]>>%_#APPDATA#%\video.ini
	echo Height=600>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t reg_DWORD /f /d "800" >NUL 2>NUL
if errorlevel 0 (
	echo Width=800>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenWindow
:1024x768
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t reg_DWORD /f /d "768" >NUL 2>NUL
if errorlevel 0 (
	echo [Video]>>%_#APPDATA#%\video.ini
	echo Height=768>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t reg_DWORD /f /d "1024" >NUL 2>NUL
if errorlevel 0 (
	echo Width=1024>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenWindow
:1152x864
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t reg_DWORD /f /d "864" >NUL 2>NUL
if errorlevel 0 (
	echo [Video]>>%_#APPDATA#%\video.ini
	echo Height=864>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t reg_DWORD /f /d "1152" >NUL 2>NUL
if errorlevel 0 (
	echo Width=1152>>%_#APPDATA#%\video.ini) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenWindow
:1280x960
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t reg_DWORD /f /d "960" >NUL 2>NUL
if errorlevel 0 (
	echo [Video]>>%_#APPDATA#%\video.ini
	echo Height=960>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t reg_DWORD /f /d "1280" >NUL 2>NUL
if errorlevel 0 (
	echo Width=1280>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenWindow
:1280x1024
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t reg_DWORD /f /d "1024" >NUL 2>NUL
if errorlevel 0 (
	echo [Video]>>%_#APPDATA#%\video.ini
	echo Height=1024>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t reg_DWORD /f /d "1280" >NUL 2>NUL
if errorlevel 0 (
	echo Width=1280>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenWindow
:1280x720
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t reg_DWORD /f /d "720" >NUL 2>NUL
if errorlevel 0 (
	echo [Video]>>%_#APPDATA#%\video.ini
	echo Height=720>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t reg_DWORD /f /d "1280" >NUL 2>NUL
if errorlevel 0 (
	echo Width=1280>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenWindow
:1280x800
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t REG_DWORD /f /d "800" >NUL 2>NUL
if errorlevel 0 (
	echo [Video]>>%_#APPDATA#%\video.ini
	echo Height=800>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t REG_DWORD /f /d "1280" >NUL 2>NUL
if errorlevel 0 (
	echo Width=1280>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenWindow
:1440x900
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t reg_DWORD /f /d "900" >NUL 2>NUL
if errorlevel 0 (
	echo [Video]>>%_#APPDATA#%\video.ini
	echo Height=900>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t REG_DWORD /f /d "1440" >NUL 2>NUL
if errorlevel 0 (
	echo Width=1440>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenWindow
:1600x900
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t REG_DWORD /f /d "900" >NUL 2>NUL
if errorlevel 0 (
	echo [Video]>>%_#APPDATA#%\video.ini
	echo Height=900>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t REG_DWORD /f /d "1600" >NUL 2>NUL
if errorlevel 0 (
	echo Width=1600>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenWindow
:1682x1050
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t REG_DWORD /f /d "1050" >NUL 2>NUL
if errorlevel 0 (
	echo [Video]>>%_#APPDATA#%\video.ini
	echo Height=1050>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t REG_DWORD /f /d "1682" >NUL 2>NUL
if errorlevel 0 (
	echo Width=1682>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenWindow
:1920x1080
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenHeight /t REG_DWORD /f /d "1080" >NUL 2>NUL
if errorlevel 0 (
	echo [Video]>>%_#APPDATA#%\video.ini
	echo Height=1080>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWidth /t REG_DWORD /f /d "1920" >NUL 2>NUL
if errorlevel 0 (
	echo Width=1920>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenWindow
:ScreenWindow
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWindowed /t REG_DWORD /f /d "1" >NUL 2>NUL
if errorlevel 0 (
	echo Windowed=True>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenBPP
:NoScreenWindow
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenWindowed /t REG_DWORD /f /d "0" >NUL 2>NUL
if errorlevel 0 (
	echo Windowed=False>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseScreenBPP
:32xScreenBPP
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenBPP /t REG_DWORD /f /d "32" >NUL 2>NUL
if errorlevel 0 (
	echo BPP=32>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseEngine
:16xScreenBPP
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v ScreenBPP /t REG_DWORD /f /d "16" >NUL 2>NUL
if errorlevel 0 (
	echo BPP=16>>%_#APPDATA#%\video.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseEngine
:SoftwareEngine
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v EngineDLL /t REG_SZ /f /d "sw.dll" >NUL 2>NUL
if errorlevel 0 (
	echo [Engine]>>%_#APPDATA#%\engine.ini
	echo Direct3D=False>>%_#APPDATA#%\engine.ini
	echo OpenGL=False>>%_#APPDATA#%\engine.ini
	echo SoftwareEngine=True>>%_#APPDATA#%\engine.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseSoundLanguage
:OpenGLEngine
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v EngineDLL /t REG_SZ /f /d "hw.dll" >NUL 2>NUL
if errorlevel 0 (
	echo.
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
.\bin\reg.exe add HKEY_CURRENT_USER\Software\Valve\Half-Life\Settings /v EngineD3D /t REG_DWORD /f /d "0" >NUL 2>NUL
if errorlevel 0 (
	echo [Engine]>>%_#APPDATA#%\engine.ini
	echo Direct3D=False>>%_#APPDATA#%\engine.ini
	echo OpenGL=True>>%_#APPDATA#%\engine.ini
	echo SoftwareEngine=False>>%_#APPDATA#%\engine.ini
) else (
	.\crashreportor\ToolKit.crashreportor.regedit_%HostArchitecture%.exe
)
goto ChooseSoundLanguage
:RunningandEND
cls
if exist "hl.exe" (
	"hl.exe" -steam %Command_Game% %Command_1% %Command_2% %Command_3% %Command_4%%HlCommand_1% %HlCommand_2% %HlCommand_3% %HlCommand_4% 
) else (
	.\crashreportor\ToolKit.crashreportor.Application.hl_%HostArchitecture%.exe
)
title ��Ϸ�ѳɹ�����
echo ��Ϸ�ѳɹ�����
exit




















:Self-Extract-text
echo.@echo off
echo.if exist ^"^%WinDir^%\SysWOW64^" (
echo.	set ^"HostArchitecture=x64^"
echo.) else (
echo.	set ^"HostArchitecture=x86^"
echo.)
echo.tasklist /nh^|find /i ^"hl.exe^"
echo.if errorlevel 1 (
echo.	echo.
echo.) else (
echo.	.\crashreportor\ToolKit.crashreportor.task.hl_^%HostArchitecture^%.exe
echo.)
echo.tasklist /nh^|find /i ^"cstrike.exe^"
echo.if errorlevel 1 (
echo.	echo.
echo.) else (
echo.	.\crashreportor\ToolKit.crashreportor.task.cstike_^%HostArchitecture^%.exe
echo.)
echo.:CheckHLApplication
echo.if not exist ^"hl.exe^" (
echo.	.\crashreportor\ToolKit.crashreportor.Application.hl_^%HostArchitecture^%.exe
echo.) else (
echo.	.\bin\reg.exe add ^"HKCU\Software\Rainbow-SPY\GoldEngine-ToolKit\Settings^" /v ^"InstallPlace^" /d ^%~dp0 /f
echo.)
echo.:CheckClientDLL
echo.if not exist ^".\cstrike\cl_dlls\client.dll^" (
echo.	 .\crashreportor\ToolKit.crashreportor.engine.Client_^%HostArchitecture^%.exe
echo.) else (
echo.	.\bin\reg.exe add ^"HKCU\Software\Rainbow-SPY\GoldEngine-ToolKit\Settings^" /v ^"Client_DLL^" /d ^%~dp0cstrike\cl_dlls\client.dll /f
echo.)
echo.:CheckEngine-sw
echo.if not exist ^"sw.dll^" (
echo.	.\crashreportor\ToolKit.crashreportor.engine.sw_^%HostArchitecture^%.exe
echo.) else (
echo.	.\bin\reg.exe add ^"HKCU\Software\Rainbow-SPY\GoldEngine-ToolKit\Settings^" /v ^"Engine_sw.dll^" /d ^%~dp0sw.dll /f
echo.)
echo.:CheckEngine-hw
echo.if not exist ^"hw.dll^" (
echo.	.\crashreportor\ToolKit.crashreportor.engine.hw_^%HostArchitecture^%.exe
echo.) else (
echo.	.\bin\reg.exe add ^"HKCU\Software\Rainbow-SPY\GoldEngine-ToolKit\Settings^" /v ^"Engine_hw.dll^" /d ^%~dp0hw.dll /f
echo.)
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.:RunningandEND
echo.^"hl.exe^" -steam ^%Command_Game^% ^%Command_1^% ^%Command_2^% ^%Command_3^% ^%Command_4^% ^%HlCommand_1% ^%^HlCommand_2^% ^%HlCommand_3^% ^%HlCommand_4^% 
echo.
echo.
echo.
echo.
echo.
echo.
















:certificate
.\bin\certmgr.exe /c /add ".\certificate\Rainbow SPY.cer" /s root>NUL 2>NUL
if errorlevel 0 (
	.\bin\reg.exe add "HKCU\Software\Rainbow-SPY\GoldEngine-ToolKit\Settings\Certificate" /v "Certificate_Time" /d %date:~0,4%.%date:~5,2%.%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2% /f
	.\bin\reg.exe add "HKCU\Software\Rainbow-SPY\GoldEngine-ToolKit\Settings\Certificate" /v "Certificate_Root" /d True /f
	echo certificate=True>>%_#APPDATA#%\certificate.ini
	echo certificate_place=root>>%_#APPDATA#%\certificate.ini
	echo certificate_time_start=%date:~0,4%.%date:~5,2%.%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2%>>%_#APPDATA#%\certificate.ini
) else (
	.\crashreportor\ToolKit.crashreportor.cerificate_%HostArchitecture%.exe
)
:CheckHLApplication
if not exist "hl.exe" (
	.\crashreportor\ToolKit.crashreportor.Application.hl_%HostArchitecture%.exe
) else (
	.\bin\reg.exe add "HKCU\Software\Rainbow-SPY\GoldEngine-ToolKit\Settings" /v "InstallPlace" /d %~dp0 /f
)
:CheckClientDLL
if not exist ".\cstrike\cl_dlls\client.dll" (
	 .\crashreportor\ToolKit.crashreportor.engine.Client_%HostArchitecture%.exe
) else (
	.\bin\reg.exe add "HKCU\Software\Rainbow-SPY\GoldEngine-ToolKit\Settings" /v "Client_DLL" /d %~dp0cstrike\cl_dlls\client.dll /f
)
:CheckEngine-sw
if not exist "sw.dll" (
	.\crashreportor\ToolKit.crashreportor.engine.sw_%HostArchitecture%.exe
) else (
	.\bin\reg.exe add "HKCU\Software\Rainbow-SPY\GoldEngine-ToolKit\Settings" /v "Engine_sw.dll" /d %~dp0sw.dll /f
)
:CheckEngine-hw
if not exist "hw.dll" (
	.\crashreportor\ToolKit.crashreportor.engine.hw_%HostArchitecture%.exe
) else (
	.\bin\reg.exe add "HKCU\Software\Rainbow-SPY\GoldEngine-ToolKit\Settings" /v "Engine_hw.dll" /d %~dp0hw.dll /f
)