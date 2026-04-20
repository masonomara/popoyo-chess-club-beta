-- ================================================================
-- Popoyo Chess Club — pg_cron Schedules
--
-- PREREQUISITE: Enable pg_cron first.
--   Supabase Dashboard → Database → Extensions → pg_cron → Enable
--
-- Then run this file in the SQL editor. All times are UTC.
-- ================================================================

-- Monday 00:00 America/Managua (06:00 UTC):
--   1. Snapshot the previous week's winner (weekly ratings still intact).
--   2. Reset weekly ELO to 1500 for the new week.
SELECT cron.schedule(
  'weekly-winner-and-reset',
  '0 6 * * 1',
  $$
    SELECT record_weekly_winner(
      ((date_trunc('week', now() AT TIME ZONE 'America/Managua'))::DATE - INTERVAL '7 days')::DATE
    );
    SELECT reset_weekly_elo();
  $$
);

-- 1st of every month 00:00 America/Managua (06:00 UTC):
--   1. Snapshot the previous month's winner (monthly ratings still intact).
--   2. Reset monthly ELO to 1500 for the new month.
SELECT cron.schedule(
  'monthly-winner-and-reset',
  '0 6 1 * *',
  $$
    SELECT record_monthly_winner(
      ((date_trunc('month', now() AT TIME ZONE 'America/Managua'))::DATE - INTERVAL '1 month')::DATE
    );
    SELECT reset_monthly_elo();
  $$
);

-- To verify schedules were registered:
-- SELECT * FROM cron.job;

-- To remove a schedule if needed:
-- SELECT cron.unschedule('weekly-winner-and-reset');
-- SELECT cron.unschedule('monthly-winner-and-reset');
