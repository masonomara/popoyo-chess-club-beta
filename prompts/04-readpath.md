# Prompt: Build the Read Path

> Paste this into Claude.ai. Attach your `goal.md` and `app/types/database.ts` before sending.

---

Read the attached `goal.md` and `app/types/database.ts` before starting.

Build the main read path for this project — the first screen a user sees after authenticating.

Rules (non-negotiable):
- Server component only — no 'use client'
- Query Supabase directly in the component — no custom hooks, no context, no abstraction layers
- No loading states — server components don't need them
- No useState or useEffect
- Real data only — do not hardcode or mock anything

What to build:
1. Identify the main authenticated screen from goal.md
2. Build it as an async Next.js server component
3. At the top: get the user, redirect to /login if not authenticated
4. Query the relevant table(s) using the server Supabase client
5. Render the data — even unstyled — it just needs to show real rows from Supabase

After building, stop and tell me:
1. What URL to open in the browser
2. What I should see

Do not write mutation code. Do not build forms. Do not add loading states.

I will open the browser and confirm real data is visible before we move on. If the table is empty, tell me to add a row manually in Supabase → Table Editor, then refresh.
