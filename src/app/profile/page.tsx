import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import ProfileForm from '@/components/ProfileForm'
import AdminPanel from '@/components/AdminPanel'
import type { Tables } from '@/types/database'
import styles from './page.module.css'

type ApprovedEmailWithProfile = Tables<'approved_emails'> & {
  profiles: Tables<'profiles'> | null
}

export default async function ProfilePage() {
  const supabase = await createClient()

  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) redirect('/')

  const { data: profile } = await supabase
    .from('profiles')
    .select('nickname, country, email, role')
    .eq('id', user.id)
    .single()

  if (!profile) redirect('/')

  let emails: ApprovedEmailWithProfile[] = []
  if (profile.role === 'admin') {
    const { data } = await supabase
      .from('approved_emails')
      .select('*, profiles(*)')
      .order('created_at', { ascending: false })
    emails = (data ?? []) as ApprovedEmailWithProfile[]
  }

  return (
    <>
      <h1 className={styles.title}>Profile Settings</h1>
      <ProfileForm
        nickname={profile.nickname}
        country={profile.country}
        email={profile.email}
      />
      {profile.role === 'admin' && (
        <>
          <h2 className={styles.adminTitle}>Approved Emails</h2>
          <AdminPanel emails={emails} />
        </>
      )}
    </>
  )
}
