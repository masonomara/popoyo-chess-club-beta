import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import UpdatePasswordForm from '@/components/UpdatePasswordForm'
import styles from './page.module.css'

export default async function UpdatePasswordPage() {
  const supabase = await createClient()

  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) redirect('/forgot-password')

  return (
    <div className={styles.wrap}>
      <div className={styles.card}>
        <h1 className={styles.title}>Set New Password</h1>
        <p className={styles.subtitle}>Choose a strong password for your account.</p>
        <UpdatePasswordForm />
      </div>
    </div>
  )
}
