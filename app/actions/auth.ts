'use server'

import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'

export type AuthState = { error: string } | null

export async function signIn(
  _prevState: AuthState,
  formData: FormData
): Promise<AuthState> {
  const supabase = await createClient()

  const email = formData.get('email') as string
  const password = formData.get('password') as string

  const { error } = await supabase.auth.signInWithPassword({ email, password })

  if (error) return { error: error.message }

  redirect('/')
}

export async function signUp(
  _prevState: AuthState,
  formData: FormData
): Promise<AuthState> {
  const supabase = await createClient()

  const email = formData.get('email') as string
  const password = formData.get('password') as string
  const nickname = formData.get('nickname') as string
  const country = formData.get('country') as string

  const { data: approved, error: approvalError } = await supabase.rpc(
    'is_email_approved',
    { p_email: email }
  )

  if (approvalError || !approved) {
    return { error: 'This email is not on the approved list.' }
  }

  const { error } = await supabase.auth.signUp({
    email,
    password,
    options: {
      data: { nickname, country },
    },
  })

  if (error) return { error: error.message }

  redirect('/')
}
