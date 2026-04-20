# Popoyo Chess Club — Build Plan

Source of truth: `docs/01-goal.md` · `supabase/schema.sql` · `app/types/database.ts`

---

## Task List

### Prerequisites

- [x] [manual] Run `supabase/schema.sql` in Supabase SQL Editor
- [x] [manual] Confirm 7 tables exist in Table Editor: `profiles`, `approved_emails`, `games`, `comments`, `player_ratings`, `weekly_winners`, `monthly_winners`
- [x] [manual] Run `supabase/seed.sql` in Supabase SQL Editor
- [x] [manual] Confirm seed counts: 28 rows in `games`, 6 in `player_ratings`, 5 in `weekly_winners`, 2 in `monthly_winners`
- [x] [manual] Enable `pg_cron` extension — Dashboard → Database → Extensions
- [x] [manual] Run `supabase/cron.sql` in Supabase SQL Editor
- [x] [manual] Confirm 2 cron jobs registered: `SELECT * FROM cron.job;`
- [x] [manual] Create `.env.local` with `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY`
- [x] [manual] Run `npm run types`
- [x] [manual] Confirm `app/types/database.ts` has populated `Tables`, `Functions`, and `Enums` sections

### Phase 1 — Supabase Clients, Proxy, and Auth

- [x] Create `lib/supabase/client.ts` — `createBrowserClient<Database>()`
- [x] Create `lib/supabase/server.ts` — async `createClient()` returning `createServerClient<Database>()` with `cookies()` from `next/headers`
- [x] Create `proxy.ts` — session refresh proxy with `createServerClient`, cookie forwarding, and matcher config
- [x] Create `app/anteup/page.tsx` — sign-in form and sign-up form (email, password, nickname, country)
- [x] Create `app/actions/auth.ts` — `signIn(formData)` server action
- [x] Create `app/actions/auth.ts` — `signUp(formData)` server action with `is_email_approved` RPC guard
- [x] Wire `useActionState` in `/anteup` forms for inline error display and pending state
- [x] [manual] Attempt sign-up with `gerry@popoyochess.club` — confirm inline "not approved" error
- [x] [manual] Sign up with `rob@popoyochess.club` — confirm redirect to `/`
- [x] [manual] Confirm new user appears in Supabase Auth Dashboard
- [x] [manual] Sign in with same credentials — session established
- [x] [manual] Refresh page — session persists

### Phase 2 — Main Read Path: Homepage

- [x] Create `app/page.tsx` as async server component
- [x] Implement Query 1: current week leader from `player_ratings` joined with `profiles` (`weekly_games_played >= 2`, `ORDER BY weekly_elo DESC LIMIT 1`)
- [x] Implement victory photo query for week leader (most recent `player1_photo_url` or `player2_photo_url` win within the current week)
- [x] Implement Query 2: current month leader (`monthly_games_played >= 4`, `ORDER BY monthly_elo DESC LIMIT 1`) with same photo logic
- [x] Implement Query 3a: full `player_ratings` joined with `profiles`, all rows for leaderboard
- [x] Implement Query 3b: all `games` joined with both player `profiles`, `ORDER BY game_date DESC`
- [x] Create `app/components/LeaderboardTable.tsx` — `'use client'`, receives full dataset as prop, re-sorts by `alltime_elo` / `weekly_elo` / `monthly_elo` via `useState` toggle
- [x] Conditionally render "Add Game" button — read `userRole` from `supabase.auth.getUser()` in server component, pass as pro
- [ ] [manual] Confirm Top Rob appears on week card with correct ELO and record
- [x] [manual] Confirm Top Rob appears on month card
- [x] [manual] Confirm leaderboard shows 6 rows with real ELO values
- [x] [manual] Confirm game history shows 28 rows, most recent first

### Phase 3 — Main Write Path: Submit Game

- [x] [manual] Create `game-photos` storage bucket in Supabase Dashboard → Storage (set to public)
- [x] Create `app/actions/games.ts` — `submitGame(formData)` calling `supabase.rpc('submit_game', {...})` then `revalidatePath('/')`
- [x] Create `app/components/AddGameSheet.tsx` — `'use client'` bottom sheet component
- [x] Implement Player 1 dropdown — `profiles` where `role IN ('admin','member')`, passed as prop
- [x] Implement Player 2 dropdown — same list, dynamically excludes selected Player 1
- [x] Implement color toggle (White / Black for Player 1)
- [x] Implement result toggle (Defeats / Drew)
- [x] Implement time control selector grouped by category (Bullet, Blitz, Rapid, Classical with all 16 options)
- [x] Implement datetime input defaulting to `new Date().toISOString()`, editable for backfill
- [x] Implement optional photo file inputs (Player 1 photo, Player 2 photo)
- [x] Implement photo upload to Supabase Storage using `createBrowserClient` before form submission
- [x] Wire `useActionState(submitGame, null)` for inline errors and pending/disabled state
- [x] Conditionally render `<AddGameSheet>` on homepage when `userRole === 'admin' || 'member'`
- [ ] [manual] Sign in as Top Rob, submit a game, confirm row in Supabase Table Editor → `games`
- [ ] [manual] Confirm `player_ratings` updated after submission (ELO changed)
- [ ] [manual] Refresh homepage — new game appears at top of history

### Phase 4 — Secondary Surfaces

#### 4a. Game Detail Page + Comments + Realtime

- [x] Create `app/games/[id]/page.tsx` — async server component
- [x] Query `games` by `params.id` with two player profile joins
- [x] Query `comments` where `game_id = params.id` with author profiles, `ORDER BY created_at ASC`
- [x] Display players (nickname + country), colors, result, time control, `game_date`, photos if present
- [x] Show inline viewer sign-up form (not a link to `/anteup`) for unauthenticated users in the comment section
- [x] Show comment form for authenticated users
- [x] Create `app/actions/comments.ts` — `submitComment(formData)` inserting into `comments`, then `revalidatePath('/games/[id]')`
- [x] Create `app/components/RealtimeComments.tsx` — `'use client'`, receives initial comments as prop, subscribes to `postgres_changes` on `comments` table filtered to `game_id=eq.${gameId}`
- [ ] [manual] Open same game in two browser tabs — post comment in one, confirm it appears in the other without refresh

#### 4b. Game Edit

- [x] Create `app/games/[id]/edit/page.tsx` — async server component
- [x] Add auth guard: redirect to `/` if user is not `admin` and did not submit the game (`submitted_by !== user.id`)
- [x] Render pre-populated game form (reuse `AddGameSheet` form fields as a full page, not a sheet)
- [x] Add `updateGame(gameId, formData)` to `app/actions/games.ts` — calls `supabase.rpc('update_game', { p_game_id, ...fields })`, then `revalidatePath('/')` and `revalidatePath('/games/[id]')`
- [x] Add "Edit" link on game detail page, visible only to `admin` or the game's submitter
- [ ] [manual] Edit a game's time control — verify change in Table Editor and in homepage history row

#### 4c. Admin Panel — Approved Emails

- [x] Create `app/admin/page.tsx` — async server component with auth guard (redirect to `/` if `role !== 'admin'`)
- [x] Query `approved_emails` joined with `profiles` on `added_by`
- [x] Display list: email, added by (nickname), added at (`created_at`)
- [x] Create `app/actions/admin.ts` — `addApprovedEmail(formData)` inserting into `approved_emails`, then `revalidatePath('/admin')`
- [x] Create `app/actions/admin.ts` — `removeApprovedEmail(formData)` deleting from `approved_emails` by `id`, then `revalidatePath('/admin')`
- [ ] [manual] Set Gerry's password — Supabase Auth Dashboard → Users → gerry@popoyochess.club → Send Password Reset (or set directly)
- [ ] [manual] Sign in as Gerry, navigate to `/admin` — confirm approved email list loads
- [ ] [manual] Add a new email — confirm it appears and exists in Table Editor
- [ ] [manual] Remove the email — confirm it disappears

#### 4d. Historical Weekly Winners Page

- [x] Create `app/weekly/page.tsx` — async server component
- [x] Query `weekly_winners` joined with `profiles` on `player_id`, `ORDER BY week_start DESC`
- [x] Display: week date range, nickname, country flag, `peak_elo`, wins/losses/draws, `games_played`, `victory_photo_url`
- [x] Wire `next/link` from homepage week card → `/weekly`
- [ ] [manual] Confirm `/weekly` shows 5 historical rows from seed data

#### 4e. Historical Monthly Winners Page

- [x] Create `app/monthly/page.tsx` — async server component
- [x] Query `monthly_winners` joined with `profiles` on `player_id`, `ORDER BY month_start DESC`
- [x] Display: month label (e.g. "March 2026"), nickname, country flag, `peak_elo`, record, `games_played`, `victory_photo_url`
- [x] Wire `next/link` from homepage month card → `/monthly`
- [ ] [manual] Confirm `/monthly` shows 2 historical rows from seed data

### Phase 5 — Styling Pass

- [x] Add CSS design tokens to `app/globals.css` (`--accent`, `--bg`, `--surface`, `--border`, `--text`, `--text-muted`, `--radius`, `--font`)
- [x] Style `app/layout.tsx` — dark background, max-width 1100px centered, 24px horizontal padding
- [x] Style winner cards — side-by-side desktop, stacked mobile; accent color on ELO badge
- [x] Style leaderboard table — rank, flag + nickname, ELO, W/L/D; toggle above table uses accent color for active state
- [x] Style game history rows — compact; result badge chip (W/L/D); player names; time control tag; date
- [x] Style `AddGameSheet` — slides up with `transform: translateY`, `backdrop-filter: blur`
- [x] Style game detail page — two-column player display with color chips, result callout, comment thread
- [x] Style `/anteup` — centered auth card, two tab forms (Sign In / Sign Up)
- [x] Style `/admin` page — list table, inline add form
- [x] Style `/weekly` and `/monthly` pages — consistent with homepage winner card design
- [x] Add `.module.css` file to every component and page
- [ ] [manual] Confirm homepage renders at 375px width with no layout breaks
- [ ] [manual] Confirm teal accent on primary buttons and active leaderboard toggle
- [ ] [manual] Confirm all four homepage sections visible without scrolling past fold on desktop

### Phase 6 — Manual Test Checklist

- [ ] Complete all Admin (Gerry) test cases in Phase 6
- [ ] Complete all Member (Top Rob) test cases in Phase 6
- [ ] Complete all Viewer (Pax) test cases in Phase 6
- [ ] Complete leaderboard toggle test cases
- [ ] Complete historical winners test cases
- [ ] Complete ELO recalculation test cases
- [ ] Complete edge case test cases

---

## Prerequisites (Manual — do these before any code)

### 1. Run schema in Supabase SQL Editor

**Who:** You (manual)

Open the [Supabase SQL Editor](https://supabase.com/dashboard/project/qyxyaovgsqflmkvgkxru/sql) and run `supabase/schema.sql` in full. Click through the Supabase warning about RLS — the temp tables inside the PL/pgSQL functions trigger it as a false positive; all seven real tables have `ENABLE ROW LEVEL SECURITY` explicitly.

**Confirm:** Go to Table Editor → verify these tables exist: `profiles`, `approved_emails`, `games`, `comments`, `player_ratings`, `weekly_winners`, `monthly_winners`.

---

### 2. Run seed in Supabase SQL Editor

**Who:** You (manual)

Run `supabase/seed.sql` after the schema. The seed inserts 8 users, 28 games, 10 comments, and historical winners. ELO recalculation functions run at the end of the file — `player_ratings` will be populated automatically.

**Confirm:** Table Editor → `games` table has 28 rows. `player_ratings` has 6 rows (one per member + admin). `weekly_winners` has 5 rows. `monthly_winners` has 2 rows.

---

### 3. Enable pg_cron and run cron schedules

**Who:** You (manual)

1. Dashboard → Database → Extensions → find `pg_cron` → Enable
2. Run `supabase/cron.sql` in the SQL Editor

**Confirm:** Run `SELECT * FROM cron.job;` in the SQL Editor — two rows: `weekly-winner-and-reset` and `monthly-winner-and-reset`.

---

### 4. Set up `.env.local`

**Who:** You (manual)

Create `.env.local` at the project root:

```
NEXT_PUBLIC_SUPABASE_URL=https://qyxyaovgsqflmkvgkxru.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=<anon key from Supabase Dashboard → Settings → API>
SUPABASE_SERVICE_ROLE_KEY=<service role key from same page>
```

**Confirm:** Both keys visible in Supabase Dashboard → Settings → API. The anon key is safe to expose client-side. The service role key is server-only — never pass it to `createBrowserClient`.

> **Key naming:** The Supabase dashboard may label it `SUPABASE_ANON_KEY` — copy the value and use `NEXT_PUBLIC_SUPABASE_ANON_KEY` in `.env.local`. The `NEXT_PUBLIC_` prefix is required for Next.js to expose it to the browser so `createBrowserClient` can reach it. Without the prefix, client-side Supabase calls will fail silently.

---

### 5. Regenerate types

**Who:** You (manual)

```bash
npm run types
```

**Confirm:** `app/types/database.ts` now contains `Tables` entries for `profiles`, `approved_emails`, `games`, `comments`, `player_ratings`, `weekly_winners`, `monthly_winners` — and `Functions` entries for `submit_game`, `update_game`, `delete_game`, `is_email_approved`, and the recalculation/reset RPCs. The `Enums` section contains `game_result`, `piece_color`, `time_control_category`, `user_role`.

---

## Phase 1 — Supabase Clients, Middleware, and Auth

**Who:** Claude

### What gets built

- `lib/supabase/client.ts` — `createBrowserClient<Database>()` using `@supabase/ssr`
- `lib/supabase/server.ts` — async `createClient()` returning `createServerClient<Database>()` with `cookies()` from `next/headers`
- `proxy.ts` — session refresh proxy using `createServerClient` with request/response cookie forwarding; exports `export function proxy()` (not `middleware` — renamed in Next.js 16); matcher excludes `_next/static`, `_next/image`, `favicon.ico`
- `app/anteup/page.tsx` — the secret, unlinked auth page with two forms: **Sign In** (email + password) and **Sign Up** (email + password + nickname + country)
- `app/actions/auth.ts` — two `'use server'` actions:
  - `signIn(formData)` → `supabase.auth.signInWithPassword({ email, password })` → `redirect('/')`
  - `signUp(formData)` → calls `is_email_approved` RPC first; if not approved, returns inline error; if approved, `supabase.auth.signUp({ email, password, options: { data: { nickname, country } } })` → `redirect('/')`
- `app/anteup/page.tsx` renders the forms as client components using `useActionState` for inline error display (unapproved email error, wrong password, etc.)

### Why the ordering matters

`signUp` calls `is_email_approved` RPC before calling `supabase.auth.signUp()`. The RPC reads `approved_emails` using `SECURITY DEFINER` so no service-role key is needed on the client. If the email is not on the list, the form shows an inline error — no account is created, no Auth entry made.

The Supabase trigger `handle_new_user` fires on `auth.users` INSERT and creates the `profiles` row automatically. The trigger reads `approved_emails` and sets `role = 'member'` if the email is there, `'viewer'` otherwise.

### Environment variable names

Use `NEXT_PUBLIC_SUPABASE_ANON_KEY` — the current Supabase dashboard still uses this name. Some Context7 docs show `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY`; this is a draft rename that has not shipped to the managed platform yet.

### Confirm

1. Go to `localhost:3000/anteup`
2. Sign up with `gerry@popoyochess.club` — expect an inline error: not on approved list (Gerry was seeded directly into auth.users, not through the form, and his email is not in `approved_emails`)
3. Sign up with `rob@popoyochess.club` / any password — expect success, redirect to `/`
4. Check Supabase Auth dashboard → new user appears
5. Sign in with the same credentials → session established
6. Refresh — session persists

---

## Phase 2 — Main Read Path: Homepage

**Who:** Claude

### What gets built

`app/page.tsx` as an async server component. Three direct Supabase queries using `createClient()` from `lib/supabase/server.ts`. No client hooks, no loading states.

#### Query 1 — Current week leader (Top Player of the Week card)

```
player_ratings joined with profiles
WHERE weekly_games_played >= 2
ORDER BY weekly_elo DESC LIMIT 1
```

Fields displayed: `profiles.nickname`, `profiles.country`, `player_ratings.weekly_elo`, `player_ratings.weekly_wins`, `player_ratings.weekly_losses`, `player_ratings.weekly_draws`

Victory photo: separate query on `games` — most recent game where `player1_id = winner_id AND result = 'player1_win' AND player1_photo_url IS NOT NULL` within the current week, OR `player2_id = winner_id AND result = 'player2_win' AND player2_photo_url IS NOT NULL`.

#### Query 2 — Current month leader (Top Player of the Month card)

Same pattern, using `monthly_games_played >= 4` and `monthly_elo`.

#### Query 3 — Full leaderboard + game history

Two parallel fetches:

- `player_ratings` joined with `profiles` — all rows, ordered by `alltime_elo DESC` initially (toggle state handled client-side by a `LeaderboardTable` client component that receives the full dataset and re-sorts locally via `useState`)
- `games` joined with `profiles` (player1 and player2) — all rows `ORDER BY game_date DESC`

The leaderboard toggle (Weekly / Monthly / All-Time) is the only piece of client state on this page. `LeaderboardTable` receives the full `player_ratings + profiles` dataset as a prop and re-sorts by the selected column — no re-fetch needed.

The **Add Game** button is conditionally shown: check `(await supabase.auth.getUser()).data.user` in the server component and pass `isAuthenticated` + `userRole` as props to any client components that need it.

### Types used

- `Tables<'player_ratings'>` — from generated `database.ts`
- `Tables<'profiles'>` — nickname, country, role
- `Tables<'games'>` — all columns
- `Enums<'game_result'>` — `'player1_win' | 'player2_win' | 'draw'`

### Confirm

Open `localhost:3000`. You should see:

- Top Player of the Week card showing **Top Rob** (the seeded weekly leader, 2 wins this week)
- Top Player of the Month card showing **Top Rob** (5 wins this month)
- Leaderboard with 6 rows (Gerry, Top Rob, Rafa, Camila, Kwame, Nils) — real ELO values from recalculation
- Game history: 28 rows, most recent first, each showing nicknames, result, time control, date

---

## Phase 3 — Main Write Path: Submit Game

**Who:** Claude

### What gets built

- `app/actions/games.ts` — `submitGame(formData: FormData)` server action
  - Reads: player1_id, player2_id, player1_color, result, time_control, time_control_category, game_date, player1_photo_url, player2_photo_url from formData
  - Calls: `supabase.rpc('submit_game', { p_player1_id, p_player2_id, p_player1_color, p_result, p_time_control, p_time_control_category, p_game_date, p_submitted_by, p_player1_photo_url, p_player2_photo_url })`
  - The RPC inserts the game, then calls `recalculate_alltime_elo()`, `recalculate_weekly_elo()`, `recalculate_monthly_elo()` atomically
  - After RPC returns: `revalidatePath('/')`
  - Error: if RPC returns an error (unauthorized role, same player, invalid time control) — return `{ error: string }` to display inline

- `app/components/AddGameSheet.tsx` — `'use client'` bottom sheet
  - Triggered by "Add Game" button on homepage; slides up from bottom
  - Form layout: `Player — color — defeats/drew — Player — color — time control`
    - Player 1 dropdown: `profiles` rows where `role IN ('admin','member')` — passed as prop from server component
    - Player 2 dropdown: same list, filtered to exclude selected Player 1
    - Color toggle: White / Black (for player 1; player 2 is automatically the opposite)
    - Result toggle: Defeats / Drew
    - Time control selector: grouped by category — Bullet (0+1, 1+0, 1+1, 2+1), Blitz (3+0, 3+2, 5+0, 5+3), Rapid (10+0, 10+5, 15+0, 15+10), Classical (25+0, 30+0, 30+20, 60+0)
    - Datetime input: defaults to `new Date().toISOString()`, editable
    - Photo fields: two optional file inputs (player 1 photo, player 2 photo)
  - Photo upload flow: on submit, upload each selected file to Supabase Storage bucket `game-photos` using `createBrowserClient`, get back public URL, include in formData
  - Uses `useActionState(submitGame, null)` for inline error display and pending state

- Homepage: conditionally renders `<AddGameSheet members={members} />` when `userRole === 'admin' || userRole === 'member'`

### Types used

- `TablesInsert<'games'>` shape (enforced by RPC parameter names)
- `Enums<'piece_color'>` → `'white' | 'black'`
- `Enums<'game_result'>` → `'player1_win' | 'player2_win' | 'draw'`
- `Enums<'time_control_category'>` → `'bullet' | 'blitz' | 'rapid' | 'classical'`

### Confirm

1. Sign in as Top Rob (`rob@popoyochess.club`)
2. "Add Game" button appears on homepage
3. Tap it — bottom sheet slides up
4. Fill out form: Top Rob (W) defeats Gerry, 10+0 Rapid
5. Submit
6. Open Supabase Table Editor → `games` — new row at top
7. Supabase Table Editor → `player_ratings` — Top Rob's ELO has changed (RPC recalculated)
8. Refresh homepage — new game appears in history

---

## Phase 4 — Secondary Surfaces

**Who:** Claude

### 4a. Game Detail Page + Comments + Realtime

`app/games/[id]/page.tsx` — async server component

**Read:**

```
games WHERE id = params.id
+ profiles (player1, player2 — two separate joins aliased)
+ comments WHERE game_id = params.id ORDER BY created_at ASC
+ profiles for each comment author
```

**Displays:** Players, colors, result, time control, game_date, photos (if present), full comment list.

**Unauthenticated viewer:** Shows "Create an account to leave a comment" prompt with a link to nowhere (account creation happens from this prompt only — viewer sees a sign-up form inline or via a modal, not by navigating away).

**Authenticated user:** Shows comment form → `app/actions/comments.ts` → `submitComment(formData)`:

```ts
supabase.from("comments").insert({ game_id, user_id, body });
```

Then `revalidatePath('/games/[id]')`.

**Realtime comments:** `app/components/RealtimeComments.tsx` — `'use client'`

- Receives initial `comments` array as prop
- Subscribes to Supabase Realtime channel filtered to `game_id = eq.${gameId}` on the `comments` table
- On INSERT event: appends new comment to local state
- Cleanup: unsubscribes on unmount

```ts
supabase
  .channel(`comments:game_id=eq.${gameId}`)
  .on(
    "postgres_changes",
    {
      event: "INSERT",
      schema: "public",
      table: "comments",
      filter: `game_id=eq.${gameId}`,
    },
    (payload) =>
      setComments((prev) => [...prev, payload.new as Tables<"comments">]),
  )
  .subscribe();
```

**Confirm:** Open game detail in two browser tabs. Post a comment in tab 1 — it appears in tab 2 without refresh.

---

### 4b. Game Edit

`app/games/[id]/edit/page.tsx` — async server component; redirects to `/` if user is not `admin` and did not submit the game.

Renders same `AddGameSheet` form logic as a full page (not a bottom sheet), pre-populated with existing game data.

`app/actions/games.ts` — add `updateGame(gameId, formData)`:

```ts
supabase.rpc("update_game", { p_game_id: gameId, ...fields });
```

Then `revalidatePath('/')` and `revalidatePath('/games/[id]')`.

**Confirm:** Edit a game's time control from the game detail page. Verify change in Table Editor and on the homepage game history row.

---

### 4c. Admin Panel — Approved Emails

`app/admin/page.tsx` — async server component; redirects to `/` if `userRole !== 'admin'`.

Queries `approved_emails` joined with `profiles` (for `added_by` nickname).

**Displays:** Table of approved emails with who added each and when.

`app/actions/admin.ts`:

- `addApprovedEmail(formData)` → `supabase.from('approved_emails').insert({ email, added_by: user.id })` → `revalidatePath('/admin')`
- `removeApprovedEmail(formData)` → `supabase.from('approved_emails').delete().eq('id', id)` → `revalidatePath('/admin')`

Both check `userRole === 'admin'` server-side before executing. RLS also enforces this at the DB layer.

**Confirm:** Sign in as Gerry (you'll need to use the seed credentials — Gerry was seeded directly into auth.users, so you can set a password via Supabase Auth Dashboard → Users → gerry@popoyochess.club → Reset Password). Navigate to `/admin` — approved email list appears. Add a new email. Remove it. Verify in Table Editor.

---

### 4d. Historical Weekly Winners Page

`app/weekly/page.tsx` — async server component

Queries:

```
weekly_winners JOIN profiles ON player_id = profiles.id
ORDER BY week_start DESC
```

Displays: each row shows week date range (`week_start` to `week_start + 6 days`), winner's `nickname`, `country`, `peak_elo`, `wins`, `losses`, `draws`, `games_played`, and `victory_photo_url` (if present).

Homepage: clicking the Top Player of the Week card → `next/link` to `/weekly`.

**Confirm:** `/weekly` shows 5 historical rows from seed data, most recent first.

---

### 4e. Historical Monthly Winners Page

`app/monthly/page.tsx` — async server component. Same pattern as weekly.

Queries:

```
monthly_winners JOIN profiles ON player_id = profiles.id
ORDER BY month_start DESC
```

Displays: month label (e.g. "March 2026"), winner's nickname, country, peak ELO, record, games played, victory photo.

**Confirm:** `/monthly` shows 2 historical rows from seed data.

---

## Phase 5 — Styling Pass

**Who:** Claude

One pass. One accent color. CSS Modules throughout.

### Design tokens (in `app/globals.css`)

```css
:root {
  --accent: #1a6b5c; /* deep teal */
  --accent-hover: #145549;
  --bg: #0f0f0f;
  --surface: #1a1a1a;
  --surface-raised: #242424;
  --border: #2e2e2e;
  --text: #f0f0f0;
  --text-muted: #888;
  --radius: 8px;
  --font: "Inter", system-ui, sans-serif;
}
```

### Layout targets

- `app/layout.tsx` — full-bleed dark background, max-width 1100px centered, 24px horizontal padding
- Homepage: winner cards side-by-side on desktop, stacked on mobile; leaderboard table full-width; game history list below
- Leaderboard: rank, flag + nickname, ELO, W/L/D columns; toggle (Weekly / Monthly / All-Time) above table
- Game history: compact rows with result badge (W/L/D chip), player names, time control, date
- Bottom sheet: slides up with CSS transform, backdrop-filter blur
- Game detail: two-column player display with colors, result callout, comment thread

### No component library — CSS Modules only

Every component gets a `.module.css` file. No Tailwind. No styled-components. No UI kit.

**Confirm:** Open `localhost:3000` — all four sections visible (week card, month card, leaderboard, history), no layout breaks at 375px width, teal accent on primary buttons and ELO leader badge.

---

## Phase 6 — Manual Test Checklist

### Admin (Gerry)

- [ ] Set Gerry's password via Supabase Auth Dashboard → Users → gerry@popoyochess.club → Reset Password
- [ ] Sign in at `/anteup` with `gerry@popoyochess.club`
- [ ] Confirm redirect to `/` after sign in
- [ ] Confirm "Add Game" button is visible on homepage
- [ ] Submit a new game via the bottom sheet — confirm it appears in game history
- [ ] Open the game detail page — confirm the "Edit" option appears
- [ ] Edit the game's time control — confirm the change renders on the homepage and detail page
- [ ] Navigate to `/admin` — confirm approved emails list loads
- [ ] Add a new email (e.g. `newmember@test.com`) — confirm it appears in the list
- [ ] Remove the new email — confirm it disappears
- [ ] Sign out (if implemented) or clear session — confirm "Add Game" button disappears

### Member (Top Rob)

- [ ] Sign in at `/anteup` with `rob@popoyochess.club`
- [ ] Confirm redirect to `/`
- [ ] Confirm "Add Game" button is visible
- [ ] Submit a game — confirm it appears in history with correct result
- [ ] Open a game Top Rob submitted — confirm "Edit" option appears
- [ ] Open a game Gerry submitted — confirm no "Edit" option
- [ ] Try navigating to `/admin` — confirm redirect or 403
- [ ] Post a comment on a game detail page — confirm it appears immediately (realtime)
- [ ] Open the same game in another tab — post a comment — confirm it appears in both tabs without refresh

### Viewer (Pax)

- [ ] Go to `localhost:3000` — confirm leaderboard, winner cards, and game history load without sign in
- [ ] Confirm no "Add Game" button visible
- [ ] Click a game row — confirm detail page loads
- [ ] Confirm "Create an account to leave a comment" prompt appears (not a sign-in form, not a link to `/anteup`)
- [ ] Sign up from the comment prompt with `pax2@gmail.com` — confirm account created with role `viewer` (check Supabase Auth Dashboard)
- [ ] Sign in — confirm no "Add Game" button still visible (viewer cannot submit games)
- [ ] Post a comment — confirm it appears
- [ ] Try navigating to `/admin` — confirm redirect
- [ ] Try navigating to `/anteup` — page loads (it's public) but sign up with unapproved email should show inline error

### Leaderboard toggle

- [ ] Toggle to Weekly ELO — rows re-sort, W/L/D columns update to weekly stats
- [ ] Toggle to Monthly ELO — rows re-sort, W/L/D columns update to monthly stats
- [ ] Toggle to All-Time ELO — rows return to all-time sort

### Historical winners

- [ ] Click Top Player of the Week card → `/weekly` loads, 5 rows visible
- [ ] Click Top Player of the Month card → `/monthly` loads, 2 rows visible

### ELO recalculation

- [ ] Submit a game where Gerry beats Top Rob (rapid)
- [ ] Open Supabase Table Editor → `player_ratings` — confirm Top Rob's `alltime_elo` has decreased and Gerry's has increased
- [ ] Confirm the homepage leaderboard reflects the new values after refresh

### Edge cases

- [ ] Submit a game with the same player as both player1 and player2 — confirm inline error
- [ ] Attempt to access `/anteup` and sign up with an unapproved email — confirm inline error, no auth user created (check Supabase Auth Dashboard to confirm no new row)
- [ ] Photo upload: submit a game with a winner photo — confirm the photo URL is stored in `games.player1_photo_url` and the image renders on the game detail page

---

## File Map

```
app/
  page.tsx                        # Homepage (server component)
  layout.tsx                      # Root layout
  globals.css                     # Design tokens + base styles
  anteup/
    page.tsx                      # Auth page (sign in + sign up)
  games/
    [id]/
      page.tsx                    # Game detail (server component)
      edit/
        page.tsx                  # Game edit
  weekly/
    page.tsx                      # Historical weekly winners
  monthly/
    page.tsx                      # Historical monthly winners
  admin/
    page.tsx                      # Approved email management (admin only)
  actions/
    auth.ts                       # signIn, signUp
    games.ts                      # submitGame, updateGame, deleteGame
    comments.ts                   # submitComment
    admin.ts                      # addApprovedEmail, removeApprovedEmail
  components/
    AddGameSheet.tsx               # 'use client' — game submission bottom sheet
    LeaderboardTable.tsx           # 'use client' — sortable leaderboard
    RealtimeComments.tsx           # 'use client' — live comment subscription
lib/
  supabase/
    client.ts                     # createBrowserClient<Database>()
    server.ts                     # createClient() → createServerClient<Database>()
proxy.ts                          # Session refresh proxy (renamed from middleware.ts in Next.js 16)
```
