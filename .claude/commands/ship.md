# /ship

Read `goal.md` and walk through the full codebase. We are in the final phase.

---

## Step 1 — One styling pass

Do a single CSS pass across all screens. CSS Modules only. No component libraries. Cover:

**Layout**
- Page containers with appropriate max-width and padding
- Consistent spacing between sections
- Responsive layout (at minimum: works on desktop, doesn't break on mobile)

**Typography**
- Heading sizes (h1, h2, h3)
- Body text size and line height
- Font weight for hierarchy

**Color**
- Background color
- Text color
- Border and divider color
- Primary action color (buttons, links)
- Error and success state colors

**Interactive states**
- Button hover and active states
- Form input focus states
- Disabled states where applicable
- Loading state for form submissions (disable the submit button while pending)

**Empty states**
- Every list or grid needs an empty state message
- Don't leave a blank page if there's no data

---

## Step 2 — End-to-end walkthrough

Walk through the full user journey for every user type in `goal.md`. For each:

1. Start from the landing page or `/login`
2. Sign in (or sign up if testing fresh)
3. Complete the primary flow from `goal.md` step by step
4. Check every screen for:
   - Broken layouts
   - Missing data
   - TypeScript errors in the console
   - Network errors in the console
   - Empty states that show nothing

Report any issues found. Fix them.

---

## Step 3 — Final checklist

Before calling this done:

- [ ] `npm run build` passes with zero errors and zero TypeScript errors
- [ ] Every screen in `goal.md` renders with real data
- [ ] The core mutation works end-to-end (form → Supabase → renders)
- [ ] RLS is enforced — a user cannot see another user's private data
- [ ] No `console.error` output during normal use
- [ ] Empty states exist for every list
- [ ] The app is deployed to Vercel and the production URL works

---

## Step 4 — Push and deploy

```bash
git add .
git commit -m "ship"
git push origin main
```

Vercel will auto-deploy from the push. Confirm the production URL works end-to-end.

---

When done, tell me the production URL and a one-sentence summary of what was built.
