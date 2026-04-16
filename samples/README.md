# Samples & Explanations

These are real production files, adapted from a working setup, with inline annotations explaining **why** each section is written the way it is.

Read these before writing your own `CLAUDE.md` and rules. The annotations answer the "why would I write that?" questions that templates can't answer.

---

## Files

| File | What it is |
|---|---|
| [`CLAUDE.sample.md`](./CLAUDE.sample.md) | A real CLAUDE.md — structure, filled-in examples, and WHY annotations for every section |
| [`rules/agent-orchestration.annotated.md`](./rules/agent-orchestration.annotated.md) | Five Pillars, agent definitions, circular loops, parallel dispatch — with failure-mode explanations |
| [`rules/development-workflow.annotated.md`](./rules/development-workflow.annotated.md) | Research → Plan → TDD → Review → Commit — why each step is mandatory |
| [`rules/performance.annotated.md`](./rules/performance.annotated.md) | Model routing, context window management, extended thinking — why these decisions save money and improve quality |

---

## How to Use These

1. **Read `CLAUDE.sample.md` first** — understand the structure and the reasoning before writing your own
2. **Copy sections you need** into your `~/.claude/CLAUDE.md`
3. **Replace the content** with your real projects, tools, and preferences
4. **Read the annotated rules** to understand why the team rules are written as they are — this helps you adapt them to your context rather than just copying blindly

---

## The One Thing That Matters Most

Your `CLAUDE.md` is not a settings file. It's a briefing document. Write it as if you're briefing a smart new team member who:
- Knows how to code
- Has never met you
- Starts every morning with no memory of yesterday
- Will follow your instructions literally

The more context you give, the less the agent has to guess. Guesses are usually wrong.
