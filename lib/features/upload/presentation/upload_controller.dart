import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raih/features/upload/data/upload_model.dart';
import 'package:raih/features/upload/data/upload_repository.dart';

class UploadState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const UploadState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  UploadState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return UploadState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class UploadNotifier extends Notifier<UploadState> {
  @override
  UploadState build() => const UploadState();

  // TODO: Query Supabase table atau panggil Supabase Auth/Storage
  Future<void> submitUpload(UploadModel model, {File? file}) async {
    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      final repo = ref.read(uploadRepositoryProvider);
      if (file != null) {
        final path = 'uploads/${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';
        await repo.uploadFile(file, path);
      }
      await repo.uploadEvent(model);
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final uploadControllerProvider =
    NotifierProvider<UploadNotifier, UploadState>(UploadNotifier.new);
