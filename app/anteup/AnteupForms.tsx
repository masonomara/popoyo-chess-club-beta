'use client'

import Link from 'next/link'
import { useState, useActionState } from 'react'
import { signIn, signUp, type AuthState } from '@/app/actions/auth'

function SignInForm() {
  const [state, action, pending] = useActionState<AuthState, FormData>(
    signIn,
    null
  )

  return (
    <form action={action}>
      <div>
        <label htmlFor="signin-email">Email</label>
        <input
          id="signin-email"
          name="email"
          type="email"
          autoComplete="email"
          required
        />
      </div>
      <div>
        <label htmlFor="signin-password">Password</label>
        <input
          id="signin-password"
          name="password"
          type="password"
          autoComplete="current-password"
          required
        />
      </div>
      {state?.error && <p role="alert">{state.error}</p>}
      <button type="submit" disabled={pending}>
        {pending ? 'Signing in…' : 'Sign In'}
      </button>
      <Link href="/forgot-password">Forgot password?</Link>
    </form>
  )
}

function SignUpForm() {
  const [state, action, pending] = useActionState<AuthState, FormData>(
    signUp,
    null
  )

  return (
    <form action={action}>
      <div>
        <label htmlFor="signup-email">Email</label>
        <input
          id="signup-email"
          name="email"
          type="email"
          autoComplete="email"
          required
        />
      </div>
      <div>
        <label htmlFor="signup-password">Password</label>
        <input
          id="signup-password"
          name="password"
          type="password"
          autoComplete="new-password"
          required
        />
      </div>
      <div>
        <label htmlFor="signup-nickname">Nickname</label>
        <input
          id="signup-nickname"
          name="nickname"
          type="text"
          autoComplete="nickname"
          required
        />
      </div>
      <div>
        <label htmlFor="signup-country">Country code (e.g. US, NI, CR)</label>
        <input
          id="signup-country"
          name="country"
          type="text"
          maxLength={2}
          placeholder="US"
          required
        />
      </div>
      {state?.error && <p role="alert">{state.error}</p>}
      <button type="submit" disabled={pending}>
        {pending ? 'Creating account…' : 'Create Account'}
      </button>
    </form>
  )
}

export default function AnteupForms() {
  const [tab, setTab] = useState<'signin' | 'signup'>('signin')

  return (
    <div>
      <nav>
        <button
          onClick={() => setTab('signin')}
          aria-current={tab === 'signin' ? 'page' : undefined}
        >
          Sign In
        </button>
        <button
          onClick={() => setTab('signup')}
          aria-current={tab === 'signup' ? 'page' : undefined}
        >
          Sign Up
        </button>
      </nav>
      {tab === 'signin' ? <SignInForm /> : <SignUpForm />}
    </div>
  )
}
