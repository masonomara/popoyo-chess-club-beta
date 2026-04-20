'use client'

import { useState } from 'react'
import type { Tables } from '@/app/types/database'

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
  const [sortBy, setSortBy] = useState<SortKey>('alltime_elo')

  const sorted = [...ratings]
    .filter((r) => getWindowStats(r, sortBy).gamesPlayed >= 3)
    .sort((a, b) => getWindowStats(b, sortBy).elo - getWindowStats(a, sortBy).elo)

  return (
    <div>
      <div role="group" aria-label="Sort leaderboard">
        {(Object.keys(SORT_LABELS) as SortKey[]).map((key) => (
          <button
            key={key}
            onClick={() => setSortBy(key)}
            aria-pressed={sortBy === key}
          >
            {SORT_LABELS[key]}
          </button>
        ))}
      </div>
      <table>
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
                <td>{i + 1}</td>
                <td>
                  {row.profiles.country} {row.profiles.nickname}
                </td>
                <td>{stats.elo}</td>
                <td>{stats.wins}</td>
                <td>{stats.losses}</td>
                <td>{stats.draws}</td>
              </tr>
            )
          })}
        </tbody>
      </table>
    </div>
  )
}
