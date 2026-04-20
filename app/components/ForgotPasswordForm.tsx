'use client'

import Link from 'next/link'
import { useActionState, useState, startTransition } from 'react'
import { forgotPassword, type AuthState } from '@/app/actions/auth'
import styles from './ForgotPasswordForm.module.css'

export default function ForgotPasswordForm({ invalidLink }: { invalidLink: boolean }) {
  const [state, dispatch, pending] = useActionState<AuthState, FormData>(
    forgotPassword,
    null
  )
  const [dispatched, setDispatched] = useState(false)

  const succeeded = dispatched && !pending && state === null

  if (succeeded) {
    return (
      <div>
        <div className={styles.successCard}>
          <p className={styles.successText}>Check your inbox — we sent a reset link.</p>
        </div>
        <Link href="/anteup" className={styles.backLink}>
          Back to sign in
        </Link>
      </div>
    )
  }

  function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    const formData = new FormData(e.currentTarget)
    setDispatched(true)
    startTransition(() => {
      dispatch(formData)
    })
  }

  return (
    <form onSubmit={handleSubmit} className={styles.form}>
      {invalidLink && (
        <p role="alert">Reset link is invalid or expired. Try again.</p>
      )}
      <div className={styles.field}>
        <label htmlFor="forgot-email">Email</label>
        <input
          id="forgot-email"
          name="email"
          type="email"
          autoComplete="email"
          placeholder="you@example.com"
          required
          disabled={pending}
        />
      </div>
      {state?.error && <p role="alert">{state.error}</p>}
      <button type="submit" disabled={pending}>
        {pending ? 'Sending…' : 'Send Reset Link'}
      </button>
      <Link href="/anteup" className={styles.backLink}>
        Back to sign in
      </Link>
    </form>
  )
}
