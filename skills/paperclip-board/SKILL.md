---
name: paperclip-board
description: >
  Use this skill when operating the Paperclip AI agent orchestration platform as a board operator.
  Triggers: "check what agents are doing", "create an issue in Paperclip", "assign a task to CEO",
  "resume / pause the Founding Engineer", "comment on NOV-XX", "look at the Paperclip dashboard",
  "what's happening with the agents", "trigger a heartbeat", "add a skill to Paperclip",
  "unblock the engineer", "read the latest agent runs", "create a sub-issue".
  Do NOT use for domain work (website building, coding) — use the genome/bb-browser skills for that.
---

# Paperclip Board Operator Skill

You are the **board operator** — the human's proxy. You have full authority to:
- Read dashboard state and agent runs
- Create, assign, comment on, and close issues
- Pause and resume agents
- Trigger manual heartbeats
- Add skills to agents
- Review and approve agent actions

---

## Step 0 — Connect to Paperclip

Paperclip runs locally. Before anything else:

```
mcp__chrome-devtools__list_pages
```

Find the page at `127.0.0.1:3102`. If not open, navigate there:

```
mcp__chrome-devtools__navigate_page → http://127.0.0.1:3102/NOV/dashboard
```

> The browser already has the board session. All `fetch()` calls from this tab are pre-authenticated.

---

## Step 1 — Read State (Before Any Action)

Always read current state before acting. Fastest method:

```javascript
// Run via mcp__chrome-devtools__evaluate_script
() => document.querySelector('main').innerText
```

Or navigate directly and use `evaluate_script` on any page.

---

## Core Operations

### READ: Dashboard Overview

```
navigate → http://127.0.0.1:3102/NOV/dashboard
evaluate_script → () => document.querySelector('main').innerText
```

Returns: live agent activity, KPIs (agents/tasks/spend/approvals), recent activity.

---

### READ: List All Issues

```
navigate → http://127.0.0.1:3102/NOV/issues
evaluate_script → () => document.querySelector('main').innerText
```

Or use the API (runs in browser context, auto-authenticated):

```javascript
async () => {
  const r = await fetch('/api/companies/NOV/issues');
  // Note: use actual companyId UUID, not "NOV". Get it from:
  const me = await fetch('/api/session').then(r => r.json());
  return me;
}
```

Shortcut: navigate directly to the issue URL pattern:
```
http://127.0.0.1:3102/NOV/issues/NOV-{number}
```

---

### READ: Agent Status

```
navigate → http://127.0.0.1:3102/NOV/agents/{slug}/dashboard
```

Where `{slug}` is: `ceo`, `code-reviewer`, or `founding-engineer`

Check the status badge: `idle` | `running` | `paused` | `error`

---

### READ: Agent Runs (What Did an Agent Just Do?)

```
navigate → http://127.0.0.1:3102/NOV/agents/{slug}/runs
evaluate_script → () => document.querySelector('main').innerText
```

Each run shows: hash, type (Timer/Assignment/Automation), status, token count, summary.

---

### WRITE: Create an Issue

**Method A — Via UI (simplest):**
```
navigate → http://127.0.0.1:3102/NOV/issues
take_snapshot → find uid for "+ New Issue" button
click uid → fill fields → submit
```

**Method B — Via fetch() in browser (fastest for bulk):**
```javascript
async () => {
  // Get companyId first
  const companies = await fetch('/api/companies').then(r => r.json());
  const companyId = companies[0].id; // or find by name "Novatong"

  const issue = await fetch(`/api/companies/${companyId}/issues`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      title: 'Your issue title',
      description: 'Optional description',
      status: 'todo',
      priority: 'high',
      // assigneeAgentId: 'agent-uuid',  // optional
      // parentId: 'parent-issue-uuid',  // optional, for sub-tasks
      // goalId: 'goal-uuid',            // optional
    })
  }).then(r => r.json());

  return issue.identifier; // e.g. "NOV-32"
}
```

---

### WRITE: Assign Issue to an Agent

```javascript
async () => {
  // Get agent ID first
  const agents = await fetch('/api/companies/{companyId}/agents').then(r => r.json());
  const ceo = agents.find(a => a.name === 'CEO');

  // Assign
  await fetch('/api/issues/{issueId}', {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ assigneeAgentId: ceo.id })
  });
  return 'assigned';
}
```

Or use "+ Assign Task" button on the agent's dashboard page.

---

### WRITE: Comment on an Issue

**Via UI:**
```
navigate → http://127.0.0.1:3102/NOV/issues/NOV-{number}
take_snapshot → find comment box uid
fill comment text → click submit
```

**Via fetch():**
```javascript
async () => {
  await fetch('/api/issues/{issueId}/comments', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      body: 'Your comment here. @CEO please proceed with Phase 1.',
      // @-mentioning an agent name triggers their heartbeat immediately
    })
  });
  return 'commented';
}
```

> **Tip:** @-mentioning an agent in a comment triggers their heartbeat immediately. Use sparingly — it costs budget.

---

### WRITE: Pause an Agent

```
navigate → http://127.0.0.1:3102/NOV/agents/{slug}/dashboard
take_snapshot → find uid for "Pause" button
click uid
```

Or via fetch():
```javascript
async () => {
  await fetch('/api/agents/{agentId}/pause', { method: 'POST' });
  return 'paused';
}
```

---

### WRITE: Resume an Agent

```
navigate → http://127.0.0.1:3102/NOV/agents/{slug}/dashboard
take_snapshot → find uid for "Resume" button
click uid
```

Or via fetch():
```javascript
async () => {
  await fetch('/api/agents/{agentId}/resume', { method: 'POST' });
  return 'resumed';
}
```

---

### WRITE: Trigger Manual Heartbeat

```
navigate → http://127.0.0.1:3102/NOV/agents/{slug}/dashboard
take_snapshot → find uid for "Run Heartbeat" button
click uid
```

Or via fetch():
```javascript
async () => {
  await fetch('/api/agents/{agentId}/heartbeat/invoke', { method: 'POST' });
  return 'heartbeat triggered';
}
```

---

### WRITE: Update Issue Status

```javascript
async () => {
  await fetch('/api/issues/{issueId}', {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ status: 'done' }) // todo | in_progress | done | cancelled | blocked
  });
}
```

---

### WRITE: Add a Skill to the Company

```
navigate → http://127.0.0.1:3102/NOV/skills
take_snapshot → find "+" add button uid OR the "Paste path..." input field
fill path → e.g. /Users/tongwu/.claude/skills/website-genome
click Add
```

---

## Getting IDs (Company, Agent, Issue)

The UI uses UUIDs internally. Two ways to get them:

**From URL:** Navigate to any agent/issue/project page and read the UUID from the URL.

**From fetch():**
```javascript
// Get company ID
async () => {
  const r = await fetch('/api/companies').then(r => r.json());
  return r.map(c => ({ name: c.name, id: c.id }));
}

// Get agent IDs
async () => {
  const companies = await fetch('/api/companies').then(r => r.json());
  const companyId = companies[0].id;
  const agents = await fetch(`/api/companies/${companyId}/agents`).then(r => r.json());
  return agents.map(a => ({ name: a.name, id: a.id, status: a.status }));
}

// Get issue ID by identifier (e.g. NOV-24)
async () => {
  const companies = await fetch('/api/companies').then(r => r.json());
  const companyId = companies[0].id;
  const issues = await fetch(`/api/companies/${companyId}/issues`).then(r => r.json());
  return issues.find(i => i.identifier === 'NOV-24');
}
```

---

## URL Reference

| Page | URL |
|------|-----|
| Dashboard | `/NOV/dashboard` |
| Inbox | `/NOV/inbox/mine` |
| All Issues | `/NOV/issues` |
| Issue Detail | `/NOV/issues/NOV-{number}` |
| Routines | `/NOV/routines` |
| Goals | `/NOV/goals` |
| Projects | `/NOV/projects` |
| Org Chart | `/NOV/org` |
| Skills Library | `/NOV/skills` |
| Costs | `/NOV/costs` |
| Activity Log | `/NOV/activity` |
| CEO Agent | `/NOV/agents/ceo/{tab}` |
| Code Reviewer | `/NOV/agents/code-reviewer/{tab}` |
| Founding Engineer | `/NOV/agents/founding-engineer/{tab}` |
| Agent Tabs | `dashboard` \| `instructions` \| `skills` \| `configuration` \| `runs` \| `budget` |
| Instance Settings | `/instance/settings/{general\|heartbeats\|experimental\|plugins}` |
| Company Settings | `/NOV/company/settings` |

---

## Current Company: Novatong (NOV)

**Agents:**
| Name | Slug | Role | Heartbeat |
|------|------|------|-----------|
| CEO | `ceo` | Orchestrator | 3600s timer |
| Code Reviewer | `code-reviewer` | Verifier | 600s timer |
| Founding Engineer | `founding-engineer` | Builder | Assignment only |

**Active P0:** NOV-24 — Transform novada replica (85/100) to production SaaS
**Current blocker:** Founding Engineer is paused → resume to unblock implementation

**Key files (agents read these):**
```
/Users/tongwu/Projects/website-factory/paperclip/WORKSPACE.md   ← filesystem brain
/Users/tongwu/Projects/website-factory/paperclip/agents/        ← AGENTS/HEARTBEAT/SOUL/TOOLS
/Users/tongwu/Projects/website-factory/paperclip/knowledge/     ← accumulated lessons
/Users/tongwu/.claude/skills/website-genome/GENOME.md           ← website building playbook
```

---

## Skill Tool Reference

```
mcp__chrome-devtools__navigate_page   navigate to URL
mcp__chrome-devtools__take_screenshot take a screenshot (visual check)
mcp__chrome-devtools__take_snapshot   get a11y tree with element uids (use for clicking)
mcp__chrome-devtools__evaluate_script run JS in browser (read data, make API calls)
mcp__chrome-devtools__click           click element by uid from snapshot
mcp__chrome-devtools__fill            fill input by uid from snapshot
mcp__chrome-devtools__list_pages      list open Chrome tabs
```

> **Preferred pattern:** `navigate_page` → `evaluate_script` (get text) → `take_snapshot` (get uids) → `click`/`fill`

---

## References

- [Full Paperclip manual](~/.claude/projects/-Users-tongwu/memory/reference_paperclip_manual.md) — detailed context, issue state, agent configs
- [Paperclip docs](https://docs.paperclip.ing) — official documentation
- [API reference](https://docs.paperclip.ing/api/issues.md) — full endpoint list
