# Claude Rules

## Types

- `app/types/database.ts` is the single source of truth for all types
- No type is defined anywhere else in the codebase
- If you need a cast, fix the schema and regenerate — no `as SomeType`
- Zod for data you don't own (user-submitted form fields, external API responses); generated types for data you do

## Schema

- The schema must always match `database.ts`
- If `database.ts` and the schema diverge, the schema is wrong — fix it
- If the schema changes, regenerate immediately — not at the end
- If you changed the DB schema at any point, run `/types` to regenerate immediately

## Patterns

- Server components query Supabase directly — no client hooks, no abstractions
- Server actions handle all mutations
- Realtime subscriptions must live in client components
- No loading states or skeletons until the read path shows real data
