'use server'

import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { z } from 'zod'

export type EloChange = {
  playerId: string
  nickname: string
  weeklyDelta: number
  monthlyDelta: number
  alltimeDelta: number
  weeklyElo: number
  monthlyElo: number
  alltimeElo: number
}

export type GameState =
  | { error: string }
  | { success: true; eloChanges: EloChange[] }
  | null

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

  const playerIds = [d.player1_id, d.player2_id]

  const { data: beforeRatings } = await supabase
    .from('player_ratings')
    .select('player_id, weekly_elo, monthly_elo, alltime_elo')
    .in('player_id', playerIds)

  const { error } = await supabase.rpc('submit_game', {
    p_player1_id: d.player1_id,
    p_player2_id: d.player2_id,
    p_player1_color: d.player1_color,
    p_result: d.result,
    p_time_control: d.time_control,
    p_time_control_category: d.time_control_category,
    p_game_date: new Date(d.game_date + '-06:00').toISOString(),
    p_submitted_by: user.id,
    p_player1_photo_url: d.player1_photo_url,
    p_player2_photo_url: d.player2_photo_url,
  })

  if (error) return { error: error.message }

  const [{ data: afterRatings }, { data: profiles }] = await Promise.all([
    supabase
      .from('player_ratings')
      .select('player_id, weekly_elo, monthly_elo, alltime_elo')
      .in('player_id', playerIds),
    supabase
      .from('profiles')
      .select('id, nickname')
      .in('id', playerIds),
  ])

  const getElo = (
    rows: typeof beforeRatings,
    id: string,
    field: 'weekly_elo' | 'monthly_elo' | 'alltime_elo'
  ) => rows?.find(r => r.player_id === id)?.[field] ?? 1500

  const eloChanges: EloChange[] = playerIds.map(id => ({
    playerId: id,
    nickname: profiles?.find(p => p.id === id)?.nickname ?? 'Unknown',
    weeklyDelta:  Math.round(getElo(afterRatings, id, 'weekly_elo')  - getElo(beforeRatings, id, 'weekly_elo')),
    monthlyDelta: Math.round(getElo(afterRatings, id, 'monthly_elo') - getElo(beforeRatings, id, 'monthly_elo')),
    alltimeDelta: Math.round(getElo(afterRatings, id, 'alltime_elo') - getElo(beforeRatings, id, 'alltime_elo')),
    weeklyElo:   getElo(afterRatings, id, 'weekly_elo'),
    monthlyElo:  getElo(afterRatings, id, 'monthly_elo'),
    alltimeElo:  getElo(afterRatings, id, 'alltime_elo'),
  }))

  revalidatePath('/')
  return { success: true, eloChanges }
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

  const [{ data: profile }, { data: oldGame }] = await Promise.all([
    supabase.from('profiles').select('role').eq('id', user.id).single(),
    supabase.from('games').select('player1_id, player2_id, player1_color, result, time_control, game_date').eq('id', gameId).single(),
  ])

  if (profile?.role !== 'admin' && profile?.role !== 'member') {
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
    p_game_date: new Date(d.game_date + '-06:00').toISOString(),
    p_player1_photo_url: d.player1_photo_url,
    p_player2_photo_url: d.player2_photo_url,
  })

  if (error) return { error: error.message }

  // Build descriptive edit comment
  if (oldGame) {
    const playerIds = [...new Set([oldGame.player1_id, oldGame.player2_id, d.player1_id, d.player2_id])]
    const { data: players } = await supabase.from('profiles').select('id, nickname').in('id', playerIds)
    const name = (id: string) => players?.find((p) => p.id === id)?.nickname ?? 'Unknown'

    const fmtResult = (r: string, p1Id: string, p2Id: string) => {
      if (r === 'player1_win') return `${name(p1Id)} wins`
      if (r === 'player2_win') return `${name(p2Id)} wins`
      return 'Draw'
    }
    const fmtDate = (iso: string) =>
      new Date(iso).toLocaleDateString('en-US', { timeZone: 'America/Managua', month: 'short', day: 'numeric', year: 'numeric' })

    const changes: string[] = []

    const oldMatchup = `${name(oldGame.player1_id)} (${oldGame.player1_color}) vs ${name(oldGame.player2_id)}`
    const newMatchup = `${name(d.player1_id)} (${d.player1_color}) vs ${name(d.player2_id)}`
    if (oldMatchup !== newMatchup) changes.push(`Matchup: ${oldMatchup} → ${newMatchup}`)

    if (oldGame.result !== d.result) {
      changes.push(`Result: ${fmtResult(oldGame.result, oldGame.player1_id, oldGame.player2_id)} → ${fmtResult(d.result, d.player1_id, d.player2_id)}`)
    }
    if (oldGame.time_control !== d.time_control) {
      changes.push(`Time control: ${oldGame.time_control} → ${d.time_control}`)
    }
    const oldDate = fmtDate(oldGame.game_date)
    const newDate = fmtDate(new Date(d.game_date + '-06:00').toISOString())
    if (oldDate !== newDate) changes.push(`Date: ${oldDate} → ${newDate}`)

    const body = changes.length > 0
      ? `Game updated:\n${changes.map((c) => `• ${c}`).join('\n')}`
      : 'Game updated.'

    await supabase.from('comments').insert({ game_id: gameId, user_id: user.id, body })
  }

  revalidatePath('/')
  revalidatePath(`/games/${gameId}`)
  return null
}

export async function deleteGame(
  gameId: string,
  _prevState: GameState,
  _formData: FormData
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

  if (profile?.role !== 'admin' && profile?.role !== 'member') {
    return { error: 'Not authorized.' }
  }

  const { error } = await supabase.rpc('delete_game', { p_game_id: gameId })
  if (error) return { error: error.message }

  revalidatePath('/')
  redirect('/')
}
