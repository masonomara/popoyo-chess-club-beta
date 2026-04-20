'use server'

import { revalidatePath } from 'next/cache'
import { createClient } from '@/lib/supabase/server'
import { z } from 'zod'

export type GameState = { error: string } | null

const SubmitGameSchema = z.object({
  player1_id: z.string().uuid(),
  player2_id: z.string().uuid(),
  player1_color: z.enum(['white', 'black']),
  result: z.enum(['player1_win', 'player2_win', 'draw']),
  time_control: z.string().min(1),
  time_control_category: z.enum(['bullet', 'blitz', 'rapid', 'classical']),
  game_date: z.string().min(1),
  player1_photo_url: z.string().optional(),
  player2_photo_url: z.string().optional(),
})

function getString(fd: FormData, key: string): string {
  const v = fd.get(key)
  return typeof v === 'string' ? v : ''
}

export async function submitGame(
  _prevState: GameState,
  formData: FormData
): Promise<GameState> {
  const supabase = await createClient()

  const {
    data: { user },
  } = await supabase.auth.getUser()
  if (!user) return { error: 'Not authenticated.' }

  const parsed = SubmitGameSchema.safeParse({
    player1_id: getString(formData, 'player1_id'),
    player2_id: getString(formData, 'player2_id'),
    player1_color: getString(formData, 'player1_color'),
    result: getString(formData, 'result'),
    time_control: getString(formData, 'time_control'),
    time_control_category: getString(formData, 'time_control_category'),
    game_date: getString(formData, 'game_date'),
    player1_photo_url: getString(formData, 'player1_photo_url') || undefined,
    player2_photo_url: getString(formData, 'player2_photo_url') || undefined,
  })

  if (!parsed.success) {
    return { error: parsed.error.issues[0]?.message ?? 'Invalid input.' }
  }

  const d = parsed.data

  if (d.player1_id === d.player2_id) return { error: 'Players must be different.' }

  const { error } = await supabase.rpc('submit_game', {
    p_player1_id: d.player1_id,
    p_player2_id: d.player2_id,
    p_player1_color: d.player1_color,
    p_result: d.result,
    p_time_control: d.time_control,
    p_time_control_category: d.time_control_category,
    p_game_date: new Date(d.game_date).toISOString(),
    p_submitted_by: user.id,
    p_player1_photo_url: d.player1_photo_url,
    p_player2_photo_url: d.player2_photo_url,
  })

  if (error) return { error: error.message }

  revalidatePath('/')
  return null
}

const UpdateGameSchema = SubmitGameSchema.extend({
  player1_id: z.string().uuid(),
  player2_id: z.string().uuid(),
})

export async function updateGame(
  gameId: string,
  _prevState: GameState,
  formData: FormData
): Promise<GameState> {
  const supabase = await createClient()

  const {
    data: { user },
  } = await supabase.auth.getUser()
  if (!user) return { error: 'Not authenticated.' }

  const { data: profile } = await supabase
    .from('profiles')
    .select('role')
    .eq('id', user.id)
    .single()

  const { data: game } = await supabase
    .from('games')
    .select('submitted_by')
    .eq('id', gameId)
    .single()

  if (!game) return { error: 'Game not found.' }
  if (profile?.role !== 'admin' && game.submitted_by !== user.id) {
    return { error: 'Not authorized.' }
  }

  const parsed = UpdateGameSchema.safeParse({
    player1_id: getString(formData, 'player1_id'),
    player2_id: getString(formData, 'player2_id'),
    player1_color: getString(formData, 'player1_color'),
    result: getString(formData, 'result'),
    time_control: getString(formData, 'time_control'),
    time_control_category: getString(formData, 'time_control_category'),
    game_date: getString(formData, 'game_date'),
    player1_photo_url: getString(formData, 'player1_photo_url') || undefined,
    player2_photo_url: getString(formData, 'player2_photo_url') || undefined,
  })

  if (!parsed.success) {
    return { error: parsed.error.issues[0]?.message ?? 'Invalid input.' }
  }

  const d = parsed.data

  if (d.player1_id === d.player2_id) return { error: 'Players must be different.' }

  const { error } = await supabase.rpc('update_game', {
    p_game_id: gameId,
    p_player1_id: d.player1_id,
    p_player2_id: d.player2_id,
    p_player1_color: d.player1_color,
    p_result: d.result,
    p_time_control: d.time_control,
    p_time_control_category: d.time_control_category,
    p_game_date: new Date(d.game_date).toISOString(),
    p_player1_photo_url: d.player1_photo_url,
    p_player2_photo_url: d.player2_photo_url,
  })

  if (error) return { error: error.message }

  revalidatePath('/')
  revalidatePath(`/games/${gameId}`)
  return null
}
