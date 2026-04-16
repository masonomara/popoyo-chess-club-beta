# Plan

> This file is written by Claude after reading `goal.md` and `app/types/database.ts`.
> It is the iterative, simple, and concise build plan for this specific project.
> It must be kept up to date as scope changes during the build.

---

## Project Summary

[Claude writes: 2-3 sentences on what this app does, who uses it, and what the core loop is]

---

## Data Model Summary

[Claude writes: A plain-English summary of every table, its purpose, and its key relationships]

### Tables

| Table | Purpose | Key Fields |
|---|---|---|
| [e.g. `users`] | [e.g. Supabase auth users extended with profile data] | [e.g. `id`, `email`, `role`] |
| [e.g. `listings`] | [e.g. Items submitted by users for review] | [e.g. `id`, `user_id`, `title`, `status`] |

### Key Relationships

- [e.g. `listings.user_id` → `users.id` (CASCADE DELETE)]
- [e.g. `listings.status` is `pending | approved | rejected`]

---

## Build Order

[Claude writes: The exact sequence of tasks, in order, for this specific project]

### Step 1 — Schema + Types *(target: 15 min)*

- [ ] Write `schema.sql` with all tables, constraints, and RLS policies
- [ ] Write `seed.sql` with sample data for every table
- [ ] Run both in Supabase SQL Editor
- [ ] Run `npm run types` to generate `app/types/database.ts`
- [ ] Confirm TypeScript compiles clean

### Step 2 — Deployment Scaffold *(target: 15 min)*

- [ ] Push to GitHub
- [ ] Connect to Vercel
- [ ] Add all env vars to Vercel and `.env.local`
- [ ] Confirm `npm run dev` runs with zero errors

### Step 3 — Auth *(target: 15 min)*

- [ ] Install `@supabase/supabase-js` and `@supabase/ssr`
- [ ] Create `src/lib/supabase/server.ts` (server client)
- [ ] Create `src/lib/supabase/browser.ts` (browser client)
- [ ] Build login page with email + password form
- [ ] Build login server action
- [ ] Confirm login works — authenticated session visible in browser

### Step 4 — Read Path *(target: 30 min)*

- [ ] Build [SCREEN NAME] as a server component
- [ ] Query Supabase directly — no hooks, no loading states
- [ ] **STOP. Open browser. Confirm real data appears.**

### Step 5 — Write Path *(target: 30 min ⭐)*

- [ ] Build server action for [MUTATION NAME]
- [ ] Validate user input with Zod (form fields only)
- [ ] Trust generated types for DB data — no Zod on query results
- [ ] Submit the form
- [ ] **STOP. Open Supabase table editor. Confirm row exists.**
- [ ] Return to browser. Confirm it renders.

> ⭐ **30-minute milestone check:** If not here by 35 minutes, cut scope now.

### Step 6 — Secondary Surfaces *(target: 45 min)*

- [ ] [Secondary screen or feature 1]
- [ ] [Secondary screen or feature 2]
- [ ] If schema changed at any point during this step, regenerate types immediately

### Step 7 — Styling *(target: 60 min)*

- [ ] One pass: layout, typography, color — CSS Modules only
- [ ] Walk the full user flow for each user type
- [ ] Fix anything broken. Ship if everything works.

---

## Scope Cuts (if needed)

[Claude updates this section if scope needs to be cut at the 30-minute milestone]

| Feature | Why it's cut | When to add back |
|---|---|---|
| — | — | — |

---

## Open Questions

[Claude lists anything ambiguous that needs a decision before building]

- [ ] [e.g. Should `status` be an enum or a text field with a check constraint?]
- [ ] [e.g. Does the admin need a separate login or is role stored on the user row?]
