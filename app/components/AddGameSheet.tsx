'use client'

import { useState, useActionState, useEffect, useRef } from 'react'
import { createClient } from '@/lib/supabase/client'
import { submitGame, type GameState } from '@/app/actions/games'
import type { Tables } from '@/app/types/database'

const CATEGORY_ORDER = ['bullet', 'blitz', 'rapid', 'classical'] as const

const TIME_CONTROLS: Record<Tables<'games'>['time_control_category'], string[]> = {
  bullet: ['0+1', '1+0', '1+1', '2+1'],
  blitz: ['3+0', '3+2', '5+0', '5+3'],
  rapid: ['10+0', '10+5', '15+0', '15+10'],
  classical: ['25+0', '30+0', '30+20', '60+0'],
}

const TC_CATEGORY_MAP = new Map<string, Tables<'games'>['time_control_category']>([
  ['0+1', 'bullet'],
  ['1+0', 'bullet'],
  ['1+1', 'bullet'],
  ['2+1', 'bullet'],
  ['3+0', 'blitz'],
  ['3+2', 'blitz'],
  ['5+0', 'blitz'],
  ['5+3', 'blitz'],
  ['10+0', 'rapid'],
  ['10+5', 'rapid'],
  ['15+0', 'rapid'],
  ['15+10', 'rapid'],
  ['25+0', 'classical'],
  ['30+0', 'classical'],
  ['30+20', 'classical'],
  ['60+0', 'classical'],
])

function nowLocal(): string {
  const d = new Date()
  d.setSeconds(0, 0)
  return d.toISOString().slice(0, 16)
}

export default function AddGameSheet({
  players,
}: {
  players: Tables<'profiles'>[]
}) {
  const [open, setOpen] = useState(false)
  const [player1Id, setPlayer1Id] = useState(players[0]?.id ?? '')
  const [player2Id, setPlayer2Id] = useState(players[1]?.id ?? '')
  const [player1Color, setPlayer1Color] =
    useState<Tables<'games'>['player1_color']>('white')
  const [isDraw, setIsDraw] = useState(false)
  const [timeControl, setTimeControl] = useState('10+0')
  const [gameDate, setGameDate] = useState(nowLocal)
  const [player1File, setPlayer1File] = useState<File | null>(null)
  const [player2File, setPlayer2File] = useState<File | null>(null)
  const [uploadPending, setUploadPending] = useState(false)

  const [state, dispatch, actionPending] = useActionState<GameState, FormData>(
    submitGame,
    null
  )
  const submittedRef = useRef(false)
  const pending = uploadPending || actionPending

  useEffect(() => {
    if (submittedRef.current && !actionPending) {
      setUploadPending(false)
      if (state === null) {
        setOpen(false)
        submittedRef.current = false
        setPlayer1File(null)
        setPlayer2File(null)
        setIsDraw(false)
        setTimeControl('10+0')
        setGameDate(nowLocal())
      }
    }
  }, [actionPending, state])

  const supabase = createClient()

  async function uploadFile(file: File, label: string): Promise<string | null> {
    const ext = file.name.split('.').pop() ?? 'jpg'
    const path = `${Date.now()}-${label}.${ext}`
    const { error } = await supabase.storage
      .from('game-photos')
      .upload(path, file)
    if (error) return null
    return supabase.storage.from('game-photos').getPublicUrl(path).data.publicUrl
  }

  async function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    setUploadPending(true)

    const formData = new FormData()
    formData.set('player1_id', player1Id)
    formData.set('player2_id', player2Id)
    formData.set('player1_color', player1Color)
    formData.set('result', isDraw ? 'draw' : 'player1_win')
    formData.set('time_control', timeControl)
    formData.set('time_control_category', TC_CATEGORY_MAP.get(timeControl) ?? 'rapid')
    formData.set('game_date', gameDate)

    const [p1Url, p2Url] = await Promise.all([
      player1File ? uploadFile(player1File, 'p1') : Promise.resolve(null),
      player2File ? uploadFile(player2File, 'p2') : Promise.resolve(null),
    ])
    if (p1Url) formData.set('player1_photo_url', p1Url)
    if (p2Url) formData.set('player2_photo_url', p2Url)

    submittedRef.current = true
    dispatch(formData)
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
    <>
      <button type="button" onClick={() => setOpen(true)}>
        Add Game
      </button>

      {open && (
        <div role="dialog" aria-modal="true" aria-label="Add game">
          <div aria-hidden="true" onClick={() => !pending && setOpen(false)} />
          <div>
            <form onSubmit={handleSubmit}>
              <div>
                <select
                  value={player1Id}
                  onChange={(e) => handlePlayer1Change(e.target.value)}
                  required
                >
                  {players.map((p) => (
                    <option key={p.id} value={p.id}>
                      {p.nickname}
                    </option>
                  ))}
                </select>

                <button
                  type="button"
                  onClick={() =>
                    setPlayer1Color((c) => (c === 'white' ? 'black' : 'white'))
                  }
                >
                  {player1Color === 'white' ? 'White' : 'Black'}
                </button>

                <button
                  type="button"
                  onClick={() => setIsDraw((d) => !d)}
                >
                  {isDraw ? 'Drew' : 'Defeats'}
                </button>

                <select
                  value={player2Id}
                  onChange={(e) => setPlayer2Id(e.target.value)}
                  required
                >
                  {player2Options.map((p) => (
                    <option key={p.id} value={p.id}>
                      {p.nickname}
                    </option>
                  ))}
                </select>

                <select
                  value={timeControl}
                  onChange={(e) => setTimeControl(e.target.value)}
                >
                  {CATEGORY_ORDER.map((cat) => (
                    <optgroup
                      key={cat}
                      label={cat.charAt(0).toUpperCase() + cat.slice(1)}
                    >
                      {TIME_CONTROLS[cat].map((tc) => (
                        <option key={tc} value={tc}>
                          {tc}
                        </option>
                      ))}
                    </optgroup>
                  ))}
                </select>
              </div>

              <div>
                <input
                  type="datetime-local"
                  value={gameDate}
                  onChange={(e) => setGameDate(e.target.value)}
                  required
                />
              </div>

              <div>
                <label>
                  {players.find((p) => p.id === player1Id)?.nickname ?? 'Player 1'} photo
                  <input
                    type="file"
                    accept="image/*"
                    onChange={(e) => setPlayer1File(e.target.files?.[0] ?? null)}
                  />
                </label>
                <label>
                  {players.find((p) => p.id === player2Id)?.nickname ?? 'Player 2'} photo
                  <input
                    type="file"
                    accept="image/*"
                    onChange={(e) => setPlayer2File(e.target.files?.[0] ?? null)}
                  />
                </label>
              </div>

              {state?.error && <p role="alert">{state.error}</p>}

              <div>
                <button type="submit" disabled={pending}>
                  {pending ? 'Saving…' : 'Save Game'}
                </button>
                <button
                  type="button"
                  onClick={() => setOpen(false)}
                  disabled={pending}
                >
                  Cancel
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </>
  )
}
