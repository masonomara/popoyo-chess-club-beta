# Popoyo Chess Club Website

## What This Is

The Popoyo Chess Club plays games and shares results over text message. This website replaces that. Members log in, submit games, and the site handles the rest — updating the leaderboard, ELO rankings, game history, and analytics automatically with every submission or edit.

## Who Uses It

There are three kinds of users.

**Admins** are added manually through the Supabase backend, not through the app. They can submit and edit games, and they manage the member list — adding and removing approved emails. Admins log in from a secret, unindexed URL: `/anteup`.

**Members** must have an email pre-approved by an admin. Once approved, they sign up through that same secret URL. They can submit and edit games.

**Viewers** are everyone else. Anyone can browse the homepage — leaderboard, top players, ELO ratings, game history — without an account. Viewers can create an account, but only through the "create an account to leave a comment" prompt on individual game pages. They can comment on games. They cannot submit or edit games.

## Account Fields

Every account stores an email address, a password, a nickname (something like "Gerry" or "Top Rob"), and a country for the flag emoji display.

## Submitting a Game

Games are entered through a compact inline form designed for quick entry. The layout includes the following:

Player — color — defeats/drew — Player — color — time control

The first player is the winner (or first player in a draw). Color is a White/Black toggle. "Defeats" toggles to "drew" for a draw result. The second player is the loser (or second player in a draw). Time control defaults to 10+0 Rapid.

The available time controls are:

Bullet: 0+1, 1+0, 1+1, 2+1. Blitz: 3+0, 3+2, 5+0, 5+3. Rapid: 10+0, 10+5, 15+0, 15+10. Classical: 25+0, 30+0, 30+20, 60+0.

Below the main form are two optional photo fields — one for the winner, one for the loser. The datetime defaults to the current time but can be edited to backfill a game played earlier.

## ELO

See [elo.md](./00-elo.md) for the full research reference.

Every player has three separate ELO ratings: all-time, weekly, and monthly. All three use the same formula. All three recalculate whenever a game within their window is submitted, edited, or deleted.

All time controls feed into the same pool for each rating. The club is too small to fragment by time control. Draws give both players 0.5. Color is recorded per game but does not adjust ratings.

**All-time rating** is persistent and never resets. Starting rating is 1500. New players are provisional for their first 20 games — during that period K=40, so ratings converge to true skill faster. After 20 games, K drops to 32. The 32 is slightly above FIDE's 20 to compensate for how rarely players meet in a small pool.

**Weekly rating** resets every Monday at midnight. Everyone starts at 1500. K=64 for every game — the entire week is provisional by nature, and the high K creates a meaningful spread across only a handful of games. A win against an equal opponent moves you 32 points; a player who goes 4-0 against equal opponents finishes near 1600. The top player of the week is the player with the highest weekly rating who has played at least 2 games that week.

**Monthly rating** resets on the first of each month at midnight. Everyone starts at 1500. K=48 — more responsive than all-time to reflect the shorter window, less chaotic than weekly. A 10-win month against equal opponents reaches roughly 1680. The top player of the month is the player with the highest monthly rating who has played at least 4 games that month.

For all three pools, ratings are calculated in the order games were played, sorted by `game_date`, not entry date. A game inserted out of order triggers recalculation of all subsequent ratings in that pool from that point forward. Edits and deletes do the same.

## Pages

**Homepage** is public. It shows a Top Player of the Week card — the player with the highest weekly ELO rating who has played at least 2 games that week. The photo is the last victory photo taken of that player during that week. Clicking the card opens the Historical Weekly Winners page. Below that, a Top Player of the Month card — the player with the highest monthly ELO who has played at least 4 games that month. The photo is the last victory photo taken of that player during that month. Clicking the card opens the Historical Monthly Winners page.

Below the winner cards is the full leaderboard. A toggle lets viewers sort by Weekly ELO, Monthly ELO, or All-Time ELO. Columns show rank, nickname, country flag, the selected ELO rating, and wins, losses, and draws within the selected window. Below the leaderboard is the full game history, most recent first, each row clickable. There is no "create an account" button anywhere on this page.

When a member or admin is logged in, a prominent "Add Game" button appears. Sessions are persistent. Tapping "Add Game" opens a bottom sheet that slides up from the bottom — quick to access, quick to dismiss, no navigation away from the homepage.

**Historical Weekly Winners page** is linked from the Top Player of the Week card. It lists every past week in reverse chronological order. Each entry shows the week's date range, the winner's nickname and flag, their weekly peak ELO, their win/loss/draw record for that week, and their victory photo.

**Historical Monthly Winners page** is the same, by month.

**Game Detail Page** shows the players, colors, result, time control, datetime, and photos. Below that is a comments section. Unauthenticated viewers see a prompt to create an account in order to comment.

**`/anteup`** is the secret, unindexed login page for admins and members. It has a login form and a sign-up form (email, password, nickname, country). If the email entered is not on the approved list, an inline error appears immediately and no further steps are allowed. This page is not linked from anywhere on the public site.

**Admin Panel** is admin-only. It manages the approved member email list — add or remove entries.

**Game Submission and Edit Screen** is available to admins and members. It uses the inline form described above. Members reach it through the "Add Game" button on the homepage. Admins and members can also edit existing games from the game detail page. Datetime is auto-populated on submit.

## Rules

ELO rankings recalculate automatically on every game submission and edit. Only admins can approve emails. Only approved emails can register as members. Admins are seeded directly in Supabase. Viewer accounts can only be created from the game comment prompt — never from the homepage.
