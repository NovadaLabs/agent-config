---
paths:
  - "Projects/novada-web/**"
  - "Projects/nova-final/**"
---

# Novada Project Conventions

## Tech Stack
- Next.js 16 App Router, TypeScript, Tailwind CSS, shadcn/ui
- Clerk (auth), Neon Postgres + Drizzle ORM
- Vercel deployment (manual via `vercel --prod` until CI/CD connected)

## API Patterns
- All API routes in `app/api/`
- Server-side proxy pattern: client → our route → Novada API (key stays server-side)
- Response shape: `{ data, error }` or Novada's native format
- Demo mode: same-origin Referer check skips auth for playground
- Authenticated mode: API key in header, credit deduction per request

## Known Gotchas
- Clerk v7: use `SIGN_IN_FALLBACK_REDIRECT_URL` not `AFTER_SIGN_IN_URL` (silent failure)
- `printf` not `echo` for Vercel env vars (trailing newline breaks API keys)
- Novada API always returns HTTP 200; check `data.code` not `res.status`
- Don't use `fetch_mode=static` with Novada — causes CAPTCHA/413
- Add browser-like headers (User-Agent, Origin, Referer) to avoid 402 from Vercel IPs

## Env Var Verification
After ANY env var change: `vercel env pull --environment=production` then verify actual value. Never assume write succeeded.

## Deployment
```bash
cd ~/Projects/novada-web && vercel --prod
```

## Dashboard is King
Post-login experience (dashboard) is the real product. Marketing site is just packaging. Nobody pays for a landing page.
