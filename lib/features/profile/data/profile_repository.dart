import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:raih/core/constants/supabase_tables.dart';
import 'package:raih/core/supabase/supabase_client.dart';
import 'package:raih/features/profile/data/profile_model.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return ProfileRepository(supabaseClient: supabase);
});

class ProfileRepository {
  final SupabaseClient _supabase;

  ProfileRepository({
    SupabaseClient? supabaseClient,
  }) : _supabase = supabaseClient ?? Supabase.instance.client;

  // TODO: Query Supabase table atau panggil Supabase Auth/Storage
  Future<ProfileModel?> getProfile(String userId) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.profiles)
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response != null) {
        return ProfileModel.fromMap(response);
      }
    } catch (_) {}
    return null;
  }

  // TODO: Query Supabase table atau panggil Supabase Auth/Storage
  Future<void> updateProfile(ProfileModel profile) async {
    await _supabase
        .from(SupabaseTables.profiles)
        .upsert(profile.toMap());
  }
}
