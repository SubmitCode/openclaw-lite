# openclaw-lite 🧠

> A lightweight, file-based AI assistant context system for Claude Code.  
> Get ~80% of OpenClaw's value with just markdown files + Claude Code CLI.

No server. No Telegram. No browser automation. Just structured context that turns Claude Code into a persistent, opinionated personal assistant.

---

## The Idea

[OpenClaw](https://github.com/openclaw/openclaw) is a powerful AI assistant platform. But if you can't install it (corporate environment, locked-down machine), you can replicate its core value:

> **OpenClaw is fundamentally a context management system.**  
> The LLM does the intelligence. The markdown files give it memory and identity.

This repo gives you that system — portable, auditable, version-controllable, and zero-dependency (beyond Claude Code itself).

---

## Quick Start

```bash
# 1. Clone
git clone https://github.com/YOUR_USERNAME/openclaw-lite.git
cd openclaw-lite

# 2. Set up your API key
cp .env.example .env
# Edit .env and add your ANTHROPIC_API_KEY

# 3. Run setup (personalizes your workspace files)
chmod +x setup.sh scripts/*.sh
./setup.sh

# 4. Start Claude Code — CLAUDE.md loads automatically
claude
```

---

## How It Works

```
openclaw-lite/
├── CLAUDE.md                  ← 🔑 Auto-loaded by Claude Code. Bootstraps everything.
├── setup.sh                   ← Interactive setup wizard
├── .env.example               ← API key template
│
├── workspace/
│   ├── SOUL.md                ← Agent personality & values
│   ├── IDENTITY.md            ← Agent name & emoji
│   ├── USER.md                ← Who the agent is helping
│   ├── AGENTS.md              ← Operating rules & memory protocol
│   ├── TOOLS.md               ← Your environment specifics (paths, aliases, etc.)
│   ├── MEMORY.md              ← Long-term curated memory
│   ├── memory/
│   │   ├── YYYY-MM-DD.md      ← Daily raw session notes
│   │   └── heartbeat-state.json
│   └── skills/
│       └── your-skill/
│           ├── SKILL.md       ← Skill instructions for the agent
│           └── scripts/       ← Helper scripts
│
└── scripts/
    ├── new-day.sh             ← Creates today's memory file
    ├── heartbeat.sh           ← Periodic checks (run via cron)
    └── session-recap.sh       ← Preview what context the agent will load
```

---

## The Memory System

| File | Purpose | When Updated |
|------|---------|-------------|
| `workspace/MEMORY.md` | Long-term memory — curated, distilled | Every few days (by agent) |
| `workspace/memory/YYYY-MM-DD.md` | Daily raw notes | During/after each session |
| `workspace/memory/heartbeat-state.json` | Tracks last check times | By heartbeat script |

**The rule:** If the agent wants to remember something, it writes it to a file.  
Files survive session restarts. "Mental notes" don't.

---

## Periodic Checks (Heartbeat)

Run `scripts/heartbeat.sh` on a schedule to get proactive monitoring:

```bash
# Example: run every 30 minutes during work hours
*/30 8-20 * * 1-5 /path/to/openclaw-lite/scripts/heartbeat.sh >> /tmp/heartbeat.log 2>&1
```

Customize the checks in `scripts/heartbeat.sh` — disk space, service health, git status, etc.

---

## Adding Skills

Skills are on-demand capability modules:

```bash
mkdir -p workspace/skills/my-skill/scripts
cat > workspace/skills/my-skill/SKILL.md << 'EOF'
# SKILL.md — My Skill

**Use when:** [describe when to use this skill]

## Instructions

1. Step one
2. Step two
3. Save output to: workspace/memory/...
EOF
```

The agent reads `SKILL.md` only when the task matches — keeps context lean.

---

## Privacy & Corporate Use

- **Memory files contain personal/work context** — think carefully about what to commit to git
- Recommended: add `workspace/memory/` and `workspace/MEMORY.md` to `.gitignore` if memory is private
- API keys go in `.env` (already gitignored)
- Skills and scripts are safe to commit and share

---

## Inspiration

Built as a distillation of [OpenClaw](https://github.com/openclaw/openclaw)'s core principles:
- Persistent identity via markdown files
- Session memory via daily notes
- On-demand skills via modular SKILL.md files
- Proactive periodic checks via heartbeat

Inspired by the idea that **80% of an AI assistant's value comes from context, not infrastructure**.

---

## License

MIT
