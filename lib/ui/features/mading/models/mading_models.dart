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
}
