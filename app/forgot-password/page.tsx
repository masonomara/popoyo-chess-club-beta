import ForgotPasswordForm from '@/app/components/ForgotPasswordForm'
import styles from './page.module.css'

export default async function ForgotPasswordPage({
  searchParams,
}: {
  searchParams: Promise<{ error?: string }>
}) {
  const { error } = await searchParams
  const invalidLink = error === 'invalid_link'

  return (
    <div className={styles.wrap}>
      <div className={styles.card}>
        <h1 className={styles.title}>Reset Password</h1>
        <p className={styles.subtitle}>
          Enter your email and we&apos;ll send a reset link.
        </p>
        <ForgotPasswordForm invalidLink={invalidLink} />
      </div>
    </div>
  )
}
