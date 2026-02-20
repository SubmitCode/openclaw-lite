#!/bin/bash
# scripts/session-recap.sh
# Prints the system prompt context that Claude Code would read on session start.
# Useful for debugging: see exactly what context the agent has loaded.

WORKSPACE="$(dirname "$0")/../workspace"
TODAY=$(date +%Y-%m-%d)
YESTERDAY=$(date -d "yesterday" +%Y-%m-%d 2>/dev/null || date -v-1d +%Y-%m-%d)

echo "════════════════════════════════════════"
echo "  openclaw-lite — Session Context Preview"
echo "════════════════════════════════════════"
echo ""

files=("SOUL.md" "USER.md" "AGENTS.md" "MEMORY.md" "TOOLS.md")
for f in "${files[@]}"; do
  path="$WORKSPACE/$f"
  if [ -f "$path" ]; then
    echo "── $f ──"
    cat "$path"
    echo ""
  fi
done

for day in "$TODAY" "$YESTERDAY"; do
  path="$WORKSPACE/memory/$day.md"
  if [ -f "$path" ]; then
    echo "── memory/$day.md ──"
    cat "$path"
    echo ""
  fi
done

echo "════════════════════════════════════════"
echo "  Total context files loaded"
echo "════════════════════════════════════════"
