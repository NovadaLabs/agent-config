# Agent Orchestration — Annotated

<!--
  This is the REAL rule file used in production, with annotations
  explaining WHY each concept exists and the failure modes that led to it.
  The actual rule file (without annotations) is at ../rules/agent-orchestration.md
-->

> [!NOTE]
> **Why this file exists:**
> Most people give AI agents tasks without thinking about system design. This works for simple, one-shot tasks. It fails completely for multi-step work, parallel tasks, or anything requiring quality review. This file captures the mental model for designing agent systems that actually complete complex work reliably.
>
> Every concept here was added because a simpler approach broke in a real project.

---

## Five Pillars (Required for Any Agent System)

> [!NOTE]
> **Why Five Pillars:**
> After running dozens of agent workflows, we found that failures always came from missing one of exactly five things. An agent with a clear goal but no tools would stall. An agent with tools but no process would thrash. An agent with everything but no knowledge base would re-research things already decided.
>
> The Five Pillars are a checklist for diagnosing why an agent system is failing. If your agent isn't working, find the missing pillar.

| Pillar | Question | Must Have |
|--------|----------|-----------|
| Agent Structure | WHO does it | Roles, responsibilities, scopes, review relationships |
| Goal Structure | WHY/WHAT | Objective hierarchy, SMART goals, strategy map |
| Process Structure | HOW | SOP, decision trees, workflows |
| Tool Structure | WITH WHAT | Chrome DevTools, GitHub, Figma, APIs, CLIs |
| Knowledge Base | FROM WHAT | Research findings, PRD, artifacts, prior outputs |

Missing any one pillar causes agent system failure.

---

## Agent Definition Template

> [!NOTE]
> **Why every agent needs a definition:**
> When you spawn a sub-agent (e.g., "review this code"), the agent starts with zero context. It doesn't know what role it's playing, what's in scope, or who reviews its output. Without an explicit definition, the agent invents all of these — usually too broadly ("I'll refactor everything while I'm here") or too narrowly ("I'll only check syntax").
>
> **Why "Review by" is in the template:**
> Self-review doesn't work. An agent that writes code and then reviews its own code has confirmation bias — it already believes the code is correct. Fresh agents with no prior context find real problems. NEVER let an agent review its own output for anything that matters.

Every agent needs:
- **Role** — what are you (e.g., "You are a code reviewer focused on security")
- **Scope** — what you do AND DON'T do (boundaries prevent scope creep)
- **SOP** — your step-by-step process (reduces hallucination on process questions)
- **Tools** — what you have access to (prevents agents from trying unavailable tools)
- **Input** — what you receive (format + source)
- **Output** — what you deliver (format + destination)
- **Review by** — who checks your work (NEVER self-review)

**Example definition:**
```
Role: Security reviewer
Scope: Review authentication and data handling code. Do NOT refactor, add features, or change logic.
SOP: 1) Check for hardcoded credentials 2) Check input validation 3) Check auth flows 4) Report findings
Tools: Read, Grep, Bash (read-only)
Input: PR diff or file list from orchestrator
Output: Report with CRITICAL/HIGH/MEDIUM/LOW findings
Review by: Human (security decisions require human sign-off)
```

---

## Circular Loop Anti-Idle Pattern

> [!NOTE]
> **Why this pattern:**
> The #1 failure mode in multi-agent systems is agents going idle. Agent A finishes, hands off to Agent B. Agent B finishes, reports "done" — and then nothing happens. The loop stops.
>
> The circular loop pattern prevents this by ensuring every agent always has input from the previous cycle. There's no "done" state until ALL agents report no new feedback in the same cycle. This is how real peer review works: keep passing the document around until nobody has new notes.

```
Agent A → B → C → D → E → A → B → ...
Exit when: all agents report "no new feedback" in one full cycle
```

Each agent always has new input (previous agent's output from last round). This prevents the #1 problem: agents finishing and going idle.

**Practical example:**
```
Cycle 1: Writer → Editor → Fact-checker → Writer (with notes from editor + fact-checker)
Cycle 2: Writer → Editor → Fact-checker → Writer
Cycle 3: All three report "no new changes" → done
```

---

## Parallel Dispatch

> [!NOTE]
> **Why parallel dispatch:**
> Sequential execution of independent tasks is the biggest avoidable time waste in agent workflows. If you have three independent research tasks, running them one-by-one takes 3x longer than running them simultaneously. The agent has no reason to serialize them — it's just the default behavior.
>
> The rule "ALWAYS parallel when no data dependency" forces the agent to think about what can run simultaneously. The test: "Does Task B need the output of Task A to start?" If no → run in parallel.

ALWAYS use parallel agent execution for independent operations. Never run sequentially when tasks have no data dependencies.

**Test:** Before dispatching tasks, ask: does Task B need output from Task A? If no → run both at once.

---

## Why/What/How Gap

> [!NOTE]
> **Why this section exists:**
> This is the most important conceptual insight in this entire file. Humans communicate WHAT they want. They rarely explain WHY they want it or HOW they want it done. Agents fill in the missing Why and How from their training — which almost never matches what the human actually intended.
>
> The classic failure: Human says "add error handling." Agent adds try/catch everywhere, including places where errors should propagate. Human meant "add error handling to the user-facing form inputs." The agent filled in its own How — incorrectly.
>
> **The solution is not better communication.** You cannot specify everything. The gap is structural. The solution is SMART Goals: measurable outcomes that let the agent figure out How through trial and error, and let you evaluate whether the result matches your intent.

Human communicates What. Agent fills in its own Why and How — usually wrongly.

**The gap is structural, not a communication failure.** Humans always underspecify. Agents always overfill.

**Solution:**
1. Don't try to specify everything — you can't
2. Give SMART Goals (measurable result, not process description)
3. Let agent discover How through trial and error
4. Correct mistakes explicitly — those corrections become your SOP

**Bad goal (process description):** "Search GitHub, then read the docs, then write a plan, then implement"
**Good goal (SMART):** "Implement OAuth login. Working: user can log in with Google, session persists across page refresh. Tests pass."

---

## Four Exploration Routes

> [!NOTE]
> **Why four routes, not one:**
> Different situations call for different agent strategies. Using an expensive multi-agent loop for a simple task wastes time and money. Using a blind run for a safety-critical task is reckless.
>
> These four routes are ordered by speed (A=fastest) and by quality (B=highest). Choose based on your actual situation:
> - You know the goal but not the path → Route A (pressure test)
> - Quality matters more than speed → Route B (multi-agent loop)
> - You want to discover the best approach → Route C (blind run)
> - Risk of mistakes is very high → Route D (replicate human workflow)

- **A. Pressure test** — give goal, let agent run until success (cheapest, fastest). Use when: you trust the agent to figure it out.
- **B. Multi-agent loop** — agents review each other, circular feedback (best quality). Use when: the output must be high quality.
- **C. Blind run** — zero SOP, success path becomes SOP (most creative). Use when: you want to discover the best approach.
- **D. Replicate human workflow** — safest but slowest and most expensive. Use when: errors are costly and the human workflow is well-understood.
