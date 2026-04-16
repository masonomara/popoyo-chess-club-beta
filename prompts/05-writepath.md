# Prompt: Build the Write Path

> Paste this into Claude.ai. Attach your `goal.md` and `app/types/database.ts` before sending.

---

Read the attached `goal.md` and `app/types/database.ts` before starting.

Build the main write path — the core mutation that makes this app useful.

Rules (non-negotiable):
- Use Zod only for user-submitted form input (fields you don't own)
- Never use Zod on Supabase query results — the generated types already guarantee shape
- Use a server action — not an API route, not a client-side fetch
- Call revalidatePath after every successful mutation so the read path updates
- Trust the generated types for DB inserts — use Database['public']['Tables']['x']['Insert']

What to build:
1. Identify the core mutation from the Key Mutations section of goal.md
2. Build a server action in `app/[route]/actions.ts` with 'use server'
3. In the action: verify auth, validate user-submitted fields with Zod, insert/update with Supabase, revalidatePath, handle errors
4. Build the form in the appropriate page or component
5. Wire the form to the server action

After building, stop and tell me:
1. What to fill in and submit
2. Which table to check in Supabase Table Editor

I will:
1. Submit the form
2. Open Supabase Table Editor and confirm the row exists
3. Return to the browser and confirm it renders

Do not build secondary screens. Do not add styling. Wait for my confirmation before continuing.
