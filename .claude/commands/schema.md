# /schema

Read `goal.md` and `app/types/database.ts` (if it exists) completely before responding.

Generate the full database architecture for this project. Output two files:

---

## File 1: `schema.sql`

Write a complete SQL file to be run in the Supabase SQL Editor. Include:

**Tables:**
- Every table needed to support every flow in `goal.md`
- Appropriate data types for every column
- `NOT NULL` on every required field
- `UNIQUE` constraints where duplication would be invalid
- Foreign keys with `ON DELETE CASCADE` where child rows should be deleted with their parent
- Check constraints for any field with a fixed set of values (e.g. `status IN ('pending', 'approved')`)
- `created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL` on every table
- `id UUID DEFAULT gen_random_uuid() PRIMARY KEY` on every table

**RLS:**
- `ALTER TABLE x ENABLE ROW LEVEL SECURITY` on every table
- Explicit `CREATE POLICY` for every operation (SELECT, INSERT, UPDATE, DELETE) on every table
- Use `auth.uid()` to scope rows to the authenticated user
- Public read policies where the product requires it (e.g. approved listings)

**Functions:**
- Any Postgres functions needed (slugs, computed fields, etc.)

**Indexes:**
- Index every foreign key column
- Index any column that will be frequently filtered or sorted

---

## File 2: `seed.sql`

Write a complete SQL file to be run after `schema.sql`. Include:

- At least 2-3 users with different roles (use `auth.users` or a profiles table as appropriate)
- Enough rows in every table to confirm every screen renders non-empty
- Data that covers the key states (e.g. both `pending` and `approved` rows if status matters)

---

## After generating both files

Remind me to:
1. Run `schema.sql` in the Supabase SQL Editor
2. Run `seed.sql` in the Supabase SQL Editor
3. Add the types script to `package.json`: `"types": "supabase gen types typescript --project-id [PROJECT_ID] > app/types/database.ts"`
4. Replace `[PROJECT_ID]` with my actual Supabase project ID (found in Project Settings → API)
5. Run `npm run types`
6. Confirm `app/types/database.ts` was generated and `npm run dev` compiles clean
