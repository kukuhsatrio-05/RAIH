import 'dart:typed_data';

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

  ProfileRepository({SupabaseClient? supabaseClient})
    : _supabase = supabaseClient ?? Supabase.instance.client;

  // Get own profile (current logged-in user)
  Future<ProfileModel?> getOwnProfile() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return null;

      final response = await _supabase
          .from(SupabaseTables.profiles)
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      final skills = await getSkills(userId);

      return ProfileModel.fromMap(response).copyWith(skills: skills);
    } catch (e) {
      rethrow;
    }
  }

  // Get skills of a user
  Future<List<String>> getSkills(String userId) async {
    final rows = await _supabase
        .from(SupabaseTables.userSkills)
        .select('name')
        .eq('profile_id', userId)
        .order('created_at');

    return List<String>.from(
      (rows as List).map((row) => row['name'] as String),
    );
  }

  // Replace all skills of a user
  Future<void> setSkills(String userId, List<String> skills) async {
    await _supabase
        .from(SupabaseTables.userSkills)
        .delete()
        .eq('profile_id', userId);

    if (skills.isEmpty) return;

    await _supabase
        .from(SupabaseTables.userSkills)
        .insert(
          skills.map((skill) => {'profile_id': userId, 'name': skill}).toList(),
        );
  }

  // Get profile by ID
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
    } catch (e) {
      print('❌ Error fetching profile: $e');
    }
    return null;
  }

  // Update profile (+ skills)
  Future<void> updateProfile(
    ProfileModel profile, {
    List<String>? skills,
  }) async {
    try {
      await _supabase
          .from(SupabaseTables.profiles)
          .update(profile.toUpdateMap())
          .eq('id', profile.id);

      if (skills != null) {
        await setSkills(profile.id, skills);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadCv(
    String userId,
    Uint8List bytes,
    String originalName,
  ) async {
    final extension = originalName.split('.').last.toLowerCase();
    if (extension != 'pdf') {
      throw ArgumentError('CV harus berupa file PDF.');
    }

    final path = '$userId/cv_${DateTime.now().millisecondsSinceEpoch}.pdf';
    await _supabase.storage
        .from(SupabaseBuckets.cvDocuments)
        .uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(contentType: 'application/pdf'),
        );
    return _supabase.storage
        .from(SupabaseBuckets.cvDocuments)
        .getPublicUrl(path);
  }

  // Mark profile as completed
  Future<void> setProfileCompleted(bool completed) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      await _supabase
          .from(SupabaseTables.profiles)
          .update({'is_profile_completed': completed})
          .eq('id', userId);
    } catch (e) {
      rethrow;
    }
  }
}
