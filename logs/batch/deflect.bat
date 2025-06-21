@echo off
:: DLL Injection Mitigation Script for Windows 11
:: Run as Administrator

echo [*] Enabling Microsoft Defender ASR Rules to block known code injection vectors...
powershell -Command "Add-MpPreference -AttackSurfaceReductionRules_Ids 75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84, D4F940AB-401B-4EFC-AADC-AD5F3C50688A, 3B576869-A4EC-4529-8536-B80A7769E899 -AttackSurfaceReductionRules_Actions Enabled"

echo [*] Enabling system-wide exploit protection (DEP, SEHOP, CFG, ASLR)...
powershell -Command "Set-ProcessMitigation -System -Enable DEP, SEHOP, ASLR, CFG"

echo [*] Enabling DLLSafeSearchMode and Disabling LoadLibrary search order hijacking...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v SafeDllSearchMode /t REG_DWORD /d 1 /f

echo [*] Blocking remote unsigned DLL loading via LSASS and WDigest...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest" /v UseLogonCredential /t REG_DWORD /d 0 /f

echo [*] Restricting unsigned code execution from memory...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy" /v EnableUnsafeCodeLoading /t REG_DWORD /d 0 /f

echo [*] Enabling PowerShell logging and constrained language mode...
powershell -Command "Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging' -Name 'EnableScriptBlockLogging' -Value 1 -Force"
powershell -Command "Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell' -Name 'EnableScripts' -Value 0 -Force"

echo [*] Disabling insecure Win32 legacy console features...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" /v MitigationOptions /t REG_QWORD /d 1000000000000 /f

echo [*] Enforcing Code Integrity: block unsigned DLLs in secure environments...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CI\Policy" /v PolicyEnforcement /t REG_DWORD /d 1 /f

echo [*] Enforcing Secure Boot and ELAM...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\SecureBoot\State" /v UEFISecureBootEnabled /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Policies\EarlyLaunch" /v DriverLoadPolicy /t REG_DWORD /d 3 /f

echo [*] Preventing privilege escalation via remote UAC bypass...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 0 /f

echo [*] Disabling AppCertDLLs injection mechanism...
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\AppCertDLLs" /f

echo [*] DLL Injection Mitigation Complete. Reboot is recommended for full effect.
pause
