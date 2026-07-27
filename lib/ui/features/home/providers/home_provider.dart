import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raih/ui/features/auth/providers/auth_provider.dart';

class HomeState {
  final UserEntity? user;
  final bool isLoading;

  HomeState({this.user, this.isLoading = false});

  HomeState copyWith({UserEntity? user, bool? isLoading}) {
    return HomeState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class HomeViewModel extends AutoDisposeNotifier<HomeState> {
  late final AuthRepository authRepository;

  @override
  HomeState build() {
    authRepository = ref.read(authRepositoryProvider);
    return HomeState();
  }

  Future<void> loadUser() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await authRepository.getCurrentUser();
      state = state.copyWith(isLoading: false, user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await authRepository.logout();
      state = state.copyWith(isLoading: false, user: null);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final homeViewModelProvider =
    NotifierProvider.autoDispose<HomeViewModel, HomeState>(() {
      return HomeViewModel();
    });
