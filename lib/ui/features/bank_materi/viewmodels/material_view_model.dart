import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raih/ui/features/bank_materi/models/document_model.dart';
import 'package:raih/ui/features/bank_materi/data/mock_document_data.dart';

// 1. State untuk menampung data
class BankMateriState {
  final String selectedCategory;
  final List<DocumentModel> documents;

  BankMateriState({required this.selectedCategory, required this.documents});

  BankMateriState copyWith({
    String? selectedCategory,
    List<DocumentModel>? documents,
  }) {
    return BankMateriState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      documents: documents ?? this.documents,
    );
  }
}

class MaterialViewModel extends Notifier<BankMateriState> {
  @override
  BankMateriState build() {
    // Konversi DocumentDetailModel → DocumentModel untuk tampilan list
    final docs = MockDocumentData.documents
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

    return BankMateriState(selectedCategory: 'Semua', documents: docs);
  }

  // Daftar kategori statis
  final List<String> categories = [
    'Semua',
    'Proposal',
    'Pitch deck',
    'Beasiswa',
    'Lainnya',
  ];

  // Getter untuk data yang sudah difilter
  List<DocumentModel> get filteredDocuments {
    if (state.selectedCategory == 'Semua') {
      return state.documents;
    }
    return state.documents
        .where((doc) => doc.category == state.selectedCategory)
        .toList();
  }

  // Fungsi untuk mengubah kategori
  void selectCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }
}

// Daftarkan Riverpod State Pod
final materialViewModelPod =
    NotifierProvider<MaterialViewModel, BankMateriState>(() {
      return MaterialViewModel();
    });
