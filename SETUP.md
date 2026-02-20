# Setup Guide

Step-by-step instructions for getting openclaw-lite running on Windows, macOS, or Linux.

---

## Prerequisites

| Tool | Required | Install |
|------|----------|---------|
| [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) | ✅ Yes | `npm install -g @anthropic-ai/claude-code` |
| Git | ✅ Yes | [git-scm.com](https://git-scm.com/) |
| Node.js (v18+) | ✅ Yes (for Claude Code) | [nodejs.org](https://nodejs.org/) |
| Python 3 | Optional | Only needed for heartbeat state tracking |
| Anthropic API key | ✅ Yes | [console.anthropic.com](https://console.anthropic.com/) |

---

## Step 1 — Clone the Repository

```bash
git clone https://github.com/SubmitCode/openclaw-lite.git
cd openclaw-lite
```

---

## Step 2 — Add Your API Key

Copy the example env file and add your key:

**Windows (PowerShell):**
```powershell
Copy-Item .env.example .env
notepad .env
```

**macOS / Linux:**
```bash
cp .env.example .env
nano .env   # or: code .env
```

Edit `.env`:
```
ANTHROPIC_API_KEY=sk-ant-your-key-here
```

Set the environment variable in your session:

**Windows (PowerShell):**
```powershell
$env:ANTHROPIC_API_KEY = "sk-ant-your-key-here"
# To persist permanently:
[System.Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "sk-ant-your-key-here", "User")
```

**macOS / Linux:**
```bash
export ANTHROPIC_API_KEY="sk-ant-your-key-here"
# To persist: add the above line to ~/.bashrc or ~/.zshrc
```

---

## Step 3 — Run Setup

The setup wizard personalizes your workspace files (USER.md, IDENTITY.md, etc.).

**Windows (PowerShell):**
```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned   # one-time
powershell -ExecutionPolicy Bypass -File setup.ps1
```

**macOS / Linux:**
```bash
chmod +x setup.sh scripts/*.sh
./setup.sh
```

Fill in your name, role, timezone, goals, etc. You can re-run this anytime or edit the files directly in `workspace/`.

---

## Step 4 — Personalize Your Workspace

After setup, review and customize these files to your liking:

| File | What to do |
|------|-----------|
| `workspace/SOUL.md` | Adjust the agent's personality and tone |
| `workspace/USER.md` | Add more context about yourself |
| `workspace/TOOLS.md` | Add your environment specifics (paths, tools, aliases) |
| `workspace/GOALS.md` | Fill in your goals |
| `workspace/RECURRING.md` | Set up your recurring routines |

---

## Step 5 — Start Claude Code

From the `openclaw-lite` directory:

```bash
claude
```

That's it. Claude Code automatically reads `CLAUDE.md` on every session start — no extra config needed. The agent will load your workspace context and be ready to help.

**First things to try:**
- `"daily briefing"` — morning context load
- `"add to inbox: [something]"` — quick capture
- `"clarify: [fuzzy idea]"` — intention clarifier

---

## Step 6 (Optional) — Schedule Heartbeat Checks

The heartbeat script runs periodic checks (disk space, service health, etc.) and logs them to your daily memory file. Customize `scripts/heartbeat.ps1` or `scripts/heartbeat.sh` with your own checks.

### Windows — Task Scheduler

**Option A: Import the XML template**

1. Edit `scripts/heartbeat-task.xml`:
   - Replace `YOURUSERNAME` with your Windows username
   - Replace the `WorkingDirectory` path with your actual path to `openclaw-lite`
2. Import in PowerShell (as Administrator):
   ```powershell
   Register-ScheduledTask -Xml (Get-Content scripts\heartbeat-task.xml | Out-String) -TaskName "openclaw-heartbeat"
   ```
3. Verify: open Task Scheduler → find `openclaw-heartbeat`

**Option B: Manual Task Scheduler UI**

1. Open **Task Scheduler** → *Create Basic Task*
2. Name: `openclaw-heartbeat`
3. Trigger: Daily, repeat every 30 minutes for 12 hours
4. Action: Start a program
   - Program: `powershell.exe`
   - Arguments: `-ExecutionPolicy Bypass -NonInteractive -File "scripts\heartbeat.ps1"`
   - Start in: `C:\path\to\openclaw-lite`

To remove the task:
```powershell
Unregister-ScheduledTask -TaskName "openclaw-heartbeat" -Confirm:$false
```

### macOS / Linux — Cron

```bash
# Edit your crontab
crontab -e

# Add this line (runs every 30 min, 8am-8pm, weekdays):
*/30 8-20 * * 1-5 /path/to/openclaw-lite/scripts/heartbeat.sh >> /tmp/openclaw-heartbeat.log 2>&1
```

---

## Folder Structure Reference

```
openclaw-lite/
├── CLAUDE.md                  ← Auto-loaded by Claude Code (the core bootstrap)
├── SETUP.md                   ← This file
├── setup.sh / setup.ps1       ← Interactive setup wizard
├── .env                       ← Your API keys (gitignored)
├── .env.example               ← Template
│
├── workspace/
│   ├── SOUL.md                ← Agent personality
│   ├── IDENTITY.md            ← Agent name & emoji
│   ├── USER.md                ← About you
│   ├── TOOLS.md               ← Your environment specifics
│   ├── MEMORY.md              ← Long-term curated memory
│   ├── GOALS.md               ← Longer-horizon goals
│   ├── INBOX.md               ← Universal capture inbox
│   ├── WAITING_FOR.md         ← Delegated & pending items
│   ├── DECISIONS.md           ← Decision log
│   ├── SOMEDAY.md             ← Ideas & backlog
│   ├── RECURRING.md           ← Recurring tasks & rhythms
│   ├── DASHBOARD.md           ← Morning status snapshot
│   ├── memory/
│   │   ├── YYYY-MM-DD.md      ← Daily session notes
│   │   └── heartbeat-state.json
│   ├── projects/
│   │   ├── INDEX.md           ← Fast-scan project overview
│   │   ├── _TEMPLATE.md       ← New project template
│   │   ├── active/            ← One file per active project
│   │   ├── planning/          ← Pre-kickoff projects
│   │   └── archive/           ← Completed projects
│   └── skills/
│       ├── daily-briefing/    ← Morning briefing workflow
│       ├── end-of-day/        ← EOD reconciliation
│       ├── weekly-review/     ← Strategic weekly audit
│       ├── quick-capture/     ← Fast inbox capture
│       ├── intention-clarifier/ ← Fuzzy idea → clear goal
│       └── meeting-processing/  ← Pre/post meeting
│
└── scripts/
    ├── new-day.sh / .ps1      ← Create today's memory file
    ├── heartbeat.sh / .ps1    ← Periodic checks
    ├── heartbeat-task.xml     ← Windows Task Scheduler template
    └── session-recap.sh / .ps1 ← Preview session context
```

---

## Troubleshooting

**`claude` command not found**
→ Install Claude Code: `npm install -g @anthropic-ai/claude-code`
→ Make sure Node.js is installed and `npm` is in your PATH

**API key not working**
→ Check the key at [console.anthropic.com](https://console.anthropic.com/)
→ Make sure `ANTHROPIC_API_KEY` is set in your environment (not just in `.env`)

**PowerShell execution policy error**
→ Run: `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned`

**Agent doesn't seem to have context**
→ Make sure you're running `claude` from the `openclaw-lite` directory (where `CLAUDE.md` lives)
→ Run `scripts/session-recap.ps1` (or `.sh`) to preview what context is loaded

**Memory files not updating**
→ Ask the agent explicitly: "log this to today's memory" or "remember: ..."
→ End sessions with "end of day" to trigger the reconciliation skill

---

## Updating

```bash
git pull origin main
```

Your `workspace/` files are yours — git won't overwrite them as long as you don't modify tracked template files.

> **Tip:** Add your `workspace/memory/` and `workspace/MEMORY.md` to `.gitignore` if you're in a shared or corporate repo environment — memory files contain personal context.
