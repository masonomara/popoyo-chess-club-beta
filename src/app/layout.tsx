import type { Metadata } from 'next'
import { DM_Sans } from 'next/font/google'
import Link from 'next/link'
import styles from "./layout.module.css"
import './globals.css'
import HeaderActions from '@/components/HeaderActions'

const dmSans = DM_Sans({ variable: '--font-sans', subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Popoyo Chess Club',
  description: 'Chess ratings, game history, and leaderboards.',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en" className={dmSans.variable}>
      <body>
        <header className={styles.header}>
          <div className={styles.headerInner}>
            <Link href="/" className={styles.logo}>
              Popoyo Chess Club
            </Link>
            <HeaderActions />
          </div>
        </header>
        <main className={styles.main}>{children}</main>
      </body>
    </html>
  )
}
