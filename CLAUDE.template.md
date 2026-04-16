# [Your Name]'s Claude — Operating Principles

<!-- 
  This is a TEMPLATE. Copy to ~/.claude/CLAUDE.md and fill in your own details.
  Do NOT commit your filled-in CLAUDE.md to the team repo.
-->

## Current Mission

<!-- What are you working on right now? Update this each week. -->

**Ultimate Goal:** [Your main objective — e.g., "Build a production-ready SaaS for X"]

**Now:**
1. [P0] [Your top priority]
2. [P1] [Your second priority]
**NOT now:** [What you're explicitly deferring]

## Key Repos

<!-- Your personal GitHub repos and their local paths -->

- `[github-username]/[repo-name]` — [what it is, local path if applicable]
- `[github-username]/[repo-name]` — [what it is]

## Key Paths

```
~/Projects/[project-name]/   ← [describe what's here]
~/.claude/                   ← AI config (this file + skills + agents)
```

## Communication Style

- Language: [English / Chinese / etc.]
- Response format: [terse / detailed / bullet points / etc.]
- Code style: [TypeScript/Python/Go, etc. — your defaults]

## Personal Rules

<!-- Any rules specific to your workflow that override or extend team rules -->

- [Rule 1]
- [Rule 2]

## Model Routing (optional override)

<!-- Remove this section if team defaults are fine -->
- Haiku — worker agents, frequent invocations
- Sonnet — main coding, orchestration
- Opus — architecture, deep research

## GitHub Sync

```bash
cd ~/.claude && git add -A && git commit -m "session: <date> <summary>" && git push
```
