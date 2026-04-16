# Prompt: Set Up Auth

> Paste this into Claude.ai. Attach your `goal.md` and `app/types/database.ts` before sending.

---

Read the attached `goal.md` and `app/types/database.ts` before starting. Understand the user model.

Set up authentication for this project. Email + password. Keep it simple.

Build:

1. Install `@supabase/supabase-js` and `@supabase/ssr`

2. Create `src/lib/supabase/server.ts` — server client using `createServerClient` from `@supabase/ssr`, typed with the Database type from `app/types/database.ts`

3. Create `src/lib/supabase/browser.ts` — browser client using `createBrowserClient` from `@supabase/ssr`, typed with the Database type

4. Create the login page at `/login` with two fields (email, password) and two actions (sign in, sign up). On success redirect to the main authenticated route. On error show the message inline — no toast libraries.

5. Create `app/login/actions.ts` with a `login` server action and a `signup` server action. Both use the server Supabase client. Both redirect on success and return an error on failure.

6. Add a session check to any existing authenticated pages: get user, redirect to /login if not authenticated.

Rules:
- No auth libraries beyond @supabase/ssr
- Email + password only — no OAuth, no magic link
- No custom session management — let Supabase handle it via cookies
- No middleware yet — just inline redirects in server components

When done, tell me:
1. What URL to open
2. How to sign up a new user
3. Where to confirm the session in Supabase dashboard

Do not proceed until I confirm login works.
