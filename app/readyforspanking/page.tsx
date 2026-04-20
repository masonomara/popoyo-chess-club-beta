import type { Metadata } from "next";
import ReadyForSpankingForms from "./ReadyForSpankingForms";
import styles from "./page.module.css";

export const metadata: Metadata = {
  robots: { index: false, follow: false },
};

export default function ReadyForSpankingPage() {
  return (
    <div className={styles.wrap}>
      <div className={styles.card}>
        <p className={styles.logo}>♟ Popoyo</p>
        <p className={styles.tagline}>Chess Club</p>
        <ReadyForSpankingForms />
      </div>
    </div>
  );
}
