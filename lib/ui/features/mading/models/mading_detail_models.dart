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
}
