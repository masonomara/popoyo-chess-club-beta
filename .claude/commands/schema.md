Read `goal.md` and `app/types/database.ts` thoroughly.

Produce two SQL files:

**schema.sql** — the full database schema:
- All tables with NOT NULL and UNIQUE constraints
- Foreign keys with ON DELETE CASCADE
- Row Level Security (RLS) policies per table
- Any Postgres functions needed (e.g. auto-abbreviations, computed fields)

**seed.sql** — sample data:
- Enough rows to exercise every screen and flow
- Covers multiple user types if applicable

Write both to the project root. I will paste them into the Supabase SQL Editor.

After writing the files, output the `package.json` script to add for type generation:
```
"types": "supabase gen types typescript --project-id [project-id] > app/types/database.ts"
```
