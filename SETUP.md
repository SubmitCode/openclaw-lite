# Setup Guide

Step-by-step instructions for getting openclaw-lite running on Windows, macOS, or Linux.

---

## Prerequisites

| Tool | Required | Install |
|------|----------|---------|
| [Claude Code](https://docs.anthropic.com/en/docs/claude-code) | ✅ Yes | `npm install -g @anthropic-ai/claude-code` |
| Git | ✅ Yes | [git-scm.com](https://git-scm.com/) |
| Node.js (v18+) | ✅ Yes (for Claude Code) | [nodejs.org](https://nodejs.org/) |
| Python 3 | Optional | Only needed for heartbeat state tracking |

> **No API key setup needed.** Claude Code manages its own authentication via `claude auth login`. Just install it, log in once, and you're ready.

---

## Step 1 — Clone the Repository

```bash
git clone https://github.com/SubmitCode/openclaw-lite.git
cd openclaw-lite
```

---

## Step 2 — Authenticate Claude Code (first time only)

```bash
claude auth login
```

Follow the prompts. You only need to do this once — Claude Code stores credentials for subsequent sessions.

---

## Step 3 — Personalize Your Workspace

You have two options:

### Option A — Just edit the files (recommended for most users)

Open `workspace/USER.md` and fill in your details — name, role, timezone, goals. That's the most important file. Then browse the other files in `workspace/` and customize as needed:

- `workspace/SOUL.md` — agent personality and tone
- `workspace/TOOLS.md` — your environment specifics (paths, tools)
- `workspace/GOALS.md` — your longer-horizon goals
- `workspace/RECURRING.md` — your recurring routines

### Option B — Interactive setup wizard

The setup scripts ask questions and write the files for you:

**Windows (PowerShell):**
```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned   # one-time
.\setup.ps1
```

**macOS / Linux:**
```bash
chmod +x setup.sh scripts/*.sh
./setup.sh
```

---

## Step 4 — Start Claude Code

From the `openclaw-lite` directory:

```bash
claude
```

`CLAUDE.md` is automatically read by Claude Code at session start — no extra config. The agent loads your workspace context and is ready to help.

**First things to try:**
- `"daily briefing"` — morning context load and priority setting
- `"add to inbox: [something]"` — quick capture
- `"clarify: [fuzzy idea]"` — turn a vague thought into a clear goal
- `"end of day"` — close loops and set up tomorrow
- `"weekly review"` — strategic audit and planning

---

## Step 5 (Optional) — Schedule Heartbeat Checks

> **Skip this if you're just getting started.** It's optional and most users won't need it.

The heartbeat script logs system checks (disk space, service health, etc.) to your daily memory file. The next time you start a Claude Code session, the agent reads those notes automatically.

**This is not background AI.** It's a plain shell script that writes to markdown. Claude Code doesn't run in the background — it's interactive. The equivalent of a "heartbeat" in Claude Code is simply opening a session and saying `"daily briefing"`.

Only set this up if you want automated system monitoring notes passively logged to your memory. Customize the checks in `scripts/heartbeat.sh` / `scripts/heartbeat.ps1` before scheduling.

### Windows — Task Scheduler

**Option A: Import the XML template**

1. Edit `scripts/heartbeat-task.xml`:
   - Replace `YOURUSERNAME` with your Windows username
   - Replace the `WorkingDirectory` path with your actual path to `openclaw-lite`
2. Import in PowerShell (as Administrator):
   ```powershell
   Register-ScheduledTask -Xml (Get-Content scripts\heartbeat-task.xml | Out-String) -TaskName "openclaw-heartbeat"
   ```
3. Verify: open Task Scheduler and find `openclaw-heartbeat`

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

# Add this line (every 30 min, 8am-8pm, weekdays):
*/30 8-20 * * 1-5 /path/to/openclaw-lite/scripts/heartbeat.sh >> /tmp/openclaw-heartbeat.log 2>&1
```

---

## Folder Structure Reference

```
openclaw-lite/
├── CLAUDE.md                    ← Auto-loaded by Claude Code (the core bootstrap)
├── SETUP.md                     ← This file
├── setup.sh / setup.ps1         ← Optional setup wizard
│
├── workspace/
│   ├── SOUL.md                  ← Agent personality
│   ├── IDENTITY.md              ← Agent name & emoji
│   ├── USER.md                  ← About you ← edit this first
│   ├── TOOLS.md                 ← Your environment specifics
│   ├── MEMORY.md                ← Long-term memory
│   ├── INBOX.md                 ← Universal capture inbox
│   ├── WAITING_FOR.md           ← Delegated & pending items
│   ├── DECISIONS.md             ← Decision log
│   ├── DASHBOARD.md             ← Morning status snapshot
│   ├── GOALS.md                 ← Longer-horizon goals
│   ├── SOMEDAY.md               ← Ideas & backlog
│   ├── RECURRING.md             ← Recurring tasks & rhythms
│   ├── memory/
│   │   ├── YYYY-MM-DD.md        ← Daily session notes
│   │   └── heartbeat-state.json
│   ├── projects/
│   │   ├── INDEX.md             ← Fast-scan project overview
│   │   ├── _TEMPLATE.md         ← New project template
│   │   ├── active/              ← One file per active project
│   │   ├── planning/            ← Pre-kickoff projects
│   │   └── archive/             ← Completed projects
│   └── skills/
│       ├── daily-briefing/      ← "daily briefing"
│       ├── end-of-day/          ← "end of day" / "wrap up"
│       ├── weekly-review/       ← "weekly review"
│       ├── quick-capture/       ← "capture" / "add to inbox"
│       ├── intention-clarifier/ ← "clarify"
│       └── meeting-processing/  ← "meeting prep" / "meeting notes"
│
└── scripts/
    ├── heartbeat.sh / .ps1      ← Optional system health check logger
    ├── heartbeat-task.xml       ← Windows Task Scheduler template
    └── session-recap.sh / .ps1  ← Preview what context Claude loads
```

---

## Troubleshooting

**`claude` command not found**
→ Install Claude Code: `npm install -g @anthropic-ai/claude-code`
→ Make sure Node.js is installed and `npm` is in your PATH

**Agent doesn't seem to have context**
→ Make sure you're running `claude` from the `openclaw-lite` folder (where `CLAUDE.md` lives)
→ Run `scripts/session-recap.ps1` (Windows) or `scripts/session-recap.sh` (macOS/Linux) to preview what's loaded

**PowerShell execution policy error**
→ Run: `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned`

**Memory files not updating**
→ Ask explicitly: `"remember: ..."` or `"log this to today's memory"`
→ End sessions with `"end of day"` to trigger the reconciliation skill

---

## Updating

```bash
git pull origin main
```

Your `workspace/` files are yours — updates won't overwrite them as long as you haven't modified tracked template files directly.

> **Tip for corporate/shared repos:** Add `workspace/memory/` and `workspace/MEMORY.md` to `.gitignore` — memory files contain personal context you probably don't want committed.
