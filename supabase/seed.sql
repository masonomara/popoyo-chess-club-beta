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
  ('1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', 'gguij002@gmail.com',      'Gery',    'CU', 'admin'),
  ('453928ea-dffe-484f-be7a-30bf8ed16132', 'mason.omara@gmail.com',   'Mason',   'US', 'admin'),
  ('656d61e9-171d-4dbd-8090-fc22229cdb61', 'robadair@gmail.com',      'Austin',  'US', 'member'),
  ('76a3157a-a3d7-4831-a360-71fc468f939b', 'robemmerson15@gmail.com', 'Top Rob', 'GB', 'member')
ON CONFLICT (id) DO UPDATE SET
  nickname = EXCLUDED.nickname,
  country  = EXCLUDED.country,
  role     = EXCLUDED.role;


-- ────────────────────────────────────────────────────────────────
-- 2. Approved emails
-- Mason (admin) pre-approves all members.
-- ────────────────────────────────────────────────────────────────
INSERT INTO approved_emails (email, added_by) VALUES
  ('gguij002@gmail.com',      '453928ea-dffe-484f-be7a-30bf8ed16132'),
  ('robadair@gmail.com',      '453928ea-dffe-484f-be7a-30bf8ed16132'),
  ('robemmerson15@gmail.com', '453928ea-dffe-484f-be7a-30bf8ed16132'),
  ('mason.omara@gmail.com',   '453928ea-dffe-484f-be7a-30bf8ed16132')
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
--   Gery    = 1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75
--   Mason   = 453928ea-dffe-484f-be7a-30bf8ed16132
--   Austin  = 656d61e9-171d-4dbd-8090-fc22229cdb61
--   Top Rob = 76a3157a-a3d7-4831-a360-71fc468f939b

INSERT INTO games (player1_id, player2_id, player1_color, result, time_control, time_control_category, game_date, submitted_by) VALUES

-- ── 4/12/2026 ──────────────────────────────────────────────────
-- Gery beat Top Rob (White)
('1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', '76a3157a-a3d7-4831-a360-71fc468f939b', 'white', 'player1_win', '10+0', 'rapid', '2026-04-12 09:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Gery beat Top Rob (Black)
('1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', '76a3157a-a3d7-4831-a360-71fc468f939b', 'black', 'player1_win', '10+0', 'rapid', '2026-04-12 09:30:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),

-- ── 4/13/2026 ──────────────────────────────────────────────────
-- Top Rob beat Gery (Black)
('76a3157a-a3d7-4831-a360-71fc468f939b', '1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', 'black', 'player1_win', '10+0', 'rapid', '2026-04-13 09:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Mason beat Top Rob (White)
('453928ea-dffe-484f-be7a-30bf8ed16132', '76a3157a-a3d7-4831-a360-71fc468f939b', 'white', 'player1_win', '10+0', 'rapid', '2026-04-13 09:30:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Gery beat Mason (White)
('1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', '453928ea-dffe-484f-be7a-30bf8ed16132', 'white', 'player1_win', '10+0', 'rapid', '2026-04-13 10:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Gery beat Mason (Black)
('1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', '453928ea-dffe-484f-be7a-30bf8ed16132', 'black', 'player1_win', '10+0', 'rapid', '2026-04-13 10:30:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Mason beat Austin (White)
('453928ea-dffe-484f-be7a-30bf8ed16132', '656d61e9-171d-4dbd-8090-fc22229cdb61', 'white', 'player1_win', '10+0', 'rapid', '2026-04-13 11:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Austin beat Gery (Black)
('656d61e9-171d-4dbd-8090-fc22229cdb61', '1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', 'black', 'player1_win', '10+0', 'rapid', '2026-04-13 11:30:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Gery beat Austin (Black)
('1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', '656d61e9-171d-4dbd-8090-fc22229cdb61', 'black', 'player1_win', '10+0', 'rapid', '2026-04-13 12:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),

-- ── 4/14/2026 ──────────────────────────────────────────────────
-- Mason beat Gery (Black)
('453928ea-dffe-484f-be7a-30bf8ed16132', '1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', 'black', 'player1_win', '10+0', 'rapid', '2026-04-14 09:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Gery beat Mason (White)
('1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', '453928ea-dffe-484f-be7a-30bf8ed16132', 'white', 'player1_win', '10+0', 'rapid', '2026-04-14 09:30:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Top Rob beat Mason (White)
('76a3157a-a3d7-4831-a360-71fc468f939b', '453928ea-dffe-484f-be7a-30bf8ed16132', 'white', 'player1_win', '10+0', 'rapid', '2026-04-14 10:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Top Rob beat Mason (Black)
('76a3157a-a3d7-4831-a360-71fc468f939b', '453928ea-dffe-484f-be7a-30bf8ed16132', 'black', 'player1_win', '10+0', 'rapid', '2026-04-14 10:30:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Top Rob beat Mason (White)
('76a3157a-a3d7-4831-a360-71fc468f939b', '453928ea-dffe-484f-be7a-30bf8ed16132', 'white', 'player1_win', '10+0', 'rapid', '2026-04-14 11:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Top Rob beat Austin (White)
('76a3157a-a3d7-4831-a360-71fc468f939b', '656d61e9-171d-4dbd-8090-fc22229cdb61', 'white', 'player1_win', '10+0', 'rapid', '2026-04-14 11:30:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Gery vs Austin — Draw (Gery listed first in match)
('1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', '656d61e9-171d-4dbd-8090-fc22229cdb61', 'white', 'draw',        '10+0', 'rapid', '2026-04-14 12:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Top Rob beat Gery (Black)
('76a3157a-a3d7-4831-a360-71fc468f939b', '1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', 'black', 'player1_win', '10+0', 'rapid', '2026-04-14 12:30:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Gery vs Top Rob — Draw (Gery listed first in match)
('1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', '76a3157a-a3d7-4831-a360-71fc468f939b', 'white', 'draw',        '10+0', 'rapid', '2026-04-14 13:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Mason beat Top Rob (White)
('453928ea-dffe-484f-be7a-30bf8ed16132', '76a3157a-a3d7-4831-a360-71fc468f939b', 'white', 'player1_win', '10+0', 'rapid', '2026-04-14 13:30:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Gery beat Mason (Black)
('1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', '453928ea-dffe-484f-be7a-30bf8ed16132', 'black', 'player1_win', '10+0', 'rapid', '2026-04-14 14:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Top Rob beat Austin (Black)
('76a3157a-a3d7-4831-a360-71fc468f939b', '656d61e9-171d-4dbd-8090-fc22229cdb61', 'black', 'player1_win', '10+0', 'rapid', '2026-04-14 14:30:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),

-- ── 4/15/2026 ──────────────────────────────────────────────────
-- Mason beat Gery (White)
('453928ea-dffe-484f-be7a-30bf8ed16132', '1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', 'white', 'player1_win', '10+0', 'rapid', '2026-04-15 09:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Gery beat Mason (White)
('1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', '453928ea-dffe-484f-be7a-30bf8ed16132', 'white', 'player1_win', '10+0', 'rapid', '2026-04-15 09:30:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Gery beat Mason (Black)
('1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', '453928ea-dffe-484f-be7a-30bf8ed16132', 'black', 'player1_win', '10+0', 'rapid', '2026-04-15 10:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Gery beat Mason (White)
('1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', '453928ea-dffe-484f-be7a-30bf8ed16132', 'white', 'player1_win', '10+0', 'rapid', '2026-04-15 10:30:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Gery beat Austin (White)
('1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', '656d61e9-171d-4dbd-8090-fc22229cdb61', 'white', 'player1_win', '10+0', 'rapid', '2026-04-15 11:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Top Rob beat Mason (Black)
('76a3157a-a3d7-4831-a360-71fc468f939b', '453928ea-dffe-484f-be7a-30bf8ed16132', 'black', 'player1_win', '10+0', 'rapid', '2026-04-15 11:30:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Top Rob beat Austin (Black)
('76a3157a-a3d7-4831-a360-71fc468f939b', '656d61e9-171d-4dbd-8090-fc22229cdb61', 'black', 'player1_win', '10+0', 'rapid', '2026-04-15 12:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Top Rob beat Mason (White)
('76a3157a-a3d7-4831-a360-71fc468f939b', '453928ea-dffe-484f-be7a-30bf8ed16132', 'white', 'player1_win', '10+0', 'rapid', '2026-04-15 12:30:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Top Rob beat Mason (White)
('76a3157a-a3d7-4831-a360-71fc468f939b', '453928ea-dffe-484f-be7a-30bf8ed16132', 'white', 'player1_win', '10+0', 'rapid', '2026-04-15 13:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Top Rob beat Austin (Black)
('76a3157a-a3d7-4831-a360-71fc468f939b', '656d61e9-171d-4dbd-8090-fc22229cdb61', 'black', 'player1_win', '10+0', 'rapid', '2026-04-15 13:30:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Top Rob beat Mason (Black)
('76a3157a-a3d7-4831-a360-71fc468f939b', '453928ea-dffe-484f-be7a-30bf8ed16132', 'black', 'player1_win', '10+0', 'rapid', '2026-04-15 14:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Top Rob beat Mason (White)
('76a3157a-a3d7-4831-a360-71fc468f939b', '453928ea-dffe-484f-be7a-30bf8ed16132', 'white', 'player1_win', '10+0', 'rapid', '2026-04-15 14:30:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Top Rob beat Mason (Black)
('76a3157a-a3d7-4831-a360-71fc468f939b', '453928ea-dffe-484f-be7a-30bf8ed16132', 'black', 'player1_win', '10+0', 'rapid', '2026-04-15 15:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),

-- ── 4/16/2026 ──────────────────────────────────────────────────
-- Gery beat Top Rob (White)
('1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', '76a3157a-a3d7-4831-a360-71fc468f939b', 'white', 'player1_win', '10+0', 'rapid', '2026-04-16 09:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Mason beat Top Rob (White)
('453928ea-dffe-484f-be7a-30bf8ed16132', '76a3157a-a3d7-4831-a360-71fc468f939b', 'white', 'player1_win', '10+0', 'rapid', '2026-04-16 09:30:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Top Rob beat Mason (White)
('76a3157a-a3d7-4831-a360-71fc468f939b', '453928ea-dffe-484f-be7a-30bf8ed16132', 'white', 'player1_win', '10+0', 'rapid', '2026-04-16 10:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Mason beat Austin (Black)
('453928ea-dffe-484f-be7a-30bf8ed16132', '656d61e9-171d-4dbd-8090-fc22229cdb61', 'black', 'player1_win', '10+0', 'rapid', '2026-04-16 10:30:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Gery beat Mason (White)
('1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', '453928ea-dffe-484f-be7a-30bf8ed16132', 'white', 'player1_win', '10+0', 'rapid', '2026-04-16 11:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Top Rob beat Gery (White)
('76a3157a-a3d7-4831-a360-71fc468f939b', '1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', 'white', 'player1_win', '10+0', 'rapid', '2026-04-16 11:30:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Gery beat Mason (Black)
('1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', '453928ea-dffe-484f-be7a-30bf8ed16132', 'black', 'player1_win', '10+0', 'rapid', '2026-04-16 12:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),

-- ── 4/17/2026 ──────────────────────────────────────────────────
-- Mason beat Gery (White)
('453928ea-dffe-484f-be7a-30bf8ed16132', '1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', 'white', 'player1_win', '10+0', 'rapid', '2026-04-17 09:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Mason beat Austin (White)
('453928ea-dffe-484f-be7a-30bf8ed16132', '656d61e9-171d-4dbd-8090-fc22229cdb61', 'white', 'player1_win', '10+0', 'rapid', '2026-04-17 09:30:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Mason beat Gery (Black)
('453928ea-dffe-484f-be7a-30bf8ed16132', '1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', 'black', 'player1_win', '10+0', 'rapid', '2026-04-17 10:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Mason beat Top Rob (White)
('453928ea-dffe-484f-be7a-30bf8ed16132', '76a3157a-a3d7-4831-a360-71fc468f939b', 'white', 'player1_win', '10+0', 'rapid', '2026-04-17 10:30:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Top Rob beat Mason (White)
('76a3157a-a3d7-4831-a360-71fc468f939b', '453928ea-dffe-484f-be7a-30bf8ed16132', 'white', 'player1_win', '10+0', 'rapid', '2026-04-17 11:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Top Rob beat Gery (White)
('76a3157a-a3d7-4831-a360-71fc468f939b', '1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', 'white', 'player1_win', '10+0', 'rapid', '2026-04-17 11:30:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Top Rob beat Gery (Black)
('76a3157a-a3d7-4831-a360-71fc468f939b', '1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', 'black', 'player1_win', '10+0', 'rapid', '2026-04-17 12:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Gery beat Top Rob (White)
('1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', '76a3157a-a3d7-4831-a360-71fc468f939b', 'white', 'player1_win', '10+0', 'rapid', '2026-04-17 12:30:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Mason beat Austin (White)
('453928ea-dffe-484f-be7a-30bf8ed16132', '656d61e9-171d-4dbd-8090-fc22229cdb61', 'white', 'player1_win', '10+0', 'rapid', '2026-04-17 13:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Austin beat Mason (White)
('656d61e9-171d-4dbd-8090-fc22229cdb61', '453928ea-dffe-484f-be7a-30bf8ed16132', 'white', 'player1_win', '10+0', 'rapid', '2026-04-17 13:30:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Top Rob beat Austin (White)
('76a3157a-a3d7-4831-a360-71fc468f939b', '656d61e9-171d-4dbd-8090-fc22229cdb61', 'white', 'player1_win', '10+0', 'rapid', '2026-04-17 14:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),

-- ── 4/18/2026 ──────────────────────────────────────────────────
-- Gery vs Mason — Draw (Gery listed first in match)
('1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', '453928ea-dffe-484f-be7a-30bf8ed16132', 'white', 'draw',        '10+0', 'rapid', '2026-04-18 09:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Mason beat Gery (White)
('453928ea-dffe-484f-be7a-30bf8ed16132', '1e5ca91f-5ed0-4c5d-997c-b3c472ed5d75', 'white', 'player1_win', '10+0', 'rapid', '2026-04-18 09:30:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Top Rob beat Mason (White)
('76a3157a-a3d7-4831-a360-71fc468f939b', '453928ea-dffe-484f-be7a-30bf8ed16132', 'white', 'player1_win', '10+0', 'rapid', '2026-04-18 10:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Top Rob beat Mason (Black)
('76a3157a-a3d7-4831-a360-71fc468f939b', '453928ea-dffe-484f-be7a-30bf8ed16132', 'black', 'player1_win', '10+0', 'rapid', '2026-04-18 10:30:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132'),
-- Top Rob beat Mason (Black)
('76a3157a-a3d7-4831-a360-71fc468f939b', '453928ea-dffe-484f-be7a-30bf8ed16132', 'black', 'player1_win', '10+0', 'rapid', '2026-04-18 11:00:00+00', '453928ea-dffe-484f-be7a-30bf8ed16132');


-- ────────────────────────────────────────────────────────────────
-- 4. Recalculate all ELO ratings from the inserted games
-- ────────────────────────────────────────────────────────────────
SELECT recalculate_alltime_elo();
SELECT recalculate_weekly_elo();
SELECT recalculate_monthly_elo();
