-- ================================================================
-- Popoyo Chess Club — Seed Data
-- Run AFTER schema.sql in the Supabase SQL editor.
--
-- All UUIDs are hardcoded for auditable FK relationships.
-- Dates use INTERVAL offsets from now() so the weekly/monthly
-- ELO windows always contain meaningful data regardless of run date.
--
-- Players:
--   001  Gerry       admin   NI
--   002  Top Rob     member  CR
--   003  Rafa        member  ES
--   004  Camila      member  AR
--   005  Kwame       member  GH
--   006  Nils        member  SE
--   007  Pax         viewer  US
--   008  Sofía       viewer  MX
-- ================================================================


-- ────────────────────────────────────────────────────────────────
-- Step 1: Insert admin into auth.users
-- Trigger fires → profile created with role='viewer' initially
-- ────────────────────────────────────────────────────────────────
INSERT INTO auth.users (
  id, instance_id, aud, role, email, encrypted_password,
  email_confirmed_at, last_sign_in_at,
  raw_app_meta_data, raw_user_meta_data,
  created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) VALUES (
  '00000000-0000-0000-0000-000000000001',
  '00000000-0000-0000-0000-000000000000',
  'authenticated', 'authenticated',
  'gerry@popoyochess.club',
  crypt('popoyo2024!', gen_salt('bf')),
  now() - INTERVAL '90 days',
  now() - INTERVAL '1 day',
  '{"provider":"email","providers":["email"]}',
  '{"nickname":"Gerry","country":"NI"}',
  now() - INTERVAL '90 days',
  now() - INTERVAL '1 day',
  '', '', '', ''
);


-- ────────────────────────────────────────────────────────────────
-- Step 2: Promote admin role
-- Triggers on_profile_role_set → inserts player_ratings row
-- ────────────────────────────────────────────────────────────────
UPDATE profiles
SET role = 'admin'
WHERE id = '00000000-0000-0000-0000-000000000001';


-- ────────────────────────────────────────────────────────────────
-- Step 3: Approved member email list (requires admin profile)
-- ────────────────────────────────────────────────────────────────
INSERT INTO approved_emails (id, email, added_by, created_at) VALUES
  ('00000000-0000-0000-0000-000000001001', 'rob@popoyochess.club',    '00000000-0000-0000-0000-000000000001', now() - INTERVAL '85 days'),
  ('00000000-0000-0000-0000-000000001002', 'rafa@popoyochess.club',   '00000000-0000-0000-0000-000000000001', now() - INTERVAL '85 days'),
  ('00000000-0000-0000-0000-000000001003', 'camila@popoyochess.club', '00000000-0000-0000-0000-000000000001', now() - INTERVAL '85 days'),
  ('00000000-0000-0000-0000-000000001004', 'kwame@popoyochess.club',  '00000000-0000-0000-0000-000000000001', now() - INTERVAL '84 days'),
  ('00000000-0000-0000-0000-000000001005', 'nils@popoyochess.club',   '00000000-0000-0000-0000-000000000001', now() - INTERVAL '84 days');


-- ────────────────────────────────────────────────────────────────
-- Step 4: Member signups
-- Trigger reads approved_emails → role='member' for each
-- Trigger on_profile_role_set → inserts player_ratings rows
-- ────────────────────────────────────────────────────────────────
INSERT INTO auth.users (
  id, instance_id, aud, role, email, encrypted_password,
  email_confirmed_at, last_sign_in_at,
  raw_app_meta_data, raw_user_meta_data,
  created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) VALUES
  (
    '00000000-0000-0000-0000-000000000002',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'rob@popoyochess.club',
    crypt('popoyo2024!', gen_salt('bf')),
    now() - INTERVAL '83 days',
    now() - INTERVAL '1 day',
    '{"provider":"email","providers":["email"]}',
    '{"nickname":"Top Rob","country":"CR"}',
    now() - INTERVAL '83 days',
    now() - INTERVAL '1 day',
    '', '', '', ''
  ),
  (
    '00000000-0000-0000-0000-000000000003',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'rafa@popoyochess.club',
    crypt('popoyo2024!', gen_salt('bf')),
    now() - INTERVAL '82 days',
    now() - INTERVAL '2 days',
    '{"provider":"email","providers":["email"]}',
    '{"nickname":"Rafa","country":"ES"}',
    now() - INTERVAL '82 days',
    now() - INTERVAL '2 days',
    '', '', '', ''
  ),
  (
    '00000000-0000-0000-0000-000000000004',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'camila@popoyochess.club',
    crypt('popoyo2024!', gen_salt('bf')),
    now() - INTERVAL '80 days',
    now() - INTERVAL '3 days',
    '{"provider":"email","providers":["email"]}',
    '{"nickname":"Camila","country":"AR"}',
    now() - INTERVAL '80 days',
    now() - INTERVAL '3 days',
    '', '', '', ''
  ),
  (
    '00000000-0000-0000-0000-000000000005',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'kwame@popoyochess.club',
    crypt('popoyo2024!', gen_salt('bf')),
    now() - INTERVAL '79 days',
    now() - INTERVAL '5 days',
    '{"provider":"email","providers":["email"]}',
    '{"nickname":"Kwame","country":"GH"}',
    now() - INTERVAL '79 days',
    now() - INTERVAL '5 days',
    '', '', '', ''
  ),
  (
    '00000000-0000-0000-0000-000000000006',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'nils@popoyochess.club',
    crypt('popoyo2024!', gen_salt('bf')),
    now() - INTERVAL '78 days',
    now() - INTERVAL '2 days',
    '{"provider":"email","providers":["email"]}',
    '{"nickname":"Nils","country":"SE"}',
    now() - INTERVAL '78 days',
    now() - INTERVAL '2 days',
    '', '', '', ''
  );


-- ────────────────────────────────────────────────────────────────
-- Step 5: Viewer signups (no approved email → role='viewer')
-- Accounts created from the game comment prompt, not /anteup
-- ────────────────────────────────────────────────────────────────
INSERT INTO auth.users (
  id, instance_id, aud, role, email, encrypted_password,
  email_confirmed_at, last_sign_in_at,
  raw_app_meta_data, raw_user_meta_data,
  created_at, updated_at,
  confirmation_token, email_change, email_change_token_new, recovery_token
) VALUES
  (
    '00000000-0000-0000-0000-000000000007',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'pax@gmail.com',
    crypt('popoyo2024!', gen_salt('bf')),
    now() - INTERVAL '30 days',
    now() - INTERVAL '1 day',
    '{"provider":"email","providers":["email"]}',
    '{"nickname":"Pax","country":"US"}',
    now() - INTERVAL '30 days',
    now() - INTERVAL '1 day',
    '', '', '', ''
  ),
  (
    '00000000-0000-0000-0000-000000000008',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'sofia@gmail.com',
    crypt('popoyo2024!', gen_salt('bf')),
    now() - INTERVAL '15 days',
    now() - INTERVAL '1 day',
    '{"provider":"email","providers":["email"]}',
    '{"nickname":"Sofía","country":"MX"}',
    now() - INTERVAL '15 days',
    now() - INTERVAL '1 day',
    '', '', '', ''
  );


-- ────────────────────────────────────────────────────────────────
-- Step 6: Games
--
-- Intervals guarantee correct ELO window coverage:
--   This week  (within current Mon–Sun):  1–5 days ago   → games 101–105
--   This month (within current 1st–now):  6–18 days ago  → games 106–115
--   March:                               19–49 days ago   → games 116–123
--   February:                            50–80 days ago   → games 124–128
--
-- player1 = winner (or first in draw), player2 = loser (or second)
-- ────────────────────────────────────────────────────────────────

-- ── This week ───────────────────────────────────────────────────

INSERT INTO games (
  id, player1_id, player2_id, player1_color, result,
  time_control, time_control_category,
  game_date, submitted_by,
  player1_photo_url, player2_photo_url
) VALUES

-- 101: Top Rob (W) beats Gerry — 1 day ago
(
  '00000000-0000-0000-0000-000000000101',
  '00000000-0000-0000-0000-000000000002',
  '00000000-0000-0000-0000-000000000001',
  'white', 'player1_win',
  '10+0', 'rapid',
  now() - INTERVAL '1 day',
  '00000000-0000-0000-0000-000000000002',
  'https://picsum.photos/seed/popoyo-g101-w/400/300',
  'https://picsum.photos/seed/popoyo-g101-l/400/300'
),

-- 102: Nils (W) beats Rafa — 2 days ago
(
  '00000000-0000-0000-0000-000000000102',
  '00000000-0000-0000-0000-000000000006',
  '00000000-0000-0000-0000-000000000003',
  'white', 'player1_win',
  '5+0', 'blitz',
  now() - INTERVAL '2 days',
  '00000000-0000-0000-0000-000000000006',
  'https://picsum.photos/seed/popoyo-g102-w/400/300',
  NULL
),

-- 103: Top Rob (B) beats Camila — 3 days ago
(
  '00000000-0000-0000-0000-000000000103',
  '00000000-0000-0000-0000-000000000002',
  '00000000-0000-0000-0000-000000000004',
  'black', 'player1_win',
  '10+0', 'rapid',
  now() - INTERVAL '3 days',
  '00000000-0000-0000-0000-000000000002',
  'https://picsum.photos/seed/popoyo-g103-w/400/300',
  NULL
),

-- 104: Gerry (W) draws Nils — 4 days ago
(
  '00000000-0000-0000-0000-000000000104',
  '00000000-0000-0000-0000-000000000001',
  '00000000-0000-0000-0000-000000000006',
  'white', 'draw',
  '15+10', 'rapid',
  now() - INTERVAL '4 days',
  '00000000-0000-0000-0000-000000000001',
  NULL, NULL
),

-- 105: Rafa (W) beats Kwame — 5 days ago
(
  '00000000-0000-0000-0000-000000000105',
  '00000000-0000-0000-0000-000000000003',
  '00000000-0000-0000-0000-000000000005',
  'white', 'player1_win',
  '3+0', 'blitz',
  now() - INTERVAL '5 days',
  '00000000-0000-0000-0000-000000000003',
  NULL, NULL
),

-- ── This month (not this week) ───────────────────────────────────

-- 106: Top Rob (W) beats Nils — 7 days ago
(
  '00000000-0000-0000-0000-000000000106',
  '00000000-0000-0000-0000-000000000002',
  '00000000-0000-0000-0000-000000000006',
  'white', 'player1_win',
  '10+0', 'rapid',
  now() - INTERVAL '7 days',
  '00000000-0000-0000-0000-000000000002',
  'https://picsum.photos/seed/popoyo-g106-w/400/300',
  NULL
),

-- 107: Camila (W) beats Kwame — 8 days ago
(
  '00000000-0000-0000-0000-000000000107',
  '00000000-0000-0000-0000-000000000004',
  '00000000-0000-0000-0000-000000000005',
  'white', 'player1_win',
  '10+5', 'rapid',
  now() - INTERVAL '8 days',
  '00000000-0000-0000-0000-000000000004',
  NULL, NULL
),

-- 108: Gerry (W) beats Rafa — 9 days ago
(
  '00000000-0000-0000-0000-000000000108',
  '00000000-0000-0000-0000-000000000001',
  '00000000-0000-0000-0000-000000000003',
  'white', 'player1_win',
  '10+0', 'rapid',
  now() - INTERVAL '9 days',
  '00000000-0000-0000-0000-000000000001',
  'https://picsum.photos/seed/popoyo-g108-w/400/300',
  NULL
),

-- 109: Kwame (B) beats Rafa — 10 days ago
(
  '00000000-0000-0000-0000-000000000109',
  '00000000-0000-0000-0000-000000000005',
  '00000000-0000-0000-0000-000000000003',
  'black', 'player1_win',
  '5+3', 'blitz',
  now() - INTERVAL '10 days',
  '00000000-0000-0000-0000-000000000005',
  NULL, NULL
),

-- 110: Nils (W) beats Camila — 12 days ago
(
  '00000000-0000-0000-0000-000000000110',
  '00000000-0000-0000-0000-000000000006',
  '00000000-0000-0000-0000-000000000004',
  'white', 'player1_win',
  '10+0', 'rapid',
  now() - INTERVAL '12 days',
  '00000000-0000-0000-0000-000000000006',
  'https://picsum.photos/seed/popoyo-g110-w/400/300',
  NULL
),

-- 111: Top Rob (B) beats Gerry — 14 days ago
(
  '00000000-0000-0000-0000-000000000111',
  '00000000-0000-0000-0000-000000000002',
  '00000000-0000-0000-0000-000000000001',
  'black', 'player1_win',
  '10+5', 'rapid',
  now() - INTERVAL '14 days',
  '00000000-0000-0000-0000-000000000002',
  'https://picsum.photos/seed/popoyo-g111-w/400/300',
  NULL
),

-- 112: Rafa (W) beats Camila — 15 days ago
(
  '00000000-0000-0000-0000-000000000112',
  '00000000-0000-0000-0000-000000000003',
  '00000000-0000-0000-0000-000000000004',
  'white', 'player1_win',
  '3+2', 'blitz',
  now() - INTERVAL '15 days',
  '00000000-0000-0000-0000-000000000003',
  NULL, NULL
),

-- 113: Kwame (W) beats Gerry — 16 days ago
(
  '00000000-0000-0000-0000-000000000113',
  '00000000-0000-0000-0000-000000000005',
  '00000000-0000-0000-0000-000000000001',
  'white', 'player1_win',
  '10+0', 'rapid',
  now() - INTERVAL '16 days',
  '00000000-0000-0000-0000-000000000005',
  NULL, NULL
),

-- 114: Nils (W) beats Kwame — 17 days ago
(
  '00000000-0000-0000-0000-000000000114',
  '00000000-0000-0000-0000-000000000006',
  '00000000-0000-0000-0000-000000000005',
  'white', 'player1_win',
  '5+0', 'blitz',
  now() - INTERVAL '17 days',
  '00000000-0000-0000-0000-000000000006',
  NULL, NULL
),

-- 115: Top Rob (W) beats Rafa — 18 days ago (classical)
(
  '00000000-0000-0000-0000-000000000115',
  '00000000-0000-0000-0000-000000000002',
  '00000000-0000-0000-0000-000000000003',
  'white', 'player1_win',
  '25+0', 'classical',
  now() - INTERVAL '18 days',
  '00000000-0000-0000-0000-000000000002',
  'https://picsum.photos/seed/popoyo-g115-w/400/300',
  'https://picsum.photos/seed/popoyo-g115-l/400/300'
),

-- ── March ────────────────────────────────────────────────────────

-- 116: Gerry (W) beats Top Rob — 20 days ago
(
  '00000000-0000-0000-0000-000000000116',
  '00000000-0000-0000-0000-000000000001',
  '00000000-0000-0000-0000-000000000002',
  'white', 'player1_win',
  '10+0', 'rapid',
  now() - INTERVAL '20 days',
  '00000000-0000-0000-0000-000000000001',
  'https://picsum.photos/seed/popoyo-g116-w/400/300',
  NULL
),

-- 117: Nils (B) beats Rafa — 22 days ago
(
  '00000000-0000-0000-0000-000000000117',
  '00000000-0000-0000-0000-000000000006',
  '00000000-0000-0000-0000-000000000003',
  'black', 'player1_win',
  '3+0', 'blitz',
  now() - INTERVAL '22 days',
  '00000000-0000-0000-0000-000000000006',
  NULL, NULL
),

-- 118: Camila (W) beats Kwame — 25 days ago
(
  '00000000-0000-0000-0000-000000000118',
  '00000000-0000-0000-0000-000000000004',
  '00000000-0000-0000-0000-000000000005',
  'white', 'player1_win',
  '10+0', 'rapid',
  now() - INTERVAL '25 days',
  '00000000-0000-0000-0000-000000000004',
  NULL, NULL
),

-- 119: Top Rob (W) beats Nils — 28 days ago
(
  '00000000-0000-0000-0000-000000000119',
  '00000000-0000-0000-0000-000000000002',
  '00000000-0000-0000-0000-000000000006',
  'white', 'player1_win',
  '10+5', 'rapid',
  now() - INTERVAL '28 days',
  '00000000-0000-0000-0000-000000000002',
  'https://picsum.photos/seed/popoyo-g119-w/400/300',
  NULL
),

-- 120: Rafa (W) draws Gerry — 30 days ago (classical)
(
  '00000000-0000-0000-0000-000000000120',
  '00000000-0000-0000-0000-000000000003',
  '00000000-0000-0000-0000-000000000001',
  'white', 'draw',
  '30+0', 'classical',
  now() - INTERVAL '30 days',
  '00000000-0000-0000-0000-000000000003',
  NULL, NULL
),

-- 121: Kwame (W) beats Camila — 33 days ago
(
  '00000000-0000-0000-0000-000000000121',
  '00000000-0000-0000-0000-000000000005',
  '00000000-0000-0000-0000-000000000004',
  'white', 'player1_win',
  '5+3', 'blitz',
  now() - INTERVAL '33 days',
  '00000000-0000-0000-0000-000000000005',
  NULL, NULL
),

-- 122: Gerry (W) beats Camila — 35 days ago
(
  '00000000-0000-0000-0000-000000000122',
  '00000000-0000-0000-0000-000000000001',
  '00000000-0000-0000-0000-000000000004',
  'white', 'player1_win',
  '10+0', 'rapid',
  now() - INTERVAL '35 days',
  '00000000-0000-0000-0000-000000000001',
  'https://picsum.photos/seed/popoyo-g122-w/400/300',
  NULL
),

-- 123: Nils (W) beats Top Rob — 37 days ago
(
  '00000000-0000-0000-0000-000000000123',
  '00000000-0000-0000-0000-000000000006',
  '00000000-0000-0000-0000-000000000002',
  'white', 'player1_win',
  '10+0', 'rapid',
  now() - INTERVAL '37 days',
  '00000000-0000-0000-0000-000000000006',
  NULL, NULL
),

-- ── February ─────────────────────────────────────────────────────

-- 124: Top Rob (W) beats Gerry — 52 days ago
(
  '00000000-0000-0000-0000-000000000124',
  '00000000-0000-0000-0000-000000000002',
  '00000000-0000-0000-0000-000000000001',
  'white', 'player1_win',
  '10+0', 'rapid',
  now() - INTERVAL '52 days',
  '00000000-0000-0000-0000-000000000002',
  'https://picsum.photos/seed/popoyo-g124-w/400/300',
  NULL
),

-- 125: Rafa (B) beats Kwame — 55 days ago
(
  '00000000-0000-0000-0000-000000000125',
  '00000000-0000-0000-0000-000000000003',
  '00000000-0000-0000-0000-000000000005',
  'black', 'player1_win',
  '5+0', 'blitz',
  now() - INTERVAL '55 days',
  '00000000-0000-0000-0000-000000000003',
  NULL, NULL
),

-- 126: Nils (W) draws Camila — 58 days ago
(
  '00000000-0000-0000-0000-000000000126',
  '00000000-0000-0000-0000-000000000006',
  '00000000-0000-0000-0000-000000000004',
  'white', 'draw',
  '15+10', 'rapid',
  now() - INTERVAL '58 days',
  '00000000-0000-0000-0000-000000000006',
  NULL, NULL
),

-- 127: Kwame (W) beats Rafa — 62 days ago
(
  '00000000-0000-0000-0000-000000000127',
  '00000000-0000-0000-0000-000000000005',
  '00000000-0000-0000-0000-000000000003',
  'white', 'player1_win',
  '3+0', 'blitz',
  now() - INTERVAL '62 days',
  '00000000-0000-0000-0000-000000000005',
  NULL, NULL
),

-- 128: Gerry (W) beats Nils — 65 days ago
(
  '00000000-0000-0000-0000-000000000128',
  '00000000-0000-0000-0000-000000000001',
  '00000000-0000-0000-0000-000000000006',
  'white', 'player1_win',
  '10+0', 'rapid',
  now() - INTERVAL '65 days',
  '00000000-0000-0000-0000-000000000001',
  'https://picsum.photos/seed/popoyo-g128-w/400/300',
  NULL
);


-- ────────────────────────────────────────────────────────────────
-- Step 7: Comments
-- Viewers comment on games; members comment too
-- ────────────────────────────────────────────────────────────────
INSERT INTO comments (id, game_id, user_id, body, created_at) VALUES

-- Viewer Pax comments on Top Rob's win over Gerry (game 101)
(
  '00000000-0000-0000-0000-000000000201',
  '00000000-0000-0000-0000-000000000101',
  '00000000-0000-0000-0000-000000000007',
  'Classic Rob — he always finds a way to convert those rook endgames.',
  now() - INTERVAL '23 hours'
),

-- Viewer Sofía also comments on game 101
(
  '00000000-0000-0000-0000-000000000202',
  '00000000-0000-0000-0000-000000000101',
  '00000000-0000-0000-0000-000000000008',
  'Gerry looked uncomfortable from move 20 onwards. The queenside was just gone.',
  now() - INTERVAL '20 hours'
),

-- Gerry (admin) replies to game 101 — self-deprecating
(
  '00000000-0000-0000-0000-000000000203',
  '00000000-0000-0000-0000-000000000101',
  '00000000-0000-0000-0000-000000000001',
  'I blundered the a-pawn and never recovered. Well played Rob.',
  now() - INTERVAL '18 hours'
),

-- Camila comments on game 102 (Nils beats Rafa)
(
  '00000000-0000-0000-0000-000000000204',
  '00000000-0000-0000-0000-000000000102',
  '00000000-0000-0000-0000-000000000004',
  'Nils in blitz this week is something else. Nobody is touching him under 10 minutes.',
  now() - INTERVAL '44 hours'
),

-- Rafa comments on his own loss (game 102)
(
  '00000000-0000-0000-0000-000000000205',
  '00000000-0000-0000-0000-000000000102',
  '00000000-0000-0000-0000-000000000003',
  'Dropped a piece on move 14. Deserved result honestly.',
  now() - INTERVAL '43 hours'
),

-- Pax comments on game 115 (Top Rob beats Rafa, classical)
(
  '00000000-0000-0000-0000-000000000206',
  '00000000-0000-0000-0000-000000000115',
  '00000000-0000-0000-0000-000000000007',
  'A classical game! Rob dismantled the Sicilian completely. How long did this one go?',
  now() - INTERVAL '17 days'
),

-- Rafa confirms on game 115
(
  '00000000-0000-0000-0000-000000000207',
  '00000000-0000-0000-0000-000000000115',
  '00000000-0000-0000-0000-000000000003',
  '64 moves. I had a fortress in the endgame but Rob found the only winning plan. Tough.',
  now() - INTERVAL '17 days'
),

-- Kwame comments on his win over Gerry (game 113)
(
  '00000000-0000-0000-0000-000000000208',
  '00000000-0000-0000-0000-000000000113',
  '00000000-0000-0000-0000-000000000005',
  'First win over an admin. Big moment for me. The king walk on the kingside just worked.',
  now() - INTERVAL '15 days' - INTERVAL '20 hours'
),

-- Sofía comments on game 116 (Gerry beats Top Rob, March)
(
  '00000000-0000-0000-0000-000000000209',
  '00000000-0000-0000-0000-000000000116',
  '00000000-0000-0000-0000-000000000008',
  'Gerry taking down the top seed! The e5 break was the turning point.',
  now() - INTERVAL '19 days' - INTERVAL '12 hours'
),

-- Nils comments on game 128 (Gerry beats Nils, February)
(
  '00000000-0000-0000-0000-000000000210',
  '00000000-0000-0000-0000-000000000128',
  '00000000-0000-0000-0000-000000000006',
  'Gerry played this one perfectly. I never got the queenside counterplay going. Rematch soon.',
  now() - INTERVAL '64 days' - INTERVAL '18 hours'
);


-- ────────────────────────────────────────────────────────────────
-- Step 8: Compute ELO ratings from all inserted games
-- These functions recalculate from scratch and upsert player_ratings
-- ────────────────────────────────────────────────────────────────
SELECT recalculate_alltime_elo();
SELECT recalculate_weekly_elo();
SELECT recalculate_monthly_elo();


-- ────────────────────────────────────────────────────────────────
-- Step 9: Historical weekly winners (closed weeks, already snapshotted)
--
-- These represent weeks that ended before the current week began.
-- ELO values are plausible given the game history above.
-- week_start must always be a Monday.
-- ────────────────────────────────────────────────────────────────

-- Find the Monday that started the previous closed week
-- (2 weeks ago Monday, so it's definitively before the current week)
INSERT INTO weekly_winners (
  id, week_start, player_id, peak_elo,
  wins, losses, draws, games_played,
  victory_photo_url, created_at
) VALUES

-- Two weeks ago: Top Rob wins, 3–1–0, peak 1564
(
  '00000000-0000-0000-0000-000000002001',
  (date_trunc('week', now()) - INTERVAL '7 days')::date,
  '00000000-0000-0000-0000-000000000002',
  1564,
  3, 1, 0, 4,
  'https://picsum.photos/seed/popoyo-g106-w/400/300',
  date_trunc('week', now()) - INTERVAL '1 day'
),

-- Three weeks ago: Nils wins, 2–1–1, peak 1548
(
  '00000000-0000-0000-0000-000000002002',
  (date_trunc('week', now()) - INTERVAL '14 days')::date,
  '00000000-0000-0000-0000-000000000006',
  1548,
  2, 1, 1, 4,
  'https://picsum.photos/seed/popoyo-g110-w/400/300',
  date_trunc('week', now()) - INTERVAL '8 days'
),

-- Four weeks ago: Gerry wins, 2–1–0, peak 1537
(
  '00000000-0000-0000-0000-000000002003',
  (date_trunc('week', now()) - INTERVAL '21 days')::date,
  '00000000-0000-0000-0000-000000000001',
  1537,
  2, 1, 0, 3,
  'https://picsum.photos/seed/popoyo-g116-w/400/300',
  date_trunc('week', now()) - INTERVAL '15 days'
),

-- Five weeks ago: Top Rob wins, 3–0–0, peak 1571
(
  '00000000-0000-0000-0000-000000002004',
  (date_trunc('week', now()) - INTERVAL '28 days')::date,
  '00000000-0000-0000-0000-000000000002',
  1571,
  3, 0, 0, 3,
  'https://picsum.photos/seed/popoyo-g119-w/400/300',
  date_trunc('week', now()) - INTERVAL '22 days'
),

-- Six weeks ago: Nils wins, 2–0–1, peak 1543
(
  '00000000-0000-0000-0000-000000002005',
  (date_trunc('week', now()) - INTERVAL '35 days')::date,
  '00000000-0000-0000-0000-000000000006',
  1543,
  2, 0, 1, 3,
  NULL,
  date_trunc('week', now()) - INTERVAL '29 days'
);


-- ────────────────────────────────────────────────────────────────
-- Step 10: Historical monthly winners (closed months)
-- month_start must always be the 1st of the month
-- ────────────────────────────────────────────────────────────────

-- Find the start of the previous closed month
INSERT INTO monthly_winners (
  id, month_start, player_id, peak_elo,
  wins, losses, draws, games_played,
  victory_photo_url, created_at
) VALUES

-- Last month (March 2026): Top Rob wins, 4–2–1, peak 1578
(
  '00000000-0000-0000-0000-000000003001',
  (date_trunc('month', now()) - INTERVAL '1 month')::date,
  '00000000-0000-0000-0000-000000000002',
  1578,
  4, 2, 1, 7,
  'https://picsum.photos/seed/popoyo-g119-w/400/300',
  date_trunc('month', now()) - INTERVAL '1 day'
),

-- Two months ago (February 2026): Nils wins, 2–1–1, peak 1541
(
  '00000000-0000-0000-0000-000000003002',
  (date_trunc('month', now()) - INTERVAL '2 months')::date,
  '00000000-0000-0000-0000-000000000006',
  1541,
  2, 1, 1, 4,
  'https://picsum.photos/seed/popoyo-g128-w/400/300',
  date_trunc('month', now()) - INTERVAL '32 days'
);
