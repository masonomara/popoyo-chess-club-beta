# 60-Minute Build Protocol

> The complete reference for every step of the build.

---

## Project Setup

Do all of this before starting the timer.

```bash
# Create the Next.js app in the project folder
npx create-next-app@latest .

# Choose your own preferences. I prefer the following:
Would you like to use TypeScript?
> Yes
Which linter would you like to use?
> ESLint
Would you like to use React Compiler?
> Yes
Would you like to use Tailwind CSS?
> No
Would you like your code inside a `src/` directory?
> No
Would you like to use App Router? (recommended)
> Yes
Would you like to customize the import alias (`@/*` by default)?
> No
Would you like to include AGENTS.md to guide coding agents to write up-to-date Next.js code?
> No
```

```bash
# Initialize git
git init
git add .
git commit -m "init"

# Create GitHub repo and push
gh repo create [project-name] --public --push --source=.

# Copy this protocol repo's files into your project
cp path/to/claude.md .
cp path/to/templates/goal.md .
cp -r path/to/.claude
```

**Checklist:**

- [ ] Next.js project created
- [ ] Git initialized and first commit made
- [ ] Public GitHub repo created and pushed
- [ ] `claude.md` copied to project root
- [ ] `goal.md` copied to project root
- [ ] `.claude/commands/` copied to project

---

## Step 1 — Write Out Goal + Plan

**Target: 5-minute mark**

Fill out `goal.md` completely before Claude writes a single line of code.

**Required sections:**

- **Context** — Why does this exist? What's the problem?
- **Users** — Who uses it? What does each user type do?
- **Core Flows** — The 2-4 essential things a user does
- **Screens** — Every route that needs to exist (max 6-8)
- **Success** — Checkboxes: what can a user do at the end?
- **Key Mutations** — The write operations, who triggers them, what they do
- **Out of Scope** — Explicit list of what you are NOT building today

**Do not start Step 2 until `goal.md` is complete.**

---

## Step 2 — Schema + Types

**Target: 15-minute mark**

This step is the entire architecture. It must be done completely and correctly before any application code is written.

### What to generate

Run `/schema` (Claude Code) or paste the schema prompt (claude.ai).

Claude will produce two files:

**`schema.sql`** — Run this in the Supabase SQL Editor first.

Must include:

- All tables with appropriate data types
- `NOT NULL` constraints on required fields
- `UNIQUE` constraints where appropriate
- Foreign keys with `ON DELETE CASCADE` where children should be deleted with parents
- Check constraints for enums (e.g. `status IN ('pending', 'approved', 'rejected')`)
- RLS enabled on every table (`ALTER TABLE x ENABLE ROW LEVEL SECURITY`)
- RLS policies for SELECT, INSERT, UPDATE, DELETE on every table
- Any Postgres functions needed (e.g. slugs, computed fields, RPCs)
- Indexes on foreign keys and any frequently-queried columns

**`seed.sql`** — Run this in the Supabase SQL Editor after `schema.sql`.

Must include:

- Sample rows for every table
- At least 2-3 users with different roles
- Enough data to confirm every screen renders non-empty

### Generate TypeScript types

After running both SQL files:

```bash
# Add this script to package.json
"types": "supabase gen types typescript --project-id [YOUR_PROJECT_ID] > app/types/database.ts"

# Run it
npm run types
```

**Confirm:** `app/types/database.ts` exists and TypeScript compiles clean.

### RLS cheatsheet

```sql
-- Enable RLS
ALTER TABLE your_table ENABLE ROW LEVEL SECURITY;

-- Users can only read their own rows
CREATE POLICY "Users can read own rows"
  ON your_table FOR SELECT
  USING (auth.uid() = user_id);

-- Users can only insert their own rows
CREATE POLICY "Users can insert own rows"
  ON your_table FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can only update their own rows
CREATE POLICY "Users can update own rows"
  ON your_table FOR UPDATE
  USING (auth.uid() = user_id);

-- Public read (e.g. approved listings)
CREATE POLICY "Public can read approved"
  ON your_table FOR SELECT
  USING (status = 'approved');
```

**Do not move to Step 3 until:**

- [ ] `schema.sql` ran in Supabase with no errors
- [ ] `seed.sql` ran in Supabase with no errors
- [ ] `app/types/database.ts` exists
- [ ] `npm run dev` compiles with zero TypeScript errors

---

## Step 3 — Deployment Scaffold

**Target: 15-minute mark**

### 1. Push to GitHub

```bash
git add .
git commit -m "schema and types"
git push origin main
```

### 2. Connect to Vercel

- Go to vercel.com → New Project → Import your GitHub repo
- Framework: Next.js (auto-detected)
- Do not deploy yet — add env vars first

### 3. Add environment variables

**In Vercel** (Settings → Environment Variables) and **in `.env.local`**:

```bash
NEXT_PUBLIC_SUPABASE_URL=https://[project-id].supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=[anon-key]
SUPABASE_SERVICE_ROLE_KEY=[service-role-key]  # only if needed for admin actions
```

Get these from: Supabase Dashboard → Project Settings → API

### 4. Update `package.json` with your project ID

```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "types": "supabase gen types typescript --project-id YOUR_PROJECT_ID > app/types/database.ts"
  }
}
```

### 5. Configure `claude.md`

If you haven't already, copy `claude.md` to your project root and update any project-specific details.

### 6. Trigger Claude to plan

Run `/plan` (Claude Code) or paste the plan prompt (claude.ai).

Claude will read `goal.md` and `database.ts`, then write a `plan.md` specific to your project.

**Do not move to Step 4 until:**

- [ ] Vercel project connected to GitHub repo
- [ ] Env vars set in Vercel and `.env.local`
- [ ] `npm run dev` runs with zero errors
- [ ] `plan.md` written and makes sense

---

## Step 4 — Auth

**Target: 15-minute mark**

Auth is simple. Email + password. Two fields. Done.

```bash
npm install @supabase/supabase-js @supabase/ssr
```

### File structure

```
src/lib/supabase/
├── server.ts      ← server client (server components, server actions)
└── browser.ts     ← browser client (client components, realtime)
```

**`src/lib/supabase/server.ts`**

```ts
import { createServerClient } from "@supabase/ssr";
import { cookies } from "next/headers";
import type { Database } from "@/types/database";

export function createClient() {
  const cookieStore = cookies();
  return createServerClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return cookieStore.getAll();
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value, options }) =>
            cookieStore.set(name, value, options),
          );
        },
      },
    },
  );
}
```

**`src/lib/supabase/browser.ts`**

```ts
import { createBrowserClient } from "@supabase/ssr";
import type { Database } from "@/types/database";

export function createClient() {
  return createBrowserClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
  );
}
```

### Login page + server action

One page at `/login`. One server action. Email field, password field, submit button.

```ts
// app/login/actions.ts
"use server";
import { createClient } from "@/lib/supabase/server";
import { redirect } from "next/navigation";

export async function login(formData: FormData) {
  const supabase = createClient();
  const { error } = await supabase.auth.signInWithPassword({
    email: formData.get("email") as string,
    password: formData.get("password") as string,
  });
  if (error) redirect("/login?error=Invalid credentials");
  redirect("/dashboard");
}

export async function signup(formData: FormData) {
  const supabase = createClient();
  const { error } = await supabase.auth.signUp({
    email: formData.get("email") as string,
    password: formData.get("password") as string,
  });
  if (error) redirect("/login?error=" + error.message);
  redirect("/dashboard");
}
```

**Do not move to Step 5 until:**

- [ ] Login page renders
- [ ] Can sign up a new user
- [ ] Can log in with that user
- [ ] Authenticated session is visible in browser (check Supabase → Authentication → Users)
- [ ] `npm run dev` zero errors

---

## Step 5 — Main Read Path

Build the first real screen. Server component. Direct Supabase query. No abstractions.

```ts
// app/dashboard/page.tsx
import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'

export default async function DashboardPage() {
  const supabase = createClient()

  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/login')

  const { data: items } = await supabase
    .from('your_table')
    .select('*')
    .eq('user_id', user.id)
    .order('created_at', { ascending: false })

  return (
    <main>
      {items?.map(item => (
        <div key={item.id}>{item.title}</div>
      ))}
    </main>
  )
}
```

**Rules:**

- No `useState`, no `useEffect`, no `useQuery`
- No loading spinners or skeleton screens
- No abstraction layers
- Query Supabase directly in the component

**Do not move to Step 6 until:**

- [ ] Screen renders in the browser
- [ ] Real data from Supabase is visible (not hardcoded, not mocked)
- [ ] If the table is empty, add a row manually in Supabase and confirm it appears

---

## Step 6 — Main Write Path

**Target: 30-minute mark ⭐**

Build the server action for the core mutation.

```ts
// app/dashboard/actions.ts
"use server";
import { z } from "zod";
import { createClient } from "@/lib/supabase/server";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";

// Zod only for user-submitted input you don't own
const schema = z.object({
  title: z.string().min(1).max(200),
  description: z.string().min(1),
});

export async function createItem(formData: FormData) {
  const supabase = createClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  // Validate user input
  const parsed = schema.safeParse({
    title: formData.get("title"),
    description: formData.get("description"),
  });
  if (!parsed.success) return { error: "Invalid input" };

  // Trust generated types for DB insert — no Zod needed here
  const { error } = await supabase.from("your_table").insert({
    user_id: user.id,
    title: parsed.data.title,
    description: parsed.data.description,
  });

  if (error) return { error: error.message };

  revalidatePath("/dashboard");
}
```

**Do not move to Step 7 until:**

- [ ] Form submits without errors
- [ ] Row appears in Supabase table editor
- [ ] Return to browser — new row renders without a page refresh
- [ ] TypeScript compiles clean

---

## ⭐ 30-Minute Milestone Check ⭐

> **If you are not past Step 6 by 35 minutes, stop and cut scope.**

This is a hard rule. Do not skip it. Do not convince yourself you'll make up the time.

Questions to ask:

- What features in `goal.md` are marked "Out of Scope"? Can more move there?
- Which secondary screens are nice-to-have vs. essential to the demo?
- Can you demo with seed data instead of building a secondary flow?

Run `/milestone` to have Claude audit scope and identify cuts.

---

## Step 7 — Secondary Surfaces + Features

Foundations are confirmed. This step moves fast.

- Build secondary screens in order of user importance
- If a screen needs realtime, add it here — never before
- If you changed the schema during this step, run `npm run types` immediately

### Realtime (if needed)

```ts
'use client'
import { useEffect, useState } from 'react'
import { createClient } from '@/lib/supabase/browser'
import type { Database } from '@/types/database'

type Item = Database['public']['Tables']['your_table']['Row']

export function RealtimeItems({ initialItems, roomId }: {
  initialItems: Item[]
  roomId: string  // Always filter by a specific ID — never subscribe to a full table
}) {
  const [items, setItems] = useState(initialItems)

  useEffect(() => {
    const supabase = createClient()
    const channel = supabase
      .channel(`items:${roomId}`)  // namespaced channel
      .on('postgres_changes', {
        event: '*',
        schema: 'public',
        table: 'your_table',
        filter: `room_id=eq.${roomId}`,  // filtered — not the full table
      }, (payload) => {
        // handle insert, update, delete
      })
      .subscribe()

    return () => { supabase.removeChannel(channel) }
  }, [roomId])

  return <>{items.map(item => <div key={item.id}>{item.title}</div>)}</>
}
```

---

## Step 8 — Styling + End-to-End Walkthrough

One pass. CSS Modules. No component library.

### What to cover

1. Layout — containers, spacing, grid
2. Typography — font sizes, weights, line heights
3. Color — background, text, borders, accents
4. Interactive states — hover, focus, disabled, loading

### Walkthrough checklist

For each user type defined in `goal.md`:

- [ ] Start from the landing page or login
- [ ] Complete the full primary flow
- [ ] Confirm every screen renders correctly with real data
- [ ] Check for broken layouts, missing error states, and empty states
- [ ] Fix anything broken before calling it done

---

## Common Mistakes

| Mistake                                        | Fix                                    |
| ---------------------------------------------- | -------------------------------------- |
| Defining types outside `database.ts`           | Delete them. Import from `database.ts` |
| `as SomeType` to silence TypeScript            | Fix the schema, regenerate types       |
| Zod on a Supabase query result                 | Remove it. Trust the generated types   |
| Building loading states before read path works | Delete them. Confirm real data first   |
| Subscribing to a full table in realtime        | Filter by a specific ID                |
| Schema and `database.ts` out of sync           | Run `npm run types`                    |
| Skipping the browser confirmation steps        | Don't. These catch 80% of bugs early   |
| Abstracting before the feature works           | Wait until it's confirmed working      |

---

## Postgres + SQL Quick Reference

```sql
-- Common column types
id UUID DEFAULT gen_random_uuid() PRIMARY KEY
created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE
status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected'))
title TEXT NOT NULL
amount INTEGER NOT NULL  -- store money as cents
is_active BOOLEAN NOT NULL DEFAULT true

-- Unique constraint
UNIQUE (user_id, slug)

-- Index on foreign key
CREATE INDEX ON your_table(user_id);

-- Postgres function example (auto-generate slug)
CREATE OR REPLACE FUNCTION generate_slug(title TEXT)
RETURNS TEXT AS $$
  SELECT lower(regexp_replace(trim(title), '[^a-zA-Z0-9]+', '-', 'g'))
$$ LANGUAGE SQL IMMUTABLE;
```

---

## Environment Variables Reference

```bash
# .env.local
NEXT_PUBLIC_SUPABASE_URL=https://[project-id].supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=[anon-key-from-supabase-dashboard]
SUPABASE_SERVICE_ROLE_KEY=[service-role-key]  # only for admin server actions
```

Get all values from: **Supabase Dashboard → Project Settings → API**
