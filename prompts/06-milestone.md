# Prompt: 30-Minute Milestone Check

> Paste this into Claude.ai. Attach your current `goal.md` and `plan.md` before sending.

---

We are at the 30-minute mark. Stop building. Audit scope.

Read the attached `goal.md` and `plan.md`, then answer these questions honestly:

**1. What is confirmed working right now?**
- Can a user authenticate? (yes / no)
- Does the main read path show real data in the browser? (yes / no)
- Does the main write path create a real row in Supabase? (yes / no)

**2. What is the minimum viable demo?**
What is the shortest path to a working, demonstrable app from where we are? Name the exact screens and flows that constitute a passable demo.

**3. What should be cut?**
Look at every feature not yet confirmed working. For each one, produce a table:

| Feature | Keep or Cut? | Reason |
|---|---|---|

Be ruthless. If it's not essential to demonstrating the core loop, cut it.

**4. What is the revised build order?**
Given the cuts, list the exact remaining steps in order.

Rules:
- Do not rationalize keeping features because "it won't take long"
- A working app with fewer features beats a broken app with more features
- Every minute on a non-essential feature is a minute not spent on polish

After the audit, update plan.md with the cuts and the revised order, then tell me what we're building next.
