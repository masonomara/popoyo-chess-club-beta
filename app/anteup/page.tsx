import type { Metadata } from 'next'
import AnteupForms from './AnteupForms'
import styles from './page.module.css'

export const metadata: Metadata = {
  robots: { index: false, follow: false },
}

export default function AnteupPage() {
  return (
    <div className={styles.wrap}>
      <div className={styles.card}>
        <p className={styles.logo}>♟ Popoyo</p>
        <p className={styles.tagline}>Chess Club</p>
        <AnteupForms />
      </div>
    </div>
  )
}
