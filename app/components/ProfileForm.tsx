'use client'

import { useActionState, useState, startTransition } from 'react'
import {
  updateProfile,
  updateEmail,
  updatePassword,
  type ProfileState,
} from '@/app/actions/profile'

export default function ProfileForm({
  nickname,
  country,
  email,
}: {
  nickname: string
  country: string
  email: string
}) {
  const [profileState, profileDispatch, profilePending] = useActionState<
    ProfileState,
    FormData
  >(updateProfile, null)

  const [emailState, emailDispatch, emailPending] = useActionState<ProfileState, FormData>(
    updateEmail,
    null
  )

  const [passwordState, passwordDispatch, passwordPending] = useActionState<
    ProfileState,
    FormData
  >(updatePassword, null)

  const [passwordMismatch, setPasswordMismatch] = useState(false)

  function handleProfile(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    const formData = new FormData(e.currentTarget)
    startTransition(() => {
      profileDispatch(formData)
    })
  }

  function handleEmail(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    const formData = new FormData(e.currentTarget)
    startTransition(() => {
      emailDispatch(formData)
    })
  }

  function handlePassword(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    const form = e.currentTarget
    const formData = new FormData(form)
    const password = formData.get('password') as string
    const confirm = formData.get('confirm') as string

    if (password !== confirm) {
      setPasswordMismatch(true)
      return
    }

    setPasswordMismatch(false)
    startTransition(() => {
      passwordDispatch(formData)
    })
  }

  return (
    <div>
      <section>
        <h2>Display Info</h2>
        <form onSubmit={handleProfile}>
          <div>
            <label htmlFor="profile-nickname">Nickname</label>
            <input
              id="profile-nickname"
              name="nickname"
              type="text"
              defaultValue={nickname}
              maxLength={50}
              required
              disabled={profilePending}
            />
          </div>
          <div>
            <label htmlFor="profile-country">Country</label>
            <input
              id="profile-country"
              name="country"
              type="text"
              defaultValue={country}
              maxLength={10}
              required
              disabled={profilePending}
            />
          </div>
          {'error' in (profileState ?? {}) && (
            <p role="alert">{(profileState as { error: string }).error}</p>
          )}
          {'success' in (profileState ?? {}) && (
            <p role="status">{(profileState as { success: string }).success}</p>
          )}
          <button type="submit" disabled={profilePending}>
            {profilePending ? 'Saving…' : 'Save'}
          </button>
        </form>
      </section>

      <section>
        <h2>Email</h2>
        <form onSubmit={handleEmail}>
          <div>
            <label htmlFor="profile-email">New email</label>
            <input
              id="profile-email"
              name="email"
              type="email"
              defaultValue={email}
              autoComplete="email"
              required
              disabled={emailPending}
            />
          </div>
          {'error' in (emailState ?? {}) && (
            <p role="alert">{(emailState as { error: string }).error}</p>
          )}
          {'success' in (emailState ?? {}) && (
            <p role="status">{(emailState as { success: string }).success}</p>
          )}
          <button type="submit" disabled={emailPending}>
            {emailPending ? 'Updating…' : 'Update Email'}
          </button>
        </form>
      </section>

      <section>
        <h2>Password</h2>
        <form onSubmit={handlePassword}>
          <div>
            <label htmlFor="profile-password">New password</label>
            <input
              id="profile-password"
              name="password"
              type="password"
              autoComplete="new-password"
              minLength={6}
              required
              disabled={passwordPending}
            />
          </div>
          <div>
            <label htmlFor="profile-confirm">Confirm password</label>
            <input
              id="profile-confirm"
              name="confirm"
              type="password"
              autoComplete="new-password"
              minLength={6}
              required
              disabled={passwordPending}
            />
          </div>
          {passwordMismatch && <p role="alert">Passwords do not match.</p>}
          {'error' in (passwordState ?? {}) && (
            <p role="alert">{(passwordState as { error: string }).error}</p>
          )}
          {'success' in (passwordState ?? {}) && (
            <p role="status">{(passwordState as { success: string }).success}</p>
          )}
          <button type="submit" disabled={passwordPending}>
            {passwordPending ? 'Updating…' : 'Update Password'}
          </button>
        </form>
      </section>
    </div>
  )
}
