import Link from 'next/link'
import { createClient } from '@/lib/supabase/server'
import LeaderboardTable from '@/app/components/LeaderboardTable'
import AddGameSheet from '@/app/components/AddGameSheet'
import type { Tables } from '@/app/types/database'

function monthName(dateStr: string): string {
  return new Date(dateStr).toLocaleDateString('en-US', { month: 'long', timeZone: 'UTC' })
}

function resultVerb(result: Tables<'games'>['result']): string {
  return result === 'draw' ? 'drew' : 'defeated'
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
    <main>
      <section>
        {weekWinner?.profiles && (
          <Link href="/weekly">
            <div>
              <h2>Player of the Week</h2>
              {weekWinner.victory_photo_url && (
                <img
                  src={weekWinner.victory_photo_url}
                  alt={`${weekWinner.profiles.nickname} victory`}
                />
              )}
              <p>{weekWinner.profiles.nickname}</p>
              <p>{weekWinner.peak_elo} ELO</p>
              <p>
                {weekWinner.wins}W – {weekWinner.losses}L – {weekWinner.draws}D
              </p>
            </div>
          </Link>
        )}

        {monthWinner?.profiles && (
          <Link href="/monthly">
            <div>
              <h2>{monthName(monthWinner.month_start)}&apos;s Player of the Month</h2>
              {monthWinner.victory_photo_url && (
                <img
                  src={monthWinner.victory_photo_url}
                  alt={`${monthWinner.profiles.nickname} victory`}
                />
              )}
              <p>{monthWinner.profiles.nickname}</p>
              <p>{monthWinner.peak_elo} ELO</p>
              <p>
                {monthWinner.wins}W – {monthWinner.losses}L – {monthWinner.draws}D
              </p>
            </div>
          </Link>
        )}
      </section>

      <section>
        {(userRole === 'admin' || userRole === 'member') && user && (
          <AddGameSheet players={players ?? []} />
        )}
        <LeaderboardTable ratings={ratings ?? []} />
      </section>

      <section>
        <h2>Game History</h2>
        <ul>
          {(games ?? []).map((game) => (
            <li key={game.id}>
              <Link href={`/games/${game.id}`}>
                {game.result === 'player2_win' ? (
                  <>
                    <span>{game.player2.nickname}</span>
                    <span> {resultVerb(game.result)} </span>
                    <span>{game.player1.nickname}</span>
                  </>
                ) : (
                  <>
                    <span>{game.player1.nickname}</span>
                    <span> {resultVerb(game.result)} </span>
                    <span>{game.player2.nickname}</span>
                  </>
                )}
                <span> · {game.time_control}</span>
                <span> · {new Date(game.game_date).toLocaleDateString()}</span>
              </Link>
            </li>
          ))}
        </ul>
      </section>
    </main>
  )
}
