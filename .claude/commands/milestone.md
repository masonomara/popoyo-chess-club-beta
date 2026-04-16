# /milestone

We are at the 30-minute mark. Stop building. Audit scope.

Read `goal.md`, `plan.md`, and the current state of the codebase. Then answer these questions honestly:

---

## Audit

**1. What is working right now?**

List every confirmed-working piece:
- Can a user authenticate? (yes / no)
- Does the main read path show real data in the browser? (yes / no)
- Does the main write path create a real row in Supabase? (yes / no)

**2. What is the minimum viable demo?**

What is the shortest path to a working, demonstrable app from where we are right now? Be specific. Name the exact screens and flows that constitute a passable demo.

**3. What should be cut?**

Look at every feature in `goal.md` that isn't confirmed working. For each one, assess:

| Feature | Keep or Cut? | Reason |
|---|---|---|
| [feature] | Cut | Not essential to the core demo |
| [feature] | Keep | Users can't do the core loop without it |

Be ruthless. The rule is: **if it's not essential to demonstrating the core loop, cut it.**

**4. What is the revised build order?**

Given the cuts, what is the exact order of the remaining steps? List them out. Be specific.

---

## Rules for this check

- Do not rationalize keeping features because "it won't take long"
- Do not skip this check because you think you're on track
- Every minute spent on a non-essential feature is a minute not spent on polish and the walkthrough
- A working app with fewer features beats a broken app with more features

---

## After the audit

Update `plan.md` with:
- The cuts in the Scope Cuts table
- The revised build order

Then tell me what we're building next.
