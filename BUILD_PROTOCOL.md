# Full Stack Web App Build Protocol

---

## I. Project Setup

### 1. Confirm that all project prerequisites are installed

**Why:** This project uses specific CLI tools. The concepts in the tutorial are applicable to any CLI-based coding agent (Codex, Gemini), but these are the tools this tutorial uses.

**How:** Verify each of the following is installed and authenticated:

- [Node.js](https://nodejs.org) (v18+)
- [GitHub CLI](https://cli.github.com) — run `gh auth login` to authenticate
- [Claude Code](https://claude.ai/code)
- [Vercel](https://vercel.com) account
- [Supabase](https://supabase.com) account
- [Context7 MCP](https://context7.com) (optional)

**Learn More:** [Why Context7?](https://www.youtube.com/watch?v=BJX6uJHIz5U)

### 2. Clone the project template and create a new GitHub repo

**Why:** The template provides a pre-configured starting point including this protocol, spec file templates, Claude commands, and `CLAUDE.md`

**How:**

```bash
git clone https://github.com/masonomara/60-minute-build [project-name]
cd [project-name]
git remote remove origin
gh repo create [project-name] --public --source=. --push
```

### 3. Create a Next.js app with the recommended project settings

**Why:** TypeScript, ESLint, App Router, and React Compiler are default recommendations. Everything else is a personal recommendation:

- **CSS Modules over Tailwind** — Tailwind becomes convoluted at scale
- **No `src/` directory** — unnecessary indirection for this scope
- **No `AGENTS.md`** — `CLAUDE.md` handles all context

**How:**

```bash
npx create-next-app@latest .
```

When prompted, use these selections:

```
Would you like to use the recommended Next.js defaults? › No, customize settings
Would you like to use TypeScript? › Yes
Which linter would you like to use? › ESLint
Would you like to use React Compiler? › Yes
Would you like to use Tailwind CSS? › No
Would you like your code inside a src/ directory? › No
Would you like to use App Router? › Yes
Would you like to customize the import alias? › No
Would you like to include AGENTS.md? › No
```

**Learn More:** [Next.js Installation](https://nextjs.org/docs/getting-started/installation)

### 4. Commit and push the initial Next.js setup

**Why:** Establishes a clean baseline before any app-specific code is added.

**How:**

```bash
git add .
git commit -m "init"
git push origin main
```

### 5. Deploy the project to Vercel

**Why:** Vercel is the native deployment target for Next.js. Every push to `main` auto-deploys, giving you a live URL and a CI pipeline.

**How:**

1. Log in to [Vercel](https://vercel.com)
2. Click **Add New Project**
3. Import your GitHub repository
4. Confirm the preset is **Next.js**
5. Click **Deploy** → **Continue to Dashboard**

### 6. Create and connect a Supabase database

**Why:** Connecting Supabase through Vercel automatically injects the required environment variables into your project and keeps both platforms in sync.

**How:**

1. In your Vercel project dashboard, go to the **Storage** tab
2. Click **Create Database** (or **Connect Store**)
3. Select **Supabase**
4. Name the resource `supabase-[project-name]`
5. Follow the prompts to create and connect the database (Click **Create** → **Continue** → **Connect**)
6. Copy the secrets from the **Quickstart** section into your `.env.local` file

See `.env.local.example` for the expected keys.

**Learn More:** [Supabase + Vercel Integration](https://supabase.com/docs/guides/getting-started/quickstarts/nextjs)

### 7. Add `SUPABASE_PROJECT_ID` to `.env.local` and the `types` script to `package.json`

**Why:** Type generation must be a one-command operation. The script reads your project ID from `.env.local` so it works consistently everywhere — protocol, commands, and CI.

**How:**

1. Find your project ID in the Supabase dashboard URL: `https://supabase.com/dashboard/project/[project-id]`
2. Add it to `.env.local`:

```
SUPABASE_PROJECT_ID=your-project-id-here
```

3. Add to the `scripts` object in `package.json`:

```json
"types": "npx --yes supabase gen types typescript --project-id $SUPABASE_PROJECT_ID > app/types/database.ts"
```

4. Confirm it works:

```bash
npm run types
```

`app/types/database.ts` will be empty until you run the schema in Supabase.

---

## II. Architecture

### 8. Fill out `docs/01-goal.md` before writing any code

**Why:** Claude reads `docs/01-goal.md` before doing anything. Writing it first forces every structural decision — roles, flows, screens, mutations — before any code exists to lock you in. Budget 5–10 minutes. Aim for ~1000 words. The more specific you are, the less you course-correct later.

**How:** Open `docs/01-goal.md` and fill in the template sections:

1. **Project Context** — What is this app? Why does it exist? What problem does it solve?
2. **User Roles** — Who uses the app? For each role: how they get access, what they can do, what they cannot.
3. **User Flows** — The 2–3 core things a user does, step by step. Start from the trigger; end at the outcome.
4. **Screens** — Every screen with a description of what it shows and what actions it supports.
5. **Success State** — 2–3 concrete, observable things you can check to confirm the app works.
6. **Key Mutations** — Every write to the database (create, update, delete), one line each.

Add sections when the project demands them:

- **Business Rules** — invariants and edge cases
- **Constraints** — what the system must enforce
- **Sample Data** — representative rows with expected normalization
- **Input Format** — form fields, toggles, dropdowns for complex inputs
- **Algorithm** — ELO, ranking, scoring logic
- **Key Server Functions** — non-trivial server-side operations

Be as specific as the project demands.

### 9. Run `/schema` to generate the database schema

**Why:** The schema is the contract. Everything downstream — queries, server actions, UI — derives from it. `app/types/database.ts` is generated from the schema and is the single source of truth for all types. If code needs a cast, the schema is wrong — fix the schema, not the code. Complete this step before writing any application code.

**How:**

1. In Claude Code, run:

```
/schema
```

2. Claude generates `docs/schema.sql`
3. In the [Supabase SQL Editor](https://supabase.com/dashboard), copy, paste, and run `schema.sql`
4. Generate `app/types/database.ts`:

```bash
npm run types
```

**Learn More:** [Supabase Row Level Security](https://supabase.com/docs/guides/auth/row-level-security) · [Supabase Type Generation](https://supabase.com/docs/reference/cli/supabase-gen-types)

### 9b. _(Optional)_ Run `/seed` to populate the database with sample data

**Why:** Seed data lets you see the app working immediately — real rows, real relationships, real state. Useful for development and demos. Skip if you prefer to add data manually or through the app.

**How:**

1. In Claude Code, run:

```
/seed
```

2. Claude generates `docs/seed.sql`
3. In the [Supabase SQL Editor](https://supabase.com/dashboard), run `seed.sql` after `schema.sql`

### 10. Run `/plan` to generate the build plan

**Why:** With `docs/01-goal.md` and `app/types/database.ts` complete, Claude has everything it needs — the goal, the schema, and the generated types — to produce a build plan tailored to this project. Running `/plan` before this point produces a generic plan; running it after produces one that knows your tables, your roles, and your mutation surface.

**How:** In the Claude Code chat, run:

```
/plan
```

Claude reads `docs/01-goal.md` and `app/types/database.ts`, researches Next.js and Supabase via Context7, and produces `docs/02-plan.md`. Review the plan before starting Phase 3. Each step identifies what gets built, who does it, and what the confirmation looks like.

---

## Learn More

### Why no separate backend?

Server actions query Supabase directly from the server, so there's no need for a separate API layer. You get type-safe database access, RLS enforcement, and no extra network hop. A dedicated backend only makes sense for complex webhooks, third-party integrations, or logic that doesn't fit as a Postgres function.

### Why server components for reads?

Server components query Supabase directly on the server and stream HTML to the client — no client hooks, no loading states, no extra round trips. Client components are reserved for anything that requires interactivity or a live connection (realtime subscriptions, forms).

### Why RLS instead of app-level auth checks?

Row Level Security enforces access rules at the database layer, where they cannot be bypassed by application bugs. Every table gets its own policies — who can select, insert, update, delete. If a server action has a bug, Supabase still won't return rows the user isn't allowed to see.

### Why Postgres functions for complex mutations?

Postgres functions bundle multiple SQL operations into a single RPC call, keeping logic close to the data and reducing round trips. Use them when a mutation touches multiple tables or must run atomically.

### Why realtime subscriptions must live in client components?

Realtime is a WebSocket connection — it must be established from the browser. A server component renders once and is done. Client components stay mounted, maintain the socket connection, receive pushes from Supabase, and re-render when data changes.

### Why generated types instead of Zod for your own database?

Supabase generates TypeScript types directly from your schema. Those types are the contract. Wrapping them in Zod would duplicate the schema in a second place that can drift. Use Zod only at system boundaries — user-submitted form fields and external API responses — where you don't control the shape of the data.
