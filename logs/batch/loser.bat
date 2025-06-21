@echo off
:: MITRE ATT&CK LOLBin High-Risk Technique Mitigation (.bat)
:: Based on the_lolbas_project.json

echo [*] Preventing LSASS memory access (T1003.001)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "RunAsPPL" /t REG_DWORD /d 1 /f

echo [*] Enabling Credential Guard (T1003)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LsaCfgFlags /t REG_DWORD /d 1 /f

echo [*] Disabling scripting interpreters (T1059)...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PowerShell" /v EnableScripts /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" /v EnableScriptBlockLogging /t REG_DWORD /d 1 /f

echo [*] Blocking ingress tool transfers via Defender (T1105)...
powershell -Command "Add-MpPreference -AttackSurfaceReductionRules_Ids E3C7E581-603C-4F68-8A1A-6B8C9FD92A4C -AttackSurfaceReductionRules_Actions Enabled"

echo [*] Blocking trusted binary abuse (T1127, T1218)...
reg add "HKLM\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers" /v DefaultLevel /t REG_DWORD /d 262144 /f

echo [*] Disabling mshta.exe (T1218.007)...
icacls "%SystemRoot%\System32\mshta.exe" /deny Everyone:RX >nul 2>&1
icacls "%SystemRoot%\SysWOW64\mshta.exe" /deny Everyone:RX >nul 2>&1

echo [*] Disabling indirect command execution (T1202)...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableCMD" /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Policies\Microsoft\Windows\System" /v "DisableCMD" /t REG_DWORD /d 1 /f

echo [*] Blocking suspicious signed scripts (T1216)...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers" /v TransparentEnabled /t REG_DWORD /d 0 /f

echo [*] Restart recommended for full mitigation effect.
pause
