class ProfileModel {
  final String id;
  final String fullName;
  final String? email;
  final String? role;
  final String? faculty;
  final String? major;
  final String? location;
  final String? whatsapp;
  final String? linkedinUrl;
  final String? instagramHandle;
  final String? headline;
  final String? bio;
  final String? cvUrl;
  final bool isProfileCompleted;
  final bool isOpenToJoin;
  final bool isMentor;
  final int savedCount;
  final int uploadedCount;
  final int selectedCount;
  final String? avatarUrl;
  final DateTime? updatedAt;
  final List<String> skills;

  const ProfileModel({
    required this.id,
    required this.fullName,
    this.email,
    this.role = '',
    this.faculty = '',
    this.major,
    this.location,
    this.whatsapp,
    this.linkedinUrl,
    this.instagramHandle,
    this.headline,
    this.bio,
    this.cvUrl,
    this.isProfileCompleted = false,
    this.isOpenToJoin = false,
    this.isMentor = false,
    this.savedCount = 0,
    this.uploadedCount = 0,
    this.selectedCount = 0,
    this.avatarUrl,
    this.updatedAt,
    this.skills = const [],
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id']?.toString() ?? '',
      fullName: map['full_name'] as String? ?? '',
      email: map['email'] as String?,
      role: map['role'] as String?,
      faculty: map['faculty'] as String? ?? map['institution'] as String?,
      major: map['major'] as String?,
      location: map['location'] as String?,
      whatsapp: map['whatsapp'] as String? ?? map['phone_number'] as String?,
      linkedinUrl: map['linkedin_url'] as String?,
      instagramHandle: map['instagram_handle'] as String?,
      headline: map['headline'] as String?,
      bio: map['bio'] as String?,
      cvUrl: map['cv_url'] as String?,
      isProfileCompleted: (map['is_profile_completed'] as bool?) ?? false,
      isOpenToJoin: (map['is_open_to_join'] as bool?) ?? false,
      isMentor: (map['is_mentor'] as bool?) ?? false,
      savedCount: (map['saved_count'] as num?)?.toInt() ?? 0,
      uploadedCount: (map['uploaded_count'] as num?)?.toInt() ?? 0,
      selectedCount: (map['selected_count'] as num?)?.toInt() ?? 0,
      avatarUrl: map['avatar_url'] as String?,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'].toString())
          : null,
      skills: (map['skills'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  ProfileModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? role,
    String? faculty,
    String? major,
    String? location,
    String? whatsapp,
    String? linkedinUrl,
    String? instagramHandle,
    String? headline,
    String? bio,
    String? cvUrl,
    bool? isProfileCompleted,
    bool? isOpenToJoin,
    bool? isMentor,
    int? savedCount,
    int? uploadedCount,
    int? selectedCount,
    String? avatarUrl,
    DateTime? updatedAt,
    List<String>? skills,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      faculty: faculty ?? this.faculty,
      major: major ?? this.major,
      location: location ?? this.location,
      whatsapp: whatsapp ?? this.whatsapp,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      instagramHandle: instagramHandle ?? this.instagramHandle,
      headline: headline ?? this.headline,
      bio: bio ?? this.bio,
      cvUrl: cvUrl ?? this.cvUrl,
      isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
      isOpenToJoin: isOpenToJoin ?? this.isOpenToJoin,
      isMentor: isMentor ?? this.isMentor,
      savedCount: savedCount ?? this.savedCount,
      uploadedCount: uploadedCount ?? this.uploadedCount,
      selectedCount: selectedCount ?? this.selectedCount,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      updatedAt: updatedAt ?? this.updatedAt,
      skills: skills ?? this.skills,
    );
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'full_name': fullName,
      'faculty': faculty,
      'major': major,
      'location': location,
      'whatsapp': whatsapp,
      'linkedin_url': linkedinUrl,
      'instagram_handle': instagramHandle,
      'headline': headline,
      'bio': bio,
      'cv_url': cvUrl,
      'is_profile_completed': isProfileCompleted,
      'is_open_to_join': isOpenToJoin,
      'is_mentor': isMentor,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  bool get isComplete => isProfileCompleted;
}
