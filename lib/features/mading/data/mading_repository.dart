import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:raih/core/constants/supabase_tables.dart';
import 'package:raih/core/supabase/supabase_client.dart';
import 'package:raih/features/mading/data/mading_model.dart';

final madingRepositoryProvider = Provider<MadingRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return MadingRepository(supabaseClient: supabase);
});

class MadingRepository {
  final SupabaseClient _supabase;

  MadingRepository({
    SupabaseClient? supabaseClient,
  }) : _supabase = supabaseClient ?? Supabase.instance.client;

  // TODO: Query Supabase table atau panggil Supabase Auth/Storage
  Future<List<MadingModel>> getMadings() async {
    try {
      final response = await _supabase
          .from(SupabaseTables.madings)
          .select();
      return (response as List)
          .map((item) => MadingModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // TODO: Query Supabase table atau panggil Supabase Auth/Storage
  Future<MadingDetailModel?> getMadingDetail(String id) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.madings)
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response != null) {
        return MadingDetailModel.fromMap(response);
      }
    } catch (_) {}
    return null;
  }
}
