import Link from 'next/link'
import { createClient } from '@/lib/supabase/server'
import type { Tables } from '@/types/database'
import styles from './page.module.css'

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
    <>
      <Link href="/" className={styles.backLink}>← Back</Link>
      <h1 className={styles.title}>Player of the Week</h1>
      {typedWinners.length === 0 ? (
        <p className={styles.empty}>No weekly winners yet.</p>
      ) : (
        <ul className={styles.list}>
          {typedWinners.map((w) => (
            <li key={w.id} className={styles.card}>
              {w.victory_photo_url && (
                <img
                  className={styles.photo}
                  src={w.victory_photo_url}
                  alt={`${w.profiles.nickname} victory`}
                />
              )}
              <div className={styles.body}>
                <p className={styles.period}>{weekRange(w.week_start)}</p>
                <p className={styles.name}>
                  {w.profiles.country} {w.profiles.nickname}
                </p>
                <p className={styles.elo}>{w.peak_elo} ELO</p>
                <p className={styles.record}>
                  {w.wins}W – {w.losses}L – {w.draws}D · {w.games_played} games
                </p>
              </div>
            </li>
          ))}
        </ul>
      )}
    </>
  )
}
