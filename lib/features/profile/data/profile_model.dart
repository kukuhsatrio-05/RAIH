class ProfileModel {
  final String id;
  final String fullName;
  final String role;
  final String institution;
  final int savedCount;
  final int uploadedCount;
  final int selectedCount;
  final String? avatarUrl;

  const ProfileModel({
    required this.id,
    required this.fullName,
    this.role = '',
    this.institution = '',
    this.savedCount = 0,
    this.uploadedCount = 0,
    this.selectedCount = 0,
    this.avatarUrl,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id']?.toString() ?? '',
      fullName: map['full_name'] as String? ?? '',
      role: map['role'] as String? ?? '',
      institution: map['institution'] as String? ?? '',
      savedCount: (map['saved_count'] as num?)?.toInt() ?? 0,
      uploadedCount: (map['uploaded_count'] as num?)?.toInt() ?? 0,
      selectedCount: (map['selected_count'] as num?)?.toInt() ?? 0,
      avatarUrl: map['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'role': role,
      'institution': institution,
      'saved_count': savedCount,
      'uploaded_count': uploadedCount,
      'selected_count': selectedCount,
      'avatar_url': avatarUrl,
    };
  }
}
