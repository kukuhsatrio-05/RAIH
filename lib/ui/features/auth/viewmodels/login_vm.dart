import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raih/ui/features/auth/models/login_models.dart';

class LoginViewModel extends Notifier<LoginModels> {
  @override
  LoginModels build() => const LoginModels();

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  Future<void> submitLogin() async {
    if (!state.isFormValid) return;

    state = state.copyWith(isLoading: true);
    // TODO: Panggil UseCase / Repository API autentikasi di sini
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(isLoading: false);
  }
}

final loginProvider = NotifierProvider<LoginViewModel, LoginModels>(
  LoginViewModel.new,
);
