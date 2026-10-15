import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raih/ui/features/auth/models/register_models.dart';

class RegisterViewModel extends Notifier<RegisterModels> {
  @override
  RegisterModels build() => const RegisterModels();

  // Daftar instansi (bisa disesuaikan dari API/Database)
  final List<String> institutions = [
    'Universitas Brawijaya',
    'Universitas Indonesia',
    'Institut Teknologi Bandung',
    'Universitas Gadjah Mada',
    'Lainnya / Perusahaan',
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

    state = state.copyWith(isLoading: true);
    // TODO: Hubungkan ke Repository / UseCase Auth Supabase di sini
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(isLoading: false);
  }
}

final registerProvider = NotifierProvider<RegisterViewModel, RegisterModels>(
  RegisterViewModel.new,
);
