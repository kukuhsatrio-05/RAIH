import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raih/features/auth/data/auth_model.dart';
import 'package:raih/features/auth/data/auth_repository.dart';

final facultiesList = [
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

class AuthController extends AsyncNotifier<UserEntity?> {
  @override
  Future<UserEntity?> build() async {
    final authRepo = ref.watch(authRepositoryProvider);
    return await authRepo.getCurrentUser();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.loginWithEmail(email, password);
      return await authRepo.getCurrentUser();
    });
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String faculty,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.registerWithEmail(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
        faculty: faculty,
      );
      return await authRepo.getCurrentUser();
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).logout();
      return null;
    });
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, UserEntity?>(
  AuthController.new,
);

// Deprecated providers for backward compatibility during cleanup
// These will be removed once UI is updated to use authControllerProvider

class LoginState {
  final String email;
  final String password;
  final bool isPasswordVisible;
  final bool isLoading;
  final String? errorMessage;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.errorMessage,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? isPasswordVisible,
    bool? isLoading,
    String? errorMessage,
  }) => LoginState(
    email: email ?? this.email,
    password: password ?? this.password,
    isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    isLoading: isLoading ?? this.isLoading,
    errorMessage: errorMessage,
  );

  bool get isEmailNotEmpty => email.isNotEmpty;
  bool get isPasswordNotEmpty => password.isNotEmpty;
  bool get isFormValid => isEmailNotEmpty && isPasswordNotEmpty;
}

class LoginViewModel extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  void setEmail(String val) => state = state.copyWith(email: val);
  void setPassword(String val) => state = state.copyWith(password: val);
  void togglePasswordVisibility() => state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);

  Future<void> submitLogin() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await ref.read(authControllerProvider.notifier).login(state.email, state.password);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final loginProvider = NotifierProvider<LoginViewModel, LoginState>(LoginViewModel.new);

class RegisterState {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? selectedInstitution;
  final String password;
  final String confirmPassword;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isLoading;
  final String? errorMessage;

  const RegisterState({
    this.fullName = '',
    this.email = '',
    this.phoneNumber = '',
    this.selectedInstitution,
    this.password = '',
    this.confirmPassword = '',
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.isLoading = false,
    this.errorMessage,
  });

  RegisterState copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? selectedInstitution,
    String? password,
    String? confirmPassword,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? isLoading,
    String? errorMessage,
  }) => RegisterState(
    fullName: fullName ?? this.fullName,
    email: email ?? this.email,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    selectedInstitution: selectedInstitution ?? this.selectedInstitution,
    password: password ?? this.password,
    confirmPassword: confirmPassword ?? this.confirmPassword,
    isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    isConfirmPasswordVisible: isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
    isLoading: isLoading ?? this.isLoading,
    errorMessage: errorMessage,
  );

  bool get isPasswordMatch => confirmPassword.isEmpty || password == confirmPassword;
  bool get isFormValid => fullName.isNotEmpty && email.isNotEmpty && phoneNumber.isNotEmpty && selectedInstitution != null && password.isNotEmpty && password == confirmPassword;
}

class RegisterViewModel extends Notifier<RegisterState> {
  @override
  RegisterState build() => const RegisterState();

  final List<String> faculties = facultiesList;

  void setFullName(String val) => state = state.copyWith(fullName: val);
  void setEmail(String val) => state = state.copyWith(email: val);
  void setPhoneNumber(String val) => state = state.copyWith(phoneNumber: val);
  void setInstitution(String? val) => state = state.copyWith(selectedInstitution: val);
  void setPassword(String val) => state = state.copyWith(password: val);
  void setConfirmPassword(String val) => state = state.copyWith(confirmPassword: val);
  void togglePasswordVisibility() => state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  void toggleConfirmPasswordVisibility() => state = state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible);

  Future<void> submitRegister() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await ref.read(authControllerProvider.notifier).register(
        email: state.email,
        password: state.password,
        fullName: state.fullName,
        phoneNumber: state.phoneNumber,
        faculty: state.selectedInstitution!,
      );
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final registerProvider = NotifierProvider<RegisterViewModel, RegisterState>(RegisterViewModel.new);

// Keep authStateProvider but point it to authControllerProvider for compatibility
final authStateProvider = authControllerProvider;
