# Agent Orchestration

## Five Pillars (Required for Any Agent System)

| Pillar | Question | Must Have |
|--------|----------|-----------|
| Agent Structure | WHO does it | Roles, responsibilities, scopes, review relationships |
| Goal Structure | WHY/WHAT | Objective hierarchy, SMART goals, strategy map |
| Process Structure | HOW | SOP, decision trees, workflows |
| Tool Structure | WITH WHAT | Chrome DevTools, GitHub, Figma, APIs, CLIs |
| Knowledge Base | FROM WHAT | Research findings, PRD, artifacts, prior outputs |

Missing any one pillar causes agent system failure.

## Agent Definition Template

Every agent needs:
- **Role** — what are you
- **Scope** — what you do and DON'T do
- **SOP** — your step-by-step process
- **Tools** — what you have access to
- **Input** — what you receive
- **Output** — what you deliver
- **Review by** — who checks your work (NEVER self-review)

## Circular Loop Anti-Idle Pattern

```
Agent A → B → C → D → E → A → B → ...
Exit when: all agents report "no new feedback" in one full cycle
```

Each agent always has new input (previous agent's output from last round). This prevents the #1 problem: agents finishing and going idle.

## Parallel Dispatch

ALWAYS use parallel agent execution for independent operations. Never run sequentially when tasks have no data dependencies.

## Why/What/How Gap

Human communicates What. Agent fills in its own Why and How — usually wrongly.

**Solution:**
1. Don't try to communicate better — the gap is structural
2. Give SMART Goals (measurable result, not process description)
3. Let agent discover How through trial and error
4. Success path = SOP for next time

## Four Exploration Routes

- **A. Pressure test** — give goal, let agent run until success (cheapest, fastest)
- **B. Multi-agent loop** — agents review each other, circular feedback (best quality)
- **C. Blind run** — zero SOP, success path becomes SOP (most creative)
- **D. Replicate human workflow** — safest but slowest and most expensive
