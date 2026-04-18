Regenerate TypeScript types from the Supabase schema.

Run:
```bash
npm run types
```

This runs `supabase gen types typescript --project-id [project-id] > app/types/database.ts`.

After regenerating, check for any TypeScript errors introduced by schema changes and fix them immediately. Do not move on until the project compiles clean.
