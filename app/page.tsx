import Link from 'next/link'
import { createClient } from '@/lib/supabase/server'
import LeaderboardTable from '@/app/components/LeaderboardTable'
import AddGameSheet from '@/app/components/AddGameSheet'
import type { Tables } from '@/app/types/database'
import styles from './page.module.css'

function monthName(dateStr: string): string {
  return new Date(dateStr).toLocaleDateString('en-US', { month: 'long', timeZone: 'UTC' })
}

export default async function HomePage() {
  const supabase = await createClient()

  const [
    { data: weekWinner },
    { data: monthWinner },
    { data: ratings },
    { data: games },
    {
      data: { user },
    },
    { data: players },
  ] = await Promise.all([
    supabase
      .from('weekly_winners')
      .select('*, profiles(*)')
      .order('week_start', { ascending: false })
      .limit(1)
      .maybeSingle(),
    supabase
      .from('monthly_winners')
      .select('*, profiles(*)')
      .order('month_start', { ascending: false })
      .limit(1)
      .maybeSingle(),
    supabase
      .from('player_ratings')
      .select('*, profiles(*)')
      .order('alltime_elo', { ascending: false }),
    supabase
      .from('games')
      .select(
        '*, player1:profiles!games_player1_id_fkey(*), player2:profiles!games_player2_id_fkey(*)'
      )
      .order('game_date', { ascending: false }),
    supabase.auth.getUser(),
    supabase
      .from('profiles')
      .select('*')
      .in('role', ['admin', 'member'])
      .order('nickname'),
  ])

  let userRole: Tables<'profiles'>['role'] | null = null
  if (user) {
    const { data: profile } = await supabase
      .from('profiles')
      .select('role')
      .eq('id', user.id)
      .single()
    userRole = profile?.role ?? null
  }

  return (
    <>
      {(weekWinner?.profiles || monthWinner?.profiles) && (
        <div className={styles.winnersRow}>
          {weekWinner?.profiles && (
            <Link href="/weekly" className={styles.winnerCard}>
              {weekWinner.victory_photo_url && (
                <img
                  className={styles.winnerPhoto}
                  src={weekWinner.victory_photo_url}
                  alt={`${weekWinner.profiles.nickname} victory`}
                />
              )}
              <div className={styles.winnerBody}>
                <p className={styles.winnerLabel}>Player of the Week</p>
                <p className={styles.winnerName}>
                  {weekWinner.profiles.country} {weekWinner.profiles.nickname}
                </p>
                <p className={styles.winnerElo}>{weekWinner.peak_elo} ELO</p>
                <p className={styles.winnerRecord}>
                  {weekWinner.wins}W – {weekWinner.losses}L – {weekWinner.draws}D
                </p>
              </div>
            </Link>
          )}

          {monthWinner?.profiles && (
            <Link href="/monthly" className={styles.winnerCard}>
              {monthWinner.victory_photo_url && (
                <img
                  className={styles.winnerPhoto}
                  src={monthWinner.victory_photo_url}
                  alt={`${monthWinner.profiles.nickname} victory`}
                />
              )}
              <div className={styles.winnerBody}>
                <p className={styles.winnerLabel}>
                  {monthName(monthWinner.month_start)}&apos;s Player of the Month
                </p>
                <p className={styles.winnerName}>
                  {monthWinner.profiles.country} {monthWinner.profiles.nickname}
                </p>
                <p className={styles.winnerElo}>{monthWinner.peak_elo} ELO</p>
                <p className={styles.winnerRecord}>
                  {monthWinner.wins}W – {monthWinner.losses}L – {monthWinner.draws}D
                </p>
              </div>
            </Link>
          )}
        </div>
      )}

      <div className={styles.leaderSection}>
        <div className={styles.sectionHeader}>
          <h2 className={styles.sectionTitle}>Leaderboard</h2>
          {(userRole === 'admin' || userRole === 'member') && user && (
            <AddGameSheet players={players ?? []} />
          )}
        </div>
        <LeaderboardTable ratings={ratings ?? []} />
      </div>

      <div>
        <h2 className={styles.historyTitle}>Game History</h2>
        <ul className={styles.gameList}>
          {(games ?? []).map((game) => {
            const isDraw = game.result === 'draw'
            const winner = game.result === 'player2_win' ? game.player2 : game.player1
            const loser = game.result === 'player2_win' ? game.player1 : game.player2
            return (
              <li key={game.id}>
                <Link href={`/games/${game.id}`} className={styles.gameRow}>
                  {isDraw ? (
                    <>
                      <span className={styles.gameWinner}>{game.player1.nickname}</span>
                      <span className={styles.gameDraw}>drew</span>
                      <span className={styles.gameLoser}>{game.player2.nickname}</span>
                    </>
                  ) : (
                    <>
                      <span className={styles.gameWinner}>{winner.nickname}</span>
                      <span className={styles.gameVerb}>defeated</span>
                      <span className={styles.gameLoser}>{loser.nickname}</span>
                    </>
                  )}
                  <span className={styles.gameMeta}>
                    <span className={styles.tcBadge}>{game.time_control}</span>
                    <span className={styles.gameDate}>
                      {new Date(game.game_date).toLocaleDateString()}
                    </span>
                  </span>
                </Link>
              </li>
            )
          })}
        </ul>
      </div>
    </>
  )
}
