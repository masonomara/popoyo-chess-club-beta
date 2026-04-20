'use client'

import { useActionState, startTransition } from 'react'
import { addApprovedEmail, removeApprovedEmail, type AdminState } from '@/app/actions/admin'
import type { Tables } from '@/app/types/database'
import styles from './AdminPanel.module.css'

type ApprovedEmailWithProfile = Tables<'approved_emails'> & {
  profiles: Tables<'profiles'> | null
}

export default function AdminPanel({
  emails,
}: {
  emails: ApprovedEmailWithProfile[]
}) {
  const [addState, addDispatch, addPending] = useActionState<AdminState, FormData>(
    addApprovedEmail,
    null
  )
  const [removeState, removeDispatch, removePending] = useActionState<AdminState, FormData>(
    removeApprovedEmail,
    null
  )

  function handleAdd(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    const formData = new FormData(e.currentTarget)
    startTransition(() => {
      addDispatch(formData)
    })
  }

  function handleRemove(id: string) {
    const formData = new FormData()
    formData.set('id', id)
    startTransition(() => {
      removeDispatch(formData)
    })
  }

  return (
    <div>
      <form onSubmit={handleAdd} className={styles.addForm}>
        <input
          type="email"
          name="email"
          placeholder="new@example.com"
          required
          disabled={addPending}
          className={styles.addInput}
        />
        <button type="submit" disabled={addPending}>
          {addPending ? 'Adding…' : 'Add Email'}
        </button>
      </form>
      {addState?.error && <p role="alert">{addState.error}</p>}
      {removeState?.error && <p role="alert">{removeState.error}</p>}

      {emails.length === 0 ? (
        <p className={styles.empty}>No approved emails yet.</p>
      ) : (
        <table className={styles.table}>
          <thead>
            <tr>
              <th>Email</th>
              <th>Added by</th>
              <th>Added</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {emails.map((entry) => (
              <tr key={entry.id}>
                <td className={styles.email}>{entry.email}</td>
                <td className={styles.addedBy}>{entry.profiles?.nickname ?? '—'}</td>
                <td className={styles.date}>
                  {new Date(entry.created_at).toLocaleDateString()}
                </td>
                <td>
                  <button
                    type="button"
                    onClick={() => handleRemove(entry.id)}
                    disabled={removePending}
                    className={styles.removeBtn}
                  >
                    Remove
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  )
}
