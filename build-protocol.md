# Full Stack Web App Build Protocol

---

## I. Project Setup

### 1. Confirm that all project prerequisites are installed

**Why:** This project uses specific CLI tools. The concepts itn the tutorial are applicable to any CLI-based coding agent (Codex, Gemini), but theese are the tools this tutorial uses.

**How:** Verify each of the following is installed and authenticated:

- [Node.js](https://nodejs.org) (v18+)
- [GitHub CLI](https://cli.github.com) — run `gh auth login` to authenticate
- [Claude Code](https://claude.ai/code)
- [Vercel](https://vercel.com) account
- [Supabase](https://supabase.com) account
- [Context7 MCP](https://context7.com) (optional)

**Learn More:** [Why Context7?](#why-context7)

### 2. Clone the project template and create a new GitHub repo

**Why:** The tempalte gives you a pre-configured starting point including this protocol, spec file tempaltes, Claude commands, CLAUDE.md, etc.

**How:**

```bash
git clone https://github.com/masonomara/60-minute-build [project-name]
cd [project-name]
git remote remove origin
gh repo create [project-name] --public --source=. --push
```

### 3. Create Next.js app with the recommended project settings

**Why:** These settings (TypeScript, ESLint, App Router, React Compiler, no Tailwind, no `src/` dir) are either best practices or personal preferences. The following three decisions are perosnal preferences, feel free to change them, they wont make much of a difference: I find Tailwind CSS becomes convulted. I dont think a src/ direcotry is neccesary for this proejcts scope, and for the AGENTS.md i refer to control all the context.

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

### 5. Setup and deploy the project to Vercel

**Why:** Vercel is the native deployment target for Next.js. It gives you a live URL and a CI pipeline so every push to `main` auto-deploys.

**How:**

1. Log in to [Vercel](https://vercel.com)
2. Click **Add New Project**
3. Import your GitHub repository
4. Confirm the preset is **Next.js**
5. Click **Deploy** → **Continue to Dashboard**

### 6. Create and connect a Supabase database through Vercel

**Why:** Provisioning Supabase through Vercel's marketplace automatically injects the required environment variables into your Vercel project and keeps the projects synced

**How:**

1. In Vercel, go to **Storage**
2. Click **Create Database**
3. Select **Supabase** from Marketplace Database Providers
4. Click **Continue**
5. Name the resource `supabase-[project-name]`
6. Click **Create** → **Continue** → **Connect**
7. Copy the secrets from the **Quickstart** section into your `.env.local` file

See `.env.local.example` for the expected keys.

**Learn More:** [Supabase + Vercel Integration](https://supabase.com/docs/guides/getting-started/quickstarts/nextjs)

### 7. Add the `types` script to `package.json`

**Why:** Type generation must be a reproducible, one-command operation. Adding it manually now means it's always available and doesn't depends on Claude to set it up correctly.

**How:** In `package.json`, add to the `scripts` object:

```json
"types": "npx --yes supabase gen types typescript --project-id YOUR_PROJECT_ID > app/types/database.ts"
```

Replace `YOUR_PROJECT_ID` with the project ref from your Supabase dashboard URL: `https://supabase.com/dashboard/project/[project-id]`. This value is also in your `.env.local` as `SUPABASE_PROJECT_ID`.

Confirm it works:

```bash
npm run types
```

`app/types/database.ts` will be empty until you run the schema in Supabase — that's expected.
