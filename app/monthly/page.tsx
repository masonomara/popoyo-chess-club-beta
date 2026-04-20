import Link from 'next/link'
import { createClient } from '@/lib/supabase/server'
import type { Tables } from '@/app/types/database'
import styles from './page.module.css'

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
    <>
      <Link href="/" className={styles.backLink}>← Back</Link>
      <h1 className={styles.title}>Player of the Month</h1>
      {typedWinners.length === 0 ? (
        <p className={styles.empty}>No monthly winners yet.</p>
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
                <p className={styles.period}>{monthLabel(w.month_start)}</p>
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
