'use client'

import { useActionState, startTransition } from 'react'
import { resetPassword, type AuthState } from '@/app/actions/auth'

export default function UpdatePasswordForm() {
  const [state, dispatch, pending] = useActionState<AuthState, FormData>(
    resetPassword,
    null
  )

  function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    const form = e.currentTarget
    const formData = new FormData(form)
    const password = formData.get('password') as string
    const confirm = formData.get('confirm') as string

    if (password !== confirm) {
      return
    }

    startTransition(() => {
      dispatch(formData)
    })
  }

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <label htmlFor="new-password">New password</label>
        <input
          id="new-password"
          name="password"
          type="password"
          autoComplete="new-password"
          minLength={6}
          required
          disabled={pending}
        />
      </div>
      <div>
        <label htmlFor="confirm-password">Confirm password</label>
        <input
          id="confirm-password"
          name="confirm"
          type="password"
          autoComplete="new-password"
          minLength={6}
          required
          disabled={pending}
        />
      </div>
      {state?.error && <p role="alert">{state.error}</p>}
      <button type="submit" disabled={pending}>
        {pending ? 'Updating…' : 'Update Password'}
      </button>
    </form>
  )
}
