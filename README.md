# openclaw-lite 🧠

> A lightweight, markdown-based personal assistant context system for Claude Code.

No server. No scripts. No setup wizard. Just structured markdown files that give Claude Code persistent memory, identity, and ready-made workflows.

Clone it, fill in `workspace/USER.md`, run `claude`. That's it.

---

## The Idea

[OpenClaw](https://github.com/openclaw/openclaw) is a full AI assistant platform. openclaw-lite captures its core insight:

> **An AI assistant is fundamentally a context management system.**  
> The LLM does the intelligence. The markdown files give it memory and identity.

~80% of the value, zero infrastructure.

---

## Quick Start

```bash
git clone https://github.com/SubmitCode/openclaw-lite.git
cd openclaw-lite
```

Open `workspace/USER.md` and fill in your name, role, timezone, and goals. Then:

```bash
claude
```

Claude Code reads `CLAUDE.md` automatically at every session start. Your context is loaded, memory is active, skills are ready.

**First things to try:**
- `"daily briefing"` — morning context load and priority setting
- `"add to inbox: [something]"` — quick capture
- `"clarify: [fuzzy idea]"` — turn a vague thought into a clear goal
- `"end of day"` — close loops and set up tomorrow
- `"weekly review"` — strategic audit and planning

---

## How It Works

On every session start, Claude Code auto-loads `CLAUDE.md`, which instructs the agent to:

1. Read your identity and context (`SOUL.md`, `USER.md`, `TOOLS.md`)
2. Load long-term memory (`MEMORY.md`)
3. Load today's and yesterday's notes (`memory/YYYY-MM-DD.md`)
4. Scan state files (`INBOX.md`, `WAITING_FOR.md`, `projects/INDEX.md`)
5. Load a skill on demand when a task matches it

Everything is plain text. Nothing is hidden. You can read, edit, and version-control all of it.

---

## Workspace Files

### Identity & Context

| File | Purpose |
|------|---------|
| `SOUL.md` | Agent personality, tone, and values |
| `IDENTITY.md` | Agent name and emoji |
| `USER.md` | About you — name, role, timezone, goals ← **edit this first** |
| `TOOLS.md` | Your environment specifics (paths, tools, endpoints) |

### Memory

| File | Purpose |
|------|---------|
| `MEMORY.md` | Long-term curated memory — decisions, preferences, ongoing context |
| `memory/YYYY-MM-DD.md` | Daily raw session notes (created by the agent) |

### Daily State Files

The agent scans these at session start and updates them throughout the day.

| File | Purpose | Review |
|------|---------|--------|
| `INBOX.md` | Universal capture — everything lands here first | Daily |
| `WAITING_FOR.md` | Delegated items and things you're waiting on | Daily |
| `DECISIONS.md` | Decision log with reasoning | As needed |
| `DASHBOARD.md` | Morning status snapshot | Morning |
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

Invoked by trigger phrases. The agent reads a skill's `SKILL.md` only when the task clearly matches — keeps context lean.

| Skill | Trigger | What it does |
|-------|---------|-------------|
| `daily-briefing` | "daily briefing" | Morning context load, surfaces urgent items, sets intentions |
| `end-of-day` | "end of day" / "wrap up" | Closes loops, updates state files, sets up tomorrow |
| `weekly-review` | "weekly review" | Strategic audit: inbox, projects, goals, plan ahead |
| `quick-capture` | "capture" / "add to inbox" | Fast frictionless inbox entry |
| `intention-clarifier` | "clarify" / fuzzy idea | Turns vague intentions into clear goals with next actions |
| `meeting-processing` | "meeting prep" / "meeting notes" | Pre/post meeting structure, extracts actions and decisions |

---

## Folder Structure

```
openclaw-lite/
├── CLAUDE.md                    ← Auto-loaded by Claude Code every session
├── README.md
├── SETUP.md                     ← Detailed setup guide
│
└── workspace/
    ├── SOUL.md
    ├── IDENTITY.md
    ├── USER.md                  ← Edit this first
    ├── TOOLS.md
    ├── MEMORY.md
    ├── INBOX.md
    ├── WAITING_FOR.md
    ├── DECISIONS.md
    ├── DASHBOARD.md
    ├── GOALS.md
    ├── SOMEDAY.md
    ├── RECURRING.md
    ├── memory/
    │   └── YYYY-MM-DD.md        ← Created by the agent
    ├── projects/
    │   ├── INDEX.md
    │   ├── _TEMPLATE.md
    │   ├── active/
    │   ├── planning/
    │   └── archive/
    └── skills/
        ├── daily-briefing/
        ├── end-of-day/
        ├── weekly-review/
        ├── quick-capture/
        ├── intention-clarifier/
        └── meeting-processing/
```

---

## Memory System

| Layer | File | Who updates it |
|-------|------|----------------|
| Long-term | `MEMORY.md` | Agent — distilled periodically from daily notes |
| Daily | `memory/YYYY-MM-DD.md` | Agent — during and after each session |
| State | `INBOX.md`, `WAITING_FOR.md`, etc. | Agent — as things change |

**The rule:** No mental notes. Files survive restarts. Thoughts don't.  
Say `"remember: ..."` and the agent writes it immediately.

---

## Privacy & Corporate Use

- All data stays local — no cloud sync, no telemetry beyond Claude Code itself
- Consider adding `workspace/memory/` and `workspace/MEMORY.md` to `.gitignore` for shared or corporate repos — memory files contain personal context

---

## Inspiration

Distilled from [OpenClaw](https://github.com/openclaw/openclaw):
- Persistent identity via markdown
- Session memory via daily notes  
- On-demand skills via SKILL.md files

---

## License

MIT
