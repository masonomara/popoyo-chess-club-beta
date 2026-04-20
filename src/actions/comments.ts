'use server'

import { revalidatePath } from 'next/cache'
import { createClient } from '@/lib/supabase/server'
import { z } from 'zod'

export type CommentState = { error: string } | null

const SubmitCommentSchema = z.object({
  game_id: z.string().uuid(),
  body: z.string().min(1).max(2000),
})

function getString(fd: FormData, key: string): string {
  const v = fd.get(key)
  return typeof v === 'string' ? v : ''
}

export async function submitComment(
  _prevState: CommentState,
  formData: FormData
): Promise<CommentState> {
  const supabase = await createClient()

  const {
    data: { user },
  } = await supabase.auth.getUser()
  if (!user) return { error: 'Not authenticated.' }

  const parsed = SubmitCommentSchema.safeParse({
    game_id: getString(formData, 'game_id'),
    body: getString(formData, 'body'),
  })

  if (!parsed.success) {
    return { error: parsed.error.issues[0]?.message ?? 'Invalid input.' }
  }

  const { error } = await supabase.from('comments').insert({
    game_id: parsed.data.game_id,
    user_id: user.id,
    body: parsed.data.body,
  })

  if (error) return { error: error.message }

  revalidatePath(`/games/${parsed.data.game_id}`)
  return null
}
