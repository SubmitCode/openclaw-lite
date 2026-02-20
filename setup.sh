#!/bin/bash
# openclaw-lite/setup.sh
# Interactive setup — personalizes your workspace markdown files.

set -e

WORKSPACE="$(dirname "$0")/workspace"
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo ""
echo -e "${BLUE}╔══════════════════════════════════════╗${NC}"
echo -e "${BLUE}║      openclaw-lite — Setup           ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════╝${NC}"
echo ""
echo "This will personalize your workspace files."
echo "You can re-run this anytime or edit the files directly."
echo ""

# --- USER.md ---
echo -e "${YELLOW}👤 About You${NC}"
read -p "  Your name: " USER_NAME
read -p "  What should the agent call you? [$USER_NAME]: " USER_CALLNAME
USER_CALLNAME="${USER_CALLNAME:-$USER_NAME}"
read -p "  Your role/job title: " USER_ROLE
read -p "  Company/Organization: " USER_COMPANY
read -p "  Timezone (e.g. Europe/Zurich): " USER_TZ
read -p "  Location (City, Country): " USER_LOCATION
read -p "  Primary language(s) [English]: " USER_LANG
USER_LANG="${USER_LANG:-English}"

echo ""
echo -e "${YELLOW}💼 Work Context${NC}"
read -p "  Primary tools (comma-separated, e.g. Jira, Confluence, GitHub): " USER_TOOLS
read -p "  Tech stack (e.g. Python, SQL, Azure): " USER_STACK
read -p "  Current main focus: " USER_FOCUS

echo ""
echo -e "${YELLOW}🎯 Goals${NC}"
echo "  Enter your main goals (one per line, empty line to finish):"
USER_GOALS=""
while IFS= read -r line; do
  [[ -z "$line" ]] && break
  USER_GOALS="${USER_GOALS}- ${line}\n"
done

# Write USER.md
cat > "$WORKSPACE/USER.md" << EOF
# USER.md — About Your Human

- **Name:** $USER_NAME
- **What to call them:** $USER_CALLNAME
- **Timezone:** $USER_TZ
- **Location:** $USER_LOCATION
- **Job:** $USER_ROLE at $USER_COMPANY
- **Language(s):** $USER_LANG

## Work Context

- **Primary tools:** $USER_TOOLS
- **Tech stack:** $USER_STACK
- **Current focus:** $USER_FOCUS

## Goals

$(echo -e "$USER_GOALS")
## Notes

_Add anything else that helps the agent help you._
EOF

echo ""
echo -e "${YELLOW}🪪 Agent Identity${NC}"
read -p "  Agent name [Assistant]: " AGENT_NAME
AGENT_NAME="${AGENT_NAME:-Assistant}"
read -p "  Agent emoji [🤖]: " AGENT_EMOJI
AGENT_EMOJI="${AGENT_EMOJI:-🤖}"

cat > "$WORKSPACE/IDENTITY.md" << EOF
# IDENTITY.md

- **Name:** $AGENT_NAME
- **Emoji:** $AGENT_EMOJI
- **Owner:** $USER_NAME
EOF

# Create memory directory and today's file
mkdir -p "$WORKSPACE/memory"
TODAY=$(date +%Y-%m-%d)
MEMORY_FILE="$WORKSPACE/memory/$TODAY.md"
if [ ! -f "$MEMORY_FILE" ]; then
  cat > "$MEMORY_FILE" << EOF
# $TODAY

## Setup

Agent initialized via setup.sh. User: $USER_NAME ($USER_ROLE at $USER_COMPANY).

EOF
  echo -e "  ${GREEN}✅ Created memory/$TODAY.md${NC}"
fi

# Create heartbeat state
cat > "$WORKSPACE/memory/heartbeat-state.json" << EOF
{
  "lastChecks": {
    "setup": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  }
}
EOF

echo ""
echo -e "${GREEN}✅ Setup complete!${NC}"
echo ""
echo "Your workspace is ready at: $WORKSPACE/"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Edit workspace/SOUL.md to shape the agent's personality"
echo "  2. Edit workspace/TOOLS.md with your environment specifics"
echo "  3. Run: claude  (in this directory — CLAUDE.md loads automatically)"
echo "  4. Optional: set up scripts/heartbeat.sh as a cron job"
echo ""
echo -e "${YELLOW}Tip:${NC} Add 'source /path/to/openclaw-lite/.env' to your shell if you use API keys."
echo ""
