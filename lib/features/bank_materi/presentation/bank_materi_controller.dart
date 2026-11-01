import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raih/features/bank_materi/data/bank_materi_model.dart';
import 'package:raih/features/bank_materi/data/bank_materi_repository.dart';

// State untuk menampung data dokumen
class BankMateriState {
  final String selectedCategory;
  final List<DocumentModel> documents;
  final bool isLoading;

  BankMateriState({
    required this.selectedCategory,
    required this.documents,
    this.isLoading = false,
  });

  BankMateriState copyWith({
    String? selectedCategory,
    List<DocumentModel>? documents,
    bool? isLoading,
  }) {
    return BankMateriState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      documents: documents ?? this.documents,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MaterialViewModel extends Notifier<BankMateriState> {
  @override
  BankMateriState build() {
    // Inisialisasi awal dokumen
    Future.microtask(() => loadDocuments());
    return BankMateriState(selectedCategory: 'Semua', documents: []);
  }

  // TODO: Query Supabase table atau panggil Supabase Auth/Storage
  Future<void> loadDocuments() async {
    state = state.copyWith(isLoading: true);
    final repo = ref.read(bankMateriRepositoryProvider);
    final docs = await repo.getDocuments();
    state = state.copyWith(documents: docs, isLoading: false);
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

class DocumentDetailState {
  final DocumentDetailModel? document;
  final bool isDescriptionExpanded;
  final int userRating;
  final bool isLoading;

  DocumentDetailState({
    this.document,
    this.isDescriptionExpanded = false,
    this.userRating = 0,
    this.isLoading = false,
  });

  DocumentDetailState copyWith({
    DocumentDetailModel? document,
    bool? isDescriptionExpanded,
    int? userRating,
    bool? isLoading,
  }) {
    return DocumentDetailState(
      document: document ?? this.document,
      isDescriptionExpanded:
          isDescriptionExpanded ?? this.isDescriptionExpanded,
      userRating: userRating ?? this.userRating,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// ViewModel menerima documentId dari provider family
class DocumentDetailViewModel
    extends FamilyNotifier<DocumentDetailState, String> {
  @override
  DocumentDetailState build(String documentId) {
    // TODO: Query Supabase table atau panggil Supabase Auth/Storage
    Future.microtask(() => loadDetail(documentId));
    return DocumentDetailState(isLoading: true);
  }

  Future<void> loadDetail(String documentId) async {
    final repo = ref.read(bankMateriRepositoryProvider);
    final doc = await repo.getDocumentDetail(documentId);
    state = state.copyWith(document: doc, isLoading: false);
  }

  void toggleDescription() {
    state = state.copyWith(isDescriptionExpanded: !state.isDescriptionExpanded);
  }

  void setUserRating(int rating) {
    state = state.copyWith(userRating: rating);
  }
}

final documentDetailViewModelPod =
    NotifierProviderFamily<DocumentDetailViewModel, DocumentDetailState, String>(
  DocumentDetailViewModel.new,
);
