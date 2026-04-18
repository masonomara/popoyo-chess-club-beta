Set up Supabase auth for this project. Steps:

1. Install packages: `npm install @supabase/supabase-js @supabase/ssr`
2. Create `lib/supabase/browser.ts` — browser client
3. Create `lib/supabase/server.ts` — server client (uses cookies)
4. Create `app/login/page.tsx` — email + password form, two fields only
5. Create `app/login/actions.ts` — server action for sign in and sign up
6. Update `middleware.ts` — refresh session on every request

Keep it simple. No OAuth, no magic links, no custom UI library. Just email + password done cleanly.

When done: run `npm run dev` and confirm zero errors before moving on.
