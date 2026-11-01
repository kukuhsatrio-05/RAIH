class UploadModel {
  final String? id;
  final String title;
  final String category;
  final String subCategory;
  final String organizer;
  final String location;
  final DateTime deadline;
  final String? description;
  final String? registrationUrl;
  final String? filePath;

  const UploadModel({
    this.id,
    required this.title,
    required this.category,
    required this.subCategory,
    required this.organizer,
    required this.location,
    required this.deadline,
    this.description,
    this.registrationUrl,
    this.filePath,
  });

  factory UploadModel.fromMap(Map<String, dynamic> map) {
    return UploadModel(
      id: map['id']?.toString(),
      title: map['title'] as String? ?? '',
      category: map['category'] as String? ?? 'Lomba',
      subCategory: map['sub_category'] as String? ?? '',
      organizer: map['organizer'] as String? ?? '',
      location: map['location'] as String? ?? '',
      deadline: map['deadline'] != null
          ? DateTime.tryParse(map['deadline'].toString()) ?? DateTime.now()
          : DateTime.now(),
      description: map['description'] as String?,
      registrationUrl: map['registration_url'] as String?,
      filePath: map['file_path'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'category': category,
      'sub_category': subCategory,
      'organizer': organizer,
      'location': location,
      'deadline': deadline.toIso8601String(),
      'description': description,
      'registration_url': registrationUrl,
      'file_path': filePath,
    };
  }
}
