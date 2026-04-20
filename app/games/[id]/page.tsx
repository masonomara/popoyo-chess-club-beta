import { notFound } from 'next/navigation'
import Link from 'next/link'
import { createClient } from '@/lib/supabase/server'
import RealtimeComments from '@/app/components/RealtimeComments'
import InlineSignUp from '@/app/components/InlineSignUp'
import type { Tables } from '@/app/types/database'

type CommentWithProfile = Tables<'comments'> & { profiles: Tables<'profiles'> | null }

function resultLabel(
  result: Tables<'games'>['result'],
  player1Nickname: string,
  player2Nickname: string
): string {
  if (result === 'draw') return `${player1Nickname} drew ${player2Nickname}`
  if (result === 'player1_win') return `${player1Nickname} defeated ${player2Nickname}`
  return `${player2Nickname} defeated ${player1Nickname}`
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

  return (
    <main>
      <section>
        <div>
          <div>
            <p>{game.player1.country} {game.player1.nickname}</p>
            <p>{game.player1_color === 'white' ? 'White' : 'Black'}</p>
            {game.player1_photo_url && (
              <img src={game.player1_photo_url} alt={`${game.player1.nickname} photo`} />
            )}
          </div>

          <div>
            <p>{resultLabel(game.result, game.player1.nickname, game.player2.nickname)}</p>
            <p>{game.time_control} · {game.time_control_category}</p>
            <p>{new Date(game.game_date).toLocaleDateString()}</p>
          </div>

          <div>
            <p>{game.player2.country} {game.player2.nickname}</p>
            <p>{game.player1_color === 'white' ? 'Black' : 'White'}</p>
            {game.player2_photo_url && (
              <img src={game.player2_photo_url} alt={`${game.player2.nickname} photo`} />
            )}
          </div>
        </div>

        {canEdit && (
          <Link href={`/games/${id}/edit`}>Edit</Link>
        )}
      </section>

      <section>
        <h2>Comments</h2>
        <RealtimeComments
          gameId={id}
          initialComments={typedComments}
          userId={user?.id ?? null}
        />
        {!user && <InlineSignUp />}
      </section>
    </main>
  )
}
