import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raih/features/profile/data/profile_model.dart';
import 'package:raih/features/profile/data/profile_repository.dart';

class ProfileState {
  final ProfileModel? profile;
  final bool isLoading;

  const ProfileState({
    this.profile,
    this.isLoading = false,
  });

  ProfileState copyWith({
    ProfileModel? profile,
    bool? isLoading,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ProfileNotifier extends AsyncNotifier<ProfileModel?> {
  @override
  Future<ProfileModel?> build() async {
    // TODO: Query Supabase table atau panggil Supabase Auth/Storage
    return const ProfileModel(
      id: '1',
      fullName: 'Ahmad Satrio',
      role: 'Mahasiswa',
      institution: 'Universitas Indonesia',
      savedCount: 12,
      uploadedCount: 4,
      selectedCount: 2,
    );
  }

  // TODO: Query Supabase table atau panggil Supabase Auth/Storage
  Future<void> refreshProfile(String userId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(profileRepositoryProvider);
      return await repo.getProfile(userId);
    });
  }
}

final profileControllerProvider =
    AsyncNotifierProvider<ProfileNotifier, ProfileModel?>(
  ProfileNotifier.new,
);
