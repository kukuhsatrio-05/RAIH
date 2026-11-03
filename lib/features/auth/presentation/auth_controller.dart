import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raih/features/auth/data/auth_model.dart';
import 'package:raih/features/auth/data/auth_repository.dart';

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

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.loginWithEmail(state.email, state.password);
      print('✅ Login Success - User authenticated');
      state = state.copyWith(isLoading: false);
      // Success - state updated, router will redirect via listener
    } catch (e) {
      final errorMsg = e.toString();
      print('❌ Login Error: $errorMsg');
      state = state.copyWith(
        isLoading: false,
        errorMessage: errorMsg,
      );
    }
  }
}

final loginProvider = NotifierProvider<LoginViewModel, LoginModels>(
  LoginViewModel.new,
);

class RegisterViewModel extends Notifier<RegisterModels> {
  @override
  RegisterModels build() => const RegisterModels();

final List<String> faculties = [
    'Fakultas Ilmu Komputer (FILKOM)',
    'Fakultas Teknik (FT)',
    'Fakultas Ekonomi dan Bisnis (FEB)',
    'Fakultas Hukum (FH)',
    'Fakultas Ilmu Administrasi (FIA)',
    'Fakultas Pertanian (FP)',
    'Fakultas Peternakan (FAPET)',
    'Fakultas Kedokteran (FK)',
    'Fakultas Perikanan dan Ilmu Kelautan (FPIK)',
    'Fakultas Matematika dan Ilmu Pengetahuan Alam (FMIPA)',
    'Fakultas Teknologi Pertanian (FTP)',
    'Fakultas Ilmu Sosial dan Ilmu Politik (FISIP)',
    'Fakultas Ilmu Budaya (FIB)',
    'Fakultas Kedokteran Gigi (FKG)',
    'Fakultas Kedokteran Hewan (FKH)',
    'Program Vokasi',
    'Lainnya',
  ];
  void setFullName(String value) => state = state.copyWith(fullName: value);
  void setEmail(String value) => state = state.copyWith(email: value);
  void setPhoneNumber(String value) =>
      state = state.copyWith(phoneNumber: value);
  void setInstitution(String? value) =>
      state = state.copyWith(selectedInstitution: value);
  void setPassword(String value) => state = state.copyWith(password: value);
  void setConfirmPassword(String value) =>
      state = state.copyWith(confirmPassword: value);

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
      isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
    );
  }

  Future<void> submitRegister() async {
    if (!state.isFormValid) return;

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.registerWithEmail(
        email: state.email,
        password: state.password,
        fullName: state.fullName,
        phoneNumber: state.phoneNumber,
        faculty: state.selectedInstitution ?? '',
      );
      state = state.copyWith(isLoading: false);
      // Redirect via router setelah sukses (handle di UI/listener)
    } catch (e) {
      final errorMsg = e.toString();
      print('❌ Register Error: $errorMsg');
      state = state.copyWith(
        isLoading: false,
        errorMessage: errorMsg,
      );
    }
  }
}

final registerProvider = NotifierProvider<RegisterViewModel, RegisterModels>(
  RegisterViewModel.new,
);

// Global Auth State Notifier
class AuthStateNotifier extends AsyncNotifier<UserEntity?> {
  @override
  Future<UserEntity?> build() async {
    // TODO: Query Supabase table atau panggil Supabase Auth/Storage
    final authRepo = ref.watch(authRepositoryProvider);
    return await authRepo.getCurrentUser();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(authRepositoryProvider).getCurrentUser();
    });
  }
}

final authStateProvider = AsyncNotifierProvider<AuthStateNotifier, UserEntity?>(
  AuthStateNotifier.new,
);
