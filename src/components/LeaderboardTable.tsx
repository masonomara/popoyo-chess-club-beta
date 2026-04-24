'use client'

import { useState } from 'react'
import type { Tables } from '@/types/database'
import styles from './LeaderboardTable.module.css'

type RatingWithProfile = Tables<'player_ratings'> & {
  profiles: Tables<'profiles'>
}

type SortKey = 'alltime_elo' | 'weekly_elo' | 'monthly_elo'

const SORT_LABELS: Record<SortKey, string> = {
  weekly_elo: 'Weekly',
  monthly_elo: 'Monthly',
  alltime_elo: 'All Time',
}

function getWindowStats(
  row: Tables<'player_ratings'>,
  key: SortKey
): { elo: number; wins: number; losses: number; draws: number; gamesPlayed: number } {
  switch (key) {
    case 'weekly_elo':
      return {
        elo: row.weekly_elo,
        wins: row.weekly_wins,
        losses: row.weekly_losses,
        draws: row.weekly_draws,
        gamesPlayed: row.weekly_games_played,
      }
    case 'monthly_elo':
      return {
        elo: row.monthly_elo,
        wins: row.monthly_wins,
        losses: row.monthly_losses,
        draws: row.monthly_draws,
        gamesPlayed: row.monthly_games_played,
      }
    case 'alltime_elo':
      return {
        elo: row.alltime_elo,
        wins: row.alltime_wins,
        losses: row.alltime_losses,
        draws: row.alltime_draws,
        gamesPlayed: row.alltime_games_played,
      }
  }
}

export default function LeaderboardTable({
  ratings,
}: {
  ratings: RatingWithProfile[]
}) {
  const [sortBy, setSortBy] = useState<SortKey>('weekly_elo')

  const sorted = [...ratings]
    .filter((r) => getWindowStats(r, sortBy).gamesPlayed >= 3)
    .sort((a, b) => getWindowStats(b, sortBy).elo - getWindowStats(a, sortBy).elo)

  return (
    <div>
      <div className={styles.header}>
        <h2 className={styles.title}>Leaderboard</h2>
        <div
          role="group"
          aria-label="Sort leaderboard"
          className={styles.toggle}
        >
          {(Object.keys(SORT_LABELS) as SortKey[]).map((key) => (
            <button
              key={key}
              type="button"
              onClick={() => setSortBy(key)}
              aria-pressed={sortBy === key}
              className={`${styles.toggleBtn} ${sortBy === key ? styles.toggleBtnActive : ''}`}
            >
              {SORT_LABELS[key]}
            </button>
          ))}
        </div>
      </div>

      {sorted.length === 0 ? (
        <p className={styles.empty}>No players with 3+ games in this period.</p>
      ) : (
        <table className={styles.table}>
          <thead>
            <tr>
              <th>#</th>
              <th>Player</th>
              <th>ELO</th>
              <th>W</th>
              <th>L</th>
              <th>D</th>
            </tr>
          </thead>
          <tbody>
            {sorted.map((row, i) => {
              const stats = getWindowStats(row, sortBy)
              return (
                <tr key={row.player_id}>
                  <td className={`${styles.rankCell} ${i === 0 ? styles.rank1 : ''}`}>
                    {i + 1}
                  </td>
                  <td>
                    <span className={styles.playerCell}>
                      {row.profiles.country} {row.profiles.nickname}
                    </span>
                  </td>
                  <td className={styles.eloCell}>{stats.elo}</td>
                  <td className={styles.statCell}>{stats.wins}</td>
                  <td className={styles.statCell}>{stats.losses}</td>
                  <td className={styles.statCell}>{stats.draws}</td>
                </tr>
              )
            })}
          </tbody>
        </table>
      )}
    </div>
  )
}
