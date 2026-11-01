import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:raih/core/constants/supabase_tables.dart';
import 'package:raih/core/supabase/supabase_client.dart';
import 'package:raih/features/auth/data/auth_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return AuthRepository(supabaseClient: supabase);
});

class AuthRepository {
  final SupabaseClient _supabase;

  AuthRepository({
    SupabaseClient? supabaseClient,
  }) : _supabase = supabaseClient ?? Supabase.instance.client;

  // TODO: Query Supabase table atau panggil Supabase Auth/Storage
  Future<UserEntity> loginWithEmail(String email, String password) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw Exception('Login gagal: user tidak ditemukan');
    }

    final profileData = await _fetchProfile(user.id);

    return UserModel.fromSupabase(
      authUser: {'id': user.id, 'email': user.email},
      profileData: profileData,
    );
  }

  // TODO: Query Supabase table atau panggil Supabase Auth/Storage
  Future<UserEntity> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String faculty,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw Exception('Registrasi gagal: user tidak ditemukan');
    }

    await _supabase.from(SupabaseTables.profiles).upsert({
      'id': user.id,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'faculty': faculty,
      'is_profile_completed': true,
    });

    return UserModel(
      id: user.id,
      email: user.email ?? '',
      fullName: fullName,
      phoneNumber: phoneNumber,
      faculty: faculty,
      isProfileCompleted: true,
    );
  }

  // TODO: Query Supabase table atau panggil Supabase Auth/Storage
  Future<UserEntity> signInWithGoogle() async {
    await GoogleSignIn.instance.initialize(
      serverClientId:
          '442127038266-khc6pa6dcjdr1vnsv298aguc1qjtcsr8.apps.googleusercontent.com',
    );

    final googleUser = await GoogleSignIn.instance.authenticate();
    final idToken = googleUser.authentication.idToken;

    if (idToken == null) {
      throw Exception('Gagal mendapatkan ID Token dari Google');
    }

    final response = await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
    );

    final user = response.user;
    if (user == null) {
      throw Exception('Google Sign-In gagal: user tidak ditemukan');
    }

    final profileData = await _fetchProfile(user.id);

    return UserModel.fromSupabase(
      authUser: {'id': user.id, 'email': user.email},
      profileData: profileData,
    );
  }

  // TODO: Query Supabase table atau panggil Supabase Auth/Storage
  Future<void> logout() async {
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
    await _supabase.auth.signOut();
  }

  // TODO: Query Supabase table atau panggil Supabase Auth/Storage
  Future<UserEntity?> getCurrentUser() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    final profileData = await _fetchProfile(user.id);

    return UserModel.fromSupabase(
      authUser: {'id': user.id, 'email': user.email},
      profileData: profileData,
    );
  }

  Future<Map<String, dynamic>?> _fetchProfile(String userId) async {
    try {
      return await _supabase
          .from(SupabaseTables.profiles)
          .select()
          .eq('id', userId)
          .maybeSingle();
    } catch (_) {
      return null;
    }
  }
}
