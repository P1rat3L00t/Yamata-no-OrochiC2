@echo off
:: Mitigation Script for BLU3F1R3 or Similar Threats
:: Run as Administrator

echo [*] Killing suspicious or known BLU3F1R3 payloads...
taskkill /F /IM blu3f1r3.exe >nul 2>&1
taskkill /F /IM powershell.exe >nul 2>&1
taskkill /F /IM rundll32.exe >nul 2>&1
taskkill /F /IM mshta.exe >nul 2>&1

echo [*] Deleting common drop and persistence paths...
del /f /s /q "%TEMP%\*.exe"
del /f /s /q "%TEMP%\*.dll"
del /f /s /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\*.lnk"
rmdir /s /q "%ProgramData%\BLU3F1R3"
rmdir /s /q "%APPDATA%\BLU3F1R3"

echo [*] Disabling PowerShell execution and logging script block...
powershell -Command "Set-ExecutionPolicy Restricted -Force"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" /v EnableScriptBlockLogging /t REG_DWORD /d 1 /f

echo [*] Disabling WMI persistence and WinRM remote access...
sc config WinRM start= disabled
net stop WinRM
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableWMI /t REG_DWORD /d 0 /f

echo [*] Disabling suspicious registry autoruns and AppCertDLLs...
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\AppCertDLLs" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /f >nul 2>&1
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /f >nul 2>&1

echo [*] Enabling ASR Rules in Defender (for script, payload, and credential protection)...
powershell -Command "Add-MpPreference -AttackSurfaceReductionRules_Ids D4F940AB-401B-4EFC-AADC-AD5F3C50688A,3B576869-A4EC-4529-8536-B80A7769E899,75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84 -AttackSurfaceReductionRules_Actions Enabled"

echo [*] Clearing scheduled tasks related to potential persistence...
schtasks /query | findstr /i "blu3f1r3" > nul && schtasks /delete /tn "blu3f1r3" /f

echo [*] Resetting default permissions on sensitive folders...
icacls "%APPDATA%" /reset /T
icacls "%TEMP%" /reset /T

echo [*] BLU3F1R3 mitigation complete. Reboot is recommended.
pause
