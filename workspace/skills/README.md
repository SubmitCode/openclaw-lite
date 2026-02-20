# Skills

Skills are modular, on-demand capabilities. Each skill lives in its own folder.

## Structure

```
skills/
└── my-skill/
    ├── SKILL.md     ← Instructions for the agent (required)
    └── scripts/     ← Helper scripts (optional)
        └── run.py
```

## How Skills Work

1. At session start, the agent knows skills exist but doesn't load them
2. When a task clearly matches a skill, the agent reads that skill's `SKILL.md`
3. The agent follows the skill's instructions for that task

## Creating a Skill

1. Create a folder: `skills/your-skill-name/`
2. Write `SKILL.md` with:
   - **Description:** When to use this skill (1 sentence)
   - **Instructions:** Step-by-step what to do
   - **Scripts:** What scripts are available and how to run them
3. Add any helper scripts to `skills/your-skill-name/scripts/`

## Example Skill: Meeting Notes

```markdown
# SKILL.md — Meeting Notes

**Use when:** User wants to capture, summarize, or review meeting notes.

## Instructions

1. Ask for the meeting topic and attendees if not provided
2. Structure notes as: Summary, Decisions, Action Items
3. Save to: workspace/memory/meetings/YYYY-MM-DD-topic.md
4. Log a reference in today's daily memory file
```

## Tips

- Keep SKILL.md concise — the agent reads it on demand
- Scripts should be self-contained and runnable directly
- Document expected inputs/outputs in SKILL.md
