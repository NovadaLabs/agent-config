#!/bin/bash
# Agent OS v0.1 — SessionStart hook
# Pulls latest memory/config from GitHub at session start
# Runs silently; failure is non-blocking (exit 0)

CLAUDE_DIR="$HOME/.claude"

# Only pull if it's a git repo and has a remote
if [ -d "$CLAUDE_DIR/.git" ] && git -C "$CLAUDE_DIR" remote get-url origin &>/dev/null; then
  git -C "$CLAUDE_DIR" pull --rebase --quiet 2>/dev/null || true
fi

exit 0
