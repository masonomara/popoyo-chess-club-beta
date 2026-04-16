# Prompts for Claude.ai Web Users

> If you're using **Claude Code**, ignore this folder — the slash commands in `.claude/commands/` are pre-installed when you clone this repo.
>
> If you're using **Claude.ai** (the web UI), copy the prompt for the step you're on and paste it into your chat.
>
> **Tip:** Create a Claude.ai Project and paste the contents of `claude.md` into the Project Instructions. This way Claude reads your rules automatically on every message.

---

## Prompts in this folder

| File | When to use |
|---|---|
| `01-schema.md` | Step 2 — Generate SQL schema and seed data |
| `02-plan.md` | Step 3 — Have Claude write your build plan |
| `03-auth.md` | Step 4 — Set up Supabase auth |
| `04-readpath.md` | Step 5 — Build the main read screen |
| `05-writepath.md` | Step 6 — Build the core mutation |
| `06-milestone.md` | 30-min mark — Scope audit |
| `07-ship.md` | Final step — Styling and deploy |
| `08-types.md` | Any time — Regenerate TypeScript types |

---

## Setup for Claude.ai Projects

1. Go to claude.ai → Projects → New Project
2. Open Project Instructions
3. Paste the entire contents of `claude.md` from this repo
4. Save
5. Create a new chat inside that project
6. Upload your `goal.md` and `app/types/database.ts` at the start of each session

Claude will read your project instructions automatically on every message.
