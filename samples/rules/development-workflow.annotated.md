# Development Workflow — Annotated

<!--
  This is the REAL rule file used in production, with annotations
  explaining WHY each step exists and the failure modes it prevents.
  The actual rule file (without annotations) is at ../rules/development-workflow.md
-->

> [!NOTE]
> **Why this file exists:**
> Without an explicit development workflow, agents jump straight to writing code. This feels fast but produces worse outcomes: code gets written before the problem is understood, tests get skipped, and the same solutions get re-researched session after session.
>
> This workflow forces the agent to follow the same discipline a senior engineer would: understand the problem first, find existing solutions, plan before coding, test while coding, review before shipping.
>
> Each step here was made mandatory because agents skip it when left to their own judgment.

---

## Feature Implementation Workflow

### Step 0 — Research & Reuse *(mandatory before any new implementation)*

> [!NOTE]
> **Why research comes before everything else:**
> The default agent behavior is to start writing code immediately. This is almost always wrong. Most problems have existing solutions on GitHub — open source libraries, reference implementations, or projects that solved 80% of the same problem. Finding those takes 5 minutes. Writing from scratch takes hours and produces worse code.
>
> **Why the specific search order matters:**
> 1. GitHub first — existing code is always more reliable than docs (docs lie, code doesn't)
> 2. Official docs second — confirms API behavior for the specific version you're using
> 3. Exa last — broad web search has too much noise to use first
>
> **Why "prefer adopting over writing net-new":**
> Net-new code has no battle testing. A library used by 10,000 projects has had its edge cases found and fixed. Write net-new only when the existing options genuinely don't fit.

- **GitHub code search first:** `gh search repos` and `gh search code` — find existing implementations
- **Library docs second:** Context7 or vendor docs — confirm API behavior, version-specific details
- **Exa only when the first two are insufficient** — broader web research
- **Check package registries:** npm, PyPI, crates.io — before writing utility code
- **Search for adaptable implementations** — look for open-source that solves 80% of the problem

### Step 1 — Plan First

> [!NOTE]
> **Why plan before coding:**
> Agents that start coding immediately make architectural decisions by accident. They choose a data structure, a dependency, or an approach because it was convenient — not because it was right. Changing those decisions later is expensive.
>
> Planning forces the agent to think about the full system before touching any code. A 10-minute plan prevents 2 hours of refactoring.
>
> **Why generate actual planning docs (PRD, architecture, etc.) rather than just thinking:**
> Written plans can be reviewed. Thoughts in the agent's context window can't. If the plan is wrong, you want to catch it before implementation starts — not after.

- Use **planner** agent to create implementation plan
- Generate planning docs: PRD, architecture, system_design, tech_doc, task_list
- Identify dependencies and risks
- Break down into phases — don't try to implement everything at once

### Step 2 — TDD Approach

> [!NOTE]
> **Why test-driven development, specifically:**
> TDD (write tests first, then implementation) sounds backwards but produces better outcomes for agents specifically. Here's why:
>
> 1. **Tests define the contract precisely.** Writing a test first forces you to specify exactly what "done" looks like — in executable form. This prevents the agent from shipping code that's technically running but doesn't actually solve the problem.
>
> 2. **Tests catch agent hallucinations.** Agents sometimes write code that looks correct but doesn't work. Tests catch this immediately. Without tests, you're relying on the agent to self-verify — which doesn't work.
>
> 3. **Red-green-refactor creates a checkpoint system.** RED = tests written, failing (problem defined). GREEN = tests passing (problem solved). IMPROVE = code cleaned up without breaking tests. Each stage is verifiable.
>
> **Why 80% coverage:**
> 100% coverage is often impractical and the last 20% has diminishing returns. 80% is achievable and catches the vast majority of regressions.

- Use **tdd-guide** agent
- Write tests first (RED) — define the contract before implementation
- Implement to pass tests (GREEN) — solve the problem you defined
- Refactor (IMPROVE) — clean up without breaking tests
- Verify 80%+ coverage

### Step 3 — Code Review

> [!NOTE]
> **Why use a separate code-reviewer agent (not the same agent that wrote the code):**
> Self-review is deeply unreliable for agents. The agent that wrote code already "believes" it's correct — it has context bias. A fresh agent with no prior context evaluates the code on its own merits and finds problems the author is blind to.
>
> This mirrors how good engineering teams work: the person who writes code cannot be the only reviewer.
>
> **Why address CRITICAL and HIGH immediately, MEDIUM when possible:**
> Not all issues are equal. CRITICAL issues (security vulnerabilities, data loss risks) must be fixed before shipping. HIGH issues (functional bugs, performance problems) should be fixed. MEDIUM issues (style, minor improvements) are worth fixing if easy, but shouldn't block shipping.
>
> This triage prevents the common failure mode of treating every linting warning as a blocker.

- Use **code-reviewer** agent — a fresh agent with no context from the implementation
- Address CRITICAL and HIGH issues (non-negotiable)
- Fix MEDIUM issues when practical

### Step 4 — Commit & Push

> [!NOTE]
> **Why conventional commits:**
> `feat:`, `fix:`, `refactor:`, `docs:`, `test:` prefixes make git history grep-able. Six months from now, `git log --grep="feat:" --since="2026-01-01"` tells you every new feature added this year. Without conventional commits, git history is noise.
>
> **Why detailed commit messages:**
> "fix bug" is useless. "fix: user session not persisting after OAuth callback — missing cookie SameSite attribute" is a searchable incident record. Write commit messages as if the future version of you will need to debug this without any other context.

- Detailed commit messages
- Follow conventional commits format: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`
- See `git-workflow.md` for full commit format and PR process
