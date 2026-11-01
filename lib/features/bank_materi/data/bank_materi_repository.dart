import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:raih/core/constants/supabase_tables.dart';
import 'package:raih/core/supabase/supabase_client.dart';
import 'package:raih/features/bank_materi/data/bank_materi_model.dart';
import 'package:raih/features/bank_materi/data/mock_document_data.dart';

final bankMateriRepositoryProvider = Provider<BankMateriRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return BankMateriRepository(supabaseClient: supabase);
});

class BankMateriRepository {
  final SupabaseClient _supabase;

  BankMateriRepository({
    SupabaseClient? supabaseClient,
  }) : _supabase = supabaseClient ?? Supabase.instance.client;

  // TODO: Query Supabase table atau panggil Supabase Auth/Storage
  Future<List<DocumentModel>> getDocuments() async {
    try {
      final response = await _supabase
          .from(SupabaseTables.documents)
          .select();
      return (response as List)
          .map((item) => DocumentModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // Fallback ke mock data
      return MockDocumentData.documents
          .map(
            (detail) => DocumentModel(
              id: detail.id,
              title: detail.title,
              fileType: detail.fileType,
              authorName: detail.authorName,
              authorInitials: detail.authorInitials,
              category: detail.category,
              downloadCount: detail.downloadCount,
              fileSizeMB: detail.fileSizeMB,
            ),
          )
          .toList();
    }
  }

  // TODO: Query Supabase table atau panggil Supabase Auth/Storage
  Future<DocumentDetailModel?> getDocumentDetail(String id) async {
    try {
      final response = await _supabase
          .from(SupabaseTables.documents)
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response != null) {
        return DocumentDetailModel.fromMap(response);
      }
    } catch (_) {}

    return MockDocumentData.findById(id);
  }

  // TODO: Query Supabase table atau panggil Supabase Auth/Storage
  Future<String?> getDownloadUrl(String path) async {
    try {
      return _supabase.storage.from(SupabaseBuckets.documents).getPublicUrl(path);
    } catch (_) {
      return null;
    }
  }
}
