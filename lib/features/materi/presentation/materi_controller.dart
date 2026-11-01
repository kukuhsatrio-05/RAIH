import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raih/features/materi/data/materi_model.dart';
import 'package:raih/features/materi/data/materi_repository.dart';

class MateriState {
  final List<MateriSectionModel> sections;
  final bool isLoading;

  const MateriState({
    this.sections = const [],
    this.isLoading = false,
  });

  MateriState copyWith({
    List<MateriSectionModel>? sections,
    bool? isLoading,
  }) {
    return MateriState(
      sections: sections ?? this.sections,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MateriNotifier extends Notifier<MateriState> {
  @override
  MateriState build() {
    // TODO: Query Supabase table atau panggil Supabase Auth/Storage
    Future.microtask(() => loadMateri());
    return const MateriState();
  }

  Future<void> loadMateri() async {
    state = state.copyWith(isLoading: true);
    final repo = ref.read(materiRepositoryProvider);
    final list = await repo.getMateriSections();
    state = state.copyWith(sections: list, isLoading: false);
  }
}

final materiControllerProvider =
    NotifierProvider<MateriNotifier, MateriState>(MateriNotifier.new);
