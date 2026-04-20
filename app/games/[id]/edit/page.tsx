import { notFound, redirect } from 'next/navigation'
import Link from 'next/link'
import { createClient } from '@/lib/supabase/server'
import EditGameForm from '@/app/components/EditGameForm'

export default async function EditGamePage({
  params,
}: {
  params: Promise<{ id: string }>
}) {
  const { id } = await params
  const supabase = await createClient()

  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) redirect('/')

  const [{ data: game }, { data: players }, { data: profile }] = await Promise.all([
    supabase
      .from('games')
      .select('*')
      .eq('id', id)
      .single(),
    supabase
      .from('profiles')
      .select('*')
      .in('role', ['admin', 'member'])
      .order('nickname'),
    supabase.from('profiles').select('role').eq('id', user.id).single(),
  ])

  if (!game) notFound()

  const isAdmin = profile?.role === 'admin'
  const isSubmitter = game.submitted_by === user.id

  if (!isAdmin && !isSubmitter) redirect('/')

  return (
    <main>
      <h1>Edit Game</h1>
      <Link href={`/games/${id}`}>← Back to game</Link>
      <EditGameForm game={game} players={players ?? []} />
    </main>
  )
}
