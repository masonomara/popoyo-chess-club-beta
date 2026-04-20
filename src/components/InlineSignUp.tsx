'use client'

import { useActionState, startTransition } from 'react'
import { signUp, type AuthState } from '@/actions/auth'
import { COUNTRIES } from '@/lib/countries'
import styles from './InlineSignUp.module.css'

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
    <div className={styles.card}>
      <p className={styles.heading}>Create an account to leave a comment</p>
      <form onSubmit={handleSubmit}>
        <div className={styles.fields}>
          <div>
            <label htmlFor="inline-email">Email</label>
            <input
              id="inline-email"
              type="email"
              name="email"
              placeholder="you@example.com"
              required
              disabled={pending}
            />
          </div>
          <div>
            <label htmlFor="inline-password">Password</label>
            <input
              id="inline-password"
              type="password"
              name="password"
              placeholder="Min 6 characters"
              required
              disabled={pending}
            />
          </div>
          <div className={styles.fieldRow}>
            <div>
              <label htmlFor="inline-nickname">Nickname</label>
              <input
                id="inline-nickname"
                type="text"
                name="nickname"
                required
                disabled={pending}
              />
            </div>
            <div>
              <label htmlFor="inline-country">Country</label>
              <select
                id="inline-country"
                name="country"
                required
                disabled={pending}
              >
                <option value="">Select…</option>
                {COUNTRIES.map((c) => (
                  <option key={c.value} value={c.value}>{c.label}</option>
                ))}
              </select>
            </div>
          </div>
        </div>
        {state?.error && <p role="alert">{state.error}</p>}
        <button type="submit" disabled={pending}>
          {pending ? 'Creating account…' : 'Create account'}
        </button>
      </form>
    </div>
  )
}
