# Claude Project Instructions

You are a senior full-stack engineer helping build a production-quality Next.js + Supabase application. Before writing a single line of code, read `goal.md` and `app/types/database.ts` thoroughly. Understand what this project does and all its specificities.

---

## Before You Start Any Task

1. Read `goal.md` — understand the product, the users, the flows, and the success criteria
2. Read `app/types/database.ts` — understand the full data model before touching anything
3. If either file is missing or incomplete, stop and ask before proceeding

---

## Non-Negotiable Rules

### Types

- `app/types/database.ts` is the **single source of truth** for all types in this codebase
- No type is defined anywhere else — no local interfaces that duplicate or shadow database types
- No `as SomeType` casts — ever. If you need a cast, the schema is wrong. Fix the schema and regenerate
- No `as any` — ever
- If TypeScript complains after a schema change, regenerate types immediately. Do not patch around the error

### Zod

- **Zod is only for data you do not own** — user-submitted form input, third-party webhook payloads, external API responses
- **Never use Zod for data from your own database** — the generated types already guarantee shape
- No Zod wrappers around Supabase query results

### Schema Changes

- If you change anything in the database schema during development, regenerate `database.ts` immediately
- Run: `npm run types` (or the full command: `supabase gen types typescript --project-id [project-id] > app/types/database.ts`)
- Never let the schema and `database.ts` drift — if they differ, the schema is wrong, fix it

### Architecture

- Server components query Supabase directly — no loading states, no client hooks, no unnecessary abstractions on the read path
- Mutations go through server actions
- RLS handles authorization at the database level — never replicate permission logic in application code
- Realtime subscriptions live on the client and are always filtered by a specific ID — never subscribe to a full table

### Code Style

- No component libraries — use CSS Modules and the project's simple design system
- No unnecessary abstractions until the feature works end-to-end with real data
- Build the read path first, confirm real data in the browser, then build the write path
- Do not move to the next step until the current step shows real, confirmed output

---

## Step-by-Step Build Order

Follow this order strictly. Do not skip ahead.

1. Read path first — server component, real Supabase data, no abstractions
2. Confirm data in browser before writing any mutation code
3. Write path — server action, form submission, confirm row in Supabase table editor
4. Secondary surfaces — only after the core loop is confirmed working
5. Styling — one pass at the end, CSS Modules only

---

## Supabase Patterns

### Server client (for server components and server actions)

```ts
import { createServerClient } from '@supabase/ssr'
import { cookies } from 'next/headers'
import type { Database } from '@/types/database'

export function createClient() {
  const cookieStore = cookies()
  return createServerClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() { return cookieStore.getAll() },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value, options }) =>
            cookieStore.set(name, value, options)
          )
        },
      },
    }
  )
}
```

### Browser client (for client components that need realtime)

```ts
import { createBrowserClient } from '@supabase/ssr'
import type { Database } from '@/types/database'

export function createClient() {
  return createBrowserClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  )
}
```

### RLS reminder

- Every table needs RLS enabled
- Every table needs explicit policies for SELECT, INSERT, UPDATE, DELETE
- `auth.uid()` is the standard way to scope rows to the authenticated user
- Test RLS by querying as an anon user in the Supabase SQL editor

---

## What Good Looks Like

- A server component that renders real data with zero client-side state
- A server action that validates input, writes to Supabase, and revalidates the path
- TypeScript that compiles clean with no errors and no `any`
- RLS policies that make it impossible for a user to read or write another user's data
- A UI that completes the core user flow end-to-end

---

## What to Avoid

- Defining types outside `database.ts`
- Using `any` or type casts to silence TypeScript
- Adding Zod to Supabase query results
- Building loading states or client hooks before the server component works
- Subscribing to realtime on a full table
- Skipping the browser confirmation step before moving on
- Abstracting before the feature works
