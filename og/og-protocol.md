# 60 Minute Build Protocol

## Step 0 – Project Setup

**Useful git/gh commands:**

- `gh auth login/logout`
- `git init`
- `git commit -m "first commit"`
- `git checkout new-branch`
- `git add`
- `git push origin [branch]`
- `gh repo fork [owner]/[repo] --clone`
- `gh repo create`

---

## Step 1 – Write Out Goal + Plan _(5 min mark)_

**One doc with:**

- Context
- Users
- Flows
- Screens
- Success
- Key Mutations

---

## Step 2 – Define Schema + Types _(15 min mark)_

Need to build out schema, types. Everything. This step is the **entire architecture**. It needs to be done completely.

Write it all to an SQL file that I will run in the **Supabase SQL Editor**. Consider:

- Tables with NOT NULL and unique constraints
- Foreign keys with ON DELETE CASCADE
- RLS policies per table
- Any Postgres functions (e.g. abbreviations)
- Generate sample data and put it into an SQL file that I will run in the Supabase SQL Editor

4. Add to `package.json` → "supabase gen types typescript --project-id [project-id] > app/types/database.ts"
   - `-y5`

---

## Step 3 – Deployment Scaffold _(15 min mark)_

1. Make sure project is in public GitHub repo
2. Configure project in Vercel
3. Set up Supabase storage from Vercel
4. Add env local variables _(this will have [project id] needed for step 2.4)_
5. Configure `claude.md`:
   - Schema in `app/types/database.ts` is single source of truth
   - No type is defined anywhere else in the codebase
   - Schema & regenerate: if you need a cast, fix the schema & regenerate
   - No `as SomeType[1]` = if you need a cast, fix the schema & regenerate
   - No `zod` for data you don't own; generated types for data you do
   - If TypeScript types everywhere the schema changes, not at the end
   - The schema can't differ from `database.ts`; the schema is wrong, fix
   - The schema regenerates

6. Write remaining confirmation steps get stopped:
   - "Read goal.md and `database.ts` thoroughly. Understand what [project] should do and all its specificities."
   - "When that's done, research the technologies used further. Don't use context 4 to help research."
   - "Then write an iterative simple and concise plan.md..."
   - _(Overview of following project protocol steps)_

---

## Step 4 – Auth _(15 min mark)_

1. `npm install @supabase/supabase-js @supabase/ssr`
2. Set up `src/lib/supabase/clients`
3. Create `src/lib/lib/supabase/supabase-js @supabase/ssr`
   - Create `browserClient/database`
   - Create `serverClient/database`
4. Auth: [email + password via Supabase auth, two fields]. Done simply.
   - Set up `src/lib/supabase/server.ts`
   - Create server client auth
   - Auth: [email action, two fields]. Done simply.
   - One server. Auth action, two fields. Done simply.
   - Browser check: `npm run dev` + zero errors → open `localhost:3000`

---

## Step 5 – Main Read Path

- Real data in the browser
- Build the first screen as a server component, query Supabase directly
- No loading states, no client hooks, no abstractions yet
- ⚠️ Render it. Open the browser. Confirm real data appears
- Do not write the next part until this one shows real data

---

## Step 6 – Main Write Path

- Code mutations end-to-end
- Build the server action for the thing [project] actually does
- For user-submitted form fields and data you don't own, validate
- For data from your own DB before touching the DB, no zod needed
- Trust the generated types. No zoo wrappers or cookies. _(Data you own)_
- Submit the form. Open Supabase table editor. Confirm the row exists.
- In the DB, come back to the browser & confirm it renders.

---

## ⭐⭐⭐ MILESTONE ⭐⭐⭐

> **Submit the milestone if you're not here by 35 minutes.**  
> This is the 30-minute milestone, not a confirmation step.  
> Cut scope, remove a feature, not a confirmation step.

---

## Step 7 – Secondary Surfaces + Features

- Build secondary surfaces. Foundations are confirmed. So this moves fast.
- Ex feature: if required, add it here and only here.
- Supabase: if re-triggered in a client component, filtered by a specific ID so you're not subscribing to a useless/stale types are silent failures.
- If you changed anything in the DB schema during this phase, regenerate immediately.

---

## Step 8 – Styling + End-to-End Walkthrough

1. One pass of CSS modules – layout, typography, color
2. Do the full user journey for each user type
3. No component library – the simple design system
4. If something breaks you have time to fix it. If everything looks, you're done.

---

## Questions

**Why no separate backend? API layer covers everything. If we separate backend, tracking directly to Supabase covers everything:**

- Server actions are great for shared server actions
- To expose logic that wouldn't fall as a database function. ID: Start with zod if I need to validate types, do something with zod
- Had some complicated webhooks, third-party integrations, or logic that wouldn't roll as a database function. ID: Start with zod if I needed
- Server actions directly. Third-party integrations.

**Rules defined in the database specific to user access. Permissions so secure actions are great for you: web-only API routes are better for shared interfaces.**

**Check the database default, learn RLS around: null + unique = can be null. Has to be limited cascade means when the parent is deleted, the children are deleted too.**

**Browse means actions & secured components:**

- Read data. Always for the data, then share to the client.
- Several components to look at Supabase, but prepared by the client.
- Browse: we can run on the server, but prepared/diagram by the server using server actions.
- Secure components by using server actions.

**Postgres + SQL:**

- SQL is the language. Postgres is the database engine. SQL works on a lot of database. Supabase is a hosted Postgres database. Worth mentioning its version control, so I can run migrations.
- Remote database calls (RPC) to "bundle" commands. Use less unique constraints. Using Postgres functions. Not null + unique constraints.
- My Supabase SQL commands, so I can version control. So I don't run auto migrations to Postgres. Worth mentioning its version control, so I can run migrations.
- Manually paste.

**Realtiming is a web socket connection that has to live on the client. Something rendered once, web socket communicates to Supabase who pushes updates as they happen.**
