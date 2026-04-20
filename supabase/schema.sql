-- ================================================================
-- Popoyo Chess Club — Postgres Schema
-- Paste into the Supabase SQL editor and run.
-- ================================================================


-- ────────────────────────────────────────────────────────────────
-- Extensions
-- ────────────────────────────────────────────────────────────────
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
-- pg_cron: enable via Supabase Dashboard → Database → Extensions → pg_cron
-- Then run supabase/cron.sql to register the schedules.


-- ────────────────────────────────────────────────────────────────
-- Enums
-- ────────────────────────────────────────────────────────────────
CREATE TYPE user_role             AS ENUM ('admin', 'member', 'viewer');
CREATE TYPE piece_color           AS ENUM ('white', 'black');
CREATE TYPE game_result           AS ENUM ('player1_win', 'player2_win', 'draw');
CREATE TYPE time_control_category AS ENUM ('bullet', 'blitz', 'rapid', 'classical');


-- ────────────────────────────────────────────────────────────────
-- profiles
-- Mirror of auth.users with app-level fields.
-- Created automatically by the handle_new_user trigger.
-- ────────────────────────────────────────────────────────────────
CREATE TABLE profiles (
  id         UUID       PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email      TEXT       NOT NULL UNIQUE,
  nickname   TEXT       NOT NULL,
  country    TEXT       NOT NULL,
  role       user_role  NOT NULL DEFAULT 'viewer',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);


-- ────────────────────────────────────────────────────────────────
-- approved_emails
-- Admin-curated list of emails that may register as members.
-- ────────────────────────────────────────────────────────────────
CREATE TABLE approved_emails (
  id         UUID  PRIMARY KEY DEFAULT gen_random_uuid(),
  email      TEXT  NOT NULL UNIQUE,
  -- RESTRICT: keep the audit record even if the approving admin leaves
  added_by   UUID  NOT NULL REFERENCES profiles(id) ON DELETE RESTRICT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);


-- ────────────────────────────────────────────────────────────────
-- games
-- player1 = winner (or first player in a draw)
-- player2 = loser  (or second player in a draw)
-- ────────────────────────────────────────────────────────────────
CREATE TABLE games (
  id                    UUID                   PRIMARY KEY DEFAULT gen_random_uuid(),
  -- RESTRICT on all player refs: preserve history if a profile is removed
  player1_id            UUID                   NOT NULL REFERENCES profiles(id) ON DELETE RESTRICT,
  player2_id            UUID                   NOT NULL REFERENCES profiles(id) ON DELETE RESTRICT,
  player1_color         piece_color            NOT NULL,
  result                game_result            NOT NULL,
  time_control          TEXT                   NOT NULL,
  time_control_category time_control_category  NOT NULL,
  game_date             TIMESTAMPTZ            NOT NULL,
  submitted_by          UUID                   NOT NULL REFERENCES profiles(id) ON DELETE RESTRICT,
  player1_photo_url     TEXT,
  player2_photo_url     TEXT,
  created_at            TIMESTAMPTZ            NOT NULL DEFAULT now(),

  CONSTRAINT different_players CHECK (player1_id != player2_id),
  CONSTRAINT valid_time_control CHECK (time_control IN (
    '0+1','1+0','1+1','2+1',
    '3+0','3+2','5+0','5+3',
    '10+0','10+5','15+0','15+10',
    '25+0','30+0','30+20','60+0'
  ))
);


-- ────────────────────────────────────────────────────────────────
-- comments
-- Visible on individual game pages; any authenticated user may post.
-- ────────────────────────────────────────────────────────────────
CREATE TABLE comments (
  id         UUID  PRIMARY KEY DEFAULT gen_random_uuid(),
  game_id    UUID  NOT NULL REFERENCES games(id)    ON DELETE CASCADE,
  user_id    UUID  NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  body       TEXT  NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);


-- ────────────────────────────────────────────────────────────────
-- player_ratings
-- Denormalized current ELO + stats for every rating window.
-- Written exclusively by SECURITY DEFINER recalculation functions.
-- One row per member/admin; created by the on_profile_role_set trigger.
-- ────────────────────────────────────────────────────────────────
CREATE TABLE player_ratings (
  player_id UUID PRIMARY KEY REFERENCES profiles(id) ON DELETE CASCADE,

  -- All-time: K=40 first 20 games, K=32 after; never resets
  alltime_elo          INTEGER NOT NULL DEFAULT 1500,
  alltime_games_played INTEGER NOT NULL DEFAULT 0,
  alltime_wins         INTEGER NOT NULL DEFAULT 0,
  alltime_losses       INTEGER NOT NULL DEFAULT 0,
  alltime_draws        INTEGER NOT NULL DEFAULT 0,

  -- Weekly: resets Monday 00:00 UTC; K=64 always
  weekly_elo           INTEGER NOT NULL DEFAULT 1500,
  weekly_games_played  INTEGER NOT NULL DEFAULT 0,
  weekly_wins          INTEGER NOT NULL DEFAULT 0,
  weekly_losses        INTEGER NOT NULL DEFAULT 0,
  weekly_draws         INTEGER NOT NULL DEFAULT 0,

  -- Monthly: resets 1st of month 00:00 UTC; K=48 always
  monthly_elo          INTEGER NOT NULL DEFAULT 1500,
  monthly_games_played INTEGER NOT NULL DEFAULT 0,
  monthly_wins         INTEGER NOT NULL DEFAULT 0,
  monthly_losses       INTEGER NOT NULL DEFAULT 0,
  monthly_draws        INTEGER NOT NULL DEFAULT 0,

  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);


-- ────────────────────────────────────────────────────────────────
-- weekly_winners
-- Snapshot of each week's top player, taken before the Monday reset.
-- ────────────────────────────────────────────────────────────────
CREATE TABLE weekly_winners (
  id                UUID  PRIMARY KEY DEFAULT gen_random_uuid(),
  week_start        DATE  NOT NULL UNIQUE,   -- always a Monday
  -- RESTRICT: historical record must outlast profile deletion
  player_id         UUID  NOT NULL REFERENCES profiles(id) ON DELETE RESTRICT,
  peak_elo          INTEGER NOT NULL,
  wins              INTEGER NOT NULL DEFAULT 0,
  losses            INTEGER NOT NULL DEFAULT 0,
  draws             INTEGER NOT NULL DEFAULT 0,
  games_played      INTEGER NOT NULL DEFAULT 0,
  victory_photo_url TEXT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);


-- ────────────────────────────────────────────────────────────────
-- monthly_winners
-- ────────────────────────────────────────────────────────────────
CREATE TABLE monthly_winners (
  id                UUID  PRIMARY KEY DEFAULT gen_random_uuid(),
  month_start       DATE  NOT NULL UNIQUE,   -- always the 1st
  -- RESTRICT: historical record must outlast profile deletion
  player_id         UUID  NOT NULL REFERENCES profiles(id) ON DELETE RESTRICT,
  peak_elo          INTEGER NOT NULL,
  wins              INTEGER NOT NULL DEFAULT 0,
  losses            INTEGER NOT NULL DEFAULT 0,
  draws             INTEGER NOT NULL DEFAULT 0,
  games_played      INTEGER NOT NULL DEFAULT 0,
  victory_photo_url TEXT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);


-- ────────────────────────────────────────────────────────────────
-- Indexes
-- ────────────────────────────────────────────────────────────────

-- FK indexes (Postgres does not auto-create these)
CREATE INDEX idx_approved_emails_added_by     ON approved_emails(added_by);
CREATE INDEX idx_games_player1_id             ON games(player1_id);
CREATE INDEX idx_games_player2_id             ON games(player2_id);
CREATE INDEX idx_games_submitted_by           ON games(submitted_by);
CREATE INDEX idx_comments_game_id             ON comments(game_id);
CREATE INDEX idx_comments_user_id             ON comments(user_id);
CREATE INDEX idx_weekly_winners_player_id     ON weekly_winners(player_id);
CREATE INDEX idx_monthly_winners_player_id    ON monthly_winners(player_id);

-- Game history list (most recent first)
CREATE INDEX idx_games_game_date_desc         ON games(game_date DESC);

-- ELO recalculation ordering (chronological, ties broken by entry order)
CREATE INDEX idx_games_elo_order              ON games(game_date ASC, created_at ASC);

-- Victory photo lookups per player per period
CREATE INDEX idx_games_p1_win_photo           ON games(player1_id, result, game_date DESC)
  WHERE result = 'player1_win' AND player1_photo_url IS NOT NULL;
CREATE INDEX idx_games_p2_win_photo           ON games(player2_id, result, game_date DESC)
  WHERE result = 'player2_win' AND player2_photo_url IS NOT NULL;

-- Leaderboard sorts
CREATE INDEX idx_player_ratings_alltime_elo   ON player_ratings(alltime_elo DESC);
CREATE INDEX idx_player_ratings_weekly_elo    ON player_ratings(weekly_elo DESC);
CREATE INDEX idx_player_ratings_monthly_elo   ON player_ratings(monthly_elo DESC);

-- Historical winner pages (reverse chron)
CREATE INDEX idx_weekly_winners_week_start    ON weekly_winners(week_start DESC);
CREATE INDEX idx_monthly_winners_month_start  ON monthly_winners(month_start DESC);

-- Signup approved-email check
CREATE INDEX idx_approved_emails_email        ON approved_emails(email);

-- Comment section order
CREATE INDEX idx_comments_game_created        ON comments(game_id, created_at DESC);


-- ────────────────────────────────────────────────────────────────
-- Row Level Security — enable on every table
-- ────────────────────────────────────────────────────────────────
ALTER TABLE profiles        ENABLE ROW LEVEL SECURITY;
ALTER TABLE approved_emails ENABLE ROW LEVEL SECURITY;
ALTER TABLE games           ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments        ENABLE ROW LEVEL SECURITY;
ALTER TABLE player_ratings  ENABLE ROW LEVEL SECURITY;
ALTER TABLE weekly_winners  ENABLE ROW LEVEL SECURITY;
ALTER TABLE monthly_winners ENABLE ROW LEVEL SECURITY;


-- ────────────────────────────────────────────────────────────────
-- Helper: current user's role (SECURITY DEFINER breaks RLS recursion)
-- ────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION get_user_role()
RETURNS user_role
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT role FROM profiles WHERE id = auth.uid();
$$;

-- Convenience RPC: used by signup server action to validate an email
-- without requiring service-role access to the approved_emails table.
CREATE OR REPLACE FUNCTION is_email_approved(p_email TEXT)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM approved_emails WHERE email = lower(trim(p_email))
  );
$$;


-- ────────────────────────────────────────────────────────────────
-- RLS Policies: profiles
-- ────────────────────────────────────────────────────────────────
-- Public leaderboard reads
CREATE POLICY "profiles_select"
  ON profiles FOR SELECT
  USING (true);

-- Users update their own nickname / country
CREATE POLICY "profiles_update_own"
  ON profiles FOR UPDATE
  USING  (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Admins update any profile (e.g. role changes)
CREATE POLICY "profiles_update_admin"
  ON profiles FOR UPDATE
  USING  (get_user_role() = 'admin')
  WITH CHECK (get_user_role() = 'admin');

-- Admins delete profiles
CREATE POLICY "profiles_delete_admin"
  ON profiles FOR DELETE
  USING (get_user_role() = 'admin');

-- No INSERT policy: profile creation is handled exclusively by the
-- handle_new_user SECURITY DEFINER trigger (bypasses RLS).


-- ────────────────────────────────────────────────────────────────
-- RLS Policies: approved_emails
-- ────────────────────────────────────────────────────────────────
CREATE POLICY "approved_emails_select_admin"
  ON approved_emails FOR SELECT
  USING (get_user_role() = 'admin');

CREATE POLICY "approved_emails_insert_admin"
  ON approved_emails FOR INSERT
  WITH CHECK (get_user_role() = 'admin');

CREATE POLICY "approved_emails_delete_admin"
  ON approved_emails FOR DELETE
  USING (get_user_role() = 'admin');


-- ────────────────────────────────────────────────────────────────
-- RLS Policies: games
-- ────────────────────────────────────────────────────────────────
CREATE POLICY "games_select"
  ON games FOR SELECT
  USING (true);

CREATE POLICY "games_insert_member_admin"
  ON games FOR INSERT
  WITH CHECK (
    get_user_role() IN ('member', 'admin')
    AND submitted_by = auth.uid()
  );

-- Members may edit games they submitted
CREATE POLICY "games_update_member_own"
  ON games FOR UPDATE
  USING  (get_user_role() = 'member' AND submitted_by = auth.uid())
  WITH CHECK (get_user_role() = 'member' AND submitted_by = auth.uid());

-- Admins may edit any game
CREATE POLICY "games_update_admin"
  ON games FOR UPDATE
  USING  (get_user_role() = 'admin')
  WITH CHECK (get_user_role() = 'admin');

-- Only admins delete games (triggers full ELO recalc via RPC)
CREATE POLICY "games_delete_admin"
  ON games FOR DELETE
  USING (get_user_role() = 'admin');


-- ────────────────────────────────────────────────────────────────
-- RLS Policies: comments
-- ────────────────────────────────────────────────────────────────
CREATE POLICY "comments_select"
  ON comments FOR SELECT
  USING (true);

CREATE POLICY "comments_insert_authenticated"
  ON comments FOR INSERT
  WITH CHECK (auth.uid() IS NOT NULL AND user_id = auth.uid());

CREATE POLICY "comments_update_own"
  ON comments FOR UPDATE
  USING  (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "comments_delete_own"
  ON comments FOR DELETE
  USING (auth.uid() = user_id);

CREATE POLICY "comments_delete_admin"
  ON comments FOR DELETE
  USING (get_user_role() = 'admin');


-- ────────────────────────────────────────────────────────────────
-- RLS Policies: player_ratings
-- All writes go through SECURITY DEFINER recalculation functions.
-- ────────────────────────────────────────────────────────────────
CREATE POLICY "player_ratings_select"
  ON player_ratings FOR SELECT
  USING (true);


-- ────────────────────────────────────────────────────────────────
-- RLS Policies: weekly_winners / monthly_winners
-- Written only by SECURITY DEFINER winner-recording functions.
-- ────────────────────────────────────────────────────────────────
CREATE POLICY "weekly_winners_select"
  ON weekly_winners FOR SELECT
  USING (true);

CREATE POLICY "monthly_winners_select"
  ON monthly_winners FOR SELECT
  USING (true);


-- ════════════════════════════════════════════════════════════════
-- Trigger Functions
-- ════════════════════════════════════════════════════════════════

-- ────────────────────────────────────────────────────────────────
-- handle_new_user
-- Fires after INSERT on auth.users.
-- Creates the profiles row; role is determined by approved_emails.
-- Nickname + country come from raw_user_meta_data set during signUp().
-- ────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  assigned_role user_role := 'viewer';
BEGIN
  IF EXISTS (SELECT 1 FROM approved_emails WHERE email = lower(trim(NEW.email))) THEN
    assigned_role := 'member';
  END IF;

  INSERT INTO profiles (id, email, nickname, country, role)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'nickname', 'Player'),
    COALESCE(NEW.raw_user_meta_data->>'country', 'US'),
    assigned_role
  );

  RETURN NEW;
END;
$$;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();


-- ────────────────────────────────────────────────────────────────
-- handle_member_role
-- Fires after INSERT or role UPDATE on profiles.
-- Ensures members/admins have a player_ratings row.
-- ────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION handle_member_role()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NEW.role IN ('admin', 'member') THEN
    INSERT INTO player_ratings (player_id)
    VALUES (NEW.id)
    ON CONFLICT (player_id) DO NOTHING;
  END IF;
  RETURN NEW;
END;
$$;

CREATE TRIGGER on_profile_role_set
  AFTER INSERT OR UPDATE OF role ON profiles
  FOR EACH ROW EXECUTE FUNCTION handle_member_role();


-- ════════════════════════════════════════════════════════════════
-- ELO Recalculation Functions
-- Each function recalculates a single rating pool from scratch,
-- processing all qualifying games in chronological order.
--
-- An advisory lock serializes concurrent recalculations so that
-- two simultaneous game submissions cannot produce a split result.
-- ════════════════════════════════════════════════════════════════

-- ────────────────────────────────────────────────────────────────
-- recalculate_alltime_elo
-- Processes every game ever played.
-- K=40 for first 20 games per player, K=32 after.
-- ────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION recalculate_alltime_elo()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  game_rec     RECORD;
  p1_elo       NUMERIC;
  p2_elo       NUMERIC;
  p1_games     INTEGER;
  p2_games     INTEGER;
  p1_k         NUMERIC;
  p2_k         NUMERIC;
  p1_expected  NUMERIC;
  p1_actual    NUMERIC;
  p2_actual    NUMERIC;
BEGIN
  PERFORM pg_advisory_xact_lock(hashtext('elo_recalculation'));

  DROP TABLE IF EXISTS _elo_work;
  CREATE TEMP TABLE _elo_work (
    player_id    UUID    PRIMARY KEY,
    elo          NUMERIC NOT NULL DEFAULT 1500,
    games_played INTEGER NOT NULL DEFAULT 0,
    wins         INTEGER NOT NULL DEFAULT 0,
    losses       INTEGER NOT NULL DEFAULT 0,
    draws        INTEGER NOT NULL DEFAULT 0
  );

  INSERT INTO _elo_work (player_id)
  SELECT id FROM profiles WHERE role IN ('admin', 'member');

  FOR game_rec IN
    SELECT player1_id, player2_id, result
    FROM games
    ORDER BY game_date ASC, created_at ASC
  LOOP
    INSERT INTO _elo_work (player_id) VALUES (game_rec.player1_id) ON CONFLICT DO NOTHING;
    INSERT INTO _elo_work (player_id) VALUES (game_rec.player2_id) ON CONFLICT DO NOTHING;

    SELECT elo, games_played INTO p1_elo, p1_games
      FROM _elo_work WHERE player_id = game_rec.player1_id;
    SELECT elo, games_played INTO p2_elo, p2_games
      FROM _elo_work WHERE player_id = game_rec.player2_id;

    p1_k := CASE WHEN p1_games < 20 THEN 40 ELSE 32 END;
    p2_k := CASE WHEN p2_games < 20 THEN 40 ELSE 32 END;

    p1_expected := 1.0 / (1.0 + power(10.0, (p2_elo - p1_elo) / 400.0));

    IF    game_rec.result = 'player1_win' THEN p1_actual := 1.0; p2_actual := 0.0;
    ELSIF game_rec.result = 'player2_win' THEN p1_actual := 0.0; p2_actual := 1.0;
    ELSE                                        p1_actual := 0.5; p2_actual := 0.5;
    END IF;

    UPDATE _elo_work SET
      elo          = elo + p1_k * (p1_actual - p1_expected),
      games_played = games_played + 1,
      wins         = wins   + CASE WHEN game_rec.result = 'player1_win' THEN 1 ELSE 0 END,
      losses       = losses + CASE WHEN game_rec.result = 'player2_win' THEN 1 ELSE 0 END,
      draws        = draws  + CASE WHEN game_rec.result = 'draw'        THEN 1 ELSE 0 END
    WHERE player_id = game_rec.player1_id;

    UPDATE _elo_work SET
      elo          = elo + p2_k * (p2_actual - (1.0 - p1_expected)),
      games_played = games_played + 1,
      wins         = wins   + CASE WHEN game_rec.result = 'player2_win' THEN 1 ELSE 0 END,
      losses       = losses + CASE WHEN game_rec.result = 'player1_win' THEN 1 ELSE 0 END,
      draws        = draws  + CASE WHEN game_rec.result = 'draw'        THEN 1 ELSE 0 END
    WHERE player_id = game_rec.player2_id;
  END LOOP;

  INSERT INTO player_ratings (
    player_id,
    alltime_elo, alltime_games_played,
    alltime_wins, alltime_losses, alltime_draws,
    updated_at
  )
  SELECT player_id, ROUND(elo)::INTEGER, games_played, wins, losses, draws, now()
  FROM _elo_work
  ON CONFLICT (player_id) DO UPDATE SET
    alltime_elo          = EXCLUDED.alltime_elo,
    alltime_games_played = EXCLUDED.alltime_games_played,
    alltime_wins         = EXCLUDED.alltime_wins,
    alltime_losses       = EXCLUDED.alltime_losses,
    alltime_draws        = EXCLUDED.alltime_draws,
    updated_at           = now();

  DROP TABLE IF EXISTS _elo_work;
END;
$$;


-- ────────────────────────────────────────────────────────────────
-- recalculate_weekly_elo
-- Processes only games played since the most recent Monday 00:00 America/Managua.
-- Everyone starts at 1500; K=64 for every game.
-- ────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION recalculate_weekly_elo()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  week_start   TIMESTAMPTZ := (date_trunc('week', (now() AT TIME ZONE 'America/Managua'))::DATE)::TIMESTAMPTZ;
  game_rec     RECORD;
  p1_elo       NUMERIC;
  p2_elo       NUMERIC;
  p1_expected  NUMERIC;
  p1_actual    NUMERIC;
  p2_actual    NUMERIC;
  k            NUMERIC := 64;
BEGIN
  PERFORM pg_advisory_xact_lock(hashtext('elo_recalculation'));

  DROP TABLE IF EXISTS _elo_work;
  CREATE TEMP TABLE _elo_work (
    player_id    UUID    PRIMARY KEY,
    elo          NUMERIC NOT NULL DEFAULT 1500,
    games_played INTEGER NOT NULL DEFAULT 0,
    wins         INTEGER NOT NULL DEFAULT 0,
    losses       INTEGER NOT NULL DEFAULT 0,
    draws        INTEGER NOT NULL DEFAULT 0
  );

  INSERT INTO _elo_work (player_id)
  SELECT id FROM profiles WHERE role IN ('admin', 'member');

  FOR game_rec IN
    SELECT player1_id, player2_id, result
    FROM games
    WHERE game_date >= week_start
    ORDER BY game_date ASC, created_at ASC
  LOOP
    INSERT INTO _elo_work (player_id) VALUES (game_rec.player1_id) ON CONFLICT DO NOTHING;
    INSERT INTO _elo_work (player_id) VALUES (game_rec.player2_id) ON CONFLICT DO NOTHING;

    SELECT elo INTO p1_elo FROM _elo_work WHERE player_id = game_rec.player1_id;
    SELECT elo INTO p2_elo FROM _elo_work WHERE player_id = game_rec.player2_id;

    p1_expected := 1.0 / (1.0 + power(10.0, (p2_elo - p1_elo) / 400.0));

    IF    game_rec.result = 'player1_win' THEN p1_actual := 1.0; p2_actual := 0.0;
    ELSIF game_rec.result = 'player2_win' THEN p1_actual := 0.0; p2_actual := 1.0;
    ELSE                                        p1_actual := 0.5; p2_actual := 0.5;
    END IF;

    UPDATE _elo_work SET
      elo          = elo + k * (p1_actual - p1_expected),
      games_played = games_played + 1,
      wins         = wins   + CASE WHEN game_rec.result = 'player1_win' THEN 1 ELSE 0 END,
      losses       = losses + CASE WHEN game_rec.result = 'player2_win' THEN 1 ELSE 0 END,
      draws        = draws  + CASE WHEN game_rec.result = 'draw'        THEN 1 ELSE 0 END
    WHERE player_id = game_rec.player1_id;

    UPDATE _elo_work SET
      elo          = elo + k * (p2_actual - (1.0 - p1_expected)),
      games_played = games_played + 1,
      wins         = wins   + CASE WHEN game_rec.result = 'player2_win' THEN 1 ELSE 0 END,
      losses       = losses + CASE WHEN game_rec.result = 'player1_win' THEN 1 ELSE 0 END,
      draws        = draws  + CASE WHEN game_rec.result = 'draw'        THEN 1 ELSE 0 END
    WHERE player_id = game_rec.player2_id;
  END LOOP;

  INSERT INTO player_ratings (
    player_id,
    weekly_elo, weekly_games_played,
    weekly_wins, weekly_losses, weekly_draws,
    updated_at
  )
  SELECT player_id, ROUND(elo)::INTEGER, games_played, wins, losses, draws, now()
  FROM _elo_work
  ON CONFLICT (player_id) DO UPDATE SET
    weekly_elo          = EXCLUDED.weekly_elo,
    weekly_games_played = EXCLUDED.weekly_games_played,
    weekly_wins         = EXCLUDED.weekly_wins,
    weekly_losses       = EXCLUDED.weekly_losses,
    weekly_draws        = EXCLUDED.weekly_draws,
    updated_at          = now();

  DROP TABLE IF EXISTS _elo_work;
END;
$$;


-- ────────────────────────────────────────────────────────────────
-- recalculate_monthly_elo
-- Processes only games played since the 1st of the current month 00:00 America/Managua.
-- Everyone starts at 1500; K=48 for every game.
-- ────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION recalculate_monthly_elo()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  month_start  TIMESTAMPTZ := (date_trunc('month', (now() AT TIME ZONE 'America/Managua'))::DATE)::TIMESTAMPTZ;
  game_rec     RECORD;
  p1_elo       NUMERIC;
  p2_elo       NUMERIC;
  p1_expected  NUMERIC;
  p1_actual    NUMERIC;
  p2_actual    NUMERIC;
  k            NUMERIC := 48;
BEGIN
  PERFORM pg_advisory_xact_lock(hashtext('elo_recalculation'));

  DROP TABLE IF EXISTS _elo_work;
  CREATE TEMP TABLE _elo_work (
    player_id    UUID    PRIMARY KEY,
    elo          NUMERIC NOT NULL DEFAULT 1500,
    games_played INTEGER NOT NULL DEFAULT 0,
    wins         INTEGER NOT NULL DEFAULT 0,
    losses       INTEGER NOT NULL DEFAULT 0,
    draws        INTEGER NOT NULL DEFAULT 0
  );

  INSERT INTO _elo_work (player_id)
  SELECT id FROM profiles WHERE role IN ('admin', 'member');

  FOR game_rec IN
    SELECT player1_id, player2_id, result
    FROM games
    WHERE game_date >= month_start
    ORDER BY game_date ASC, created_at ASC
  LOOP
    INSERT INTO _elo_work (player_id) VALUES (game_rec.player1_id) ON CONFLICT DO NOTHING;
    INSERT INTO _elo_work (player_id) VALUES (game_rec.player2_id) ON CONFLICT DO NOTHING;

    SELECT elo INTO p1_elo FROM _elo_work WHERE player_id = game_rec.player1_id;
    SELECT elo INTO p2_elo FROM _elo_work WHERE player_id = game_rec.player2_id;

    p1_expected := 1.0 / (1.0 + power(10.0, (p2_elo - p1_elo) / 400.0));

    IF    game_rec.result = 'player1_win' THEN p1_actual := 1.0; p2_actual := 0.0;
    ELSIF game_rec.result = 'player2_win' THEN p1_actual := 0.0; p2_actual := 1.0;
    ELSE                                        p1_actual := 0.5; p2_actual := 0.5;
    END IF;

    UPDATE _elo_work SET
      elo          = elo + k * (p1_actual - p1_expected),
      games_played = games_played + 1,
      wins         = wins   + CASE WHEN game_rec.result = 'player1_win' THEN 1 ELSE 0 END,
      losses       = losses + CASE WHEN game_rec.result = 'player2_win' THEN 1 ELSE 0 END,
      draws        = draws  + CASE WHEN game_rec.result = 'draw'        THEN 1 ELSE 0 END
    WHERE player_id = game_rec.player1_id;

    UPDATE _elo_work SET
      elo          = elo + k * (p2_actual - (1.0 - p1_expected)),
      games_played = games_played + 1,
      wins         = wins   + CASE WHEN game_rec.result = 'player2_win' THEN 1 ELSE 0 END,
      losses       = losses + CASE WHEN game_rec.result = 'player1_win' THEN 1 ELSE 0 END,
      draws        = draws  + CASE WHEN game_rec.result = 'draw'        THEN 1 ELSE 0 END
    WHERE player_id = game_rec.player2_id;
  END LOOP;

  INSERT INTO player_ratings (
    player_id,
    monthly_elo, monthly_games_played,
    monthly_wins, monthly_losses, monthly_draws,
    updated_at
  )
  SELECT player_id, ROUND(elo)::INTEGER, games_played, wins, losses, draws, now()
  FROM _elo_work
  ON CONFLICT (player_id) DO UPDATE SET
    monthly_elo          = EXCLUDED.monthly_elo,
    monthly_games_played = EXCLUDED.monthly_games_played,
    monthly_wins         = EXCLUDED.monthly_wins,
    monthly_losses       = EXCLUDED.monthly_losses,
    monthly_draws        = EXCLUDED.monthly_draws,
    updated_at           = now();

  DROP TABLE IF EXISTS _elo_work;
END;
$$;


-- ════════════════════════════════════════════════════════════════
-- Game Mutation RPCs
-- All three functions run the full ELO recalculation for all
-- three pools inside a single transaction.
-- Called from server actions via supabase.rpc('submit_game', {...})
-- ════════════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION submit_game(
  p_player1_id            UUID,
  p_player2_id            UUID,
  p_player1_color         piece_color,
  p_result                game_result,
  p_time_control          TEXT,
  p_time_control_category time_control_category,
  p_game_date             TIMESTAMPTZ,
  p_submitted_by          UUID,
  p_player1_photo_url     TEXT DEFAULT NULL,
  p_player2_photo_url     TEXT DEFAULT NULL
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  new_game_id UUID;
BEGIN
  IF get_user_role() NOT IN ('member', 'admin') THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  IF p_submitted_by != auth.uid() THEN
    RAISE EXCEPTION 'submitted_by must match the authenticated user';
  END IF;

  INSERT INTO games (
    player1_id, player2_id, player1_color, result,
    time_control, time_control_category,
    game_date, submitted_by,
    player1_photo_url, player2_photo_url
  ) VALUES (
    p_player1_id, p_player2_id, p_player1_color, p_result,
    p_time_control, p_time_control_category,
    p_game_date, p_submitted_by,
    p_player1_photo_url, p_player2_photo_url
  )
  RETURNING id INTO new_game_id;

  PERFORM recalculate_alltime_elo();
  PERFORM recalculate_weekly_elo();
  PERFORM recalculate_monthly_elo();

  RETURN new_game_id;
END;
$$;


CREATE OR REPLACE FUNCTION update_game(
  p_game_id               UUID,
  p_player1_id            UUID,
  p_player2_id            UUID,
  p_player1_color         piece_color,
  p_result                game_result,
  p_time_control          TEXT,
  p_time_control_category time_control_category,
  p_game_date             TIMESTAMPTZ,
  p_player1_photo_url     TEXT DEFAULT NULL,
  p_player2_photo_url     TEXT DEFAULT NULL
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  current_submitter UUID;
  current_role      user_role := get_user_role();
BEGIN
  SELECT submitted_by INTO current_submitter
  FROM games WHERE id = p_game_id;

  IF current_submitter IS NULL THEN
    RAISE EXCEPTION 'Game not found';
  END IF;

  -- Members may only edit their own submissions; admins may edit any
  IF current_role = 'member' AND current_submitter != auth.uid() THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  IF current_role NOT IN ('member', 'admin') THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  UPDATE games SET
    player1_id            = p_player1_id,
    player2_id            = p_player2_id,
    player1_color         = p_player1_color,
    result                = p_result,
    time_control          = p_time_control,
    time_control_category = p_time_control_category,
    game_date             = p_game_date,
    player1_photo_url     = p_player1_photo_url,
    player2_photo_url     = p_player2_photo_url
  WHERE id = p_game_id;

  PERFORM recalculate_alltime_elo();
  PERFORM recalculate_weekly_elo();
  PERFORM recalculate_monthly_elo();
END;
$$;


CREATE OR REPLACE FUNCTION delete_game(p_game_id UUID)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF get_user_role() != 'admin' THEN
    RAISE EXCEPTION 'Unauthorized';
  END IF;

  DELETE FROM games WHERE id = p_game_id;

  PERFORM recalculate_alltime_elo();
  PERFORM recalculate_weekly_elo();
  PERFORM recalculate_monthly_elo();
END;
$$;


-- ════════════════════════════════════════════════════════════════
-- Period Management RPCs
-- Called by pg_cron jobs at period boundaries.
-- ════════════════════════════════════════════════════════════════

-- ────────────────────────────────────────────────────────────────
-- record_weekly_winner
-- Snapshots the top weekly player (≥3 games) into weekly_winners.
-- p_week_start: the Monday that opened the week being closed.
-- ────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION record_weekly_winner(p_week_start DATE)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  winner_id     UUID;
  winner_elo    INTEGER;
  winner_wins   INTEGER;
  winner_losses INTEGER;
  winner_draws  INTEGER;
  winner_games  INTEGER;
  victory_photo TEXT;
  window_start  TIMESTAMPTZ := p_week_start::TIMESTAMPTZ;
  window_end    TIMESTAMPTZ := p_week_start::TIMESTAMPTZ + INTERVAL '7 days';
BEGIN
  SELECT pr.player_id, pr.weekly_elo,
         pr.weekly_wins, pr.weekly_losses, pr.weekly_draws, pr.weekly_games_played
  INTO winner_id, winner_elo,
       winner_wins, winner_losses, winner_draws, winner_games
  FROM player_ratings pr
  WHERE pr.weekly_games_played >= 3
  ORDER BY pr.weekly_elo DESC
  LIMIT 1;

  IF winner_id IS NULL THEN RETURN; END IF;

  -- Last victory photo: prefer player1 win photo, fall back to player2 win photo
  SELECT COALESCE(
    (SELECT player1_photo_url FROM games
      WHERE player1_id = winner_id AND result = 'player1_win'
        AND game_date >= window_start AND game_date < window_end
        AND player1_photo_url IS NOT NULL
      ORDER BY game_date DESC LIMIT 1),
    (SELECT player2_photo_url FROM games
      WHERE player2_id = winner_id AND result = 'player2_win'
        AND game_date >= window_start AND game_date < window_end
        AND player2_photo_url IS NOT NULL
      ORDER BY game_date DESC LIMIT 1)
  ) INTO victory_photo;

  INSERT INTO weekly_winners (
    week_start, player_id, peak_elo,
    wins, losses, draws, games_played, victory_photo_url
  ) VALUES (
    p_week_start, winner_id, winner_elo,
    winner_wins, winner_losses, winner_draws, winner_games, victory_photo
  )
  ON CONFLICT (week_start) DO UPDATE SET
    player_id         = EXCLUDED.player_id,
    peak_elo          = EXCLUDED.peak_elo,
    wins              = EXCLUDED.wins,
    losses            = EXCLUDED.losses,
    draws             = EXCLUDED.draws,
    games_played      = EXCLUDED.games_played,
    victory_photo_url = EXCLUDED.victory_photo_url;
END;
$$;


-- ────────────────────────────────────────────────────────────────
-- record_monthly_winner
-- Snapshots the top monthly player (≥3 games) into monthly_winners.
-- p_month_start: the 1st of the month being closed.
-- ────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION record_monthly_winner(p_month_start DATE)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  winner_id     UUID;
  winner_elo    INTEGER;
  winner_wins   INTEGER;
  winner_losses INTEGER;
  winner_draws  INTEGER;
  winner_games  INTEGER;
  victory_photo TEXT;
  window_start  TIMESTAMPTZ := p_month_start::TIMESTAMPTZ;
  window_end    TIMESTAMPTZ := p_month_start::TIMESTAMPTZ + INTERVAL '1 month';
BEGIN
  SELECT pr.player_id, pr.monthly_elo,
         pr.monthly_wins, pr.monthly_losses, pr.monthly_draws, pr.monthly_games_played
  INTO winner_id, winner_elo,
       winner_wins, winner_losses, winner_draws, winner_games
  FROM player_ratings pr
  WHERE pr.monthly_games_played >= 3
  ORDER BY pr.monthly_elo DESC
  LIMIT 1;

  IF winner_id IS NULL THEN RETURN; END IF;

  SELECT COALESCE(
    (SELECT player1_photo_url FROM games
      WHERE player1_id = winner_id AND result = 'player1_win'
        AND game_date >= window_start AND game_date < window_end
        AND player1_photo_url IS NOT NULL
      ORDER BY game_date DESC LIMIT 1),
    (SELECT player2_photo_url FROM games
      WHERE player2_id = winner_id AND result = 'player2_win'
        AND game_date >= window_start AND game_date < window_end
        AND player2_photo_url IS NOT NULL
      ORDER BY game_date DESC LIMIT 1)
  ) INTO victory_photo;

  INSERT INTO monthly_winners (
    month_start, player_id, peak_elo,
    wins, losses, draws, games_played, victory_photo_url
  ) VALUES (
    p_month_start, winner_id, winner_elo,
    winner_wins, winner_losses, winner_draws, winner_games, victory_photo
  )
  ON CONFLICT (month_start) DO UPDATE SET
    player_id         = EXCLUDED.player_id,
    peak_elo          = EXCLUDED.peak_elo,
    wins              = EXCLUDED.wins,
    losses            = EXCLUDED.losses,
    draws             = EXCLUDED.draws,
    games_played      = EXCLUDED.games_played,
    victory_photo_url = EXCLUDED.victory_photo_url;
END;
$$;


-- ────────────────────────────────────────────────────────────────
-- reset_weekly_elo
-- Resets all weekly stats to baseline 1500. Called Monday 00:00.
-- ────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION reset_weekly_elo()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  UPDATE player_ratings SET
    weekly_elo          = 1500,
    weekly_games_played = 0,
    weekly_wins         = 0,
    weekly_losses       = 0,
    weekly_draws        = 0,
    updated_at          = now();
END;
$$;


-- ────────────────────────────────────────────────────────────────
-- reset_monthly_elo
-- Resets all monthly stats to baseline 1500. Called 1st 00:00.
-- ────────────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION reset_monthly_elo()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  UPDATE player_ratings SET
    monthly_elo          = 1500,
    monthly_games_played = 0,
    monthly_wins         = 0,
    monthly_losses       = 0,
    monthly_draws        = 0,
    updated_at           = now();
END;
$$;


-- ════════════════════════════════════════════════════════════════
-- pg_cron Schedules
-- Run supabase/cron.sql SEPARATELY after enabling pg_cron:
--   Supabase Dashboard → Database → Extensions → pg_cron → Enable
-- ════════════════════════════════════════════════════════════════
