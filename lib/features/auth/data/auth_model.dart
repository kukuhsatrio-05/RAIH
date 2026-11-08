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
