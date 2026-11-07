class ExperienceModel {
  final String id;
  final String profileId;
  final String title;
  final String organization;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrent;
  final String? description;

  const ExperienceModel({
    required this.id,
    required this.profileId,
    required this.title,
    required this.organization,
    required this.startDate,
    this.endDate,
    this.isCurrent = false,
    this.description,
  });

  factory ExperienceModel.fromMap(Map<String, dynamic> map) {
    return ExperienceModel(
      id: map['id']?.toString() ?? '',
      profileId: map['profile_id']?.toString() ?? '',
      title: map['title'] as String? ?? '',
      organization: map['organization'] as String? ?? '',
      startDate: DateTime.parse(map['start_date'] as String),
      endDate: map['end_date'] != null ? DateTime.parse(map['end_date'] as String) : null,
      isCurrent: map['is_current'] as bool? ?? false,
      description: map['description'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'profile_id': profileId,
      'title': title,
      'organization': organization,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_current': isCurrent,
      'description': description,
    };
  }
}
