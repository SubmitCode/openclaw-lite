# Setup Guide

---

## Prerequisites

| Tool | Install |
|------|---------|
| [Claude Code](https://docs.anthropic.com/en/docs/claude-code) | `npm install -g @anthropic-ai/claude-code` |
| Node.js (v18+) | [nodejs.org](https://nodejs.org/) |
| Git | [git-scm.com](https://git-scm.com/) |

No API key setup needed — Claude Code handles authentication via `claude auth login`.

---

## 1. Clone

```bash
git clone https://github.com/SubmitCode/openclaw-lite.git
cd openclaw-lite
```

---

## 2. Authenticate Claude Code (first time only)

```bash
claude auth login
```

Follow the prompts. One-time setup — credentials are stored for future sessions.

---

## 3. Personalize

Open `workspace/USER.md` and fill in your details. This is the most important file — it tells the agent who you are.

Then browse the other files in `workspace/` and customize:

- `SOUL.md` — agent personality and tone
- `TOOLS.md` — your environment (paths, tools, endpoints)
- `GOALS.md` — your longer-horizon goals
- `RECURRING.md` — your recurring routines

All files are plain markdown — just edit them directly.

---

## 4. Run

```bash
claude
```

From the `openclaw-lite` directory. `CLAUDE.md` loads automatically — no flags, no config.

**Try these to get started:**
- `"daily briefing"` — morning context and priorities
- `"add to inbox: [something]"` — quick capture
- `"end of day"` — close loops, set up tomorrow

---

## Troubleshooting

**`claude` command not found**
→ `npm install -g @anthropic-ai/claude-code`

**Agent doesn't seem to have my context**
→ Make sure you're running `claude` from the `openclaw-lite` folder (where `CLAUDE.md` lives)
→ Check that `workspace/USER.md` is filled in

**Memory not updating between sessions**
→ Say `"remember: ..."` to write explicitly
→ Use `"end of day"` to trigger the reconciliation skill — it updates all state files

---

## Keeping It Private

If you're in a corporate or shared repo environment, consider adding to `.gitignore`:

```
workspace/memory/
workspace/MEMORY.md
```

Memory files contain personal work context you probably don't want committed.

---

## Updating

```bash
git pull origin main
```
