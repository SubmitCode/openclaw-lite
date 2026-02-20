# setup.ps1 — openclaw-lite interactive setup (Windows / PowerShell)
# Run with: powershell -ExecutionPolicy Bypass -File setup.ps1

$WORKSPACE = Join-Path $PSScriptRoot "workspace"

Write-Host ""
Write-Host "╔══════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║      openclaw-lite — Setup           ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "This will personalize your workspace files."
Write-Host "You can re-run this anytime or edit the files directly."
Write-Host ""

# --- USER.md ---
Write-Host "👤 About You" -ForegroundColor Yellow
$USER_NAME     = Read-Host "  Your name"
$USER_CALLNAME = Read-Host "  What should the agent call you? [$USER_NAME]"
if (-not $USER_CALLNAME) { $USER_CALLNAME = $USER_NAME }
$USER_ROLE     = Read-Host "  Your role/job title"
$USER_COMPANY  = Read-Host "  Company/Organization"
$USER_TZ       = Read-Host "  Timezone (e.g. Europe/Zurich)"
$USER_LOCATION = Read-Host "  Location (City, Country)"
$USER_LANG     = Read-Host "  Primary language(s) [English]"
if (-not $USER_LANG) { $USER_LANG = "English" }

Write-Host ""
Write-Host "💼 Work Context" -ForegroundColor Yellow
$USER_TOOLS = Read-Host "  Primary tools (e.g. Jira, Confluence, GitHub, Teams)"
$USER_STACK = Read-Host "  Tech stack (e.g. Python, SQL, Azure, Power BI)"
$USER_FOCUS = Read-Host "  Current main focus"

Write-Host ""
Write-Host "🎯 Goals (one per line, empty line to finish)" -ForegroundColor Yellow
$USER_GOALS = @()
while ($true) {
    $line = Read-Host "  Goal"
    if (-not $line) { break }
    $USER_GOALS += "- $line"
}

# Write USER.md
$goalsText = $USER_GOALS -join "`n"
@"
# USER.md — About Your Human

- **Name:** $USER_NAME
- **What to call them:** $USER_CALLNAME
- **Timezone:** $USER_TZ
- **Location:** $USER_LOCATION
- **Job:** $USER_ROLE at $USER_COMPANY
- **Language(s):** $USER_LANG

## Work Context

- **Primary tools:** $USER_TOOLS
- **Tech stack:** $USER_STACK
- **Current focus:** $USER_FOCUS

## Goals

$goalsText

## Notes

_Add anything else that helps the agent help you._
"@ | Set-Content -Path "$WORKSPACE\USER.md" -Encoding UTF8

Write-Host ""
Write-Host "🪪 Agent Identity" -ForegroundColor Yellow
$AGENT_NAME  = Read-Host "  Agent name [Assistant]"
if (-not $AGENT_NAME) { $AGENT_NAME = "Assistant" }
$AGENT_EMOJI = Read-Host "  Agent emoji [🤖]"
if (-not $AGENT_EMOJI) { $AGENT_EMOJI = "🤖" }

@"
# IDENTITY.md

- **Name:** $AGENT_NAME
- **Emoji:** $AGENT_EMOJI
- **Owner:** $USER_NAME
"@ | Set-Content -Path "$WORKSPACE\IDENTITY.md" -Encoding UTF8

# Create memory directory and today's file
$memDir = Join-Path $WORKSPACE "memory"
New-Item -ItemType Directory -Force -Path $memDir | Out-Null

$TODAY = Get-Date -Format "yyyy-MM-dd"
$MEMORY_FILE = Join-Path $memDir "$TODAY.md"

if (-not (Test-Path $MEMORY_FILE)) {
    @"
# $TODAY

## Setup

Agent initialized via setup.ps1. User: $USER_NAME ($USER_ROLE at $USER_COMPANY).

"@ | Set-Content -Path $MEMORY_FILE -Encoding UTF8
    Write-Host "  ✅ Created memory\$TODAY.md" -ForegroundColor Green
}

# Create heartbeat state
$stateFile = Join-Path $memDir "heartbeat-state.json"
$now = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
@"
{
  "lastChecks": {
    "setup": "$now"
  }
}
"@ | Set-Content -Path $stateFile -Encoding UTF8

# Create .env from example if it doesn't exist
$envExample = Join-Path $PSScriptRoot ".env.example"
$envFile    = Join-Path $PSScriptRoot ".env"
if ((Test-Path $envExample) -and -not (Test-Path $envFile)) {
    Copy-Item $envExample $envFile
    Write-Host "  📄 Created .env from .env.example — add your ANTHROPIC_API_KEY" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "✅ Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Your workspace is ready at: $WORKSPACE"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Edit workspace\SOUL.md to shape the agent's personality"
Write-Host "  2. Edit workspace\TOOLS.md with your environment specifics"
Write-Host "  3. Edit .env and add your ANTHROPIC_API_KEY"
Write-Host "  4. Run: claude   (in this directory — CLAUDE.md loads automatically)"
Write-Host "  5. Optional: schedule scripts\heartbeat.ps1 via Task Scheduler"
Write-Host ""
