import { createClient } from '@supabase/supabase-js'

const SUPABASE_URL = 'https://qyxyaovgsqflmkvgkxru.supabase.co'
const SUPABASE_SERVICE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF5eHlhb3Znc3FmbG1rdmdreHJ1Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3NjYyODk2NCwiZXhwIjoyMDkyMjA0OTY0fQ.cIcAsd8WzITDvhSc_DivTAqGZYGtLyBnFb_IbpSuaIY'

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY)

const AUSTIN  = 'be9cd8ba-33b1-4a2b-9eb0-4b2ed7f46e54'
const GERY    = 'bc0c3ae8-e75c-4199-bfe2-52f686dfca13'
const MASON   = '7dd665f5-c37d-4625-93d5-41882c377ec0'
const TOBROB  = '41d449f6-c801-45c4-b394-3b53c989e194'
const SUB     = MASON

const W = 'white'
const B = 'black'
const WIN = 'player1_win'
const DRAW = 'draw'

// All games ordered chronologically, parsed from unstructed-games.md
// player1 = winner (or first-named for draws)
// player1_color = winner's color
const games = [
  // 4/12 - 2 games
  { p1: GERY,   p2: TOBROB, c: W, r: WIN,  d: '2026-04-12 09:00:00+00' }, // Gerry(white) beats Top-Rob
  { p1: GERY,   p2: TOBROB, c: B, r: WIN,  d: '2026-04-12 09:30:00+00' }, // Gerry(black) beats Top-Rob

  // 4/13 - 7 games
  { p1: TOBROB, p2: GERY,   c: B, r: WIN,  d: '2026-04-13 09:00:00+00' }, // Top-Rob(black) beats Gerry
  { p1: MASON,  p2: TOBROB, c: W, r: WIN,  d: '2026-04-13 09:30:00+00' }, // Mason(white) beats Top-Rob
  { p1: GERY,   p2: MASON,  c: W, r: WIN,  d: '2026-04-13 10:00:00+00' }, // Gerry(white) beats Mason
  { p1: GERY,   p2: MASON,  c: B, r: WIN,  d: '2026-04-13 10:30:00+00' }, // Gerry(black) beats Mason
  { p1: MASON,  p2: AUSTIN, c: W, r: WIN,  d: '2026-04-13 11:00:00+00' }, // Mason(white) beats Austin
  { p1: AUSTIN, p2: GERY,   c: B, r: WIN,  d: '2026-04-13 11:30:00+00' }, // Austin(black) beats Gerry
  { p1: GERY,   p2: AUSTIN, c: B, r: WIN,  d: '2026-04-13 12:00:00+00' }, // Gerry(black) beats Austin

  // 4/14 - 12 games
  { p1: MASON,  p2: GERY,   c: B, r: WIN,  d: '2026-04-14 09:00:00+00' }, // Mason(black) beats Gerry
  { p1: GERY,   p2: MASON,  c: W, r: WIN,  d: '2026-04-14 09:30:00+00' }, // Gerry(white) beats Mason
  { p1: TOBROB, p2: MASON,  c: W, r: WIN,  d: '2026-04-14 10:00:00+00' }, // Top-Rob(white) beats Mason
  { p1: TOBROB, p2: MASON,  c: B, r: WIN,  d: '2026-04-14 10:30:00+00' }, // Top-Rob(black) beats Mason
  { p1: TOBROB, p2: MASON,  c: W, r: WIN,  d: '2026-04-14 11:00:00+00' }, // Top-Rob(white) beats Mason
  { p1: TOBROB, p2: AUSTIN, c: W, r: WIN,  d: '2026-04-14 11:30:00+00' }, // Top-Rob(white) beats Austin
  { p1: GERY,   p2: AUSTIN, c: W, r: DRAW, d: '2026-04-14 12:00:00+00' }, // Gerry/Austin draw
  { p1: TOBROB, p2: GERY,   c: B, r: WIN,  d: '2026-04-14 12:30:00+00' }, // Top-Rob(black) beats Gerry
  { p1: GERY,   p2: TOBROB, c: W, r: DRAW, d: '2026-04-14 13:00:00+00' }, // Gerry/Top-Rob draw
  { p1: MASON,  p2: TOBROB, c: W, r: WIN,  d: '2026-04-14 13:30:00+00' }, // Mason(white) beats Top-Rob
  { p1: GERY,   p2: MASON,  c: B, r: WIN,  d: '2026-04-14 14:00:00+00' }, // Gerry(black) beats Mason
  { p1: TOBROB, p2: AUSTIN, c: B, r: WIN,  d: '2026-04-14 14:30:00+00' }, // Top-Rob(black) beats Austin

  // 4/15 - 13 games
  { p1: MASON,  p2: GERY,   c: W, r: WIN,  d: '2026-04-15 09:00:00+00' }, // Mason(white) beats Gerry
  { p1: GERY,   p2: MASON,  c: W, r: WIN,  d: '2026-04-15 09:30:00+00' }, // Gerry(white) beats Mason
  { p1: GERY,   p2: MASON,  c: B, r: WIN,  d: '2026-04-15 10:00:00+00' }, // Gerry(black) beats Mason
  { p1: GERY,   p2: MASON,  c: W, r: WIN,  d: '2026-04-15 10:30:00+00' }, // Gerry(white) beats Mason
  { p1: GERY,   p2: AUSTIN, c: W, r: WIN,  d: '2026-04-15 11:00:00+00' }, // Gerry(white) beats Austin
  { p1: TOBROB, p2: MASON,  c: B, r: WIN,  d: '2026-04-15 11:30:00+00' }, // Top-Rob(black) beats Mason
  { p1: TOBROB, p2: AUSTIN, c: B, r: WIN,  d: '2026-04-15 12:00:00+00' }, // Top-Rob(black) beats Austin
  { p1: TOBROB, p2: MASON,  c: W, r: WIN,  d: '2026-04-15 12:30:00+00' }, // Top-Rob(white) beats Mason
  { p1: TOBROB, p2: MASON,  c: W, r: WIN,  d: '2026-04-15 13:00:00+00' }, // Top-Rob(white) beats Mason
  { p1: TOBROB, p2: AUSTIN, c: B, r: WIN,  d: '2026-04-15 13:30:00+00' }, // Top-Rob(black) beats Austin
  { p1: TOBROB, p2: MASON,  c: B, r: WIN,  d: '2026-04-15 14:00:00+00' }, // Top-Rob(black) beats Mason
  { p1: TOBROB, p2: MASON,  c: W, r: WIN,  d: '2026-04-15 14:30:00+00' }, // Top-Rob(white) beats Mason
  { p1: TOBROB, p2: MASON,  c: B, r: WIN,  d: '2026-04-15 15:00:00+00' }, // Top-Rob(black) beats Mason

  // 4/16 - 7 games
  { p1: GERY,   p2: TOBROB, c: W, r: WIN,  d: '2026-04-16 09:00:00+00' }, // Gerry(white) beats Top-Rob
  { p1: MASON,  p2: TOBROB, c: W, r: WIN,  d: '2026-04-16 09:30:00+00' }, // Mason(white) beats Top-Rob
  { p1: TOBROB, p2: MASON,  c: W, r: WIN,  d: '2026-04-16 10:00:00+00' }, // Top-Rob(white) beats Mason
  { p1: MASON,  p2: AUSTIN, c: B, r: WIN,  d: '2026-04-16 10:30:00+00' }, // Mason(black) beats Austin
  { p1: GERY,   p2: MASON,  c: W, r: WIN,  d: '2026-04-16 11:00:00+00' }, // Gerry(white) beats Mason
  { p1: TOBROB, p2: GERY,   c: W, r: WIN,  d: '2026-04-16 11:30:00+00' }, // Top-Rob(white) beats Gerry
  { p1: GERY,   p2: MASON,  c: B, r: WIN,  d: '2026-04-16 12:00:00+00' }, // Gerry(black) beats Mason

  // 4/17 - 11 games
  { p1: MASON,  p2: GERY,   c: W, r: WIN,  d: '2026-04-17 09:00:00+00' }, // Mason(white) beats Gerry
  { p1: MASON,  p2: AUSTIN, c: W, r: WIN,  d: '2026-04-17 09:30:00+00' }, // Mason(white) beats Austin
  { p1: MASON,  p2: GERY,   c: B, r: WIN,  d: '2026-04-17 10:00:00+00' }, // Mason(black) beats Gerry
  { p1: MASON,  p2: TOBROB, c: W, r: WIN,  d: '2026-04-17 10:30:00+00' }, // Mason(white) beats Top-Rob
  { p1: TOBROB, p2: MASON,  c: W, r: WIN,  d: '2026-04-17 11:00:00+00' }, // Top-Rob(white) beats Mason
  { p1: TOBROB, p2: GERY,   c: W, r: WIN,  d: '2026-04-17 11:30:00+00' }, // Top-Rob(white) beats Gerry
  { p1: TOBROB, p2: GERY,   c: B, r: WIN,  d: '2026-04-17 12:00:00+00' }, // Top-Rob(black) beats Gerry
  { p1: GERY,   p2: TOBROB, c: W, r: WIN,  d: '2026-04-17 12:30:00+00' }, // Gerry(white) beats Top-Rob
  { p1: MASON,  p2: AUSTIN, c: W, r: WIN,  d: '2026-04-17 13:00:00+00' }, // Mason(white) beats Austin
  { p1: AUSTIN, p2: MASON,  c: W, r: WIN,  d: '2026-04-17 13:30:00+00' }, // Austin(white) beats Mason
  { p1: TOBROB, p2: AUSTIN, c: W, r: WIN,  d: '2026-04-17 14:00:00+00' }, // Top-Rob(white) beats Austin

  // 4/18 - 5 games
  { p1: GERY,   p2: MASON,  c: W, r: DRAW, d: '2026-04-18 09:00:00+00' }, // Gerry/Mason draw
  { p1: MASON,  p2: GERY,   c: W, r: WIN,  d: '2026-04-18 09:30:00+00' }, // Mason(white) beats Gerry
  { p1: TOBROB, p2: MASON,  c: W, r: WIN,  d: '2026-04-18 10:00:00+00' }, // Top-Rob(white) beats Mason
  { p1: TOBROB, p2: MASON,  c: B, r: WIN,  d: '2026-04-18 10:30:00+00' }, // Top-Rob(black) beats Mason
  { p1: TOBROB, p2: MASON,  c: B, r: WIN,  d: '2026-04-18 11:00:00+00' }, // Top-Rob(black) beats Mason

  // 4/20 - 5 games (times from chat, EDT = UTC-4)
  { p1: GERY,   p2: MASON,  c: B, r: WIN,  d: '2026-04-20 13:09:45+00' }, // 9:09 AM EDT
  { p1: TOBROB, p2: MASON,  c: B, r: WIN,  d: '2026-04-20 13:23:18+00' }, // 9:23 AM EDT
  { p1: TOBROB, p2: MASON,  c: W, r: WIN,  d: '2026-04-20 13:35:50+00' }, // 9:35 AM EDT
  { p1: TOBROB, p2: GERY,   c: B, r: WIN,  d: '2026-04-20 17:15:24+00' }, // 1:15 PM EDT
  { p1: TOBROB, p2: GERY,   c: B, r: WIN,  d: '2026-04-20 17:48:40+00' }, // 1:48 PM EDT

  // 4/21 - 4 games (times from chat, EDT = UTC-4)
  { p1: TOBROB, p2: MASON,  c: B, r: WIN,  d: '2026-04-21 15:07:57+00' }, // 11:07 AM EDT
  { p1: TOBROB, p2: MASON,  c: W, r: WIN,  d: '2026-04-21 16:23:18+00' }, // 12:23 PM EDT
  { p1: TOBROB, p2: MASON,  c: B, r: WIN,  d: '2026-04-21 16:51:49+00' }, // 12:51 PM EDT
  { p1: TOBROB, p2: MASON,  c: W, r: WIN,  d: '2026-04-21 17:03:47+00' }, // 1:03 PM EDT

  // 4/22 - 12 games (times from chat, EDT = UTC-4)
  { p1: TOBROB, p2: MASON,  c: W, r: WIN,  d: '2026-04-22 12:56:45+00' }, // 8:56 AM EDT
  { p1: GERY,   p2: TOBROB, c: W, r: WIN,  d: '2026-04-22 13:34:54+00' }, // 9:34 AM EDT
  { p1: TOBROB, p2: GERY,   c: W, r: WIN,  d: '2026-04-22 14:52:40+00' }, // 10:52:40 AM EDT
  { p1: TOBROB, p2: MASON,  c: W, r: WIN,  d: '2026-04-22 14:52:49+00' }, // 10:52:49 AM EDT
  { p1: TOBROB, p2: MASON,  c: B, r: WIN,  d: '2026-04-22 15:01:49+00' }, // 11:01 AM EDT
  { p1: GERY,   p2: TOBROB, c: W, r: WIN,  d: '2026-04-22 15:22:00+00' }, // 11:22 AM EDT
  { p1: TOBROB, p2: GERY,   c: W, r: WIN,  d: '2026-04-22 15:42:34+00' }, // 11:42 AM EDT
  { p1: TOBROB, p2: GERY,   c: W, r: WIN,  d: '2026-04-22 20:07:37+00' }, // 4:07 PM EDT
  { p1: TOBROB, p2: GERY,   c: B, r: WIN,  d: '2026-04-22 20:27:02+00' }, // 4:27 PM EDT
  { p1: GERY,   p2: TOBROB, c: B, r: WIN,  d: '2026-04-22 20:58:19+00' }, // 4:58 PM EDT
  { p1: GERY,   p2: MASON,  c: B, r: WIN,  d: '2026-04-22 21:30:16+00' }, // 5:30:16 PM EDT
  { p1: GERY,   p2: MASON,  c: W, r: WIN,  d: '2026-04-22 21:30:23+00' }, // 5:30:23 PM EDT

  // 4/23 - 4 games (times from chat, EDT = UTC-4)
  { p1: TOBROB, p2: MASON,  c: W, r: WIN,  d: '2026-04-23 16:03:22+00' }, // 12:03 PM EDT
  { p1: TOBROB, p2: MASON,  c: B, r: WIN,  d: '2026-04-23 16:21:18+00' }, // 12:21 PM EDT
  { p1: TOBROB, p2: MASON,  c: W, r: WIN,  d: '2026-04-23 16:40:16+00' }, // 12:40 PM EDT
  { p1: AUSTIN, p2: MASON,  c: B, r: WIN,  d: '2026-04-23 20:17:19+00' }, // 4:17 PM EDT - "Rob A" = Austin
]

const rows = games.map(g => ({
  player1_id: g.p1,
  player2_id: g.p2,
  player1_color: g.c,
  result: g.r,
  game_date: g.d,
  time_control: '10+0',
  time_control_category: 'rapid',
  submitted_by: SUB,
}))

console.log(`Prepared ${rows.length} games to insert`)

const { error: delError } = await supabase.from('games').delete().neq('id', '00000000-0000-0000-0000-000000000000')
if (delError) {
  console.error('Delete failed:', delError)
  process.exit(1)
}
console.log('Deleted all existing games')

const { error: insError } = await supabase.from('games').insert(rows)
if (insError) {
  console.error('Insert failed:', insError)
  process.exit(1)
}
console.log(`Inserted ${rows.length} games successfully`)
