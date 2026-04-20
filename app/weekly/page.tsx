import { createClient } from '@/lib/supabase/server'
import type { Tables } from '@/app/types/database'

type WeeklyWinnerWithProfile = Tables<'weekly_winners'> & {
  profiles: Tables<'profiles'>
}

function weekRange(weekStart: string): string {
  const start = new Date(weekStart)
  const end = new Date(weekStart)
  end.setUTCDate(end.getUTCDate() + 6)
  return `${start.toLocaleDateString('en-US', { month: 'short', day: 'numeric', timeZone: 'UTC' })} – ${end.toLocaleDateString('en-US', { month: 'short', day: 'numeric', timeZone: 'UTC' })}`
}

export default async function WeeklyPage() {
  const supabase = await createClient()

  const { data: winners } = await supabase
    .from('weekly_winners')
    .select('*, profiles(*)')
    .order('week_start', { ascending: false })

  const typedWinners = (winners ?? []) as WeeklyWinnerWithProfile[]

  return (
    <main>
      <h1>Player of the Week — All Time</h1>
      <ul>
        {typedWinners.map((w) => (
          <li key={w.id}>
            {w.victory_photo_url && (
              <img src={w.victory_photo_url} alt={`${w.profiles.nickname} victory`} />
            )}
            <p>{weekRange(w.week_start)}</p>
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
