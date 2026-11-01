import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:raih/core/constants/supabase_tables.dart';
import 'package:raih/core/supabase/supabase_client.dart';
import 'package:raih/features/upload/data/upload_model.dart';

final uploadRepositoryProvider = Provider<UploadRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return UploadRepository(supabaseClient: supabase);
});

class UploadRepository {
  final SupabaseClient _supabase;

  UploadRepository({
    SupabaseClient? supabaseClient,
  }) : _supabase = supabaseClient ?? Supabase.instance.client;

  // TODO: Query Supabase table atau panggil Supabase Auth/Storage
  Future<void> uploadEvent(UploadModel model) async {
    await _supabase
        .from(SupabaseTables.events)
        .insert(model.toMap());
  }

  // TODO: Query Supabase table atau panggil Supabase Auth/Storage
  Future<String?> uploadFile(File file, String path) async {
    try {
      final response = await _supabase.storage
          .from(SupabaseBuckets.documents)
          .upload(path, file);
      return response;
    } catch (_) {
      return null;
    }
  }
}
