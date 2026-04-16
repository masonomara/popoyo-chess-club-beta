# Prompt: Regenerate TypeScript Types

> Paste this into Claude.ai whenever you change the database schema.

---

I need to regenerate my Supabase TypeScript types.

Remind me to run:

```bash
npm run types
```

Which maps to:

```bash
supabase gen types typescript --project-id [YOUR_PROJECT_ID] > app/types/database.ts
```

After running, I should:
1. Open `app/types/database.ts` and confirm it was updated
2. Run `npm run dev` and confirm zero TypeScript errors
3. If TypeScript errors appear after regeneration, do NOT use type casts — the schema is wrong, fix it and regenerate again

Remind me to run this every time I:
- Add a table
- Add or remove a column
- Change a column's type or constraints
- Add or remove an enum/check constraint value
- Add a Postgres function that returns a typed result

The schema and `database.ts` must never be out of sync.
