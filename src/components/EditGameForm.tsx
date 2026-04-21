'use client'

import { useState, useActionState, startTransition } from 'react'
import { createClient } from '@/lib/supabase/client'
import { updateGame, type GameState } from '@/actions/games'
import type { Tables } from '@/types/database'
import styles from './EditGameForm.module.css'

const CATEGORY_ORDER = ['bullet', 'blitz', 'rapid', 'classical'] as const

const TIME_CONTROLS: Record<Tables<'games'>['time_control_category'], string[]> = {
  bullet: ['0+1', '1+0', '1+1', '2+1'],
  blitz: ['3+0', '3+2', '5+0', '5+3'],
  rapid: ['10+0', '10+5', '15+0', '15+10'],
  classical: ['25+0', '30+0', '30+20', '60+0'],
}

const TC_CATEGORY_MAP = new Map<string, Tables<'games'>['time_control_category']>([
  ['0+1', 'bullet'], ['1+0', 'bullet'], ['1+1', 'bullet'], ['2+1', 'bullet'],
  ['3+0', 'blitz'], ['3+2', 'blitz'], ['5+0', 'blitz'], ['5+3', 'blitz'],
  ['10+0', 'rapid'], ['10+5', 'rapid'], ['15+0', 'rapid'], ['15+10', 'rapid'],
  ['25+0', 'classical'], ['30+0', 'classical'], ['30+20', 'classical'], ['60+0', 'classical'],
])

function toNicaDatetimeString(isoStr: string): string {
  const d = new Date(isoStr)
  const parts = new Intl.DateTimeFormat('en-CA', {
    timeZone: 'America/Managua',
    year: 'numeric', month: '2-digit', day: '2-digit',
    hour: '2-digit', minute: '2-digit', hour12: false,
  }).formatToParts(d)
  const get = (t: string) => parts.find(p => p.type === t)?.value ?? ''
  return `${get('year')}-${get('month')}-${get('day')}T${get('hour')}:${get('minute')}`
}

export default function EditGameForm({
  game,
  players,
}: {
  game: Tables<'games'>
  players: Tables<'profiles'>[]
}) {
  const [player1Id, setPlayer1Id] = useState(game.player1_id)
  const [player2Id, setPlayer2Id] = useState(game.player2_id)
  const [player1Color, setPlayer1Color] = useState<Tables<'games'>['player1_color']>(
    game.player1_color
  )
  const [isDraw, setIsDraw] = useState(game.result === 'draw')
  const [timeControl, setTimeControl] = useState(game.time_control)
  const [gameDate, setGameDate] = useState(toNicaDatetimeString(game.game_date))
  const [player1File, setPlayer1File] = useState<File | null>(null)
  const [player2File, setPlayer2File] = useState<File | null>(null)
  const [uploadPending, setUploadPending] = useState(false)
  const [uploadError, setUploadError] = useState<string | null>(null)

  const boundAction = updateGame.bind(null, game.id)
  const [state, dispatch, actionPending] = useActionState<GameState, FormData>(
    boundAction,
    null
  )
  const pending = uploadPending || actionPending

  const supabase = createClient()

  const MAX_FILE_SIZE = 50 * 1024 * 1024

  async function uploadFile(file: File, label: string): Promise<string> {
    const ext = file.name.split('.').pop() ?? 'jpg'
    const path = `${Date.now()}-${label}.${ext}`
    const timeout = new Promise<never>((_, reject) =>
      setTimeout(() => reject(new Error('Upload timed out')), 30_000)
    )
    const { error } = await Promise.race([
      supabase.storage.from('game-photos').upload(path, file),
      timeout,
    ])
    if (error) throw error
    return supabase.storage.from('game-photos').getPublicUrl(path).data.publicUrl
  }

  async function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    setUploadError(null)

    if (player1File && player1File.size > MAX_FILE_SIZE) {
      setUploadError('Player 1 photo is too large (max 50 MB).')
      return
    }
    if (player2File && player2File.size > MAX_FILE_SIZE) {
      setUploadError('Player 2 photo is too large (max 50 MB).')
      return
    }

    setUploadPending(true)
    const formData = new FormData()
    formData.set('player1_id', player1Id)
    formData.set('player2_id', player2Id)
    formData.set('player1_color', player1Color)
    formData.set('result', isDraw ? 'draw' : 'player1_win')
    formData.set('time_control', timeControl)
    formData.set('time_control_category', TC_CATEGORY_MAP.get(timeControl) ?? 'rapid')
    formData.set('game_date', gameDate)

    try {
      const [p1Url, p2Url] = await Promise.all([
        player1File ? uploadFile(player1File, 'p1') : Promise.resolve(game.player1_photo_url),
        player2File ? uploadFile(player2File, 'p2') : Promise.resolve(game.player2_photo_url),
      ])
      if (p1Url) formData.set('player1_photo_url', p1Url)
      if (p2Url) formData.set('player2_photo_url', p2Url)
    } catch {
      setUploadPending(false)
      setUploadError('Photo upload failed. Please try a smaller image or try again.')
      return
    }

    setUploadPending(false)
    startTransition(() => dispatch(formData))
  }

  function handlePlayer1Change(newId: string) {
    setPlayer1Id(newId)
    if (player2Id === newId) {
      const next = players.find((p) => p.id !== newId)
      setPlayer2Id(next?.id ?? '')
    }
  }

  const player2Options = players.filter((p) => p.id !== player1Id)

  return (
    <div className={styles.wrap}>
      <form onSubmit={handleSubmit}>
        <div className={styles.gameRow}>
          <select
            value={player1Id}
            onChange={(e) => handlePlayer1Change(e.target.value)}
            required
            className={styles.playerSelect}
          >
            {players.map((p) => (
              <option key={p.id} value={p.id}>{p.nickname}</option>
            ))}
          </select>

          <button
            type="button"
            onClick={() => setPlayer1Color((c) => (c === 'white' ? 'black' : 'white'))}
            className={`${styles.colorBtn} ${player1Color === 'white' ? styles.colorBtnWhite : ''}`}
          >
            {player1Color === 'white' ? '○ White' : '● Black'}
          </button>

          <button
            type="button"
            onClick={() => setIsDraw((d) => !d)}
            className={`${styles.resultBtn} ${isDraw ? styles.resultBtnActive : ''}`}
          >
            {isDraw ? 'Drew' : 'Defeated'}
          </button>

          <select
            value={player2Id}
            onChange={(e) => setPlayer2Id(e.target.value)}
            required
            className={styles.playerSelect}
          >
            {player2Options.map((p) => (
              <option key={p.id} value={p.id}>{p.nickname}</option>
            ))}
          </select>
        </div>

        <div className={styles.fieldGroup}>
          <div>
            <label>Time Control</label>
            <select value={timeControl} onChange={(e) => setTimeControl(e.target.value)}>
              {CATEGORY_ORDER.map((cat) => (
                <optgroup key={cat} label={cat.charAt(0).toUpperCase() + cat.slice(1)}>
                  {TIME_CONTROLS[cat].map((tc) => (
                    <option key={tc} value={tc}>{tc}</option>
                  ))}
                </optgroup>
              ))}
            </select>
          </div>
          <div>
            <label>Date & Time</label>
            <input
              type="datetime-local"
              value={gameDate}
              onChange={(e) => setGameDate(e.target.value)}
              required
            />
          </div>
        </div>

        <div className={styles.photoRow}>
          <div>
            <p className={styles.photoLabel}>
              {players.find((p) => p.id === player1Id)?.nickname ?? 'Player 1'} photo
            </p>
            <input
              type="file"
              accept="image/*"
              onChange={(e) => setPlayer1File(e.target.files?.[0] ?? null)}
            />
          </div>
          <div>
            <p className={styles.photoLabel}>
              {players.find((p) => p.id === player2Id)?.nickname ?? 'Player 2'} photo
            </p>
            <input
              type="file"
              accept="image/*"
              onChange={(e) => setPlayer2File(e.target.files?.[0] ?? null)}
            />
          </div>
        </div>

        {uploadError && <p role="alert">{uploadError}</p>}
        {state?.error && <p role="alert">{state.error}</p>}

        <button type="submit" disabled={pending}>
          {pending ? 'Saving…' : 'Save Changes'}
        </button>
      </form>
    </div>
  )
}
