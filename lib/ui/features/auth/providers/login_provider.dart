import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raih/ui/features/auth/providers/auth_provider.dart';

class LoginState {
  final bool isButtonEnabled;
  final bool isPasswordVisible;
  final bool isLoading;
  final String? errorMessage;
  final UserEntity? user;

  LoginState({
    this.isButtonEnabled = false,
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.errorMessage,
    this.user,
  });

  LoginState copyWith({
    bool? isButtonEnabled,
    bool? isPasswordVisible,
    bool? isLoading,
    String? errorMessage,
    UserEntity? user,
  }) {
    return LoginState(
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      user: user ?? this.user,
    );
  }
}

class LoginViewModel extends AutoDisposeNotifier<LoginState> {
  late final AuthRepository authRepository;

  @override
  LoginState build() {
    authRepository = ref.read(authRepositoryProvider);
    return LoginState();
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void validate(String email, String password) {
    final isValid = email.isNotEmpty && password.isNotEmpty;
    state = state.copyWith(isButtonEnabled: isValid);
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await authRepository.loginWithEmail(email.trim(), password);
      state = state.copyWith(isLoading: false, user: user);
      return true;
    } catch (e) {
      final error = e.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(isLoading: false, errorMessage: error);
      return false;
    }
  }

  Future<void> loginWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await authRepository.signInWithGoogle();
      state = state.copyWith(isLoading: false, user: user);
    } catch (e) {
      final error = e.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(isLoading: false, errorMessage: error);
    }
  }
}

final loginViewModelProvider =
    NotifierProvider.autoDispose<LoginViewModel, LoginState>(() {
  return LoginViewModel();
});
