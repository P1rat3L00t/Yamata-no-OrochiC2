
# Query-AnyDesk-Core.ps1
# Reads and logs values from two core AnyDesk registry locations

$keys = @(
    "HKLM:\SOFTWARE\Clients\Media\AnyDesk",
    "HKLM:\SYSTEM\CurrentControlSet\Services\AnyDesk"
)

$logPath = "$env:USERPROFILE\Desktop\AnyDesk_Core_Log.txt"
"=== AnyDesk Core Registry Scan - $(Get-Date) ===`n" | Out-File -FilePath $logPath

foreach ($key in $keys) {
    Add-Content -Path $logPath -Value ">>> $key"

    if (Test-Path $key) {
        try {
            $props = Get-ItemProperty -Path $key
            foreach ($p in $props.PSObject.Properties) {
                Add-Content -Path $logPath -Value "`t$($p.Name) : $($p.Value)"
            }
        } catch {
            Add-Content -Path $logPath -Value "`t[ERROR] Could not access key."
        }
    } else {
        Add-Content -Path $logPath -Value "`t[NOT FOUND]"
    }
    Add-Content -Path $logPath -Value "`n"
}

Write-Output "Core registry data saved to: $logPath"

# Optional: Register as Scheduled Task to Run at User Logon
$taskName = "QueryAnyDeskCore"
$scriptPath = "$env:USERPROFILE\Desktop\Query-AnyDesk-Core.ps1"

Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`"") `
  -Trigger (New-ScheduledTaskTrigger -AtLogOn) `
  -TaskName $taskName -Description "Auto-log AnyDesk core registry keys" -User "$env:USERNAME" -RunLevel Highest -Force
