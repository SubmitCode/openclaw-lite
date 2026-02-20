# scripts/heartbeat.ps1 — Periodic checks. Run via Windows Task Scheduler.
#
# To schedule (runs every 30 min, 8am-8pm on weekdays):
#   See SETUP.md for Task Scheduler instructions, or run:
#   Register-ScheduledTask -Xml (Get-Content scripts\heartbeat-task.xml | Out-String) -TaskName "openclaw-heartbeat"

$WORKSPACE   = Join-Path $PSScriptRoot "..\workspace"
$TODAY       = Get-Date -Format "yyyy-MM-dd"
$NOW         = Get-Date -Format "HH:mm"
$memDir      = Join-Path $WORKSPACE "memory"
$MEMORY_FILE = Join-Path $memDir "$TODAY.md"
$STATE_FILE  = Join-Path $memDir "heartbeat-state.json"

New-Item -ItemType Directory -Force -Path $memDir | Out-Null

# Ensure today's file exists
if (-not (Test-Path $MEMORY_FILE)) {
    & "$PSScriptRoot\new-day.ps1"
}

Add-Content -Path $MEMORY_FILE -Value ""
Add-Content -Path $MEMORY_FILE -Value "## Heartbeat @ $NOW"

# ─── CHECKS ──────────────────────────────────────────────────────────────────
# Add your own checks here. Examples:

# 1. Check a local service is up
# try {
#     $response = Invoke-WebRequest -Uri "http://localhost:8080/health" -TimeoutSec 5 -UseBasicParsing
#     if ($response.StatusCode -ne 200) {
#         Add-Content -Path $MEMORY_FILE -Value "⚠️  Service :8080 is DOWN (HTTP $($response.StatusCode))"
#     } else {
#         Add-Content -Path $MEMORY_FILE -Value "✅ Service :8080 healthy"
#     }
# } catch {
#     Add-Content -Path $MEMORY_FILE -Value "⚠️  Service :8080 unreachable: $_"
# }

# 2. Check disk space on C: drive
$disk = Get-PSDrive C
$usedPct = [math]::Round(($disk.Used / ($disk.Used + $disk.Free)) * 100)
if ($usedPct -gt 85) {
    Add-Content -Path $MEMORY_FILE -Value "⚠️  Disk C: usage high: ${usedPct}%"
} else {
    Add-Content -Path $MEMORY_FILE -Value "✅ Disk C: ${usedPct}% used"
}

# 3. Check for uncommitted git changes in workspace
# $gitStatus = git -C $WORKSPACE status --porcelain 2>$null
# if ($gitStatus) {
#     Add-Content -Path $MEMORY_FILE -Value "📝 Uncommitted changes in workspace repo"
# }

# ─────────────────────────────────────────────────────────────────────────────

# Update heartbeat state JSON
try {
    if (Test-Path $STATE_FILE) {
        $state = Get-Content $STATE_FILE | ConvertFrom-Json
    } else {
        $state = @{ lastChecks = @{} }
    }
    $state.lastChecks | Add-Member -NotePropertyName "heartbeat" `
        -NotePropertyValue (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ") -Force
    $state | ConvertTo-Json | Set-Content -Path $STATE_FILE -Encoding UTF8
} catch {
    Write-Warning "Could not update heartbeat state: $_"
}

Write-Host "Heartbeat done @ $(Get-Date -Format 'HH:mm:ss')"
