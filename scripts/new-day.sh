#!/bin/bash
# scripts/new-day.sh
# Creates today's memory file if it doesn't exist yet.
# Run this at the start of each day (via cron or manually).

WORKSPACE="$(dirname "$0")/../workspace"
TODAY=$(date +%Y-%m-%d)
MEMORY_FILE="$WORKSPACE/memory/$TODAY.md"

mkdir -p "$WORKSPACE/memory"

if [ ! -f "$MEMORY_FILE" ]; then
  cat > "$MEMORY_FILE" << EOF
# $TODAY

## Sessions

_Add notes during/after each conversation._

## Decisions

## Follow-ups

## Notes

EOF
  echo "✅ Created memory/$TODAY.md"
else
  echo "ℹ️  memory/$TODAY.md already exists"
fi
