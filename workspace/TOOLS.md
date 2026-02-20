# TOOLS.md — Environment Notes

> This file is for YOUR specifics — things unique to your setup. Skills define how tools work; this file defines your instance of them.

## What Goes Here

- API endpoints and base URLs (not secrets — store those in `.env`)
- SSH hosts and aliases
- File paths to important things
- Device or service nicknames
- Anything environment-specific

## Template

```markdown
### APIs / Services
- Internal API: https://api.corp.example.com
- Data platform: [name, URL, access notes]

### File Paths
- Project root: /path/to/project
- Reports output: /path/to/reports

### SSH / Remote
- dev-server → hostname or IP, user: yourname

### Credentials
- Stored in: .env (never commit this file)
- Pattern: source .env before running scripts
```

## Notes

Skills are shared and generic. This file is yours. Keep them separate so you can update skills without losing your setup, and share skills without leaking your infrastructure.
