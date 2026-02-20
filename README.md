# openclaw-lite 🧠

> A lightweight, file-based AI assistant context system for Claude Code.  
> Get ~80% of OpenClaw's value with just markdown files + Claude Code CLI.

No server. No complex setup. Just structured markdown that turns Claude Code into a persistent, opinionated personal assistant — with memory, projects, inbox, and ready-made workflows.

---

## The Idea

[OpenClaw](https://github.com/openclaw/openclaw) is a powerful AI assistant platform. But if you can't install it (corporate environment, locked-down machine), you can replicate its core value:

> **An AI assistant is fundamentally a context management system.**  
> The LLM does the intelligence. The markdown files give it memory and identity.

This repo gives you that system — portable, auditable, version-controllable, and zero-dependency beyond Claude Code itself.

---

## Quick Start

```bash
# 1. Clone
git clone https://github.com/SubmitCode/openclaw-lite.git
cd openclaw-lite

# 2. Edit workspace/USER.md with your name, role, timezone, goals
# (or run the optional setup wizard — see below)

# 3. Start Claude Code — CLAUDE.md loads automatically
claude
```

That's it. No API key config, no server, no dependencies. Claude Code handles its own authentication.

**First things to try once you're in:**
- `"daily briefing"` — morning context load and priority setting
- `"add to inbox: [something]"` — quick capture
- `"clarify: [fuzzy idea]"` — turn a vague thought into a clear goal
- `"end of day"` — close loops and set up tomorrow

---

## Do You Need the Setup Script?

**Short answer: no.** You can clone the repo, open `workspace/USER.md`, fill in your details, and run `claude`. Done.

The setup scripts (`setup.sh` / `setup.ps1`) are optional convenience wizards — they ask you questions and write the files for you. Useful if you prefer an interactive walkthrough, but experienced users will find it faster to just edit the markdown directly.

---

## How It Works

Claude Code automatically reads `CLAUDE.md` at the start of every session. That file tells the agent to:

1. Load your identity and context (`SOUL.md`, `USER.md`, `TOOLS.md`)
2. Load long-term memory (`MEMORY.md`)
3. Load recent daily notes (`memory/YYYY-MM-DD.md`)
4. Scan the state files (`INBOX.md`, `WAITING_FOR.md`, `projects/INDEX.md`)
5. Load a skill when a task matches it

Everything is plain markdown. Nothing is hidden.

---

## Workspace Files

### Identity & Context
| File | Purpose |
|------|---------|
| `SOUL.md` | Agent personality, tone, and values |
| `IDENTITY.md` | Agent name and emoji |
| `USER.md` | About you — name, role, timezone, goals, preferences |
| `TOOLS.md` | Your environment specifics (paths, tools, API endpoints) |

### Memory
| File | Purpose |
|------|---------|
| `MEMORY.md` | Long-term curated memory — decisions, preferences, ongoing context |
| `memory/YYYY-MM-DD.md` | Daily raw session notes |

### Daily State Files
These are your daily touchpoints — the agent scans them at session start and updates them throughout the day.

| File | Purpose | Check when |
|------|---------|------------|
| `INBOX.md` | Universal capture — everything lands here first | Daily |
| `WAITING_FOR.md` | Delegated items and things you're waiting on | Daily |
| `DECISIONS.md` | Decision log with reasoning | After significant choices |
| `DASHBOARD.md` | Morning status snapshot (updated by daily briefing skill) | Morning |
| `GOALS.md` | Longer-horizon personal and professional goals | Weekly |
| `SOMEDAY.md` | Ideas and backlog for later | Weekly |
| `RECURRING.md` | Recurring tasks and rhythms | Weekly |

### Projects
| Path | Purpose |
|------|---------|
| `projects/INDEX.md` | Fast-scan overview of all active projects |
| `projects/active/` | One file per active project (loaded on demand) |
| `projects/planning/` | Pre-kickoff projects |
| `projects/archive/` | Completed projects |
| `projects/_TEMPLATE.md` | Template for new project files |

### Skills (On-Demand Workflows)
Skills are invoked by trigger phrases. The agent reads a skill's `SKILL.md` only when the task matches — keeps context lean.

| Skill | Trigger | What it does |
|-------|---------|-------------|
| `daily-briefing` | "daily briefing" | Morning context load, surfaces urgent items, sets intentions |
| `end-of-day` | "end of day" / "wrap up" | Closes loops, updates all state files, sets up tomorrow |
| `weekly-review` | "weekly review" | Strategic audit: inbox, projects, goals, plan ahead |
| `quick-capture` | "capture" / "add to inbox" | Fast frictionless inbox capture without breaking flow |
| `intention-clarifier` | "clarify" / fuzzy idea | Turns vague intentions into clear goals with next actions |
| `meeting-processing` | "meeting prep" / "meeting notes" | Pre/post meeting structure, extracts actions and decisions |

---

## Scripts

Every script has both a shell (`.sh`) and PowerShell (`.ps1`) version.

| Script | Purpose |
|--------|---------|
| `setup.sh` / `setup.ps1` | Optional setup wizard |
| `scripts/new-day.sh` / `.ps1` | Create today's memory file |
| `scripts/heartbeat.sh` / `.ps1` | Periodic checks (disk, services) — run via cron/Task Scheduler |
| `scripts/session-recap.sh` / `.ps1` | Preview what context Claude loads — useful for debugging |
| `scripts/heartbeat-task.xml` | Windows Task Scheduler template for heartbeat |

---

## Folder Structure

```
openclaw-lite/
├── CLAUDE.md                    ← Auto-loaded by Claude Code (the core bootstrap)
├── SETUP.md                     ← Detailed setup guide
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
│       ├── daily-briefing/
│       ├── end-of-day/
│       ├── weekly-review/
│       ├── quick-capture/
│       ├── intention-clarifier/
│       └── meeting-processing/
│
└── scripts/
    ├── new-day.sh / .ps1
    ├── heartbeat.sh / .ps1
    ├── heartbeat-task.xml       ← Windows Task Scheduler template
    └── session-recap.sh / .ps1
```

---

## Memory System

| Layer | File | Updated by |
|-------|------|-----------|
| Long-term | `MEMORY.md` | Agent — distilled every few days from daily notes |
| Daily | `memory/YYYY-MM-DD.md` | Agent — during/after each session |
| State | `INBOX.md`, `WAITING_FOR.md`, etc. | Agent — continuously, as things change |

**The rule:** No mental notes. Files survive session restarts. Thoughts don't.  
If you want the agent to remember something: *"remember: ..."* → it writes it immediately.

---

## Privacy & Corporate Use

- All your data stays local — no cloud sync, no telemetry
- Memory files contain personal/work context — consider adding `workspace/memory/` and `workspace/MEMORY.md` to `.gitignore` for shared/corporate repos
- Skills and scripts are safe to commit and share across teams

---

## Inspiration

Distilled from [OpenClaw](https://github.com/openclaw/openclaw)'s core principles:
- Persistent identity via markdown files
- Session memory via daily notes
- On-demand skills via modular SKILL.md files
- Proactive periodic checks via heartbeat

---

## License

MIT
