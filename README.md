# 60-Minute Build Protocol

> A battle-tested system for shipping full-stack web apps in under an hour using Claude, Next.js, and Supabase.

📺 **[Watch the tutorial →](#)** *(link coming soon)*

---

## What's in this repo

| File / Folder | What it does |
|---|---|
| `claude.md` | Project instructions Claude reads before every response |
| `templates/goal.md` | Fill-in-the-blank spec doc — start every build here |
| `templates/plan.md` | Iterative plan template Claude writes after reading your goal |
| `templates/build-protocol.md` | The full 60-minute build protocol with all steps |
| `.claude/commands/` | Slash commands for Claude Code users |
| `prompts/` | Copy-paste prompts for Claude.ai web users |

---

## Quickstart

### Claude Code users

```bash
git clone https://github.com/YOUR_USERNAME/60-minute-build
cd 60-minute-build
```

Slash commands are pre-installed. Open Claude Code in your project and run `/schema`, `/readpath`, etc. at the right step.

### Claude.ai web users

Clone the repo or browse to the `/prompts` folder. Copy and paste the prompt for whichever step you're on into your Claude.ai chat. For best results, create a **Claude.ai Project** and paste the contents of `claude.md` into the Project Instructions.

---

## The Protocol at a Glance

| Step | What you do | Time target |
|---|---|---|
| 0 | Project setup — git, GitHub, Vercel | Before clock starts |
| 1 | Fill out `goal.md` | 5 min |
| 2 | Generate schema + seed SQL | 15 min |
| 3 | Deployment scaffold + env vars | 15 min |
| 4 | Auth | 15 min |
| 5 | Main read path | — |
| 6 | Main write path | 30 min ⭐ |
| 7 | Secondary surfaces | — |
| 8 | Styling + end-to-end walkthrough | 60 min |

> ⭐ **30-minute milestone:** If you're not through Step 6 by 35 minutes, cut scope. Remove a feature. Do not skip the milestone check.

---

## Stack

- **Framework:** Next.js (App Router)
- **Database:** Supabase (Postgres + Auth + RLS)
- **Deployment:** Vercel
- **Language:** TypeScript
- **Styling:** CSS Modules

---

## Rules (enforced via `claude.md`)

- `app/types/database.ts` is the single source of truth for all types
- No type is defined anywhere else in the codebase
- No `as SomeType` casts — if you need a cast, fix the schema and regenerate
- No Zod for data you own — trust the generated types
- Zod only for user-submitted form input you don't own
- If TypeScript complains after a schema change, regenerate immediately — never patch around it
- No component libraries — use the simple design system

---

## FAQ

**Why no separate backend?**
Server actions talk directly to Supabase. RLS enforces permissions at the database level. There's nothing a separate API layer adds that this architecture doesn't cover more simply.

**Why no component library?**
One CSS pass at the end. Tailwind and component libraries create dependency decisions that eat time during a 60-minute build.

**Why Supabase over Prisma + Postgres?**
Generated TypeScript types, built-in auth, RLS, and realtime — all without configuration. For a 60-minute build, managed beats self-hosted every time.

**What if I need realtime?**
Supabase realtime subscriptions have to live on the client (they're WebSocket connections). Add them in Step 7, never before. Always filter by a specific ID — never subscribe to a full table.

---

## Contributing

Found a bug in the protocol? Open an issue or PR. This repo evolves with each tutorial.

---

## License

MIT
