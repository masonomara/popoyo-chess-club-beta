# /writepath

Read `goal.md` and `app/types/database.ts` before starting.

Build the main write path — the core mutation that makes this app useful.

---

## Rules (non-negotiable)

- **Zod only for user-submitted input** — form fields, things you don't own
- **No Zod on Supabase query results** — the generated types already guarantee shape
- **Server action** — not an API route, not a client-side fetch
- **`revalidatePath` after every successful mutation** — so the read path updates
- **Trust the generated types** — `Database['public']['Tables']['x']['Insert']` is your friend

---

## What to build

1. Identify the core mutation from `goal.md` (the Key Mutations section)
2. Build a server action in `app/[route]/actions.ts`
3. Build the form in the appropriate page or component
4. Wire them together with a `<form action={serverAction}>` or `useFormState`

---

## Server action pattern

```ts
'use server'
import { z } from 'zod'
import { createClient } from '@/lib/supabase/server'
import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'

// Zod schema — only for form fields (user input you don't own)
const schema = z.object({
  title: z.string().min(1, 'Title is required').max(200),
  description: z.string().min(1, 'Description is required'),
})

export async function createItem(formData: FormData) {
  const supabase = createClient()

  // Always verify auth in server actions
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/login')

  // Validate only the user-submitted fields
  const parsed = schema.safeParse({
    title: formData.get('title'),
    description: formData.get('description'),
  })

  if (!parsed.success) {
    return { error: parsed.error.errors[0].message }
  }

  // Insert — trust the generated types, no Zod here
  const { error } = await supabase
    .from('your_table')
    .insert({
      user_id: user.id,           // from auth, not from the form
      title: parsed.data.title,
      description: parsed.data.description,
    })

  if (error) return { error: error.message }

  revalidatePath('/dashboard')
}
```

---

## Form pattern

```tsx
'use client'
import { useFormState } from 'react-dom'
import { createItem } from './actions'

const initialState = { error: null }

export function CreateItemForm() {
  const [state, formAction] = useFormState(createItem, initialState)

  return (
    <form action={formAction}>
      <input name="title" placeholder="Title" required />
      <textarea name="description" placeholder="Description" required />
      {state?.error && <p>{state.error}</p>}
      <button type="submit">Create</button>
    </form>
  )
}
```

---

## Stop here

When the form is built, **stop and tell me**:

1. What to fill in and submit
2. Where to look in Supabase Table Editor to confirm the row

**I need to:**
1. Submit the form
2. Open Supabase → Table Editor → confirm the row exists
3. Return to the browser and confirm it renders

Do not build secondary screens. Do not add styling. Wait for my confirmation.
