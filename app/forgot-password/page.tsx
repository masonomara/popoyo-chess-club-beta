import ForgotPasswordForm from '@/app/components/ForgotPasswordForm'

export default async function ForgotPasswordPage({
  searchParams,
}: {
  searchParams: Promise<{ error?: string }>
}) {
  const { error } = await searchParams
  const invalidLink = error === 'invalid_link'

  return (
    <main>
      <h1>Reset Password</h1>
      <ForgotPasswordForm invalidLink={invalidLink} />
    </main>
  )
}
