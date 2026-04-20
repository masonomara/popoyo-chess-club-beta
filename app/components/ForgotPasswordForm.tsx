'use client'

import Link from 'next/link'
import { useActionState, useState, startTransition } from 'react'
import { forgotPassword, type AuthState } from '@/app/actions/auth'

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
        <p>Check your inbox — we sent a password reset link.</p>
        <Link href="/anteup">Back to sign in</Link>
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
    <form onSubmit={handleSubmit}>
      {invalidLink && <p role="alert">Reset link is invalid or expired. Try again.</p>}
      <div>
        <label htmlFor="forgot-email">Email</label>
        <input
          id="forgot-email"
          name="email"
          type="email"
          autoComplete="email"
          required
          disabled={pending}
        />
      </div>
      {state?.error && <p role="alert">{state.error}</p>}
      <button type="submit" disabled={pending}>
        {pending ? 'Sending…' : 'Send Reset Link'}
      </button>
      <Link href="/anteup">Back to sign in</Link>
    </form>
  )
}
