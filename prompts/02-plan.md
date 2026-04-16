# Prompt: Write Build Plan

> Paste this into Claude.ai. Attach your `goal.md` and `app/types/database.ts` before sending.

---

Read the attached `goal.md` and `app/types/database.ts` thoroughly and completely before writing anything.

Then write `plan.md` — a concise, iterative build plan specific to this project.

plan.md must contain:

**Project Summary** — 2-3 sentences: what this app does, who uses it, what the core loop is.

**Data Model Summary** — Plain-English description of every table, its purpose, and key relationships. Include a table with columns: Table | Purpose | Key Fields.

**Build Order** — The exact sequence of tasks for this specific project with checkboxes. Name actual tables, screens, and mutations from goal.md. Follow this structure:
1. Schema + Types (target: 15 min)
2. Deployment Scaffold (target: 15 min)
3. Auth (target: 15 min)
4. Read Path — [specific screen from goal.md]
5. Write Path — [specific mutation from goal.md] (target: 30 min ⭐)
6. Secondary Surfaces — [list each one]
7. Styling + Walkthrough (target: 60 min)

**Scope Cuts** — An empty table ready to fill if scope needs to be cut at the 30-minute milestone.

**Open Questions** — Any ambiguities that need a decision before building. If none, say so.

Rules: Be specific to this project. No generic placeholder text. Name real tables, screens, and mutations. Flag anything in goal.md that looks risky for a 60-minute build. Do not write any application code — only write plan.md.
