#!/bin/bash

# Auto-start all enabled Claude Code sessions
# This script can be run manually or added to startup (.bashrc, systemd, etc.)

echo "====================================="
echo "  Claude Sessions Auto-Start"
echo "====================================="
echo ""

# Source environment variables if they exist
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# Check if session manager exists
if [ ! -f /root/claude-session ]; then
    echo "ERROR: claude-session not found"
    exit 1
fi

# Check for configured sessions
CONFIG_DIR="/root/.claude-sessions"
if [ ! -d "$CONFIG_DIR" ] || [ -z "$(ls -A "$CONFIG_DIR"/*.yaml 2>/dev/null)" ]; then
    echo "No sessions configured. Run 'claude-session add' to create one."
    exit 0
fi

# Start each enabled session
started=0
skipped=0

for config in "$CONFIG_DIR"/*.yaml; do
    if [ ! -f "$config" ]; then
        continue
    fi

    repo=$(basename "$config" .yaml)
    enabled=$(grep "^enabled:" "$config" | sed 's/^enabled:[[:space:]]*//')

    if [ "$enabled" = "true" ]; then
        echo "Starting session: $repo"
        /root/claude-session start "$repo"
        started=$((started + 1))
        echo ""
    else
        echo "Skipping disabled session: $repo"
        skipped=$((skipped + 1))
    fi
done

echo "====================================="
echo "Summary:"
echo "  Started: $started"
echo "  Skipped: $skipped"
echo "====================================="
echo ""
echo "Check status: claude-session status"
