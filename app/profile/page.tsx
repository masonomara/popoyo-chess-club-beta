import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import ProfileForm from '@/app/components/ProfileForm'
import styles from './page.module.css'

export default async function ProfilePage() {
  const supabase = await createClient()

  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) redirect('/')

  const { data: profile } = await supabase
    .from('profiles')
    .select('nickname, country, email')
    .eq('id', user.id)
    .single()

  if (!profile) redirect('/')

  return (
    <>
      <h1 className={styles.title}>Profile Settings</h1>
      <ProfileForm
        nickname={profile.nickname}
        country={profile.country}
        email={profile.email}
      />
    </>
  )
}
