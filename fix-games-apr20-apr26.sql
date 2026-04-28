-- Fix games Apr 20–26
-- Run this in the Supabase SQL editor.
--
-- Player IDs:
--   Rob Emmerson  = 41d449f6-c801-45c4-b394-3b53c989e194
--   Gery          = bc0c3ae8-e75c-4199-bfe2-52f686dfca13
--   Mason         = 7dd665f5-c37d-4625-93d5-41882c377ec0
--   Rob Adair     = be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54

BEGIN;

-- ─────────────────────────────────────────────────
-- DELETE 6 wrong records
-- ─────────────────────────────────────────────────

-- Apr 20: Mason never played. These 3 rows were fabricated by the batch import.
DELETE FROM games WHERE id = '26066a51-ee67-449a-8ebc-7d1cf6658a57'; -- Gery(black) vs Mason
DELETE FROM games WHERE id = 'cd963ff6-7733-4418-af73-4dcc4c175fb4'; -- Rob_E(black) vs Mason
DELETE FROM games WHERE id = '3d2747b7-b89d-49ac-9ce7-89e9b4f01e39'; -- Rob_E(white) vs Mason

-- Apr 24: Only 2 games were played (Gery beat Rob, Rob beat Gery).
-- These 3 rows were entered retroactively on Apr 26 and have no source in the WhatsApp log.
DELETE FROM games WHERE id = '17191e8c-f49a-43e4-8ed4-20d0143c5984'; -- Rob_E(white) vs Mason
DELETE FROM games WHERE id = 'd265831b-ef67-45ca-9128-6e04db88234f'; -- Rob_E(white) vs Gery
DELETE FROM games WHERE id = '0da7937a-3797-48c1-8d17-53f3669069dc'; -- Gery(white) vs Rob_E

-- ─────────────────────────────────────────────────
-- INSERT 3 missing Apr 26 games
-- ─────────────────────────────────────────────────

INSERT INTO games (player1_id, player2_id, player1_color, result, time_control, time_control_category, game_date, submitted_by)
VALUES
  -- 10:37 AM: Gery (white) beat Rob
  (
    'bc0c3ae8-e75c-4199-bfe2-52f686dfca13',
    '41d449f6-c801-45c4-b394-3b53c989e194',
    'white', 'player1_win', '10+0', 'rapid',
    '2026-04-26 17:37:22+00',
    '7dd665f5-c37d-4625-93d5-41882c377ec0'
  ),
  -- 10:56 AM: Rob (white) beat Gery
  (
    '41d449f6-c801-45c4-b394-3b53c989e194',
    'bc0c3ae8-e75c-4199-bfe2-52f686dfca13',
    'white', 'player1_win', '10+0', 'rapid',
    '2026-04-26 17:56:56+00',
    '7dd665f5-c37d-4625-93d5-41882c377ec0'
  ),
  -- 11:16 AM: Rob (black) beat Mason
  (
    '41d449f6-c801-45c4-b394-3b53c989e194',
    '7dd665f5-c37d-4625-93d5-41882c377ec0',
    'black', 'player1_win', '10+0', 'rapid',
    '2026-04-26 18:16:32+00',
    '7dd665f5-c37d-4625-93d5-41882c377ec0'
  );

COMMIT;
