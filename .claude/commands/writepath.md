Read `docs/goal.md` and `app/types/database.ts`.

Build the primary write path end-to-end:
- Create the server action for the main mutation in `app/actions.ts`
- Build the form that calls it
- Validate user-submitted fields with zod (form inputs only — not DB data)
- Trust the generated types for everything from your own database
- No zod wrappers around DB responses

When done: submit the form, open the Supabase table editor, confirm the row exists. Then come back to the browser and confirm it renders.
