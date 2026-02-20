# scripts/new-day.ps1 — Creates today's memory file if it doesn't exist.
# Run at the start of each day or via Task Scheduler.

$WORKSPACE   = Join-Path $PSScriptRoot "..\workspace"
$TODAY       = Get-Date -Format "yyyy-MM-dd"
$memDir      = Join-Path $WORKSPACE "memory"
$MEMORY_FILE = Join-Path $memDir "$TODAY.md"

New-Item -ItemType Directory -Force -Path $memDir | Out-Null

if (-not (Test-Path $MEMORY_FILE)) {
    @"
# $TODAY

## Sessions

_Add notes during/after each conversation._

## Decisions

## Follow-ups

## Notes

"@ | Set-Content -Path $MEMORY_FILE -Encoding UTF8
    Write-Host "✅ Created memory\$TODAY.md"
} else {
    Write-Host "ℹ️  memory\$TODAY.md already exists"
}
