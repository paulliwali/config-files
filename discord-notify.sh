#!/bin/bash
WEBHOOK_URL="https://discord.com/api/webhooks/1457600927828676638/TW6o-kzY5S7eVzS5QCwWKgr4SXL-bdEUhbUeBql6l7wcOB70rhKcCLAGLSG2BqRexTHw"

# Read hook input from stdin
input=$(cat)

# Determine session name for prefix
if [ -n "$CLAUDE_SESSION_NAME" ]; then
    # Use env var if set
    SESSION_PREFIX="[$CLAUDE_SESSION_NAME] "
else
    # Try to detect from current directory
    SESSION_NAME=$(basename "$PWD" | tr '[:upper:]' '[:lower:]')
    if [ "$SESSION_NAME" != "root" ] && [ -n "$SESSION_NAME" ]; then
        SESSION_PREFIX="[$SESSION_NAME] "
    else
        # No prefix (backward compatibility)
        SESSION_PREFIX=""
    fi
fi

# Debug logging
LOG_FILE="/tmp/discord-notify.log"
echo "$(date): Hook triggered (session: ${SESSION_PREFIX:-none})" >> "$LOG_FILE"
echo "Input data: $input" >> "$LOG_FILE"

# Extract relevant information based on tool type
TOOL_NAME=$(echo "$input" | jq -r '.tool_name' 2>/dev/null)
HOOK_EVENT=$(echo "$input" | jq -r '.hook_event_name' 2>/dev/null)

# Build message based on tool type
case "$TOOL_NAME" in
  "AskUserQuestion")
    QUESTION=$(echo "$input" | jq -r '.tool_input.questions[0].question' 2>/dev/null)
    # Extract options and format them
    OPTIONS=$(echo "$input" | jq -r '.tool_input.questions[0].options | to_entries | map((.key + 1 | tostring) + ". " + .value.label + " - " + .value.description) | join("\n")' 2>/dev/null)

    if [ -n "$OPTIONS" ] && [ "$OPTIONS" != "null" ]; then
      MESSAGE="${SESSION_PREFIX}🚨 **Claude Needs Input:**
$QUESTION

**Options:**
$OPTIONS"
    else
      MESSAGE="${SESSION_PREFIX}🚨 **Claude Needs Input:**
$QUESTION"
    fi
    ;;
  "Bash")
    COMMAND=$(echo "$input" | jq -r '.tool_input.command' 2>/dev/null)
    DESCRIPTION=$(echo "$input" | jq -r '.tool_input.description' 2>/dev/null)
    if [ "$HOOK_EVENT" = "PreToolUse" ]; then
      MESSAGE="${SESSION_PREFIX}⚙️ **Running command:** $DESCRIPTION
\`\`\`bash
${COMMAND:0:200}
\`\`\`"
    else
      MESSAGE="${SESSION_PREFIX}✅ **Command completed:** $DESCRIPTION"
    fi
    ;;
  "Read")
    FILE_PATH=$(echo "$input" | jq -r '.tool_input.file_path' 2>/dev/null)
    if [ "$HOOK_EVENT" = "PreToolUse" ]; then
      MESSAGE="${SESSION_PREFIX}📖 **Reading file:** \`$FILE_PATH\`"
    else
      MESSAGE="${SESSION_PREFIX}✅ **Read completed:** \`$FILE_PATH\`"
    fi
    ;;
  "Write")
    FILE_PATH=$(echo "$input" | jq -r '.tool_input.file_path' 2>/dev/null)
    if [ "$HOOK_EVENT" = "PreToolUse" ]; then
      MESSAGE="${SESSION_PREFIX}✏️ **Writing file:** \`$FILE_PATH\`"
    else
      MESSAGE="${SESSION_PREFIX}✅ **Write completed:** \`$FILE_PATH\`"
    fi
    ;;
  "Edit")
    FILE_PATH=$(echo "$input" | jq -r '.tool_input.file_path' 2>/dev/null)
    if [ "$HOOK_EVENT" = "PreToolUse" ]; then
      MESSAGE="${SESSION_PREFIX}✏️ **Editing file:** \`$FILE_PATH\`"
    else
      MESSAGE="${SESSION_PREFIX}✅ **Edit completed:** \`$FILE_PATH\`"
    fi
    ;;
  "TodoWrite")
    MESSAGE="${SESSION_PREFIX}📝 **Updated todo list**"
    ;;
  "EnterPlanMode")
    MESSAGE="${SESSION_PREFIX}🎯 **Entering plan mode**"
    ;;
  "ExitPlanMode")
    MESSAGE="${SESSION_PREFIX}🎯 **Exiting plan mode - ready for approval**"
    ;;
  *)
    MESSAGE="${SESSION_PREFIX}🤖 **Claude activity:** $TOOL_NAME ($HOOK_EVENT)"
    ;;
esac

# Send to Discord - properly escape JSON
PAYLOAD=$(jq -n --arg msg "$MESSAGE" '{content: $msg}')
curl -s -H "Content-Type: application/json" \
     -d "$PAYLOAD" \
     $WEBHOOK_URL >> /tmp/discord-notify.log 2>&1

