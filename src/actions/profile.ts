'use server'

import { revalidatePath } from 'next/cache'
import { createClient } from '@/lib/supabase/server'
import { z } from 'zod'

export type ProfileState = { error: string } | { success: string } | null

const UpdateProfileSchema = z.object({
  nickname: z.string().min(1).max(50),
  country: z.string().min(1).max(4),
})

const UpdateEmailSchema = z.object({
  email: z.string().email(),
})

const UpdatePasswordSchema = z.object({
  password: z.string().min(6),
})

function getString(fd: FormData, key: string): string {
  const v = fd.get(key)
  return typeof v === 'string' ? v : ''
}

async function getAuthUser() {
  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()
  return { supabase, user }
}

export async function updateProfile(
  _prevState: ProfileState,
  formData: FormData
): Promise<ProfileState> {
  const { supabase, user } = await getAuthUser()
  if (!user) return { error: 'Not authenticated.' }

  const parsed = UpdateProfileSchema.safeParse({
    nickname: getString(formData, 'nickname'),
    country: getString(formData, 'country'),
  })

  if (!parsed.success) {
    return { error: parsed.error.issues[0]?.message ?? 'Invalid input.' }
  }

  const { error } = await supabase
    .from('profiles')
    .update({ nickname: parsed.data.nickname, country: parsed.data.country })
    .eq('id', user.id)

  if (error) return { error: error.message }

  revalidatePath('/profile')
  return { success: 'Profile updated.' }
}

export async function updateEmail(
  _prevState: ProfileState,
  formData: FormData
): Promise<ProfileState> {
  const { supabase, user } = await getAuthUser()
  if (!user) return { error: 'Not authenticated.' }

  const parsed = UpdateEmailSchema.safeParse({
    email: getString(formData, 'email'),
  })

  if (!parsed.success) {
    return { error: parsed.error.issues[0]?.message ?? 'Invalid email.' }
  }

  const { error: authError } = await supabase.auth.updateUser({
    email: parsed.data.email,
  })

  if (authError) return { error: authError.message }

  await supabase
    .from('profiles')
    .update({ email: parsed.data.email })
    .eq('id', user.id)

  revalidatePath('/profile')
  return { success: 'Confirmation sent to new email address.' }
}

export async function updatePassword(
  _prevState: ProfileState,
  formData: FormData
): Promise<ProfileState> {
  const { supabase, user } = await getAuthUser()
  if (!user) return { error: 'Not authenticated.' }

  const parsed = UpdatePasswordSchema.safeParse({
    password: getString(formData, 'password'),
  })

  if (!parsed.success) {
    return { error: parsed.error.issues[0]?.message ?? 'Invalid password.' }
  }

  const { error } = await supabase.auth.updateUser({
    password: parsed.data.password,
  })

  if (error) return { error: error.message }

  return { success: 'Password updated.' }
}
