'use client'

import { useEffect, useState, useActionState, useRef, startTransition } from 'react'
import { createClient } from '@/lib/supabase/client'
import { submitComment, type CommentState } from '@/actions/comments'
import type { Tables } from '@/types/database'
import styles from './RealtimeComments.module.css'

type CommentWithProfile = Tables<'comments'> & { profiles: Tables<'profiles'> | null }

export default function RealtimeComments({
  gameId,
  initialComments,
  userId,
}: {
  gameId: string
  initialComments: CommentWithProfile[]
  userId: string | null
}) {
  const [comments, setComments] = useState(initialComments)
  const [state, dispatch, pending] = useActionState<CommentState, FormData>(
    submitComment,
    null
  )
  const formRef = useRef<HTMLFormElement>(null)
  const submittedRef = useRef(false)

  useEffect(() => {
    if (submittedRef.current && !pending) {
      if (state === null) {
        formRef.current?.reset()
        submittedRef.current = false
      }
    }
  }, [pending, state])

  useEffect(() => {
    const supabase = createClient()

    const channel = supabase
      .channel(`comments:game_id=eq.${gameId}`)
      .on(
        'postgres_changes',
        {
          event: 'INSERT',
          schema: 'public',
          table: 'comments',
          filter: `game_id=eq.${gameId}`,
        },
        async (payload) => {
          const newComment = payload.new as Tables<'comments'>
          const { data: profile } = await supabase
            .from('profiles')
            .select('*')
            .eq('id', newComment.user_id)
            .single()
          setComments((prev) => {
            if (prev.some((c) => c.id === newComment.id)) return prev
            return [...prev, { ...newComment, profiles: profile }]
          })
        }
      )
      .subscribe()

    return () => {
      supabase.removeChannel(channel)
    }
  }, [gameId])

  function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    const formData = new FormData(e.currentTarget)
    submittedRef.current = true
    startTransition(() => {
      dispatch(formData)
    })
  }

  return (
    <div>
      {comments.length === 0 ? (
        <p className={styles.empty}>No comments yet.</p>
      ) : (
        <ul className={styles.list}>
          {comments.map((comment) => (
            <li key={comment.id} className={styles.comment}>
              <div className={styles.commentMeta}>
                <span className={styles.commentAuthor}>
                  {comment.profiles?.nickname ?? 'Unknown'}
                </span>
                <span className={styles.commentDate}>
                  {new Date(comment.created_at).toLocaleDateString('en-US', {
                    month: 'short',
                    day: 'numeric',
                  })}
                </span>
              </div>
              <p className={styles.commentBody}>{comment.body}</p>
            </li>
          ))}
        </ul>
      )}

      {userId && (
        <form ref={formRef} onSubmit={handleSubmit} className={styles.form}>
          <input type="hidden" name="game_id" value={gameId} />
          <textarea
            name="body"
            placeholder="Add a comment…"
            required
            maxLength={2000}
            disabled={pending}
          />
          {state?.error && <p role="alert">{state.error}</p>}
          <button type="submit" disabled={pending} className={styles.postBtn}>
            {pending ? 'Posting…' : 'Post comment'}
          </button>
        </form>
      )}
    </div>
  )
}
