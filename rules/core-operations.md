# Core Operations

## Browser Operations

When any task involves browsing websites, follow this priority:

1. **opencli** (first choice) — uses user's existing Chrome login session, zero friction
2. **`open -a "Google Chrome" <url>`** (fallback) — opens URL in user's Chrome directly
3. **Chrome DevTools MCP** (when programmatic reading needed) — connects to user's Chrome via CDP
4. **Playwright** (last resort) — only when a fresh browser instance is truly required

**Why this order matters:**
- User can watch the agent operate in real-time on their own Chrome
- User's Chrome already has all site logins (X, GitHub, Zhihu, Bilibili, etc.)
- Separate browser instances are invisible to the user — no learning opportunity

**Never** launch a separate browser instance when the user's existing Chrome can accomplish the task.

## GitHub Sync

All configuration is backed up to `github.com/Goldentrii/claude` (private).

- **Pull at session start:** `cd ~/.claude && git pull`
- **Push after changes:** `cd ~/.claude && git add -A && git commit -m "..." && git push`
- Memory, journals, rules, skills, agents, commands, settings — all synced.

## Information Research Priority

1. GitHub (`gh search repos`, `gh search code`) — existing implementations
2. Official docs (Context7 MCP or vendor docs) — API behavior, version-specific
3. Exa / web search — broader discovery when the first two are insufficient
4. Package registries (npm, PyPI) — before writing utility code
