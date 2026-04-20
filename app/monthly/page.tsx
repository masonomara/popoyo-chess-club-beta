import { createClient } from '@/lib/supabase/server'
import type { Tables } from '@/app/types/database'

type MonthlyWinnerWithProfile = Tables<'monthly_winners'> & {
  profiles: Tables<'profiles'>
}

function monthLabel(monthStart: string): string {
  return new Date(monthStart).toLocaleDateString('en-US', {
    month: 'long',
    year: 'numeric',
    timeZone: 'UTC',
  })
}

export default async function MonthlyPage() {
  const supabase = await createClient()

  const { data: winners } = await supabase
    .from('monthly_winners')
    .select('*, profiles(*)')
    .order('month_start', { ascending: false })

  const typedWinners = (winners ?? []) as MonthlyWinnerWithProfile[]

  return (
    <main>
      <h1>Player of the Month — All Time</h1>
      <ul>
        {typedWinners.map((w) => (
          <li key={w.id}>
            {w.victory_photo_url && (
              <img src={w.victory_photo_url} alt={`${w.profiles.nickname} victory`} />
            )}
            <p>{monthLabel(w.month_start)}</p>
            <p>
              {w.profiles.country} {w.profiles.nickname}
            </p>
            <p>{w.peak_elo} ELO</p>
            <p>
              {w.wins}W – {w.losses}L – {w.draws}D · {w.games_played} games
            </p>
          </li>
        ))}
      </ul>
    </main>
  )
}
