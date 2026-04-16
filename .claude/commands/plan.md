# /plan

Read `goal.md` and `app/types/database.ts` thoroughly and completely before writing anything.

Then write `plan.md` — a concise, iterative build plan specific to this project.

---

## What plan.md must contain

**Project Summary**
2-3 sentences: what this app does, who uses it, what the core loop is.

**Data Model Summary**
Plain-English description of every table, its purpose, and its key relationships. Include a table: Table | Purpose | Key Fields.

**Build Order**
The exact sequence of tasks for this specific project, with checkboxes. Follow this structure:

1. Schema + Types (target: 15 min)
2. Deployment Scaffold (target: 15 min)
3. Auth (target: 15 min)
4. Read Path — [specific screen name from goal.md]
5. Write Path — [specific mutation name from goal.md] (target: 30 min ⭐)
6. Secondary Surfaces — [list each one]
7. Styling + Walkthrough (target: 60 min)

**Scope Cuts**
An empty table ready to be filled if scope needs to be cut at the 30-minute milestone.

**Open Questions**
Any ambiguities in `goal.md` or `database.ts` that need a decision before building. If there are none, say so.

---

## Rules for writing plan.md

- Be specific to this project — no generic placeholder text
- Name actual tables, actual screens, actual mutations from the goal
- Keep it short — the plan is a reference, not a spec
- Flag anything in `goal.md` that looks risky for a 60-minute build
- Do not start writing application code — only write plan.md
