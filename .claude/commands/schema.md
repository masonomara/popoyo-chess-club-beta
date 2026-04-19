We need to build out the project schema, types, everything. This step is the entire architecture. It needs to be done completely, as queries, server actions, and components all derive from it.

Read `01-goal.md` in depth, understand the goal and how it should work deeply, what it is supposed to do and all its specificities.

Secondly, study [shiptypes.com](https://shiptypes.com/) in great detail, understand the intricacies of it and how it relates to our project.

When that's done, write out the entire project's Postgres schema to `supabase/schema.sql` that I will run in the Supabase SQL editor. Use Context7 when helpful. Consider the following:

- One table per entity, no exceptions
- UUID primary keys: `DEFAULT gen_random_uuid()`
- `created_at TIMESTAMPTZ NOT NULL DEFAULT now()` on every table
- Every column: explicit type + `NOT NULL` unless null is meaningful
- `UNIQUE` constraints wherever the data model requires it
- Explicit `FOREIGN KEY` constraints on every relationship with `ON DELETE CASCADE` by default — use `SET NULL` or `RESTRICT` only with a comment explaining why
- RLS policies per table with explicit `CREATE POLICY` for SELECT, INSERT, UPDATE, DELETE per table - no permissive catch-alls, `ALTER TABLE [table] ENABLE ROW LEVEL SECURITY;` on every table
- Clearly named Postgres functions that will be called as RPC's from server actions: `CREATE OR REPLACE FUNCTION` for any mutation touching more than one table or requiring atomicity
- Indexes for every foreign key column
- Indexes for columns that appear in frequent `WHERE` or `ORDER BY` clauses per the flows in `docs/01-goal.md`
