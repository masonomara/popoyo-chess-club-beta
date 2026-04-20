'use server'

import { revalidatePath } from 'next/cache'
import { createClient } from '@/lib/supabase/server'
import { z } from 'zod'

export type AdminState = { error: string } | null

const AddEmailSchema = z.object({
  email: z.string().email(),
})

function getString(fd: FormData, key: string): string {
  const v = fd.get(key)
  return typeof v === 'string' ? v : ''
}

async function getAdminUser() {
  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()
  if (!user) return { supabase, user: null, isAdmin: false }

  const { data: profile } = await supabase
    .from('profiles')
    .select('role')
    .eq('id', user.id)
    .single()

  return { supabase, user, isAdmin: profile?.role === 'admin' }
}

export async function addApprovedEmail(
  _prevState: AdminState,
  formData: FormData
): Promise<AdminState> {
  const { supabase, user, isAdmin } = await getAdminUser()
  if (!user) return { error: 'Not authenticated.' }
  if (!isAdmin) return { error: 'Not authorized.' }

  const parsed = AddEmailSchema.safeParse({
    email: getString(formData, 'email'),
  })

  if (!parsed.success) {
    return { error: parsed.error.issues[0]?.message ?? 'Invalid email.' }
  }

  const { error } = await supabase.from('approved_emails').insert({
    email: parsed.data.email,
    added_by: user.id,
  })

  if (error) return { error: error.message }

  revalidatePath('/admin')
  return null
}

export async function removeApprovedEmail(
  _prevState: AdminState,
  formData: FormData
): Promise<AdminState> {
  const { supabase, user, isAdmin } = await getAdminUser()
  if (!user) return { error: 'Not authenticated.' }
  if (!isAdmin) return { error: 'Not authorized.' }

  const id = getString(formData, 'id')
  if (!id) return { error: 'Missing id.' }

  const { error } = await supabase.from('approved_emails').delete().eq('id', id)

  if (error) return { error: error.message }

  revalidatePath('/admin')
  return null
}
