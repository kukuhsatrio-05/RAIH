import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raih/ui/features/auth/providers/auth_provider.dart';

class RegisterState {
  final String? selectedFakultas;
  final bool isButtonEnabled;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isLoading;
  final String? errorMessage;
  final UserEntity? user;

  RegisterState({
    this.selectedFakultas,
    this.isButtonEnabled = false,
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.isLoading = false,
    this.errorMessage,
    this.user,
  });

  RegisterState copyWith({
    String? selectedFakultas,
    bool? isButtonEnabled,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? isLoading,
    String? errorMessage,
    UserEntity? user,
  }) {
    return RegisterState(
      selectedFakultas: selectedFakultas ?? this.selectedFakultas,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      user: user ?? this.user,
    );
  }
}

class RegisterViewModel extends AutoDisposeNotifier<RegisterState> {
  late final AuthRepository authRepository;

  final List<String> fakultasList = const [
    'Fakultas Ilmu Komputer',
    'Fakultas Hukum',
    'Fakultas Teknik',
  ];

  @override
  RegisterState build() {
    authRepository = ref.read(authRepositoryProvider);
    return RegisterState();
  }

  void setFakultas(
    String? value,
    String name,
    String email,
    String phone,
    String password,
    String confirmPassword,
  ) {
    state = state.copyWith(selectedFakultas: value);
    validate(name, email, phone, password, confirmPassword);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void toggleConfirmPasswordVisibility() {
    state =
        state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible);
  }

  bool _isEmailValid(String email) {
    return RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(email.trim());
  }

  bool _isPasswordValid(String password) {
    return password.length >= 8;
  }

  bool _isPasswordMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  void validate(
    String name,
    String email,
    String phone,
    String password,
    String confirmPassword,
  ) {
    final isValid = name.trim().isNotEmpty &&
        email.trim().isNotEmpty &&
        phone.trim().isNotEmpty &&
        state.selectedFakultas != null &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        _isEmailValid(email) &&
        _isPasswordValid(password) &&
        _isPasswordMatch(password, confirmPassword);

    state = state.copyWith(isButtonEnabled: isValid);
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await authRepository.registerWithEmail(
        email: email.trim(),
        password: password,
        fullName: name.trim(),
        phoneNumber: phone.trim(),
        faculty: state.selectedFakultas!,
      );
      state = state.copyWith(isLoading: false, user: user);
      return true;
    } catch (e) {
      final error = e.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(isLoading: false, errorMessage: error);
      return false;
    }
  }

  Future<void> registerWithGoogle() async {
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

final registerViewModelProvider =
    NotifierProvider.autoDispose<RegisterViewModel, RegisterState>(() {
  return RegisterViewModel();
});
