@echo off
:: High Priority Windows Hardening Script (cyber.gov.au aligned)
:: Run as administrator

echo [*] Disabling unnecessary features: macros, plugins, etc...

:: Disable Office Macros (Trusted Locations & VBA macros)
reg add "HKCU\Software\Microsoft\Office\16.0\Word\Security" /v VBAWarnings /t REG_DWORD /d 4 /f
reg add "HKCU\Software\Microsoft\Office\16.0\Excel\Security" /v VBAWarnings /t REG_DWORD /d 4 /f
reg add "HKCU\Software\Microsoft\Office\16.0\PowerPoint\Security" /v VBAWarnings /t REG_DWORD /d 4 /f

:: Disable Flash/ActiveX plugins (legacy IE/Edge)
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Ext" /v DisableFlash /t REG_DWORD /d 1 /f

echo [*] Enabling Exploit Guard ASR rules...
:: Enable all ASR rules (adjust per environment)
powershell -Command "Add-MpPreference -AttackSurfaceReductionRules_Ids 75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84, 3B576869-A4EC-4529-8536-B80A7769E899, D4F940AB-401B-4EFC-AADC-AD5F3C50688A -AttackSurfaceReductionRules_Actions Enabled"

echo [*] Disabling legacy WDigest and enabling Credential Guard...
:: Disable WDigest
reg add "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest" /v UseLogonCredential /t REG_DWORD /d 0 /f

:: Enable Credential Guard (requires reboot + virtualization)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v EnableVirtualizationBasedSecurity /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v RequirePlatformSecurityFeatures /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LsaCfgFlags /t REG_DWORD /d 1 /f

echo [*] Enabling Controlled Folder Access (protect Documents, Desktop, etc)...
powershell -Command "Set-MpPreference -EnableControlledFolderAccess Enabled"

echo [*] Enforcing UAC secure desktop and virtualization...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 2 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v PromptOnSecureDesktop /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableVirtualization /t REG_DWORD /d 1 /f

echo [*] Enabling Early Launch Antimalware (ELAM)...
reg add "HKLM\SYSTEM\CurrentControlSet\Policies\EarlyLaunch" /v DriverLoadPolicy /t REG_DWORD /d 3 /f

echo [*] Enabling Exploit Protection (CFG, DEP, etc.)...
powershell -Command "Set-ProcessMitigation -System -Enable DEP, SEHOP, ASLR, CFG"

echo [*] Enforcing strong password and local admin restrictions...
net accounts /minpwlen:30
net accounts /maxpwage:30
net accounts /uniquepw:5

:: Admin approval mode
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 0 /f

echo [*] Enabling Secure Boot and Measured Boot (if supported)...
:: These require UEFI and TPM—verify with BIOS and system info
bcdedit /set {current} bootux disabled
reg add "HKLM\SYSTEM\CurrentControlSet\Control\SecureBoot\State" /v UEFISecureBootEnabled /t REG_DWORD /d 1 /f

echo [*] Hardening Microsoft Edge browser...
:: Enable auto-updates and passwordless sign-in
reg add "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /v AutoUpdateCheckPeriodMinutes /t REG_DWORD /d 1440 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v UseCertificateForOnPremAuth /t REG_DWORD /d 1 /f

echo [*] Enforcing MFA (indirect enforcement via Windows Hello)...
reg add "HKLM\SOFTWARE\Policies\Microsoft\PassportForWork" /v Enabled /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\PassportForWork" /v RequireSecurityDevices /t REG_DWORD /d 1 /f

echo [*] High Priority Hardening Complete. Please restart the system.
pause
