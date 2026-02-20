#!/bin/bash
# scripts/heartbeat.sh — Optional system health check logger
#
# What this does:
#   Runs checks (disk space, services, etc.) and appends results to today's
#   memory file. The next time you start a Claude Code session, the agent
#   reads those notes as part of its context load.
#
# What this does NOT do:
#   It does not trigger Claude Code or start a session automatically.
#   There is no background AI running — this is just a shell script that
#   writes to a markdown file.
#
# The Claude Code equivalent of a "heartbeat" is simply starting your day
#   with: "daily briefing"
#
# To schedule (optional):
#   crontab -e
#   */30 8-20 * * 1-5 /path/to/openclaw-lite/scripts/heartbeat.sh >> /tmp/openclaw-heartbeat.log 2>&1

WORKSPACE="$(dirname "$0")/../workspace"
TODAY=$(date +%Y-%m-%d)
NOW=$(date +"%H:%M")
MEMORY_FILE="$WORKSPACE/memory/$TODAY.md"
STATE_FILE="$WORKSPACE/memory/heartbeat-state.json"

mkdir -p "$WORKSPACE/memory"

# Create today's memory file if it doesn't exist
if [ ! -f "$MEMORY_FILE" ]; then
  cat > "$MEMORY_FILE" << EOF
# $TODAY

## Sessions

_Add notes during/after each conversation._

## Notes

EOF
fi

echo "" >> "$MEMORY_FILE"
echo "## System Check @ $NOW" >> "$MEMORY_FILE"

# ─── ADD YOUR CHECKS BELOW ───────────────────────────────────────────────────

# 1. Disk space
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
if [ "$DISK_USAGE" -gt 85 ]; then
  echo "⚠️  Disk usage high: ${DISK_USAGE}%" >> "$MEMORY_FILE"
else
  echo "✅ Disk: ${DISK_USAGE}% used" >> "$MEMORY_FILE"
fi

# 2. Check a local service (uncomment and adapt)
# HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -m 5 http://localhost:8080/health 2>/dev/null)
# if [ "$HTTP_CODE" != "200" ]; then
#   echo "⚠️  Service :8080 DOWN (HTTP $HTTP_CODE)" >> "$MEMORY_FILE"
# else
#   echo "✅ Service :8080 healthy" >> "$MEMORY_FILE"
# fi

# 3. Check for uncommitted git changes (uncomment and adapt)
# if git -C /path/to/project status --porcelain | grep -q .; then
#   echo "📝 Uncommitted changes in project repo" >> "$MEMORY_FILE"
# fi

# ─────────────────────────────────────────────────────────────────────────────

# Update state file
python3 -c "
import json, datetime
try:
    with open('$STATE_FILE') as f:
        state = json.load(f)
except:
    state = {'lastChecks': {}}
state['lastChecks']['heartbeat'] = datetime.datetime.utcnow().isoformat() + 'Z'
with open('$STATE_FILE', 'w') as f:
    json.dump(state, f, indent=2)
" 2>/dev/null || true

echo "System check logged @ $(date)"
