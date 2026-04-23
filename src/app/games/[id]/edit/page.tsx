import { notFound, redirect } from 'next/navigation'
import Link from 'next/link'
import { createClient } from '@/lib/supabase/server'
import EditGameForm from '@/components/EditGameForm'
import styles from './page.module.css'

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
    supabase.from('games').select('*').eq('id', id).single(),
    supabase.from('profiles').select('*').in('role', ['admin', 'member']).order('nickname'),
    supabase.from('profiles').select('role').eq('id', user.id).single(),
  ])

  if (!game) notFound()

  if (profile?.role !== 'admin' && profile?.role !== 'member') redirect('/')

  return (
    <>
      <Link href={`/games/${id}`} className={styles.backLink}>
        ← Back to game
      </Link>
      <h1 className={styles.title}>Edit Game</h1>
      <EditGameForm game={game} players={players ?? []} />
    </>
  )
}
