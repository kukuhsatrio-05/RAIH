import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:raih/core/constants/supabase_tables.dart';
import 'package:raih/core/supabase/supabase_client.dart';
import 'package:raih/features/materi/data/materi_model.dart';

final materiRepositoryProvider = Provider<MateriRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return MateriRepository(supabaseClient: supabase);
});

class MateriRepository {
  final SupabaseClient _supabase;

  MateriRepository({
    SupabaseClient? supabaseClient,
  }) : _supabase = supabaseClient ?? Supabase.instance.client;

  // TODO: Query Supabase table atau panggil Supabase Auth/Storage
  Future<List<MateriSectionModel>> getMateriSections() async {
    try {
      final response = await _supabase
          .from(SupabaseTables.materials)
          .select();
      return (response as List)
          .map((item) => MateriSectionModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
