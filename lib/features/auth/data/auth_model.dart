class UserEntity {
  final String id;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String faculty;
  final bool isProfileCompleted;

  const UserEntity({
    required this.id,
    required this.email,
    this.fullName = '',
    this.phoneNumber = '',
    this.faculty = '',
    this.isProfileCompleted = false,
  });
}

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.fullName,
    super.phoneNumber,
    super.faculty,
    super.isProfileCompleted,
  });

  factory UserModel.fromSupabase({
    required Map<String, dynamic> authUser,
    Map<String, dynamic>? profileData,
  }) {
    return UserModel(
      id: authUser['id'] as String,
      email: authUser['email'] as String? ?? '',
      fullName: profileData?['full_name'] as String? ?? '',
      phoneNumber: profileData?['phone_number'] as String? ?? '',
      faculty: profileData?['faculty'] as String? ?? '',
      isProfileCompleted:
          profileData?['is_profile_completed'] as bool? ?? false,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String? ?? '',
      email: map['email'] as String? ?? '',
      fullName: map['full_name'] as String? ?? '',
      phoneNumber: map['phone_number'] as String? ?? '',
      faculty: map['faculty'] as String? ?? '',
      isProfileCompleted: map['is_profile_completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'faculty': faculty,
      'is_profile_completed': isProfileCompleted,
    };
  }
}

class LoginModels {
  final String email;
  final String password;
  final bool isPasswordVisible;
  final bool isLoading;
  final String? errorMessage;

  const LoginModels({
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isEmailNotEmpty => email.trim().isNotEmpty;
  bool get isPasswordNotEmpty => password.isNotEmpty;

  bool get isFormValid => isEmailNotEmpty && isPasswordNotEmpty;

  LoginModels copyWith({
    String? email,
    String? password,
    bool? isPasswordVisible,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LoginModels(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  factory LoginModels.fromMap(Map<String, dynamic> map) {
    return LoginModels(
      email: map['email'] as String? ?? '',
      password: map['password'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }
}

typedef LoginModel = LoginModels;

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
  final String? errorMessage;

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
    this.errorMessage,
  });

  bool get isPasswordMatch =>
      confirmPassword.isEmpty || password == confirmPassword;

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
    String? errorMessage,
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
      errorMessage: errorMessage,
    );
  }

  factory RegisterModels.fromMap(Map<String, dynamic> map) {
    return RegisterModels(
      fullName: map['full_name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phoneNumber: map['phone_number'] as String? ?? '',
      selectedInstitution: map['institution'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'institution': selectedInstitution,
    };
  }
}

typedef RegisterModel = RegisterModels;
