# Performance Optimization — Annotated

<!--
  This is the REAL rule file used in production, with annotations
  explaining WHY each decision exists and what failure modes it addresses.
  The actual rule file (without annotations) is at ../rules/performance.md
-->

> [!NOTE]
> **Why this file exists:**
> Running all agent tasks on the most powerful model feels safe but is wasteful and slow. Running everything on the cheapest model is fast but produces shallow output on complex tasks. Without explicit routing rules, agents default to whatever the system configured — usually the same model for everything.
>
> This file defines when to use which model based on task characteristics, and how to manage the other main cost driver: context window size.

---

## Model Selection Strategy

> [!NOTE]
> **Why three tiers, not one:**
> The cost difference between tiers is large: Haiku is roughly 15-20x cheaper than Opus per token. For a simple file read, paying Opus prices is pure waste. For an architecture decision that will affect six months of work, skimping on reasoning quality is false economy.
>
> The tiers reflect a real tradeoff: cost vs. reasoning depth. Map your tasks to tiers based on how much they'd cost if the agent gets it wrong.
>
> **The key insight for multi-agent systems:**
> Worker agents in loops run many times. A loop that runs 20 iterations with Opus costs 20x a single Opus call. The same loop with Haiku workers costs almost nothing. Use Haiku for everything that runs frequently; use Opus only for decisions you make once.

**Haiku 4.5** (fastest, cheapest — 90% of Sonnet capability for most tasks):
- High-frequency tasks: reading files, searching, simple transforms
- Worker agents in loops — agents called repeatedly
- Pair programming and inline suggestions
- Any task where being wrong has low cost

**Sonnet 4.6** (best daily driver — best coding model available):
- Main coding work
- Orchestrating multi-agent workflows
- Complex implementation across multiple files
- Most conversations with the agent

**Opus 4.5** (deepest reasoning — use sparingly):
- Architecture decisions that are hard to reverse
- Research synthesis where nuance matters
- Reviewing critical systems (security, data integrity)
- Anything where shallow reasoning would be costly

---

## Context Window Management

> [!NOTE]
> **Why context window management matters:**
> AI agents degrade in quality as the context window fills up. In the last 20% of the context window, agents become inconsistent: they may forget earlier constraints, repeat themselves, or make decisions that contradict earlier reasoning.
>
> **Practical rule:** If a task requires reading many files, spanning many tools, or running for a long time — start it in a fresh session with only the necessary context loaded. Don't try to add it on top of an already-long conversation.
>
> **Why some tasks are context-insensitive:**
> A single-file edit requires only that file. An independent utility function requires only its spec. These tasks don't accumulate context and can run at any point in a conversation safely.

Avoid the last 20% of context window for:
- Large-scale refactoring (reads many files, makes many decisions)
- Feature implementation spanning multiple files
- Debugging complex, interconnected systems

These tasks are lower context sensitivity (safe to run anywhere):
- Single-file edits
- Independent utility creation
- Documentation updates
- Simple bug fixes with clear scope

---

## Extended Thinking + Plan Mode

> [!NOTE]
> **Why extended thinking:**
> Extended thinking reserves tokens for the agent's internal reasoning — working through a problem step by step before writing a response. Without it, the agent jumps to the first plausible answer. With it, the agent considers multiple approaches, finds edge cases, and arrives at more reliable conclusions.
>
> **When to enable it:**
> Extended thinking has a cost: it uses more tokens and takes longer. The tradeoff is worth it for complex, consequential decisions. It's wasteful for simple, reversible tasks.
>
> **Why Plan Mode for complex tasks specifically:**
> Plan Mode forces the agent to show its plan before executing, giving you a checkpoint to catch wrong assumptions before they turn into wrong code. It's the difference between "I'll do X, Y, Z — approve?" and having the agent silently do X, Y, Z and present you with a fait accompli.

Extended thinking is on by default (reserves up to 31,999 tokens for internal reasoning).

Controls:
- **Toggle:** Option+T (macOS) / Alt+T (Windows/Linux)
- **Budget cap:** `export MAX_THINKING_TOKENS=10000` (reduce for simple tasks)
- **Verbose mode:** Ctrl+O to see the reasoning

Use extended thinking + Plan Mode together when:
1. The task has multiple valid approaches and choosing wrong is expensive
2. You want to review the plan before execution starts
3. The task spans multiple systems or has non-obvious dependencies

---

## Build Troubleshooting

> [!NOTE]
> **Why a dedicated build-error-resolver agent:**
> Build errors are a specific category of problem: they have structured error messages, follow known patterns, and benefit from methodical diagnosis. A general-purpose agent will often try "smart" fixes that introduce new problems. The build-error-resolver agent is trained specifically on error patterns and fixes incrementally — one error at a time, verifying after each fix.
>
> **Why "fix incrementally, verify after each fix":**
> Build errors often have cascading dependencies. Fix the root error → re-run → find next error → fix → re-run. Trying to fix all visible errors at once often introduces new errors because each fix changes the context for the others.

When build fails:
1. Use **build-error-resolver** agent (not a general agent)
2. Read the full error message — the root cause is usually in the middle, not at the top
3. Fix one error, verify, then proceed to next
4. If errors cascade (fixing one reveals three more), stop and find the root cause
