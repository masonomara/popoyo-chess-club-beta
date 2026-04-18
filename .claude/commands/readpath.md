Read `goal.md` and `app/types/database.ts`.

Build the primary read screen as a server component:
- Query Supabase directly in the server component (no client hooks, no abstractions)
- Use the generated types from `app/types/database.ts`
- No loading states, no skeleton UI — just render the data
- If auth is required, redirect unauthenticated users to `/login`

Stop when real data appears in the browser. Do not write the write path until this screen shows real data from Supabase.
