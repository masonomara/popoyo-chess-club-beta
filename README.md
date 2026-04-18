# 60-Minute Build Protocol

A scaffold and step-by-step protocol for building a full-stack web app (Next.js + Supabase) in under 60 minutes — with Claude doing most of the work.

## What's in this repo

| File/Folder | Purpose |
|---|---|
| `build-protocol.md` | The full step-by-step build guide |
| `claude.md` | Rules Claude follows on every project |
| `templates/goal.md` | Goal doc template to fill out before starting |
| `app/types/database.ts` | Placeholder for Supabase-generated types |
| `.claude/commands/` | Slash commands — one per build step |

## How to use it

1. Clone this repo into your new project folder: `git clone [repo] [project-name]`
2. Run `npx create-next-app@latest .` — scaffold files are already there
3. Create a new GitHub repo and push: `gh repo create [project-name] --public --push --source=.`
4. Fill out `goal.md`
5. Follow `build-protocol.md` — use the slash commands at each step

## The 8 Steps

| Step | What | Target |
|---|---|---|
| 0 | Project setup | Before timer |
| 1 | Goal + plan | 5 min |
| 2 | Schema + types | 15 min |
| 3 | Deployment scaffold | 15 min |
| 4 | Auth | 15 min |
| 5 | Main read path | — |
| 6 | Main write path | — |
| ⭐ | **Milestone** | **35 min** |
| 7 | Secondary surfaces | — |
| 8 | Styling + walkthrough | 60 min |

## Stack

- **Framework:** Next.js (App Router, TypeScript, no Tailwind)
- **Database:** Supabase (Postgres + RLS + Auth)
- **Deployment:** Vercel
- **AI:** Claude Code with slash commands
