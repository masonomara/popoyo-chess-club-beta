Thoroughly read `docs/01-goal.md` and `app/types/database.ts` before doing anything else. Do not proceed until you have read and understood both documents completely. The goal doc defines what gets built. The types file defines the exact shape of every table, column, and function — every step in the plan must reference actual type names, not invented ones.

## Your task

Research the stack using context7, then write `docs/02-plan.md` — a scannable, iterative build plan tailored to this specific project.

---

## Step 1 — Research the stack

Use context7 to pull current documentation for:

- Next.js App Router — server components, server actions, routing conventions
- Supabase SSR — `@supabase/ssr`, `createBrowserClient`, `createServerClient`, cookie handling, auth helpers
- Any other library referenced in `docs/01-goal.md`

Do not rely on training data for API signatures, package names, or configuration shapes. Fetch current docs.

---

## Step 2 — Write `docs/02-plan.md`

The plan must be scannable, not a novel. Each step: what gets built · who does it (User or Claude) · what the confirmation looks like. Use the exact structure below.

Fill in Step 4 and Step 6 with content specific to this project — drawn from the actual screens, flows, roles, and type names in `docs/01-goal.md` and `app/types/database.ts`. Steps 1–3 and 5 are structural and should be written as shown, with project-specific details (table names, column names, mutation names) inserted where relevant.

---

### Template for `docs/02-plan.md`

```markdown
# Build Plan

> Generated from `docs/01-goal.md` and `app/types/database.ts`. Review before starting Phase 3.
>
> Each step: what gets built · who does it · what confirms it's working.

---

## 1. Skeleton + Auth

**Claude builds:**

- `lib/supabase/client.ts` — exports `createBrowserClient<Database>()` using `@supabase/ssr`
- `lib/supabase/server.ts` — exports `createServerClient<Database>()` using `@supabase/ssr` with cookie handling
- One auth server action with two fields: email and password
- Sign-in and sign-up flows following Supabase SSR best practices

**Confirmation:** Sign up a new user → user appears in Supabase Auth dashboard → sign in with same credentials → session persists on page refresh.

---

## 2. Main Read Path

**Claude builds:**

- Home screen as a server component
- Direct Supabase query using `createServerClient` — no client hooks, no abstractions, no loading states
- Renders real rows from the database using the types in `app/types/database.ts`

**Confirmation:** Open the app in the browser → real rows from the seeded database are visible on screen. Do not proceed to Step 3 until this is confirmed.

---

## 3. Main Write Path

**Claude builds:**

- Server action for the core mutation identified in `docs/01-goal.md`
- Form that calls the server action
- Generated types are trusted directly — no Zod for data you own

**Confirmation:** Submit the form → open Supabase table editor → new row exists → return to browser → row renders on screen.

---

## 4. Secondary Surfaces + Features

[Fill in each secondary screen and feature from `docs/01-goal.md` as a sub-item. Be specific — use actual screen names and actual type names from `app/types/database.ts`.]

**Schema change protocol:** If any step in this phase requires a schema change — update `docs/schema.sql`, re-run in Supabase SQL Editor, then run `npm run types` immediately. Never defer type regeneration.

---

## 5. Styling

**Claude builds:**

- One styling pass: layout, typography, one accent color
- No component library
- CSS Modules — no Tailwind

**Confirmation:** Every screen from the Screens section of `docs/01-goal.md` is visually coherent and readable.

---

## 6. End-to-End Walkthrough

[Generate a manual test checklist specific to this project. Cover every user role from `docs/01-goal.md` and every core flow from the User Flows section. Each item must be a concrete, observable action with a concrete, observable outcome — not "verify it works."]
```
