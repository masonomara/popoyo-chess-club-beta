# /readpath

Read `goal.md` and `app/types/database.ts` before starting.

Build the main read path for this project — the first screen a user sees after authenticating.

---

## Rules (non-negotiable)

- **Server component only** — no `'use client'`
- **Query Supabase directly** — no custom hooks, no context, no abstraction layers
- **No loading states** — server components don't need them
- **No skeleton screens** — not yet
- **No `useState` or `useEffect`** — this is a server component
- **Real data only** — do not hardcode anything, do not mock anything

---

## What to build

1. Identify the main authenticated screen from `goal.md`
2. Build it as a Next.js server component (`async function Page()`)
3. At the top: get the user, redirect to `/login` if not authenticated
4. Query the relevant table(s) using the server Supabase client
5. Render the data — even ugly, even unstyled — it just needs to show real rows

---

## Pattern to follow

```ts
import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'

export default async function Page() {
  const supabase = createClient()

  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/login')

  const { data: items, error } = await supabase
    .from('your_table')
    .select('*')
    .eq('user_id', user.id)
    .order('created_at', { ascending: false })

  if (error) console.error(error)

  return (
    <main>
      <h1>Dashboard</h1>
      {items?.map(item => (
        <div key={item.id}>
          {/* render what matters */}
        </div>
      ))}
    </main>
  )
}
```

---

## Stop here

When the screen renders, **stop and tell me**:

1. What URL to open
2. What I should see

Do not write any mutation code. Do not build forms. Do not add loading states.

**I need to open the browser and confirm real data is visible before we move on.**

If the table is empty, tell me to add a row manually in Supabase → Table Editor, then refresh.
