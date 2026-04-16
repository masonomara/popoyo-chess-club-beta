# /types

Regenerate TypeScript types from the Supabase schema.

---

Run this command:

```bash
npm run types
```

Which maps to:

```bash
supabase gen types typescript --project-id [YOUR_PROJECT_ID] > app/types/database.ts
```

---

After running:

1. Open `app/types/database.ts` and confirm it was updated (check the timestamp or a field you recently added)
2. Run `npm run dev` and confirm zero TypeScript errors
3. If TypeScript errors appear after regeneration, **do not patch them with casts** — the schema is wrong, fix it

---

## When to run /types

Run this command every time you:
- Add a table to the schema
- Add or remove a column
- Change a column's type or constraints
- Add or remove an enum value
- Add a Postgres function that returns a typed result

**The schema and `database.ts` must never be out of sync.**

If you're not sure whether they're in sync, run `/types` anyway. It's fast.
