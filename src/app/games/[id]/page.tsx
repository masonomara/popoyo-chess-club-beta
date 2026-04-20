import { notFound } from 'next/navigation'
import Link from 'next/link'
import { createClient } from '@/lib/supabase/server'
import RealtimeComments from '@/components/RealtimeComments'
import InlineSignUp from '@/components/InlineSignUp'
import type { Tables } from '@/types/database'
import styles from './page.module.css'

type CommentWithProfile = Tables<'comments'> & { profiles: Tables<'profiles'> | null }

function resultSummary(
  result: Tables<'games'>['result'],
  p1: string,
  p2: string
): string {
  if (result === 'draw') return 'Draw'
  if (result === 'player1_win') return `${p1} won`
  return `${p2} won`
}

export default async function GameDetailPage({
  params,
}: {
  params: Promise<{ id: string }>
}) {
  const { id } = await params
  const supabase = await createClient()

  const [
    { data: game },
    { data: comments },
    {
      data: { user },
    },
  ] = await Promise.all([
    supabase
      .from('games')
      .select(
        '*, player1:profiles!games_player1_id_fkey(*), player2:profiles!games_player2_id_fkey(*)'
      )
      .eq('id', id)
      .single(),
    supabase
      .from('comments')
      .select('*, profiles(*)')
      .eq('game_id', id)
      .order('created_at', { ascending: true }),
    supabase.auth.getUser(),
  ])

  if (!game) notFound()

  let canEdit = false
  if (user) {
    const { data: profile } = await supabase
      .from('profiles')
      .select('role')
      .eq('id', user.id)
      .single()
    canEdit = profile?.role === 'admin' || game.submitted_by === user.id
  }

  const typedComments = (comments ?? []) as CommentWithProfile[]
  const p1Color = game.player1_color
  const p2Color = p1Color === 'white' ? 'black' : 'white'

  return (
    <>
      <Link href="/" className={styles.backLink}>
        ← All games
      </Link>

      <div className={styles.playersPanel}>
        <div className={styles.playersGrid}>
          <div className={styles.playerCol}>
            <p className={styles.playerName}>
              {game.player1.country} {game.player1.nickname}
            </p>
            <span className={styles.colorChip}>
              <span
                className={`${styles.colorDot} ${p1Color === 'white' ? styles.colorDotWhite : styles.colorDotBlack}`}
              />
              {p1Color === 'white' ? 'White' : 'Black'}
            </span>
            {game.player1_photo_url && (
              <img
                className={styles.playerPhoto}
                src={game.player1_photo_url}
                alt={`${game.player1.nickname} photo`}
              />
            )}
          </div>

          <div className={styles.resultCallout}>
            <p className={styles.resultText}>
              {resultSummary(game.result, game.player1.nickname, game.player2.nickname)}
            </p>
            <p className={styles.tcText}>{game.time_control} · {game.time_control_category}</p>
            <p className={styles.dateText}>
              {new Date(game.game_date).toLocaleDateString('en-US', {
                month: 'short',
                day: 'numeric',
                year: 'numeric',
              })}
            </p>
          </div>

          <div className={`${styles.playerCol} ${styles.playerColRight}`}>
            <p className={styles.playerName}>
              {game.player2.country} {game.player2.nickname}
            </p>
            <span className={styles.colorChip}>
              <span
                className={`${styles.colorDot} ${p2Color === 'white' ? styles.colorDotWhite : styles.colorDotBlack}`}
              />
              {p2Color === 'white' ? 'White' : 'Black'}
            </span>
            {game.player2_photo_url && (
              <img
                className={styles.playerPhoto}
                src={game.player2_photo_url}
                alt={`${game.player2.nickname} photo`}
              />
            )}
          </div>
        </div>

        {canEdit && (
          <div className={styles.editRow}>
            <Link href={`/games/${id}/edit`} className={styles.editLink}>
              ✎ Edit game
            </Link>
          </div>
        )}
      </div>

      <div className={styles.commentsSection}>
        <h2 className={styles.commentsTitle}>Comments</h2>
        <RealtimeComments
          gameId={id}
          initialComments={typedComments}
          userId={user?.id ?? null}
        />
        {!user && <InlineSignUp />}
      </div>
    </>
  )
}
