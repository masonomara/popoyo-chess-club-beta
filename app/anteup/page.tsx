import type { Metadata } from 'next'
import AnteupForms from './AnteupForms'

export const metadata: Metadata = {
  robots: { index: false, follow: false },
}

export default function AnteupPage() {
  return (
    <main>
      <h1>Popoyo Chess Club</h1>
      <AnteupForms />
    </main>
  )
}
