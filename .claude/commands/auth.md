# /auth

Read `goal.md` and `app/types/database.ts` before starting. Understand the user model before writing any auth code.

Set up authentication for this project. Email + password. Keep it simple.

---

## What to build

**1. Install dependencies**

```bash
npm install @supabase/supabase-js @supabase/ssr
```

**2. Create Supabase client files**

`src/lib/supabase/server.ts` — server client for server components and server actions
`src/lib/supabase/browser.ts` — browser client for client components and realtime

**3. Create the login page**

- Route: `/login`
- Two fields: email, password
- Two actions: sign in, sign up
- On success: redirect to `/dashboard` (or whatever the main authenticated route is in `goal.md`)
- On error: show the error message inline — no toast libraries, no modals

**4. Create the auth server action**

`app/login/actions.ts`
- `login(formData)` — calls `supabase.auth.signInWithPassword`
- `signup(formData)` — calls `supabase.auth.signUp`
- Both redirect on success, both show errors on failure

**5. Protect authenticated routes**

Add a session check at the top of every authenticated server component:

```ts
const { data: { user } } = await supabase.auth.getUser()
if (!user) redirect('/login')
```

---

## Rules

- No auth libraries beyond `@supabase/ssr`
- No magic link, no OAuth, no social login — email + password only
- No custom session management — let Supabase handle it via cookies
- No middleware auth guards yet — just inline redirects in server components

---

## When you are done

Confirm with me:
1. The login page renders at `/login`
2. I can sign up a new user
3. I can log in with that user
4. The authenticated session is visible in Supabase → Authentication → Users
5. `npm run dev` compiles with zero errors

Do not proceed to the read path until all five are confirmed.
