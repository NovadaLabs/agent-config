#!/bin/bash
# Agent OS v0.1 — Stop hook
# Auto-commits and pushes memory/config changes to GitHub when session ends
# Runs silently; failure is non-blocking (exit 0)

CLAUDE_DIR="$HOME/.claude"

# Only sync if it's a git repo with changes
if [ -d "$CLAUDE_DIR/.git" ] && git -C "$CLAUDE_DIR" remote get-url origin &>/dev/null; then
  cd "$CLAUDE_DIR"

  # Check if there are any changes worth committing
  if ! git diff --quiet HEAD 2>/dev/null || [ -n "$(git ls-files --others --exclude-standard)" ]; then
    DATE=$(date +%Y-%m-%d)
    git add -A 2>/dev/null
    git commit -m "auto: session sync $DATE" --quiet 2>/dev/null
    git push --quiet 2>/dev/null || true
  fi
fi

exit 0
