class DocumentDetailModel {
  final String id;
  final String title;
  final String fileType;
  final String authorName;
  final String authorInitials;
  final String authorRole;
  final String category;
  final int downloadCount;
  final double fileSizeMB;
  final String uploadDate;
  final int totalPages;
  final double rating;
  final String description;

  DocumentDetailModel({
    required this.id,
    required this.title,
    required this.fileType,
    required this.authorName,
    required this.authorInitials,
    required this.authorRole,
    required this.category,
    required this.downloadCount,
    required this.fileSizeMB,
    required this.uploadDate,
    required this.totalPages,
    required this.rating,
    required this.description,
  });
}
