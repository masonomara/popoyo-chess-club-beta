We need to populate the database with enough realistic data to exercise every table, role, and flow described in `docs/01-goal.md`.

Read `supabase/schema.sql` and `docs/01-goal.md` in depth. Understand how both work deeply, what each do and all their specifities. Don;t stop until you understand every table, constraint, and user role.

When that's done, write realistic sample data to `supabase/seed.sql` that covers the full shape of the application. Consider the following:

- At least one row per user role described in `docs/01-goal.md`
- Enough rows per table to make the app feel real — not 1 row, but a working state
- All data must respect every constraint in `schema.sql` — foreign keys, NOT NULL, UNIQUE, check constraints
- Hardcoded UUIDs so foreign key relationships are explicit and auditable
- Realistic values — not `test1`, `foo`, `bar`
