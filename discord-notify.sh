#!/bin/bash
WEBHOOK_URL="https://discord.com/api/webhooks/1457600927828676638/TW6o-kzY5S7eVzS5QCwWKgr4SXL-bdEUhbUeBql6l7wcOB70rhKcCLAGLSG2BqRexTHw"

# Read hook input from stdin
input=$(cat)

# Debug logging
echo "$(date): Hook triggered" >> /tmp/discord-notify.log
echo "Input data: $input" >> /tmp/discord-notify.log

# Extract the question from Claude's hook data
QUESTION=$(echo "$input" | jq -r '.tool_input.questions[0].question' 2>/dev/null)

# Fallback message if question extraction fails
if [ -z "$QUESTION" ]; then
  QUESTION="Claude is asking a question (check logs for details)"
fi

# Send to Discord
curl -s -H "Content-Type: application/json" \
     -d "{\"content\": \"🚨 **Claude Needs Input:**\n$QUESTION\"}" \
     $WEBHOOK_URL >> /tmp/discord-notify.log 2>&1

