# Alex's Claude — Operating Principles

<!--
  ════════════════════════════════════════════════════════════
  THIS IS A REAL EXAMPLE — adapted from a production CLAUDE.md
  used daily by a NovadaLabs founder to run AI agent workflows.

  Use it as a reference. Copy the structure, replace the content
  with your own projects and preferences.

  Each section has a [WHY] note explaining the reasoning.
  ════════════════════════════════════════════════════════════
-->

> [!NOTE]
> **Why does this file exist?**
> Without `CLAUDE.md`, your AI agent has no persistent context. Every session starts cold — it doesn't know who you are, what you're building, what rules to follow, or what you've already decided. This file is the one place where you accumulate that context. Think of it as the "briefing document" you give a new employee on their first day — except this employee starts from zero every morning, so the briefing needs to be complete, not assumed.

---

## Current Mission

> [!NOTE]
> **Why "Current Mission" is the first section:**
> The agent reads this file top-to-bottom at the start of every session. The first thing it needs to know is what you're trying to accomplish RIGHT NOW — not in general, but this week. Without this, the agent defaults to generic helpful behavior instead of orienting everything toward your actual goal.
>
> **Why include "NOT now" and "Gate":**
> AI agents are eager to help with anything. Without explicit boundaries, they'll start suggesting Stripe integration, marketing copy, or other things you've consciously deferred. The "NOT now" list prevents scope creep. The "Gate" teaches the agent your decision logic so it can reason about tradeoffs the way you do.

**Ultimate Goal:** Build a B2B analytics platform — automated data pipeline from any source to a production-ready dashboard.

**Two capabilities:**
1. **Ingest** — User connects a data source → pipeline ingests, normalizes, and stores
2. **Visualize** — User describes a chart → agent generates the query + visualization code

**Knowledge Base:** `~/Projects/analytics-platform/docs/` — architecture diagrams, API specs, prior research

**Now:**
1. [P0] Data connector for PostgreSQL sources — target: 5 source types working
2. [P0] Chart generation from natural language — LLM → SQL → recharts component
3. [P1] Auth system — email + OAuth, no magic links yet
**NOT now:** Billing, white-labeling, mobile app, marketing site
**Gate:** Billing ONLY after chart generation is demo-ready end-to-end

---

## How This Project Works

> [!NOTE]
> **Why document the workflow in CLAUDE.md:**
> This is the section most people skip — and it's the most valuable one. If you have a specific process (e.g., always extract before building, always run tests before shipping), write it here explicitly. Otherwise the agent will invent its own process, which usually differs from what you actually want.
>
> The process section converts your tribal knowledge into agent-executable SOPs. Each line is a constraint that prevents a category of mistakes.

### Adding a new data connector:
1. Read `docs/connector-spec.md` — interface all connectors must implement
2. Check `src/connectors/` for existing patterns before writing new code
3. Process: Research source API → Write adapter → Write integration test → Add to registry

### Adding a new chart type:
1. Check `src/charts/` — reuse existing component patterns
2. Process: Define schema → Generate SQL template → Build component → Add to catalog

### Key paths:
- **Source code:** `~/Projects/analytics-platform/`
- **Connector registry:** `src/connectors/index.ts`
- **Chart catalog:** `src/charts/catalog.ts`
- **Docs:** `~/Projects/analytics-platform/docs/`

---

## Tools (Priority Order)

> [!NOTE]
> **Why list tools with priority order:**
> When multiple tools can accomplish the same task, the agent will pick one. Without explicit priority, it picks whatever feels natural to its training — which often means launching a fresh browser instead of using your logged-in one, or writing code from scratch instead of searching for existing implementations.
>
> Priority lists force the agent to exhaust better options first. The reasoning matters too: writing "because X" gives the agent enough context to make the right call in edge cases you didn't anticipate.

**For browser tasks:**
1. `bb-browser` (PRIMARY) — uses your real Chrome with existing logins. No auth setup needed.
2. `playwright-pro` (backup) — for public pages where login doesn't matter
3. Chrome DevTools MCP (backup) — when programmatic DOM inspection is needed

**Rule:** AI needs structured data (HTML, JSON), NOT screenshots. Screenshots are for human QA only.
**Rule:** Never open a fresh browser for pages that require login. Your Chrome already has sessions.

**For research:**
1. `gh search repos` / `gh search code` — find existing implementations first
2. Official docs via Context7 MCP — confirm API behavior, avoid guessing
3. Exa / web search — only when the first two are insufficient

**Rule:** Never build from scratch when an existing, tested implementation can be adapted.

---

## Daily Startup Protocol

> [!NOTE]
> **Why a startup protocol:**
> Without this, the agent starts each session by asking "what should I do?" or making assumptions. The startup protocol turns session-open into an automatic orientation: read the memory, check the journal, pull latest config, then report current state.
>
> This pattern is borrowed from how good managers brief themselves before a meeting — they review notes, check for updates, then walk in ready. Your agent should do the same.

1. Read `~/.claude/projects/memory/MEMORY.md` — load project context and past corrections
2. Read the latest journal entry — understand what happened in the last session
3. `cd ~/.claude && git pull` — sync latest config from team repo
4. Report: "I've reviewed [X]. Current priority is [Y]. Ready."

---

## Core Philosophy

> [!NOTE]
> **Why include philosophy, not just rules:**
> Rules cover cases you anticipated. Philosophy covers cases you didn't. When the agent hits an ambiguous situation — "should I refactor this while I'm here?" "should I add error handling for this edge case?" — rules won't cover it. Philosophy gives the agent a mental model for reasoning about tradeoffs the way you would.
>
> Each bullet here was added because the agent made a mistake that this principle would have prevented. They're not abstract values — they're scar tissue from real sessions.

- **Research before building** — `gh search`, official docs, then Exa. Never build from scratch when a solution exists. *Why: 80% of "new" code is reinventing something already on GitHub.*

- **Intelligent Distance** — The gap between what humans say and what they mean is structural, not a communication failure. When confused — ASK. A 5-second question beats 30 minutes of wrong work. *Why: Humans communicate in fragments and assume context. Agents fill gaps with guesses. The guess is usually wrong.*

- **Five Pillars** — Every agent task needs: WHO does it, WHY/WHAT the goal is, HOW the process works, WITH WHAT tools, FROM WHAT knowledge base. Missing any one causes failure. *Why: Agents given only a goal (WHAT) but no process (HOW) or tools (WITH WHAT) will invent both — usually incorrectly.*

- **Result over process** — Give SMART Goals (measurable outcomes), not step-by-step instructions. Let the agent discover the best path. Document what worked as SOP. *Why: Over-specified instructions make agents brittle. Under-specified instructions make them directionless. SMART Goals hit the right balance.*

- **Multi-agent > single agent** — Single agents have confirmation bias and poor self-review. Use cross-review by fresh agents with no prior context. *Why: An agent that writes code and then reviews its own code will approve almost anything. A fresh agent with no context finds real problems.*

- **Structurize input** — I communicate in scattered, non-linear bursts. Agent's job: collect all points, reorganize into structured actionable items, present back for confirmation before executing. Never assume A→B→C from fragmented input. *Why: This rule exists because the agent used to start executing immediately based on partial information, then had to redo work when the full picture emerged.*

---

## Model Routing

> [!NOTE]
> **Why explicit model routing:**
> By default, agents use the same model for everything. But different tasks have very different cost/quality tradeoffs. Using Opus for a simple file read is 15x more expensive than using Haiku. Using Haiku for a complex architectural decision produces shallow output.
>
> Model routing is a performance optimization that also improves quality by matching the tool to the job. Write this section based on your actual usage patterns — what tasks do you run frequently vs. rarely?

- **Haiku** — high-frequency, low-stakes: reading files, searching, simple transforms, worker agents in loops
- **Sonnet** — daily driver: coding, orchestration, complex implementation, most conversations
- **Opus** — rare, high-stakes: architecture decisions, research synthesis, reviewing critical systems

---

## Communication Style

> [!NOTE]
> **Why communication style matters:**
> Without this section, agents default to verbose, padded responses with lots of "Great! I'll now..." and trailing summaries. This adds noise and slows reading.
>
> More importantly, specify your language preference. If you work in Chinese but your codebase is in English, write that explicitly — otherwise the agent will pick one and stick with it regardless of context.

- **Language:** English for code and technical docs. Chinese for discussion and planning.
- **Responses:** Terse. No filler words. No trailing summaries — I can read the diff.
- **Output format:** File paths and command results, not verbal assurances. Show what was done, not what will be done.
- **When uncertain:** Ask one focused question. Don't ask five at once.

---

## GitHub Sync

> [!NOTE]
> **Why a GitHub sync section:**
> This makes config backup automatic and sharable. Without it, agent configurations exist only on one machine and get lost when you reinstall or switch computers. With it, every session's changes are committed and pushed — so your config grows over time and survives machine changes.
>
> The commit message format matters: `session: 2026-04-16 added chart types` is grep-able. `update` is not.

```bash
cd ~/.claude && git add -A && git commit -m "session: $(date +%Y-%m-%d) <brief summary>" && git push
```

---

## Key Repos

> [!NOTE]
> **Why list repos explicitly:**
> Agents often need to find files, run git commands, or cross-reference code. Without this list, they'll guess repo names or search your entire filesystem. With it, they navigate directly.
>
> Include the local path for repos you work in frequently. Include the GitHub URL for repos you reference but don't edit locally.

- `YOUR_ORG/analytics-platform` — main product (`~/Projects/analytics-platform/`)
- `YOUR_ORG/shared-ui` — component library (`~/Projects/shared-ui/`)
- `YOUR_ORG/claude` — this AI config, synced to GitHub
