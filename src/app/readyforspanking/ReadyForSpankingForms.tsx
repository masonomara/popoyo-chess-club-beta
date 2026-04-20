'use client'

import Link from 'next/link'
import { useState, useActionState } from 'react'
import { signIn, signUp, type AuthState } from '@/actions/auth'
import { COUNTRIES } from '@/lib/countries'
import styles from './ReadyForSpankingForms.module.css'

function SignInForm() {
  const [state, action, pending] = useActionState<AuthState, FormData>(signIn, null)

  return (
    <form action={action} className={styles.form}>
      <div className={styles.field}>
        <label htmlFor="signin-email">Email</label>
        <input
          id="signin-email"
          name="email"
          type="email"
          autoComplete="email"
          required
        />
      </div>
      <div className={styles.field}>
        <label htmlFor="signin-password">Password</label>
        <input
          id="signin-password"
          name="password"
          type="password"
          autoComplete="current-password"
          required
        />
      </div>
      <Link href="/forgot-password" className={styles.forgotLink}>
        Forgot password?
      </Link>
      {state?.error && <p role="alert">{state.error}</p>}
      <button type="submit" disabled={pending}>
        {pending ? 'Signing in…' : 'Sign In'}
      </button>
    </form>
  )
}

function SignUpForm() {
  const [state, action, pending] = useActionState<AuthState, FormData>(signUp, null)

  return (
    <form action={action} className={styles.form}>
      <div className={styles.field}>
        <label htmlFor="signup-email">Email</label>
        <input
          id="signup-email"
          name="email"
          type="email"
          autoComplete="email"
          required
        />
      </div>
      <div className={styles.field}>
        <label htmlFor="signup-password">Password</label>
        <input
          id="signup-password"
          name="password"
          type="password"
          autoComplete="new-password"
          required
        />
      </div>
      <div className={styles.fieldRow}>
        <div className={styles.field}>
          <label htmlFor="signup-nickname">Nickname</label>
          <input
            id="signup-nickname"
            name="nickname"
            type="text"
            autoComplete="nickname"
            required
          />
        </div>
        <div className={styles.field}>
          <label htmlFor="signup-country">Country</label>
          <select
            id="signup-country"
            name="country"
            required
          >
            <option value="">Select…</option>
            {COUNTRIES.map((c) => (
              <option key={c.value} value={c.value}>{c.label}</option>
            ))}
          </select>
        </div>
      </div>
      {state?.error && <p role="alert">{state.error}</p>}
      <button type="submit" disabled={pending}>
        {pending ? 'Creating account…' : 'Create Account'}
      </button>
    </form>
  )
}

export default function ReadyForSpankingForms() {
  const [tab, setTab] = useState<'signin' | 'signup'>('signin')

  return (
    <div>
      <div className={styles.tabs}>
        <button
          type="button"
          onClick={() => setTab('signin')}
          className={`${styles.tab} ${tab === 'signin' ? styles.tabActive : ''}`}
          aria-current={tab === 'signin' ? 'page' : undefined}
        >
          Sign In
        </button>
        <button
          type="button"
          onClick={() => setTab('signup')}
          className={`${styles.tab} ${tab === 'signup' ? styles.tabActive : ''}`}
          aria-current={tab === 'signup' ? 'page' : undefined}
        >
          Sign Up
        </button>
      </div>
      {tab === 'signin' ? <SignInForm /> : <SignUpForm />}
    </div>
  )
}
