import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:raih/core/constants/supabase_tables.dart';
import 'package:raih/core/supabase/supabase_client.dart';
import 'package:raih/features/home/data/home_model.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return HomeRepository(supabaseClient: supabase);
});

class HomeRepository {
  final SupabaseClient _supabase;

  HomeRepository({
    SupabaseClient? supabaseClient,
  }) : _supabase = supabaseClient ?? Supabase.instance.client;

  // TODO: Query Supabase table atau panggil Supabase Auth/Storage
  Future<List<EventModel>> getEvents() async {
    try {
      final response = await _supabase
          .from(SupabaseTables.events)
          .select();
      return (response as List)
          .map((item) => EventModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // TODO: Query Supabase table atau panggil Supabase Auth/Storage
  Future<EventModel?> getEventById(String id) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.events)
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response != null) {
        return EventModel.fromMap(response);
      }
    } catch (_) {}
    return null;
  }
}
