class LoginModels {
  final String email;
  final String password;
  final bool isPasswordVisible;
  final bool isLoading;

  const LoginModels({
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.isLoading = false,
  });

  bool get isEmailNotEmpty => email.trim().isNotEmpty;
  bool get isPasswordNotEmpty => password.isNotEmpty;

  // Tombol 'Masuk' aktif jika kedua kolom sudah diisi
  bool get isFormValid => isEmailNotEmpty && isPasswordNotEmpty;

  LoginModels copyWith({
    String? email,
    String? password,
    bool? isPasswordVisible,
    bool? isLoading,
  }) {
    return LoginModels(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
