# NovadaLabs AI Configuration

🌍 **Language:** [English](README.md) · [中文](README.zh.md) · [Português](README.pt-BR.md)

---

> A shared AI agent configuration system for NovadaLabs. Fork this repo, apply your personal layer, and get a fully configured AI agent in minutes — whether you use Claude Code, Codex, or another agent runtime.

---

## Table of Contents

- [What This Is](#what-this-is)
- [Architecture: Three Layers](#architecture-three-layers)
- [Prerequisites](#prerequisites)
- [Quick Start — Fork & Install](#quick-start--fork--install)
- [Folder Structure](#folder-structure)
- [Skills Catalog](#skills-catalog)
- [Agent Definitions](#agent-definitions)
- [Rules & Principles](#rules--principles)
- [AgentRecall Setup](#agentrecall-setup)
- [Multi-Agent Guide](#multi-agent-guide)
- [Personal Customization](#personal-customization)
- [Platform Notes](#platform-notes)
- [Contributing](#contributing)

---

## What This Is

This repo is the **shared configuration layer** for NovadaLabs AI agents. It contains:

- **95 skills** — reusable instructions for specific tasks (research, coding, deployment, etc.)
- **Agent definitions** — specialized agents for code review, planning, TDD, security, and more
- **Rules** — team-wide principles for development workflow, git, performance, and security
- **Hooks** — automation that runs at session start/stop and on tool use
- **AgentRecall** — persistent memory system that gives agents context across sessions

**What it is NOT:** This repo does not contain personal memory, credentials, journal entries, or project-specific context. Those live in your personal layer (explained below).

---

## Architecture: Three Layers

```
┌─────────────────────────────────────────┐
│  Layer 3: Project Context               │  ← Per-project CLAUDE.md, notes
├─────────────────────────────────────────┤
│  Layer 2: Personal Layer                │  ← Your CLAUDE.md, memory/, journal/
├─────────────────────────────────────────┤
│  Layer 1: Team Shared (this repo)       │  ← skills/, agents/, rules/, hooks/
└─────────────────────────────────────────┘
```

- **Layer 1** (this repo) is shared. You get updates by pulling from the upstream team repo.
- **Layer 2** is yours alone. Your mission, your projects, your memory. Never commit this to the team repo.
- **Layer 3** is per-project. A `CLAUDE.md` file in the project root gives the agent project-specific context.

---

## Prerequisites

| Requirement | Version | Notes |
|---|---|---|
| Node.js | 20+ | Required for AgentRecall and hooks |
| Git | any | Required for syncing config |
| Claude Code | latest | Primary supported agent runtime |
| macOS | 14+ | Some tools (bb-browser, opencli) are Mac-only |

Other agent runtimes (Codex, Copilot CLI) are supported with minor differences — see [Multi-Agent Guide](#multi-agent-guide).

---

## Quick Start — Fork & Install

### Step 1 — Fork the repo

Go to `https://github.com/NovadaLabs/claude` and click **Fork** (top right).

> **Why fork?** Forking gives you your own copy. You can commit your personal layer (CLAUDE.md, memory/) to your fork without touching the team repo. When the team repo updates, you can pull those changes into your fork.

### Step 2 — Clone your fork

```bash
# Replace YOUR_USERNAME with your GitHub username
git clone https://github.com/YOUR_USERNAME/claude.git ~/.claude-team
```

### Step 3 — Install into your agent config directory

**Claude Code:**
```bash
# Back up your existing config first
cp -r ~/.claude ~/.claude-backup-$(date +%Y%m%d)

# Copy team skills, agents, rules, hooks
cp -r ~/.claude-team/skills ~/.claude/
cp -r ~/.claude-team/agents ~/.claude/
cp -r ~/.claude-team/rules ~/.claude/
cp -r ~/.claude-team/hooks ~/.claude/
```

**Codex / OpenAI:** See [Multi-Agent Guide](#multi-agent-guide).

### Step 4 — Set up the upstream remote (to receive team updates)

```bash
cd ~/.claude-team
git remote add upstream https://github.com/NovadaLabs/claude.git
```

To pull future team updates:
```bash
git fetch upstream
git merge upstream/main
```

### Step 5 — Create your personal CLAUDE.md

```bash
cp ~/.claude-team/CLAUDE.template.md ~/.claude/CLAUDE.md
```

Then edit `~/.claude/CLAUDE.md` with your own:
- Current mission and projects
- Key repos and paths
- Personal preferences

### Step 6 — Install AgentRecall

```bash
npm install -g @agent-recall/cli
```

Then add AgentRecall hooks to `~/.claude/settings.json` — see [AgentRecall Setup](#agentrecall-setup).

---

## Folder Structure

```
~/.claude/
├── CLAUDE.md                  ← Your personal instructions (NOT committed to team repo)
├── skills/                    ← 95 reusable skills (team-shared)
│   ├── agent-recall/          ← Memory system integration
│   ├── website-genome/        ← Website replication system
│   ├── deep-research/         ← Multi-source research
│   └── ...                    ← (see Skills Catalog)
├── agents/                    ← Specialized subagent definitions
│   ├── code-reviewer.md
│   ├── planner.md
│   └── ...
├── rules/                     ← Team principles and workflow rules
│   ├── development-workflow.md
│   ├── git-workflow.md
│   ├── agent-orchestration.md
│   └── ...
├── hooks/                     ← Automation scripts
│   ├── session-start-sync.sh
│   └── session-stop-sync.sh
├── memory/                    ← PERSONAL — not in team repo
│   ├── MEMORY.md              ← Index of all memories
│   └── journal/               ← Session journal
└── settings.json              ← Claude Code config (template version in team repo)
```

---

## Skills Catalog

Skills are reusable instruction sets for specific tasks. Invoke with the `Skill` tool in Claude Code.

### Agent & Orchestration
| Skill | Purpose |
|---|---|
| `agent-recall` | Persistent memory across sessions |
| `agent-browser` | Browser automation with user's Chrome |
| `agentic-engineering` | Multi-agent system design patterns |
| `autonomous-loops` | Self-running agent loops |
| `continuous-agent-loop` | Recurring agent workflows |
| `enterprise-agent-ops` | Production agent operations |
| `team-builder` | Build and configure agent teams |

### Development
| Skill | Purpose |
|---|---|
| `tdd-workflow` | Test-driven development (red/green/refactor) |
| `code-to-prd` | Convert code to product requirements |
| `api-design` | API design patterns and review |
| `backend-patterns` | Server-side architecture patterns |
| `frontend-patterns` | UI/UX implementation patterns |
| `database-migrations` | Safe DB migration strategies |
| `coding-standards` | Team code style enforcement |
| `bun-runtime` | Bun.js-specific patterns |
| `nextjs-turbopack` | Next.js + Turbopack setup |

### Research & Discovery
| Skill | Purpose |
|---|---|
| `deep-research` | Multi-source structured research |
| `market-research` | Competitive landscape analysis |
| `competitive-teardown` | Detailed competitor analysis |
| `exa-search` | Exa-powered web research |
| `iterative-retrieval` | Progressive search refinement |
| `research-summarizer` | Condense research into insights |
| `documentation-lookup` | Find official docs fast |

### Website & Content
| Skill | Purpose |
|---|---|
| `website-genome` | Full website replication system |
| `awwwards-landing-page` | Award-quality landing pages |
| `landing-page-generator` | Fast landing page scaffolding |
| `content-engine` | Structured content production |
| `article-writing` | Long-form article generation |
| `crosspost` | Multi-platform content publishing |

### Infrastructure & DevOps
| Skill | Purpose |
|---|---|
| `deployment-patterns` | CI/CD and deployment strategies |
| `docker-patterns` | Docker/container best practices |
| `postgres-patterns` | PostgreSQL optimization patterns |
| `mcp-server-patterns` | MCP server design and deployment |
| `eval-harness` | Evaluation framework setup |

### Security
| Skill | Purpose |
|---|---|
| `security-review` | Code security audit |
| `security-scan` | Automated vulnerability scanning |

### Product & Strategy
| Skill | Purpose |
|---|---|
| `product-discovery` | User research and problem framing |
| `product-strategist` | Strategic product decisions |
| `product-manager-toolkit` | PM workflow and artifacts |
| `investor-materials` | Pitch deck and investor docs |
| `roadmap-communicator` | Roadmap creation and communication |

### Testing & Quality
| Skill | Purpose |
|---|---|
| `e2e-testing` | End-to-end test setup and execution |
| `webapp-testing` | Web app QA patterns |
| `ai-regression-testing` | AI output regression testing |
| `verification-loop` | Multi-step verification patterns |
| `python-testing` | Python test patterns |

### Automation & Tools
| Skill | Purpose |
|---|---|
| `playwright-pro` | Advanced Playwright automation |
| `playwright-cli` | Playwright CLI usage |
| `opencli` | CLI tool for social/web actions |
| `tmux` | Terminal multiplexer workflows |
| `x-api` | X (Twitter) API integration |

> **Full list:** Run `/find-skills` in Claude Code to search and discover all skills.

---

## Agent Definitions

Specialized subagents in `agents/`. Claude Code loads these automatically.

| Agent | Purpose | When Used |
|---|---|---|
| `planner` | Implementation planning | Before starting complex features |
| `architect` | System design | Architectural decisions |
| `code-reviewer` | Code review | After writing any code |
| `tdd-guide` | Test-driven development | New features, bug fixes |
| `security-reviewer` | Security audit | Before commits, after auth changes |
| `build-error-resolver` | Fix build failures | When build fails |
| `e2e-runner` | E2E test execution | Critical user flows |
| `refactor-cleaner` | Dead code removal | Code maintenance |
| `doc-updater` | Documentation updates | After feature completion |
| `website-builder` | Autonomous site builder | Replication and build tasks |

---

## Rules & Principles

Rules in `rules/` are always-on team standards loaded into every session.

| File | Covers |
|---|---|
| `development-workflow.md` | Research → Plan → TDD → Review → Commit |
| `git-workflow.md` | Commit format, PR process |
| `agent-orchestration.md` | Multi-agent design patterns, Five Pillars |
| `core-operations.md` | Browser priority, GitHub sync |
| `performance.md` | Model selection, context window management |
| `security.md` | Security-first coding practices |
| `testing.md` | Test coverage requirements |
| `coding-style.md` | Code style guidelines |

---

## AgentRecall Setup

AgentRecall gives agents persistent memory across sessions — corrections, project context, user preferences.

**Install:**
```bash
npm install -g @agent-recall/cli
```

**Add hooks to `~/.claude/settings.json`:**
```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [{
          "type": "command",
          "command": "node $(which agentrecall) hook-start 2>/dev/null || true"
        }]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [{
          "type": "command",
          "command": "node $(which agentrecall) hook-correction 2>/dev/null || true"
        }]
      }
    ],
    "Stop": [
      {
        "hooks": [{
          "type": "command",
          "command": "node $(which agentrecall) hook-end 2>/dev/null || true"
        }]
      }
    ]
  }
}
```

**Verify:**
```bash
agentrecall status
```

AgentRecall stores memory in `~/.claude/projects/<project>/memory/` — this is personal and should not be committed to the team repo.

---

## Multi-Agent Guide

### Which file configures the agent?

| Agent Runtime | Config File | Skills Location |
|---|---|---|
| Claude Code | `~/.claude/CLAUDE.md` | `~/.claude/skills/` |
| OpenAI Codex | `AGENTS.md` (in project root) | `~/.codex/skills/` |
| GitHub Copilot CLI | `AGENTS.md` | N/A (no skill system) |
| Gemini CLI | `GEMINI.md` | Skills via `activate_skill` |

### Tool name mapping

Skills reference Claude Code tool names. If you use a different runtime, map accordingly:

| Claude Code | Codex | Copilot CLI | Gemini CLI |
|---|---|---|---|
| `Skill` tool | `skill` tool | N/A | `activate_skill` |
| `Agent` tool | subagent dispatch | N/A | N/A |
| `Read` tool | `read_file` | `read_file` | `read_file` |
| `Bash` tool | `shell` | `shell` | `shell` |

### Choosing your approach

**If you use Claude Code:** Follow the Quick Start exactly. All 95 skills work out of the box.

**If you use Codex:** Copy skills to `~/.codex/skills/`. Edit each skill file and replace Claude tool names using the mapping table above. The `AGENTS.md` file replaces `CLAUDE.md`.

**If you use both:** Keep `~/.claude/` for Claude Code and `~/.codex/` for Codex. Copy relevant skills to both locations.

---

## Personal Customization

**These files are yours — do not push them to the team repo:**

| File/Folder | What to put there |
|---|---|
| `~/.claude/CLAUDE.md` | Your mission, projects, personal rules, key paths |
| `~/.claude/memory/` | AgentRecall's memory (auto-managed) |
| `~/.claude/settings.local.json` | Personal API keys, local overrides |

**Template:** Copy `CLAUDE.template.md` and fill in:
- `## Current Mission` — what you're working on now
- `## Key Repos` — your GitHub repos and local paths
- `## Communication Style` — language preferences, response format

**Adding team skills from your personal work:** If you build a skill that the whole team would benefit from, submit a PR to the team repo. See [Contributing](#contributing).

---

## Platform Notes

**Mac-only tools:**
- `bb-browser` — connects to user's Chrome via AppleScript. Mac only.
- `opencli` — uses macOS Chrome profile. Mac only.

**Node.js required:**
- AgentRecall hooks require Node.js 20+
- Session sync hooks require Node.js

**Windows/Linux users:**
- Skills work fully (they're Markdown instruction files)
- Agent definitions work fully
- Replace `bb-browser` with `playwright-pro` for browser automation
- Replace `opencli` with direct API calls

---

## Contributing

1. Fork the team repo (`NovadaLabs/claude`)
2. Create a branch: `git checkout -b skill/my-new-skill`
3. Add your skill to `skills/my-new-skill/` with a `skill.md` file
4. Test it: invoke it in a Claude Code session, verify it works as expected
5. Submit a PR with: what the skill does, when to use it, example invocation

**Skill file format:**
```markdown
---
name: my-skill-name
description: One-line description for skill discovery
---

# My Skill

## When to use
...

## Steps
...
```

---

*Maintained by NovadaLabs. Built on [Superpowers](https://github.com/superpowers) harness.*
