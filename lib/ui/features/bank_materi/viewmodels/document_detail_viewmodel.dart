import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/document_detail_model.dart';
import '../data/mock_document_data.dart';

class DocumentDetailState {
  final DocumentDetailModel? document;
  final bool isDescriptionExpanded;
  final int userRating;

  DocumentDetailState({
    this.document,
    this.isDescriptionExpanded = false,
    this.userRating = 0,
  });

  DocumentDetailState copyWith({
    DocumentDetailModel? document,
    bool? isDescriptionExpanded,
    int? userRating,
  }) {
    return DocumentDetailState(
      document: document ?? this.document,
      isDescriptionExpanded:
          isDescriptionExpanded ?? this.isDescriptionExpanded,
      userRating: userRating ?? this.userRating,
    );
  }
}

// ViewModel menerima documentId dari provider family
class DocumentDetailViewModel
    extends FamilyNotifier<DocumentDetailState, String> {
  @override
  DocumentDetailState build(String documentId) {
    // Load langsung dari centralized mock data berdasarkan ID
    final doc = MockDocumentData.findById(documentId);
    return DocumentDetailState(document: doc);
  }

  void toggleDescription() {
    state = state.copyWith(isDescriptionExpanded: !state.isDescriptionExpanded);
  }

  void setUserRating(int rating) {
    state = state.copyWith(userRating: rating);
  }
}

// NotifierProviderFamily agar setiap documentId punya instance state sendiri
final documentDetailViewModelPod =
    NotifierProviderFamily<DocumentDetailViewModel, DocumentDetailState, String>(
      DocumentDetailViewModel.new,
    );
