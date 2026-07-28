class DocumentModel {
  final String id;
  final String title;
  final String fileType; // 'PDF', 'DOC', 'PPT'
  final String authorName;
  final String authorInitials;
  final String category;
  final int downloadCount;
  final double fileSizeMB;

  DocumentModel({
    required this.id,
    required this.title,
    required this.fileType,
    required this.authorName,
    required this.authorInitials,
    required this.category,
    required this.downloadCount,
    required this.fileSizeMB,
  });
}
