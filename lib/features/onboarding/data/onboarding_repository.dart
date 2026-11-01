import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:raih/core/supabase/supabase_client.dart';
import 'package:raih/features/onboarding/data/onboarding_model.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return OnboardingRepository(supabaseClient: supabase);
});

class OnboardingRepository {
  final SupabaseClient _supabase;

  OnboardingRepository({
    SupabaseClient? supabaseClient,
  }) : _supabase = supabaseClient ?? Supabase.instance.client;

  // TODO: Query Supabase table atau panggil Supabase Auth/Storage
  Future<List<OnboardingItem>> getOnboardingItems() async {
    try {
      final response = await _supabase.from('onboardings').select();
      return (response as List)
          .map((item) => OnboardingItem.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
