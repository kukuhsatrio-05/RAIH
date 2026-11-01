import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConstants {
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  
  /// Kunci publik Supabase (Publishable Key / Anon Key)
  static String get supabasePublishableKey =>
      dotenv.env['SUPABASE_ANON_KEY'] ??
      dotenv.env['SUPABASE_KEY'] ??
      dotenv.env['SUPABASE_PUBLISHABLE_KEY'] ??
      '';

  /// Alias untuk kompatibilitas nama lama
  static String get supabaseAnonKey => supabasePublishableKey;
}
