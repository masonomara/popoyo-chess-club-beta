# Prompt: Generate Schema + Seed Data

> Paste this into Claude.ai. Attach your `goal.md` before sending.

---

Read the attached `goal.md` completely before responding.

Generate the full database architecture for this project as two SQL files.

**File 1: `schema.sql`**

A complete SQL file to run in the Supabase SQL Editor. Include:

- Every table needed to support every flow in goal.md
- `id UUID DEFAULT gen_random_uuid() PRIMARY KEY` on every table
- `created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL` on every table
- `NOT NULL` on every required field
- `UNIQUE` constraints where duplication is invalid
- Foreign keys with `ON DELETE CASCADE` where children should be deleted with the parent
- Check constraints for fixed-value fields (e.g. `status IN ('pending', 'approved')`)
- `ALTER TABLE x ENABLE ROW LEVEL SECURITY` on every table
- `CREATE POLICY` for SELECT, INSERT, UPDATE, DELETE on every table using `auth.uid()`
- Indexes on every foreign key column and any frequently-filtered column
- Any Postgres functions needed

**File 2: `seed.sql`**

A complete SQL file to run after schema.sql. Include:

- 2-3 sample users with different roles
- Enough rows in every table so every screen renders non-empty
- Data covering key states (e.g. both pending and approved rows)

After generating both files, remind me to:

1. Run schema.sql in Supabase SQL Editor
2. Run seed.sql in Supabase SQL Editor
3. Add to package.json scripts: `"types": "supabase gen types typescript --project-id [PROJECT_ID] > app/types/database.ts"`
4. Replace [PROJECT_ID] with my actual project ID from Supabase → Project Settings → API
5. Run `npm run types`
6. Confirm `app/types/database.ts` was generated and `npm run dev` compiles clean
