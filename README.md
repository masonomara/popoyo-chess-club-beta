# Full Stack Web App Build Protocol

A scaffold and step-by-step protocol for building a full-stack web app (Next.js + Supabase) in under 60 minutes.

## What's in this repo

- `BUILD_PROTOCOL.md` — full step-by-step build guide
- `CLAUDE.md` — rules and constraints Claude follows
- `docs/01-goal.md` — template to fill out before starting the build. Drives the plan, schema, and everything downstream
- `app/types/database.ts` — single source of truth for all types, generated from Supabase after schema is set
- `.claude/commands/` — slash commands called at each build step (`/plan`, `/schema`, `/seed`)
- `.env.local.example` — environment variable template; copy to `.env.local` and fill in Supabase + any other keys

## How to use it

Clone this repo into your project folder, scaffold Next.js on top of it, and follow `BUILD_PROTOCOL.md`.
