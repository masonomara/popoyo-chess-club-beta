'use client'

import { useActionState, startTransition } from 'react'
import { signUp, type AuthState } from '@/app/actions/auth'

export default function InlineSignUp() {
  const [state, dispatch, pending] = useActionState<AuthState, FormData>(signUp, null)

  function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    const formData = new FormData(e.currentTarget)
    startTransition(() => {
      dispatch(formData)
    })
  }

  return (
    <form onSubmit={handleSubmit}>
      <p>Create an account to leave a comment</p>
      <input type="email" name="email" placeholder="Email" required disabled={pending} />
      <input
        type="password"
        name="password"
        placeholder="Password"
        required
        disabled={pending}
      />
      <input
        type="text"
        name="nickname"
        placeholder="Nickname"
        required
        disabled={pending}
      />
      <input
        type="text"
        name="country"
        placeholder="Country flag emoji (e.g. 🇺🇸)"
        required
        disabled={pending}
      />
      {state?.error && <p role="alert">{state.error}</p>}
      <button type="submit" disabled={pending}>
        {pending ? 'Creating account…' : 'Create account'}
      </button>
    </form>
  )
}
