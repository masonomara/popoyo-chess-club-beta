import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import AdminPanel from '@/app/components/AdminPanel'
import type { Tables } from '@/app/types/database'

type ApprovedEmailWithProfile = Tables<'approved_emails'> & {
  profiles: Tables<'profiles'> | null
}

export default async function AdminPage() {
  const supabase = await createClient()

  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) redirect('/')

  const { data: profile } = await supabase
    .from('profiles')
    .select('role')
    .eq('id', user.id)
    .single()

  if (profile?.role !== 'admin') redirect('/')

  const { data: emails } = await supabase
    .from('approved_emails')
    .select('*, profiles(*)')
    .order('created_at', { ascending: false })

  return (
    <main>
      <h1>Approved Emails</h1>
      <AdminPanel emails={(emails ?? []) as ApprovedEmailWithProfile[]} />
    </main>
  )
}
