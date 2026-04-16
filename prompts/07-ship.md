# Prompt: Style + Ship

> Paste this into Claude.ai. Attach your `goal.md` before sending.

---

Read the attached `goal.md`. We are in the final phase — one styling pass, then ship.

**Step 1 — Styling pass**

Do a single CSS pass across all screens using CSS Modules only. No component libraries. Cover:

- Layout: page containers, max-width, padding, consistent spacing
- Typography: heading sizes, body text, line height, font weight hierarchy  
- Color: background, text, borders, primary action color, error and success states
- Interactive states: button hover/active, input focus, disabled states, submit button disabled while pending
- Empty states: every list needs a message when there's no data — no blank pages

**Step 2 — End-to-end walkthrough**

Walk through the full user journey for every user type in goal.md:
1. Start from the landing page or /login
2. Sign in
3. Complete the primary flow step by step
4. Check every screen for: broken layouts, missing data, console errors, empty states

Report every issue found and fix it.

**Step 3 — Final checklist**

Before calling done, confirm:
- [ ] `npm run build` passes with zero errors and zero TypeScript errors
- [ ] Every screen in goal.md renders with real data
- [ ] Core mutation works end-to-end
- [ ] RLS is enforced — users cannot access each other's private data
- [ ] No console errors during normal use
- [ ] Empty states exist for every list
- [ ] App is deployed to Vercel and the production URL works

**Step 4 — Push and deploy**

```bash
git add .
git commit -m "ship"
git push origin main
```

When done, give me the production URL and a one-sentence summary of what was built.
