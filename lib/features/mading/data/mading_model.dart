class MadingModel {
  final String id;
  final String title;
  final String organizer;
  final String location;
  final String category; // 'Lomba' atau 'Beasiswa'
  final String subCategory; // Misal: 'UI/UX Design', 'Full Scholarship', dll.
  final String imageUrl;
  final String deadline;
  final String reward;
  final String startDate;
  final String description;
  final String teamSize;

  const MadingModel({
    required this.id,
    required this.title,
    required this.organizer,
    required this.location,
    required this.category,
    required this.subCategory,
    required this.imageUrl,
    required this.deadline,
    this.reward = '',
    this.startDate = '',
    this.description = '',
    this.teamSize = '',
  });

  factory MadingModel.fromMap(Map<String, dynamic> map) {
    return MadingModel(
      id: map['id']?.toString() ?? '',
      title: map['title'] as String? ?? '',
      organizer: map['organizer'] as String? ?? '',
      location: map['location'] as String? ?? '',
      category: map['category'] as String? ?? 'Lomba',
      subCategory: map['sub_category'] as String? ?? '',
      imageUrl: map['image_url'] as String? ?? '',
      deadline: map['deadline'] as String? ?? '',
      reward: map['reward'] as String? ?? '',
      startDate: map['start_date'] as String? ?? '',
      description: map['description'] as String? ?? '',
      teamSize: map['team_size'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'organizer': organizer,
      'location': location,
      'category': category,
      'sub_category': subCategory,
      'image_url': imageUrl,
      'deadline': deadline,
      'reward': reward,
      'start_date': startDate,
      'description': description,
      'team_size': teamSize,
    };
  }
}

class MadingDetailModel {
  final String id;
  final String categoryTag; // e.g. "Lomba", "Webinar"
  final String title;
  final String organizer;
  final String location;
  final String benefit;
  final String openDate;
  final String endDate;
  final String description;
  final String teamSize;
  final String? imageUrl;

  MadingDetailModel({
    required this.id,
    required this.categoryTag,
    required this.title,
    required this.organizer,
    required this.location,
    required this.benefit,
    required this.openDate,
    required this.endDate,
    required this.description,
    required this.teamSize,
    this.imageUrl,
  });

  factory MadingDetailModel.fromMap(Map<String, dynamic> map) {
    return MadingDetailModel(
      id: map['id']?.toString() ?? '',
      categoryTag: map['category_tag'] as String? ?? 'Lomba',
      title: map['title'] as String? ?? '',
      organizer: map['organizer'] as String? ?? '',
      location: map['location'] as String? ?? '',
      benefit: map['benefit'] as String? ?? '',
      openDate: map['open_date'] as String? ?? '',
      endDate: map['end_date'] as String? ?? '',
      description: map['description'] as String? ?? '',
      teamSize: map['team_size'] as String? ?? '',
      imageUrl: map['image_url'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_tag': categoryTag,
      'title': title,
      'organizer': organizer,
      'location': location,
      'benefit': benefit,
      'open_date': openDate,
      'end_date': endDate,
      'description': description,
      'team_size': teamSize,
      'image_url': imageUrl,
    };
  }
}
