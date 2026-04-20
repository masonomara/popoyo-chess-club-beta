-- ================================================================
-- Popoyo Chess Club — Seed Data
-- Paste into the Supabase SQL editor and run.
-- UUIDs match existing auth.users rows.
-- ================================================================


-- ────────────────────────────────────────────────────────────────
-- 1. Profiles
-- Users were already created in auth.users (trigger fired with
-- wrong defaults). ON CONFLICT corrects nickname / country / role.
-- The on_profile_role_set trigger fires on the role update and
-- creates player_ratings rows automatically.
-- ────────────────────────────────────────────────────────────────
INSERT INTO profiles (id, email, nickname, country, role) VALUES
  ('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'gguij002@gmail.com',      'Gery',    '🇨🇺', 'admin'),
  ('7dd665f5-c37d-4625-93d5-41882c377ec0', 'mason.omara@gmail.com',   'Mason',   '🇺🇸', 'admin'),
  ('be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', 'raadair33@gmail.com',      'Austin',  '🇺🇸', 'member'),
  ('41d449f6-c801-45c4-b394-3b53c989e194', 'robemmerson15@gmail.com', 'Top Rob', '🇬🇧', 'member')
ON CONFLICT (id) DO UPDATE SET
  nickname = EXCLUDED.nickname,
  country  = EXCLUDED.country,
  role     = EXCLUDED.role;


-- ────────────────────────────────────────────────────────────────
-- 2. Approved emails
-- Mason (admin) pre-approves all members.
-- ────────────────────────────────────────────────────────────────
INSERT INTO approved_emails (email, added_by) VALUES
  ('gguij002@gmail.com',      '7dd665f5-c37d-4625-93d5-41882c377ec0'),
  ('raadair33@gmail.com',      '7dd665f5-c37d-4625-93d5-41882c377ec0'),
  ('robemmerson15@gmail.com', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
  ('mason.omara@gmail.com',   '7dd665f5-c37d-4625-93d5-41882c377ec0')
ON CONFLICT (email) DO NOTHING;


-- ────────────────────────────────────────────────────────────────
-- 3. Games
-- player1 = winner (or first listed in a draw)
-- player2 = loser  (or second listed in a draw)
-- player1_color = winner's color; draws default to 'white'
-- time_control '10+0' = Rapid (10 Min games)
-- submitted_by = Mason for all historical backfill
-- game_date staggered 30 min per game within each day to preserve order
-- ────────────────────────────────────────────────────────────────

-- Player UUID aliases used below:
--   Gery    = bc0c3ae8-e75c-4199-bfe2-52f686dfca13
--   Mason   = 7dd665f5-c37d-4625-93d5-41882c377ec0
--   Austin  = be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54
--   Top Rob = 41d449f6-c801-45c4-b394-3b53c989e194

INSERT INTO games (player1_id, player2_id, player1_color, result, time_control, time_control_category, game_date, submitted_by) VALUES

-- ── 4/12/2026 ──────────────────────────────────────────────────
-- Gery beat Top Rob (White)
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '41d449f6-c801-45c4-b394-3b53c989e194', 'white', 'player1_win', '10+0', 'rapid', '2026-04-12 09:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Gery beat Top Rob (Black)
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '41d449f6-c801-45c4-b394-3b53c989e194', 'black', 'player1_win', '10+0', 'rapid', '2026-04-12 09:30:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),

-- ── 4/13/2026 ──────────────────────────────────────────────────
-- Top Rob beat Gery (Black)
('41d449f6-c801-45c4-b394-3b53c989e194', 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'black', 'player1_win', '10+0', 'rapid', '2026-04-13 09:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Mason beat Top Rob (White)
('7dd665f5-c37d-4625-93d5-41882c377ec0', '41d449f6-c801-45c4-b394-3b53c989e194', 'white', 'player1_win', '10+0', 'rapid', '2026-04-13 09:30:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Gery beat Mason (White)
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '10+0', 'rapid', '2026-04-13 10:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Gery beat Mason (Black)
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'black', 'player1_win', '10+0', 'rapid', '2026-04-13 10:30:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Mason beat Austin (White)
('7dd665f5-c37d-4625-93d5-41882c377ec0', 'be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', 'white', 'player1_win', '10+0', 'rapid', '2026-04-13 11:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Austin beat Gery (Black)
('be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'black', 'player1_win', '10+0', 'rapid', '2026-04-13 11:30:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Gery beat Austin (Black)
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', 'black', 'player1_win', '10+0', 'rapid', '2026-04-13 12:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),

-- ── 4/14/2026 ──────────────────────────────────────────────────
-- Mason beat Gery (Black)
('7dd665f5-c37d-4625-93d5-41882c377ec0', 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'black', 'player1_win', '10+0', 'rapid', '2026-04-14 09:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Gery beat Mason (White)
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '10+0', 'rapid', '2026-04-14 09:30:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Top Rob beat Mason (White)
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '10+0', 'rapid', '2026-04-14 10:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Top Rob beat Mason (Black)
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'black', 'player1_win', '10+0', 'rapid', '2026-04-14 10:30:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Top Rob beat Mason (White)
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '10+0', 'rapid', '2026-04-14 11:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Top Rob beat Austin (White)
('41d449f6-c801-45c4-b394-3b53c989e194', 'be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', 'white', 'player1_win', '10+0', 'rapid', '2026-04-14 11:30:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Gery vs Austin — Draw (Gery listed first in match)
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', 'white', 'draw',        '10+0', 'rapid', '2026-04-14 12:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Top Rob beat Gery (Black)
('41d449f6-c801-45c4-b394-3b53c989e194', 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'black', 'player1_win', '10+0', 'rapid', '2026-04-14 12:30:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Gery vs Top Rob — Draw (Gery listed first in match)
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '41d449f6-c801-45c4-b394-3b53c989e194', 'white', 'draw',        '10+0', 'rapid', '2026-04-14 13:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Mason beat Top Rob (White)
('7dd665f5-c37d-4625-93d5-41882c377ec0', '41d449f6-c801-45c4-b394-3b53c989e194', 'white', 'player1_win', '10+0', 'rapid', '2026-04-14 13:30:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Gery beat Mason (Black)
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'black', 'player1_win', '10+0', 'rapid', '2026-04-14 14:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Top Rob beat Austin (Black)
('41d449f6-c801-45c4-b394-3b53c989e194', 'be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', 'black', 'player1_win', '10+0', 'rapid', '2026-04-14 14:30:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),

-- ── 4/15/2026 ──────────────────────────────────────────────────
-- Mason beat Gery (White)
('7dd665f5-c37d-4625-93d5-41882c377ec0', 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'white', 'player1_win', '10+0', 'rapid', '2026-04-15 09:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Gery beat Mason (White)
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '10+0', 'rapid', '2026-04-15 09:30:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Gery beat Mason (Black)
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'black', 'player1_win', '10+0', 'rapid', '2026-04-15 10:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Gery beat Mason (White)
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '10+0', 'rapid', '2026-04-15 10:30:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Gery beat Austin (White)
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', 'white', 'player1_win', '10+0', 'rapid', '2026-04-15 11:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Top Rob beat Mason (Black)
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'black', 'player1_win', '10+0', 'rapid', '2026-04-15 11:30:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Top Rob beat Austin (Black)
('41d449f6-c801-45c4-b394-3b53c989e194', 'be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', 'black', 'player1_win', '10+0', 'rapid', '2026-04-15 12:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Top Rob beat Mason (White)
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '10+0', 'rapid', '2026-04-15 12:30:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Top Rob beat Mason (White)
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '10+0', 'rapid', '2026-04-15 13:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Top Rob beat Austin (Black)
('41d449f6-c801-45c4-b394-3b53c989e194', 'be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', 'black', 'player1_win', '10+0', 'rapid', '2026-04-15 13:30:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Top Rob beat Mason (Black)
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'black', 'player1_win', '10+0', 'rapid', '2026-04-15 14:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Top Rob beat Mason (White)
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '10+0', 'rapid', '2026-04-15 14:30:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Top Rob beat Mason (Black)
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'black', 'player1_win', '10+0', 'rapid', '2026-04-15 15:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),

-- ── 4/16/2026 ──────────────────────────────────────────────────
-- Gery beat Top Rob (White)
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '41d449f6-c801-45c4-b394-3b53c989e194', 'white', 'player1_win', '10+0', 'rapid', '2026-04-16 09:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Mason beat Top Rob (White)
('7dd665f5-c37d-4625-93d5-41882c377ec0', '41d449f6-c801-45c4-b394-3b53c989e194', 'white', 'player1_win', '10+0', 'rapid', '2026-04-16 09:30:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Top Rob beat Mason (White)
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '10+0', 'rapid', '2026-04-16 10:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Mason beat Austin (Black)
('7dd665f5-c37d-4625-93d5-41882c377ec0', 'be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', 'black', 'player1_win', '10+0', 'rapid', '2026-04-16 10:30:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Gery beat Mason (White)
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '10+0', 'rapid', '2026-04-16 11:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Top Rob beat Gery (White)
('41d449f6-c801-45c4-b394-3b53c989e194', 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'white', 'player1_win', '10+0', 'rapid', '2026-04-16 11:30:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Gery beat Mason (Black)
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'black', 'player1_win', '10+0', 'rapid', '2026-04-16 12:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),

-- ── 4/17/2026 ──────────────────────────────────────────────────
-- Mason beat Gery (White)
('7dd665f5-c37d-4625-93d5-41882c377ec0', 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'white', 'player1_win', '10+0', 'rapid', '2026-04-17 09:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Mason beat Austin (White)
('7dd665f5-c37d-4625-93d5-41882c377ec0', 'be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', 'white', 'player1_win', '10+0', 'rapid', '2026-04-17 09:30:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Mason beat Gery (Black)
('7dd665f5-c37d-4625-93d5-41882c377ec0', 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'black', 'player1_win', '10+0', 'rapid', '2026-04-17 10:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Mason beat Top Rob (White)
('7dd665f5-c37d-4625-93d5-41882c377ec0', '41d449f6-c801-45c4-b394-3b53c989e194', 'white', 'player1_win', '10+0', 'rapid', '2026-04-17 10:30:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Top Rob beat Mason (White)
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '10+0', 'rapid', '2026-04-17 11:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Top Rob beat Gery (White)
('41d449f6-c801-45c4-b394-3b53c989e194', 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'white', 'player1_win', '10+0', 'rapid', '2026-04-17 11:30:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Top Rob beat Gery (Black)
('41d449f6-c801-45c4-b394-3b53c989e194', 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'black', 'player1_win', '10+0', 'rapid', '2026-04-17 12:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Gery beat Top Rob (White)
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '41d449f6-c801-45c4-b394-3b53c989e194', 'white', 'player1_win', '10+0', 'rapid', '2026-04-17 12:30:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Mason beat Austin (White)
('7dd665f5-c37d-4625-93d5-41882c377ec0', 'be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', 'white', 'player1_win', '10+0', 'rapid', '2026-04-17 13:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Austin beat Mason (White)
('be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '10+0', 'rapid', '2026-04-17 13:30:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Top Rob beat Austin (White)
('41d449f6-c801-45c4-b394-3b53c989e194', 'be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54', 'white', 'player1_win', '10+0', 'rapid', '2026-04-17 14:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),

-- ── 4/18/2026 ──────────────────────────────────────────────────
-- Gery vs Mason — Draw (Gery listed first in match)
('bc0c3ae8-e75c-4199-bfe2-52f686dfca13', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'draw',        '10+0', 'rapid', '2026-04-18 09:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Mason beat Gery (White)
('7dd665f5-c37d-4625-93d5-41882c377ec0', 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13', 'white', 'player1_win', '10+0', 'rapid', '2026-04-18 09:30:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Top Rob beat Mason (White)
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'white', 'player1_win', '10+0', 'rapid', '2026-04-18 10:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Top Rob beat Mason (Black)
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'black', 'player1_win', '10+0', 'rapid', '2026-04-18 10:30:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0'),
-- Top Rob beat Mason (Black)
('41d449f6-c801-45c4-b394-3b53c989e194', '7dd665f5-c37d-4625-93d5-41882c377ec0', 'black', 'player1_win', '10+0', 'rapid', '2026-04-18 11:00:00+00', '7dd665f5-c37d-4625-93d5-41882c377ec0');


-- ────────────────────────────────────────────────────────────────
-- 4. Recalculate all ELO ratings from the inserted games
-- ────────────────────────────────────────────────────────────────
SELECT recalculate_alltime_elo();
SELECT recalculate_weekly_elo();
SELECT recalculate_monthly_elo();
