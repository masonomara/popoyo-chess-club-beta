import { createClient } from '@/lib/supabase/server'
import Link from 'next/link'
import AddGameSheet from './AddGameSheet'
import type { Tables } from '@/types/database'
import styles from './HeaderActions.module.css'

export default async function HeaderActions() {
  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) return null

  const { data: profile } = await supabase
    .from('profiles')
    .select('role')
    .eq('id', user.id)
    .single()

  const userRole = profile?.role ?? null
  const canAddGame = userRole === 'admin' || userRole === 'member'

  let players: Tables<'profiles'>[] = []
  if (canAddGame) {
    const { data } = await supabase
      .from('profiles')
      .select('*')
      .in('role', ['admin', 'member'])
      .order('nickname')
    players = data ?? []
  }

  return (
    <nav className={styles.headerNav}>
      {canAddGame && <AddGameSheet players={players} />}
      <Link href="/profile" className={styles.headerNavBtn}>
        Profile
      </Link>
    </nav>
  )
}
