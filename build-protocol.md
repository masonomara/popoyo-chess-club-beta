# Full Stack Web App Build Protocol

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

## Learn More

### Why no separate backend?

Server actions query Supabase directly from the server, so there's no need for a separate API layer. You get type-safe DB access, RLS enforcement, and no extra network hop. A dedicated backend only makes sense if you have complicated webhooks, third-party integrations, or logic that doesn't fit as a Postgres function.

### Why server components for reads?

Server components query Supabase directly on the server and stream HTML to the client — no client hooks, no loading states, no extra round trips. Client components are reserved for anything that requires interactivity or a live connection (realtime subscriptions, forms).

### Why RLS instead of app-level auth checks?

Row Level Security enforces access rules at the database layer, so they can't be bypassed by application bugs. Every table gets its own policies — who can select, insert, update, delete. If a server action has a bug, Supabase still won't return rows the user isn't allowed to see.

### Why Postgres functions for complex mutations?

Postgres functions let you bundle multiple SQL operations into a single RPC call, keeping the logic close to the data and reducing round trips. Use them when a mutation touches multiple tables or needs to run atomically.

### Why realtime subscriptions must live in client components?

Realtime is a WebSocket connection — it has to be established from the browser. A server component renders once and is done. Client components stay mounted and can maintain the socket, receive pushes from Supabase, and re-render when data changes.

### Why generated types instead of Zod for your own DB?

Supabase generates TypeScript types directly from your schema. Those types are the contract. Wrapping them in Zod would just duplicate the schema in a second place that can drift. Use Zod only at system boundaries — user-submitted form fields and external API responses — where you don't control the shape of the data.
