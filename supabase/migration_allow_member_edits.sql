-- Drop old member-only policy and replace with one that allows any member to edit any game
DROP POLICY IF EXISTS "games_update_member_own" ON games;
DROP POLICY IF EXISTS "games_update_member" ON games;
CREATE POLICY "games_update_member"
  ON games FOR UPDATE
  USING  (get_user_role() = 'member')
  WITH CHECK (get_user_role() = 'member');

-- Fix update_game RPC:
--   - remove submitter-ownership check
--   - rename 'current_role' variable (conflicts with PostgreSQL built-in)
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
  v_role            user_role;
BEGIN
  SELECT role INTO v_role FROM profiles WHERE id = auth.uid();

  SELECT submitted_by INTO current_submitter
  FROM games WHERE id = p_game_id;

  IF current_submitter IS NULL THEN
    RAISE EXCEPTION 'Game not found';
  END IF;

  IF v_role NOT IN ('member', 'admin') THEN
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
