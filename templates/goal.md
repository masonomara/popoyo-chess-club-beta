# Goal

> Fill this out before writing a single line of code. This is the contract for the entire build.
> Claude will read this file before every response. Be specific. Vague goals produce vague software.

---

## Project Name

[Your project name]

---

## One-Line Description

[What does this do in one sentence? Who is it for and what problem does it solve?]

---

## Context

[Why does this exist? What's the problem space? What's the insight that makes this worth building?]

---

## Users

[Who uses this? Be specific. If there are multiple user types, list each one and what they do.]

| User Type | What they do |
|---|---|
| [e.g. Admin] | [e.g. Creates and manages listings] |
| [e.g. Viewer] | [e.g. Browses and saves listings] |

---

## Core Flows

[The 2-4 things a user actually does in this app. Be ruthless — only the essential flows.]

1. [Flow 1: e.g. User signs up and creates a profile]
2. [Flow 2: e.g. User submits a new listing with title, description, and price]
3. [Flow 3: e.g. Admin reviews and approves submitted listings]
4. [Flow 4: e.g. User views all approved listings on a public feed]

---

## Screens

[Every screen that needs to exist. One line each. No more than 6-8 for a 60-minute build.]

- `/` — [e.g. Public landing page with approved listings]
- `/login` — [e.g. Email + password login]
- `/dashboard` — [e.g. Authenticated user's submitted listings]
- `/submit` — [e.g. Form to submit a new listing]
- `/admin` — [e.g. Admin review queue]

---

## Success

[How do you know this build worked? What can a user do at the end that they couldn't before?]

A user can:
- [ ] [e.g. Sign up and log in with an email and password]
- [ ] [e.g. Submit a new listing and see it appear in their dashboard]
- [ ] [e.g. An admin can approve the listing and it appears on the public feed]

---

## Key Mutations

[The write operations the app performs. These map directly to server actions.]

| Mutation | Who triggers it | What it does |
|---|---|---|
| [e.g. `createListing`] | [e.g. Authenticated user] | [e.g. Inserts a row into `listings` with status `pending`] |
| [e.g. `approveListing`] | [e.g. Admin] | [e.g. Updates `listings.status` to `approved`] |

---

## Out of Scope

[Things you are explicitly NOT building in this session. Saying no here protects the 60-minute constraint.]

- [ ] [e.g. Email notifications]
- [ ] [e.g. Image uploads]
- [ ] [e.g. Stripe payments]
- [ ] [e.g. Mobile app]

---

## Notes

[Anything else Claude should know. Edge cases, business rules, constraints, preferences.]

-
