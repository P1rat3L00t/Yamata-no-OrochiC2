
# AnyDesk CVE Artifact Scanner
# NOTE: This script only performs basic checks for indicators related to listed CVEs. It is not an exploit tool.

$logPath = "$env:USERPROFILE\Desktop\AnyDesk_CVE_Scan_Log.txt"
"=== AnyDesk CVE Scan Log - $(Get-Date) ===`n" | Out-File -FilePath $logPath

function Log {
    param ($msg)
    Add-Content -Path $logPath -Value $msg
}

# Check 1: Exposed Public IP (CVE-2024-52940)
Log "CVE-2024-52940: Checking if 'Allow Direct Connections' is enabled in config.ini..."
$confPath = "$env:APPDATA\AnyDesk\system.conf"
if (Test-Path $confPath) {
    $conf = Get-Content $confPath
    if ($conf -match "ad.direct_connections=1") {
        Log "`t[!] 'Allow Direct Connections' is enabled — possible exposure of public IP."
    } else {
        Log "`t[OK] Direct Connections setting is disabled or not found."
    }
} else {
    Log "`t[INFO] Config file not found — AnyDesk may not be installed."
}

# Check 2: Symbolic Link Arbitrary File Disclosure (CVE-2024-12754)
Log "`nCVE-2024-12754: Checking for common junction abuse points in background image paths..."
$bgImageDir = "$env:APPDATA\AnyDesk"
if (Test-Path $bgImageDir) {
    $junctions = fsutil reparsepoint query $bgImageDir 2>$null
    if ($junctions) {
        Log "`t[!] Reparse/junction found — review manually for abuse."
    } else {
        Log "`t[OK] No obvious junctions found."
    }
}

# Check 3: DoS Versions (CVE-2023-26509)
Log "`nCVE-2023-26509: Checking AnyDesk version..."
$versionPath = "$env:PROGRAMFILES\AnyDesk\AnyDesk.exe"
if (Test-Path $versionPath) {
    $version = (Get-Item $versionPath).VersionInfo.FileVersion
    Log "`tInstalled version: $version"
    if ($version -eq "7.0.8") {
        Log "`t[!] Version is vulnerable to DoS (7.0.8). Consider updating."
    }
} else {
    Log "`t[INFO] AnyDesk binary not found in Program Files."
}

# Check 4: Priv Esc via %APPDATA% Symbolic Link (CVE-2022-32450)
Log "`nCVE-2022-32450: Checking for symbolic links in %APPDATA% chat/trace files..."
$paths = @("$env:APPDATA\AnyDesk\chat", "$env:APPDATA\AnyDesk\ad.trace")
foreach ($p in $paths) {
    if (Test-Path $p) {
        $linkInfo = fsutil reparsepoint query $p 2>$null
        if ($linkInfo) {
            Log "`t[!] $p is a reparse point — possible privilege escalation vector."
        } else {
            Log "`t[OK] $p appears to be normal."
        }
    } else {
        Log "`t[INFO] $p not found."
    }
}

# Check 5: Arbitrary Upload (CVE-2021-44426)
Log "`nCVE-2021-44426: Checking Downloads folder for unauthorized files..."
$downloadPath = "$env:USERPROFILE\Downloads"
$filter = "*.*"
$recentFiles = Get-ChildItem -Path $downloadPath -Filter $filter -Recurse -ErrorAction SilentlyContinue | 
    Where-Object { $_.LastWriteTime -gt (Get-Date).AddDays(-2) -and $_.Length -gt 0 }
if ($recentFiles) {
    Log "`t[!] Recent files found in Downloads. Review manually for suspicious files."
    $recentFiles | ForEach-Object { Log "`t - $($_.Name)" }
} else {
    Log "`t[OK] No recent files detected."
}

# General Note
Log "`n[NOTE] Full CVE checks may require forensic or system-specific review. This script does not guarantee detection."
Write-Output "Scan complete. Results saved to: $logPath"
