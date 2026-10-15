class RegisterModels {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? selectedInstitution;
  final String password;
  final String confirmPassword;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isLoading;

  const RegisterModels({
    this.fullName = '',
    this.email = '',
    this.phoneNumber = '',
    this.selectedInstitution,
    this.password = '',
    this.confirmPassword = '',
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.isLoading = false,
  });

  // Validasi: Mengecek apakah konfirmasi kata sandi cocok
  bool get isPasswordMatch =>
      confirmPassword.isEmpty || password == confirmPassword;

  // Form dianggap valid jika seluruh kolom terisi dan kata sandi cocok
  bool get isFormValid =>
      fullName.trim().isNotEmpty &&
      email.trim().isNotEmpty &&
      phoneNumber.trim().isNotEmpty &&
      selectedInstitution != null &&
      password.isNotEmpty &&
      confirmPassword.isNotEmpty &&
      password == confirmPassword;

  RegisterModels copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? selectedInstitution,
    String? password,
    String? confirmPassword,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? isLoading,
  }) {
    return RegisterModels(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      selectedInstitution: selectedInstitution ?? this.selectedInstitution,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
