# scripts/heartbeat.ps1 — Optional system health check logger
#
# What this does:
#   Runs checks (disk space, services, etc.) and appends results to today's
#   memory file. The next time you start a Claude Code session, the agent
#   reads those notes as part of its context load.
#
# What this does NOT do:
#   It does not trigger Claude Code or start a session automatically.
#   There is no background AI running — this is just a PowerShell script
#   that writes to a markdown file.
#
# The Claude Code equivalent of a "heartbeat" is simply starting your day
#   with: "daily briefing"
#
# To schedule (optional):
#   See SETUP.md for Task Scheduler instructions, or:
#   Register-ScheduledTask -Xml (Get-Content scripts\heartbeat-task.xml | Out-String) -TaskName "openclaw-heartbeat"

$WORKSPACE   = Join-Path $PSScriptRoot "..\workspace"
$TODAY       = Get-Date -Format "yyyy-MM-dd"
$NOW         = Get-Date -Format "HH:mm"
$memDir      = Join-Path $WORKSPACE "memory"
$MEMORY_FILE = Join-Path $memDir "$TODAY.md"
$STATE_FILE  = Join-Path $memDir "heartbeat-state.json"

New-Item -ItemType Directory -Force -Path $memDir | Out-Null

# Create today's memory file if it doesn't exist
if (-not (Test-Path $MEMORY_FILE)) {
    @"
# $TODAY

## Sessions

_Add notes during/after each conversation._

## Notes

"@ | Set-Content -Path $MEMORY_FILE -Encoding UTF8
}

Add-Content -Path $MEMORY_FILE -Value ""
Add-Content -Path $MEMORY_FILE -Value "## System Check @ $NOW"

# ─── ADD YOUR CHECKS BELOW ───────────────────────────────────────────────────

# 1. Disk space on C: drive
$disk    = Get-PSDrive C
$usedPct = [math]::Round(($disk.Used / ($disk.Used + $disk.Free)) * 100)
if ($usedPct -gt 85) {
    Add-Content -Path $MEMORY_FILE -Value "⚠️  Disk C: usage high: ${usedPct}%"
} else {
    Add-Content -Path $MEMORY_FILE -Value "✅ Disk C: ${usedPct}% used"
}

# 2. Check a local service (uncomment and adapt)
# try {
#     $r = Invoke-WebRequest -Uri "http://localhost:8080/health" -TimeoutSec 5 -UseBasicParsing
#     if ($r.StatusCode -ne 200) {
#         Add-Content -Path $MEMORY_FILE -Value "⚠️  Service :8080 DOWN (HTTP $($r.StatusCode))"
#     } else {
#         Add-Content -Path $MEMORY_FILE -Value "✅ Service :8080 healthy"
#     }
# } catch {
#     Add-Content -Path $MEMORY_FILE -Value "⚠️  Service :8080 unreachable"
# }

# ─────────────────────────────────────────────────────────────────────────────

# Update state file
try {
    $state = if (Test-Path $STATE_FILE) {
        Get-Content $STATE_FILE | ConvertFrom-Json
    } else {
        [PSCustomObject]@{ lastChecks = @{} }
    }
    $state.lastChecks | Add-Member -NotePropertyName "heartbeat" `
        -NotePropertyValue (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ") -Force
    $state | ConvertTo-Json | Set-Content -Path $STATE_FILE -Encoding UTF8
} catch {
    Write-Warning "Could not update heartbeat state: $_"
}

Write-Host "System check logged @ $(Get-Date -Format 'HH:mm:ss')"
