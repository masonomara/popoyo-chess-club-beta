export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.5"
  }
  public: {
    Tables: {
      approved_emails: {
        Row: {
          added_by: string
          created_at: string
          email: string
          id: string
        }
        Insert: {
          added_by: string
          created_at?: string
          email: string
          id?: string
        }
        Update: {
          added_by?: string
          created_at?: string
          email?: string
          id?: string
        }
        Relationships: [
          {
            foreignKeyName: "approved_emails_added_by_fkey"
            columns: ["added_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      comments: {
        Row: {
          body: string
          created_at: string
          game_id: string
          id: string
          user_id: string
        }
        Insert: {
          body: string
          created_at?: string
          game_id: string
          id?: string
          user_id: string
        }
        Update: {
          body?: string
          created_at?: string
          game_id?: string
          id?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "comments_game_id_fkey"
            columns: ["game_id"]
            isOneToOne: false
            referencedRelation: "games"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "comments_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      games: {
        Row: {
          created_at: string
          game_date: string
          id: string
          player1_color: Database["public"]["Enums"]["piece_color"]
          player1_id: string
          player1_photo_url: string | null
          player2_id: string
          player2_photo_url: string | null
          result: Database["public"]["Enums"]["game_result"]
          submitted_by: string
          time_control: string
          time_control_category: Database["public"]["Enums"]["time_control_category"]
        }
        Insert: {
          created_at?: string
          game_date: string
          id?: string
          player1_color: Database["public"]["Enums"]["piece_color"]
          player1_id: string
          player1_photo_url?: string | null
          player2_id: string
          player2_photo_url?: string | null
          result: Database["public"]["Enums"]["game_result"]
          submitted_by: string
          time_control: string
          time_control_category: Database["public"]["Enums"]["time_control_category"]
        }
        Update: {
          created_at?: string
          game_date?: string
          id?: string
          player1_color?: Database["public"]["Enums"]["piece_color"]
          player1_id?: string
          player1_photo_url?: string | null
          player2_id?: string
          player2_photo_url?: string | null
          result?: Database["public"]["Enums"]["game_result"]
          submitted_by?: string
          time_control?: string
          time_control_category?: Database["public"]["Enums"]["time_control_category"]
        }
        Relationships: [
          {
            foreignKeyName: "games_player1_id_fkey"
            columns: ["player1_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "games_player2_id_fkey"
            columns: ["player2_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "games_submitted_by_fkey"
            columns: ["submitted_by"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      monthly_winners: {
        Row: {
          created_at: string
          draws: number
          games_played: number
          id: string
          losses: number
          month_start: string
          peak_elo: number
          player_id: string
          victory_photo_url: string | null
          wins: number
        }
        Insert: {
          created_at?: string
          draws?: number
          games_played?: number
          id?: string
          losses?: number
          month_start: string
          peak_elo: number
          player_id: string
          victory_photo_url?: string | null
          wins?: number
        }
        Update: {
          created_at?: string
          draws?: number
          games_played?: number
          id?: string
          losses?: number
          month_start?: string
          peak_elo?: number
          player_id?: string
          victory_photo_url?: string | null
          wins?: number
        }
        Relationships: [
          {
            foreignKeyName: "monthly_winners_player_id_fkey"
            columns: ["player_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      player_ratings: {
        Row: {
          alltime_draws: number
          alltime_elo: number
          alltime_games_played: number
          alltime_losses: number
          alltime_wins: number
          created_at: string
          monthly_draws: number
          monthly_elo: number
          monthly_games_played: number
          monthly_losses: number
          monthly_wins: number
          player_id: string
          updated_at: string
          weekly_draws: number
          weekly_elo: number
          weekly_games_played: number
          weekly_losses: number
          weekly_wins: number
        }
        Insert: {
          alltime_draws?: number
          alltime_elo?: number
          alltime_games_played?: number
          alltime_losses?: number
          alltime_wins?: number
          created_at?: string
          monthly_draws?: number
          monthly_elo?: number
          monthly_games_played?: number
          monthly_losses?: number
          monthly_wins?: number
          player_id: string
          updated_at?: string
          weekly_draws?: number
          weekly_elo?: number
          weekly_games_played?: number
          weekly_losses?: number
          weekly_wins?: number
        }
        Update: {
          alltime_draws?: number
          alltime_elo?: number
          alltime_games_played?: number
          alltime_losses?: number
          alltime_wins?: number
          created_at?: string
          monthly_draws?: number
          monthly_elo?: number
          monthly_games_played?: number
          monthly_losses?: number
          monthly_wins?: number
          player_id?: string
          updated_at?: string
          weekly_draws?: number
          weekly_elo?: number
          weekly_games_played?: number
          weekly_losses?: number
          weekly_wins?: number
        }
        Relationships: [
          {
            foreignKeyName: "player_ratings_player_id_fkey"
            columns: ["player_id"]
            isOneToOne: true
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      profiles: {
        Row: {
          country: string
          created_at: string
          email: string
          id: string
          nickname: string
          role: Database["public"]["Enums"]["user_role"]
        }
        Insert: {
          country: string
          created_at?: string
          email: string
          id: string
          nickname: string
          role?: Database["public"]["Enums"]["user_role"]
        }
        Update: {
          country?: string
          created_at?: string
          email?: string
          id?: string
          nickname?: string
          role?: Database["public"]["Enums"]["user_role"]
        }
        Relationships: []
      }
      weekly_winners: {
        Row: {
          created_at: string
          draws: number
          games_played: number
          id: string
          losses: number
          peak_elo: number
          player_id: string
          victory_photo_url: string | null
          week_start: string
          wins: number
        }
        Insert: {
          created_at?: string
          draws?: number
          games_played?: number
          id?: string
          losses?: number
          peak_elo: number
          player_id: string
          victory_photo_url?: string | null
          week_start: string
          wins?: number
        }
        Update: {
          created_at?: string
          draws?: number
          games_played?: number
          id?: string
          losses?: number
          peak_elo?: number
          player_id?: string
          victory_photo_url?: string | null
          week_start?: string
          wins?: number
        }
        Relationships: [
          {
            foreignKeyName: "weekly_winners_player_id_fkey"
            columns: ["player_id"]
            isOneToOne: false
            referencedRelation: "profiles"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      delete_game: { Args: { p_game_id: string }; Returns: undefined }
      get_user_role: {
        Args: never
        Returns: Database["public"]["Enums"]["user_role"]
      }
      is_email_approved: { Args: { p_email: string }; Returns: boolean }
      recalculate_alltime_elo: { Args: never; Returns: undefined }
      recalculate_monthly_elo: { Args: never; Returns: undefined }
      recalculate_weekly_elo: { Args: never; Returns: undefined }
      record_monthly_winner: {
        Args: { p_month_start: string }
        Returns: undefined
      }
      record_weekly_winner: {
        Args: { p_week_start: string }
        Returns: undefined
      }
      reset_monthly_elo: { Args: never; Returns: undefined }
      reset_weekly_elo: { Args: never; Returns: undefined }
      submit_game: {
        Args: {
          p_game_date: string
          p_player1_color: Database["public"]["Enums"]["piece_color"]
          p_player1_id: string
          p_player1_photo_url?: string
          p_player2_id: string
          p_player2_photo_url?: string
          p_result: Database["public"]["Enums"]["game_result"]
          p_submitted_by: string
          p_time_control: string
          p_time_control_category: Database["public"]["Enums"]["time_control_category"]
        }
        Returns: string
      }
      update_game: {
        Args: {
          p_game_date: string
          p_game_id: string
          p_player1_color: Database["public"]["Enums"]["piece_color"]
          p_player1_id: string
          p_player1_photo_url?: string
          p_player2_id: string
          p_player2_photo_url?: string
          p_result: Database["public"]["Enums"]["game_result"]
          p_time_control: string
          p_time_control_category: Database["public"]["Enums"]["time_control_category"]
        }
        Returns: undefined
      }
    }
    Enums: {
      game_result: "player1_win" | "player2_win" | "draw"
      piece_color: "white" | "black"
      time_control_category: "bullet" | "blitz" | "rapid" | "classical"
      user_role: "admin" | "member" | "viewer"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      game_result: ["player1_win", "player2_win", "draw"],
      piece_color: ["white", "black"],
      time_control_category: ["bullet", "blitz", "rapid", "classical"],
      user_role: ["admin", "member", "viewer"],
    },
  },
} as const
