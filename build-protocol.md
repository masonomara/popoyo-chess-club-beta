# 60-Minute Build Protocol

> The complete reference for every step of the build.

---

## Step 0 — Project Setup

Do all of this before starting the timer.

```bash
# Clone this repo into your new project folder
git clone https://github.com/[your-username]/60-minute-build [project-name]
cd [project-name]

# Create the Next.js app (scaffold files are already here)
npx create-next-app@latest .
```

Recommended settings:
- TypeScript: **Yes**
- Linter: **ESLint**
- React Compiler: **Yes**
- Tailwind CSS: **No**
- `src/` directory: **No**
- App Router: **Yes**
- Import alias: **No**
- AGENTS.md: **No**

```bash
# Create a new GitHub repo for your project and push
gh repo create [project-name] --public --push --source=.
```

**Checklist:**
- [ ] Repo cloned
- [ ] Next.js project created
- [ ] New GitHub repo created and pushed
- [ ] `claude.md` present at project root
- [ ] `goal.md` present at project root
- [ ] `.claude/commands/` present
- [ ] `app/types/database.ts` present

---

## Step 1 — Goal + Plan _(5 min mark)_

Fill out `goal.md` with:
- **Context** — what the app does and why
- **Users** — who uses it
- **Flows** — 2–3 core user flows
- **Screens** — what screens exist
- **Success** — how you'll know it works
- **Key Mutations** — the main writes to the database

Then run `/plan` — Claude will read your goal and produce a concise build plan.

---

## Step 2 — Schema + Types _(15 min mark)_

Run `/schema` — Claude will produce:
- `schema.sql` — all tables, constraints, RLS policies, Postgres functions
- `seed.sql` — sample data for every flow

Paste both into the **Supabase SQL Editor** and run them.

Then add the type generation script to `package.json`:
```json
"types": "supabase gen types typescript --project-id [project-id] > app/types/database.ts"
```

Run `npm run types` to populate `app/types/database.ts`.

---

## Step 3 — Deployment Scaffold _(15 min mark)_

1. Confirm the project is in a public GitHub repo
2. Create a new project in [Vercel](https://vercel.com) and connect the repo
3. Create a new project in [Supabase](https://supabase.com)
4. Add environment variables to `.env.local`:
   ```
   NEXT_PUBLIC_SUPABASE_URL=
   NEXT_PUBLIC_SUPABASE_ANON_KEY=
   ```
5. Add the same env vars to Vercel

---

## Step 4 — Auth _(15 min mark)_

Run `/auth` — Claude will:
1. Install `@supabase/supabase-js` and `@supabase/ssr`
2. Create browser and server Supabase clients
3. Build a simple email + password login page
4. Set up middleware to refresh sessions

Verify: `npm run dev` → open `localhost:3000` → confirm zero errors.

---

## Step 5 — Main Read Path

Run `/readpath` — Claude will build the primary screen as a server component querying Supabase directly.

**Stop here until real data appears in the browser.** Do not write the write path until this works.

---

## Step 6 — Main Write Path

Run `/writepath` — Claude will build the server action for your primary mutation and wire up the form.

**Verify:** Submit the form → open Supabase table editor → confirm the row exists → return to browser and confirm it renders.

---

## ⭐ Milestone _(35 min mark)_

Run `/milestone` — Claude will assess whether the read and write paths both work and flag anything to cut.

> If you're not here by 35 minutes, cut scope. A working app with fewer features beats a broken app with all features.

---

## Step 7 — Secondary Surfaces

Build secondary screens and features. The core is confirmed, so this moves fast.

If you touch the DB schema at any point during this step, run `/types` immediately after.

---

## Step 8 — Styling + Walkthrough _(60 min mark)_

Run `/ship` — Claude will do one pass of CSS modules and walk through every user flow.

Rules:
- No new features
- No component library — simple CSS modules only
- If something is broken and takes more than 5 minutes to fix, cut it
