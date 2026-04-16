# Website Genome OS v3.2

> Agent operating system for building or replicating any website.
> This file is the MAP. Reference files in `genome/v1/` are the ENCYCLOPEDIA.
> Read this file. Read reference files ON DEMAND when a step says to.
>
> QUALITY SYSTEM, not checklist. "I did something" != "I did it completely."
> Every line exists because an agent failed without it.

---

## STEP 0: CHROME (BLOCKING)

```
The human's Chrome must be running with login sessions accessible.
Without this, auth-gated extraction is impossible.

Human runs:  cd ~/Projects/novada-replicate && npm run launch-chrome
Agent runs:  bb-browser open <any-url>
  → Works? → proceed
  → Fails? → STOP. Tell human to launch Chrome. Do not proceed.

MULTI-AGENT: Each agent opens its OWN TAB. Never share tabs.
```

**Why this is Step 0:** Three separate agents tried to skip Chrome setup. All failed on auth-gated pages. This is the single human action required per site.

---

## STEP 0.5: MISSION ROUTING

```
┌─────────────────────────────────────────────┐
│  Existing replica to fix?                   │
│  ├── YES → §FIX                             │
│  └── NO                                     │
│       URL to replicate?                     │
│       ├── YES → §COPY                       │
│       └── NO  → §BUILD                      │
└─────────────────────────────────────────────┘

SCALING:
  < 10 pages  → single agent, fully autonomous
  10-50 pages → single agent, phase commits
  50+ pages   → orchestrator plans + fresh agents execute
    WHY: orchestrators that also execute always cut corners.
    Context fatigue after hours of planning degrades build quality.

QUESTION POLICY:
  Ask ONLY for irreversible decisions (architecture, auth provider, data model).
  Default silently for: colors, spacing, copy, icons.
```

---

## TOOLS

```
EXTRACTION:
  bb-browser       PRIMARY — interactive (hover, click, auth-gated pages)
  site-crawler     BULK — automated crawl (100+ pages, assets, screenshots)
  Chrome CDP       BACKUP — programmatic batch extraction
  Playwright       BACKUP — public pages only, headless
  gstack           QA — responsive testing at 375/768/1440

BUILD STACK:
  Next.js 16 + shadcn/ui + Tailwind 4 + Geist + Vercel
  Versions: genome/v1/VERSION.md

RULES:
  AI needs structured data (HTML, a11y tree, CSS), NOT screenshots.
  Auth-gated pages → bb-browser (user's Chrome). Never a fresh browser.
  Screenshots = human QA only, never primary extraction artifact.
```

---

## §COPY — Replicate a website from URL

### Step 1: CONNECT

```
bb-browser open <target-url>
GATE: Can you see the page? Auth-gated pages accessible?
  → No? Ask human to log in, retry.
```

### Step 1.5: DETECT TECH STACK

```
Before extraction, identify what the target site uses.
This determines build choices — replica uses SAME stack as original.

DETECTION CHECKLIST:
  Framework:
    □ __NEXT_DATA__ in page source → Next.js (check version in script tags)
    □ ng-version attribute → Angular
    □ data-v- attributes → Vue
    □ _app.js, _document.js → Next.js Pages Router
    □ No framework markers → static HTML or custom

  CSS:
    □ Class patterns "flex bg-* text-*" → Tailwind
    □ Class patterns "col-md-* btn-*" → Bootstrap
    □ Styled-components, CSS modules → check <style> tags

  Auth:
    □ clerk.js / __clerk cookies → Clerk
    □ next-auth cookies → NextAuth
    □ auth0.js → Auth0
    □ supabase-auth cookies → Supabase Auth
    □ No auth scripts → custom or none

  Payment:
    □ stripe.js / Stripe elements → Stripe
    □ paddle.js → Paddle
    □ No payment scripts → none detected

  Analytics:
    □ gtag.js → Google Analytics
    □ plausible.js → Plausible
    □ posthog-js → PostHog

  Other:
    □ sentry.js → Sentry (monitoring)
    □ intercom widget → Intercom (support)
    □ algolia → Algolia (search)

Output: specs/tech-stack.json
  {
    "framework": "Next.js 16",
    "css": "Tailwind CSS v4",
    "auth": "Clerk",
    "payment": "Stripe",
    "analytics": "PostHog",
    "monitoring": "Sentry",
    "other": ["Intercom"]
  }

GATE: tech-stack.json exists with at least framework + css identified.
```

**Why:** Builder uses the SAME tech stack as original. If original uses Clerk → replica uses Clerk. Wrong tech stack = different behavior.

### Step 2: DISCOVER ALL PAGES

```
site-crawler <url> --output specs/public --max-pages 200
bb-browser: navigate sidebar, click every link, collect all paths
Classify: INTERNAL (replicate) / PRODUCT-SUBDOMAIN (replicate) / EXTERNAL (keep)

DASHBOARD FIRST: Auth-gated pages are the product. Marketing is the wrapper.
Extract dashboard BEFORE marketing pages — it has the most depth.

Output: specs/sitemap.json
GATE: discovered pages >= what you see in navigation?
```

### Step 3: EXTRACT — The 8 Dimensions

```
REPLICATION QUALITY = EXTRACTION QUALITY. Period.
100% extraction → mechanical rebuild. 70% extraction → 30% guessing → human catches it.
Every failure in our history traces to incomplete extraction, not bad code.

For EVERY page in sitemap, capture ALL 8 dimensions:

┌──────────────────────────────────────────────────────────────┐
│ 1. STRUCTURE  — full HTML DOM                                │
│    bb-browser eval "document.documentElement.outerHTML"       │
│    → specs/html/<page>.html                                  │
├──────────────────────────────────────────────────────────────┤
│ 2. STYLE      — computed CSS + design tokens                 │
│    Colors, fonts, spacing, radius, shadows                   │
│    → specs/design-tokens.json + specs/css/<page>.css          │
├──────────────────────────────────────────────────────────────┤
│ 3. ASSETS     — every referenced file                        │
│    Images, fonts, SVGs, icons → specs/assets/                │
│    GATE: 0 placeholder images. Every <img> = real file.      │
├──────────────────────────────────────────────────────────────┤
│ 4. CONTENT    — every text string, verbatim                  │
│    site-crawler saves page.md per page                       │
│    Rule: every text in replica comes from extraction, not AI │
├──────────────────────────────────────────────────────────────┤
│ 5. BEHAVIOR   — what happens when you interact               │
│    For EVERY clickable element: click it, record result       │
│    Tabs → each tab's content. Buttons → API/modal/navigate.  │
│    Dropdowns → all options. Forms → fields + submit result.   │
│    THIS IS RECURSIVE: new elements revealed → click those too │
│    → specs/interactions.json                                  │
├──────────────────────────────────────────────────────────────┤
│ 6. STATE      — all possible page states                     │
│    Every tab content, every dropdown selection, every form    │
│    state (empty/filled/error/success), auth states            │
│    → specs/states/<page>/<state>.html                         │
│    GATE: states captured >= interactive elements found        │
├──────────────────────────────────────────────────────────────┤
│ 7. NETWORK    — every API call the page makes                │
│    Open DevTools Network tab BEFORE interacting with page     │
│    Click every button, submit every form, trigger every action│
│    For each API call captured:                                │
│      URL, method, headers, request body, response body        │
│      Status code, content-type, auth headers (redacted)       │
│    Strategy per endpoint: PROXY (real) / MOCK (saved response)│
│    → specs/apis.json                                          │
│                                                               │
│    SaaS DETECTION (conditional — evaluate each):              │
│    IF page has login/signup form:                             │
│      → capture auth endpoints, cookie names, token format     │
│      → note auth provider from tech-stack.json                │
│    IF page has pricing/checkout:                              │
│      → capture payment endpoints, plan IDs, price data        │
│      → note payment provider from tech-stack.json             │
│    IF page has user settings/profile:                         │
│      → capture CRUD endpoints for user data                   │
│    IF page has search:                                        │
│      → capture search endpoint, query format, response shape  │
│    IF page has dashboard with charts/tables:                  │
│      → capture data endpoints, pagination, filters            │
│                                                               │
│    GATE: every Submit button has a captured API endpoint       │
│    GATE: every form action has a documented response          │
├──────────────────────────────────────────────────────────────┤
│ 8. METADATA   — invisible essentials                         │
│    <title>, <meta>, OG tags, JSON-LD                          │
│    → specs/metadata/<page>.json                               │
└──────────────────────────────────────────────────────────────┘

SHARED COMPONENTS (navbar, footer, hero):
  Extract separately: screenshot + outerHTML + structure.
  Navbar dropdowns: hover each → capture each dropdown state.
  → specs/components/

COMPLETENESS CHECK (per page):
  □ HTML  □ CSS  □ Assets  □ Content
  □ Every click documented  □ All states visited  □ APIs intercepted  □ Metadata
  ANY unchecked box = INCOMPLETE extraction.

CONDITIONAL ARTIFACTS (evaluate each — do NOT skip without checking):
  IF page has forms/buttons that submit data:
    → specs/apis.json MUST have their endpoints. This is NOT optional.
  IF page has login/signup:
    → specs/auth-flow.md documenting: provider, endpoints, cookie names
  IF page has pricing/checkout:
    → specs/payment-flow.md documenting: provider, plan IDs, prices
  IF page has charts/analytics/tables with data:
    → specs/data-endpoints.json with: URL, params, response shape
  IF site has search functionality:
    → specs/search-api.json with: endpoint, query format, response
  DECISION RULE: When you see "conditional" — check the condition NOW.
  If the condition is true, the artifact is REQUIRED, not optional.

ARTIFACT CONTRACT (what Step 4 expects from Step 3):
  REQUIRED — build cannot start without these:
    specs/sitemap.json       — pages array [{url, title, auth_required}]
    specs/html/<page>.html   — one per page in sitemap (min 1)
    specs/design-tokens.json — {colors, typography, spacing, radii}
    specs/tech-stack.json    — {framework, css} at minimum
  CONDITIONAL — required if condition met during extraction:
    specs/apis.json          — IF any form/button submits data
    specs/interactions.json  — IF any tabs/dropdowns/modals found
    specs/components/        — IF shared components detected (navbar, footer)
    specs/assets/            — IF any images/fonts/SVGs referenced

Log every action: → see extraction-log.jsonl.example for format.

GATE: NO CODE UNTIL SPECS ARE COMPLETE. Run verify-extraction.sh.
```

**Why 8 dimensions:** Every replication failure maps to a missing dimension. Structure without behavior = static shell. Behavior without network = dead buttons. This list is exhaustive by design.

### Step 3.5: HUMAN GATE (complex sites only)

```
< 15 pages, no auth → SKIP (specs are the gate)
15+ pages OR auth-gated dashboard:
  → Show human: page count, routes, interactive states, assets downloaded
  → "Found N pages, M interactive elements, K assets. Ready to build?"
  → Missing pages? → back to Step 2/3
```

### Step 4: BUILD

```
a. Scaffold: Next.js 16 + shadcn/ui + Geist
b. Apply extracted design tokens
c. Build layouts (marketing + dashboard + auth)
d. Build pages bottom-up: for each page →
   → Read its extracted HTML + structure
   → Build from EXTRACTED DATA, not imagination
   → Every text = from extraction. Every image = downloaded asset.
e. Wire interactions (dropdowns, tabs, forms, modals)
f. Wire API routes (proxy or mock per specs/apis.json)

GOLDEN RULE: Every pixel traces to observed data. Never invent content.

SHARED COMPONENT DETECTION:
  Before building, scan extracted sub-tabs. If multiple pages share
  identical layouts → build ONE shared component, reuse it.

PARALLEL BUILD:
  Multiple agents → agents ONLY write files, never run npm run build.
  Only orchestrator runs build (prevents race conditions).
  Send 1 canary agent first → verify → then batch 2-3.

Reference (read on demand):
  → genome/v1/04-components.md — molecule/organism patterns
  → genome/v1/05-page-templates.md — layout skeletons
  → genome/v1/02-design-tokens.md — token implementation

GATE: npm run build passes? Every page renders?
```

### Step 5: VERIFY → REFLECT → ACT (loop, max 3 iterations)

```
COMPONENT COMPARISON (do FIRST):
  Open BOTH original and replica simultaneously.
  For each shared component (navbar, footer, hero):
    Trigger on ORIGINAL → screenshot
    Trigger on REPLICA  → screenshot
    Compare: layout, text, item count, color, positioning, hover state
    ANY structural mismatch → fix BEFORE page-level verify.
  WHY: broken navbar = 100 wrong pages.

DEPTH-FIRST PAGE WALK (the core verification):
  For EACH page in sidebar, on ORIGINAL:
    1. List EVERY clickable element: tabs, buttons, links, dropdowns, forms
    2. Click/interact with EACH on ORIGINAL → capture result
    3. Click/interact with EACH on REPLICA  → compare
    4. Sub-elements revealed? → REPEAT RECURSIVELY
    5. Page is "complete" only when ALL paths match at ALL depths
  A page with 4 tabs × 3 buttons × 2 forms = 24 paths, not 1.

VERIFY CHECKLIST:
  □ npm run build passes (zero errors)
  □ Zero broken internal links
  □ Zero links to original product domains (self-contained)
  □ Every nav item navigates correctly
  □ Dashboard sidebar: every item → real page with real content
  □ Dashboard depth: every sub-tab, form, button works
  □ Dashboard API: every Submit button returns real data
  □ Every <img> = real downloaded file (zero placeholders)
  □ Content: replica sections >= 60% of original per page
  □ Use production build: npm run build && npx next start

→ All pass? EXIT → report with numbers
→ Any fail? REFLECT (list failures, prioritize: broken > missing > cosmetic)
          → ACT (fix, may need re-extraction)
          → back to VERIFY

EXIT after: all gates pass OR 3 iterations

VERIFIER GATE (after your own VERIFY passes):
  Run verify-build.sh — mechanical check that blocks delivery if broken.
  Then dispatch a FRESH agent using verifier-prompt.md.
  The verifier has ZERO context from this session — fresh eyes only.
  Pass it: project directory path + original site URL.
  Wait for its report. If P0 issues → fix → re-verify.
  Only proceed to DELIVERY after verifier reports 0 P0 issues.

Report: Pages: N | Links: X checked, 0 broken | Images: M real |
        Dashboard: N/N working | Score: XX/100 | Remaining gaps: [list]
```

---

## §BUILD — Create a website from scratch

```
STEP 1: READ CHECKLIST
  Input: human-setup/project-checklist.md
  Extract: brand, type, features, pages, auth, database

STEP 2: GENERATE SPECS
  a. specs/prd.md (from genome/v1/18-prd-template.md)
  b. specs/tech-rd.md (from genome/v1/19-tech-rd-template.md)
  GATE: PRD + Tech RD exist with real content, not placeholders

STEP 3: SCAFFOLD
  npx create-next-app@16 <name> --typescript --tailwind --eslint --app --src-dir --turbopack
  npx shadcn@2 init -d
  npm install geist lucide-react
  + conditional deps from PRD (auth → @clerk/nextjs, db → drizzle-orm, etc.)
  → Check genome/v1/VERSION.md for pinned versions
  git init && git add -A && git commit -m "chore: scaffold"
  gh repo create <name> --private --source=. --push

STEP 4: BUILD (phase by phase)
  Each phase: Read reference → Build → Gate → Commit

  A.   Design tokens + layouts         → genome/v1/02, 05
  B.   Public pages                    → genome/v1/04, 06, 13
  C. Auth (if needed)                → genome/v1/08 §auth
  D.   App/dashboard pages (if needed) → genome/v1/06 §dashboard
  D.5. API routes + integrations (if dashboard has forms/buttons)
       For each interactive element in specs/apis.json:
         → Create Next.js API route that proxies to real service OR returns mock data
         → Wire frontend form/button to call the local API route
       GATE: every Submit button gets a non-error response
  E. Data layer (if needed)          → genome/v1/08 §database
  F. Interactions + state            → genome/v1/07
  G. Invisible layer (SEO/a11y)      → genome/v1/09
  G.5. Agent-browsable layer         → genome/v1/10
  G.6. Error + edge cases            → genome/v1/11
  H. Responsive pass                 → genome/v1/12

  Gate per phase: npm run dev renders without errors
  Gate failure → fix before next phase. Blocked after 2 attempts → report to human.

STEP 5: VERIFY → REFLECT → ACT (same loop as §COPY Step 5)
  Use genome/v1/16-validation.md (90-point review). Target: >= 90%.
  Run verify-build.sh before declaring done.
  Dispatch fresh verifier agent (verifier-prompt.md) before DELIVERY.
  0 P0 issues from verifier = ready to ship.
```

---

## §FIX — Patch an existing replica

```
STEP 0: DASHBOARD FIRST
  Before reading any handoff, before writing any code:
  → bb-browser open <dashboard-url>
  → Capture FULL sidebar structure NOW
  → This is Step 0 because it's the #1 persistent failure across 3+ agents.

STEP 1: READ HANDOFF
  The handoff is a HYPOTHESIS. Read the actual SOP sections it references.

STEP 2: OWN COMPARISON
  Navigate original + replica side-by-side. List EVERY difference.
  Trust your own observation over the handoff.

STEP 3: EXECUTE FIXES (priority)
  P0: Broken links, missing pages, external→internal links
  P1: Layout/structure mismatches
  P2: Content depth (missing sections)
  P3: Visual polish

STEP 4: VERIFY → REFLECT → ACT (same loop, same gates, no shortcuts)
  Run verify-build.sh before declaring done.
  Dispatch fresh verifier agent (verifier-prompt.md) before DELIVERY.
```

---

## QUALITY GATES

```
HARD GATES (any fail = not done, no exceptions):
  □ npm run build exit code = 0
  □ Broken internal links = 0
  □ Links to original product domains = 0
  □ Every nav item navigates correctly
  □ Dashboard sidebar: every item → real page (not placeholder)
  □ Logo/hero images = real downloaded files
  □ Placeholder images = 0
  □ Dashboard API: every Submit returns real data (not empty, not "coming soon")

SCORED GATES (numeric thresholds — report exact numbers):
  □ Pages built / pages in sitemap >= 90%
  □ Content word count: replica >= 60% of original per page
  □ Assets downloaded / assets referenced in HTML >= 80%
  □ Interactive elements working / total found >= 70%
  □ API endpoints wired / endpoints in specs/apis.json >= 80%
  □ Responsive: no layout break at 375px, 768px, 1440px

SCORING FORMULA:
  Hard gates: all must pass (binary)
  Scored gates: each scores 0-100%, weighted:
    Pages coverage:     20%
    Content match:      20%
    Assets completeness: 15%
    Interactivity:      20%
    API coverage:       15%
    Responsive:         10%
  Overall = weighted average. Target: >= 85/100

REPORT FORMAT (required — not prose):
  Pages: X/Y built (Z%)
  Content: avg X% match across Y pages
  Assets: X/Y downloaded (Z%)
  Interactive: X/Y working (Z%)
  APIs: X/Y wired (Z%)
  Responsive: pass/fail at each breakpoint
  Overall: XX/100
  P0 issues: [list with specific pages/elements]

RULE: Use production build (npm run build && npx next start).
      Click everything. Report numbers, not feelings.
      Use knowledge_write to record any new failure patterns.
```

---

## DELIVERY

```
git add -A && git commit && git push
Verify live Vercel URL (3-5 key pages)
Report: deployment URL + verification numbers
```

---

## PRINCIPLES (7 structural invariants)

```
1. EXTRACTION IS THE PRODUCT
   specs/ folder matters, not code. Code is assembly.
   70% time on extraction, 30% on build.

2. 8 DIMENSIONS, ALL REQUIRED
   Structure + Style + Assets + Content + Behavior + State + Network + Metadata.
   Missing ANY = incomplete.

3. RECURSIVE DEPTH
   Click every clickable. For every result: repeat.
   4 tabs × 3 buttons × 2 forms = 24 paths, not 1.

4. DASHBOARD FIRST
   Auth-gated pages are the product. Marketing is the wrapper.

5. COMPARE BOTH SITES, ALWAYS
   Never evaluate replica alone. Original + replica side by side.

6. QUALITY SYSTEM, NOT CHECKLIST
   "I did something" != "I did it completely."
   Agents optimize for gate-passing. Fight this instinct.

7. VERIFY WITH PRODUCTION BUILD
   npm run build && npx next start. Click everything.
   Report with numbers: "52 pages, 0 404s" not "looks good."
```

---

## REFERENCE INDEX (read on demand — do NOT pre-load)

```
WHEN TO READ                              FILE
Building components?                      genome/v1/04-components.md
Choosing a layout?                        genome/v1/05-page-templates.md
Implementing design tokens?               genome/v1/02-design-tokens.md
Wiring form validation?                   genome/v1/07-interactions.md §7.4
Adding SEO/a11y?                          genome/v1/09-invisible-layer.md
Page type catalog?                        genome/v1/06-page-types.md
Agent-browsable layer?                    genome/v1/10-agent-browsable.md
Error handling patterns?                  genome/v1/11-error-edge-cases.md
Responsive breakpoints?                   genome/v1/12-responsive.md
Content strategy?                         genome/v1/13-content-strategy.md
90-point validation checklist?            genome/v1/16-validation.md
PRD template?                             genome/v1/18-prd-template.md
Tech RD template?                         genome/v1/19-tech-rd-template.md
Pinned dependency versions?               genome/v1/VERSION.md
Extraction verification?                  verify-extraction.sh
Extraction log format?                    extraction-log.jsonl.example
Post-build verifier prompt?               verifier-prompt.md
```

---

## HARNESS ALIGNMENT

```
This genome follows Harness Engineering principles:

MAP, NOT MANUAL     This file is ~350 lines (the map).
                    genome/v1/ has 18 files (the encyclopedia).
                    Load minimum during work, full context when confused.

INVARIANTS > IMPL   The 8 dimensions and 7 principles define WHAT must exist.
                    HOW to extract is the agent's problem to solve.

MECHANICAL GATES    verify-extraction.sh blocks build if specs are incomplete.
                    Error messages contain remediation instructions.
                    Gates can't be faked — they check file existence and size.

AGENT→AGENT REVIEW  Crawler → Builder → Verifier loop.
                    Fresh agents verify. Orchestrators don't self-review.
                    See verifier-prompt.md for the review agent prompt.
```

<!-- Genome OS v3.2 | Created: 2026-04-03 | Based on: v3.1 (v2.1) + Harness Engineering | Old genome: genome/v1/ -->
