#!/bin/bash
# scripts/heartbeat.sh
# Lightweight periodic check — runs via cron, appends a heartbeat note to today's memory.
# Customize the checks below for your environment.
#
# Example cron (every 30 min, 8am-8pm):
#   */30 8-20 * * 1-5 /path/to/openclaw-lite/scripts/heartbeat.sh >> /tmp/heartbeat.log 2>&1

WORKSPACE="$(dirname "$0")/../workspace"
TODAY=$(date +%Y-%m-%d)
NOW=$(date +"%H:%M")
MEMORY_FILE="$WORKSPACE/memory/$TODAY.md"
STATE_FILE="$WORKSPACE/memory/heartbeat-state.json"

mkdir -p "$WORKSPACE/memory"

# Ensure today's file exists
[ ! -f "$MEMORY_FILE" ] && bash "$(dirname "$0")/new-day.sh"

echo ""
echo "## Heartbeat @ $NOW" >> "$MEMORY_FILE"

# ─── CHECKS ──────────────────────────────────────────────────────────────────
# Add your own checks here. Examples:

# 1. Check a local service is up
# HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -m 5 http://localhost:8080/health 2>/dev/null)
# if [ "$HTTP_CODE" != "200" ]; then
#   echo "⚠️  Service on :8080 is DOWN (HTTP $HTTP_CODE)" >> "$MEMORY_FILE"
#   # Optionally: restart it here
# else
#   echo "✅ Service :8080 healthy" >> "$MEMORY_FILE"
# fi

# 2. Check disk space
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
if [ "$DISK_USAGE" -gt 85 ]; then
  echo "⚠️  Disk usage high: ${DISK_USAGE}%" >> "$MEMORY_FILE"
else
  echo "✅ Disk: ${DISK_USAGE}% used" >> "$MEMORY_FILE"
fi

# 3. Check pending git commits (if in a git repo)
# if git -C /path/to/project status --porcelain | grep -q .; then
#   echo "📝 Uncommitted changes in project repo" >> "$MEMORY_FILE"
# fi

# ─────────────────────────────────────────────────────────────────────────────

# Update heartbeat state
python3 -c "
import json, datetime, sys
try:
    with open('$STATE_FILE') as f:
        state = json.load(f)
except:
    state = {'lastChecks': {}}
state['lastChecks']['heartbeat'] = datetime.datetime.utcnow().isoformat() + 'Z'
with open('$STATE_FILE', 'w') as f:
    json.dump(state, f, indent=2)
" 2>/dev/null || true

echo "Heartbeat done @ $(date)"
