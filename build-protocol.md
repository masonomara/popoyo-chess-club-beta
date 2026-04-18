# Full Stack Web App Build Protocol

---

## I. Project Setup

### 1. Confirm project prerequisites are installed

- [Node.js](https://nodejs.org) (v18+)
- [GitHub CLI](https://cli.github.com) — run `gh auth login` to authenticate
- [Claude Code](https://claude.ai/code)
- A [Vercel](https://vercel.com) account
- A [Supabase](https://supabase.com) account

### 2. Clone project scaffold and create GitHub repo

```bash
git clone https://github.com/masonomara/60-minute-build [project-name]
cd [project-name]
git remote remove origin
gh repo create [project-name] --public --source=. --push
```

### 3. Create the Next.js app

```bash
npx create-next-app@latest .
```

Use these Next.js settings:

```bash
Would you like to use the recommended Next.js defaults? › No, customize settings
Would you like to use TypeScript? … Yes
Which linter would you like to use? › ESLint
Would you like to use React Compiler? … Yes
Would you like to use Tailwind CSS? … No
Would you like your code inside a `src/` directory? … No
Would you like to use App Router? (recommended) … Yes
Would you like to customize the import alias (`@/*` by default)? … No
Would you like to include AGENTS.md to guide coding agents to write up-to-date Next.js code? › No
```

### 4. Commit and push

```bash
git add .
git commit -m "init"
git push origin main
```

### 5. Set up project in Vercel

- Log in to [Vercel](https://vercel.com)
- Click **Add New Project**
- Import Git repository
- Application preset should be **Next.js**
- Click **Deploy**
- Click **Continue to Dashboard**

### 6. Set up Supabase

- In Vercel, go to **Storage**
- Click **Create Database**
- Select **Supabase** from Marketplace Database Providers
- Click **Continue**
- Change the resource name to `supabase-[project-name]`
- Click **Create** → **Continue** → **Connect**
- Copy the secrets from the **Quickstart** section into your `.env.local` file

See `.env.local.example` for the expected keys.

### Checkpoint

- [ ] Repo is live on GitHub
- [ ] `CLAUDE.md` is at the project root
- [ ] `docs/goal.md` is present
- [ ] `.claude/commands/` is present
- [ ] Vercel project deployed
- [ ] Supabase connected via Vercel Storage
- [ ] `.env.local` populated with secrets

## Phase 2: Plan _(5 min mark)_

**5. Write your goal**

- Open `docs/goal.md` and fill in: Context, Users, Flows, Screens, Success, Key Mutations
- Keep it short — this is a spec, not an essay

**6. Run `/plan`**

- Claude reads `docs/goal.md` and produces a build plan: first screen, primary mutation, what to cut

---

## Phase 3: Architecture _(15 min mark)_

**7. Run `/schema`**

- Claude produces `schema.sql` and `seed.sql`
- Paste both into the Supabase SQL Editor and run them

**8. Generate types**

- Add to `package.json`:

```json
"types": "supabase gen types typescript --project-id [project-id] > app/types/database.ts"
```

```bash
npm run types
```

**9. Connect your services**

- Create a project in [Supabase](https://supabase.com)
- Create a project in [Vercel](https://vercel.com) and connect the repo
- Add to `.env.local` and Vercel:

```bash
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
```

**10. Run `/auth`**

- Sets up email + password auth end to end

```bash
npm run dev
```

- Open `localhost:3000` — confirm zero errors before moving on

---

## Phase 4: Build

**11. Run `/readpath`**

- Claude builds the primary screen as a server component with real Supabase data
- Don't move on until you see real data in the browser

**12. Run `/writepath`**

- Claude builds the server action for your primary mutation and wires up the form
- Submit the form → open Supabase table editor → confirm the row exists → confirm it renders in the browser

---

## ⭐ Milestone _(35 min mark)_

**13. Run `/milestone`**

- Claude checks whether read and write paths work, and flags what to cut

> If you're not here by 35 minutes, cut something. A working app with less does more than a broken app with everything.

---

## Phase 5: Ship _(60 min mark)_

**14. Build secondary screens**

- Run `/readpath` and `/writepath` for secondary surfaces
- Run `/types` any time you touch the schema

**15. Run `/ship`**

- One pass of CSS modules — layout, typography, color
- Walk every user flow
- No new features, no component libraries
- If something takes more than 5 minutes to fix, cut it
