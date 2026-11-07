import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raih/features/profile/data/profile_model.dart';
import 'package:raih/features/profile/data/profile_repository.dart';

// Profile state
class ProfileState {
  final ProfileModel? profile;
  final bool isLoading;
  final String? error;

  const ProfileState({this.profile, this.isLoading = false, this.error});

  ProfileState copyWith({
    ProfileModel? profile,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

  // Helper getters
  bool get isProfileCompleted => profile?.isProfileCompleted ?? false;
  bool get hasProfile => profile != null;
}

// Profile controller
class ProfileController extends StateNotifier<ProfileState> {
  final ProfileRepository _repository;

  ProfileController(this._repository) : super(const ProfileState());

  // Fetch own profile
  Future<void> fetchOwnProfile() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final profile = await _repository.getOwnProfile();

      if (profile != null) {
        state = state.copyWith(
          profile: profile,
          isLoading: false,
          clearError: true,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Mark profile as completed
  Future<void> completeProfile() async {
    try {
      await _repository.setProfileCompleted(true);

      if (state.profile != null) {
        state = state.copyWith(
          profile: state.profile!.copyWith(
            isProfileCompleted: true,
            updatedAt: DateTime.now(),
          ),
        );
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // Update profile (+ skills)
  Future<void> updateProfile(
    ProfileModel profile, {
    List<String>? skills,
  }) async {
    try {
      await _repository.updateProfile(profile, skills: skills);
      state = state.copyWith(
        profile: profile.copyWith(
          skills: skills ?? profile.skills,
          updatedAt: DateTime.now(),
        ),
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider
final profileProvider = StateNotifierProvider<ProfileController, ProfileState>((
  ref,
) {
  final repository = ref.watch(profileRepositoryProvider);
  return ProfileController(repository);
});
