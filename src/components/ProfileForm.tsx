'use client'

import { useActionState, useState, startTransition } from 'react'
import {
  updateProfile,
  updateEmail,
  updatePassword,
  type ProfileState,
} from '@/actions/profile'
import { COUNTRIES } from '@/lib/countries'
import styles from './ProfileForm.module.css'

function errorMsg(state: ProfileState): string | null {
  if (state && 'error' in state) return state.error
  return null
}

function successMsg(state: ProfileState): string | null {
  if (state && 'success' in state) return state.success
  return null
}

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
    startTransition(() => profileDispatch(formData))
  }

  function handleEmail(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    const formData = new FormData(e.currentTarget)
    startTransition(() => emailDispatch(formData))
  }

  function handlePassword(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    const formData = new FormData(e.currentTarget)
    const password = formData.get('password') as string
    const confirm = formData.get('confirm') as string
    if (password !== confirm) {
      setPasswordMismatch(true)
      return
    }
    setPasswordMismatch(false)
    startTransition(() => passwordDispatch(formData))
  }

  return (
    <div className={styles.sections}>
      <div className={styles.section}>
        <h2 className={styles.sectionTitle}>Display Info</h2>
        <form onSubmit={handleProfile} className={styles.form}>
          <div className={styles.fieldRow}>
            <div className={styles.field}>
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
            <div className={styles.field}>
              <label htmlFor="profile-country">Country</label>
              <select
                id="profile-country"
                name="country"
                defaultValue={country}
                required
                disabled={profilePending}
              >
                <option value="">Select…</option>
                {COUNTRIES.map((c) => (
                  <option key={c.value} value={c.value}>{c.label}</option>
                ))}
              </select>
            </div>
          </div>
          {errorMsg(profileState) && <p role="alert">{errorMsg(profileState)}</p>}
          {successMsg(profileState) && <p role="status">{successMsg(profileState)}</p>}
          <button type="submit" disabled={profilePending} className={styles.saveBtn}>
            {profilePending ? 'Saving…' : 'Save'}
          </button>
        </form>
      </div>

      <div className={styles.section}>
        <h2 className={styles.sectionTitle}>Email</h2>
        <form onSubmit={handleEmail} className={styles.form}>
          <div className={styles.field}>
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
          {errorMsg(emailState) && <p role="alert">{errorMsg(emailState)}</p>}
          {successMsg(emailState) && <p role="status">{successMsg(emailState)}</p>}
          <button type="submit" disabled={emailPending} className={styles.saveBtn}>
            {emailPending ? 'Updating…' : 'Update Email'}
          </button>
        </form>
      </div>

      <div className={styles.section}>
        <h2 className={styles.sectionTitle}>Password</h2>
        <form onSubmit={handlePassword} className={styles.form}>
          <div className={styles.field}>
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
          <div className={styles.field}>
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
          {errorMsg(passwordState) && <p role="alert">{errorMsg(passwordState)}</p>}
          {successMsg(passwordState) && <p role="status">{successMsg(passwordState)}</p>}
          <button type="submit" disabled={passwordPending} className={styles.saveBtn}>
            {passwordPending ? 'Updating…' : 'Update Password'}
          </button>
        </form>
      </div>
    </div>
  )
}
