@echo off
:: MITRE ATT&CK LOLBAS Mitigation (.bat)
:: Covers: T1003, T1059, T1105, T1127, T1218, T1218.007, T1202, T1216
:: Run as Administrator

set LOG=%USERPROFILE%\Desktop\Mitre_LOLBAS_Mitigation_Log.txt
echo ==== STARTING MITRE ATT&CK LOLBAS MITIGATION ==== >> "%LOG%"

echo [*] Enabling LSASS protection... >> "%LOG%"
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "RunAsPPL" /t REG_DWORD /d 1 /f

echo [*] Enabling Credential Guard... >> "%LOG%"
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "LsaCfgFlags" /t REG_DWORD /d 1 /f

echo [*] Disabling PowerShell scripts and logging... >> "%LOG%"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PowerShell" /v EnableScripts /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" /v EnableScriptBlockLogging /t REG_DWORD /d 1 /f

echo [*] Enabling ASR rule to block tool transfers (Defender)... >> "%LOG%"
powershell -Command "Add-MpPreference -AttackSurfaceReductionRules_Ids 'E3C7E581-603C-4F68-8A1A-6B8C9FD92A4C' -AttackSurfaceReductionRules_Actions Enabled"

echo [*] Hardening AppLocker and safer code policy... >> "%LOG%"
reg add "HKLM\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers" /v DefaultLevel /t REG_DWORD /d 262144 /f

echo [*] Blocking mshta.exe (used in T1218.007)... >> "%LOG%"
icacls "%SystemRoot%\System32\mshta.exe" /deny Everyone:RX
icacls "%SystemRoot%\SysWOW64\mshta.exe" /deny Everyone:RX

echo [*] Disabling CMD prompt (T1202)... >> "%LOG%"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableCMD /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Policies\Microsoft\Windows\System" /v DisableCMD /t REG_DWORD /d 1 /f

echo [*] Disabling transparent execution of signed code... >> "%LOG%"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers" /v TransparentEnabled /t REG_DWORD /d 0 /f

echo ==== MITIGATION COMPLETE ==== >> "%LOG%"
echo [!] Please reboot the system to apply all changes.
pause
