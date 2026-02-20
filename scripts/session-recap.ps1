# scripts/session-recap.ps1 — Preview the context Claude will load on session start.
# Useful for debugging: see exactly what the agent knows going in.

$WORKSPACE = Join-Path $PSScriptRoot "..\workspace"
$TODAY     = Get-Date -Format "yyyy-MM-dd"
$YESTERDAY = (Get-Date).AddDays(-1).ToString("yyyy-MM-dd")

Write-Host "════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  openclaw-lite — Session Context Preview" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

$files = @("SOUL.md", "USER.md", "MEMORY.md", "TOOLS.md")
foreach ($f in $files) {
    $path = Join-Path $WORKSPACE $f
    if (Test-Path $path) {
        Write-Host "── $f ──" -ForegroundColor Yellow
        Get-Content $path
        Write-Host ""
    }
}

foreach ($day in @($TODAY, $YESTERDAY)) {
    $path = Join-Path $WORKSPACE "memory\$day.md"
    if (Test-Path $path) {
        Write-Host "── memory\$day.md ──" -ForegroundColor Yellow
        Get-Content $path
        Write-Host ""
    }
}

Write-Host "════════════════════════════════════════" -ForegroundColor Cyan
